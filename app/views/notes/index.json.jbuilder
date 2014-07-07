json.array! @notes do |note|
  json.merge! note.attributes
  json.tasks note.tasks, :id, :position, :content, :completed
end