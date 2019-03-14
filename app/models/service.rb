class Service < ApplicationRecord
  belongs_to :user, optional: true
end
