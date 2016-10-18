require 'net/http'
require 'httparty'
require 'json'

class HoldingsController < ApplicationController

  def create
    @portfolio = Portfolio.find(params[:portfolio_id])
    @holding = Holding.new(holding_params)
    @holding.portfolio = @portfolio
    url = 'http://download.finance.yahoo.com/d/quotes.csv?s=' + @holding.symbol + '&f=pyt8kjj1e7e8s7a2'
    response = HTTParty.get(url)
    data = response.rstrip.split(',')
    @holding.price_close = data[0].to_f
    @holding.div_yield = data[1].to_f
    @holding.year_target = data[2].to_f
    @holding.year_high = data[3].to_f
    @holding.year_low = data[4].to_f
    magnitude = data[5].slice!(-1)
    @holding.market_cap = data[5].to_f
    if magnitude == "M"
      @holding.market_cap /= 1000
    end
    @holding.avg_volume = data[9].to_i
    @holding.eps_current = data[6].to_f
    @holding.eps_next = data[7].to_f
    @holding.short_ratio = data[8].to_f

    user = current_user
    if user_signed_in?
      if @holding.save
        flash[:notice] = 'Holding created successfully'
      else
        flash[:notice] = @holding.errors.full_messages.join(', ')
      end
      redirect_to @portfolio
    else
      flash[:notice] = 'Please sign in'
      redirect_to new_user_session_path
    end
  end

  def show
    @holding = Holding.find(params[:id])
  end

  def edit
    @holding = Holding.find(params[:id])
    if current_user != @holding.user
      flash[:notice] = 'You cannot edit this holding'
      redirect_to @holding.portfolio
    end
  end

  def update
    @holding = Holding.find(params[:id])
    if @holding.user == current_user
      if @holding.update_attributes(holding_params)
        flash[:notice] = 'Holding successfully edited'
        redirect_to @holding.portfolio
      else
        flash[:notice] = @holding.errors.full_messages.join(', ')
        render 'edit'
      end
    end
  end

  def destroy
    holding = Holding.find(params[:id])
    portfolio = holding.portfolio
    if holding.user == current_user || current_user.admin
      holding.destroy
      flash[:notice] = 'Holding successfully deleted'
      redirect_to portfolio
    end
  end

  def sign_in
    flash[:notice] = "Please sign in"
    redirect_to new_user_session_path
  end

  private

  def holding_params
    params.require(:holding).permit(:symbol, :number_shares, :purchase_price, :portfolio_id)
  end

end
