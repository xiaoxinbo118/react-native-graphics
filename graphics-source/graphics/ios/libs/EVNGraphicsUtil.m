//
//  EVNUtil.m
//  graphics
//
//  Created by 1 on 2019/10/28.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "EVNGraphicsUtil.h"

@implementation EVNGraphicsUtil

+ (UIColor *)colorFromHex:(NSString *)jsHex {
  NSString *colorStr = [jsHex stringByReplacingOccurrencesOfString:@"#" withString:@"0x"];
  unsigned long hexValue = strtoul([colorStr UTF8String], 0, 16);
  
  return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                         green:((float)((hexValue & 0xFF00) >> 8))/255.0
                          blue:((float)(hexValue & 0xFF))/255.0 alpha:1];
}

@end
