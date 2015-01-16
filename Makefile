ARCHS = armv7 arm64
include theos/makefiles/common.mk

TWEAK_NAME = SpotlightGoogle
SpotlightGoogle_FILES = Tweak.xm
SpotlightGoogle_FRAMEWORKS = UIKit
SpotlightGoogle_CFLAGS = -Wno-error

include $(THEOS_MAKE_PATH)/tweak.mk

include $(THEOS_MAKE_PATH)/aggregate.mk

after-install::
	install.exec "killall -9 SpringBoard"
