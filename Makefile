INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = wonderbar

wonderbar_FILES = Tweak.x
wonderbar_FRAMEWORKS = UIKit
wonderbar_PRIVATE_FRAMEWORKS = Preferences
wonderbar_EXTRA_FRAMEWORKS += Cephei
wonderbar_LIBRARIES = colorpicker
wonderbar_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += wonderbarprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
