# example model file
class Profile
  include DataMapper::Resource

  property :id,             Serial
  property :name,           String
  property :surname,        String

  property :zip_code,       String
  property :region,         String
  property :city,           String
  property :address,        String
  property :phone,          String
  property :email,          String

  property :site,           String
  property :photo_alliance, Boolean, default: false
  property :position,       String
  property :skype,          String
  property :facebook,       String
  property :paid,           Boolean, default: false

  property :created_at,     DateTime
  property :updated_at,     DateTime

  property :birthday,       DateTime

  has n, :photos
  validates_presence_of :photos, when: [:with_photos]

  validates_presence_of :name, :surname, :region, :zip_code,
                        :city, :address, :phone, :email, :birthday

  def payment_form
    Liqpay.new.cnb_form(request_params)
  end

  def signature_valid?(recieved_signature, recieved_data)
    Liqpay.new.match?(recieved_data, recieved_signature)
  end

  def free?
    birthday && (birthday >= DateTime.new(1997, 4, 25))
  end

  def age_category
    return 'дорослі' if !birthday || (birthday <= DateTime.new(1997, 4, 24))

    birthday <= DateTime.new(2002, 4, 24) ? '16 до 20р' : '15р і менше'
  end

  protected

    def rate
      self.photo_alliance ? 100 : 150
    end

    def request_params
      {
        version: 3,
        action: 'pay',
        amount: rate,
        currency: 'UAH',
        description: "#{self.name.to_slug.normalize(transliterations: [:ukrainian, :russian]).to_s} #{self.surname.to_slug.normalize(transliterations: [:ukrainian, :russian]).to_s}",
        order_id: order_id,
        language: 'uk',
        server_url: "#{SiteConfig.url_base}payment/#{self.id}",
        result_url: "#{SiteConfig.url_base}success",
        sandbox: SiteConfig.sandbox
      }
    end

    def order_id
      Time.now.to_s.parameterize + self.id.to_s
    end
end
