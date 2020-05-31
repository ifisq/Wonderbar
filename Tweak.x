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

//This is a function that converts a given hex code into a UIColor object. This function was taken from https://stackoverflow.com/a/3805354. Take a look!
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

//This is a function that converts a given UIColor object into a hex code in string format. This function was taken from https://stackoverflow.com/a/14051861. Take a look!
NSString * hexStringForColor(UIColor * color) {
      const CGFloat *components = CGColorGetComponents(color.CGColor);
      CGFloat r = components[0];
      CGFloat g = components[1];
      CGFloat b = components[2];
      NSString *hexString=[NSString stringWithFormat:@"%02X%02X%02X", (int)(r * 255), (int)(g * 255), (int)(b * 255)];
      return hexString;
}

// Hooks this class so that we can disable breadcrumbs. A breadcrumb is the <- app button that pops up to go back to the previous app in the status bar.
%hook SBDeviceApplicationSceneStatusBarBreadcrumbProvider

	// If the tweak & date are enabled, we disable breadcrumbs. This is because a breadcrumb will mess with the positioning of the date view.
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

			// If the date is enabled, and the time is being changed.
			if(dateEnabled && [text containsString:@":"]) {

				// This creates a date formatter that gives us a date in the format MM/dd (e.g. 05/16)
				NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
				[dateFormatter setDateFormat:@"MM/dd"];

				// Fixes some of the stringview's properties to account for the date being added + another line being needed.
				[self setFont:[UIFont boldSystemFontOfSize:13]];
				[self setNumberOfLines:2];

				// We get the current date in a string format using the date formatter.
				NSString * date = [dateFormatter stringFromDate:[NSDate date]];

				// If the user replaced the time with custom text, set the string to the date + the custom text.
				if(![textContent isEqual:@""]) {
					text = [NSString stringWithFormat:@"%@\n%@", date, textContent];
				}

				// If the user doesn't want custom text, set the string to the date + time.
				else {
					text = [NSString stringWithFormat:@"%@\n%@", date, text];
				}
			}

			//If the user doesn't have the date enabled but has a custom text, set the string to that text.
			else if(![textContent isEqual:@""] && [text containsString:@":"]) {
				text = textContent;
			}
		}

		%orig;
	}

	// If the user wants to display the date, set the number of lines in the label to 2 so that we can fit both.
	- (void)setNumberOfLines:(NSInteger)num {
		if(enabled && dateEnabled) {
			num = 2;
		}
		%orig;
	}

	// If the user wants the date in the status bar, we have to change the system font to fit it.
	- (void)setFont:(UIFont *)font {
		if(enabled && dateEnabled) {
			font = [font fontWithSize:13];
		}
		%orig;
	}

	//If the user wants a custom text color, this sets it to their choice.
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

// This hooks the Cellular icon on the status bar.
%hook _UIStatusBarCellularSignalView

	// If the user wants a custom color for the main color on the cellular icon (active bars), set it to their choice.
	-(void)setActiveColor:(id)color {
		if(enabled) {
			if(![activeCellularColor isEqual:@"#FFFFFF"]) {
				color = returnUIColor(activeCellularColor);
			}
		}
		%orig;
	}

	// If the user wants a custom color for the secondary color on the cellular icon (inactive bars), set it to their choice.
	-(void)setInactiveColor:(id)color {
		if(enabled) {
			if(![inactiveCellularColor isEqual:@"#878182"]) {
				color = returnUIColor(inactiveCellularColor);
			}
		}
		%orig;
	}

%end

// This hooks the WiFi icon on the status bar.
%hook _UIStatusBarWifiSignalView

	// If the user wants a custom color for the main color on the WiFi icon (active bars), set it to their choice.
	-(void)setActiveColor:(id)color {
		if(enabled) {
			if(![activeWifiColor isEqual:@"#FFFFFF"]) {
				color = returnUIColor(activeWifiColor);
			}
		}
		%orig;
	}

	// If the user wants a custom color for the secondary color on the WiFi icon (inactive bars), set it to their choice.
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

	// Initializes properties of the class that we will refer to later.
	%property (nonatomic, copy) UIColor *bodyColor;
	%property (nonatomic, assign) NSInteger chargingState;
	%property (nonatomic, assign) BOOL saverModeActive;
	%property (nonatomic, assign) BOOL isPercentInit;

	// Whenever the view is refreshed this method is called. We can use this to our advantage to reload our custom percentage view.
	- (void)layoutSubviews {
		%orig;

		if(enabled) {
			// If the tweak is enabled, the user has selected the custom percentage view, and if it hasn't already been created, we create it and call the setChargingState function to ensure that when the view loads, it has the correct charging state.
			if(isPercentageReplaceEnabled && !self.isPercentInit) {
				[self initPercentageLabel:self.frame];
				[self setChargingState:self.chargingState];
			}
		}
	}

	// This is a new method I created to initialize my custom battery percentage view. This is only called if the user has the option enabled in settings.
	%new
	- (void)initPercentageLabel:(CGRect) frame {
		if(enabled) {
			// I create a new UILabel (since we're just displaying a percentage) and initialize it with the same frame as the normal battery, which we will hide later.
			UILabel *batteryLabel = [[UILabel alloc]initWithFrame:frame];
			NSString *percentCharge = [NSString stringWithFormat:@"%d",(int)([self chargePercent] * 100)];
			[batteryLabel setText:[percentCharge stringByAppendingString:@"%"]];
			[batteryLabel setBounds:self.bounds];
			[batteryLabel setCenter:self.center];
			[batteryLabel setFont:[UIFont boldSystemFontOfSize:12]];
			batteryLabel.adjustsFontSizeToFitWidth = YES;
			// If the user has a custom battery text color enabled, this sets it to their choice.
			if(![percentageReplaceColor isEqual:@"#FFFFFF"]) {
				[batteryLabel setTextColor:returnUIColor(percentageReplaceColor)];
			}
			// Otherwise, it just makes it white. 
			else {
				[batteryLabel setTextColor:[UIColor whiteColor]];
			}
			// This next part is mostly just setting formatting so that it looks okay.
			[batteryLabel setTextAlignment:NSTextAlignmentRight];
			[batteryLabel setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];
			[batteryLabel setLineBreakMode:NSLineBreakByCharWrapping];
			[batteryLabel setNumberOfLines:1];
			// I gave this a tag so that we can refer to it later from the superview, _UIStatusBarForegroundView (the status bar view) when we need to update percentage. 5/16/03 is also my birthday :)
			[batteryLabel setTag:51603];
			// Adds my custom view as a subview of _UIStatusBarForegroundView (the status bar view) which displays it in the status bar.
			[self.superview addSubview:batteryLabel];
			// Shows that the percentage view is initialized so that it doesn't get repeatedly created every time layoutSubviews is called.
			self.isPercentInit = TRUE;
			// Hides the battery view, making it so that you can only see the percentage view now.
			[self setHidden:TRUE];
			[batteryLabel sizeToFit];
		}
	}

	// If the battery icon is replaced with my custom percentage view, this sets the alpha to 0.0 so it's invisible. This may not be necessary anymore, but I kept it in here for now as insurance.
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

			//If the device is currently charging...
			if(self.chargingState == 1) {
				// If the custom battery percentage view is enabled, it gets it through its superview _UIStatusBarForegroundView and sets the label's text color to green to signify that it is charging.
				if(isPercentageReplaceEnabled) {
					((UILabel *)[self.superview viewWithTag:51603]).textColor = [UIColor colorWithRed:0.19 green:0.82 blue:0.35 alpha:1.00];
				}
				//Set the battery icon's body (exterior) color to green so it's visible
				realBodyColor = [UIColor colorWithRed:0.19 green:0.82 blue:0.35 alpha:1.00];
			}

			// Otherwise, if the device is going into low power mode...
			else if([hex isEqual:@"FFD60A"]) {

				// If the custom percentage view is enabled, this gets the label and then sets the text color to the yellow color, signifying that the device is being put into low power mode and not charging.
				if(isPercentageReplaceEnabled) {
					((UILabel *)[self.superview viewWithTag:51603]).textColor = realBodyColor;
				}
			}

			// Otherwise, if it isn't about to start charging or about to enter low power mode...
			else {
				// If the custom percentage view is enabled and if the user hasn't selected a custom color for it, this sets its text color to be white.
				if(isPercentageReplaceEnabled && [percentageReplaceColor isEqual:@"#FFFFFF"]) {
					((UILabel *)[self.superview viewWithTag:51603]).textColor = returnUIColor(percentageReplaceColor);
				}
				// If the battery icon's color is not my default color #878182 (this is a gray color, I use it due to Alderis not supporting alpha), it sets it to the user's choice.
				if(![batteryExteriorColor isEqual:@"#878182"]) {
					realBodyColor = returnUIColor(batteryExteriorColor);
				}
				else {
					//If color is set to #878182 hex code (my hex code equivalent of system default), it defaults to the actual system default with alpha.
					realBodyColor = [UIColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:0.40];
				}
			}
		}
		%orig;
		// Reloads the view so that everything is updated.
		[self setNeedsDisplay];
		[self setNeedsLayout];
	}

	// This is called whenever the battery icon changes its battery. We use this to also update our custom battery percentage view, if the user has it enabled.
	-(void)setChargePercent:(double)arg1 {
		%orig;
		// If the user has the tweak and the custom battery percentage view enabled...
		if(enabled && isPercentageReplaceEnabled) {
			// We get the custom battery percentage view and cast it to a UILabel since we know for sure it's a UILabel and so that we can use its setText method to update the text and use sizeToFit to fix its size so it isn't cut off.
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
				// If the custom battery percentage view is enabled, 
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

			// If the device is starting to charge...
			if(realChargingState == 1) {
				// We get the custom battery percentage view and cast it to a UILabel since we know for sure it's a UILabel and so that we can use its textColor method to update the text color.
				if(isPercentageReplaceEnabled) {
					((UILabel *)[self.superview viewWithTag:51603]).textColor = [UIColor colorWithRed:0.19 green:0.82 blue:0.35 alpha:1.00];
				}

				// Make the battery icon's body color green so the user knows that it's charging.
				[self setBodyColor:[UIColor colorWithRed:0.19 green:0.82 blue:0.35 alpha:1.00]];
			}

			// If the device is not getting charged anymore and low power mode is on...
			else if(self.saverModeActive == 1) {
				if(isPercentageReplaceEnabled) {
				// We get the custom battery percentage view and cast it to a UILabel since we know for sure it's a UILabel and so that we can use its textColor method to update the text color.
					((UILabel *)[self.superview viewWithTag:51603]).textColor = [UIColor colorWithRed:1.00 green:0.84 blue:0.04 alpha:1.00];
				}
				// Make the battery icon's body color yellow so the user knows it's enabled.
				[self setBodyColor:[UIColor colorWithRed:1.00 green:0.84 blue:0.04 alpha:1.00]];
			}

			// If the device is reverting back to normal (stopping charge or low power mode is being turned off)...
			else {
				// If the custom battery percentage view is enabled and isn't set to default, set it to the user's choice. 
				if(isPercentageReplaceEnabled && ![percentageReplaceColor isEqual:@"#FFFFFF"]) {
					((UILabel *)[self.superview viewWithTag:51603]).textColor = returnUIColor(percentageReplaceColor);
				}
				// If the custom battery percentage view is enabled and is set to default, set its text color to be white. 
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

	// Resets preferences to default. This uses NSDistributedNotificationCenter to get notifications from our preferences when someone clicks the 'Reset' button on the popup that occurs after the user clicks the 'Reset Settings' button. You can see the sender in wonderbarprefs/WBPRootListController.m
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