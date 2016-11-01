class PortfoliosController < ApplicationController
  skip_before_action :verify_authenticity_token
  include HoldingsDataHelper

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

    def portfolio_params
      params.require(:portfolio).permit(:title, :cash, :id, :user_id)
    end
end
