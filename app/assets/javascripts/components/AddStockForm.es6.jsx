const AddStockForm = props => {
  let portfolio_id = props.portfolio_id
  let url = "/portfolios/" + portfolio_id + "/holdings"
  return (
    <form id="add-holding-form" className="new_holding" method="post" action={url}>
      <label htmlFor="Symbol" id="stockSymbol">Stock Symbol</label>
      <input type="text" name="holding[symbol]" />
      <label htmlFor="number_shares" id="numberShares">Number shares</label>
      <input type="number" name="holding[number_shares]" defaultValue="0" />
      <label htmlFor="purchase_price" id="stockSymbol">Purchase price</label>
      <input type="number" name="holding[purchase_price]" defaultValue="0.0" />
      <input type="submit" name="commit" defaultValue="Add holding" className="formButton" />
    </form>
  );
}
