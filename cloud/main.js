var UserLikedShows = Parse.Object.extend('UserLikedShows');

Parse.Cloud.beforeSave('UserLikedShows', function(request, response) {

  if (!request.object.isNew()) {
  	response.success();
  }

  var query = new Parse.Query(UserLikedShows);
  query.equalTo('user', Parse.User.current());
  query.equalTo('showId', request.object.get('showId'));
  query.first().then(function(existingObject) {
      if (existingObject) {
        return existingObject.save();
      } else {
        return Parse.Promise.as(false);
      }
    }).then(function(existingObject) {
      if (existingObject) {
        response.error("Existing object");
      } else {
        response.success();
      }
    }, function (error) {
      response.error("Error performing checks or saves.");
    });
});

var UserSavedShows = Parse.Object.extend('UserSavedShows');

Parse.Cloud.beforeSave('UserSavedShows', function(request, response) {

  if (!request.object.isNew()) {
  	response.success();
  }

  var query = new Parse.Query(UserSavedShows);
  query.equalTo('user', Parse.User.current());
  query.equalTo('showId', request.object.get('showId'));
  query.first().then(function(existingObject) {
      if (existingObject) {
        return existingObject.save();
      } else {
        return Parse.Promise.as(false);
      }
    }).then(function(existingObject) {
      if (existingObject) {
        response.error("Existing object");
      } else {
        response.success();
      }
    }, function (error) {
      response.error("Error performing checks or saves.");
    });
});

var UserWatchedEpisodes = Parse.Object.extend('UserWatchedEpisodes');

Parse.Cloud.beforeSave('UserWatchedEpisodes', function(request, response) {

  if (!request.object.isNew()) {
  	response.success();
  }

  var query = new Parse.Query(UserWatchedEpisodes);
  query.equalTo('user', Parse.User.current());
  query.equalTo('showId', request.object.get('showId'));
  query.equalTo('seasonNumber', request.object.get('seasonNumber'));
  query.equalTo('episodeNumber', request.object.get('episodeNumber'));
  query.first().then(function(existingObject) {
      if (existingObject) {
        return existingObject.save();
      } else {
        return Parse.Promise.as(false);
      }
    }).then(function(existingObject) {
      if (existingObject) {
        response.error("Existing object");
      } else {
        response.success();
      }
    }, function (error) {
      response.error("Error performing checks or saves.");
    });
});
