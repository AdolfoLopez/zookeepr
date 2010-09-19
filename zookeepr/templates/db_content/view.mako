<%inherit file="/base.mako" />
<%namespace file="../bookmark_submit.mako" name="bookmark_submit" inheritable="True"/>
<%
url=h.lca_info["event_permalink"] + h.url_for()
import re
findh3 = re.compile('(<h3>(.+?)</h3>)', re.IGNORECASE|re.DOTALL|re.MULTILINE)
h3 = findh3.findall(c.db_content.body)
body = c.db_content.body
if h3.__len__() > 0:
    simple_title = ''
    for match in h3:
        simple_title = re.compile('([^a-zA-Z0-9])').sub('', match[1])
        body = re.compile(match[0]).sub(r'<a name="' + simple_title + '"></a>\g<0>', body)

findslideshow = re.compile('({{slideshow:\s*(.*?)(,\s*(.*))?}})', re.DOTALL)
slideshow = findslideshow.findall(c.db_content.body)
if slideshow.__len__() > 0:
   for match in slideshow:
      body = re.compile(match[0]).sub(h.slideshow(match[1], match[3]), body)
%>

<h2>${ c.db_content.title }</h2>

% if c.db_content.is_news():
<div style="float: right;">
${ bookmark_submit.bookmark_submit(url, c.db_content.title) }
</div>
<p class="submitted">
Submitted on ${ c.db_content.creation_timestamp.strftime("%Y-%m-%d&nbsp;%H:%M") |n }
</p>
% else:
<div style="float: right;">
<%include file="/leftcol/contents.mako" args="parent=self" />
</div>
% endif


${ body |n}


<%def name="title()">
${ c.db_content.title } -
 ${ parent.title() }
</%def>

<%def name="big_promotion()">
<% directory = h.featured_image(c.db_content.title, big = True) %>
%if directory is not False:
			<div class = 'news_banner'>
%  if h.os.path.isfile(directory + "/3.png"):
				<div class = 'news_banner_left'>
					<a href = '/media/news/${ c.db_content.id }'><img src = '${ directory }/1.png' alt="${ c.db_content.title }" title="${ c.db_content.title }"></a>
				</div>
%  endif
%  if h.os.path.isfile(directory + "/3.png"):
				<div class = 'news_banner_right'>
					<a href = '/media/news/${ c.db_content.id }'><img src = '${ directory }/3.png' alt="${ c.db_content.title }" title="${ c.db_content.title }"></a>
				</div>
%  endif
				<a href = '/media/news/${ c.db_content.id }'>
					<img src = '${ directory }/2.png' alt="${ c.db_content.title }" title="${ c.db_content.title }">
				</a>
			</div>
  <br /><br />
%endif
</%def>

<%def name="extra_head()">
<% directory = h.featured_image(c.db_content.title, big = True) %>
%if directory is not False:
<style type="text/css">
.content
{
    background-image: url(/images/content_bg_tall.png);
}
</style>
%endif
</%def>

<%def name="contents()">
<% 
  menu = ''

  import re

  findh3 = re.compile('(<h3>(.+?)</h3>)', re.IGNORECASE|re.DOTALL|re.MULTILINE)
  h3 = findh3.findall(c.db_content.body)
  if h3.__len__() > 0:
    simple_title = ''
    for match in h3:
        simple_title = re.compile('([^a-zA-Z0-9])').sub('', match[1])
        menu += '<li><a href="#' + simple_title + '">' + match[1] + '</a></li>'
    return menu
%>
</%def>

