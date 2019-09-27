cmake_minimum_required(VERSION 2.8)

set(PROJECT_NAME "Game_Engine")

project(${PROJECT_NAME})

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} --std=c++11 -O3 -pthread -g")

find_package(SDL2 REQUIRED component main)
if (UNIX AND NOT APPLE)
 set(SDL2_LIBRARIES "SDL2")
endif()
if(NOT WIN32)
    find_package(OpenGL REQUIRED)
endif()
include_directories(${SDL2_INCLUDE_DIRS} ${OPENGL_INCLUDE_DIRS} ${CMAKE_SOURCE_DIR})


file(GLOB srcFiles engineCode/*.cpp external/*.cpp)
#message(STATUS ${srcFiles} )

file(GLOB glad_src glad/*.c)
file(GLOB imgui_src imgui/*.cpp)
file(GLOB_RECURSE lua_src Lua/*.c)

add_library(glad ${glad_src})
add_library(imgui ${imgui_src})
add_library(Lua ${lua_src})

message( "" )
message( "Graphics Library Locations:" )
message( "  SDL2 Library: " ${SDL2_LIBRARIES} )
message( "  OpenGL Library: " ${OPENGL_LIBRARIES} )

#message( "DL-libs: " ${CMAKE_DL_LIBS} )

#get_cmake_property(_variableNames VARIABLES)
#list (SORT _variableNames)
#foreach (_variableName ${_variableNames})
#    message(STATUS "${_variableName}=${${_variableName}}")
#endforeach()


add_executable(engine ${srcFiles})
target_link_libraries(engine ${OPENGL_LIBRARIES} ${SDL2_LIBRARIES} glad imgui Lua ${CMAKE_DL_LIBS})

set_target_properties( engine
    PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/../GEFS"
)

set_property(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY VS_STARTUP_PROJECT engine)

#cmake -G "Visual Studio 15 2017 Win64" ..   //To ensure a particular build e.g., Win64
#cmake -G "Xcode" ..  //to ensure an Xcode build
