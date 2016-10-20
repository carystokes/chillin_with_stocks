<table>
  <tr>
    <th>Symbol</th>
    <th>Shares</th>
    <th>Price</th>
    <th>Value</th>
  </tr>

  <% total = 0 %>
  <% @portfolio.holdings.each do |holding| %>
    <tr>
      <td><%= link_to holding.symbol, holding %></td>
      <td><%= holding.number_shares %></td>
      <td><%= holding.price_close %></td>
      <td><%= holding.number_shares * holding.price_close %></td>
      <% total += holding.number_shares * holding.price_close %>
    </tr>
  <% end %>

  <tr>
    <td>Cash</td>
    <td> </td>
    <td> </td>
    <td><%= @portfolio.cash %></td>
    <% total += @portfolio.cash %>
  </tr>

  <tr>
    <td> </td>
    <td> </td>
    <td> </td>
    <td><%= total %></td>
  </tr>
</table>
