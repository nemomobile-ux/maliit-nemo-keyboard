find_package(Glacier 0.8 COMPONENTS App REQUIRED)

set(SRC main.cpp)

add_executable(glacier-keyboardtest ${SRC} ${RESOURCES})

target_link_libraries(glacier-keyboardtest
        Qt6::Gui
        Qt6::Qml
        Qt6::Quick
        PkgConfig::GLACIER
)
