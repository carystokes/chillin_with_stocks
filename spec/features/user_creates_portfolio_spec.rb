require 'rails_helper'

feature 'User creates recipe' do
  let!(:user) { FactoryGirl.create(:user) }
  context 'As an authenticated user' do
    scenario 'I can navigate to a page to create a new portfolio' do
      visit root_path
      user_sign_in(user)

      click_link 'Add a Porfolio'

      expect(current_path).to eq(new_portfolio_path)
    end

    scenario 'User cannot create a new portfolio if not logged in' do
      visit new_portfolio_path

      expect(page).to have_content('Please sign in')
    end

    scenario 'User successfully creates a portfolio with purchase data' do
      user_sign_in(user)
      visit new_portfolio_path
      fill_in 'Title', with: 'Title'
      fill_in 'Stock Symbol', with: 'GOOGL'
      fill_in 'Number of Shares', with: 100
      fill_in 'Purchase Price', with: 800
      click_button 'Save Portfolio'

      expect(page).to have_content 'Portfolio added successfully'
      expect(page).to have_content 'Title'
      expect(page).to have_content 'GOOGL'

    end

    scenario 'User successfully creates a portfolio without purchase data' do
      user_sign_in(user)
      visit new_portfolio_path
      fill_in 'Title', with: 'Title2'
      fill_in 'Stock Symbol', with: 'GOOGL'
      click_button 'Save Portfolio'

      expect(page).to have_content 'Portfolio added successfully'
      expect(page).to have_content 'Title2'
      expect(page).to have_content 'GOOGL'

    end

    scenario 'User gets an error if they don\'t provide a title' do
      user_sign_in(user)
      visit new_portfolio_path
      fill_in 'Stock Symbol', with: 'GOOGL'
      fill_in 'Number of Shares', with: 100
      fill_in 'Purchase Price', with: 800
      click_button 'Save Portfolio'

      expect(page).to have_content('Title can\'t be blank')

    end

    scenario 'User gets an error if they don\'t provide a stock symbol' do
      user_sign_in(user)
      visit new_portfolio_path
      fill_in 'Title', with: 'Title3'
      click_button 'Save Portfolio'

      expect(page).to have_content('You must provide at least one stock symbol')
    end
  end
end
