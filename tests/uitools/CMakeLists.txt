find_package(Glacier 0.8 COMPONENTS App REQUIRED)

set(SRC main.cpp
    maliitquick.h
    fakeinputmethod.cpp
    fakeinputmethod.h)
add_definitions(-DSOURCE_DIR="${CMAKE_SOURCE_DIR}/")
add_definitions(-DBUILD_DIR="${CMAKE_BINARY_DIR}/")

add_executable(glacier-keyboardtest ${SRC} ${RESOURCES}
    fakekeyoverridequick.h fakekeyoverridequick.cpp)

target_link_libraries(glacier-keyboardtest
        Qt6::Gui
        Qt6::Qml
        Qt6::Quick
        PkgConfig::GLACIER
        PkgConfig::MALLIT-FRAMEWORK
)
