class ImageUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "uploads/images/" +
    "#{model.profile.name.to_slug.normalize(transliterations: [:ukrainian, :russian]).to_s}_" +
    "#{model.profile.surname.to_slug.normalize(transliterations: [:ukrainian, :russian]).to_s}"
  end

  def extension_white_list
    %w(jpg jpeg JPG JPEG)
  end

  def filename
    "#{model.position}"+
    "_#{model.profile.name.to_slug.normalize(transliterations: [:ukrainian, :russian]).to_s}"+
    "_#{model.profile.surname.to_slug.normalize(transliterations: [:ukrainian, :russian]).to_s}"+
    "_#{model.title.to_slug.normalize(transliterations: [:ukrainian, :russian]).to_s}"+
    "_#{model.profile.city.to_slug.normalize(transliterations: [:ukrainian, :russian]).to_s}"+
    ".#{model.file.file.extension}"
  end
end
