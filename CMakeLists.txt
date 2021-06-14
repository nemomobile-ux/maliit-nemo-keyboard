cmake_minimum_required(VERSION 3.6.0)

project(maliit-nemo-keyboard
        VERSION 0.1
        DESCRIPTION "mallit nemomobile keyboard")

include(FeatureSummary)
include(GNUInstallDirs)

install(FILES qml/nemo-keyboard.qml
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/maliit/plugins/)

install(DIRECTORY qml/org/nemomobile
    DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/maliit/plugins/org)
