cmake_minimum_required(VERSION 3.6.0)

project(maliit-nemo-keyboard
        VERSION 0.2
        DESCRIPTION "mallit nemomobile keyboard")

set(CMAKE_AUTOMOC ON)

include(FeatureSummary)
include(GNUInstallDirs)

set(QT_MIN_VERSION "5.6.0")
find_package(Qt5 COMPONENTS Gui Qml Quick LinguistTools REQUIRED)

add_subdirectory(predictor)

install(FILES qml/nemo-keyboard.qml
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/maliit/plugins/)

install(DIRECTORY qml/org/nemomobile
    DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/maliit/plugins/org)
