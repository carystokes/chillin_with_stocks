class PortfolioChillTable extends React.Component {
  render() {
    let portfolio = this.props.portfolio;
    let performance = this.props.performance;
    return (
      <table className="table table-responsive table-striped" id="portfolio-grade-table">
        <tbody>
          <tr>
            <th>Area</th>
            <th>Points</th>
            <th>Possible</th>
          </tr>
          <tr>
            <td>Concentration</td>
            <td className="table-number">{performance.portfolio_concentration}</td>
            <td className="table-number">10</td>
          </tr>
          <tr>
            <td>Diversification</td>
            <td className="table-number">{performance.portfolio_diversification}</td>
            <td className="table-number">20</td>
          </tr>
          <tr>
            <td>Weighted Concentration</td>
            <td className="table-number">-{parseInt(performance.weighted_concentration)}</td>
            <td className="table-number">0</td>
          </tr>
          <tr>
            <td>Individual Stock Picking</td>
            <td className="table-number">{parseInt(performance.stock_picking_points)}</td>
            <td className="table-number">70</td>
          </tr>
          <tr>
            <td className="table-total">Total Chill Points</td>
            <td className="table-number table-total">{portfolio.portfolio_chill_points}</td>
            <td className="table-number table-total">100</td>
          </tr>
        </tbody>
      </table>
    );
  }
}
