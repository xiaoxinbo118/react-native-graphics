//
//  EVNCmdExcutor.m
//  graphics
//
//  Created by 1 on 2019/10/28.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "EVNCmdExcutor.h"
#import "EVNCommand.h"

@interface EVNCmdExcutor()

@property (nonatomic, strong) NSMutableArray *cmds;

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) BOOL ignoreImageDownloadError;

@end

@implementation EVNCmdExcutor

- (instancetype)initWithCommands:(NSArray *)commands
                           width:(CGFloat)width
                          height:(CGFloat)height
                            ignoreImageDownloadError:(BOOL)ignoreImageDownloadError
{
  self = [super init];
  
  if (self) {
    self.cmds = [NSMutableArray array];
    self.width = width;
    self.height = height;
    self.ignoreImageDownloadError = ignoreImageDownloadError;
    CGRect previousRect = CGRectZero;
    for (NSDictionary *item in commands) {
      EVNCommand *command = [EVNCommand commandWithCommand:item canvasWidth:width canvasHeight:height previousRect:previousRect];
      previousRect = command.rect;
      [self.cmds addObject:command];
    }
  }
  
  return self;
}

- (void)excute:(void(^)(NSString *localPath, NSError *error))completionBlock {
  dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
  dispatch_group_t group = dispatch_group_create();
  
  void (^drawBlock)(NSError *error) = ^(NSError *error){
    dispatch_async(dispatch_get_main_queue(), ^{
      if (error) {
        completionBlock(nil, error);
        return;
      }
      
      UIImage *resultImage = [self draw];
      NSString * tmpDir = NSTemporaryDirectory();
      NSString *pictureName = [NSString stringWithFormat:@"%@.jpeg", [[NSUUID UUID] UUIDString]];
      
      NSString *savedImagePath = [tmpDir stringByAppendingPathComponent:pictureName];
      
      dispatch_async(queue, ^{
        NSData *imageData = UIImageJPEGRepresentation(resultImage, 1);
        BOOL result = [imageData writeToFile:savedImagePath atomically:YES];//保存照片到沙盒目录
      
        dispatch_async(dispatch_get_main_queue(), ^{
          if (result) {
            completionBlock(savedImagePath, nil);
          } else {
            completionBlock(nil, [NSError errorWithDomain:@"file" code:-100 userInfo:@{NSLocalizedDescriptionKey : @"save to tmp failed"}]);
          }
        });
      });
    });
  };
  
  BOOL hasPrepare = NO;
  for (EVNCommand *cmd in self.cmds) {
    dispatch_block_t block = [cmd prepareBlock];
    
    if (block) {
      hasPrepare = YES;
      dispatch_group_async(group, queue, block);
    }
  }
  
  if (hasPrepare) {
    // 下载图片等准备资源
    dispatch_group_notify(group, queue, ^{
      if (self.ignoreImageDownloadError) {
        drawBlock(nil);
      } else {
        NSError *error = nil;
        for (EVNCommand *cmd in self.cmds) {
          if (cmd.error) {
            error = cmd.error;
            break;
          }
        }
        
        if (error) {
          drawBlock(error);
        } else {
          drawBlock(nil);
        }
      }
     
    });
  } else {
    drawBlock(nil);
  }
}

- (UIImage *)draw {
  UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.width, self.height), NO, 0);

  UIColor *blackColr = [UIColor whiteColor];
  [blackColr setFill];
  UIRectFill(CGRectMake(0, 0, self.width, self.height));
  CGContextRef context = UIGraphicsGetCurrentContext();
  for (EVNCommand *cmd in self.cmds) {
    [cmd excute:context];
  }
  
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return newImage;
}



@end
