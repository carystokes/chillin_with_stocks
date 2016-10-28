class PortfoliosController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @portfolios = []
    if !current_user.nil?
      @user = current_user
      @portfolios = @user.portfolios
    end
  end

  def show
    @portfolio = set_portfolio
    @holdings = @portfolio.holdings
    @holding = Holding.new
  end

  def grade
    @portfolio = set_portfolio
    @holdings = @portfolio.holdings
    @performance = {}
    grades = get_portfolio_grade(@holdings)
    @performance[:portfolio_concentration] = grades[0]
    @performance[:portfolio_diversification] = grades[1]
    total_value = @portfolio.cash
    grades[2].values.each do |value|
      total_value += value
    end
    penalty_points = 0
    grades[2].values.each do |value|
      if value / total_value > 0.2
        penalty_points += value / total_value * 30
      end
    end
    @performance[:weighted_concentration] = penalty_points
    stock_picking_points = get_stock_point_array(@holdings) / total_value
    @performance[:stock_picking_points] = stock_picking_points
    @portfolio.portfolio_chill_points = grades[0] + grades[1] - penalty_points + stock_picking_points
    chill = get_chill_color(@portfolio.portfolio_chill_points)
    @portfolio.portfolio_chill_color = chill[0]
    @portfolio.portfolio_chill_message = chill[1]
  end

  def new
    if current_user.nil?
      redirect_to portfolios_path, notice: "Please sign in"
    else
      @portfolio = Portfolio.new
      @portfolio.user = current_user
    end
  end

  def edit
    @portfolio = set_portfolio
    render :new
  end

  def create
    new_params = portfolio_params
    new_params[:user_id] = current_user.id
    @portfolio = Portfolio.create(new_params)
    if @portfolio.save
      redirect_to @portfolio, notice: 'Portfolio was successfully created.'
    else
      flash[:notice] = @portfolio.errors.full_messages.join(', ')
      render 'new'
    end
  end

  def update
    @portfolio = Portfolio.find(params[:id])
    holdings = @portfolio.holdings
    holdings.each do |holding|
      holding = get_holding_data(holding)
      holding.save()
    end
    redirect_to @portfolio
  end

  def destroy
    @portfolio = set_portfolio
    @portfolio.destroy
    redirect_to portfolios_url, notice: 'Portfolio was successfully destroyed.'
  end

  private
    def set_portfolio
      @portfolio = Portfolio.find(params[:id])
    end

    def get_portfolio_grade(holdings)
      concentration_grade = get_concentration(holdings)
      diversification_grade = get_diversification(holdings)
      industry_concentration_hash = get_industry_concentration(holdings)
      return [concentration_grade, diversification_grade, industry_concentration_hash]
    end

    def get_concentration(holdings)
      num_stocks = holdings.length
      if num_stocks <= 4
        return 0
      elsif num_stocks <= 8
        return 5
      elsif num_stocks <=20
        return 10
      else
        return 5
      end
    end

    def get_diversification(holdings)
      div_holdings = []
      holdings.each do |holding|
        if !div_holdings.member?(holding.industry)
          div_holdings << holding.industry
        end
      end
      if div_holdings.length > 7
        return 20
      elsif div_holdings.length > 3
        return 10
      else
        return 0
      end
    end

    def get_industry_concentration(holdings)
      industry_holdings = {}
      holdings.each do |holding|
        if industry_holdings.member?(holding.industry)
          industry_holdings[holding.industry] += (holding.number_shares * holding.price_close)
        else
          industry_holdings[holding.industry] = (holding.number_shares * holding.price_close)
        end
      end
      industry_holdings
    end

    def get_stock_point_array(holdings)
      stock_points = 0
      holdings.each do |holding|
        stock_points += holding.number_shares * holding.price_close * holding.chill_points
      end
      stock_points
    end

    def get_chill_color(points)
      if points >= 75
        return ['green', 'is CHILLIN!!']
      elsif points >= 50
        return ['yellow', 'might be chillin.']
      else
        return ['red', 'is NOT chillin!']
      end
    end

    def get_holding_data(holding)
      url = 'http://download.finance.yahoo.com/d/quotes.csv?s=' + holding.symbol + '&f=pyt8kjj1e7e8s7a2'
      response = HTTParty.get(url)
      data = response.rstrip.split(',')
      holding.price_close = data[0].to_f
      holding.div_yield = data[1].to_f
      holding.year_target = data[2].to_f
      holding.year_high = data[3].to_f
      holding.year_low = data[4].to_f
      holding.market_cap = data[5]
      magnitude = data[5].slice!(-1)
      holding.market_cap_num = data[5].to_f
      if magnitude == "M"
        holding.market_cap_num /= 1000
      end
      holding.eps_current = data[6].to_f
      holding.eps_next = data[7].to_f
      holding.short_ratio = data[8].to_f
      holding.avg_volume = data[9].to_i
      holding.chill_points = 0
      performance = get_performance(holding)
      performance.values.each do |points|
        holding.chill_points += points
      end
      if holding.chill_points >= 75
        holding[:chill_color] = 'green'
        holding[:chill_message] = "is CHILLIN!!"
      elsif holding.chill_points >= 50
        holding[:chill_color] = 'yellow'
        holding[:chill_message] = "might be CHILLIN."
      else
        holding[:chill_color] = 'red'
        holding[:chill_message] = "is not CHILLIN!"
      end
      holding
    end

    def get_price_perf(holding)
      price_perf = (holding.price_close - holding.year_low) / (holding.year_high - holding.year_low) * 100
      if price_perf >= 80
        return 0
      elsif price_perf >= 50
        return 5
      elsif price_perf >= 20
        return 10
      else
        return 15
      end
    end

    def get_price_to_earnings(holding)
      price_to_earnings = holding.price_close / holding.eps_next
      if price_to_earnings >= 25
        return 0
      elsif price_to_earnings >= 15
        return 15
      elsif price_to_earnings >= 5
        return 30
      elsif price_to_earnings >= 0
        return 5
      else
        return 0
      end
    end

    def get_earnings_growth(holding)
      earnings_growth = (holding.eps_next - holding.eps_current) / holding.eps_current * 100
      if earnings_growth >= 20
        return 25
      elsif earnings_growth >= 10
        return 20
      elsif earnings_growth >= 5
        return 10
      elsif earnings_growth >= 0
        return 5
      else
        return -10
      end
    end

    def get_div_yield(holding)
      div_yield = holding.div_yield
      if div_yield >= 5
        return 0
      elsif div_yield >= 2
        return 10
      elsif div_yield > 0
        return 5
      else
        return 0
      end
    end

    def get_price_expectation(holding)
      price_expectation_ratio = (holding.year_target - holding.price_close) / holding.price_close * 100
      if price_expectation_ratio >= 20
        return 10
      elsif price_expectation_ratio >= 10
        return 5
      else
        return 0
      end
    end

    def get_market_cap(holding)
      market_cap = holding.market_cap_num
      if market_cap >= 5
        return 5
      elsif market_cap >= 0.1
        return 10
      else
        return 0
      end
    end

    def get_avg_volume(holding)
      avg_volume = holding.avg_volume.to_i
      if avg_volume >= 100000
        return 0
      elsif avg_volume >= 50000
        return -5
      else
        return -10
      end
    end

    def get_short_ratio(holding)
      short_ratio = holding.short_ratio.to_f
      if short_ratio >= 4
        return -10
      elsif short_ratio >= 2
        return -5
      else
        return 0
      end
    end

    def get_performance(holding)
      performance = {}
      performance[:price_perf] = get_price_perf(holding)
      performance[:price_to_earnings] = get_price_to_earnings(holding)
      performance[:earnings_growth] = get_earnings_growth(holding)
      performance[:div_yield] = get_div_yield(holding)
      performance[:price_expectation] = get_price_expectation(holding)
      performance[:market_cap] = get_market_cap(holding)
      performance[:avg_volume] = get_avg_volume(holding)
      performance[:short_ratio] = get_short_ratio(holding)
      performance
    end

    def portfolio_params
      params.require(:portfolio).permit(:title, :cash, :id, :user_id)
    end
end
