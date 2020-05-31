#line 1 "Tweak.x"
#import <Cephei/HBPreferences.h>
#import <Foundation/NSDistributedNotificationCenter.h>
#import <objc/objc-runtime.h>


HBPreferences *preferences;
BOOL enabled;
BOOL isPercentageEnabled;
BOOL isBarHidden;
BOOL dateEnabled;
BOOL isPercentageReplaceEnabled;
NSString * textColor;
NSString * textContent;
NSString * activeWifiColor;
NSString * inactiveWifiColor;
NSString * activeCellularColor;
NSString * inactiveCellularColor;
NSString * batteryExteriorColor;
NSString * batteryFillColor;
NSString * lightningColor;
NSString * percentageReplaceColor;
NSInteger batterySize;


@interface _UIBatteryView : UIView
@property (nonatomic, assign) BOOL isPercentInit;
@property (nonatomic, copy) UIColor *bodyColor;
@property (nonatomic, assign) NSInteger chargingState;
@property (nonatomic, assign) BOOL saverModeActive;
- (void)setBodyColor:(UIColor *)realBodyColor;
- (void)setBoltColor:(UIColor * )realBoltColor;
-(void)initPercentageLabel:(CGRect)frame;
-(double)chargePercent;
@end


@interface _UIStatusBarForegroundView : UIView
@property (nonatomic, assign, readwrite, getter=isHidden) BOOL hidden;
-(void)setHidden:(BOOL)changeHidden;
-(BOOL)isHidden;
-(void)addSubview:(UIView *)item;
@end


@interface _UIStatusBarStringView : UIView
-(void)setNumberOfLines:(NSInteger)num;
-(void)setFont:(UIFont *)font;
@end


UIColor * returnUIColor(NSString * realText) {
	NSString *cleanString = [realText stringByReplacingOccurrencesOfString:@"#" withString:@""];
	if([cleanString length] == 3) {
		cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
						[cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
						[cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
						[cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
	}
	if([cleanString length] == 6) {
		cleanString = [cleanString stringByAppendingString:@"ff"];
	}
	
	unsigned int baseValue;
	[[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
	
	float red = ((baseValue >> 24) & 0xFF)/255.0f;
	float green = ((baseValue >> 16) & 0xFF)/255.0f;
	float blue = ((baseValue >> 8) & 0xFF)/255.0f;
	float alpha = ((baseValue >> 0) & 0xFF)/255.0f;

	return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}


NSString * hexStringForColor(UIColor * color) {
      const CGFloat *components = CGColorGetComponents(color.CGColor);
      CGFloat r = components[0];
      CGFloat g = components[1];
      CGFloat b = components[2];
      NSString *hexString=[NSString stringWithFormat:@"%02X%02X%02X", (int)(r * 255), (int)(g * 255), (int)(b * 255)];
      return hexString;
}


#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class _UIBatteryView; @class _UIStatusBarCellularSignalView; @class _UIStatusBarStringView; @class _UIStatusBarWifiSignalView; @class _UIStatusBarForegroundView; @class SBDeviceApplicationSceneStatusBarBreadcrumbProvider; 
static BOOL (*_logos_meta_orig$_ungrouped$SBDeviceApplicationSceneStatusBarBreadcrumbProvider$_shouldAddBreadcrumbToActivatingSceneEntity$sceneHandle$withTransitionContext$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, id, id, id); static BOOL _logos_meta_method$_ungrouped$SBDeviceApplicationSceneStatusBarBreadcrumbProvider$_shouldAddBreadcrumbToActivatingSceneEntity$sceneHandle$withTransitionContext$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, id, id, id); static void (*_logos_orig$_ungrouped$_UIStatusBarStringView$setText$)(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarStringView* _LOGOS_SELF_CONST, SEL, NSString *); static void _logos_method$_ungrouped$_UIStatusBarStringView$setText$(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarStringView* _LOGOS_SELF_CONST, SEL, NSString *); static void (*_logos_orig$_ungrouped$_UIStatusBarStringView$setNumberOfLines$)(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarStringView* _LOGOS_SELF_CONST, SEL, NSInteger); static void _logos_method$_ungrouped$_UIStatusBarStringView$setNumberOfLines$(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarStringView* _LOGOS_SELF_CONST, SEL, NSInteger); static void (*_logos_orig$_ungrouped$_UIStatusBarStringView$setFont$)(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarStringView* _LOGOS_SELF_CONST, SEL, UIFont *); static void _logos_method$_ungrouped$_UIStatusBarStringView$setFont$(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarStringView* _LOGOS_SELF_CONST, SEL, UIFont *); static void (*_logos_orig$_ungrouped$_UIStatusBarStringView$setTextColor$)(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarStringView* _LOGOS_SELF_CONST, SEL, UIColor *); static void _logos_method$_ungrouped$_UIStatusBarStringView$setTextColor$(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarStringView* _LOGOS_SELF_CONST, SEL, UIColor *); static void (*_logos_orig$_ungrouped$_UIStatusBarForegroundView$setHidden$)(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarForegroundView* _LOGOS_SELF_CONST, SEL, BOOL); static void _logos_method$_ungrouped$_UIStatusBarForegroundView$setHidden$(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarForegroundView* _LOGOS_SELF_CONST, SEL, BOOL); static void (*_logos_orig$_ungrouped$_UIStatusBarForegroundView$setNeedsLayout)(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarForegroundView* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$_UIStatusBarForegroundView$setNeedsLayout(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarForegroundView* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$_UIStatusBarCellularSignalView$setActiveColor$)(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarCellularSignalView* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$_ungrouped$_UIStatusBarCellularSignalView$setActiveColor$(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarCellularSignalView* _LOGOS_SELF_CONST, SEL, id); static void (*_logos_orig$_ungrouped$_UIStatusBarCellularSignalView$setInactiveColor$)(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarCellularSignalView* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$_ungrouped$_UIStatusBarCellularSignalView$setInactiveColor$(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarCellularSignalView* _LOGOS_SELF_CONST, SEL, id); static void (*_logos_orig$_ungrouped$_UIStatusBarWifiSignalView$setActiveColor$)(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarWifiSignalView* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$_ungrouped$_UIStatusBarWifiSignalView$setActiveColor$(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarWifiSignalView* _LOGOS_SELF_CONST, SEL, id); static void (*_logos_orig$_ungrouped$_UIStatusBarWifiSignalView$setInactiveColor$)(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarWifiSignalView* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$_ungrouped$_UIStatusBarWifiSignalView$setInactiveColor$(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarWifiSignalView* _LOGOS_SELF_CONST, SEL, id); static void (*_logos_orig$_ungrouped$_UIBatteryView$layoutSubviews)(_LOGOS_SELF_TYPE_NORMAL _UIBatteryView* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$_UIBatteryView$layoutSubviews(_LOGOS_SELF_TYPE_NORMAL _UIBatteryView* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$_UIBatteryView$initPercentageLabel$(_LOGOS_SELF_TYPE_NORMAL _UIBatteryView* _LOGOS_SELF_CONST, SEL, CGRect); static void (*_logos_orig$_ungrouped$_UIBatteryView$setAlpha$)(_LOGOS_SELF_TYPE_NORMAL _UIBatteryView* _LOGOS_SELF_CONST, SEL, CGFloat); static void _logos_method$_ungrouped$_UIBatteryView$setAlpha$(_LOGOS_SELF_TYPE_NORMAL _UIBatteryView* _LOGOS_SELF_CONST, SEL, CGFloat); static void (*_logos_orig$_ungrouped$_UIBatteryView$setShowsInlineChargingIndicator$)(_LOGOS_SELF_TYPE_NORMAL _UIBatteryView* _LOGOS_SELF_CONST, SEL, BOOL); static void _logos_method$_ungrouped$_UIBatteryView$setShowsInlineChargingIndicator$(_LOGOS_SELF_TYPE_NORMAL _UIBatteryView* _LOGOS_SELF_CONST, SEL, BOOL); static void (*_logos_orig$_ungrouped$_UIBatteryView$setShowsPercentage$)(_LOGOS_SELF_TYPE_NORMAL _UIBatteryView* _LOGOS_SELF_CONST, SEL, BOOL); static void _logos_method$_ungrouped$_UIBatteryView$setShowsPercentage$(_LOGOS_SELF_TYPE_NORMAL _UIBatteryView* _LOGOS_SELF_CONST, SEL, BOOL); static void (*_logos_orig$_ungrouped$_UIBatteryView$setBodyColor$)(_LOGOS_SELF_TYPE_NORMAL _UIBatteryView* _LOGOS_SELF_CONST, SEL, UIColor *); static void _logos_method$_ungrouped$_UIBatteryView$setBodyColor$(_LOGOS_SELF_TYPE_NORMAL _UIBatteryView* _LOGOS_SELF_CONST, SEL, UIColor *); static void (*_logos_orig$_ungrouped$_UIBatteryView$setChargePercent$)(_LOGOS_SELF_TYPE_NORMAL _UIBatteryView* _LOGOS_SELF_CONST, SEL, double); static void _logos_method$_ungrouped$_UIBatteryView$setChargePercent$(_LOGOS_SELF_TYPE_NORMAL _UIBatteryView* _LOGOS_SELF_CONST, SEL, double); static void (*_logos_orig$_ungrouped$_UIBatteryView$setFillColor$)(_LOGOS_SELF_TYPE_NORMAL _UIBatteryView* _LOGOS_SELF_CONST, SEL, UIColor *); static void _logos_method$_ungrouped$_UIBatteryView$setFillColor$(_LOGOS_SELF_TYPE_NORMAL _UIBatteryView* _LOGOS_SELF_CONST, SEL, UIColor *); static void (*_logos_orig$_ungrouped$_UIBatteryView$setBoltColor$)(_LOGOS_SELF_TYPE_NORMAL _UIBatteryView* _LOGOS_SELF_CONST, SEL, UIColor * ); static void _logos_method$_ungrouped$_UIBatteryView$setBoltColor$(_LOGOS_SELF_TYPE_NORMAL _UIBatteryView* _LOGOS_SELF_CONST, SEL, UIColor * ); static void (*_logos_orig$_ungrouped$_UIBatteryView$setIconSize$)(_LOGOS_SELF_TYPE_NORMAL _UIBatteryView* _LOGOS_SELF_CONST, SEL, NSInteger); static void _logos_method$_ungrouped$_UIBatteryView$setIconSize$(_LOGOS_SELF_TYPE_NORMAL _UIBatteryView* _LOGOS_SELF_CONST, SEL, NSInteger); static void (*_logos_orig$_ungrouped$_UIBatteryView$setSaverModeActive$)(_LOGOS_SELF_TYPE_NORMAL _UIBatteryView* _LOGOS_SELF_CONST, SEL, BOOL); static void _logos_method$_ungrouped$_UIBatteryView$setSaverModeActive$(_LOGOS_SELF_TYPE_NORMAL _UIBatteryView* _LOGOS_SELF_CONST, SEL, BOOL); static void (*_logos_orig$_ungrouped$_UIBatteryView$setChargingState$)(_LOGOS_SELF_TYPE_NORMAL _UIBatteryView* _LOGOS_SELF_CONST, SEL, NSInteger); static void _logos_method$_ungrouped$_UIBatteryView$setChargingState$(_LOGOS_SELF_TYPE_NORMAL _UIBatteryView* _LOGOS_SELF_CONST, SEL, NSInteger); 

#line 84 "Tweak.x"


static BOOL _logos_meta_method$_ungrouped$SBDeviceApplicationSceneStatusBarBreadcrumbProvider$_shouldAddBreadcrumbToActivatingSceneEntity$sceneHandle$withTransitionContext$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1, id arg2, id arg3) {
	if(dateEnabled && enabled) {
		return FALSE;
	}
	return _logos_meta_orig$_ungrouped$SBDeviceApplicationSceneStatusBarBreadcrumbProvider$_shouldAddBreadcrumbToActivatingSceneEntity$sceneHandle$withTransitionContext$(self, _cmd, arg1, arg2, arg3);
}






	
	static void _logos_method$_ungrouped$_UIStatusBarStringView$setText$(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarStringView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString * text) {
		if(enabled) {
			
			if(![textContent isEqual:@""] && [text containsString:@":"]) {
				text = textContent;
			}

			else if(dateEnabled && [text containsString:@":"]) {
				NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
				[dateFormatter setDateFormat:@"MM/dd"];

				[self setFont:[UIFont boldSystemFontOfSize:13]];
				[self setNumberOfLines:2];

				
				

				NSString * date = [dateFormatter stringFromDate:[NSDate date]];

				if(![textContent isEqual:@""]) {
					text = [NSString stringWithFormat:@"%@\n%@", date, textContent];
				}
				else {
					text = [NSString stringWithFormat:@"%@\n%@", date, text];
				}
			}
		}

		_logos_orig$_ungrouped$_UIStatusBarStringView$setText$(self, _cmd, text);
	}

	static void _logos_method$_ungrouped$_UIStatusBarStringView$setNumberOfLines$(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarStringView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSInteger num) {
		if(enabled && dateEnabled) {
			num = 2;
		}
		_logos_orig$_ungrouped$_UIStatusBarStringView$setNumberOfLines$(self, _cmd, num);
	}

	static void _logos_method$_ungrouped$_UIStatusBarStringView$setFont$(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarStringView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIFont * font) {
		if(enabled && dateEnabled) {
			font = [font fontWithSize:13];
		}
		_logos_orig$_ungrouped$_UIStatusBarStringView$setFont$(self, _cmd, font);
	}

	
	static void _logos_method$_ungrouped$_UIStatusBarStringView$setTextColor$(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarStringView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIColor * realTextColor) {
		if(enabled) {
			if(![textColor isEqual:@"#FFFFFF"]) {
				realTextColor = returnUIColor(textColor);
			}
		}
		_logos_orig$_ungrouped$_UIStatusBarStringView$setTextColor$(self, _cmd, realTextColor);
	}






	__attribute__((used)) static BOOL _logos_method$_ungrouped$_UIStatusBarForegroundView$hidden(_UIStatusBarForegroundView * __unused self, SEL __unused _cmd) { NSValue * value = objc_getAssociatedObject(self, (void *)_logos_method$_ungrouped$_UIStatusBarForegroundView$hidden); BOOL rawValue; [value getValue:&rawValue]; return rawValue; }; __attribute__((used)) static void _logos_method$_ungrouped$_UIStatusBarForegroundView$setHidden(_UIStatusBarForegroundView * __unused self, SEL __unused _cmd, BOOL rawValue) { NSValue * value = [NSValue valueWithBytes:&rawValue objCType:@encode(BOOL)]; objc_setAssociatedObject(self, (void *)_logos_method$_ungrouped$_UIStatusBarForegroundView$hidden, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }

	
	static void _logos_method$_ungrouped$_UIStatusBarForegroundView$setHidden$(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarForegroundView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, BOOL changeHidden) {
		if(enabled) {
			if(isBarHidden) {
				changeHidden = TRUE;
			}
		}
		_logos_orig$_ungrouped$_UIStatusBarForegroundView$setHidden$(self, _cmd, changeHidden);
	}

	
	static void _logos_method$_ungrouped$_UIStatusBarForegroundView$setNeedsLayout(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarForegroundView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
		if(enabled) {
			if(isBarHidden) {
				self.hidden = TRUE;
			}
		}
		_logos_orig$_ungrouped$_UIStatusBarForegroundView$setNeedsLayout(self, _cmd);
	}





	static void _logos_method$_ungrouped$_UIStatusBarCellularSignalView$setActiveColor$(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarCellularSignalView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id color) {
		if(enabled) {
			if(![activeCellularColor isEqual:@"#FFFFFF"]) {
				color = returnUIColor(activeCellularColor);
			}
		}
		_logos_orig$_ungrouped$_UIStatusBarCellularSignalView$setActiveColor$(self, _cmd, color);
	}

	static void _logos_method$_ungrouped$_UIStatusBarCellularSignalView$setInactiveColor$(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarCellularSignalView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id color) {
		if(enabled) {
			if(![inactiveCellularColor isEqual:@"#878182"]) {
				color = returnUIColor(inactiveCellularColor);
			}
		}
		_logos_orig$_ungrouped$_UIStatusBarCellularSignalView$setInactiveColor$(self, _cmd, color);
	}





	static void _logos_method$_ungrouped$_UIStatusBarWifiSignalView$setActiveColor$(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarWifiSignalView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id color) {
		if(enabled) {
			if(![activeWifiColor isEqual:@"#FFFFFF"]) {
				color = returnUIColor(activeWifiColor);
			}
		}
		_logos_orig$_ungrouped$_UIStatusBarWifiSignalView$setActiveColor$(self, _cmd, color);
	}

	static void _logos_method$_ungrouped$_UIStatusBarWifiSignalView$setInactiveColor$(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarWifiSignalView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id color) {
		if(enabled) {
			if(![inactiveWifiColor isEqual:@"#878182"]) {
				color = returnUIColor(inactiveWifiColor);
			}
		}
		_logos_orig$_ungrouped$_UIStatusBarWifiSignalView$setInactiveColor$(self, _cmd, color);
	}





	__attribute__((used)) static UIColor * _logos_method$_ungrouped$_UIBatteryView$bodyColor(_UIBatteryView * __unused self, SEL __unused _cmd) { return (UIColor *)objc_getAssociatedObject(self, (void *)_logos_method$_ungrouped$_UIBatteryView$bodyColor); }; __attribute__((used)) static void _logos_method$_ungrouped$_UIBatteryView$setBodyColor(_UIBatteryView * __unused self, SEL __unused _cmd, UIColor * rawValue) { objc_setAssociatedObject(self, (void *)_logos_method$_ungrouped$_UIBatteryView$bodyColor, rawValue, OBJC_ASSOCIATION_COPY_NONATOMIC); }
	__attribute__((used)) static NSInteger _logos_method$_ungrouped$_UIBatteryView$chargingState(_UIBatteryView * __unused self, SEL __unused _cmd) { NSValue * value = objc_getAssociatedObject(self, (void *)_logos_method$_ungrouped$_UIBatteryView$chargingState); NSInteger rawValue; [value getValue:&rawValue]; return rawValue; }; __attribute__((used)) static void _logos_method$_ungrouped$_UIBatteryView$setChargingState(_UIBatteryView * __unused self, SEL __unused _cmd, NSInteger rawValue) { NSValue * value = [NSValue valueWithBytes:&rawValue objCType:@encode(NSInteger)]; objc_setAssociatedObject(self, (void *)_logos_method$_ungrouped$_UIBatteryView$chargingState, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }
	__attribute__((used)) static BOOL _logos_method$_ungrouped$_UIBatteryView$saverModeActive(_UIBatteryView * __unused self, SEL __unused _cmd) { NSValue * value = objc_getAssociatedObject(self, (void *)_logos_method$_ungrouped$_UIBatteryView$saverModeActive); BOOL rawValue; [value getValue:&rawValue]; return rawValue; }; __attribute__((used)) static void _logos_method$_ungrouped$_UIBatteryView$setSaverModeActive(_UIBatteryView * __unused self, SEL __unused _cmd, BOOL rawValue) { NSValue * value = [NSValue valueWithBytes:&rawValue objCType:@encode(BOOL)]; objc_setAssociatedObject(self, (void *)_logos_method$_ungrouped$_UIBatteryView$saverModeActive, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }
	__attribute__((used)) static BOOL _logos_method$_ungrouped$_UIBatteryView$isPercentInit(_UIBatteryView * __unused self, SEL __unused _cmd) { NSValue * value = objc_getAssociatedObject(self, (void *)_logos_method$_ungrouped$_UIBatteryView$isPercentInit); BOOL rawValue; [value getValue:&rawValue]; return rawValue; }; __attribute__((used)) static void _logos_method$_ungrouped$_UIBatteryView$setIsPercentInit(_UIBatteryView * __unused self, SEL __unused _cmd, BOOL rawValue) { NSValue * value = [NSValue valueWithBytes:&rawValue objCType:@encode(BOOL)]; objc_setAssociatedObject(self, (void *)_logos_method$_ungrouped$_UIBatteryView$isPercentInit, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }

	static void _logos_method$_ungrouped$_UIBatteryView$layoutSubviews(_LOGOS_SELF_TYPE_NORMAL _UIBatteryView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
		_logos_orig$_ungrouped$_UIBatteryView$layoutSubviews(self, _cmd);

		if(enabled) {
			if(!self.isPercentInit && isPercentageReplaceEnabled) {
				[self initPercentageLabel:self.frame];
				[self setChargingState:self.chargingState];
			}
		}
	}

	
	static void _logos_method$_ungrouped$_UIBatteryView$initPercentageLabel$(_LOGOS_SELF_TYPE_NORMAL _UIBatteryView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, CGRect frame) {
		if(enabled) {
			UILabel *batteryLabel = [[UILabel alloc]initWithFrame:frame];
			NSString *percentCharge = [NSString stringWithFormat:@"%d",(int)([self chargePercent] * 100)];
			[batteryLabel setText:[percentCharge stringByAppendingString:@"%"]];
			[batteryLabel setBounds:self.bounds];
			[batteryLabel setCenter:self.center];
			[batteryLabel setFont:[UIFont boldSystemFontOfSize:12]];
			batteryLabel.adjustsFontSizeToFitWidth = YES;
			if(![percentageReplaceColor isEqual:@"#FFFFFF"]) {
				[batteryLabel setTextColor:returnUIColor(percentageReplaceColor)];
			}
			else {
				[batteryLabel setTextColor:[UIColor whiteColor]];
			}
			[batteryLabel setTextAlignment:NSTextAlignmentRight];
			[batteryLabel setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];
			[batteryLabel setLineBreakMode:NSLineBreakByCharWrapping];
			[batteryLabel setNumberOfLines:1];
			[batteryLabel setTag:51603];
			[self.superview addSubview:batteryLabel];
			self.isPercentInit = TRUE;
			[self setHidden:TRUE];
			[batteryLabel sizeToFit];
		}
	}

	static void _logos_method$_ungrouped$_UIBatteryView$setAlpha$(_LOGOS_SELF_TYPE_NORMAL _UIBatteryView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, CGFloat newAlpha) {
		if(enabled && isPercentageReplaceEnabled) {
			newAlpha = 0.0;
		}
		_logos_orig$_ungrouped$_UIBatteryView$setAlpha$(self, _cmd, newAlpha);
	}

	
	static void _logos_method$_ungrouped$_UIBatteryView$setShowsInlineChargingIndicator$(_LOGOS_SELF_TYPE_NORMAL _UIBatteryView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, BOOL realBoltIcon) {
		if(enabled) {
			if(isPercentageEnabled) {
				realBoltIcon = NO;
			}
		}
		_logos_orig$_ungrouped$_UIBatteryView$setShowsInlineChargingIndicator$(self, _cmd, realBoltIcon);
	}

	
	static void _logos_method$_ungrouped$_UIBatteryView$setShowsPercentage$(_LOGOS_SELF_TYPE_NORMAL _UIBatteryView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, BOOL realShowsPercentage) {
		if(enabled) {
			if(isPercentageEnabled) {
				realShowsPercentage = YES;
			}
		}
		_logos_orig$_ungrouped$_UIBatteryView$setShowsPercentage$(self, _cmd, realShowsPercentage);
	}

	
	static void _logos_method$_ungrouped$_UIBatteryView$setBodyColor$(_LOGOS_SELF_TYPE_NORMAL _UIBatteryView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIColor * realBodyColor) {
		if(enabled) {

			NSString * hex = hexStringForColor(realBodyColor);

			
			if(self.chargingState == 1) {
				if(isPercentageReplaceEnabled) {
					((UILabel *)[self.superview viewWithTag:51603]).textColor = [UIColor colorWithRed:0.19 green:0.82 blue:0.35 alpha:1.00];
				}
				realBodyColor = [UIColor colorWithRed:0.19 green:0.82 blue:0.35 alpha:1.00];
			}

			else if([hex isEqual:@"FFD60A"]) {
				if(isPercentageReplaceEnabled) {
					((UILabel *)[self.superview viewWithTag:51603]).textColor = realBodyColor;
				}
				
			}

			else {
				if(isPercentageReplaceEnabled && [percentageReplaceColor isEqual:@"#FFFFFF"]) {
					((UILabel *)[self.superview viewWithTag:51603]).textColor = returnUIColor(percentageReplaceColor);
				}
				
				if(![batteryExteriorColor isEqual:@"#878182"]) {
					realBodyColor = returnUIColor(batteryExteriorColor);
				}
				else {
					
					realBodyColor = [UIColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:0.40];
				}
			}
		}
		_logos_orig$_ungrouped$_UIBatteryView$setBodyColor$(self, _cmd, realBodyColor);
		[self setNeedsDisplay];
		[self setNeedsLayout];
	}

	static void _logos_method$_ungrouped$_UIBatteryView$setChargePercent$(_LOGOS_SELF_TYPE_NORMAL _UIBatteryView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, double arg1) {
		_logos_orig$_ungrouped$_UIBatteryView$setChargePercent$(self, _cmd, arg1);
		if(enabled && isPercentageReplaceEnabled) {
			[((UILabel *)[self.superview viewWithTag:51603]) setText: [[NSString stringWithFormat:@"%d",(int)([self chargePercent] * 100)] stringByAppendingString:@"%"]];
			[((UILabel *)[self.superview viewWithTag:51603]) sizeToFit];
		}
	}

	
	static void _logos_method$_ungrouped$_UIBatteryView$setFillColor$(_LOGOS_SELF_TYPE_NORMAL _UIBatteryView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIColor * realFillColor) {
		if(enabled) {
			if(![batteryFillColor isEqual:@""]) {
				realFillColor = returnUIColor(batteryFillColor);
			}
		}
		_logos_orig$_ungrouped$_UIBatteryView$setFillColor$(self, _cmd, realFillColor);
	}

	
	static void _logos_method$_ungrouped$_UIBatteryView$setBoltColor$(_LOGOS_SELF_TYPE_NORMAL _UIBatteryView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIColor *  realBoltColor) {
		if(@available(iOS 13.0, *)) {
			if(enabled) {
				if(![lightningColor isEqual:@"#FFFFFF"]) {
					realBoltColor = returnUIColor(lightningColor);
				}
			}
		}
		_logos_orig$_ungrouped$_UIBatteryView$setBoltColor$(self, _cmd, realBoltColor);
	}

	
	static void _logos_method$_ungrouped$_UIBatteryView$setIconSize$(_LOGOS_SELF_TYPE_NORMAL _UIBatteryView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSInteger realIconSize) {
		if(enabled) {
			realIconSize = batterySize;
		}
		_logos_orig$_ungrouped$_UIBatteryView$setIconSize$(self, _cmd, realIconSize);
	}

	
	static void _logos_method$_ungrouped$_UIBatteryView$setSaverModeActive$(_LOGOS_SELF_TYPE_NORMAL _UIBatteryView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, BOOL active) {
		if(enabled) {
			if(active == false) {
				if(isPercentageReplaceEnabled) {
					((UILabel *)[self.superview viewWithTag:51603]).textColor = returnUIColor(percentageReplaceColor);
				}
				
				[self setBodyColor:returnUIColor(batteryExteriorColor)];
			}
			else if(self.chargingState == 1) {
				
			}
			else {
				if(isPercentageReplaceEnabled) {
					((UILabel *)[self.superview viewWithTag:51603]).textColor = [UIColor colorWithRed:1.00 green:0.84 blue:0.04 alpha:1.00];
				}
				
				[self setBodyColor:[UIColor colorWithRed:1.00 green:0.84 blue:0.04 alpha:1.00]];
				active = false;
			}
		}
		_logos_orig$_ungrouped$_UIBatteryView$setSaverModeActive$(self, _cmd, active);
	}

	
	static void _logos_method$_ungrouped$_UIBatteryView$setChargingState$(_LOGOS_SELF_TYPE_NORMAL _UIBatteryView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSInteger realChargingState) {
		_logos_orig$_ungrouped$_UIBatteryView$setChargingState$(self, _cmd, realChargingState);

		if(enabled) {
			
			if (@available(iOS 13.0, *)) {
				[self setBoltColor:returnUIColor(lightningColor)];
			}

			
			if(realChargingState == 1) {
				if(isPercentageReplaceEnabled) {
					((UILabel *)[self.superview viewWithTag:51603]).textColor = [UIColor colorWithRed:0.19 green:0.82 blue:0.35 alpha:1.00];
				}
				[self setBodyColor:[UIColor colorWithRed:0.19 green:0.82 blue:0.35 alpha:1.00]];
			}

			
			else if(self.saverModeActive == 1) {
				if(isPercentageReplaceEnabled) {
					((UILabel *)[self.superview viewWithTag:51603]).textColor = [UIColor colorWithRed:1.00 green:0.84 blue:0.04 alpha:1.00];
				}
				[self setBodyColor:[UIColor colorWithRed:1.00 green:0.84 blue:0.04 alpha:1.00]];
			}

			else {
				if(isPercentageReplaceEnabled && ![percentageReplaceColor isEqual:@"#FFFFFF"]) {
					((UILabel *)[self.superview viewWithTag:51603]).textColor = returnUIColor(percentageReplaceColor);
				}
				else {
					((UILabel *)[self.superview viewWithTag:51603]).textColor = returnUIColor(@"#FFFFFF");
				}
			}
		}
	}




static __attribute__((constructor)) void _logosLocalCtor_dcd28ce4(int __unused argc, char __unused **argv, char __unused **envp) {
	preferences = [[HBPreferences alloc] initWithIdentifier:@"dev.aryanjnambiar.wonderbarprefs"];

	[preferences registerBool:&enabled default:YES forKey:@"ENABLED"];
	[preferences registerBool:&isBarHidden default:NO forKey:@"HIDDEN"];

	[preferences registerObject:&textColor default:@"#FFFFFF" forKey:@"textColor"];
	[preferences registerObject:&textContent default:@"" forKey:@"textContent"];
	[preferences registerBool:&dateEnabled default:NO forKey:@"dateEnabled"];

	[preferences registerObject:&activeWifiColor default:@"#FFFFFF" forKey:@"activeWifiColor"];
	[preferences registerObject:&inactiveWifiColor default:@"#878182" forKey:@"inactiveWifiColor"];

	[preferences registerObject:&activeCellularColor default:@"#FFFFFF" forKey:@"activeCellularColor"];
	[preferences registerObject:&inactiveCellularColor default:@"#878182" forKey:@"inactiveCellularColor"];

	[preferences registerObject:&batteryExteriorColor default:@"#878182" forKey:@"batteryExteriorColor"];
	[preferences registerObject:&batteryFillColor default:@"#FFFFFF" forKey:@"batteryFillColor"];
	[preferences registerBool:&isPercentageEnabled default:NO forKey:@"isPercentageEnabled"];
	[preferences registerObject:&lightningColor default:@"#FFFFFF" forKey:@"lightningColor"];
	[preferences registerBool:&isPercentageReplaceEnabled default:NO forKey:@"isPercentageReplaceEnabled"];
	[preferences registerObject:&percentageReplaceColor default:@"#FFFFFF" forKey:@"percentageReplaceColor"];
	[preferences registerInteger:&batterySize default:2 forKey:@"batteryIconSize"];

	
	[[NSDistributedNotificationCenter defaultCenter] addObserverForName:@"dev.aryanjnambiar.wonderbarprefs/ReloadPrefs" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
		[preferences setBool:YES forKey:@"ENABLED"];
		[preferences setBool:NO forKey:@"HIDDEN"];

		[preferences setObject:@"#FFFFFF" forKey:@"textColor"];
		[preferences setObject:@"" forKey:@"textContent"];
		[preferences setBool:NO forKey:@"dateEnabled"];

		[preferences setObject:@"#FFFFFF" forKey:@"activeWifiColor"];
		[preferences setObject:@"#878182" forKey:@"inactiveWifiColor"];

		[preferences setObject:@"#FFFFFF" forKey:@"activeCellularColor"];
		[preferences setObject:@"#878182" forKey:@"inactiveCellularColor"];

		[preferences setObject:@"#878182" forKey:@"batteryExteriorColor"];
		[preferences setObject:@"#FFFFFF" forKey:@"batteryFillColor"];
		[preferences setBool:NO forKey:@"isPercentageEnabled"];
		[preferences setObject:@"#FFFFFF" forKey:@"lightningColor"];
		[preferences setBool:NO forKey:@"isPercentageReplaceEnabled"];
		[preferences setObject:@"#FFFFFF" forKey:@"percentageReplaceColor"];
		[preferences setInteger:2 forKey:@"batteryIconSize"];

		[preferences synchronize];
	}];
}
static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$SBDeviceApplicationSceneStatusBarBreadcrumbProvider = objc_getClass("SBDeviceApplicationSceneStatusBarBreadcrumbProvider"); Class _logos_metaclass$_ungrouped$SBDeviceApplicationSceneStatusBarBreadcrumbProvider = object_getClass(_logos_class$_ungrouped$SBDeviceApplicationSceneStatusBarBreadcrumbProvider); MSHookMessageEx(_logos_metaclass$_ungrouped$SBDeviceApplicationSceneStatusBarBreadcrumbProvider, @selector(_shouldAddBreadcrumbToActivatingSceneEntity:sceneHandle:withTransitionContext:), (IMP)&_logos_meta_method$_ungrouped$SBDeviceApplicationSceneStatusBarBreadcrumbProvider$_shouldAddBreadcrumbToActivatingSceneEntity$sceneHandle$withTransitionContext$, (IMP*)&_logos_meta_orig$_ungrouped$SBDeviceApplicationSceneStatusBarBreadcrumbProvider$_shouldAddBreadcrumbToActivatingSceneEntity$sceneHandle$withTransitionContext$);Class _logos_class$_ungrouped$_UIStatusBarStringView = objc_getClass("_UIStatusBarStringView"); MSHookMessageEx(_logos_class$_ungrouped$_UIStatusBarStringView, @selector(setText:), (IMP)&_logos_method$_ungrouped$_UIStatusBarStringView$setText$, (IMP*)&_logos_orig$_ungrouped$_UIStatusBarStringView$setText$);MSHookMessageEx(_logos_class$_ungrouped$_UIStatusBarStringView, @selector(setNumberOfLines:), (IMP)&_logos_method$_ungrouped$_UIStatusBarStringView$setNumberOfLines$, (IMP*)&_logos_orig$_ungrouped$_UIStatusBarStringView$setNumberOfLines$);MSHookMessageEx(_logos_class$_ungrouped$_UIStatusBarStringView, @selector(setFont:), (IMP)&_logos_method$_ungrouped$_UIStatusBarStringView$setFont$, (IMP*)&_logos_orig$_ungrouped$_UIStatusBarStringView$setFont$);MSHookMessageEx(_logos_class$_ungrouped$_UIStatusBarStringView, @selector(setTextColor:), (IMP)&_logos_method$_ungrouped$_UIStatusBarStringView$setTextColor$, (IMP*)&_logos_orig$_ungrouped$_UIStatusBarStringView$setTextColor$);Class _logos_class$_ungrouped$_UIStatusBarForegroundView = objc_getClass("_UIStatusBarForegroundView"); MSHookMessageEx(_logos_class$_ungrouped$_UIStatusBarForegroundView, @selector(setHidden:), (IMP)&_logos_method$_ungrouped$_UIStatusBarForegroundView$setHidden$, (IMP*)&_logos_orig$_ungrouped$_UIStatusBarForegroundView$setHidden$);MSHookMessageEx(_logos_class$_ungrouped$_UIStatusBarForegroundView, @selector(setNeedsLayout), (IMP)&_logos_method$_ungrouped$_UIStatusBarForegroundView$setNeedsLayout, (IMP*)&_logos_orig$_ungrouped$_UIStatusBarForegroundView$setNeedsLayout);{ char _typeEncoding[1024]; sprintf(_typeEncoding, "%s@:", @encode(BOOL)); class_addMethod(_logos_class$_ungrouped$_UIStatusBarForegroundView, @selector(hidden), (IMP)&_logos_method$_ungrouped$_UIStatusBarForegroundView$hidden, _typeEncoding); sprintf(_typeEncoding, "v@:%s", @encode(BOOL)); class_addMethod(_logos_class$_ungrouped$_UIStatusBarForegroundView, @selector(setHidden:), (IMP)&_logos_method$_ungrouped$_UIStatusBarForegroundView$setHidden, _typeEncoding); } Class _logos_class$_ungrouped$_UIStatusBarCellularSignalView = objc_getClass("_UIStatusBarCellularSignalView"); MSHookMessageEx(_logos_class$_ungrouped$_UIStatusBarCellularSignalView, @selector(setActiveColor:), (IMP)&_logos_method$_ungrouped$_UIStatusBarCellularSignalView$setActiveColor$, (IMP*)&_logos_orig$_ungrouped$_UIStatusBarCellularSignalView$setActiveColor$);MSHookMessageEx(_logos_class$_ungrouped$_UIStatusBarCellularSignalView, @selector(setInactiveColor:), (IMP)&_logos_method$_ungrouped$_UIStatusBarCellularSignalView$setInactiveColor$, (IMP*)&_logos_orig$_ungrouped$_UIStatusBarCellularSignalView$setInactiveColor$);Class _logos_class$_ungrouped$_UIStatusBarWifiSignalView = objc_getClass("_UIStatusBarWifiSignalView"); MSHookMessageEx(_logos_class$_ungrouped$_UIStatusBarWifiSignalView, @selector(setActiveColor:), (IMP)&_logos_method$_ungrouped$_UIStatusBarWifiSignalView$setActiveColor$, (IMP*)&_logos_orig$_ungrouped$_UIStatusBarWifiSignalView$setActiveColor$);MSHookMessageEx(_logos_class$_ungrouped$_UIStatusBarWifiSignalView, @selector(setInactiveColor:), (IMP)&_logos_method$_ungrouped$_UIStatusBarWifiSignalView$setInactiveColor$, (IMP*)&_logos_orig$_ungrouped$_UIStatusBarWifiSignalView$setInactiveColor$);Class _logos_class$_ungrouped$_UIBatteryView = objc_getClass("_UIBatteryView"); MSHookMessageEx(_logos_class$_ungrouped$_UIBatteryView, @selector(layoutSubviews), (IMP)&_logos_method$_ungrouped$_UIBatteryView$layoutSubviews, (IMP*)&_logos_orig$_ungrouped$_UIBatteryView$layoutSubviews);{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(CGRect), strlen(@encode(CGRect))); i += strlen(@encode(CGRect)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$_UIBatteryView, @selector(initPercentageLabel:), (IMP)&_logos_method$_ungrouped$_UIBatteryView$initPercentageLabel$, _typeEncoding); }MSHookMessageEx(_logos_class$_ungrouped$_UIBatteryView, @selector(setAlpha:), (IMP)&_logos_method$_ungrouped$_UIBatteryView$setAlpha$, (IMP*)&_logos_orig$_ungrouped$_UIBatteryView$setAlpha$);MSHookMessageEx(_logos_class$_ungrouped$_UIBatteryView, @selector(setShowsInlineChargingIndicator:), (IMP)&_logos_method$_ungrouped$_UIBatteryView$setShowsInlineChargingIndicator$, (IMP*)&_logos_orig$_ungrouped$_UIBatteryView$setShowsInlineChargingIndicator$);MSHookMessageEx(_logos_class$_ungrouped$_UIBatteryView, @selector(setShowsPercentage:), (IMP)&_logos_method$_ungrouped$_UIBatteryView$setShowsPercentage$, (IMP*)&_logos_orig$_ungrouped$_UIBatteryView$setShowsPercentage$);MSHookMessageEx(_logos_class$_ungrouped$_UIBatteryView, @selector(setBodyColor:), (IMP)&_logos_method$_ungrouped$_UIBatteryView$setBodyColor$, (IMP*)&_logos_orig$_ungrouped$_UIBatteryView$setBodyColor$);MSHookMessageEx(_logos_class$_ungrouped$_UIBatteryView, @selector(setChargePercent:), (IMP)&_logos_method$_ungrouped$_UIBatteryView$setChargePercent$, (IMP*)&_logos_orig$_ungrouped$_UIBatteryView$setChargePercent$);MSHookMessageEx(_logos_class$_ungrouped$_UIBatteryView, @selector(setFillColor:), (IMP)&_logos_method$_ungrouped$_UIBatteryView$setFillColor$, (IMP*)&_logos_orig$_ungrouped$_UIBatteryView$setFillColor$);MSHookMessageEx(_logos_class$_ungrouped$_UIBatteryView, @selector(setBoltColor:), (IMP)&_logos_method$_ungrouped$_UIBatteryView$setBoltColor$, (IMP*)&_logos_orig$_ungrouped$_UIBatteryView$setBoltColor$);MSHookMessageEx(_logos_class$_ungrouped$_UIBatteryView, @selector(setIconSize:), (IMP)&_logos_method$_ungrouped$_UIBatteryView$setIconSize$, (IMP*)&_logos_orig$_ungrouped$_UIBatteryView$setIconSize$);MSHookMessageEx(_logos_class$_ungrouped$_UIBatteryView, @selector(setSaverModeActive:), (IMP)&_logos_method$_ungrouped$_UIBatteryView$setSaverModeActive$, (IMP*)&_logos_orig$_ungrouped$_UIBatteryView$setSaverModeActive$);MSHookMessageEx(_logos_class$_ungrouped$_UIBatteryView, @selector(setChargingState:), (IMP)&_logos_method$_ungrouped$_UIBatteryView$setChargingState$, (IMP*)&_logos_orig$_ungrouped$_UIBatteryView$setChargingState$);{ char _typeEncoding[1024]; sprintf(_typeEncoding, "%s@:", @encode(UIColor *)); class_addMethod(_logos_class$_ungrouped$_UIBatteryView, @selector(bodyColor), (IMP)&_logos_method$_ungrouped$_UIBatteryView$bodyColor, _typeEncoding); sprintf(_typeEncoding, "v@:%s", @encode(UIColor *)); class_addMethod(_logos_class$_ungrouped$_UIBatteryView, @selector(setBodyColor:), (IMP)&_logos_method$_ungrouped$_UIBatteryView$setBodyColor, _typeEncoding); } { char _typeEncoding[1024]; sprintf(_typeEncoding, "%s@:", @encode(NSInteger)); class_addMethod(_logos_class$_ungrouped$_UIBatteryView, @selector(chargingState), (IMP)&_logos_method$_ungrouped$_UIBatteryView$chargingState, _typeEncoding); sprintf(_typeEncoding, "v@:%s", @encode(NSInteger)); class_addMethod(_logos_class$_ungrouped$_UIBatteryView, @selector(setChargingState:), (IMP)&_logos_method$_ungrouped$_UIBatteryView$setChargingState, _typeEncoding); } { char _typeEncoding[1024]; sprintf(_typeEncoding, "%s@:", @encode(BOOL)); class_addMethod(_logos_class$_ungrouped$_UIBatteryView, @selector(saverModeActive), (IMP)&_logos_method$_ungrouped$_UIBatteryView$saverModeActive, _typeEncoding); sprintf(_typeEncoding, "v@:%s", @encode(BOOL)); class_addMethod(_logos_class$_ungrouped$_UIBatteryView, @selector(setSaverModeActive:), (IMP)&_logos_method$_ungrouped$_UIBatteryView$setSaverModeActive, _typeEncoding); } { char _typeEncoding[1024]; sprintf(_typeEncoding, "%s@:", @encode(BOOL)); class_addMethod(_logos_class$_ungrouped$_UIBatteryView, @selector(isPercentInit), (IMP)&_logos_method$_ungrouped$_UIBatteryView$isPercentInit, _typeEncoding); sprintf(_typeEncoding, "v@:%s", @encode(BOOL)); class_addMethod(_logos_class$_ungrouped$_UIBatteryView, @selector(setIsPercentInit:), (IMP)&_logos_method$_ungrouped$_UIBatteryView$setIsPercentInit, _typeEncoding); } } }
#line 493 "Tweak.x"
