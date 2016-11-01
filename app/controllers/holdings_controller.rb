require 'net/http'
require 'httparty'
require 'json'

class HoldingsController < ApplicationController
  skip_before_action :verify_authenticity_token
  include HoldingsDataHelper

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
