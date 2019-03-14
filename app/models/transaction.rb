class Transaction < ApplicationRecord
  belongs_to :user, optional: true
end
