#import <Cephei/HBPreferences.h>

//Initialize variables
HBPreferences *preferences;
BOOL enabled;
BOOL isPercentageEnabled;
NSString * textColor;
NSString * textContent;
NSString * batteryExteriorColor;
NSString * batteryFillColor;
NSString * lightningColor;
NSInteger batterySize;

//Declare the UIBatteryView interface so that I can alter some of these properties/access these functions later in the code.
@interface _UIBatteryView : UIView
@property (nonatomic, copy) UIColor *bodyColor;
@property (nonatomic, assign) NSInteger chargingState;
@property (nonatomic, assign) BOOL saverModeActive;
- (void)setBodyColor:(UIColor *)realBodyColor;
- (void)setBoltColor:(UIColor * )realBoltColor;
@end

//Unnecessary code (for now) - working on adding a toggle to hide status bar in the future
@interface _UIStatusBar
@property (nonatomic, assign, readwrite, getter=isHidden) BOOL hidden;
-(void)setHidden:(BOOL)hidden;
@end

//This is a function that converts a given hex code into a UIColor object
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

//This is a function that converts a given UIColor object into a hex code in string format
NSString * hexStringForColor(UIColor * color) {
      const CGFloat *components = CGColorGetComponents(color.CGColor);
      CGFloat r = components[0];
      CGFloat g = components[1];
      CGFloat b = components[2];
      NSString *hexString=[NSString stringWithFormat:@"%02X%02X%02X", (int)(r * 255), (int)(g * 255), (int)(b * 255)];
      return hexString;
}

//Hooks all objects of the type UIStatusBarStringView.
%hook _UIStatusBarStringView

	//Sets text content
	- (void)setText:(NSString *)text {
		if(enabled) {
			//(Mildly) hacky way to figure out whether it's the time string on the status bar and set it to user's choice.
			if(![textContent isEqual:@""] && [text containsString:@":"]) {
				text = textContent;
			}
		}
		%orig;
	}

	//Sets text color
	- (void)setTextColor:(UIColor *)realTextColor {
		if(enabled) {
			if(![textColor isEqual:@"#FFFFFF"]) {
				realTextColor = returnUIColor(textColor);
			}
		}
		%orig;
	}
%end


//Hooks the battery view on all devices with a modern status bar.
%hook _UIBatteryView

	%property (nonatomic, copy) UIColor *bodyColor;
	%property (nonatomic, assign) NSInteger chargingState;
	%property (nonatomic, assign) BOOL saverModeActive;

	//If the show percentage option is selected, it prevents the bolt icon from showing up to block that.
	- (void)setShowsInlineChargingIndicator:(BOOL)realBoltIcon {
		if(enabled) {
			if(isPercentageEnabled) {
				realBoltIcon = NO;
			}
		}
		%orig;
	}

	//Shows percentage if the user has that option selected.
	- (void)setShowsPercentage:(BOOL)realShowsPercentage {
		if(enabled) {
			if(isPercentageEnabled) {
				realShowsPercentage = YES;
			}
		}
		%orig;
	}

	//Sets the body (exterior) color based on user options.
	- (void)setBodyColor:(UIColor *)realBodyColor {
		if(enabled) {

			NSString * hex = hexStringForColor(realBodyColor);

			//If the device is currently charging, set the body (exterior) color to green so it's visible
			if(self.chargingState == 1) {
				realBodyColor = [UIColor colorWithRed:0.19 green:0.82 blue:0.35 alpha:1.00];
			}

			else if([hex isEqual:@"FFD60A"]) {
				//Do nothing because it's going into low power mode.
			}

			else {
				//Temporary - color is set to this default as alderis currently doesn't support opacity. Will be updated once it does.
				if(![batteryExteriorColor isEqual:@"#878182"]) {
					realBodyColor = returnUIColor(batteryExteriorColor);
				}
				else {
					//If color is set to #878182 hex code, it defaults to this.
					realBodyColor = [UIColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:0.40];
				}
			}
		}
		%orig;
		[self setNeedsDisplay];
		[self setNeedsLayout];
	}

	//Sets the fill (interior) color of the battery
	- (void)setFillColor:(UIColor *)realFillColor {
		if(enabled) {
			if(![batteryFillColor isEqual:@""]) {
				realFillColor = returnUIColor(batteryFillColor);
			}
		}
		%orig;
	}

	//Sets the lightning bolt icon color. This method was added in iOS 13, so we must check if the device is on any version above 13.0 to make sure the tweak doesn't crash the device.
	- (void)setBoltColor:(UIColor * )realBoltColor {
		if(@available(iOS 13.0, *)) {
			if(enabled) {
				if(![lightningColor isEqual:@"#FFFFFF"]) {
					realBoltColor = returnUIColor(lightningColor);
				}
			}
		}
		%orig;
	}

	//Sets the size of the battery icon.
	- (void)setIconSize:(NSInteger)realIconSize {
		if(enabled) {
			realIconSize = batterySize;
		}
		%orig;
	}

	//This method is called when the device is set to power saver mode or if it's being turned off. This is hooked to make sure that functionality works when the percentage is displayed. 
	- (void)setSaverModeActive:(BOOL)active {
		if(enabled) {
			if(active == false) {
				// If power saver mode is being turned off, change it back to the user's previously set body color.
				[self setBodyColor:returnUIColor(batteryExteriorColor)];
			}
			else if(self.chargingState == 1) {
				// Do nothing because the body color has already been changed to green when it entered the charging state.

			}
			else {
				// set the border to be yellow
				[self setBodyColor:[UIColor colorWithRed:1.00 green:0.84 blue:0.04 alpha:1.00]];
				active = false;
			}
		}
		%orig;
	}

	// This method is called when the device begins/stops being charged. This is hooked to make sure that functionality works when the percentage is being displayed. 
	- (void)setChargingState:(NSInteger)realChargingState {
		%orig;
		if(enabled) {
			// If the user is on iOS 13, set the bolt color to the user's choice. 
			if (@available(iOS 13.0, *)) {
				[self setBoltColor:returnUIColor(lightningColor)];
			}

			// If the device is starting to charge, make the body color green so the user can see this.
			if(realChargingState == 1) {
				[self setBodyColor:[UIColor colorWithRed:0.19 green:0.82 blue:0.35 alpha:1.00]];
			}

			// If the device is not getting charged anymore and low power mode is on, make the body color yellow so the user knows it's enabled.
			else if(self.saverModeActive == 1) {
				[self setBodyColor:[UIColor colorWithRed:1.00 green:0.84 blue:0.04 alpha:1.00]];
			}
		}
	}

%end

//Initialize preferences using Cephei
%ctor {
	preferences = [[HBPreferences alloc] initWithIdentifier:@"dev.aryanjnambiar.wonderbarprefs"];

	[preferences registerBool:&enabled default:YES forKey:@"ENABLED"];

	[preferences registerObject:&textColor default:@"#FFFFFF" forKey:@"textColor"];
	[preferences registerObject:&textContent default:@"" forKey:@"textContent"];

	[preferences registerObject:&batteryExteriorColor default:@"#878182" forKey:@"batteryExteriorColor"];
	[preferences registerObject:&batteryFillColor default:@"#FFFFFF" forKey:@"batteryFillColor"];
	[preferences registerBool:&isPercentageEnabled default:NO forKey:@"isPercentageEnabled"];
	[preferences registerObject:&lightningColor default:@"#FFFFFF" forKey:@"lightningColor"];
	[preferences registerInteger:&batterySize default:2 forKey:@"batteryIconSize"];
}