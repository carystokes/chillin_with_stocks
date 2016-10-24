const IndustryDropdown = props => {
  return (
    <div className="form-group new_holding">
      <label htmlFor="industry" id="industry-label">Industry</label>
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
    <div id="addStockModal" className="modal" role="dialog">
      <div className="modal-dialog" role="document">
        <div className="modal-content">
          <div className="modal-header">
            <button type="button" className="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
            <h4 className="modal-title">Add a Holding</h4>
          </div>
          <div className="modal-body">
            <form className="form-horizontal" role="form" method="post" action={url}>
              <div className="form-group">
                <label htmlFor="number" className="col-sm-2 control-label" id="modal-label-1">Stock Symbol</label>
                <div className="col-sm-10">
                  <input type="text" name="holding[symbol]" />
                </div>
              </div>
              <IndustryDropdown />
              <div className="form-group">
                <label htmlFor="number" className="col-sm-2 control-label" id="modal-label-2">Number of Shares</label>
                <div className="col-sm-10">
                  <input type="number" name="holding[number_shares]" defaultValue="0" />
                </div>
              </div>
              <div className="form-group">
                <label htmlFor="purchase_price" className="col-sm-2 control-label" id="modal-label-3">Purchase Price</label>
                <div className="col-sm-10">
                  <input type="number" name="holding[purchase_price]" defaultValue="0.0" />
                </div>
              </div>
              <div className="col-sm-2"></div>
              <button type="submit" className="btn" id="add-button">Add</button>
              <button type="button" className="btn btn-default " data-dismiss="modal">Cancel</button>
            </form>
          </div>
        </div>
      </div>
    </div>
  );
}
