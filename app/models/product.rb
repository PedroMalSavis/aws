class Product < ApplicationRecord
  belongs_to :user, optional: true
  has_one_attached :image
  # has_many_attached :images
end
