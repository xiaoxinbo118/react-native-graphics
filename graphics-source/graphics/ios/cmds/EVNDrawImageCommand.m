//
//  EVNDrawImageCommand.m
//  graphics
//
//  Created by 1 on 2019/10/30.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "EVNDrawImageCommand.h"
#import "SDWebImage.h"

@interface EVNDrawImageCommand()

@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation EVNDrawImageCommand

- (instancetype)initWithCommand:(NSDictionary *)cmd canvasWidth:(CGFloat)canvasWidth canvasHeight:(CGFloat)canvasHeight previousRect:(CGRect)previousRect {
  self = [super initWithCommand:cmd canvasWidth:canvasWidth canvasHeight:canvasHeight previousRect:previousRect];
  
  if (self) {
    self.url = [cmd valueForKey:@"imageUrl"];
    CGFloat x = [[cmd valueForKey:@"x"] floatValue];
    CGFloat y = [[cmd valueForKey:@"y"] floatValue];
    CGFloat w = [[cmd valueForKey:@"w"] floatValue];
    CGFloat h = [[cmd valueForKey:@"h"] floatValue];
    
    self.rect = CGRectMake(x, y, w, h);
    self.imageView = [[UIImageView alloc] init];
  }
  
  return self;
}

- (dispatch_block_t)prepareBlock {
  return ^{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0); //创建信号量
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.url] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
      self.error = error;
      dispatch_semaphore_signal(semaphore);   //发送信号
    }];
    
    dispatch_semaphore_wait(semaphore,DISPATCH_TIME_FOREVER);  //等待
  };
}

- (void)excute:(CGContextRef)context {
  [self.imageView.image drawInRect:self.rect];
}

@end
