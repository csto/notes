# == Schema Information
#
# Table name: notes
#
#  id         :integer          not null, primary key
#  content    :text
#  created_at :datetime
#  updated_at :datetime
#

class Note < ActiveRecord::Base
  has_many :tasks, -> { order('position ASC, created_at ASC') }, dependent: :destroy
  accepts_nested_attributes_for :tasks
end
