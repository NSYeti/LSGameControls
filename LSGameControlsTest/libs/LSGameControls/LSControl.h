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
#import "cocos2d.h"


enum {
    LSControlEventTouchDown                       = 1 <<  0,  // A touch-down event in the control.
    LSControlEventTouchDownRepeat                 = 1 <<  1,  // A repeated touch-down event in the control (tapCount > 1).
    LSControlEventTouchDragInside                 = 1 <<  2,  // An event where the finger is dragged inside the bounds of the control.
    LSControlEventTouchDragOutside                = 1 <<  3,  // An event where the finger is dragged just outside the bounds of the control.
//    LSControlEventTouchDragEnter                  = 1 <<  4,  // An event where the finger is dragged into the bounds of the control.
//    LSControlEventTouchDragExit                   = 1 <<  5,  // An event where a finger is dragged from within a control to outside its bounds.
    LSControlEventTouchUpInside                   = 1 <<  6,  // A touch-up event in the control where the finger is inside the bounds of the control.
    LSControlEventTouchUpOutside                  = 1 <<  7,  // A touch-up event in the control where the finger is outside the bounds of the control.
    LSControlEventTouchCancel                     = 1 <<  8,  // A system event canceling the current touches for the control.
    
    LSControlEventJoystickReturnedToCentre        = 1 << 9,   // A touch-up event where the joystick thumb has returned to it's centre position.
    LSControlEventJoystickWithinMaxRadius         = 1 << 10,  // An event where the joystick thumb has been dragged to it's maximum radius.
    LSControlEventJoystickReachedMaxRadius        = 1 << 11,  // An event where the joystick thumb has been dragged to within it's maximum radius.
    
    LSControlEventJoypadRightPressed              = 1 << 12,  // A touch-down event where the right direction of the joypad has been pressed.
    LSControlEventJoypadUpRightPressed            = 1 << 13,  // A touch-down event where the up right direction of the joypad has been pressed.
    LSControlEventJoypadUpPressed               	= 1 << 14,  // A touch-down event where the up direction of the joypad has been pressed.
    LSControlEventJoypadUpLeftPressed             = 1 << 15,  // A touch-down event where the up left direction of the joypad has been pressed.
    LSControlEventJoypadLeftPressed               = 1 << 16,  // A touch-down event where the left direction of the joypad has been pressed.
    LSControlEventJoypadDownLeftPressed           = 1 << 17,  // A touch-down event where the down left direction of the joypad has been pressed.
    LSControlEventJoypadDownPressed               = 1 << 18,  // A touch-down event where the down direction of the joypad has been pressed.
    LSControlEventJoypadDownRightPressed          = 1 << 19,  // A touch-down event where the down right direction of the joypad has been pressed.
    
    LSControlEventJoypadRightReleased             = 1 << 20,  // A touch-down event where the right direction of the joypad has been released.
    LSControlEventJoypadUpRightReleased           = 1 << 21,  // A touch-down event where the up right direction of the joypad has been released.
    LSControlEventJoypadUpReleased                = 1 << 22,  // A touch-down event where the up direction of the joypad has been released.
    LSControlEventJoypadUpLeftReleased            = 1 << 23,  // A touch-down event where the up left direction of the joypad has been released.
    LSControlEventJoypadLeftReleased              = 1 << 24,  // A touch-down event where the left direction of the joypad has been released.
    LSControlEventJoypadDownLeftReleased          = 1 << 25,  // A touch-down event where the down left direction of the joypad has been released.
    LSControlEventJoypadDownReleased              = 1 << 26,  // A touch-down event where the down direction of the joypad has been released.
    LSControlEventJoypadDownRightReleased         = 1 << 27   // A touch-down event where the down right direction of the joypad has been released.
};
typedef int LSControlEvents;


//
//  ABSTRACT BASE CLASS
//  -------------------
//

@interface LSControl : CCNode {

    NSMutableArray *invocations;
    
}

// Loosely based on UIControl's target/action API. Not feature complete as of yet but enough to get started with.

// Add a target/action for a particular event. You can call this multiple times and you can specify multiple target/actions for
// a particular event. The action may optionally include the sender and the event in that order. The action cannot be NULL.
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(LSControlEvents)events;

// Remove a previously added target/action. Pass in NULL for the action to remove all actions for that target.
- (void)removeTarget:(id)target action:(SEL)action forControlEvents:(LSControlEvents)events;

// Send all actions associated with events.
- (void)sendActionsForControlEvents:(LSControlEvents)events;

@end


