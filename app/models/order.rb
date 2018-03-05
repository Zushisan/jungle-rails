class Order < ActiveRecord::Base

  after_create :order_success

  belongs_to :user
  has_many :line_items

  monetize :total_cents, numericality: true

  validates :stripe_charge_id, presence: true

  def order_success
    self.line_items.each do |line_item|
      if p = Product.find_by(id: line_item.product.id)
        p.quantity = p.quantity - 1
        p.save!
      end
    end
  end

end
