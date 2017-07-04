require 'rails_helper'

feature 'User creates portfolio' do
  let!(:user) { FactoryGirl.create(:user) }
  context 'As an authenticated user' do
    scenario 'User can navigate to a page to create a new portfolio' do
      visit root_path
      user_sign_in(user)
      click_link 'My Portfolios'

      click_link 'Add a Portfolio'

      expect(current_path).to eq(new_portfolio_path)
    end

    scenario 'User cannot create a new portfolio if not logged in' do
      visit new_portfolio_path

      expect(page).to have_content('Please sign in')
    end

    scenario 'User successfully creates a portfolio' do
      user_sign_in(user)
      visit new_portfolio_path
      fill_in 'Title', with: 'Title'
      click_button 'Create Portfolio'

      expect(page).to have_content 'Portfolio was successfully created'
      expect(page).to have_content 'Title'
    end

    scenario 'User successfully creates a portfolio with cash' do
      user_sign_in(user)
      visit new_portfolio_path
      fill_in 'Title', with: 'Title'
      fill_in 'Cash', with: 100000
      click_button 'Create Portfolio'

      expect(page).to have_content 'Portfolio was successfully created'
      expect(page).to have_content 'Title'
    end

    scenario 'User gets an error if they don\'t provide a title' do
      user_sign_in(user)
      visit new_portfolio_path
      fill_in 'Cash', with: 100000
      click_button 'Create Portfolio'

      expect(page).to have_content('Title can\'t be blank')
    end
  end
end
