# == Schema Information
#
# Table name: images
#
#  id                :integer          not null, primary key
#  note_id           :integer
#  created_at        :datetime
#  updated_at        :datetime
#  file_file_name    :string(255)
#  file_content_type :string(255)
#  file_file_size    :integer
#  file_updated_at   :datetime
#

class Image < ActiveRecord::Base
  belongs_to :image
  
  has_attached_file :file, :styles => { full: "2000x2000>", :medium => "240x240>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :file, :content_type => /\Aimage\/.*\Z/
end
