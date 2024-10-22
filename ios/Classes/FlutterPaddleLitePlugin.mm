#import "FlutterPaddleLitePlugin.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#include "../Headers/Private/paddle_api.h"
#include "../Headers/Private/paddle_use_ops.h"
#include "../Headers/Private/paddle_use_kernels.h"

using namespace paddle::lite_api;

@interface FlutterPaddleLitePlugin ()
@property (nonatomic) MobileConfig *mobileConfig;
@end

@implementation FlutterPaddleLitePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"flutter_paddle_lite"
                                     binaryMessenger:[registrar messenger]];
    FlutterPaddleLitePlugin* instance = [[FlutterPaddleLitePlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];

}

- (instancetype) init {
    self = [super init];
    if(self) {
        _mobileConfig = new MobileConfig();
        _mobileConfig->set_power_mode(LITE_POWER_FULL);
        _mobileConfig->set_threads((int)[[NSProcessInfo processInfo] activeProcessorCount]);
    }
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"getPlatformVersion" isEqualToString:call.method]) {
        result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    } else if([@"setModel" isEqualToString: call.method]) {
        NSString *modelPath = call.arguments[@"modelPath"];
        _mobileConfig->set_model_from_file(modelPath.UTF8String);
        result(nil);
    } else {
        result(FlutterMethodNotImplemented);
    }
}

@end
