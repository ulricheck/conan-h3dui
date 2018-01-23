#=============================================================================
# Copyright 2001-2011 Kitware, Inc.
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file Copyright.txt for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================
# (To distribute this file outside of CMake, substitute the full
#  License text for the above reference.)
include( H3DUtilityFunctions )
if( MSVC )
  getMSVCPostFix( msvc_postfix )
  set( ui_name "UI${msvc_postfix}" )
elseif( UNIX )
  set( ui_name h3dui )
else()
  set( ui_name UI )
endif()

handleRenamingVariablesBackwardCompatibility( NEW_VARIABLE_NAMES UI_LIBRARY_DEBUG
                                              OLD_VARIABLE_NAMES UI_DEBUG_LIBRARY
                                              DOC_STRINGS "Path to ${ui_name}_d library." )

include( H3DCommonFindModuleFunctions )

# Look for the header file.
find_path( UI_INCLUDE_DIR NAMES H3D/UI/UI.h
                          PATHS ${CONAN_INCLUDE_DIRS_UI}
                          DOC "Path in which the file UI/UI.h is located." )
mark_as_advanced( UI_INCLUDE_DIR )

find_library( UI_LIBRARY_RELEASE NAMES ${ui_name}
                                 PATHS ${CONAN_LIB_DIRS_H3DUI}
                                 DOC "Path to ${ui_name} library." )

find_library( UI_LIBRARY_DEBUG NAMES ${ui_name}_d
                               PATHS ${CONAN_LIB_DIRS_H3DUI}
                               DOC "Path to ${ui_name}_d library." )

mark_as_advanced( UI_LIBRARY_RELEASE UI_LIBRARY_DEBUG )

if( UI_INCLUDE_DIR )
  handleComponentsForLib( UI
                          MODULE_HEADER_DIRS ${UI_INCLUDE_DIR}
                          MODULE_HEADER_SUFFIX /H3D/UI/UI.h
                          DESIRED ${UI_FIND_COMPONENTS}
                          REQUIRED H3DAPI
                          OUTPUT found_vars component_libraries component_include_dirs
                          H3D_MODULES H3DAPI )
endif()

include( SelectLibraryConfigurations )
select_library_configurations( UI )

include( FindPackageHandleStandardArgs )
# handle the QUIETLY and REQUIRED arguments and set UI_FOUND to TRUE
# if all listed variables are TRUE
find_package_handle_standard_args( UI DEFAULT_MSG
                                   UI_INCLUDE_DIR UI_LIBRARY ${found_vars} )

set( UI_LIBRARIES ${UI_LIBRARY} ${component_libraries} )
set( UI_INCLUDE_DIRS ${UI_INCLUDE_DIR} ${component_include_dirs} )
list( REMOVE_DUPLICATES UI_INCLUDE_DIRS )

# Backwards compatibility values set here.
set( UI_INCLUDE_DIR ${UI_INCLUDE_DIRS} )

MESSAGE("** CONAN FOUND UI:  ${UI_LIBRARIES}")
MESSAGE("** CONAN FOUND UI INCLUDE:  ${UI_INCLUDE_DIRS}")

# Additional message on MSVC
if( UI_FOUND AND MSVC )
  if( NOT UI_LIBRARY_RELEASE )
    message( WARNING "UI release library not found. Release build might not work properly. To get rid of this warning set UI_LIBRARY_RELEASE." )
  endif()
  if( NOT UI_LIBRARY_DEBUG )
    message( WARNING "UI debug library not found. Debug build might not work properly. To get rid of this warning set UI_LIBRARY_DEBUG." )
  endif()
endif()
