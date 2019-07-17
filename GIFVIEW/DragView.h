//
//  DragView.h
//  GIFVIEW
//
//  Created by Dylan Xiao on 2019/7/17.
//  Copyright © 2019年 Dylan Xiao. All rights reserved.
//


/*看到很多Mac上的工具类应用都可以直接拖入图片 或者 拖入文件直接使用，今天就来说一下文件拖入的使用方法
 */
#import <Cocoa/Cocoa.h>


@protocol DragDropViewDelegate <NSObject>
//设置代理方法
-(void) doGetDragDropArrayFiles:(NSArray*) fileLists;

@end

NS_ASSUME_NONNULL_BEGIN

@interface DragView : NSView
@property (nonatomic,assign) BOOL isDragIn;
@property(assign) IBOutlet id<DragDropViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
