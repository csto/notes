# == Schema Information
#
# Table name: notes
#
#  id         :integer          not null, primary key
#  position   :integer          default(0)
#  kind       :string(255)      default("Note")
#  title      :string(255)
#  content    :text
#  color      :string(255)
#  archived   :boolean          default(FALSE)
#  created_at :datetime
#  updated_at :datetime
#

class Note < ActiveRecord::Base
  
  has_many :user_notes
  has_many :users, through: :user_notes
  
  has_many :tasks, -> { order('position ASC, created_at ASC') }, dependent: :destroy
  has_many :images, -> { order('created_at ASC') }, dependent: :destroy
  
  accepts_nested_attributes_for :tasks, allow_destroy: true
end
