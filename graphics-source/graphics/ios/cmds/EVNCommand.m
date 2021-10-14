//
//  EVNBaseCommand.m
//  graphics
//
//  Created by 1 on 2019/10/27.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "EVNCommand.h"
#import "EVNFillTextCommand.h"
#import "EVNDrawImageCommand.h"
#import "EVNDrawBarcodeCommand.h"

NSString *const kCmdFillText = @"fillText";
NSString *const kCmdDrawImage = @"drawImage";
NSString *const kCmdDrawBarcode = @"drawBarcode";

@implementation EVNCommand

- (instancetype)initWithCommand:(NSDictionary *)cmd canvasWidth:(CGFloat)canvasWidth canvasHeight:(CGFloat)canvasHeight previousRect:(CGRect)previousRect {
  
  self = [super init];
  
  if (self) {
    _name = [cmd objectForKey:@"cmd"];
    _params = cmd;
    self.canvasWidth = canvasWidth;
    self.canvasHeight = canvasHeight;
    self.previousRect = previousRect;
  }
  
  return self;
}

+ (instancetype)commandWithCommand:(NSDictionary *)cmd canvasWidth:(CGFloat)canvasWidth canvasHeight:(CGFloat)canvasHeight previousRect:(CGRect)previousRect {
  EVNCommand *command;
  NSString *name = [cmd objectForKey:@"cmd"];
  if ([kCmdFillText isEqualToString:name]) {
    command = [[EVNFillTextCommand alloc] initWithCommand:cmd canvasWidth:canvasWidth canvasHeight:canvasHeight previousRect:previousRect];
  } else if ([kCmdDrawImage isEqualToString:name]) {
    command = [[EVNDrawImageCommand alloc] initWithCommand:cmd canvasWidth:canvasWidth canvasHeight:canvasHeight previousRect:previousRect];
  } else if ([kCmdDrawBarcode isEqualToString:name]) {
    command = [[EVNDrawBarcodeCommand alloc] initWithCommand:cmd canvasWidth:canvasWidth canvasHeight:canvasHeight previousRect:previousRect];
  } else {
    command = [[EVNCommand alloc] initWithCommand:cmd canvasWidth:canvasWidth canvasHeight:canvasHeight previousRect:previousRect];
  }
  
  return command;
}

- (dispatch_block_t)prepareBlock {
  return nil;
}

- (void)excute:(CGContextRef)context {
  
}

@end
