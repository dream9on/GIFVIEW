//
//  DragView.m
//  GIFVIEW
//
//  Created by Dylan Xiao on 2019/7/17.
//  Copyright © 2019年 Dylan Xiao. All rights reserved.
//


/*
 1.首先要支持文件拖放，肯定要有一个放的位置，这里我们定义一个DragDropView来接收鼠标拖进来的文件。
 2.对View进行注册拖放事件的监听[self registerForDraggedTypes:[NSArray arrayWithObjects:NSFilenamesPboardType, nil]];，可以监听多种类型，常用类型为：
 NSStringPboardType         字符串类型
 NSFilenamesPboardType      文件
 NSURLPboardType            url链接
 NSPDFPboardType            pdf文件
 NSHTMLPboardType           html文件
 3.注册拖放事件监听之后，对鼠标拖放的文件进行接收，并把文件放到剪切版上
 设置方法：-(NSDragOperation) draggingEntered:(id<NSDraggingInfo>)sender，如果拖放的文件符合注册拖放事件监听所支持的类型，则返回NSDragOperationCopy，否则返回 NSDragOperationNone。
 4.获取拖放的文件，从剪切版上获取之前拖放进来的文件
 方法：-(BOOL) prepareForDragOperation:(id<NSDraggingInfo>)sender，获取拖放文件之后，把文件数组传递给DragDropView的代理方法，所以我们还要给DragDropView设置一个代理方法，方便对拖放的文件进行操作。
 5.设置DragDropView的代理方法
 @property(assign) IBOutlet id<DragDropViewDelegate> delegate;
 
 @protocol DragDropViewDelegate <NSObject>
 //设置代理方法
 -(void) doGetDragDropArrayFiles:(NSArray*) fileLists;
 
 @end
 总结：NSView支持文件拖放，主要步骤是注册拖放时间的监听器，设置监听的文件类型，接收拖放事件的方法，获取拖放文件的方法，设置View的代理，总共5步。
 
 */




#import "DragView.h"

@implementation DragView
@synthesize delegate =_delegate;

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    NSColor *color = [NSColor systemBlueColor];
    //[color setStroke];
    [color setFill];
    NSRectFill(dirtyRect);
    
//    self.wantsLayer = YES;
//    self.layer.backgroundColor = [NSColor systemBlueColor].CGColor;
    
    // Drawing code here.
    
    
    /*第一步：帮助view注册拖动事件的监听器，可以监听多种数据类型，这里只列出比较常用的：
     NSStringPboardType         字符串类型
     NSFilenamesPboardType      文件
     NSURLPboardType            url链接
     NSPDFPboardType            pdf文件
     NSHTMLPboardType           html文件
     ***/
    //这里我们只添加对文件进行监听，如果拖动其他数据类型到view中是不会被接受的
    [self registerForDraggedTypes:[NSArray arrayWithObjects:NSFilenamesPboardType,nil]];
    if (_isDragIn) {
        NSLog(@"Dragged.");
    }
}

- (NSDragOperation)draggingEntered:(id)sender
{
    _isDragIn=YES;
    [self setNeedsDisplay:YES];
    NSPasteboard *pb =[sender draggingPasteboard];
    NSArray *array=[pb types];
    if ([array containsObject:NSFilenamesPboardType]) {
        return NSDragOperationCopy;
    }
    return NSDragOperationNone;
}

- (void)draggingExited:(id)sender
{
    _isDragIn=NO;
    [self setNeedsDisplay:YES];
}

- (BOOL)prepareForDragOperation:(id)sender
{
    _isDragIn=NO;
    [self setNeedsDisplay:YES];
    return YES;
}


//设置鼠标拖放文件的动作，如果不重置，拖放的文件会有一个回退到原位置的动作轨迹。返回YES,拖放文件没有回退动作轨迹，返回NO，则有回退动作轨迹
- (BOOL)performDragOperation:(id)sender
{
    if([sender draggingSource] !=self)
    {
        NSArray* filePaths = [[sender draggingPasteboard] propertyListForType:NSFilenamesPboardType];
        NSLog(@"文件地址:%@",filePaths);
    }
    
    
    NSPasteboard *pb =[sender draggingPasteboard];
    NSArray *list =[pb propertyListForType:NSFilenamesPboardType];
    if (self.delegate && [self.delegate respondsToSelector:@selector(doGetDragDropArrayFiles:)]) {
        [self.delegate doGetDragDropArrayFiles:list];
    }
    
    return YES;
}

@end
