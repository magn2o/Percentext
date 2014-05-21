TARGET := iphone:7.0:2.0
ARCHS := armv6 arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Percentext
Percentext_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

BUNDLE_NAME = PercentextSettings
PercentextSettings_FILES = Preferences.m
PercentextSettings_INSTALL_PATH = /Library/PreferenceBundles
PercentextSettings_FRAMEWORKS = UIKit
PercentextSettings_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/Percentext.plist$(ECHO_END)

after-install::
	install.exec "killall -9 SpringBoard"
