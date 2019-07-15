//
//  GifView.h
//  GIFVIEW
//
//  Created by Dylan Xiao on 2019/7/15.
//  Copyright © 2019年 Dylan Xiao. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface GifView : NSView
-(void)setImage:(NSImage*)image;
-(void)setImageURL:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
