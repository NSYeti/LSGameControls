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

#import "LSJoypad.h"

@implementation LSJoypad

@synthesize type;
@synthesize axis;
@synthesize sprite;
@synthesize maxRadius;
@synthesize deadZone;
@synthesize direction;
@synthesize cancelIfOutsideHitTestRect;

- (void)dealloc {
    [spriteFrames release];
    [super dealloc];
}


+ (id)joypadWithType:(LSJoypadType)padType spriteFrames:(NSDictionary *)frames {
    return [[[self alloc] initWithType:padType spriteFrames:frames] autorelease];
}


- (id)init {
    return [self initWithType:LSJoypadTypeEightWay spriteFrames:nil];
}


- (id)initWithType:(LSJoypadType)padType spriteFrames:(NSDictionary *)frames {
    self = [super init];
    if (self != nil) {
        
        NSAssert(frames, @"Error: frames dictionary must not be nil.");
        
        wins = [[CCDirector sharedDirector] winSize];
        
        type = padType;
        
        spriteFrames  = [frames retain];
                
        sprite = [CCSprite spriteWithSpriteFrame:[spriteFrames objectForKey:@"Neutral"]];
        [self addChild:sprite];
        
        maxRadius = sprite.boundingBox.size.width / 2.0;
        deadZone = 20.0;
        
        cancelIfOutsideHitTestRect = NO;
        
        hitTestRect = CGRectZero;
        initialPosition = CGPointZero;
        relativePositioningMode = NO;
        returnToHome = NO;
        
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


- (void)doTargetActionsForDirection:(LSJoypadDirection)theDirection isPressed:(BOOL)pressed {
    
    if (pressed) {
        switch (theDirection) {
            case LSJoypadDirectionRight: {
                [self sendActionsForControlEvents:LSControlEventJoypadRightPressed];
                break;
            }
            case LSJoypadDirectionUpRight: {
                [self sendActionsForControlEvents:LSControlEventJoypadUpRightPressed];
                break;
            }
            case LSJoypadDirectionUp: {
                [self sendActionsForControlEvents:LSControlEventJoypadUpPressed];
                break;
            }
            case LSJoypadDirectionUpLeft: {
                [self sendActionsForControlEvents:LSControlEventJoypadUpLeftPressed];
                break;
            }
            case LSJoypadDirectionLeft: {
                [self sendActionsForControlEvents:LSControlEventJoypadLeftPressed];
                break;
            }
            case LSJoypadDirectionDownLeft: {
                [self sendActionsForControlEvents:LSControlEventJoypadDownLeftPressed];
                break;
            }
            case LSJoypadDirectionDown: {
                [self sendActionsForControlEvents:LSControlEventJoypadDownPressed];
                break;
            }
            case LSJoypadDirectionDownRight: {
                [self sendActionsForControlEvents:LSControlEventJoypadDownRightPressed];
                break;
            }
            default: {
                break;
            }
        } 
    }
    else {
        switch (theDirection) {
            case LSJoypadDirectionRight: {
                [self sendActionsForControlEvents:LSControlEventJoypadRightReleased];
                break;
            }
            case LSJoypadDirectionUpRight: {
                [self sendActionsForControlEvents:LSControlEventJoypadUpRightReleased];
                break;
            }
            case LSJoypadDirectionUp: {
                [self sendActionsForControlEvents:LSControlEventJoypadUpReleased];
                break;
            }
            case LSJoypadDirectionUpLeft: {
                [self sendActionsForControlEvents:LSControlEventJoypadUpLeftReleased];
                break;
            }
            case LSJoypadDirectionLeft: {
                [self sendActionsForControlEvents:LSControlEventJoypadLeftReleased];
                break;
            }
            case LSJoypadDirectionDownLeft: {
                [self sendActionsForControlEvents:LSControlEventJoypadDownLeftReleased];
                break;
            }
            case LSJoypadDirectionDown: {
                [self sendActionsForControlEvents:LSControlEventJoypadDownReleased];
                break;
            }
            case LSJoypadDirectionDownRight: {
                [self sendActionsForControlEvents:LSControlEventJoypadDownRightReleased];
                break;
            }
            default: {
                break;
            }
        }
    }
}


- (void)calculateDirectionForPoint:(CGPoint)point {
    
    int directions;
    switch (type) {
        case LSJoypadTypeEightWay: {
            directions = 8;
            break;
        }
        case LSJoypadTypeFourWay: {
            directions = 4;
            break;
        }
        default: {
            break;
        }
    }
    
    float degsPerDirection = 360.0 / directions;
    
    angle = CC_RADIANS_TO_DEGREES(ccpToAngle(point));
    angle = roundf(angle / degsPerDirection) * degsPerDirection;
    if (angle < 0.0) angle += 360.0;
    if (angle == 360.0) angle = 0.0;
    angle = fabsf(angle);
    
    float distance = ccpLength(point);
    if (distance > maxRadius) distance = maxRadius;
    
    if (distance > deadZone) {
        
        switch ((int)angle) {
            case 0: {
                direction = LSJoypadDirectionRight;
                axis = CGPointMake(1.0, 0.0);
                [sprite setDisplayFrame:[spriteFrames objectForKey:@"Right"]];
                break;
            }
            case 45: {
                direction = LSJoypadDirectionUpRight;
                axis = CGPointMake(1.0, 1.0);
                [sprite setDisplayFrame:[spriteFrames objectForKey:@"Up Right"]];
                break;
            }
            case 90: {
                direction = LSJoypadDirectionUp;
                axis = CGPointMake(0.0, 1.0);
                [sprite setDisplayFrame:[spriteFrames objectForKey:@"Up"]];
                break;
            }
            case 135: {
                direction = LSJoypadDirectionUpLeft;
                axis = CGPointMake(-1.0, 1.0);
                [sprite setDisplayFrame:[spriteFrames objectForKey:@"Up Left"]];
                break;
            }
            case 180: {
                direction = LSJoypadDirectionLeft;
                axis = CGPointMake(-1.0, 0.0);
                [sprite setDisplayFrame:[spriteFrames objectForKey:@"Left"]];
                break;
            }
            case 225: {
                direction = LSJoypadDirectionDownLeft;
                axis = CGPointMake(-1.0, -1.0);
                [sprite setDisplayFrame:[spriteFrames objectForKey:@"Down Left"]];
                break;
            }
            case 270: {
                direction = LSJoypadDirectionDown;
                axis = CGPointMake(0.0, -1.0);
                [sprite setDisplayFrame:[spriteFrames objectForKey:@"Down"]];
                break;
            }
            case 315: {
                direction = LSJoypadDirectionDownRight;
                axis = CGPointMake(1.0, -1.0);
                [sprite setDisplayFrame:[spriteFrames objectForKey:@"Down Right"]];
                break;
            }
            default: {
                break;
            }
        }
        
        if (direction != previousDirection) {
            [self doTargetActionsForDirection:previousDirection isPressed:NO];
            [self doTargetActionsForDirection:direction isPressed:YES];
        }
        
    }
    else {
        direction = LSJoypadDirectionNeutral;
        axis = CGPointZero;
        [sprite setDisplayFrame:[spriteFrames objectForKey:@"Neutral"]];
        
        [self doTargetActionsForDirection:previousDirection isPressed:NO];
    }
    
    previousDirection = direction;
}


- (void)setRelativePositioningModeWithHitTestRect:(CGRect)rect returnToHomeOnRelease:(BOOL)willReturn homePosition:(CGPoint)homePos {
    
    hitTestRect = rect;
    returnToHome = willReturn;
    initialPosition = homePos;
    relativePositioningMode = YES;
}


#pragma mark -
#pragma mark CCTargetedTouchDelgate
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint touchPoint = [touch locationInView:[[CCDirector sharedDirector] view]];
    touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];
    
    BOOL willMove = NO;
    
    if (relativePositioningMode) {
        if (CGRectContainsPoint(hitTestRect, touchPoint)) {
            self.position = touchPoint;
            willMove = YES;
        }
        touchPoint = [self convertToNodeSpace:touchPoint];
    }
    else {
        touchPoint = [self convertToNodeSpace:touchPoint];
        
        if (ccpLength(touchPoint) <= maxRadius) {
            willMove = YES;            
        }
    }
    
    if (willMove) {
        isMoving = YES;
        touchHash = [touch hash];
        
        [self calculateDirectionForPoint:touchPoint];
        
        [self sendActionsForControlEvents:LSControlEventTouchDown];
        
        return YES;
    }
    else {
        return NO;
    }
}


- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint touchPoint = [touch locationInView:[[CCDirector sharedDirector] view]];
    touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];
    
    BOOL willMove = YES;
    
    if ([touch hash] == touchHash && isMoving) {
        
        touchPoint = [self convertToNodeSpace:touchPoint];
        
        if (relativePositioningMode) {
            if (!CGRectContainsPoint(hitTestRect, touchPoint) && cancelIfOutsideHitTestRect) {
                willMove = NO;
                [self ccTouchCancelled:touch withEvent:event]; 
            }
        }
        else {
            if (ccpLength(touchPoint) <= maxRadius) {
                willMove = YES;            
            }
        }
        
        if (willMove) {
            
            isMoving = YES;
            
            [self calculateDirectionForPoint:touchPoint];
            
            if (CGRectContainsPoint([sprite boundingBox], touchPoint)) {
                [self sendActionsForControlEvents:LSControlEventTouchDragInside];
            }
            else {
                [self sendActionsForControlEvents:LSControlEventTouchDragOutside];
            }
        }      
    }
}


- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint touchPoint = [touch locationInView:[[CCDirector sharedDirector] view]];
    touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];
    
    if ([touch hash] == touchHash) {        
        isMoving = NO;        
		touchHash = 0;
        
        [self calculateDirectionForPoint:CGPointZero];
        
        if (relativePositioningMode) {
            if (returnToHome) {
                self.position = initialPosition;
            }
        }
        
        touchPoint = [self convertToNodeSpace:touchPoint];
        
        if (CGRectContainsPoint([sprite boundingBox], touchPoint)) {
            [self sendActionsForControlEvents:LSControlEventTouchUpInside];
        }
        else {
            [self sendActionsForControlEvents:LSControlEventTouchUpOutside];
        }
	}
    
}


- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
    [self ccTouchEnded:touch withEvent:event];
    [self sendActionsForControlEvents:LSControlEventTouchCancel];
}


@end
