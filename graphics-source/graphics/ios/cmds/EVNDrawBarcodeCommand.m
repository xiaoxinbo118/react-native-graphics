//
//  EVNDrawBarcodeCommand.m
//  graphics
//
//  Created by 1 on 2019/11/1.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "EVNDrawBarcodeCommand.h"
#import "SDWebImage.h"

@interface EVNDrawBarcodeCommand()

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *iconUrl;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, assign) CGFloat iconWidth;

@end

@implementation EVNDrawBarcodeCommand

- (instancetype)initWithCommand:(NSDictionary *)cmd canvasWidth:(CGFloat)canvasWidth canvasHeight:(CGFloat)canvasHeight previousRect:(CGRect)previousRect {
  self = [super initWithCommand:cmd canvasWidth:canvasWidth canvasHeight:canvasHeight previousRect:previousRect];
  
  if (self) {
    self.code = [cmd valueForKey:@"code"];
    CGFloat x = [[cmd valueForKey:@"x"] floatValue];
    CGFloat y = [[cmd valueForKey:@"y"] floatValue];
    CGFloat w = [[cmd valueForKey:@"w"] floatValue];
    CGFloat h = [[cmd valueForKey:@"h"] floatValue];
    
    self.rect = CGRectMake(x, y, w, h);
    self.iconUrl = [cmd valueForKey:@"iconUrl"];
    self.iconWidth = [[cmd valueForKey:@"iconWidth"] floatValue];
    self.iconImageView = [[UIImageView alloc] init];
  }
  
  return self;
}

- (dispatch_block_t)prepareBlock {
  NSURL *url = [NSURL URLWithString:self.iconUrl];
  if (url == nil) {
      return nil;
  }

  return ^{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0); //创建信号量
    [self.iconImageView sd_setImageWithURL:url completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//      self.error = error;
      dispatch_semaphore_signal(semaphore);   //发送信号
    }];
    
    dispatch_semaphore_wait(semaphore,DISPATCH_TIME_FOREVER);  //等待
  };
}

- (void)excute:(CGContextRef)context {
  UIImage *codeImage = [self erweima];
  [codeImage drawInRect:self.rect];
  
  if (self.iconImageView.image) {
      [self.iconImageView.image drawInRect:CGRectMake(self.rect.origin.x + (self.rect.size.width - self.iconWidth) / 2, self.rect.origin.y + (self.rect.size.height - self.iconWidth) / 2, self.iconWidth, self.iconWidth)];
  }
}

- (UIImage *) erweima {
  // 1. 实例化二维码滤镜
  CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
  // 2. 恢复滤镜的默认属性
  [filter setDefaults];
  
  // 3. 将字符串转换成NSData
  NSString *urlStr = self.code;//测试二维码地址,次二维码不能支付,需要配合服务器来二维码的地址(跟后台人员配合)
  NSData *data = [urlStr dataUsingEncoding:NSUTF8StringEncoding];
  // 4. 通过KVO设置滤镜inputMessage数据
  [filter setValue:data forKey:@"inputMessage"];
  
  // 5. 获得滤镜输出的图像
  CIImage *outputImage = [filter outputImage];
  
  // 6. 将CIImage转换成UIImage，并放大显示 (此时获取到的二维码比较模糊,所以需要用下面的createNonInterpolatedUIImageFormCIImage方法重绘二维码)
  //    UIImage *codeImage = [UIImage imageWithCIImage:outputImage scale:1.0 orientation:UIImageOrientationUp];
  UIImage *erweima = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:self.rect.size.width];//重绘二维码,使其显示清晰
  
  return erweima; //[self addIconToQRCodeImage:erweima withIcon:[UIImage imageNamed:@"erweima_logo"] withIconSize:CGSizeMake(20, 20)];
}

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size {
  CGRect extent = CGRectIntegral(image.extent);
  CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
  // 1.创建bitmap;
  size_t width = CGRectGetWidth(extent) * scale;
  size_t height = CGRectGetHeight(extent) * scale;
  CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
  CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
  CIContext *context = [CIContext contextWithOptions:nil];
  CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
  CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
  CGContextScaleCTM(bitmapRef, scale, scale);
  CGContextDrawImage(bitmapRef, extent, bitmapImage);
  // 2.保存bitmap到图片
  CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
  CGContextRelease(bitmapRef);
  CGImageRelease(bitmapImage);
  return [UIImage imageWithCGImage:scaledImage];
}

- (UIImage *)addIconToQRCodeImage:(UIImage *)image withIcon:(UIImage *)icon withIconSize:(CGSize)iconSize {
//  UIGraphicsBeginImageContext(image.size);
//  //通过两张图片进行位置和大小的绘制，实现两张图片的合并；其实此原理做法也可以用于多张图片的合并
//
//  [image drawInRect:CGRectMake(0, 0, kErweimaHeight, kErweimaHeight)];
//  [icon drawInRect:CGRectMake((kErweimaHeight - kErweimaIconWidth)/2, (kErweimaHeight - kErweimaIconWidth)/2,
//                              kErweimaIconWidth, kErweimaIconWidth)];
//  UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//
//  UIGraphicsEndImageContext();
//  return img;
  return nil;
}
@end
