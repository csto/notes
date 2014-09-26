app = angular.module "Todos"

# Fixes ng-view nested inside of ng-include...silly angular
app.run(['$route', angular.noop]);

app.factory "Note", ["$resource", ($resource) ->
  $resource("/notes/:id", {id: "@id"}, {update: {method: "PUT"}, archive: {url: '/notes/:id/archive', method: 'POST'}})
]

app.factory "Task", ["$resource", ($resource) ->
  $resource("/tasks/:id", {id: "@id"})
]

app.factory "Image", ["$resource", ($resource) ->
  $resource("/images/:id", {id: "@id"})
]

app.controller 'NotesCtrl', ['$rootScope', "$scope", "Note", "Task", 'Image', '$upload', '$timeout', '$window', '$http', 'Flash', ($rootScope, $scope, Note, Task, Image, $upload, $timeout, $window, $http, Flash) ->
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
      for task, index in $rootScope.current_note.tasks
        task.position = index
      $scope.updateNote($rootScope.current_note.id, $rootScope.current_note)

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
    $('.note input, .note textarea').prop('disabled', true)
    $('.note').height('auto')
    $('.note > div').css(top: 'auto', minHeight: '0px', height: 'auto').css(
        transform: "translateY(0px)",
        MozTransform: "translateY(0px)",
        WebkitTransform: "translateY(0px)",
        msTransform: "translateY(0px)",
        width: 'auto'
      )
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
    for note, index in $scope.notes
      if !note.id
        $scope.notes.splice(index, 1)
        Flash.add('Note discarded.')
      $rootScope.current_note = null
      $scope.current_task = null
  
  $scope.searchClick = ->
    $scope.show_search = true
    $('#search input').focus()
    
  $scope.setCurrentNote = (note) ->
    if !$rootScope.current_note
      $('.note input, .note textarea').prop('disabled', false)
      $rootScope.current_note = note
      
    
  $scope.buildNote = (kind) ->
    console.log 'building note'
    if kind == 'Image'
      kind = 'Note'
      image = true
    $scope.notes.push({title: null, content: null, kind: kind, archived: false})
    $rootScope.current_note = $scope.notes[$scope.notes.length - 1]
    
    $timeout ->
      element = $('.new')
      app.openNote(element)
    $scope.selectFile() if image
    
  $scope.updateNote = () ->
    console.log 'update note'
    if !$rootScope.current_note.id
      console.log 'saving'
      $rootScope.current_note.images = [] if !$rootScope.current_note.images
      $rootScope.current_note.tasks = [] if !$rootScope.current_note.tasks
      position = _.min _.map($scope.notes, (note) ->
        note.position
      )
      $rootScope.current_note.position = position - 1
      Note.save {note: $rootScope.current_note}, (response) ->
        $rootScope.current_note.id = response.id
        
    else
      console.log 'updating'
      Note.update {id: $rootScope.current_note.id, note: $rootScope.current_note}, (response) ->
        console.log 'updated'
        for task, index in $rootScope.current_note.tasks
          if task._destroy == true
            $rootScope.current_note.tasks.splice(index, 1)
  
  $scope.archive = ->
    console.log 'archive'
    if $rootScope.current_note
      Note.archive {id: $rootScope.current_note.id}, ->
        $scope.toIndex()
  
  $scope.delete = ->
    console.log 'delete'
    if $rootScope.current_note
      $scope.notes.splice($scope.getNoteIndex($rootScope.current_note.id), 1)
      Note.delete {id: $rootScope.current_note.id}
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
    $rootScope.current_note.images = []
    for file in $files
      reader = new FileReader()
      file_path = null
      reader.onload = (e) =>
        file_path = e.target.result
        $scope.$apply () =>
          $rootScope.current_note.images.push {file_path: file_path}
      reader.readAsDataURL file
            
      $scope.upload = $upload.upload(
        url: "notes/#{$rootScope.current_note.id}/images"
        file: file
      ).progress((e) ->
        console.log "percent: " + parseInt(100.0 * e.loaded / e.total)
      ).success((data, status, headers, config) ->
        index = _.indexOf($rootScope.current_note.images, _.findWhere($rootScope.current_note.images, {file_path: file_path}))
        $rootScope.current_note.images[index] = data
      )
  
  $scope.open = (size, image) ->
    if $rootScope.current_note
      $('.modal-dialog img').height($(window).height() - 100)
      modalInstance = $modal.open
        templateUrl: 'imageModal.html',
        controller: ModalInstanceCtrl,
        size: size,
        resolve:
          options: ->
            return {
              size: size,
              image: image
            }
  
  $scope.removeImage = (image) ->
    console.log image
    Image.delete(id: image.id)
    $rootScope.current_note.images = _.without($rootScope.current_note.images, image)
    
  $scope.swipe = (event) ->
    console.log event
    
  $scope.share = (email) ->
    email = 'coreystout@hotmail.com'
    $http(
      method: 'POST',
      url: "/users/#{email}/user_notes"
    ).success().error()
    
  $scope.query(false)
    
]


app.directive 'ngFullscreen', ['$animate', '$window', ($animate, $window) ->
  return (scope, element, attrs) ->
    element.on 'click', ->
      if !scope.current_note
        app.openNote(element)
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

