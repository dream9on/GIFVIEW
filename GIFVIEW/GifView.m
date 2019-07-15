//
//  GifView.m
//  GIFVIEW
//
//  Created by Dylan Xiao on 2019/7/15.
//  Copyright © 2019年 Dylan Xiao. All rights reserved.
//

#import "GifView.h"

@interface GifView()
@property (nonatomic) NSImage *image;
@property (nonatomic) NSBitmapImageRep *gifbitmapRep;
@property (assign) NSInteger currentFrameIdx;
@property (nonatomic) NSTimer *giftimer;

@end

@implementation GifView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    [self drawGif];
}


-(void)setImage:(NSImage *)img
{
    if (img) {
        _image = img;
        self.gifbitmapRep = nil;
        if (self.giftimer) {
            [self.giftimer invalidate];
            self.giftimer = nil;
        }
        
        //get the image representations and iterate through them
        NSArray *reps = [self.image representations];
        for (NSImageRep *rep in reps) {
            if ([rep isKindOfClass:[NSBitmapImageRep class]] == YES) {
                NSBitmapImageRep *bitmapRep = (NSBitmapImageRep *)rep;
                
                //get the number of frames.If it's 0,it's not an animated gif, do nothing
                int numFrame = [[bitmapRep valueForProperty:NSImageFrameCount] intValue];
                if(numFrame ==0) break;
                
                //just consider equal time slot
                float delayTime = [[bitmapRep valueForProperty:NSImageCurrentFrameDuration] floatValue];
                self.currentFrameIdx = 0;
                self.gifbitmapRep = bitmapRep;
                
                self.giftimer = [NSTimer timerWithTimeInterval:delayTime target:self selector:@selector(animateGif) userInfo:nil repeats:YES];
                [[NSRunLoop mainRunLoop] addTimer:self.giftimer forMode:NSRunLoopCommonModes];
            }
        }
    }

}

-(void)animateGif{
    [self setNeedsDisplay:YES];
}

-(void)drawGif
{
    if (self.gifbitmapRep) {
        int numFrame = [[self.gifbitmapRep valueForProperty:NSImageFrameCount] intValue];
        if(self.currentFrameIdx >= numFrame)
        {
            self.currentFrameIdx = 0;
        }
        
        [self.gifbitmapRep setProperty:NSImageCurrentFrame withValue:@(self.currentFrameIdx)];
        NSRect drawGifRect;
        // get iamge factor
        if (self.image.size.width > self.frame.size.width || self.image.size.height>self.frame.size.height) {
            float hfactor = self.image.size.width/self.frame.size.width;
            float vfavtor = self.image.size.height/self.frame.size.height;
            float factor = fmaxf(hfactor, vfavtor);
            float newWidth = self.image.size.width / factor;
            float newHeight =self.image.size.height / factor;
            drawGifRect = NSMakeRect((self.frame.size.width - newWidth) /2.0, (self.frame.size.height - newHeight)/2.0, newWidth, newHeight);
        }else
        {
            drawGifRect = NSMakeRect((self.frame.size.width - self.image.size.width)/2.0, (self.frame.size.height - self.image.size.height)/2.0, self.image.size.width, self.image.size.height);
        }
        
        [self.gifbitmapRep  drawInRect:drawGifRect
                              fromRect:NSZeroRect
                             operation:NSCompositingOperationSourceOver
                              fraction:1.0f
                        respectFlipped:NO
                                 hints:nil];
        self.currentFrameIdx++;
    }
}

-(void)setImageURL:(NSString *)url
{
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [urlRequest addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                               if (connectionError) {
                                   NSLog(@"error description:%@,errcode = %ld.",connectionError.description,connectionError.code);
                               }else
                               {
                                   if (data) {
                                       NSImage *image = [[NSImage alloc] initWithData:data];
                                       if (image) {
                                           [self setImage:image];
                                       }else
                                       {
                                           NSLog(@"Error: not Image data");
                                       }
                                   }
                               }
                           }];
    
    [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error)
        {
            NSLog(@"error description: %@,errcode = %ld.",error.description,error.code);
        }else
        {
            if(data)
            {
                NSImage *image = [[NSImage alloc] initWithData:data];
                if(image) [self setImage:image];
                else NSLog(@"Error :not image data");
                
            }
        }
    }];
}

-(void)dealloc
{
    [self.giftimer invalidate];
    self.giftimer = nil;
}
@end
