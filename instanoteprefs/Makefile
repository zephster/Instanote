ARCHS = armv7 arm64

include theos/makefiles/common.mk

BUNDLE_NAME = InstanotePrefs
InstanotePrefs_FILES = InstanotePrefs.mm
InstanotePrefs_INSTALL_PATH = /Library/PreferenceBundles
InstanotePrefs_FRAMEWORKS = UIKit Social
InstanotePrefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/InstanotePrefs.plist$(ECHO_END)
