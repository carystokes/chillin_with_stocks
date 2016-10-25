class PortfolioStockList extends React.Component {
  constructor() {
    super();
    this.state = {
      display: "hidden"
    };
    this.handleChange = this.handleChange.bind(this);
  }

  handleChange(event) {
    if (this.state.display == "hidden") {
      this.setState({ display: "show" })
    } else {
      this.setState({ display: "hidden"})
    }
  }

  render() {
    let holding = this.props.holding;
    return (
    <div>
      <form>
        <input type="button" id="show-data" value="Show Data" onClick={this.handleChange} />
      </form>
      <br />
      <div className="col-sm-push-3">
        <ul className={this.state.display} id="holding-data">
          <li>Previous Closing Price: ${ holding.price_close }</li>
          <li>Dividend Yield: { holding.div_yield }%</li>
          <li>12 Month Target Price: ${ holding.year_target }</li>
          <li>52 Week High: ${ holding.year_high }</li>
          <li>52 Week Low: ${ holding.year_low }</li>
          <li>Market Capitalization: ${ holding.market_cap } </li>
          <li>Average Daily Volume: { holding.avg_volume }</li>
          <li>Current Year EPS Estimate: ${ holding.eps_current }</li>
          <li>Next Year EPS Estimate: ${ holding.eps_next }</li>
          <li>Short Ratio: { holding.short_ratio }%</li>
        </ul>
      </div>
    </div>
    );
  }
}
