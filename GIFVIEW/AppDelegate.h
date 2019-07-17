//
//  AppDelegate.h
//  GIFVIEW
//
//  Created by Dylan Xiao on 2019/7/15.
//  Copyright © 2019年 Dylan Xiao. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DragView.h"

@interface AppDelegate : NSObject <NSApplicationDelegate,DragDropViewDelegate>
{
    __weak IBOutlet NSTextField *pathText;
    
    __weak IBOutlet DragView *dragView;
}

@end

