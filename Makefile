ARCHS = arm64 arm64e

TARGET := iphone:clang:13.7:13.0
PREFIX = $(THEOS)/toolchain/Xcode.xctoolchain/usr/bin/

INSTALL_TARGET_PROCESSES = Instagram

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = InstaSly

InstaSly_FILES = $(shell find Sources/InstaSly -name "*.swift") $(shell find Sources/InstaSlyC -name "*.m")
InstaSly_SWIFTFLAGS = -ISources/InstaSlyC/include
InstaSly_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += InstaSlyPreferences
include $(THEOS_MAKE_PATH)/aggregate.mk
