  var app = angular.module('App', ['ngMaterial', 
                                   'btford.socket-io',
                                   'ui.router']);

  app.config(function($mdThemingProvider) {
    $mdThemingProvider.theme('default')
      .primaryPalette('grey')
      .accentPalette('blue')
      .warnPalette('red')

  });

  app.factory('mySocket', function (socketFactory) {
        return socketFactory();
  });

  app.controller('AppController', function($mdSidenav) {
    var vm = this;
    vm.toggleSidenav = function(menuId) {
      $mdSidenav(menuId).toggle();
    };
  });

  app.controller('NavButtons', function ($scope) {
    $scope.submit1 = function () { 
      alert ("Alert TEST"); 
    };
    $scope.testButton = function (path) {
      $location.path(path);
    };
  });

  app.controller('ArduController', function ($scope, mySocket) {

        $scope.data = {
          cb1: false,
          intensity: 0,
          red: 0,
          blue: 0,
          green: 0
        };

        $scope.message = 'false';

        $scope.onRGBChange = function(data) {
          console.log("Intensity: " + data.intensity + " Red: " + data.red + " Blue: " + data.blue + " Green: " + data.green );
          mySocket.emit("rgb", data);
        }

        $scope.onChange = function(cbState) {
         
          // For LED toggle
          if (cbState === true) {
            mySocket.emit('led:on');
            console.log('LED ON');
            $scope.message = cbState;
          } else {
            mySocket.emit('led:off');
            console.log('LED OFF');
            $scope.message = cbState;
          }; 

        };
  
        $scope.ledOn = function () {
            mySocket.emit('led:on');
            console.log('LED ON');
        };

        $scope.ledOff = function () {
            mySocket.emit('led:off');
            console.log('LED OFF');
        };

        mySocket.on('key', function(msg) {
          console.log("got key pressed on " + msg );
          $scope.qs1 = "TRUE";
        });

        mySocket.on('alert', function(msg) {
          //alert(msg);
          console.log("alerted of LED ON click...");
          $scope.clicked = "WAS CLICKED";
        });
  });

  app.config(function($stateProvider, $urlRouterProvider) {

      $urlRouterProvider.otherwise('/home');

      $stateProvider

        .state('home', {
          url: '/home',
          templateUrl: 'partials/main.html'
          })
        .state('test', {
          url: '/test',
          templateUrl: 'partials/test.html'
          })
        .state('ardy', {
          url: '/ardy',
          templateUrl: 'partials/ardy.html'
        });
  });
