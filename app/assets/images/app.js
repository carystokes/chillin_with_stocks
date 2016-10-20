const Holding = props => {

  return (
  <tr>
    <td>{ props.holding.symbol }</td>
    <td>{ props.holding.number_shares }</td>
    <td>{ props.holding.price_close }</td>
    <td>{ props.holding.number_shares * props.holding.price_close }</td>
  </tr>
  );
}

class App extends React.Component {

  this.state = {
    holdings: props.data
  }

  render () {
    return (
      <div>
        <p>Hello</p>
        <table>
          <tr>
            <th>Symbol</th>
            <th>Shares</th>
            <th>Price</th>
            <th>Value</th>
          </tr>

          <div>
            {this.state.holdings.map(function(holding) {
              return (
                <Holding holding={holding}>
              )
            })}
          </div>

          <tr>
            <td>Cash</td>
            <td> </td>
            <td> </td>
            <td>{ @portfolio.cash }</td>
          </tr>

          <tr>
            <td> </td>
            <td> </td>
            <td> </td>
            <td>total</td>
          </tr>
        </table>
      </div>
    );
  }
}
