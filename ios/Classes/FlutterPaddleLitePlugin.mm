#import "FlutterPaddleLitePlugin.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#include "../Headers/Private/paddle_api.h"
#include "../Headers/Private/paddle_use_ops.h"
#include "../Headers/Private/paddle_use_kernels.h"
#import "Timer.h"

using namespace paddle::lite_api;

@interface FlutterPaddleLitePlugin ()
@property(nonatomic) NSObject <FlutterPluginRegistrar> *registar;
@property(nonatomic) NSMutableDictionary *predictorInstances;
@end

@implementation FlutterPaddleLitePlugin
+ (void)registerWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel
            methodChannelWithName:@"flutter_paddle_lite"
                  binaryMessenger:[registrar messenger]];
    FlutterPaddleLitePlugin *instance = [[FlutterPaddleLitePlugin alloc] initWithRegistar:registrar];
    [registrar addMethodCallDelegate:instance channel:channel];

}

- (instancetype)initWithRegistar:(NSObject <FlutterPluginRegistrar> *)registar {
    self = [super init];
    if (self) {
        _registar = registar;
        _predictorInstances = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([@"getPlatformVersion" isEqualToString:call.method]) {
        result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    } else if ([@"createPredictor" isEqualToString:call.method]) {
        NSString *modelPath = call.arguments;
        NSString *key = [self.registar lookupKeyForAsset:modelPath];
        NSString *path = [[NSBundle mainBundle] pathForResource:key ofType:nil];
        NSLog(@"model path: %@", path);
        if (path == nil) {
            return result([FlutterError errorWithCode:@"1" message:@"Model not found" details:nil]);
        }
        MobileConfig* mobileConfig = new MobileConfig();
        mobileConfig->set_power_mode(LITE_POWER_FULL);
        mobileConfig->set_threads((int) [[NSProcessInfo processInfo] activeProcessorCount]);
        mobileConfig->set_model_from_file([path UTF8String]);

        std::shared_ptr <PaddlePredictor> predictor = CreatePaddlePredictor<MobileConfig>(
                *mobileConfig);
        NSString *instanceId = [[NSUUID UUID] UUIDString];
        NSValue *predictorValue = [NSValue valueWithPointer:(void *) new std::shared_ptr<PaddlePredictor>(
                predictor)];
        self.predictorInstances[instanceId] = predictorValue;

        return result(instanceId);
    } else if ([@"runImagePrediction" isEqualToString:call.method]) {
        NSString *instanceId = call.arguments[@"instanceId"];
        NSArray *inputData = call.arguments[@"inputData"];
        NSArray *inputShape = call.arguments[@"inputShape"];

        NSValue *predictorValue = self.predictorInstances[instanceId];
        if (!predictorValue) {
            return result(
                    [FlutterError errorWithCode:@"2" message:@"Predictor not found" details:nil]);
        }

        std::shared_ptr <PaddlePredictor> *predictorPtr = (std::shared_ptr < PaddlePredictor > *)
        [predictorValue pointerValue];
        std::shared_ptr <PaddlePredictor> predictor = *predictorPtr;

        auto inputTensor = predictor->GetInput(0);

        // Set input shape
        std::vector <int64_t> shape;
        for (NSNumber *dim in inputShape) {
            shape.push_back([dim longLongValue]);
        }
        inputTensor->Resize(shape);

        // Set input data
        auto *data = inputTensor->mutable_data<float>();
        for (NSUInteger i = 0; i < inputData.count; ++i) {
            data[i] = [inputData[i] floatValue];
        }

        Timer *tic =[[Timer alloc] init];
        [tic start];
        predictor->Run();
        [tic end];

        // Get output
        auto outputTensor = predictor->GetOutput(0);
        auto outputShape = outputTensor->shape();
        int64_t outputSize = 1;
        for (int64_t dim: outputShape) {
            outputSize *= dim;
        }

        auto *outputData = outputTensor->data<float>();

        NSMutableArray *outputArray = [NSMutableArray arrayWithCapacity:(NSUInteger) outputSize];
        for (int64_t i = 0; i < outputSize; ++i) {
            [outputArray addObject:@(outputData[i])];
        }

        result(outputArray);
    } else if ([@"disposePredictor" isEqualToString:call.method]) {
        NSString *instanceId = call.arguments;
        NSValue *predictorValue = self.predictorInstances[instanceId];
        if (!predictorValue) {
            return result(
                    [FlutterError errorWithCode:@"2" message:@"Predictor not found" details:nil]);
        }

        std::shared_ptr <PaddlePredictor> *predictorPtr = (std::shared_ptr < PaddlePredictor > *)
        [predictorValue pointerValue];
        delete predictorPtr;

        [self.predictorInstances removeObjectForKey:instanceId];

        result(nil);
    } else {
        result(FlutterMethodNotImplemented);
    }
}

@end
