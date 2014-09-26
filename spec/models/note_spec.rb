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

require 'spec_helper'

describe Note do
  pending "add some examples to (or delete) #{__FILE__}"
end
