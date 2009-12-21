# == Schema Information
#
# Table name: decisions
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#

class Decision < ActiveRecord::Base
  has_many :produits
end

