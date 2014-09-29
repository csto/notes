app = angular.module "Todos"

# Fixes ng-view nested inside of ng-include...silly angular
app.run(['$route', angular.noop]);

app.service "Note", ["$resource", ($resource) ->
  $resource("/notes/:id", {id: "@id"}, {update: {method: "PUT"}, archive: {url: '/notes/:id/archive', method: 'POST'}})
]

app.service "Notes", [ ->
  notes = {}
  notes.all = []
  notes.current = null
  
  notes.setNotes = (all) ->
    notes.all = all
    
  notes.addNote = (note) ->
    notes.all.push(note)
    notes.current = _.last(notes.all)
    
  notes.deleteNote = (note) ->
    notes.all.splice(_.indexOf(notes.all, note), 1)
    
  notes.setCurrent = (note) ->
    notes.current = notes.all[_.indexOf(notes.all, note)]
    notes.current.images = [] if !notes.current.images
    notes.current.tasks = [] if !notes.current.tasks
    
  notes.removeCurrent = ->
    notes.current = null
    
  notes.setCurrentAttr = (attr, value) ->
    notes.current[attr] = value
    
  notes.addObj = (attr, obj) ->
    notes.current[attr].push(obj)
    
  notes.removeObj = (attr, obj) ->
    notes.current[attr].splice(_.indexOf(notes.current[attr], obj), 1)
  
  return notes
]

app.service "Task", ["$resource", ($resource) ->
  $resource("/tasks/:id", {id: "@id"})
]

app.service "Image", ["$resource", ($resource) ->
  $resource("/images/:id", {id: "@id"})
]

app.controller 'NotesCtrl', ['$rootScope', "$scope", "Note", 'Notes', "Task", 'Image', '$upload', '$timeout', '$window', '$http', 'Flash', ($rootScope, $scope, Note, Notes, Task, Image, $upload, $timeout, $window, $http, Flash) ->
  console.log 'NotesCtrl loaded'
  
  $scope.closeSidebar = (event) ->
    if ($(event.target).parents('#sidebar, #menu').length == 0) && !_.contains(['sidebar', 'menu'], $(event.target).attr('id'))
      if $scope.openMenu
        $scope.openMenu = false
        event.stopPropagation()
  
  $scope.sortableOptions = 
    start: (e, ui) ->
      $('body').addClass('no-animate')
      
    stop: (e, ui) ->
      console.log e
      $('body').removeClass('no-animate')
      for task, index in $rootScope.currentNote.tasks
        task.position = index
      $scope.updateNote($rootScope.currentNote.id, $rootScope.currentNote)

    axis: "y",
    handle: '.fa-bars'

  $scope.current_task = null
  $scope.search = {}
  $scope.new_task = {}
  
  $scope.getNoteIndex = (id) ->
    for note, index in $scope.notes
      if note.id == id
        return index
  
  $scope.query = (archived) ->
    console.log 'query'
    $scope.search.archived = archived
    if $scope.notes
      $scope.toIndex()
    else
      Note.query {}, (response) ->
        $scope.notes = response
        $scope.toIndex
        console.log $scope.notes
       
  $scope.toIndex = ->
    console.log 'toIndex'
    $('.note input, .note textarea').prop('disabled', true)
    $('.note').height('auto')
    $('.note > div').css(top: 'auto', minHeight: '0px', height: 'auto').css(
        transform: "translateY(0px)",
        MozTransform: "translateY(0px)",
        WebkitTransform: "translateY(0px)",
        msTransform: "translateY(0px)",
        width: 'auto'
      )
    for note, index in $scope.notes
      if !note.id
        $scope.notes.splice(index, 1)
        Flash.add('Note discarded.')
      $rootScope.currentNote = null
      $scope.current_task = null
  
  $scope.searchClick = ->
    $scope.show_search = true
    $('#search input').focus()
    
  $scope.setCurrentNote = (note) ->
    if !$rootScope.currentNote
      $('.note input, .note textarea').prop('disabled', false)
      $rootScope.currentNote = $scope.notes[_.indexOf($scope.notes, note)]
      
    
  $scope.buildNote = (kind) ->
    console.log 'building note'
    if kind == 'Image'
      kind = 'Note'
      image = true
    $scope.notes.push({title: null, content: null, kind: kind, archived: false})
    $rootScope.currentNote = $scope.notes[$scope.notes.length - 1]
    
    $timeout ->
      element = $('.new')
      app.openNote(element)
    $scope.selectFile() if image
    
  $scope.updateNote = () ->
    console.log 'update note'
    if !$rootScope.currentNote.id
      console.log 'saving'
      $rootScope.currentNote.images = [] if !$rootScope.currentNote.images
      $rootScope.currentNote.tasks = [] if !$rootScope.currentNote.tasks
      position = _.min _.map($scope.notes, (note) ->
        note.position
      )
      $rootScope.currentNote.position = position - 1
      Note.save {note: $rootScope.currentNote}, (response) ->
        $rootScope.currentNote.id = response.id
        
    else
      console.log 'updating'
      Note.update {id: $rootScope.currentNote.id, note: $rootScope.currentNote}, (response) ->
        console.log 'updated'
        for task, index in $rootScope.currentNote.tasks
          if task._destroy == true
            $rootScope.currentNote.tasks.splice(index, 1)
  
  $scope.archive = ->
    console.log 'archive'
    if $rootScope.currentNote
      Note.archive {id: $rootScope.currentNote.id}, ->
        $scope.toIndex()
  
  $scope.delete = ->
    console.log 'delete'
    if $rootScope.currentNote
      $scope.notes.splice($scope.getNoteIndex($rootScope.currentNote.id), 1)
      Note.delete {id: $rootScope.currentNote.id}
      $scope.toIndex()
      
  $scope.createTask = (id) ->
    console.log 'create task'
    note = $scope.notes[$scope.getNoteIndex(id)]
    if $scope.new_task && $scope.new_task.content
      if !note.tasks
        note.tasks = []
      $scope.new_task.position = 999999
      $scope.new_task.completed = false
      $scope.new_task.note_id = id
      Task.save {task: $scope.new_task}, (response) ->
        note.tasks.push(response)
        $scope.new_task = {}
        
  $scope.selectFile = ->
    $('.select-file').click()
    return true
        
  $scope.onFileSelect = ($files) ->
    $rootScope.currentNote.images = [] if !$rootScope.currentNote.images
    for file in $files
      reader = new FileReader()
      file_path = null
      reader.onload = (e) =>
        file_path = e.target.result
        $scope.$apply () =>
          $rootScope.currentNote.images.push {file_path: file_path}
      reader.readAsDataURL file
            
      $scope.upload = $upload.upload(
        url: "notes/#{$rootScope.currentNote.id}/images"
        file: file
      ).progress((e) ->
        console.log "percent: " + parseInt(100.0 * e.loaded / e.total)
      ).success((data, status, headers, config) ->
        index = _.indexOf($rootScope.currentNote.images, _.findWhere($rootScope.currentNote.images, {file_path: file_path}))
        # add all but file_path so it doesn't flicker
        $rootScope.currentNote.images[index] = data
      )
  
  $scope.openImage = (image) ->
    if $rootScope.currentNote
      console.log 'opening image'
      $('.modal-contents').html("<img src='#{image.file_path.replace("original", "full")}'/>")
      $('.modal').show()
      return
      
  $scope.closeModal = ->
    console.log 'closing modal'
    $('.modal').hide()
    return
      
  
  $scope.removeImage = (image) ->
    console.log image
    Image.delete(id: image.id)
    $rootScope.currentNote.images = _.without($rootScope.currentNote.images, image)
    
  $scope.swipe = (event) ->
    console.log event
    
  $scope.share = (email) ->
    console.log 'share'
    email = ''
    $http(
      method: 'POST',
      url: "/notes/#{$scope.currentNote.id}/user_notes",
      data:
        email: email
    ).success().error()
    
  $scope.query(false)
    
]

app.openNote = (element) ->
  $parent = element.parent()
  $parent.height($parent.height())
  scrollTop = $('#notes-wrapper').scrollTop()
  top = ($parent.offset().top - 50 + scrollTop)
  element.css(top: "#{top}px", minHeight: (window.innerHeight - 50), height: (window.innerHeight - 50))
  element.addClass('expand')
  # find distance from top to header
  animateDistance = -($parent.offset().top - 50)
  element.css(
    transform: "translate(-15px, #{animateDistance }px)",
    MozTransform: "translate(-15px, #{animateDistance }px)",
    WebkitTransform: "translate(-15px, #{animateDistance }px)",
    msTransform: "translate(-15px, #{animateDistance }px)",
    width: "#{window.outerWidth}px"
  )
  
app.directive 'ngFullscreen', ['$animate', '$window', ($animate, $window) ->
  return (scope, element, attrs) ->
    element.on 'click', ->
      if !scope.currentNote
        app.openNote(element)
]

app.directive 'focusMe', ['$timeout', ($timeout) -> 
  scope:
    trigger: "=focusMe"

  link: (scope, element) ->
    scope.$watch "trigger", (value) ->
      if value is true
        $timeout ->
          element[0].focus()
]

app.directive 'backImg', ->
  return (scope, element, attrs) ->
    url = attrs.backImg
    element.css('background-image': "url('#{url}')")
    
app.directive 'resize', ['$window', '$rootScope', ($window, $rootScope) ->
  link: (scope, element, attrs) ->
    angular.element($window).on 'resize', ->
      if $rootScope.currentNote
        element.css
          width: $window.outerWidth
          height: $window.outerHeight - 50
]

app.directive 'show-close', ['$timeout', ($timeout) -> 
  link: (scope, element) ->
    element.parents('.modal').on 'mousemove', ->
      console.log 'mousemove'
      element.show()
      $timeout ->
        element.hide()
      , 500
]

