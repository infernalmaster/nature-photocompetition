# frozen_string_literal: true

# User profile
class Profile
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,      type:      String
  field :surname,   type:      String

  field :zip_code,  type:      String
  field :region,    type:      String
  field :city,      type:      String
  field :address,   type:      String
  field :phone,     type:      String
  field :email,     type:      String

  field :site,      type:      String
  field :photo_alliance, type: Boolean, default: false
  field :position,  type:      String
  field :skype,     type:      String
  field :facebook,  type:      String
  field :paid,      type:      Boolean, default: false
  field :payment_status, type: String

  field :birthday,  type:      DateTime

  has_many :photos

  validates_presence_of :name, :surname, :region, :zip_code,
                        :city, :address, :phone, :email, :birthday

  def payment_form
    Liqpay.new.cnb_form(
      version: 3,
      action: 'pay',
      amount: rate,
      currency: 'UAH',
      description: "#{name.to_slug.normalize(transliterations: %i[ukrainian russian])} #{surname.to_slug.normalize(transliterations: %i[ukrainian russian])}",
      order_id: order_id,
      language: 'uk',
      server_url: "#{SiteConfig.url_base}/payment/#{id}",
      result_url: "#{SiteConfig.url_base}/success",
      sandbox: SiteConfig.sandbox
    )
  end

  def signature_valid?(recieved_signature, recieved_data)
    Liqpay.new.match?(recieved_data, recieved_signature)
  end

  def free?
    birthday && (birthday >= DateTime.new(1999, 4, 25))
  end

  def age_category
    return 'дорослі' if !birthday || (birthday <= DateTime.new(1999, 4, 24))

    birthday <= DateTime.new(2004, 4, 24) ? '16 до 20р' : '15р і менше'
  end

  def rate
    if photos.group_by(&:category).size > 1
      photo_alliance ? 150 : 200
    else
      photo_alliance ? 100 : 150
    end
  end

  protected

  def order_id
    Time.now.to_s.parameterize + id.to_s
  end
end
