# frozen_string_literal: true

class ImageUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    File.join('uploads', 'images', latiniza(model.category), user_folder)
  end

  def extension_white_list
    %w[jpg jpeg JPG JPEG]
  end

  def filename
    [
      model.position.to_s,
      latiniza(model.profile.name),
      latiniza(model.profile.surname),
      latiniza(model.title),
      latiniza(model.profile.city)
    ].join('_') + ".#{model.file.file.extension}"
  end

  private

  def user_folder
    [
      latiniza(model.profile.name),
      latiniza(model.profile.surname)
    ].join('_')
  end

  def latiniza(text)
    text.to_slug.normalize(transliterations: %i[ukrainian russian]).to_s
  end
end
