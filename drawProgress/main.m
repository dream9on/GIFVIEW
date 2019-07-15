//
//  main.m
//  drawProgress
//
//  Created by Dylan Xiao on 2019/7/15.
//  Copyright © 2019年 Dylan Xiao. All rights reserved.
//

#import <Foundation/Foundation.h>

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
        for (i=0; i<20; i++) {
            if (i<num/5) printf("*");
            else printf(" ");
        }
        
        printf("]");
        
        printf("%d%%...%c\r",num++,pic[num%4]);
        //NSLog(@"%d%%...%c\r",num++,pic[num%4]);
        fflush(stdout);
        usleep(100000);
    }
    
    return 0;
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        drawProgress();
    }
    return 0;
}
