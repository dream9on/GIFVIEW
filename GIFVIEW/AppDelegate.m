//
//  AppDelegate.m
//  GIFVIEW
//
//  Created by Dylan Xiao on 2019/7/15.
//  Copyright © 2019年 Dylan Xiao. All rights reserved.
//

#import "AppDelegate.h"
#import "GifView.h"

@interface AppDelegate ()
- (IBAction)Btn_OK:(NSButton *)sender;
@property (weak) IBOutlet GifView *gifView;

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    dragView.delegate = self;
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


-(BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}

- (IBAction)Btn_OK:(NSButton *)sender {
    NSImage *img = [NSImage imageNamed:@"1.gif"];
    [_gifView setImage:img];
    
    //drawProgress();
}

int drawProgress()
{
    int i,num=1;
    const char *pic = "|/-\\"; // 简易动画特效
    printf("loading state:\n");
    while (1) {
        if (101==num) {
            printf("\nLoading success!\n");
            break;
        }
        
        printf("[");
        for (i=0; i<num/10; i++) {
            printf("*");
        }
        printf("]");
        printf("%d%%...%c\n",num++,pic[num%4]);
        fflush(stdout);  //清空输出缓冲区，并把缓冲区内容输出。
        usleep(100000);
    }
    
    return 0;
}




#pragma mark
-(void) doGetDragDropArrayFiles:(NSArray*) fileLists
{
    NSString *path =@"";
    for (NSString *content in fileLists) {
        path =[path stringByAppendingFormat:@"%@\n",content];
    }
    [pathText setStringValue:path];
}
@end
