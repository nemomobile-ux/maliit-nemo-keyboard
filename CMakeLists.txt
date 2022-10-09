cmake_minimum_required(VERSION 3.6.0)

project(maliit-nemo-keyboard
        VERSION 0.102
        DESCRIPTION "mallit nemomobile keyboard")

include(FeatureSummary)
include(GNUInstallDirs)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD 11)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_INSTALL_PREFIX "/usr" CACHE PATH "..." FORCE)

set(QT_MIN_VERSION "5.11.0")
find_package(Qt5 ${QT_MIN_VERSION} COMPONENTS Gui Qml Quick LinguistTools REQUIRED)
find_package(PkgConfig)
pkg_check_modules(MLITE5 mlite5 REQUIRED IMPORTED_TARGET)
pkg_check_modules(HUNSPELL hunspell REQUIRED IMPORTED_TARGET)

install(FILES qml/nemo-keyboard.qml
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/maliit/plugins/)

install(DIRECTORY qml/org/nemomobile
    DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/maliit/plugins/org)

install(DIRECTORY layouts/
    DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/glacier-keyboard/layouts)

add_subdirectory("src")
add_subdirectory("settings-plugin")
