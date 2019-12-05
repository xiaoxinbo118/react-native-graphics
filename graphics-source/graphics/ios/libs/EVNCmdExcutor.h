//
//  EVNCmdExcutor.h
//  graphics
//
//  Created by 1 on 2019/10/28.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^draw_completion_block_t)(NSString * _Nullable localPath, NSError * _Nullable error);

NS_ASSUME_NONNULL_BEGIN

@interface EVNCmdExcutor : NSObject

- (instancetype)initWithCommands:(NSArray *)commands width:(CGFloat)width height:(CGFloat)height ignoreImageDownloadError:(BOOL)ignoreImageDownloadError;

- (void)excute:(draw_completion_block_t)completionBlock;

@end

NS_ASSUME_NONNULL_END
