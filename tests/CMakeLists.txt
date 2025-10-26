add_definitions(-DUNIT_TEST=1)
add_definitions(-DSOURCE_DIR="${CMAKE_SOURCE_DIR}")
add_definitions(-DBUILD_DIR="${CMAKE_BINARY_DIR}")

include_directories(${CMAKE_SOURCE_DIR})

add_subdirectory(uitools)
add_subdirectory(ut_keyLayoutsModel)
