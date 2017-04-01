QT += qml quick

CONFIG += c++11

SOURCES += main.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

DISTFILES += \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat \
    android/src/org/freedesktop/gstreamer/GStreamer.java \
    android/src/net/armsofsorrow/gstreamerandroidqtapp/MainActivity.java

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

android {

    # GStreamer binaries use differenct ABI naming than android SDK, so we need to
    # create intermediate variables instead of using ANDROID_TARGET_ARCH directly.
    equals(ANDROID_TARGET_ARCH, armeabi-v7a) {
        GSTREAMER_ARCH_FOLDER = armv7
    }
    equals(ANDROID_TARGET_ARCH, x86)  {
        GSTREAMER_ARCH_FOLDER = x86
    }

    # GStreamer ndk-build scripts need this variable to do anything at all.
    # Since version 1.10 (I think) they've switched to a single package instead of multiple ABI-specific ones.
    # We combine the root (which is inside our project directory) with the variable defined before so we build for the right ABI.
    GSTREAMER_ROOT_ANDROID = $$_PRO_FILE_PWD_/gstreamer-1.0/$$GSTREAMER_ARCH_FOLDER

    # http://stackoverflow.com/questions/15864689/qmake-pre-build-step-before-any-compilation
    # To avoid regenerating libgstreamer_android.so on each build, we specify this target.
    # NOTE: if you change the plugins included in libgstreamer_android.so, you need to rebuild. Otherwise the changes won't be picked up.
    gst.target = $$ANDROID_PACKAGE_SOURCE_DIR/libs/$$ANDROID_TARGET_ARCH/libgstreamer_android.so
    gst.commands = cd $$ANDROID_PACKAGE_SOURCE_DIR; ./build_gstreamer.sh TARGET_ARCH_ABI=$$ANDROID_TARGET_ARCH \
                   GSTREAMER_ROOT_ANDROID=$$GSTREAMER_ROOT_ANDROID NDK_PROJECT_PATH=$$ANDROID_PACKAGE_SOURCE_DIR

    # Delete gstreamer_android compile output. The proper way would be with ndk-build, but it works and I've had enough of this shit.
    extraclean.commands = rm -rv $$ANDROID_PACKAGE_SOURCE_DIR/libs $$ANDROID_PACKAGE_SOURCE_DIR/obj
    clean.depends += extraclean

    QMAKE_EXTRA_TARGETS += gst clean extraclean
    PRE_TARGETDEPS += $$ANDROID_PACKAGE_SOURCE_DIR/libs/$$ANDROID_TARGET_ARCH/libgstreamer_android.so

    # Includes and libs for c++. You might need to add more libs as you use more gstreamer features.
    INCLUDEPATH += $$GSTREAMER_ROOT_ANDROID/include/gstreamer-1.0 $$GSTREAMER_ROOT_ANDROID/include/glib-2.0 $$GSTREAMER_ROOT_ANDROID/lib/glib-2.0/include
    LIBS += -L$$ANDROID_PACKAGE_SOURCE_DIR/libs/$$ANDROID_TARGET_ARCH -lgstreamer_android

    # Don't forget to package the generated lib into the final apk
    ANDROID_EXTRA_LIBS = $$ANDROID_PACKAGE_SOURCE_DIR/libs/$$ANDROID_TARGET_ARCH/libgstreamer_android.so
}
