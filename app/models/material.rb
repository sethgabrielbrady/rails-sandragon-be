class Material < ApplicationRecord
  include Rails.application.routes.url_helpers
  has_one_attached :image
  # has_many_attached :files

  def image_url
    image.attached? ? url_for(image) : nil
  end

  # def file_url
  #   file.attached? ? url_for(file) : nil
  # end

  def falsify_any_active
    if self.active
        self.class.where('id != ? and active', self.id).update_all("active = 'false'")
    end
  end
end