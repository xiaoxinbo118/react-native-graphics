//
//  RNGraphics.m
//  graphics
//
//  Created by 1 on 2019/10/27.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "RNGraphics.h"
#import "EVNCmdExcutor.h"


@implementation RNGraphics

- (dispatch_queue_t)methodQueue
{
  return dispatch_get_main_queue();
}
RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(draw:(NSArray *)cmds
                  width:(NSInteger)width
                  height:(NSInteger)height
                  ignoreImageDownloadError:(BOOL)ignoreImageDownloadError
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject
                  ) {
  EVNCmdExcutor *excutor = [[EVNCmdExcutor alloc] initWithCommands:cmds width:width height:height ignoreImageDownloadError:ignoreImageDownloadError];
  
  [excutor excute:^(NSString * _Nullable localPath, NSError * _Nullable error) {
    if (error) {
      reject([NSString stringWithFormat:@"%@", @(error.code)], error.localizedFailureReason, error);
    } else {
      resolve(localPath);
    }
  }];
}


@end
