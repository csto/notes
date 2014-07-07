app = angular.module "Todos"

app.factory "Note", ["$resource", ($resource) ->
  $resource("/notes/:id", {id: "@id"}, {update: {method: "PUT"}})
]

app.controller 'NotesIndexCtrl', ["$scope", "Note", "$routeParams", ($scope, Note, $routeParams) ->
  $scope.notes = Note.query $routeParams, (response) ->
    console.log response

  $scope.query = (search) ->
    Note.query {"q[title_matches]": search, "q[elementable_content_cont]": search}, (response) ->
      $scope.notes = response
]

app.controller 'ListsCtrl', ["$rootScope", "$scope", "$routeParams", "List", ($rootScope, $scope, $routeParams, List) ->
  if $routeParams.listId
    $scope.list = List.get {id: $routeParams.listId}, (response) ->
      $rootScope.element_id = response.element.id
      
]

app.controller 'NotesShowCtrl', ["$location", "$scope", "$routeParams", "Note", ($location, $scope, $routeParams, Note) ->
  
  if $routeParams.noteId
    $scope.note = Note.get {id: $routeParams.noteId}, (response) ->
      $scope.isList = true if response.kind == 'List'
  
  if $routeParams.list
    $scope.isList = true
    $scope.note = {kind: 'List'}
  
  $scope.updateNote = ->
    if !$scope.note || !$scope.note.id
      Note.save {note: $scope.note}, (response) ->
        $scope.note = response
    else
      Note.update {id: $scope.note.id, note: $scope.note}
  
  $scope.archive = (id) ->
    Note.archive {id: id}, ->
      $location.path("/notes")
  
  $scope.delete = (id) ->
    Note.delete {id: id}, ->
      $location.path("/notes")
      
  $scope.sortableOptions = 
    stop: (e, ui) ->
      for task, index in $scope.list.tasks
        task.position = index
      $scope.updateNote()

    axis: "y",
    handle: '.fa-bars'
      
  $scope.createTask = ->
    if !$scope.note.tasks
      $scope.note.tasks = []
    $scope.note.new_task.position = 999999
    $scope.note.tasks.push($scope.note.new_task)
    $scope.note.new_task = null
    $scope.updateNote()
      
  $scope.deleteTask = (id) ->
    Note.delete {id: id}
]