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

require 'spec_helper'

describe Task do
  pending "add some examples to (or delete) #{__FILE__}"
end
