# == Schema Information
#
# Table name: tasks
#
#  id         :integer          not null, primary key
#  note_id    :integer
#  content    :string(255)
#  completed  :boolean          default(FALSE)
#  position   :integer          default(0)
#  created_at :datetime
#  updated_at :datetime
#

class Task < ActiveRecord::Base
  belongs_to :note
end
