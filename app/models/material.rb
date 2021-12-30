class Material < ApplicationRecord
  include Rails.application.routes.url_helpers
  has_one_attached :image
  has_one_attached :file

  validate :acceptable_image

  def image_url
    image.attached? ? url_for(image) : nil
  end

  def file_url
    file.attached? ? url_for(file) : nil
  end

  def falsify_any_active
    if self.active
        self.class.where('id != ? and active', self.id).update_all("active = 'false'")
    end
  end

  def acceptable_image
    return unless image.attached?

    unless image.byte_size <= 1.megabyte
      errors.add(:image, "is too big")
    end

    acceptable_types = ["image/jpeg", "image/png"]
    unless acceptable_types.include?(image.content_type)
      errors.add(:image, "must be a JPEG or PNG")
    end
  end
end