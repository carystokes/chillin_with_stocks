class PortfoliosController < ApplicationController
  def index
    @portfolios = Portfolio.all
  end

  def show
    @portfolio = set_portfolio
    @holding = Holding.new
    @holdings = @portfolio.holdings
  end

  def new
    if current_user.nil?
      redirect_to portfolios_path, notice: "Please sign in"
    else
      @portfolio = Portfolio.new
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
      if @portfolio.errors.any?
        @warning = @portfolio.errors.full_messages.join(", ")
        render :new
      end
    end
  end

  def update
    @portfolio = Portfolio.create(portfolio_params)
    if @portfolio.update(portfolio_params)
      redirect_to @portfolio, notice: 'Portfolio was successfully updated.'
    else
      render :new, notice: 'Portfolio was not updated.'
    end
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

    def portfolio_params
      params.require(:portfolio).permit(:title)
    end
end