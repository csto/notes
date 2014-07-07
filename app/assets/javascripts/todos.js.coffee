app = angular.module "Todos", ["ngSanitize", "ngRoute", "ngResource", "ngTouch", 'ng-rails-csrf', 'ui.sortable']

app.config [
  "$routeProvider"
  ($routeProvider) ->
    $routeProvider.when(
      "/notes",
      templateUrl: "../assets/notes/index.html"
      controller: "NotesIndexCtrl"
    ).when(
      "/notes/new"
      templateUrl: "../assets/notes/show.html"
      controller: "NotesShowCtrl"
    ).when(
      "/notes/:noteId",
      templateUrl: "../assets/notes/show.html"
      controller: "NotesShowCtrl"
    ).otherwise redirectTo: "/notes"
]