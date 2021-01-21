ARCHS = arm64 arm64e

TARGET := iphone:clang:13.7:13.0
PREFIX = $(THEOS)/toolchain/Xcode.xctoolchain/usr/bin/

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = InstaSlyPreferences

InstaSlyPreferences_FILES = $(shell find Sources/InstaSlyPreferences -name "*.swift") $(shell find Sources/InstaSlyPreferences -name "*.m")
InstaSlyPreferences_INSTALL_PATH = /Library/PreferenceBundles
InstaSlyPreferences_SWIFTFLAGS = -ISources/InstaSlyPreferencesC/include
InstaSlyPreferences_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
