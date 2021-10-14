//
//  EVNFillTextCommand.m
//  graphics
//
//  Created by 1 on 2019/10/28.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "EVNFillTextCommand.h"
#import "EVNGraphicsUtil.h"

@interface EVNFillTextCommand()

@property (nonatomic, strong) NSDictionary *attr;

@property (nonatomic, copy) NSString *text;

@end

@implementation EVNFillTextCommand

- (instancetype)initWithCommand:(NSDictionary *)cmd canvasWidth:(CGFloat)canvasWidth canvasHeight:(CGFloat)canvasHeight previousRect:(CGRect)previousRect {
  self = [super initWithCommand:cmd canvasWidth:canvasWidth canvasHeight:canvasHeight previousRect:previousRect];
  
  if (self) {
    self.text = [self.params objectForKey:@"text"];
    
    NSMutableDictionary *attr = [NSMutableDictionary dictionaryWithDictionary:@{
                          NSFontAttributeName: [UIFont systemFontOfSize:14],
                          NSForegroundColorAttributeName:[UIColor blackColor],
                          NSBackgroundColorAttributeName:[UIColor clearColor],
                          }];
    
    
    NSDictionary *style = [self.params objectForKey:@"style"];

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    NSNumber *lineHeight = [style valueForKey:@"lineHeight"];
    if (lineHeight) {
      paragraphStyle.lineSpacing = lineHeight.floatValue;
    }
    
    NSString *textAlign = [style valueForKey:@"textAlign"];
    if ([@"center" isEqualToString:textAlign]) {
      paragraphStyle.alignment = NSTextAlignmentCenter;
    } else if ([@"left" isEqualToString:textAlign]) {
      paragraphStyle.alignment = NSTextAlignmentLeft;
    } else if ([@"right" isEqualToString:textAlign]) {
      paragraphStyle.alignment = NSTextAlignmentRight;
    }

    attr[NSParagraphStyleAttributeName] = paragraphStyle;
    
    NSString *textDecorationLine = [style valueForKey:@"textDecorationLine"];
    
    if (textDecorationLine) {
      NSString *key = NSUnderlineStyleAttributeName;
      NSUnderlineStyle sedStyle = NSUnderlineStyleNone;
      if ([@"underline" isEqualToString:textDecorationLine]) {
        key = NSUnderlineStyleAttributeName;
      } else if ([@"line-through" isEqualToString:textDecorationLine]) {
        key = NSStrikethroughStyleAttributeName;
      }
      
      NSString *textDecorationStyle = [style valueForKey:@"textDecorationStyle"];
      
      if (textDecorationStyle) {
        if ([@"solid" isEqualToString:textDecorationStyle]) {
          sedStyle = NSUnderlineStylePatternSolid;
        } else if ([@"double" isEqualToString:textDecorationStyle]) {
          sedStyle = NSUnderlineStyleDouble;
        } else if ([@"dotted" isEqualToString:textDecorationStyle]) {
          sedStyle = NSUnderlineStylePatternDot;
        } else if ([@"dashed" isEqualToString:textDecorationStyle]) {
          sedStyle = NSUnderlineStylePatternDash;
        }
      }
      
      attr[key] = [NSNumber numberWithInteger:NSUnderlineStyleSingle | sedStyle];
    }

    NSString *textDecorationColorStr = [style valueForKey:@"textDecorationColor"];
    if (textDecorationColorStr) {
      UIColor *color = [EVNGraphicsUtil colorFromHex:textDecorationColorStr];
      if (color)  attr[NSUnderlineColorAttributeName] = color;
    }
    
    NSString *colorStr = [style valueForKey:@"color"];
    if (colorStr) {
      UIColor *color = [EVNGraphicsUtil colorFromHex:colorStr];
      if (color)  attr[NSForegroundColorAttributeName] = color;
    }
    
    NSString *backgroundColorStr = [style valueForKey:@"backgroundColor"];
    if (backgroundColorStr) {
      UIColor *color = [EVNGraphicsUtil colorFromHex:backgroundColorStr];
      if (color)  attr[NSBackgroundColorAttributeName] = color;
    }
    
    NSNumber *fontSize = [style valueForKey:@"fontSize"];
    NSString *fontWeight = [style valueForKey:@"fontWeight"];
    if (fontSize) {
      UIFont *font = [@"bold" isEqualToString:fontWeight] ? [UIFont boldSystemFontOfSize:fontSize.floatValue] : [UIFont systemFontOfSize:fontSize.floatValue];
      attr[NSFontAttributeName] = font;
    }
    
    CGFloat top = [style valueForKey:@"top"] ? [[style valueForKey:@"top"] floatValue] : CGRectGetMaxY(self.previousRect);
    CGFloat left = [style valueForKey:@"left"] ? [[style valueForKey:@"left"] floatValue] : CGRectGetMaxX(self.previousRect);
    CGFloat width = [[style valueForKey:@"width"] floatValue];
    CGFloat height = [[style valueForKey:@"height"] floatValue];
    
    CGSize textSize = [self.text sizeWithAttributes:attr];
    CGFloat maxWidth = self.canvasWidth - left;
    CGFloat maxHeight = self.canvasHeight - top;
    if (width == 0) {
      width = MIN(textSize.width, maxWidth);
    }
    
    if (height == 0) {
      height = MIN(textSize.height, maxHeight);
    }
    
    self.attr = attr;
    
    CGFloat marginTop = [[style objectForKey:@"marginTop"] floatValue];
    CGFloat marginLeft = [[style objectForKey:@"marginLeft"] floatValue];
    CGFloat marginBottom = [[style objectForKey:@"marginBottom"] floatValue];
    CGFloat marginRight = [[style objectForKey:@"marginRight"] floatValue];
    self.rect = CGRectMake(left + marginLeft, top + marginTop, width - marginRight, height - marginBottom);
  }
  
  return self;
}

- (void)excute:(CGContextRef)context {
  [self.text drawInRect:self.rect withAttributes:self.attr];
}

@end
