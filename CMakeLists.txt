cmake_minimum_required(VERSION 3.6.0)

project(maliit-nemo-keyboard
        VERSION 0.102
        DESCRIPTION "mallit nemomobile keyboard")

include(FeatureSummary)
include(GNUInstallDirs)

set(QT_MIN_VERSION "5.11.0")
find_package(Qt5 ${QT_MIN_VERSION} COMPONENTS Gui Qml Quick REQUIRED)

install(FILES qml/nemo-keyboard.qml
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/maliit/plugins/)

install(DIRECTORY qml/org/nemomobile
    DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/maliit/plugins/org)

add_subdirectory("settings-plugin")
