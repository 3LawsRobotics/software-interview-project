include(GoogleTest)

find_package(GTest REQUIRED)

add_executable(main_test "${CMAKE_CURRENT_SOURCE_DIR}/test.cpp")
target_link_libraries(main_test PRIVATE GTest::Main 3laws::coding_interview_project)
gtest_add_tests(TARGET main_test)
