# frozen_string_literal: true

require 'image_uploader'

# Photo that user uploads
class Photo
  include Mongoid::Document

  CATEGORIES = [
    'Слід людини',
    'Пейзаж, флора і фауна',
    'Фото з висоти пташиного польоту'
  ].freeze

  PER_CATEGORY = 5

  field :title, type: String
  field :category, type: String
  field :position, type: Integer

  mount_uploader :file, ImageUploader

  belongs_to :profile

  validates_presence_of :file, :position, :category
  validates :category, inclusion: { in: CATEGORIES }

  # validates_with_method :validate_minimum_image_size
  #
  # def validate_minimum_image_size
  #   geometry = self.file.geometry
  #   if (!geometry.empty?) && geometry[:width] >= 2400 || geometry[:height] >= 2400
  #     return true
  #   else
  #     return [ false, "2400 px по довшій стороні мінімум" ]
  #   end
  # end
end
