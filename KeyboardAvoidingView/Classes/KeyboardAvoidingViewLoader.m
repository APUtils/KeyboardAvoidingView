//
//  KeyboardAvoidingViewLoader.m
//  KeyboardAvoidingView
//
//  Created by mac-246 on 2/16/18.
//

// TODO: Is it possible with preprocess macros to use proper import statement?

// Dynamic framework import
//#import <KeyboardAvoidingView/KeyboardAvoidingView-Swift.h>

// Static framework import
//#import "KeyboardAvoidingView-Swift.h"

#import "KeyboardAvoidingViewLoader.h"

@implementation KeyboardAvoidingViewLoader

+ (void)load {
    Class keyboardManagerClass = NSClassFromString(@"_TtC20KeyboardAvoidingView15KeyboardManager");
    SEL sharedSelector = NSSelectorFromString(@"shared");
    if ([keyboardManagerClass respondsToSelector:sharedSelector]) {
    // This causes a leak but I don't know how to support both static and dynamic frameworks together.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [keyboardManagerClass performSelector:sharedSelector];
#pragma clang diagnostic pop
    }
}

@end
