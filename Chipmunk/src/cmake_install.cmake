# Install script for directory: /Users/thoughtstem/Dev/Physics/racket-chipmunk/Chipmunk/src

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/usr/local")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Release")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE SHARED_LIBRARY FILES
    "/Users/thoughtstem/Dev/Physics/racket-chipmunk/Chipmunk/src/libchipmunk.7.0.2.dylib"
    "/Users/thoughtstem/Dev/Physics/racket-chipmunk/Chipmunk/src/libchipmunk.7.dylib"
    "/Users/thoughtstem/Dev/Physics/racket-chipmunk/Chipmunk/src/libchipmunk.dylib"
    )
  foreach(file
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libchipmunk.7.0.2.dylib"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libchipmunk.7.dylib"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libchipmunk.dylib"
      )
    if(EXISTS "${file}" AND
       NOT IS_SYMLINK "${file}")
      if(CMAKE_INSTALL_DO_STRIP)
        execute_process(COMMAND "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/strip" "${file}")
      endif()
    endif()
  endforeach()
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "/Users/thoughtstem/Dev/Physics/racket-chipmunk/Chipmunk/src/libchipmunk.a")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libchipmunk.a" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libchipmunk.a")
    execute_process(COMMAND "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ranlib" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libchipmunk.a")
  endif()
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/chipmunk" TYPE FILE FILES
    "/Users/thoughtstem/Dev/Physics/racket-chipmunk/Chipmunk/include/chipmunk/chipmunk.h"
    "/Users/thoughtstem/Dev/Physics/racket-chipmunk/Chipmunk/include/chipmunk/chipmunk_ffi.h"
    "/Users/thoughtstem/Dev/Physics/racket-chipmunk/Chipmunk/include/chipmunk/chipmunk_private.h"
    "/Users/thoughtstem/Dev/Physics/racket-chipmunk/Chipmunk/include/chipmunk/chipmunk_structs.h"
    "/Users/thoughtstem/Dev/Physics/racket-chipmunk/Chipmunk/include/chipmunk/chipmunk_types.h"
    "/Users/thoughtstem/Dev/Physics/racket-chipmunk/Chipmunk/include/chipmunk/chipmunk_unsafe.h"
    "/Users/thoughtstem/Dev/Physics/racket-chipmunk/Chipmunk/include/chipmunk/cpArbiter.h"
    "/Users/thoughtstem/Dev/Physics/racket-chipmunk/Chipmunk/include/chipmunk/cpBB.h"
    "/Users/thoughtstem/Dev/Physics/racket-chipmunk/Chipmunk/include/chipmunk/cpBody.h"
    "/Users/thoughtstem/Dev/Physics/racket-chipmunk/Chipmunk/include/chipmunk/cpConstraint.h"
    "/Users/thoughtstem/Dev/Physics/racket-chipmunk/Chipmunk/include/chipmunk/cpDampedRotarySpring.h"
    "/Users/thoughtstem/Dev/Physics/racket-chipmunk/Chipmunk/include/chipmunk/cpDampedSpring.h"
    "/Users/thoughtstem/Dev/Physics/racket-chipmunk/Chipmunk/include/chipmunk/cpGearJoint.h"
    "/Users/thoughtstem/Dev/Physics/racket-chipmunk/Chipmunk/include/chipmunk/cpGrooveJoint.h"
    "/Users/thoughtstem/Dev/Physics/racket-chipmunk/Chipmunk/include/chipmunk/cpHastySpace.h"
    "/Users/thoughtstem/Dev/Physics/racket-chipmunk/Chipmunk/include/chipmunk/cpMarch.h"
    "/Users/thoughtstem/Dev/Physics/racket-chipmunk/Chipmunk/include/chipmunk/cpPinJoint.h"
    "/Users/thoughtstem/Dev/Physics/racket-chipmunk/Chipmunk/include/chipmunk/cpPivotJoint.h"
    "/Users/thoughtstem/Dev/Physics/racket-chipmunk/Chipmunk/include/chipmunk/cpPolyShape.h"
    "/Users/thoughtstem/Dev/Physics/racket-chipmunk/Chipmunk/include/chipmunk/cpPolyline.h"
    "/Users/thoughtstem/Dev/Physics/racket-chipmunk/Chipmunk/include/chipmunk/cpRatchetJoint.h"
    "/Users/thoughtstem/Dev/Physics/racket-chipmunk/Chipmunk/include/chipmunk/cpRobust.h"
    "/Users/thoughtstem/Dev/Physics/racket-chipmunk/Chipmunk/include/chipmunk/cpRotaryLimitJoint.h"
    "/Users/thoughtstem/Dev/Physics/racket-chipmunk/Chipmunk/include/chipmunk/cpShape.h"
    "/Users/thoughtstem/Dev/Physics/racket-chipmunk/Chipmunk/include/chipmunk/cpSimpleMotor.h"
    "/Users/thoughtstem/Dev/Physics/racket-chipmunk/Chipmunk/include/chipmunk/cpSlideJoint.h"
    "/Users/thoughtstem/Dev/Physics/racket-chipmunk/Chipmunk/include/chipmunk/cpSpace.h"
    "/Users/thoughtstem/Dev/Physics/racket-chipmunk/Chipmunk/include/chipmunk/cpSpatialIndex.h"
    "/Users/thoughtstem/Dev/Physics/racket-chipmunk/Chipmunk/include/chipmunk/cpTransform.h"
    "/Users/thoughtstem/Dev/Physics/racket-chipmunk/Chipmunk/include/chipmunk/cpVect.h"
    )
endif()

