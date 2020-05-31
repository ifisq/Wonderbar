#include "WBPRootListController.h"

#define wonderbarPrefsPath @"/User/Library/Preferences/dev.aryanjnambiar.wonderbar.plist"

@implementation WBPRootListController

// Initialize Preferences with Cephei
- (void)viewDidLoad {
	[super viewDidLoad];

	HBAppearanceSettings *appearance = [[HBAppearanceSettings alloc] init];
	appearance.tintColor = [UIColor colorWithRed:.678 green:.847 blue:.902 alpha:1];
	self.hb_appearanceSettings = appearance;
	self.title = @"Wonderbar";
}

// Loads specifiers from the plist and then returns them so that they can be used.
- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

// This function is called when the 'Reset' button is clicked in the popup from clicking the 'Reset Settings' button. This method uses NSDistributedNotificationCenter to send a notification to the Tweak.x file to reset preferences.
- (void)resetPrefsToDefault {
	[[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"dev.aryanjnambiar.wonderbarprefs/ReloadPrefs" object:nil userInfo:nil deliverImmediately:TRUE];
	[self reloadSpecifiers];
}

// This is used to reset to the default preferences when the user clicks 'Reset to Default Settings'.
- (void)resetSettings {
	//This initializes a UIAlertController, which will be presented to the user to reset settings.
	UIAlertController *alertController = [UIAlertController  alertControllerWithTitle:@"Are you sure you want to reset to default settings?"  message:nil  preferredStyle:UIAlertControllerStyleAlert];
	
	// This adds a button/action to the alert controller/view that, when clicked, signifies that the user wants to reset their settings.
	[alertController addAction:[UIAlertAction actionWithTitle:@"Reset" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
		// This calls the resetPrefsToDefault function, which sends a notification to reset the preferences to the tweak.
		[self resetPrefsToDefault];
		// This then closes the alert view.
		[self dismissViewControllerAnimated:YES completion:nil];
	}]];

	// This adds a button/action to the alert controller/view that, when clicked, closes the alert view without doing any actions.
	[alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
		[self dismissViewControllerAnimated:YES completion:nil];
	}]];

	// This presents the alert view to the user.
 	[self presentViewController:alertController animated:YES completion:nil];
}

// This is used to remove the keyboard when the user clicks on 'Save Changes' in preferences.
- (void)applySettings {
	[self.view endEditing:YES];
}

// When the user selects the respring option, this method is called to respring the device & return to the tweak preferences screen.
- (void)respring {
	[HBRespringController respringAndReturnTo:[NSURL URLWithString:@"prefs:root=Wonderbar"]];
}

@end
