class AddressForm < BaseForm
  attr_accessor :first_name, :last_name, :address, :city, :zip, :country, :phone,
                :address_type, :addressable

  ONLY_LETTERS_FORMAT = /\A[A-Za-z\s]+\z/.freeze
  ADDRESS_FORMAT = /\A[a-zA-Z0-9\s,\-]+\z/.freeze
  ZIP_FORMAT = /\A[0-9\-]+\z/.freeze
  PHONE_FORMAT = /\A\+[0-9]{1,3}\s?[0-9]{2}\s?[0-9]{3}\s?[0-9]{4}\z/.freeze
  FIFTY_LENGTH = 50
  ZIP_LENGTH = 10
  PHONE_LENGTH = 16

  validates :first_name, :last_name, :address, :city, :zip, :country, :phone, :address_type, presence: true
  validates :first_name, :last_name, :address, :city, length: { maximum: FIFTY_LENGTH }
  validates :first_name, :last_name, :city, format: { with: ONLY_LETTERS_FORMAT }
  validates :address, format: { with: ADDRESS_FORMAT }
  validates :zip, length: { maximum: ZIP_LENGTH }, format: { with: ZIP_FORMAT }
  validates :phone, length: { maximum: PHONE_LENGTH }, format: { with: PHONE_FORMAT }
  validate :country_code_of_the_selected_country, if: -> { phone.present? }
  validate :country_from_the_above, if: -> { country.present? }

  def self.from_address(address)
    return new unless address

    address_attributes = address.attributes.except('id', 'user_id', 'created_at', 'updated_at',
                                                   'addressable_id', 'addressable_type')
    new(address_attributes)
  end

  def submit
    case address_type.to_sym
    when :billing then addressable.billing_address = Address.new(@params)
    when :shipping then addressable.shipping_address = Address.new(@params)
    end
  end

  private

  def country_from_the_above
    errors.add(:country, :invalid) if ISO3166::Country.find_country_by_name(country).nil?
  end

  def country_code_of_the_selected_country
    selected_country = ISO3166::Country.find_country_by_name(country)
    errors.add(:phone, :invalid) if selected_country.present? && phone.exclude?("+#{selected_country.country_code}")
  end
end
