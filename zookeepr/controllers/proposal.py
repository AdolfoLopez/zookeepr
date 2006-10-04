from formencode import validators, compound, schema, variabledecode, Invalid

from zookeepr.lib.auth import SecureController, AuthFunc, AuthTrue, AuthFalse, AuthRole
from zookeepr.lib.base import *
from zookeepr.lib.crud import Modify, View
from zookeepr.lib.validators import BaseSchema, PersonValidator, ProposalTypeValidator, FileUploadValidator, StreamValidator, ReviewSchema
from zookeepr.model import Proposal, ProposalType, Stream, Review, Attachment

class ProposalSchema(schema.Schema):
    title = validators.String()
    abstract = validators.String()
    experience = validators.String()
    url = validators.String()
    type = ProposalTypeValidator()

class NewProposalSchema(BaseSchema):
    ignore_key_missing = True
    proposal = ProposalSchema()
    attachment = FileUploadValidator()
    pre_validators = [variabledecode.NestedVariables]

class EditProposalSchema(BaseSchema):
    proposal = ProposalSchema()
    pre_validators = [variabledecode.NestedVariables]


class NotYetReviewedValidator(validators.FancyValidator):
    """Make sure the reviewer hasn't yet reviewed this proposal"""

    messages = {
        "already": "You've already reviewed this proposal, try editing the existing review."
        }
    
    def validate_python(self, value, state):
        review = Query(Review).get_by(reviewer_id=c.signed_in_person.id, proposal_id=c.proposal.id)
        if review is not None:
            raise Invalid(self.message('already', None),
                          value, state)
        

class NewReviewSchema(BaseSchema):
    review = ReviewSchema()
    pre_validators = [variabledecode.NestedVariables]
    chained_validators = [NotYetReviewedValidator()]

class NewAttachmentSchema(BaseSchema):
    attachment = FileUploadValidator()
    pre_validators = [variabledecode.NestedVariables]

class ProposalController(SecureController, View, Modify):
    model = Proposal
    individual = 'proposal'

    schemas = {"new" : NewProposalSchema(),
               "edit" : EditProposalSchema()}
    permissions = {"edit": [AuthFunc('is_submitter')],
                   "view": [AuthFunc('is_submitter'), AuthRole('reviewer')],
                   "delete": [AuthFunc('is_submitter')],
                   "index": [AuthRole('reviewer')],
                   }

    def __before__(self, **kwargs):
        super(ProposalController, self).__before__(**kwargs)

        c.proposal_types = Query(ProposalType).select()

    def new(self, id):
        errors = {}
        defaults = dict(request.POST)
        if defaults:
            result, errors = self.schemas['new'].validate(defaults)

            if not errors:
                c.proposal = self.obj = self.model()
                for k in result['proposal']:
                    setattr(c.proposal, k, result['proposal'][k])
                self.obj.people.append(c.signed_in_person)
                objectstore.save(c.proposal)
                if result.has_key('attachment') and result['attachment'] is not None:
                    att = Attachment()
                    for k in result['attachment']:
                        setattr(att, k, result['attachment'][k])
                    self.obj.attachments.append(att)
                    objectstore.save(att)
                
                objectstore.flush()

                redirect_to(action='view', id=self.obj.id)

        return render_response('proposal/new.myt', defaults=defaults, errors=errors)

    def is_submitter(self):
        return c.signed_in_person in self.obj.people

    def review(self, id):
        """Review a proposal.
        """
        c.proposal = Query(Proposal).get(id)

        defaults = dict(request.POST)
        errors = {}
        
        if defaults:
            result, errors = NewReviewSchema().validate(defaults)

            if not errors:
                review = Review()
                for k in result['review']:
                    setattr(review, k, result['review'][k])

                objectstore.save(review)

                review.reviewer = c.signed_in_person
                c.proposal.reviews.append(review)

                objectstore.flush()
                
                redirect_to(controller='proposal', action='index', id=None)
                
        c.streams = Query(Stream).select()
        
        return render_response('proposal/review.myt', defaults=defaults, errors=errors)
    

    def attach(self, id):
        """Attach a file to the proposal.
        """
        c.proposal = Query(Proposal).get(id)
        defaults = dict(request.POST)
        errors = {}

        if defaults:
            result, errors = NewAttachmentSchema().validate(defaults)

            if not errors:
                attachment = Attachment()
                for k in result['attachment']:
                    setattr(attachment, k, result['attachment'][k])
                c.proposal.attachments.append(attachment)

                objectstore.flush()

                return redirect_to(action='view', id=id)

        return render_response('proposal/attach.myt', defaults=defaults, errors=errors)

    def view(self):
        # save the current proposal id so we can refer to it later when we need to
        # bounce back here from other controllers
        # crazy shit with RUDBase means id is on self.obj
        session['proposal_id'] = self.obj.id
        session.save()
        return super(ProposalController, self).view()

    def index(self):
        c.proposal_types = Query(ProposalType).select()

        for pt in c.proposal_types:
            stuff = Query(Proposal).select_by(proposal_type_id=pt.id)
            setattr(c, '%s_collection' % pt.name, stuff)

        return super(ProposalController, self).index()
