class Flag < ApplicationRecord

  belongs_to :flaggable, polymorphic: true
  belongs_to :user

end
