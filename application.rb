# frozen_string_literal: true

require 'sinatra'
require_relative 'environment'

get '/' do
  haml :root
end

post '/save_profile' do
  birthday = begin
    DateTime.strptime(params[:birthday], '%d.%m.%Y')
  rescue StandardError
    status 406
    'Дата народження повинна бути в формати dd.mm.yyyy'
  end

  profile = Profile.new(
    params.slice(
      :name,
      :surname,
      :zip_code,
      :city,
      :address,
      :phone,
      :email,
      :region,
      :site,
      :photo_alliance,
      :position,
      :skype,
      :facebook
    ).merge(birthday: birthday)
  )

  logger.info "New profile #{profile.inspect}"

  if profile.save
    session[:profile_id] = profile.id.to_s
    return
  else
    status 406
    logger.warn "Profile validation errors #{profile.errors.values.join(', ')}"
    profile.errors.values.join(', ')
  end
end

def send_mails
  subject = "Реєстрація #{@profile.name} #{@profile.surname} на бієнале «Природа»"
  mail_options = {
    from: SiteConfig.smtp_user_name,
    via: :smtp,
    via_options: {
      address:               SiteConfig.smtp_server,
      port:                  SiteConfig.smtp_port,
      enable_starttls_auto:  true,
      user_name:             SiteConfig.smtp_user_name,
      password:              SiteConfig.smtp_password,
      authentication:        :plain, # :plain, :login, :cram_md5, no auth by default
      domain:                SiteConfig.smtp_domain # the HELO domain provided by the client to the server
    }
  }.freeze

  Pony.mail(
    mail_options.merge(
      to: SiteConfig.smtp_to,
      subject: subject,
      html_body: haml(:email, layout: false)
    )
  )

  Pony.mail(
    mail_options.merge(
      to: @profile.email,
      subject: subject,
      html_body: haml(:email_for_user, layout: false)
    )
  )
rescue Net::SMTPFatalError => e
  logger.error "Could not send an email: #{@profile.email}"
  logger.error "Backtrace:\n#{e.backtrace.join("\n")}"
end

post '/upload' do
  @profile = Profile.where(id: session[:profile_id]).first

  unless @profile
    logger.warn "Could not find profile by session id #{session[:profile_id]}"
    status 406
    return 'Не знайдено профіль'
  end

  @profile.photos = []

  Photo::CATEGORIES.size.times do |ci|
    position = 1

    Photo::PER_CATEGORY.times do |i|
      input_index = ci * Photo::PER_CATEGORY + i

      next unless params["image#{input_index}"]

      @profile.photos << Photo.new(
        profile: @profile,
        file:  params["image#{input_index}"],
        title: params["title#{input_index}"] || "фото #{input_index}",
        position: position,
        category: params["category#{input_index}"]
      )
      position += 1
    end
  end

  if @profile.photos.present? && @profile.save
    logger.info "Uploaded photos #{@profile.photos.size}"
    if @profile.free?
      @profile.update!(paid: false, payment_status: 'безплатно')
      send_mails

      'success'
    else
      # uncomment next to enable payment
      # @profile.payment_form

      # make payment
      send_mails
      "pay/#{@profile.rate}"
    end
  else
    status 406
    er_message = @profile.errors.values.join(', ')
    er_message || 'Перевірте розширення та розміри файлів'
  end
end

post '/payment/:id' do
  @profile = Profile.where(id: params[:id]).first
  if @profile.signature_valid?(params[:signature], params[:data])
    @profile.update!(paid: true, payment_status: JSON.parse(Base64.decode64(params[:data]))['status'])

    send_mails
  else
    logger.warn "Invalid payment siggnature for profile #{@profile.inspect}"
    logger.warn "Signature #{params[:signature].inspect}"
    logger.warn "Data #{params[:data].inspect}"
  end
end

get '/success' do
  haml :success
end

get '/pay/:rate' do
  @rate = params[:rate]

  haml :pay
end
