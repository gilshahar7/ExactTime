ARCHS = armv7 arm64 arm64e
export TARGET = iphone:clang:11.2:7.0
include $(THEOS)/makefiles/common.mk

FINALPACKAGE=1

BUNDLE_NAME = ExactTimeprefs
ExactTimeprefs_FILES = ExactTimeprefs.mm
ExactTimeprefs_INSTALL_PATH = /Library/PreferenceBundles
ExactTimeprefs_FRAMEWORKS = UIKit
ExactTimeprefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/ExactTimeprefs.plist$(ECHO_END)
