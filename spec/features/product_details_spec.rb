require 'rails_helper'

RSpec.feature "Visitor navigates to home page", type: :feature, js: true do

  # SETUP
  before :each do
    @category = Category.create! name: 'Apparel'

    1.times do |n|
      @category.products.create!(
        name:  Faker::Hipster.sentence(3),
        description: Faker::Hipster.paragraph(4),
        image: open_asset('apparel1.jpg'),
        quantity: 10,
        price: 64.99
      )
    end
  end

  scenario "They click a product and see that product page" do
    # ACT
    visit root_path
    click_link 'Details'

    find('.main-img')['complete']

    
    # VERIFY
    expect(page).to have_css 'article.product-detail'
    # DEBUG
    save_screenshot
  end
end
