class Page < ActiveRecord::Base
  def title_or_permalink
    title.nil? ? permalink : title
  end
end

# == Schema Information
# Schema version: 20101021093522
#
# Table name: pages
#
#  id         :integer         primary key
#  permalink  :string(255)
#  content    :text
#  created_at :timestamp
#  updated_at :timestamp
#  title      :string(255)
#

