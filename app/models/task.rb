# == Schema Information
#
# Table name: tasks
#
#  id         :integer          not null, primary key
#  list_id    :integer
#  content    :string(255)
#  completed  :boolean          default(FALSE)
#  created_at :datetime
#  updated_at :datetime
#

class Task < ActiveRecord::Base
  belongs_to :list
end
