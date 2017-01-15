'use strict'

###*
 # @ngdoc function
 # @name swarmApp.controller:AchievementsCtrl
 # @description
 # # AchievementsCtrl
 # Controller of the swarmApp
###
angular.module('swarmApp').controller 'AchievementsCtrl', ($scope, game, $location, $log) ->
  $scope.game = game
  game.session.state.achievementsShown ?=
    earned: true
    unearned: true
    masked: true
    order: 'default'
    reverse: false
  $scope.form =
    show: _.clone game.session.state.achievementsShown

  preds =
    'default': (achievement) -> achievement.earnedAtMillisElapsed()
    percentComplete: (achievement) -> achievement.progressOrder()
  $scope.order =
    pred: preds[$scope.form.show.order]
  $scope.onChangeVisibility = ->
    $scope.order.pred = preds[$scope.form.show.order]
    game.withUnreifiedSave ->
      game.session.state.achievementsShown = _.clone $scope.form.show

  $scope.state = (achievement) ->
    if achievement.isEarned()
      return 'earned'
    return 'unearned'
  $scope.isVisible = (achievement) ->
    state = $scope.state achievement
    if state == 'earned'
      return $scope.form.show.earned
    else if state == 'unearned'
      return $scope.form.show.unearned
    else
      return $scope.form.show.masked
  
  $scope.achieveclick = (achievement) ->
    $log.debug 'achieveclick', achievement
    $scope.$emit 'achieveclick', achievement
