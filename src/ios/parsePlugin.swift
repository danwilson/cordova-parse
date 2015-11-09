import Foundation
import Parse

@objc(ParsePlugin) class ParsePlugin : CDVPlugin {
    func initialize(command: CDVInvokedUrlCommand) {
        let message = "Initialized";
        let appId = command.arguments[0] as! String;
        let clientKey = command.arguments[1] as! String;

        Parse.enableLocalDatastore()

        // Initialize Parse.
        Parse.setApplicationId(appId, clientKey: clientKey)

        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: message);
        commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId);
    }

    func save(command: CDVInvokedUrlCommand) {
        let message = "Saved";
        let className = command.arguments[0] as! String;
        let properties = command.arguments[1] as! NSDictionary;

        let obj = PFObject(className:className);

        for (key, value) in properties {
            print("key: \(key), value: \(value)")
            obj[key as! String] = value
        }

        obj.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in

            var pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: message);
            if (!success) {
                pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: error!.description);
            }
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId);
        }
    }

    func get(command: CDVInvokedUrlCommand) {
        let className = command.arguments[0] as! String;
        let id = command.arguments[1] as! String;

        let query = PFQuery(className:className);
        query.getObjectInBackgroundWithId(id) {
            (obj: PFObject?, error: NSError?) -> Void in

            var pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: "success");
            if error == nil && obj != nil {
                let dict = Dictionary<String, String>();

                pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsDictionary: dict);
            } else {
                pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: error!.description);
            }
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId);
        }
    }
}
