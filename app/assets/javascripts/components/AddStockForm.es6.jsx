const IndustryDropdown = props => {
  return (
    <div className="form-group new_holding">
      <label htmlFor="industry">Industry</label>
      <select className="form-control" name="holding[industry]" id="industry">
        <option>Consumer Discretionary</option>
        <option>Consumer Staples</option>
        <option>Energy</option>
        <option>Financials</option>
        <option>Health Care</option>
        <option>Industrials</option>
        <option>Information Technology</option>
        <option>Materials</option>
        <option>Real Estate</option>
        <option>Telecommunication Services</option>
        <option>Utilities</option>
      </select>
    </div>
  )
};

const AddStockForm = props => {
  let portfolio_id = props.portfolio_id
  let url = "/portfolios/" + portfolio_id + "/holdings"
  return (
    <form id="add-holding-form" className="new_holding" method="post" action={url}>
      <label htmlFor="Symbol" id="stockSymbol">Stock Symbol</label>
      <input type="text" name="holding[symbol]" />
      <IndustryDropdown />
      <label htmlFor="number_shares" id="numberShares">Number shares</label>
      <input type="number" name="holding[number_shares]" defaultValue="0" /><br />
      <label htmlFor="purchase_price" id="purchasePrice">Purchase price</label>
      <input type="number" name="holding[purchase_price]" defaultValue="0.0" /><br />
      <input type="submit" name="commit" defaultValue="Add holding" className="formButton" />
    </form>
  );
}
