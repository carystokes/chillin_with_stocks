const SellStockForm = props => {
  let portfolio = props.portfolio;
  let url = "/holdings/sell";
  return (
    <div id="sellStockModal" className="modal" role="dialog">
      <div className="modal-dialog" role="document">
        <div className="modal-content">
          <div className="modal-header">
            <button type="button" className="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
            <h4 className="modal-title">Sell a Stock</h4>
          </div>
          <div className="modal-body">
            <form className="form-horizontal" role="form" method="post" action={url}>
              <div className="form-group">
                <label htmlFor="portfolio" className="col-sm-2 control-label" id="modal-label-1">Portfolio</label>
                <div className="col-sm-10">
                  <input type="text" name="portfolio" value={ portfolio.title } />
                  <input type="number" name="portfolio_id" className="hidden" value={portfolio.id} />
                </div>
              </div>
              <div className="form-group">
                <label htmlFor="symbol" className="col-sm-2 control-label" id="modal-label-1">Stock Symbol</label>
                <div className="col-sm-10">
                  <input type="text" name="symbol" />
                </div>
              </div>
              <div className="form-group">
                <label htmlFor="number" className="col-sm-2 control-label" id="modal-label-2">Number of Shares</label>
                <div className="col-sm-10">
                  <input type="number" name="number" defaultValue="0" />
                </div>
              </div>
              <div className="form-group">
                <label htmlFor="sales_price" className="col-sm-2 control-label" id="modal-label-3">Sales Price</label>
                <div className="col-sm-10">
                  <input type="decimal" name="sales_price" defaultValue="0.0" />
                </div>
              </div>
              <div className="col-sm-2"></div>
              <button type="submit" className="btn" id="add-button">Sell</button>
              <button type="button" className="btn btn-default " data-dismiss="modal">Cancel</button>
            </form>
          </div>
        </div>
      </div>
    </div>
  );
}
