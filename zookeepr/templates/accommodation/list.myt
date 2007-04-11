<h1>Accommodation</h1>

<table>

<th>#</th>

<th>Location</th>

<th>Option</th>

<th>Cost per night</th>

<th>Capacity (# beds)</th>

<th>Availability (# beds left)</th>

% if accommodation_paid:
<th> Paid Accommodation </th>
% # endif


% beds_total = 0
% beds_available = 0
% beds_paid = 0
% for a in c.accommodation_collection:
%     beds_total += a.beds
%     beds_available += a.get_available_beds()

<tr class="<% h.cycle('even', 'odd')%>">

<td>
<% a.id %>
</td>

<td>
<% a.name %>
</td>

<td>
<% a.option %>
</td>

<td>
<% h.number_to_currency(a.cost_per_night) %>
</td>

<td>
<% a.beds |h %>
</td>

<td>
<% a.get_available_beds() |h %>
</td>

%     if accommodation_paid:
<td>
%         if a.id in accommodation_paid:
%		beds_paid += accommodation_paid[a.id]
<% accommodation_paid[a.id] %>
%         else:
0
%         # endif
</td>
%     # endif


</tr>

% #endfor

<tr>
    <td>&nbsp;</td>
    <td><strong>Totals</strong</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>

    <td><% beds_total %></td>
    <td><% beds_available %></td>
%     if accommodation_paid:
    <td><% beds_paid %></td>
%     # endif
</tr>

</table>

<%args scope="component">
accommodation_paid = None
</%args>

<%method title>
Accommodation - <& PARENT:title &>
</%method>