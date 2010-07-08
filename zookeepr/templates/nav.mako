<%
    url = h.url_for()
    # Hack for schedule url
    if url.startswith('/schedule'):
        url = '/programme' + url
    mm = h.lca_menu

    where = ''
    if url == '' or url == '/':
        where = 'home'

    map = [(u, c) for (t, u, c) in mm]

    for (u, w) in map:
        if url.startswith('/' + w):
            where = w

    def cls(part):
        if part == where:
            return 'class="selected"'
        else:
            return 'class=""'
%>

      <img src="images/header.jpg">
      <ul class="primarynav">
% for (t, u, c) in mm:
%   if c == 'selected':
          <li>${ t |n }</li>
%   else:
          <li ${ cls(c) |n}><a href="${ u }">${ t }</a></li>
%   endif

% endfor
      </ul>

