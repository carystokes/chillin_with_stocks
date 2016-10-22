class Holding extends React.Component {
  render() {
    let holding = this.props.holding;
    let performance = this.props.performance;
    return (
      <table className="table table-responsive table-striped" id="holding-show-table">
        <tbody>
          <tr>
            <th>Factor</th>
            <th>Points</th>
            <th>Possible</th>
          </tr>
          <tr>
            <td>Price Performance</td>
            <td className="table-number">{performance.price_perf}</td>
            <td className="table-number">10</td>
          </tr>
          <tr>
            <td>Price to Earnings (PE)</td>
            <td className="table-number">{performance.price_to_earnings}</td>
            <td className="table-number">30</td>
          </tr>
          <tr>
            <td>Earnings Growth</td>
            <td className="table-number">{performance.earnings_growth}</td>
            <td className="table-number">25</td>
          </tr>
          <tr>
            <td>Dividend Yield</td>
            <td className="table-number">{performance.div_yield}</td>
            <td className="table-number">10</td>
          </tr>
          <tr>
            <td>Price Expectation</td>
            <td className="table-number">{performance.price_expectation}</td>
            <td className="table-number">10</td>
          </tr>
          <tr>
            <td>Market Capitalization</td>
            <td className="table-number">{performance.market_cap}</td>
            <td className="table-number">10</td>
          </tr>
          <tr>
            <td>Average Daily Volume</td>
            <td className="table-number">{performance.avg_volume}</td>
            <td className="table-number">0</td>
          </tr>
          <tr>
            <td>Short Ratio</td>
            <td className="table-number">{performance.short_ratio}</td>
            <td className="table-number">0</td>
          </tr>
          <tr>
            <td className="table-total">Total Chill Points</td>
            <td className="table-number table-total">{holding.chill_points}</td>
            <td className="table-number table-total">100</td>
          </tr>
        </tbody>
      </table>
    );
  }
}
