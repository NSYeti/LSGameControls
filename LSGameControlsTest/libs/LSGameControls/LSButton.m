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

#import "LSButton.h"


@interface LSButton ()

@property (nonatomic, assign) BOOL willRepeat;

@end


@implementation LSButton

@synthesize type;
@synthesize selected = isSelected;
@synthesize enabled = isEnabled;
@synthesize tapCount;
@synthesize tapDuration;
@synthesize repeatRate;
@synthesize willRepeat;
@synthesize normalSprite;
@synthesize selectedSprite;
@synthesize disabledSprite;


- (void)dealloc {
    
    [super dealloc];
}


+ (id)buttonWithType:(LSButtonType)buttonType normalSprite:(CCSprite *)normal selectedSprite:(CCSprite *)selected disabledSprite:(CCSprite *)disabled {
    return [[[self alloc] initWithType:(LSButtonType)buttonType normalSprite:normal selectedSprite:selected disabledSprite:disabled] autorelease];
}


- (id)init {
    return [self initWithType:LSButtonTypeNormal normalSprite:nil selectedSprite:nil disabledSprite:nil];
}


- (id)initWithType:(LSButtonType)buttonType normalSprite:(CCSprite *)normal selectedSprite:(CCSprite *)selected disabledSprite:(CCSprite *)disabled {
    self = [super init];
    if (self != nil) {
        
        NSAssert(normal, @"Error: normal sprite must not be nil.");
        
        wins = [[CCDirector sharedDirector] winSize];
        
        type = buttonType;
        
        rect = CGRectZero;
        
        if (normal != nil) {
            normalSprite = normal;
            [self addChild:normalSprite];
            
            rect = CGRectUnion(rect, [normalSprite boundingBox]);
        }
        
        if (selected != nil) {
            selectedSprite = selected;
            [self addChild:selectedSprite];
            selectedSprite.visible = NO;
            
            rect = CGRectUnion(rect, [selectedSprite boundingBox]);
        }
        
        if (disabled != nil) {
            disabledSprite = disabled;
            [self addChild:disabledSprite];
            disabledSprite.visible = NO;
            
            rect = CGRectUnion(rect, [disabledSprite boundingBox]);
        }
        
        self.selected = NO;
        self.enabled = YES;
        
        repeatRate = 0.0;
        
    }
    return self;
}


- (void)onEnter {
    [super onEnter];
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:1 swallowsTouches:NO];
}


- (void)onExit {
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    [super onExit];
}


- (void)setEnabled:(BOOL)newValue {
    
    isEnabled = newValue;
    
    if (isEnabled) {
        if (normalSprite != nil) normalSprite.visible = YES;
        if (selectedSprite != nil) selectedSprite.visible = NO;
        if (disabledSprite != nil) disabledSprite.visible = NO;
    }
    else {
        if (disabledSprite != nil) {
            disabledSprite.visible = YES;
            if (normalSprite != nil) normalSprite.visible = NO;
            if (selectedSprite != nil)selectedSprite.visible = NO;
        }
        else {
            if (normalSprite != nil) normalSprite.visible = YES;
            if (selectedSprite != nil)selectedSprite.visible = NO;
        }
    }
}


- (void)setSelected:(BOOL)newValue {
    
    isSelected = newValue;
    
    if (isSelected) {
        if (selectedSprite != nil) {
            selectedSprite.visible = YES;
            if (normalSprite != nil) normalSprite.visible = NO;
            if (disabledSprite != nil) disabledSprite.visible = NO;
        }
    }
    else {
        if (normalSprite != nil) normalSprite.visible = YES;
        if (selectedSprite != nil) selectedSprite.visible = NO;
        if (disabledSprite != nil) disabledSprite.visible = NO;
    }

}


- (void)tick:(ccTime)dt {
    
    if (willRepeat) {
        
        self.selected = !self.selected;
        
        if (self.selected) {
            [self sendActionsForControlEvents:LSControlEventTouchDown];
        }
        else {
            [self sendActionsForControlEvents:LSControlEventTouchUpInside];
        }
        
        [self sendActionsForControlEvents:LSControlEventTouchDownRepeat];
    }

}


- (void)setRepeatRate:(int)newRate {

    repeatRate = newRate;  
    
    if (repeatRate < 0) repeatRate = 0;
    if (repeatRate > 60) repeatRate = 60;
}


- (void)setWillRepeat:(BOOL)newValue {
    
    willRepeat = newValue;
    
    if (willRepeat) {
        float rate = 1.0 / (float)repeatRate;
        
        if (repeatRate != 0) {
            [self schedule:@selector(tick:) interval:rate];
        }
    }
    else {
        [self unschedule:@selector(tick:)];
    }
    
    [self sendActionsForControlEvents:LSControlEventTouchDownRepeat];
}


#pragma mark -
#pragma mark CCTargetedTouchDelgate
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint touchPoint = [touch locationInView:[[CCDirector sharedDirector] view]];
    touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];
    
    touchPoint = [self convertToNodeSpace:touchPoint];
        
    if (CGRectContainsPoint(rect, touchPoint)) {
        
        touchHash = [touch hash];
        
        tapCount = [touch tapCount];
        
        if (tapCount > 1) [self sendActionsForControlEvents:LSControlEventTouchDownRepeat];
        
        startDuration = [touch timestamp];
        tapDuration = 0.0;
        
        if (type == LSButtonTypeToggle) {
            self.willRepeat = !self.willRepeat;
            
            if (!willRepeat && repeatRate != 0) {
                self.selected = NO;
            }
            else {
                self.selected = !self.selected;
            }
        }
        else {
            if (repeatRate != 0) {
                self.willRepeat = YES;
            }
            else {
                self.selected = YES;
            }
        }
        
        [self sendActionsForControlEvents:LSControlEventTouchDown];
        
        return YES;
    }

    return NO;
}


- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint touchPoint = [touch locationInView:[[CCDirector sharedDirector] view]];
    touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];
        
    if ([touch hash] == touchHash) {
        
        touchPoint = [self convertToNodeSpace:touchPoint];
        
        CGRect expandedRect = CGRectMake(rect.origin.x - rect.size.width * 0.5, 
                                         rect.origin.y - rect.size.height * 0.5, 
                                         rect.size.width * 2.0, 
                                         rect.size.height * 2.0);
//        if (CGRectContainsPoint(rect, touchPoint)) {
        if (CGRectContainsPoint(expandedRect, touchPoint)) {
            [self sendActionsForControlEvents:LSControlEventTouchDragInside];
            
            if (type == LSButtonTypeNormal) {
                if (!willRepeat) {
                    self.selected = YES;
                }
            }
        }
        else {
            [self sendActionsForControlEvents:LSControlEventTouchDragOutside];
            
            if (type == LSButtonTypeNormal) {
                if (!willRepeat) {
                    self.selected = NO;
                }
            }
        }
    }
}


- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint touchPoint = [touch locationInView:[[CCDirector sharedDirector] view]];
    touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];
    
    if ([touch hash] == touchHash) {
        
        touchPoint = [self convertToNodeSpace:touchPoint];
                
        if (CGRectContainsPoint(rect, touchPoint)) {
            [self sendActionsForControlEvents:LSControlEventTouchUpInside];
        }
        else {
            [self sendActionsForControlEvents:LSControlEventTouchUpOutside];
        }
        
        touchHash = 0;
        
        tapDuration = [touch timestamp] - startDuration;
        
        if (type == LSButtonTypeNormal) {
            self.selected = NO;
            if (willRepeat) self.willRepeat = NO;
        }
    }
}


- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
    [self ccTouchEnded:touch withEvent:event];
    [self sendActionsForControlEvents:LSControlEventTouchCancel];
}


@end
