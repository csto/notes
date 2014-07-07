# == Schema Information
#
# Table name: user_elements
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  element_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class UserElement < ActiveRecord::Base
  belongs_to :user
  belongs_to :element
end
