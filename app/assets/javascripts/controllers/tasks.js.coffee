app = angular.module "Todos"

app.factory "Task", ["$resource", ($resource) ->
  $resource("/tasks/:id", {id: "@id"}, {update: {method: "PUT"}})
]

app.controller 'TasksCtrl', ["$scope", "Task", "$routeParams", ($scope, Task, $routeParams) ->
  
  $scope.updateTask = (task) ->
    Task.update(id: task.id, task: task)

  $scope.deleteTask = (id) ->
    console.log 'deleting'
    Task.delete {id: id}

]