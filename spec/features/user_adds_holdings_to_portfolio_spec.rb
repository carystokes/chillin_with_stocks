require 'rails_helper'

feature 'User creates portfolio' do
  let!(:user) { FactoryGirl.create(:user) }
  context 'As an authenticated user' do

    scenario 'User successfully adds holding to portfolio with purchase data' do
      user_sign_in(user)
      visit new_portfolio_path
      fill_in 'Title', with: 'Title'
      click_button 'Create Portfolio'

      fill_in 'Symbol', with: 'GOOGL'
      fill_in 'Number shares', with: 100
      fill_in 'Purchase price', with: 800
      click_button 'Add holding'

      expect(page).to have_content 'GOOGL'
      expect(page).to have_content '80000'
    end

    scenario 'User successfully adds holding to portfolio without purchase data' do
      user_sign_in(user)
      visit new_portfolio_path
      fill_in 'Title', with: 'Title'
      click_button 'Create Portfolio'
      fill_in 'Symbol', with: 'FB'
      click_button 'Add holding'

      expect(page).to have_content('FB')
    end
  end
end
