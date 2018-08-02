//
//  KeyboardAvoidingViewLoader.m
//  KeyboardAvoidingView
//
//  Created by mac-246 on 2/16/18.
//

#import "KeyboardAvoidingViewLoader.h"

@implementation KeyboardAvoidingViewLoader

+ (void)load {
    Class keyboardManagerClass = NSClassFromString(@"_TtC20KeyboardAvoidingView15KeyboardManager");
    SEL sharedSelector = NSSelectorFromString(@"shared");
    if ([keyboardManagerClass respondsToSelector:sharedSelector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [keyboardManagerClass performSelector:sharedSelector];
#pragma clang diagnostic pop
    }
}

@end
