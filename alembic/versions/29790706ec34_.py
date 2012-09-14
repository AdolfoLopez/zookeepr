"""empty message

Revision ID: 29790706ec34
Revises: 2daf319bbf1
Create Date: 2012-07-22 13:46:58.218753

"""

# revision identifiers, used by Alembic.
revision = '29790706ec34'
down_revision = '2daf319bbf1'

from alembic import op
import sqlalchemy as sa


def upgrade():
    ### commands auto generated by Alembic - please adjust! ###
    op.add_column('proposal', sa.Column('private_abstract', sa.Text(), nullable=False))
    op.alter_column('payment_received', u'client_ip_zk', 
               existing_type=sa.String(), 
               name=u'client_ip_zookeepr')
    op.alter_column('proposal', u'technical_requirements', 
               existing_type=sa.TEXT(), 
               nullable=False)
    op.alter_column('proposal', u'url', 
               existing_type=sa.TEXT(), 
               nullable=False)
    op.alter_column('proposal', u'abstract', 
               existing_type=sa.TEXT(), 
               nullable=False)
    op.alter_column('proposal', u'title', 
               existing_type=sa.TEXT(), 
               nullable=False)
    op.alter_column('proposal', u'project', 
               existing_type=sa.TEXT(), 
               nullable=False)
    op.alter_column('proposal', u'abstract_video_url', 
               existing_type=sa.TEXT(), 
               nullable=False)
    op.alter_column('proposal', u'slides_release', 
               existing_nullable=True, 
               nullable=False)
    op.alter_column('proposal', u'video_release', 
               existing_nullable=True,
               nullable=False)
    ### end Alembic commands ###


def downgrade():
    ### commands auto generated by Alembic - please adjust! ###
    op.alter_column('proposal', u'video_release', 
               existing_nullable=False, 
               nullable=True)
    op.alter_column('proposal', u'slides_release', 
               existing_nullable=False, 
               nullable=True)
    op.alter_column('proposal', u'abstract_video_url', 
               existing_type=sa.TEXT(), 
               nullable=True)
    op.alter_column('proposal', u'project', 
               existing_type=sa.TEXT(), 
               nullable=True)
    op.alter_column('proposal', u'title', 
               existing_type=sa.TEXT(), 
               nullable=True)
    op.alter_column('proposal', u'abstract', 
               existing_type=sa.TEXT(), 
               nullable=True)
    op.alter_column('proposal', u'url', 
               existing_type=sa.TEXT(), 
               nullable=True)
    op.alter_column('proposal', u'technical_requirements', 
               existing_type=sa.TEXT(), 
               nullable=True)
    op.alter_column('payment_received', 'client_ip_zookeepr', 
               existing_type=sa.String(), 
               nullable=False,
               name=u'client_ip_zk')
    op.drop_column('proposal', 'private_abstract')
    ### end Alembic commands ###