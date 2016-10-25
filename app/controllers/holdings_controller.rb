require 'net/http'
require 'httparty'
require 'json'

class HoldingsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    @portfolio = Portfolio.find(params[:portfolio_id])
    holding = Holding.new(holding_params)
    holding.portfolio = @portfolio
    @holding = get_holding_data(holding)

    if @holding.save
      flash[:notice] = 'Holding created successfully'
    else
      flash[:notice] = @holding.errors.full_messages.join(', ')
    end
    redirect_to @portfolio
  end

  def show
    @holding = Holding.find(params[:id])
    @performance = get_performance(@holding)
  end

  def edit
  end

  def update
    if params[:portfolio_all]
      portfolio = Portfolio.find(params[:portfolio_id])
      holdings = portfolio.holdings
      holdings.each do |holding|
        new_holding = holding
        new_holding = get_holding_data(holding)
        holding = new_holding
      end
      redirect_to portfolio
    else
      holding = Holding.find(params[:id])
      @holding = get_holding_data(holding)

      if @holding.save
        flash[:notice] = 'Holding updated successfully'
      else
        flash[:notice] = @holding.errors.full_messages.join(', ')
      end
      redirect_to @holding
    end
  end

  def destroy
    holding = Holding.find(params[:id])
    portfolio = holding.portfolio
    holding.destroy
    flash[:notice] = 'Holding successfully deleted'
    redirect_to portfolio
  end

  private

    def holding_params
      params.require(:holding).permit(:symbol, :number_shares, :purchase_price, :industry, :portfolio_id)
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
end
