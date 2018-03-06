require 'rails_helper'

RSpec.feature "Visitor navigates to home page", type: :feature, js: true do

  # SETUP
  before :each do
      @user = User.create!({
        first_name: 'Zushi',
        last_name: 'San',
        email: 'zushi@san.com',
        password: '123456',
        password_confirmation: '123456'
      })
    end

  scenario "They click a product and see that product page" do
    # ACT
    visit root_path
    click_link 'Login'

    find('.login-form')

    fill_in 'email', with: @user.email
    fill_in 'password', with: @user.password
    click_on 'Submit'

    find('.navbar')

    
    # VERIFY
    expect(page).to have_css '.signed-in-as', text: "Signed in as Zushi"
    # DEBUG
    save_screenshot
  end
end

