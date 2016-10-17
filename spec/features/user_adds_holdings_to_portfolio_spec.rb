require 'rails_helper'

feature 'User creates portfolio' do
  let!(:user) { FactoryGirl.create(:user) }
  context 'As an authenticated user' do

    scenario 'User successfully adds holding to portfolio with purchase data' do
      user_sign_in(user)
      visit new_portfolio_path
      fill_in 'Title', with: 'Title'
      click_button 'Create Portfolio'

      fill_in 'Stock Symbol', with: 'GOOGL'
      fill_in 'Number shares', with: 100
      fill_in 'Price per share', with: 800
      fill_in 'Cash', with: 10000
      click_button 'Add holding'

      expect(page).to have_content 'GOOGL'
      expect(page).to have_content '90000'
    end

    scenario 'User successfully adds holding to portfolio without purchase data' do
      user_sign_in(user)
      visit new_portfolio_path
      fill_in 'Title', with: 'Title'
      click_button 'Create Portfolio'
      click_button 'Add a holding'
      fill_in 'Stock Symbol', with: 'FB'

      expect(page).to have_content('FB')
    end
  end
end
