//
//  KeyboardAvoidingViewLoader.m
//  KeyboardAvoidingView
//
//  Created by mac-246 on 2/16/18.
//

#import <KeyboardAvoidingView/KeyboardAvoidingView-Swift.h>
#import "KeyboardAvoidingViewLoader.h"

@implementation KeyboardAvoidingViewLoader
    
+ (void)load {
    (void)[KeyboardManager shared];
}

@end
