//
//  EVNBaseCommand.h
//  graphics
//
//  Created by 1 on 2019/10/27.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface EVNCommand : NSObject

- (instancetype)initWithCommand:(NSDictionary *)cmd canvasWidth:(CGFloat)canvasWidth canvasHeight:(CGFloat)canvasHeight previousRect:(CGRect)previousRect;
+ (instancetype)commandWithCommand:(NSDictionary *)cmd canvasWidth:(CGFloat)canvasWidth canvasHeight:(CGFloat)canvasHeight previousRect:(CGRect)previousRect;


@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSDictionary *params;

@property (nonatomic, assign) CGRect previousRect;
@property (nonatomic, assign) CGRect rect;

@property (atomic, strong) NSError *error;

@property (nonatomic, assign) CGFloat canvasWidth;
@property (nonatomic, assign) CGFloat canvasHeight;

- (dispatch_block_t)prepareBlock;

- (void)excute:(CGContextRef)context;

@end

NS_ASSUME_NONNULL_END
