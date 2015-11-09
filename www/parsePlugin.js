var exec = require('cordova/exec');

exports.initialize = function(appId, clientKey, success, error) {
    exec(success, error, "ParsePlugin", "initialize", [appId, clientKey]);
};

exports.save = function(className, toSave, success, error) {
    exec(success, error, "ParsePlugin", "save", [className, toSave]);
};
exports.get = function(className, id, success, error) {
    exec(success, error, "ParsePlugin", "get", [className, id]);
};
