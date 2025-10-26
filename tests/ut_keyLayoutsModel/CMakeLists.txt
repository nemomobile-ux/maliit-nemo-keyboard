set(TESTNAME layoutsModel)

set(SRC
    ut_${TESTNAME}.cpp
    ut_${TESTNAME}.h
    ${CMAKE_SOURCE_DIR}/src/keyboardslayoutmodel.cpp)

add_executable(ut_${TESTNAME} ${SRC})

target_link_libraries(ut_${TESTNAME}
    Qt6::Core
    Qt6::Test
    Qt6::Qml
    Qt6::Gui
    PkgConfig::MLITE6)

add_test(ut_${TESTNAME} ut_${TESTNAME})
