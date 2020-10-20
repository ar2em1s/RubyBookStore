class Order < ApplicationRecord
  include AASM

  belongs_to :user, optional: true
  has_many :order_items, dependent: :destroy
  has_one :order_coupon, dependent: :destroy
  has_one :coupon, through: :order_coupon
  has_one :billing_address, -> { where(address_type: :billing) },
          inverse_of: :addressable, as: :addressable, class_name: 'Address', dependent: :destroy
  has_one :shipping_address, -> { where(address_type: :shipping) },
          inverse_of: :addressable, as: :addressable, class_name: 'Address', dependent: :destroy
  has_one :order_delivery_type, dependent: :destroy
  has_one :delivery_type, through: :order_delivery_type
  has_one :card, dependent: :destroy

  scope :uncompleted, -> { where(state: %i[addresses delivery payment confirm complete]) }
  scope :in_progress, -> { where(state: %i[in_queue in_delivery]) }
  scope :delivered, -> { where(state: :delivered) }
  scope :canceled, -> { where(state: :canceled) }

  enum state: {
    addresses: 0, delivery: 1, payment: 2, confirm: 3, complete: 4,
    in_queue: 5, in_delivery: 6, delivered: 7, canceled: 8
  }

  aasm column: :state, enum: true do
    state :addresses, initial: true
    state :delivery, :payment, :confirm, :complete,
          :in_queue, :in_delivery, :delivered, :canceled

    event(:addresses_step)   { transitions from: :confirm, to: :addresses }
    event(:delivery_step)    { transitions from: %i[addresses confirm], to: :delivery }
    event(:payment_step)     { transitions from: %i[delivery confirm], to: :payment }
    event(:confirm_step)     { transitions from: :payment, to: :confirm }
    event(:complete_step)    { transitions from: :confirm, to: :complete }
    event(:in_queue_step)    { transitions from: :complete, to: :in_queue }
    event(:in_delivery_step) { transitions from: :in_queue, to: :in_delivery }
    event(:delivered_step)   { transitions from: %i[in_queue in_delivery], to: :delivered }
    event(:canceled_step)    { transitions from: %i[in_queue in_delivery delivered], to: :canceled }
  end
end
