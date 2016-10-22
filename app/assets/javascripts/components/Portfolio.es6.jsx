class HoldingsRow extends React.Component {
  render() {
    let value = parseFloat(this.props.number_shares * this.props.price_close).toFixed(2);
    let original_value = parseFloat(this.props.number_shares * this.props.purchase_price).toFixed(2);
    let holding_delta = parseFloat(value - original_value).toFixed(2);
    let symbol_url = "/holdings/" + this.props.id;
    let delete_url = symbol_url
    return (
      <tr>
        <td><a href={symbol_url}>{this.props.symbol}</a></td>
        <td className="table-number">{this.props.number_shares}</td>
        <td className="table-number">${parseFloat(this.props.purchase_price).toFixed(2)}</td>
        <td className="table-number">${original_value}</td>
        <td className="table-number">${parseFloat(this.props.price_close).toFixed(2)}</td>
        <td className="table-number">${value}</td>
        <td className="table-number">${holding_delta}</td>
        <td>
          <form className="button_to" method="post" action={delete_url}>
            <input type="hidden" name="_method" value="delete" />
            <input data-confirm="You sure?" type="submit" value="Delete Holding" />
            <input type="hidden" />
          </form>
        </td>
      </tr>
    );
  }
}

class Portfolio extends React.Component {
  render() {
    let cash = parseFloat(this.props.portfolio.cash).toFixed(2);
    let total = parseFloat(cash);
    let delta = 0;
    for (i = 0; i < this.props.data.length; i++){
      total += parseFloat(this.props.data[i].number_shares * this.props.data[i].price_close);
      delta += (this.props.data[i].price_close - this.props.data[i].purchase_price) * this.props.data[i].number_shares;
    }
    return (
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
              <HoldingsRow key={holding.id} symbol={holding.symbol}
               number_shares={holding.number_shares}
               purchase_price={holding.purchase_price}
               price_close={holding.price_close}
               id={holding.id}/>
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
    );
  }
}
