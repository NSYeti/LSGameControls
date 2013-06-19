/*
 * LSGameControls: https://github.com/NSYeti/LSGameControls
 *
 * Copyright (c) 2012 Lee Scott
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "LSControl.h"


@implementation LSControl

- (void)dealloc {
    [invocations release];
    [super dealloc];
}


- (id)init {
    if ((self = [super init])) {
        invocations = [[NSMutableArray alloc] init];
    }
    return self;
}


- (void)addTarget:(id)target action:(SEL)action forControlEvents:(LSControlEvents)events {
    
    NSAssert(target, @"Error: target must not be nil.");
    
    if(action != NULL) {
        
        // Check if we've already got an invocation for the current target, action, and events...
        BOOL invocationFound = NO;
        for (NSInvocation *inv in invocations) {
            id theTarget = [inv target];
            SEL theAction = [inv selector];
            LSControlEvents theEvents;
            [inv getArgument:&theEvents atIndex:3];
            
            if ([target isEqual:theTarget] && (action == theAction) && (events == theEvents)) {
                invocationFound = YES;
            }
        }
        
        if (!invocationFound) {
            
            NSMethodSignature *signature = [target methodSignatureForSelector:action];
            NSAssert(signature, @"Error: method signature not found for selector:%@", NSStringFromSelector(action));
            
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
            [invocation setTarget:target];
            [invocation setSelector:action];
            [invocation setArgument:&self atIndex:2]; // sender
            [invocation setArgument:&events atIndex:3]; // events
            [invocation retainArguments];
            
            [invocations addObject:invocation];    
        }
    }
}


- (void)removeTarget:(id)target action:(SEL)action forControlEvents:(LSControlEvents)events {
    
    NSAssert(target, @"Error: target must not be nil.");
    
    NSMutableArray *invocationsList = [NSMutableArray array];
    
    // Iterate through the invocations...
    for (NSInvocation *inv in invocations) {
        id theTarget = [inv target];
        SEL theAction = [inv selector];
        LSControlEvents theEvents;
        [inv getArgument:&theEvents atIndex:3];
        
        if (([target isEqual:theTarget] && (action == NULL)) || 
            ([target isEqual:theTarget] && (action == theAction) && (events == theEvents))) {
            [invocationsList addObject:inv];
        }
    }
    
    // Remove them.
    [invocations removeObjectsInArray:invocationsList];
}


- (void)sendActionsForControlEvents:(LSControlEvents)events {
    
    NSMutableArray *invocationsList = [NSMutableArray array];
    
    // Iterate through the invocations...
    for (NSInvocation *inv in invocations) {        
        LSControlEvents evnt;
        [inv getArgument:&evnt atIndex:3];
        LSControlEvents result = evnt & events;
        
        // Check if the target implements the selector.
        BOOL respondsToSelector = NO;
        respondsToSelector = [[inv target] respondsToSelector:[inv selector]];
        NSString *errorString = [NSString stringWithFormat:@"Error: target:%@ does not respond to selector:%@", [inv target], NSStringFromSelector([inv selector])];
        if (!respondsToSelector) NSAssert(respondsToSelector, errorString);
        
        if (result == events) {
            [invocationsList addObject:inv];
        }
    }
    
    // Do the invoking...
    for (NSInvocation *inv in invocationsList) {
        [inv invoke];
    }
}


@end
