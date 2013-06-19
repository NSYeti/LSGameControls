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

#import <Foundation/Foundation.h>
#import "LSControl.h"


enum {
    LSJoystickType360               = 0
};
typedef int LSJoystickType;


//
//  ANALOG JOYSTICK CLASS
//  ---------------------
//

@interface LSJoystick : LSControl <CCTargetedTouchDelegate> {
    
    CGSize wins;
    
    LSJoystickType type;
        
    CGPoint axis;
    
    float angle;
    float maxRadius;
    float deadZone;
    
    BOOL isMoving;
    BOOL autoCentering;
    BOOL activatesOnThumbSpriteTouch;
    BOOL reachedMaxRadius;
    
    int touchHash;
    
    CCSprite *baseSprite;
    CCSprite *thumbSprite;
    
    CGRect hitTestRect;
    CGPoint initialPosition;
    BOOL returnToHome;
    BOOL relativePositioningMode;
    BOOL cancelIfOutsideHitTestRect;

}

// The type of joystick.
@property (nonatomic, readonly) LSJoystickType type;

// Position vector of the joystick. Ranges from -1.0 to +1.0
@property (nonatomic, readonly) CGPoint axis;

// Angle of the joystick in degrees.
@property (nonatomic, readonly) float angle;

// Sprite for the base of the joystick.
@property (nonatomic, readonly) CCSprite *baseSprite;

// Sprite for the thumb of the joystick.
@property (nonatomic, readonly) CCSprite *thumbSprite;

// Maximum amount the thumb of the joystick can be moved in any direction from it's centre point.
// Defaults to 3/4 the width of the 'base' sprite's bounding box.
@property (nonatomic, assign) float maxRadius;

// Amount of 'slack' the thumb of the joystick has to be moved through in order to register any changes to it's position vector. Defaults to 0.0
@property (nonatomic, assign) float deadZone;

// Whether the thumb of the joystick will return to it's centre position after the user's finger is lifted off the screen.
@property (nonatomic, assign) BOOL autoCentering;

// Whether the user is actually required to touch the thumb sprite of the joystick in order to register any movement changes. 
// Unless you're fairly accurate in your finger positioning it's recommended to leave this disabled.
//
// NOTE: this will be ignored if relative positioning mode is being used.
@property (nonatomic, assign) BOOL activatesOnThumbSpriteTouch;


// Designated initializers.
+ (id)joystickWithType:(LSJoystickType)stickType baseSprite:(CCSprite *)base thumbSprite:(CCSprite *)thumb;
- (id)initWithType:(LSJoystickType)stickType baseSprite:(CCSprite *)base thumbSprite:(CCSprite *)thumb;


// Enables positioning of the whole joystick (both the base and thumb sprite together) relative to where the user's 
// initial touch is located - similar to how Gameloft's joysticks work.
//
// The rectangle passed into 'rect' determines the area of the screen for this joystick that will be tested for touches.
//
// Passing YES into 'willReturn' will reset the position of the whole joystick when the user lifts their finger off the screen to the 
// position passed into 'homePos'. If passing 'NO' into 'willReturn' then 'homePos' is ignored and CGPointZero can be safely passed in.
//
// If using more than one joystick ensure that each joystick's hit test rect has its own exclusive area of the screen.
//
// DUAL JOYSTICKS EXAMPLE:
//
//      rect 1         rect 2
// +--------------+--------------+
// |              |              |
// |              |              | 
// |              |              |
// |              |              |
// |   *****      |      *****   |
// | *       *    |    *       * |
// | *   X   *    |    *   X   * |
// | *       *    |    *       * |
// |   *****      |      *****   |
// +--------------+--------------+
//         width of screen
//
- (void)setRelativePositioningModeWithHitTestRect:(CGRect)rect returnToHomeOnRelease:(BOOL)willReturn homePosition:(CGPoint)homePos;

// Whether the touch sequence and joystick movement will be cancelled if the user's finger moves outside the hit test rect.
//
// NOTE: This is meant to be used in conjunction with the 'setRelativePositioningModeWithHitTestRect:...' method above.
@property (nonatomic, assign) BOOL cancelIfOutsideHitTestRect;


@end
