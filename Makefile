ARCHS = armv7 arm64
THEOS_PACKAGE_DIR_NAME = debs

include theos/makefiles/common.mk

TWEAK_NAME = Instanote
Instanote_FILES = Tweak.xm
Instanote_FRAMEWORKS = UIKit

include theos/makefiles/tweak.mk

after-install::
	install.exec "killall -9 Instagram"