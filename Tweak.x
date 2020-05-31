#import <Cephei/HBPreferences.h>
#import <Foundation/NSDistributedNotificationCenter.h>
#import <objc/objc-runtime.h>

//Initialize variables
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

//Declare the UIBatteryView interface so that I can alter some of these properties/access these functions later in the code.
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

//Declare the _UIStatusBarForegroundView interface so that I can alter some of these properties/access these functions later in the code.
@interface _UIStatusBarForegroundView : UIView
@property (nonatomic, assign, readwrite, getter=isHidden) BOOL hidden;
-(void)setHidden:(BOOL)changeHidden;
-(BOOL)isHidden;
-(void)addSubview:(UIView *)item;
@end

//Declare the _UIStatusBarStringView interface so that I can alter some of these properties/access these functions later in the code.
@interface _UIStatusBarStringView : UIView
-(void)setNumberOfLines:(NSInteger)num;
-(void)setFont:(UIFont *)font;
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

%hook SBDeviceApplicationSceneStatusBarBreadcrumbProvider

+(BOOL)_shouldAddBreadcrumbToActivatingSceneEntity:(id)arg1 sceneHandle:(id)arg2 withTransitionContext:(id)arg3 {
	if(dateEnabled && enabled) {
		return FALSE;
	}
	return %orig;
}

%end

//Hooks all objects of the type UIStatusBarStringView.
%hook _UIStatusBarStringView

	//Sets text content
	- (void)setText:(NSString *)text {
		if(enabled) {
			//(Mildly) hacky way to figure out whether it's the time string on the status bar and set it to user's choice.
			if(![textContent isEqual:@""] && [text containsString:@":"]) {
				text = textContent;
			}

			else if(dateEnabled && [text containsString:@":"]) {
				NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
				[dateFormatter setDateFormat:@"MM/dd"];

				[self setFont:[UIFont boldSystemFontOfSize:13]];
				[self setNumberOfLines:2];

				// text = textContent + @"\n" + [dateFormatter stringFromDate:[NSDate date]];
				// text = @"05/23\n12:00";

				NSString * date = [dateFormatter stringFromDate:[NSDate date]];

				if(![textContent isEqual:@""]) {
					text = [NSString stringWithFormat:@"%@\n%@", date, textContent];
				}
				else {
					text = [NSString stringWithFormat:@"%@\n%@", date, text];
				}
			}
		}

		%orig;
	}

	- (void)setNumberOfLines:(NSInteger)num {
		if(enabled && dateEnabled) {
			num = 2;
		}
		%orig;
	}

	- (void)setFont:(UIFont *)font {
		if(enabled && dateEnabled) {
			font = [font fontWithSize:13];
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

//Hooks the status bar view.
%hook _UIStatusBarForegroundView

	%property (nonatomic, assign) BOOL hidden;

	//If the user wants the status bar hidden, this keeps it hidden regardless of what the system tries to do.
	- (void)setHidden:(BOOL)changeHidden {
		if(enabled) {
			if(isBarHidden) {
				changeHidden = TRUE;
			}
		}
		%orig;
	}

	//Sets the status bar to be hidden when the view is created.
	-(void)setNeedsLayout {
		if(enabled) {
			if(isBarHidden) {
				self.hidden = TRUE;
			}
		}
		%orig;
	}

%end

%hook _UIStatusBarCellularSignalView

	-(void)setActiveColor:(id)color {
		if(enabled) {
			if(![activeCellularColor isEqual:@"#FFFFFF"]) {
				color = returnUIColor(activeCellularColor);
			}
		}
		%orig;
	}

	-(void)setInactiveColor:(id)color {
		if(enabled) {
			if(![inactiveCellularColor isEqual:@"#878182"]) {
				color = returnUIColor(inactiveCellularColor);
			}
		}
		%orig;
	}

%end

%hook _UIStatusBarWifiSignalView

	-(void)setActiveColor:(id)color {
		if(enabled) {
			if(![activeWifiColor isEqual:@"#FFFFFF"]) {
				color = returnUIColor(activeWifiColor);
			}
		}
		%orig;
	}

	-(void)setInactiveColor:(id)color {
		if(enabled) {
			if(![inactiveWifiColor isEqual:@"#878182"]) {
				color = returnUIColor(inactiveWifiColor);
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
	%property (nonatomic, assign) BOOL isPercentInit;

	- (void)layoutSubviews {
		%orig;

		if(enabled) {
			if(!self.isPercentInit && isPercentageReplaceEnabled) {
				[self initPercentageLabel:self.frame];
				[self setChargingState:self.chargingState];
			}
		}
	}

	%new
	- (void)initPercentageLabel:(CGRect) frame {
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

	- (void)setAlpha:(CGFloat)newAlpha {
		if(enabled && isPercentageReplaceEnabled) {
			newAlpha = 0.0;
		}
		%orig;
	}

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
				if(isPercentageReplaceEnabled) {
					((UILabel *)[self.superview viewWithTag:51603]).textColor = [UIColor colorWithRed:0.19 green:0.82 blue:0.35 alpha:1.00];
				}
				realBodyColor = [UIColor colorWithRed:0.19 green:0.82 blue:0.35 alpha:1.00];
			}

			else if([hex isEqual:@"FFD60A"]) {
				if(isPercentageReplaceEnabled) {
					((UILabel *)[self.superview viewWithTag:51603]).textColor = realBodyColor;
				}
				//Do nothing because it's going into low power mode.
			}

			else {
				if(isPercentageReplaceEnabled && [percentageReplaceColor isEqual:@"#FFFFFF"]) {
					((UILabel *)[self.superview viewWithTag:51603]).textColor = returnUIColor(percentageReplaceColor);
				}
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

	-(void)setChargePercent:(double)arg1 {
		%orig;
		if(enabled && isPercentageReplaceEnabled) {
			[((UILabel *)[self.superview viewWithTag:51603]) setText: [[NSString stringWithFormat:@"%d",(int)([self chargePercent] * 100)] stringByAppendingString:@"%"]];
			[((UILabel *)[self.superview viewWithTag:51603]) sizeToFit];
		}
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
				if(isPercentageReplaceEnabled) {
					((UILabel *)[self.superview viewWithTag:51603]).textColor = returnUIColor(percentageReplaceColor);
				}
				// If power saver mode is being turned off, change it back to the user's previously set body color.
				[self setBodyColor:returnUIColor(batteryExteriorColor)];
			}
			else if(self.chargingState == 1) {
				// Do nothing because the body color has already been changed to green when it entered the charging state.
			}
			else {
				if(isPercentageReplaceEnabled) {
					((UILabel *)[self.superview viewWithTag:51603]).textColor = [UIColor colorWithRed:1.00 green:0.84 blue:0.04 alpha:1.00];
				}
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
				if(isPercentageReplaceEnabled) {
					((UILabel *)[self.superview viewWithTag:51603]).textColor = [UIColor colorWithRed:0.19 green:0.82 blue:0.35 alpha:1.00];
				}
				[self setBodyColor:[UIColor colorWithRed:0.19 green:0.82 blue:0.35 alpha:1.00]];
			}

			// If the device is not getting charged anymore and low power mode is on, make the body color yellow so the user knows it's enabled.
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

%end

//Initialize preferences using Cephei
%ctor {
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

	// Resets preferences to default.
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