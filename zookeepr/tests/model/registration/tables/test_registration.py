from zookeepr.tests.model import *

class TestRegistrationTable(TableTest):
    """Test the ``registration`` table.

    This table stores registration details.
    """
    table = model.registration.tables.registration
    samples = [dict(
                    address1='a11',
                    address2='a12',
                    city='city1',
                    state='state1',
                    country='country1',
                    postcode='postcode1',
                    company='company1',
                    shell='shell1',
                    shelltext='shelltext1',
                    editor='editor1',
                    editortext='editortext1',
                    distro='distro1',
                    distrotext='distrotext1',
                    type='type1',
                    discount_code='discount_code1',
                    teesize='teesize1',
                    dinner=1,
                    diet='diet1',
                    special='special1',
                    opendaydrag=1,
                    partner_email='partneremail1',
                    kids_0_3=1,
                    kids_4_6=1,
                    kids_7_9=1,
                    kids_10=1,
                    accommodation='accommodation1',
                    checkin=1,
                    checkout=1,
                    lasignup=1,
                    announcesignup=1,
                    delegatesignup=1,
                    ),
               dict(
                    address1='a21',
                    address2='a22',
                    city='city2',
                    state='state2',
                    country='country2',
                    postcode='postcode2',
                    company='company2',
                    shell='shell2',
                    shelltext='shelltext2',
                    editor='editor2',
                    editortext='editortext2',
                    distro='distro2',
                    distrotext='distrotext2',
                    type='type2',
                    discount_code='discount_code2',
                    teesize='teesize2',
                    dinner=2,
                    diet='diet2',
                    special='special2',
                    opendaydrag=2,
                    partner_email='partneremail2',
                    kids_0_3=2,
                    kids_4_6=2,
                    kids_7_9=2,
                    kids_10=2,
                    accommodation='accommodation2',
                    checkin=2,
                    checkout=2,
                    lasignup=0,
                    announcesignup=0,
                    delegatesignup=0,
                    ),
                ]
