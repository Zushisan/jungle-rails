require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'After creation' do
    before :each do
      # Setup at least two products with different quantities, names, etc
      cat1 = Category.find_or_create_by! name: 'Apparel'

      @product1 = cat1.products.create!({
        name:  'Super Zushi Shirt',
        description: 'A cool shirt with a cat',
        quantity: 7,
        price: 64.99
      })

      @product2 = cat1.products.create!({
        name:  'Super Brushy Brush',
        description: 'A cool brush that brush',
        quantity: 18,
        price: 124.99
      })

      @product3 = cat1.products.create!({
        name:  'A bag that fly',
        description: 'Look at it goooooo',
        quantity: 4,
        price: 34.49
      })
      # Setup at least one product that will NOT be in the order
    end
    # pending test 1
    it 'deducts quantity from products based on their line item quantities' do
      # TODO: Implement based on hints below
      # 1. initialize order with necessary fields (see orders_controllers, schema and model definition for what is required)
      @order = Order.new(      
        email: 'zushi@email.com',
        total_cents: 777,
        stripe_charge_id: '7498651313'
      ) # returned by stripe)

      # 2. build line items on @order
      @order.line_items.new(
        product: @product1,
        quantity: @product1.quantity,
        item_price: @product1.price,
        total_price: 777
      )
      @order.line_items.new(
        product: @product2,
        quantity: @product2.quantity,
        item_price: @product2.price,
        total_price: 777
      )
      @order.line_items.new(
        product: @product2,
        quantity: @product2.quantity,
        item_price: @product2.price,
        total_price: 777
      )

      # 3. save! the order - ie raise an exception if it fails (not expected)
      @order.save!
      # 4. reload products to have their updated quantities
      @product1.reload
      @product2.reload
      # 5. use RSpec expect syntax to assert their new quantity values
      expect(@product1.quantity).to eq(6)
      expect(@product2.quantity).to eq(16)
      
    end
    # pending test 2
    it 'does not deduct quantity from products that are not in the order' do
      # TODO: Implement based on hints in previous tes
      @order = Order.new(      
        email: 'zushi@email.com',
        total_cents: 777,
        stripe_charge_id: '7498651313'
      ) # returned by stripe)

      # 2. build line items on @order
      @order.line_items.new(
        product: @product1,
        quantity: @product1.quantity,
        item_price: @product1.price,
        total_price: 777
      )
      @order.line_items.new(
        product: @product2,
        quantity: @product2.quantity,
        item_price: @product2.price,
        total_price: 777
      )

      # 3. save! the order - ie raise an exception if it fails (not expected)
      @order.save!

      @product3.reload
      expect(@product3.quantity).to eq(4)
    end
  end
end
