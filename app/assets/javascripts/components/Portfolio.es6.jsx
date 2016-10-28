class HoldingsRow extends React.Component {
  render() {
    let value = parseFloat(this.props.holding.number_shares * this.props.holding.price_close).toFixed(2)
    let original_value = parseFloat(this.props.holding.number_shares * this.props.holding.purchase_price).toFixed(2)
    let holding_delta = parseFloat(value - original_value).toFixed(2)
    let number_color = "green-num"
    if (holding_delta < 0) {
      number_color = "red-num"
    }
    let symbol_url = "/holdings/" + this.props.holding.id
    let delete_url = symbol_url
    return (
      <tr>
        <td><a href={symbol_url} className="purple-link">{this.props.holding.symbol}</a></td>
        <td className="table-number">{this.props.holding.number_shares}</td>
        <td className="table-number">${parseFloat(this.props.holding.purchase_price).toFixed(2)}</td>
        <td className="table-number">${original_value}</td>
        <td className="table-number">${parseFloat(this.props.holding.price_close).toFixed(2)}</td>
        <td className="table-number">${value}</td>
        <td className={number_color}>${holding_delta}</td>
        <td>
          <form className="button_to" method="post" action={delete_url}>
            <input type="hidden" name="_method" value="delete" />
            <input data-confirm="You sure?" type="submit" value="Delete" />
            <input type="hidden" />
          </form>
        </td>
      </tr>
    );
  }
}

class Portfolio extends React.Component {
  render() {
    let cash = parseFloat(this.props.portfolio.cash).toFixed(2)
    let portfolio_id = this.props.portfolio.id
    let total = parseFloat(cash)
    let delta = 0
    for (i = 0; i < this.props.data.length; i++){
      total += parseFloat(this.props.data[i].number_shares * this.props.data[i].price_close);
      delta += (this.props.data[i].price_close - this.props.data[i].purchase_price) * this.props.data[i].number_shares;
    }
    let delete_url = "/portfolios/" + this.props.portfolio.id;
    let grade_url =  delete_url + "/grade"
    let update_url = delete_url + "/update";

    return (
      <div>
        <table className="table table-responsive table-striped" id="portfolio-show-table">
          <tbody>
            <tr>
              <th>Symbol</th>
              <th>Shares</th>
              <th>Purchase Price</th>
              <th>Original Value</th>
              <th>Price</th>
              <th>Value</th>
              <th>Gain/Loss</th>
              <th>Delete</th>
            </tr>
            {this.props.data.map(function (holding) {
              return(
                <HoldingsRow key={holding.id} holding={holding} portfolio_id={portfolio_id} />
              )
            })}
            <tr>
              <td>Cash</td>
              <td> </td>
              <td> </td>
              <td> </td>
              <td> </td>
              <td className="table-number">${cash}</td>
              <td> </td>
              <td> </td>
            </tr>

            <tr>
              <td> </td>
              <td> </td>
              <td> </td>
              <td> </td>
              <td> </td>
              <td className="table-number" >${parseFloat(total).toFixed(2)}</td>
              <td className="table-number">${parseFloat(delta).toFixed(2)}</td>
              <td> </td>
            </tr>
          </tbody>
        </table>
        <div className="row" id="portfolio-links-row">
          <div id="grade-portfolio-link">
            <a href={grade_url} className="purple-link">Grade this portfolio</a>
          </div>
          <AddStockForm portfolio_id={this.props.portfolio.id}/>
          <div>
            <form className="button_to" method="patch" action={update_url}>
              <input type="hidden" name="_method" value="patch" />
              <input data-confirm="You sure?" type="submit" value="Update Data" className="portfolio-button purple-link" />
              <input type="hidden" />
              <input type="hidden" name="portfolio_all" value="true" />
            </form>
          </div>
          <div>
            <a data-toggle="modal" href="#addStockModal" className="btn purple-link" id="addStock">Add Holding</a>
          </div>
          <div>
            <form className="button_to" method="post" action={delete_url}>
              <input type="hidden" name="_method" value="delete" />
              <input data-confirm="You sure?" type="submit" value="Delete" className="portfolio-button purple-link" />
              <input type="hidden" />
            </form>
          </div>
        </div>
      </div>
    );
  }
}
