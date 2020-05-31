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

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

- (void)resetPrefsToDefault {
	[[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"dev.aryanjnambiar.wonderbarprefs/ReloadPrefs" object:nil userInfo:nil deliverImmediately:TRUE];
	[self reloadSpecifiers];
}

// This is used to reset to the default preferences when the user clicks 'Reset to Default Settings'.
- (void)resetSettings {
	UIAlertController *alertController = [UIAlertController  alertControllerWithTitle:@"Are you sure you want to reset to default settings?"  message:nil  preferredStyle:UIAlertControllerStyleAlert];
	[alertController addAction:[UIAlertAction actionWithTitle:@"Reset" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
		//This is where you would make the settings reset to defaults, maybe by calling another function?
		[self resetPrefsToDefault];
		[self dismissViewControllerAnimated:YES completion:nil];
	}]];

	[alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
	[self dismissViewControllerAnimated:YES completion:nil];
	}]];

 	[self presentViewController:alertController animated:YES completion:nil];
}

// This is used to remove the keyboard when the user clicks on 'Save' in preferences.
- (void)applySettings {
	[self.view endEditing:YES];
}

// When the user selects the respring option, this method is called to respring the device & return to the tweak preferences screen.
- (void)respring {
	[HBRespringController respringAndReturnTo:[NSURL URLWithString:@"prefs:root=Wonderbar"]];
}

@end
