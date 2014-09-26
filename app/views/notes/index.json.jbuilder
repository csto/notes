json.array! @notes do |note|
  json.merge! note.attributes
  json.tasks note.tasks, :id, :position, :content, :completed
  json.images note.images do |image|
    json.id image.id
    json.file_path image.file.url
  end
end