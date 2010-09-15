                <script type="text/javascript">
                   function ticketWarning(tickettype){
                   var str=/student/i;
                      if(tickettype.match(str)){
                         jQuery('#warningDiv').slideDown(1000);
                      }
                      else{
                         jQuery('#warningDiv').slideUp(1000);
                      }
                   }
                   function showRocketWarning(){
                     jQuery('#rocket_warning').slideDown(1000);
                     jQuery("#rocket_see_note").show();
                   }
</script>

<%
import datetime
import re
import array
%>

<p class="note">${ h.lca_info['event_pricing_disclaimer'] }</p>

        <fieldset id="personal">
          <legend>&nbsp;</legend>
          <h2>Personal Information</h2>

          <p class="note"><span class="mandatory">*</span> - Mandatory field</p>

          <p class="label">
            <b>Name:</b>
% if c.registration and c.registration.person:
          ${ c.registration.person.firstname }
% else:
          ${ c.signed_in_person.firstname }
% endif
% if c.registration and c.registration.person:
          ${ c.registration.person.lastname }
% else:
          ${ c.signed_in_person.lastname }
% endif
          </p>
          <p class="label">
            <b>Email address:</b>
% if c.registration and c.registration.person:
          ${ c.registration.person.email_address }
% else:
          ${ c.signed_in_person.email_address }
% endif
          </p>

%if h.lca_rego['personal_info']['home_address'] == 'yes':
          <p class="label"><span class="mandatory">*</span><label for="person.address">Address:</label></p>
          <p class="entries">
            ${ h.text('person.address1', size=40) }
            <br>
            ${ h.text('person.address2', size=40) }
          </p>

          <p class="label"><span class="mandatory">*</span><label for="person.city">City/Suburb:</label></p>
          <p class="entries">${ h.text('person.city', size=40) }</p>

          <p class="label"><label for="person.state">State/Province:</label></p>
          <p class="entries">${ h.text('person.state', size=40) }</p>

          <p class="label"><span class="mandatory">*</span><label for="person.postcode">Postcode/ZIP:</label></p>
          <p class="entries">${ h.text('person.postcode', size=40) }</p>
%else:
${ h.hidden('person.address1') }
${ h.hidden('person.address2') }
${ h.hidden('person.city') }
${ h.hidden('person.state') }
${ h.hidden('person.postcode') }
%endif

          <p class="label"><span class="mandatory">*</span><label for="person.country">Country:</label></p>
          <p class="entries">
            <select name="person.country">
% for country in h.countries():
              <option value="${country}">${ country }</option>
% endfor
            </select>
          </p>

<%
  is_speaker = c.signed_in_person.is_speaker()
%>

%if h.lca_rego['personal_info']['phone'] == 'yes':
          <p class="label"><label for="person.mobile">Phone number (International Format):</label></p>
          <p class="entries">${ h.text('person.phone') }</p>

          <p class="label">
% if is_speaker:
            <span class="mandatory">*</span>
% endif
            <label for="person.mobile">Mobile/Cell number (International Format):</label>
          </p>
          <p class="entries">${ h.text('person.mobile') }</p>
%else:
${ h.hidden('person.phone') }
${ h.hidden('person.mobile') }
%endif

          <p class="label"><label for="person.company">Company:</label></p>
          <p class="entries">${ h.text('person.company', size=60) }</p>

        </fieldset>

        <fieldset id="voucher">
          <legend>&nbsp;</legend>
          <h2>Voucher</h2>

          <p class="label"><label for="registration.voucher_code">Voucher code:</label></p>
          <p class="entries">${ h.text('registration.voucher_code', size=15) }</p>
          <p class="note">If you have been provided with a voucher code, please enter it here.</p>

        </fieldset>
% for category in c.product_categories:
<%
  all_products = category.available_products(c.signed_in_person, stock=False)
  products = []
  for product in all_products:
      if c.product_available(product, stock=False):
          products.append(product)
%>
%   if len(products) > 0:

        <fieldset id="${ h.computer_title(category.name) }">
          <legend>&nbsp;</legend>
          <h2>${ category.name.title() }</h2>
          <p class="description">${ category.description |n}</p>
## Manual category display goes here:
%       if category.display_mode == 'shirt':
<%
           fields = dict()
           for product in products:
             results = re.match("^([a-zA-Z0-9']+)\s+(.*)$", product.description)
             gender = results.group(1)
             size = results.group(2)

             if gender not in fields:
               fields[gender] = []
             fields[gender].append((size, product))
           endfor
%>
          <table>
%           for gender in fields: 
            <tr><th>&nbsp;</th>
%              for (size, product) in fields[gender]:
               <th>${ size }</th>
%              endfor
             </tr>
             <tr>
               <td>${ gender }</td>
%              for (size, product) in fields[gender]:

%               if not product.available():
            <td><span class="mandatory">SOLD&nbsp;OUT</span><br />${ h.hidden('products.product_' + category.name.replace('-','_') + '_' + product.description.replace('-','_') + '_qty', 0) }</td>
%               else:
            <td>${ h.text('products.product_' + category.name.replace('-','_') + '_' + product.description.replace('-','_') + '_qty', size=2) }</td>
%               endif
%             endfor
            </tr>
%           endfor
          </table>
%       elif category.display_mode == 'grid' and category.display == 'qty':
<table>
  <tr>
%           for product in products:
<%
               soldout = ''
               if not product.available():
                   soldout = '<span class="mandatory">SOLD&nbsp;OUT</span><br />'
%>
    <th>${ product.description }<br />${ soldout | n}(${ h.number_to_currency(product.cost/100.0) })</th>
%           endfor
  </tr>
%           for product in products:
    <td align="center">${ h.text('products.product_' + category.name.replace('-','_') + '_' + product.description.replace('-','_') + '_qty', size=2) }</td>
%           endfor
</table>
%       elif category.display == 'radio':
         <p class="entries">
         <ul class="entries">
%         for product in products:
<%
               soldout = ''
               if not product.available():
                   soldout = ' <span class="mandatory">SOLD&nbsp;OUT</span> '
%> 

%              if category.name == "Ticket":
                <li> <label onclick="javascript: ticketWarning(' ${ product.description } ');"> ${ h.radio('products.category_' + category.name.replace('-','_'), str(product.id)) } ${ soldout |n}${ product.description } - ${ h.number_to_currency(product.cost/100.0) }</label><br />
%                  if product.description.lower().find('student') > -1:

<div id="warningDiv">
         <div class="message message-information">
          <p>Your student Id will be validated at the registration desk. Your card must be current or at least expired December of the previous year.</p>
         </div>
</div>
          <script type="text/javascript">
           jQuery("#warningDiv").hide();
          </script>
%                 endif
%              else:
          <li> <label> ${ h.radio('products.category_' + category.name.replace('-','_'), str(product.id)) } ${ soldout |n}${ product.description } - ${ h.number_to_currency(product.cost/100.0) }</label><br />
%              endif
%         endfor
          </ul>
          </p>
%       elif category.display == 'select':
%         if (category.name == 'Accommodation' and h.lca_rego['accommodation']['self_book'] == 'yes'):
            <input type="hidden" name="products.category_${ category.name.replace('-','_') }"
%             for product in products:
%               if product.description == 'I will organise my own':
                  value="${ product.id }"
%               endif
%             endfor
             >
%         else:
          <p class="entries">
            <select name="products.category_${ category.name.replace('-','_') }">
              <option value=""> - </option>
%           for product in products:
<%
               soldout = ''
               if not product.available():
                   soldout = ' SOLD&nbsp;OUT '
               endif
%>
              <option value="${ product.id }"> ${ soldout |n}${ product.description } - ${ h.number_to_currency(product.cost/100.0) }</option>
%           endfor
            </select>
          </p>
%         endif
%       elif category.display == 'checkbox':
%           for product in products:
<%
               soldout = ''
               if not product.available():
                   soldout = ' <span class="mandatory">SOLD&nbsp;OUT</span> '
%>
         <p class="entries"><label>${ h.checkbox('products.product_' + category.name.replace('-','_') + product.description.replace('-','_')) }${ soldout |n}${ product.description } - ${ h.number_to_currency(product.cost/100.0) }</label></p>
%           endfor
%       elif category.display == 'qty':
%           for product in products:
<%
               soldout = ''
               if not product.available():
                   soldout = ' <span class="mandatory">SOLD&nbsp;OUT</span> '
%>
          <p>${ soldout |n}${ product.description } ${ h.text('products.product_' + str(product.id) + '_qty', size=2) } x ${ h.number_to_currency(product.cost/100.0) }</p>
%           endfor
%       endif
%       if category.name == 'Accommodation':
%         if h.lca_rego['accommodation']['self_book'] == 'yes':
          <p class="note">Please see the
          <a href="${ h.lca_info['event_url']}/register/accommodation" target="_blank">accommodation page</a>
          for discounted rates for delegates. You <strong>must</strong> book
          your accommodation directly through the accommodation providers
          yourself. Registering for the conference <strong>does not</strong>
          book your accommodation.</p>
          <input type="hidden" name="registration.checkin" value='2010/01/01'>
          <input type="hidden" name="registration.checkout" value='2010/01/01'>
%         else:
          <p>Please see the <a href="${ h.lca_info['event_url']}/register/accommodation" target="_blank">accommodation page</a> for prices and details.</p>
          <p class="label"><span class="mandatory">*</span><label for="registration.checkin">Check in on:</label></p>
          <p class="entries">
            <select name="registration.checkin">
         <% dates = [(d, 1) for d in range(17,25)] %>
%           for (day, month) in dates[:-1]:
              <option value="${ day }">${ datetime.datetime(2010, month, day).strftime('%A, %e %b') }</option>
%           endfor
            </select>
          </p>

          <p class="label"><span class="mandatory">*</span><label for="registation.checkout">Check out on:</label></p>
          <p class="entries">
            <select name="registration.checkout">
%           for (day, month) in dates[1:]:
              <option value="${ day }" >${ datetime.datetime(2010, month, day).strftime('%A, %e %b') }</option>
%           endfor
            </select>
          </p>
%         endif
%       elif category.name == "Partners Programme":
          <p class="label"><span class="mandatory">#</span><label for="registration.partner_name">Your partner's name:</label></p>
          <p class="entries">${ h.text('products.partner_name', size=50) }</p>
          <p class="note">#If your partner will be participating in the programme, then this field is required so that our Partners Programme manager can contact them.</p>
          <p class="label"><span class="mandatory">#</span><label for="registration.partner_email">Your partner's email address:</label></p>
          <p class="entries">${ h.text('products.partner_email', size=50) }</p>
          <p class="note">#If your partner will be participating in the programme, then this field is required so that our Partners Programme manager can contact them.</p>
          <p class="label"><span class="mandatory">#</span><label for="registration.partner_mobile">Your partner's mobile (if known, in international format, otherwise enter "<b>unknown</b>"):</label></p>
          <p class="entries">${ h.text('products.partner_mobile', size=50) }</p>
          <p class="note">A Partners Programme shirt is included with every adult partner ticket. Please indicate the appropriate number and sizes in the T-Shirt Section (above).</p>
%       endif
%     if category.note:
        <p class="note">${ category.note | n }</p>
%     endif
        </fieldset>
%   endif
% endfor

        <fieldset>
          <legend>&nbsp;</legend>
          <h2>Further Information</h2>

          <p class="label"><span class="mandatory">*</span> <label for="registration.over18">Are you over 18?</label></p>
          <p class="entries">
            <label>${ h.radio('registration.over18', 1) } Yes</label><br />
            <label>${ h.radio('registration.over18', 0) } No</label><br />
           </p>
          <p class="note">Being under 18 will not stop you from registering. We need to know whether you are over 18 to allow us to cater for you at venues that serve alcohol.</p>

          <p class="label"><label for="registration.diet">Dietary requirements:</label></p>
          <p class="entries">${ h.text('registration.diet', size=60) }</p>

          <p class="label"><label for="registration.special">Other special requirements:</label></p>
          <p class="entries">${ h.text('registration.special', size=60) }</p>
          <p class="note">Please enter any requirements if necessary; access requirements, etc.</p>

             <p class="label"><label for="registration.prevlca">Have you attended linux.conf.au before?</label></p>
            <p class="entries">
            <table>
              <tr>
                <td>
% for (year, desc) in h.lca_rego['past_confs']:
   <% label = 'registration.prevlca.%s' % year %>
                <label>${ h.checkbox(label) } ${ desc }</label><br />
% endfor
                </td>
              </tr>
            </table>
            </p>
       </fieldset>

        <fieldset>
          <legend>&nbsp;</legend>
          <h2>Miniconfs Registration of Interest</h2>

          <p class="label"><label for="registration.miniconfs">Preferred miniconfs:</label></p>
          <p class="entries">
            <p>Rocket Miniconf: due to logistics and planning requirements for this unique miniconf,
               you <span style="color:orange">must</span> check the box below to gain admission to this miniconf.</p>
            <table>
              <tr>
% for day, miniconfs in h.lca_rego['miniconfs']:
                <th>${ day }</th>
% endfor
              </tr>
              <tr>
% for day, miniconfs in h.lca_rego['miniconfs']:
                <td>
%   for miniconf in miniconfs:

        <% label = 'registration.miniconf.%s_%s' % (day,miniconf.replace(' ', '_').replace('.', '_')) %>
%       if miniconf == 'Rocket Miniconf':
                  <label onclick="javascript: showRocketWarning()">${ h.checkbox(label) } ${ miniconf } <span class="note" id="rocket_see_note"># See note below</span> </label>
%       else:
                  <label>${ h.checkbox(label) } ${ miniconf } </label>
%       endif
                  <br>
%   endfor
                </td>
% endfor
              </tr>
            </table>

            <p class="note">
            </p>
            <div id="rocket_warning">
               <div class="message message-information">
                <p># Rocketry miniconf.  This miniconf will have a
                practical component, including a field trip to a
                rocketry launch site, and working with FOSS rocket
                hardware.  Therefore attending this miniconf incurs
                financial <b><span style="color:orange">commitment</span></b>
                over and above your conference registration costs.</p>
                <p style="color:orange">By leaving this box checked and submitting this form,
                you acknowledge this commitment above, and agree to follow
                the <a href="http://lca2011.linux.org.au/programme/rocket_miniconf">
                Requirements for the Rocketry Miniconf as laid
                out on the website.</a></p>
              </div>
            </div>
          <script type="text/javascript">
           jQuery("#rocket_warning").hide();
           jQuery("#rocket_see_note").hide();
          </script>

            <p class="note">Please check the <a href="${ h.lca_info['event_url']}/programme/miniconfs" target="_blank">Miniconfs page</a> for details on each event. You can choose to attend multiple miniconfs in the one day, as the schedules will be published ahead of the conference for you to swap sessions.</p>

          </fieldset>

          <fieldset>
            <legend>&nbsp;</legend>
            <h2>Optional</h2>
<script src="/silly.js"></script>
<table>
<tr>
  <th>Your favourite shell</th>
  <th>Your favourite editor</th>
  <th>Your favourite distro</th>
</tr>
<tr>
  <td>
            <p class="entries">
              <select id="registration.shell" name="registration.shell" onchange="toggle_select_hidden(this.id, 'shell_other')">
                <option value="">(please select)</option>
% for s in h.lca_rego['shells']:
                <option value="${s}">${ s }</option>
% endfor
                <option value="other">other</option>
              </select>
            </p>

% if not c.registration or c.registration.shell in h.lca_rego['shells'] or c.registration.shell == '':
<span id="shell_other" style="display: none">
% else:
<span id="shell_other" style="display: inline">
% endif
  <p class="entries">${ h.text('registration.shelltext', size=12) }</entries></p>
</span>
  </td>

  <td>
            <p class="entries">
              <select id="registration.editor" name="registration.editor" onchange="toggle_select_hidden(this.id, 'editor_other')">
                <option value="">(please select)</option>
% for e in h.lca_rego['editors']:
                <option value="${ e }">${ e }</option>
% endfor
                <option value="other">other</option>
              </select>
            </p>

% if not c.registration or c.registration.editor in h.lca_rego['editors'] or c.registration.editor == '':
<span id="editor_other" style="display: none">
% else:
<span id="editor_other" style="display: inline">
% endif
  <p class="entries">${ h.text('registration.editortext', size=12) }</entries></p>
</span>
  </td>

  <td>
            <p class="entries">
              <select id="registration.distro" name="registration.distro" onchange="toggle_select_hidden(this.id, 'distro_other')">
                <option value="">(please select)</option>
% for d in h.lca_rego['distros']:
                <option value="${ d }">${ d }</option>
% endfor
                <option value="other">other</option>
              </select>
            </p>

% if not c.registration or c.registration.distro in h.lca_rego['distros'] or c.registration.distro == '':
<span id="distro_other" style="display: none">
% else:
<span id="distro_other" style="display: inline">
% endif
  <p class="entries">${ h.text('registration.distrotext', size=12) }</entries></p>
</span>
  </td>
</tr>
</table>

            <p class="label"><label for="registration.nick">Superhero name:</label></p>
            <p class="entries">${ h.text('registration.nick', size=30) }</p>
            <p class="note">Your IRC nick or other handle you go by.</p>

% if h.lca_rego['pgp_collection'] != 'no':
            <p class="label"><label for="registration.keyid">GnuPG/PGP Keyid:</label></p>
            <p class="entries">${ h.text('registration.keyid', size=10) }</p>
            <p class="note">If you have a GnuPG or PGP key that is stored on a public key server and would like to participate in the Conference Key Signing, please enter your keyid (e.g. A3D48B3C) here. More information about the key signing will be made available closer to the conference.</p>
% endif

            <p class="label"><label for="registration.planetfeed">Planet Feed:</label></p>
            <p class="entries">${ h.text('registration.planetfeed', size=50) }</p>
            <p class="note">If you have a blog and would like it included in the ${ h.event_name() } planet, please specify an <b>${ h.event_name() } specific feed</b> to be included. (This is the URL of the RSS feed.)</p>

            <p class="label"><label for="registration.silly_description">Description:</label>
            <blockquote class="entries">${ c.silly_description }</blockquote></p>
            ${ h.hidden('registration.silly_description') }
            ${ h.hidden('registration.silly_description_checksum') }
            <p class="note">This is a randomly chosen description for your name badge</p>

          </fieldset>
          <fieldset>
            <legend>&nbsp;</legend>
            <h2>Subscriptions</h2>
             <p class="note">Tick below to sign up for any of the following:</p>

            <p class="entries">
            <ul class="entries">
              <li> <label>${ h.checkbox('registration.signup.linuxaustralia') } membership with Linux Australia</label> <a href="http://www.linux.org.au/" target="_blank">(read more)</a>

              <li> <label>${ h.checkbox('registration.signup.announce') } the low traffic <b>${ h.event_name() }  announcement list</b></label>

              <li> <label>${ h.checkbox('registration.signup.chat') } the <b>${ h.event_name() } attendees list</b></label>
            </ul>
            </p>
          </fieldset>

% if is_speaker:
          <fieldset>
            <legend>&nbsp;</legend>
            <h2>Speaker recording consent and release</h2>
            <p>As a service to Linux Australia members and to other interested Linux users,
            Linux Australia would like to make your presentation available to the public.
            This involves video­taping your talk, and offering the video/audio and slides
            (for download, or on physical media).</p>

            <p>If you have allowed Linux Australia to publish your slides, there will
            be an upload mechanism closer to the conference. We will publish them under
            the Creative Commons Attribution License unless you have an equivalent
            preference that you let us know.</p>
          </fieldset>
% endif
