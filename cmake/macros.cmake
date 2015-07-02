include(CMakeParseArguments)

#-------------------------------------------------------------------------------
# macros
#-------------------------------------------------------------------------------

if (NOT WIN32)
	string(ASCII 27 Esc)
	set(ColorReset  "${Esc}[m")
	set(ColorRed    "${Esc}[31m")
	set(ColorGreen  "${Esc}[32m")
	set(ColorYellow "${Esc}[33m")
	set(ColorBlue   "${Esc}[34m")
endif()

#function(message)
#	list(GET ARGV 0 TYPE)
#	if (TYPE STREQUAL FATAL_ERROR)
#		list(REMOVE_AT ARGV 0)
#		_message(${TYPE} "${ColorRed}${ARGV}${ColorReset}")
#	elseif(TYPE STREQUAL WARNING)
#		list(REMOVE_AT ARGV 0)
#		_message(${TYPE} "${ColorYellow}${ARGV}${ColorReset}")
#	elseif(TYPE STREQUAL STATUS)
#		list(REMOVE_AT ARGV 0)
#		_message(${TYPE} "${ColorGreen}${ARGV}${ColorReset}")
#	elseif (ARGV)
#		_message("${ARGV}")
#	endif()
#endfunction()

macro(cp_message MSG)
	if (VERBOSE)
		message("${ColorBlue}${MSG}${ColorReset}")
	endif()
endmacro()

macro(texture_file_write TARGET_FILE FILEENTRY)
	file(READ ${FILEENTRY} CONTENTS)
	string(REGEX REPLACE ";" "\\\\;" CONTENTS "${CONTENTS}")
	string(REGEX REPLACE "\n" ";" CONTENTS "${CONTENTS}")
	list(REMOVE_AT CONTENTS 0 -2)
	foreach(LINE ${CONTENTS})
		file(APPEND ${TARGET_FILE} "${LINE}\n")
	endforeach()
endmacro()

macro(get_subdirs RESULT DIR)
	file(GLOB SUBDIRS RELATIVE ${DIR} ${DIR}/*)
	set(DIRLIST "")
	foreach(CHILD ${SUBDIRS})
		if (IS_DIRECTORY ${DIR}/${CHILD})
			list(APPEND DIRLIST ${CHILD})
		endif()
	endforeach()
	set(${RESULT} ${DIRLIST})
	list(SORT ${RESULT})
endmacro()

macro(create_dir_header PROJECTNAME)
	set(TARGET_FILE ${ROOT_DIR}/src/${PROJECTNAME}/dir.h)
	set(BASEDIR ${ROOT_DIR}/base/${PROJECTNAME})

	set(SUBDIRS)
	get_subdirs(SUBDIRS ${BASEDIR})
	foreach(SUBDIR ${SUBDIRS})
		file(GLOB FILESINDIR RELATIVE ${BASEDIR}/${SUBDIR} ${BASEDIR}/${SUBDIR}/*)
		list(LENGTH FILESINDIR LISTENTRIES)
		file(APPEND ${TARGET_FILE} "if (basedir == \"${i}/\") {\n")
		file(APPEND ${TARGET_FILE} "entriesAll.reserve(${LISTENTRIES});\n")
		foreach(FILEINDIR ${FILESINDIR})
			file(APPEND ${TARGET_FILE} "entriesAll.push_back(\"${FILEINDIR}\");\n")
		endforeach()
	endforeach()
	file(APPEND ${TARGET_FILE} "return entriesAll;\n}\n")
	message("wrote ${TARGET_FILE}")
endmacro()

macro(texture_merge TARGET_FILE FILELIST_BIG FILELIST_SMALL)
	file(WRITE ${TARGET_FILE} "")

	file(APPEND ${TARGET_FILE} "texturesbig = {\n")
	foreach(FILEENTRY ${FILELIST_BIG})
		texture_file_write(${TARGET_FILE} ${FILEENTRY})
	endforeach()
	file(APPEND ${TARGET_FILE} "}\n")

	file(APPEND ${TARGET_FILE} "texturessmall = {\n")
	foreach(FILEENTRY ${FILELIST_SMALL})
		texture_file_write(${TARGET_FILE} ${FILEENTRY})
	endforeach()
	file(APPEND ${TARGET_FILE} "}\n")
endmacro()

macro(textures PROJECTNAME)
	file(GLOB FILELIST_BIG ${ROOT_DIR}/contrib/assets/png-packed/${PROJECTNAME}-*big.lua)
	file(GLOB FILELIST_SMALL ${ROOT_DIR}/contrib/assets/png-packed/${PROJECTNAME}-*small.lua)
	message("build complete.lua: ${ROOT_DIR}/contrib/assets/png-packed/${PROJECTNAME}")
	texture_merge(${PROJECT_BINARY_DIR}/complete.lua.in "${FILELIST_BIG}" "${FILELIST_SMALL}")
	configure_file(${PROJECT_BINARY_DIR}/complete.lua.in ${ROOT_DIR}/base/${PROJECTNAME}/textures/complete.lua COPYONLY)
endmacro()

macro(texturepacker PROJECTNAME FILELIST)
	if (TEXTUREPACKER_BIN)
		set(DEPENDENCIES)
		foreach(FILEENTRY ${FILELIST})
			set(PNGBIG ${ROOT_DIR}/base/${PROJECTNAME}/pics/${FILEENTRY}-big.png)
			set(PNGSMALL ${ROOT_DIR}/base/${PROJECTNAME}/pics/${FILEENTRY}-small.png)
			set(TPS ${ROOT_DIR}/contrib/assets/png-packed/${FILEENTRY}.tps)
			add_custom_command(OUTPUT ${PNGBIG} ${PNGSMALL} COMMAND ${TEXTUREPACKER_BIN} ARGS ${TPS} DEPENDS ${TPS} VERBATIM)
			list(APPEND DEPENDENCIES ${PNGBIG} ${PNGSMALL})
		endforeach()
		if (DEPENDENCIES)
			add_custom_target(${PROJECTNAME}_texturepacker DEPENDS ${DEPENDENCIES})
			add_dependencies(${PROJECTNAME} ${PROJECTNAME}_texturepacker)
		endif()
		set(DEPENDENCIES)
	endif()
endmacro()

macro(check_lua_files TARGET FILES)
	find_program(LUAC_EXECUTABLE NAMES ${DEFAULT_LUAC_EXECUTABLE})
	if (LUAC_EXECUTABLE)
		message("${LUAC_EXECUTABLE} found")
		foreach(_FILE ${FILES})
			string(REPLACE "/" "-" TARGETNAME ${_FILE})
			add_custom_target(
				${TARGETNAME}
				COMMENT "checking lua file ${_FILE}"
				COMMAND ${DEFAULT_LUAC_EXECUTABLE} -p ${_FILE}
				WORKING_DIRECTORY ${ROOT_DIR}/base/${TARGET}
			)
			add_dependencies(${TARGET} ${TARGETNAME})
		endforeach()
	else()
		message(WARNING "No lua compiler (${DEFAULT_LUAC_EXECUTABLE}) found")
	endif()
endmacro()

macro(prepare_android PROJECTNAME APPNAME VERSION VERSION_CODE)
	if (ANDROID)
		message("prepare java code for ${PROJECTNAME}")
		file(COPY ${ANDROID_ROOT} DESTINATION ${CMAKE_BINARY_DIR}/android-${PROJECTNAME})
		set(WHITELIST base libsdl ${PROJECTNAME})
		set(JAVA_PACKAGE org.${PROJECTNAME})
		set(APPNAME ${APPNAME})
		set(VERSION ${VERSION})
		set(VERSION_CODE ${VERSION_CODE})
		set(ANDROID_BIN_ROOT ${CMAKE_BINARY_DIR}/android-${PROJECTNAME})
		get_subdirs(SUBDIRS ${ANDROID_BIN_ROOT}/src/org)
		list(REMOVE_ITEM SUBDIRS ${WHITELIST})
		foreach(DIR ${SUBDIRS})
			file(REMOVE_RECURSE ${ANDROID_BIN_ROOT}/src/org/${DIR})
		endforeach()
		configure_file(${ANDROID_BIN_ROOT}/AndroidManifest.xml.in ${ANDROID_BIN_ROOT}/AndroidManifest.xml @ONLY)
		configure_file(${ANDROID_BIN_ROOT}/strings.xml.in ${ANDROID_BIN_ROOT}/res/values/strings.xml @ONLY)
		configure_file(${ANDROID_BIN_ROOT}/default.properties.in ${ANDROID_BIN_ROOT}/default.properties @ONLY)
		configure_file(${ANDROID_BIN_ROOT}/build.xml.in ${ANDROID_BIN_ROOT}/build.xml @ONLY)
		configure_file(${ANDROID_BIN_ROOT}/project.properties.in ${ANDROID_BIN_ROOT}/project.properties @ONLY)
		add_custom_command(TARGET ${PROJECTNAME} POST_BUILD COMMAND ${ANDROID_ANT} ${ANT_TARGET} WORKING_DIRECTORY ${ANDROID_BIN_ROOT})
		add_custom_target(${PROJECTNAME}-backtrace adb logcat | ndk-stack -sym ${ANDROID_BIN_ROOT}/obj/local/${ANDROID_NDK_SYMDIR} WORKING_DIRECTORY ${ANDROID_BIN_ROOT})
		add_custom_target(${PROJECTNAME}-install ant ${ANT_INSTALL_TARGET} WORKING_DIRECTORY ${ANDROID_BIN_ROOT})
		add_custom_target(${PROJECTNAME}-uninstall ant uninstall WORKING_DIRECTORY ${ANDROID_BIN_ROOT})
		add_custom_target(${PROJECTNAME}-start adb shell am start -n org.${PROJECTNAME}/org.${PROJECTNAME}.${APPNAME} WORKING_DIRECTORY ${ANDROID_BIN_ROOT})
		file(COPY ${ROOT_DIR}/contrib/installer/android/${PROJECTNAME}/ DESTINATION ${ANDROID_BIN_ROOT})
		file(COPY ${ROOT_DIR}/contrib/installer/android/ DESTINATION ${ANDROID_BIN_ROOT}/libs PATTERN *.jar)
		file(COPY ${ROOT_DIR}/base/${PROJECTNAME} DESTINATION ${ANDROID_BIN_ROOT}/assets/base)
		file(REMOVE ${ANDROID_BIN_ROOT}/assets/base/${PROJECTNAME}/maps PATTERN test*)
		file(REMOVE ${ANDROID_BIN_ROOT}/assets/base/${PROJECTNAME}/maps PATTERN empty*)
		set(RESOLUTIONS hdpi ldpi mdpi xhdpi)
		if (HD_VERSION)
			set(ICON "hd${PROJECTNAME}-icon.png")
		endif()
		if (NOT EXISTS ${ROOT_DIR}/contrib/${ICON} OR NOT HD_VERSION)
			set(ICON "${PROJECTNAME}-icon.png")
		endif()
		foreach(RES ${RESOLUTIONS})
			file(MAKE_DIRECTORY ${ANDROID_BIN_ROOT}/res/drawable-${RES})
			configure_file(${ROOT_DIR}/contrib/${ICON} ${ANDROID_BIN_ROOT}/res/drawable-${RES}/icon.png COPYONLY)
		endforeach()
		set(ANDROID_SO_OUTDIR ${ANDROID_BIN_ROOT}/libs/${ANDROID_NDK_ARCH})
		set_target_properties(${PROJECTNAME} PROPERTIES LIBRARY_OUTPUT_DIRECTORY ${ANDROID_SO_OUTDIR})
		set_target_properties(${PROJECTNAME} PROPERTIES LIBRARY_OUTPUT_DIRECTORY_RELEASE ${ANDROID_SO_OUTDIR})
		set_target_properties(${PROJECTNAME} PROPERTIES LIBRARY_OUTPUT_DIRECTORY_DEBUG ${ANDROID_SO_OUTDIR})
		if (NOT EXISTS ${ANDROID_BIN_ROOT}/local.properties)
			message("=> create Android SDK project: ${PROJECTNAME}")
			execute_process(COMMAND ${ANDROID_SDK_TOOL} --silent update project
					--path .
					--target ${ANDROID_API}
					WORKING_DIRECTORY ${ANDROID_BIN_ROOT})
			execute_process(COMMAND ${ANDROID_SDK_TOOL} --silent update lib-project
					--path google-play-services_lib
					--target ${ANDROID_API}
					WORKING_DIRECTORY ${ANDROID_BIN_ROOT})
		endif()
	endif()
endmacro()

macro(var_global VARIABLES)
	foreach(VAR ${VARIABLES})
		cp_message("${VAR} => ${${VAR}}")
		set(${VAR} ${${VAR}} CACHE STRING "" FORCE)
	endforeach()
endmacro()

macro(package_global LIB)
	find_package(${LIB})
endmacro()

macro(cp_add_library LIB SRCS COMPILER_FLAGS DEFINES)
	find_package(${LIB})
	string(TOUPPER ${LIB} PREFIX)
	if (${PREFIX}_FOUND)
		message(STATUS "System wide installation found for ${LIB}")
		var_global(${PREFIX}_FOUND)
	else()
		message(STATUS "No system wide installation found, use built-in version of ${LIB}")
		add_library(${LIB} "${SRCS}")
		set_target_properties(${LIB} PROPERTIES FOLDER ${LIB})
		if (COMPILER_FLAGS)
			set_target_properties(${LIB} PROPERTIES COMPILE_FLAGS ${COMPILER_FLAGS})
		endif()
		set(${PREFIX}_LIBRARIES)
		set(${PREFIX}_INCLUDE_DIRS "${ROOT_DIR}/src/libs;${ROOT_DIR}/src/libs/${LIB}")
		set(${PREFIX}_LIBRARY ${${PREFIX}_LIBRARIES})
		set(${PREFIX}_INCLUDE_DIR ${${PREFIX}_INCLUDE_DIRS})
		add_definitions(${${PREFIX}_DEFINITIONS} ${DEFINES})
		include_directories(${${PREFIX}_INCLUDE_DIRS})
	endif()
	var_global(${PREFIX}_LIBRARY)
	var_global(${PREFIX}_LIBRARIES)
	var_global(${PREFIX}_INCLUDE_DIRS)
	var_global(${PREFIX}_INCLUDE_DIR)
endmacro()

macro(cp_find LIB HEADER SUFFIX)
	string(TOUPPER ${LIB} PREFIX)
	if(CMAKE_SIZEOF_VOID_P EQUAL 8)
		set(_PROCESSOR_ARCH "x64")
	else()
		set(_PROCESSOR_ARCH "x86")
	endif()
	set(_SEARCH_PATHS
		~/Library/Frameworks
		/Library/Frameworks
		/usr/local
		/usr
		/sw # Fink
		/opt/local # DarwinPorts
		/opt/csw # Blastwave
		/opt
	)
	find_package(PkgConfig)
	if (LINK_STATIC_LIBS)
		set(PKG_PREFIX _${PREFIX}_STATIC)
	else()
		set(PKG_PREFIX _${PREFIX})
	endif()
	if (PKG_CONFIG_FOUND)
		message(STATUS "Checking for ${LIB}")
		pkg_check_modules(_${PREFIX} ${LIB})
		if (_${PREFIX}_FOUND)
			cp_message(STATUS "Found ${LIB} via pkg-config")
			cp_message(STATUS "CFLAGS: ${${PKG_PREFIX}_CFLAGS}")
			cp_message(STATUS "LDFLAGS: ${${PKG_PREFIX}_LDFLAGS}")
			set(${PREFIX}_COMPILERFLAGS ${${PKG_PREFIX}_CFLAGS})
			var_global(${PREFIX}_COMPILERFLAGS)
			set(${PREFIX}_LINKERFLAGS ${${PKG_PREFIX}_LDFLAGS})
			var_global(${PREFIX}_LINKERFLAGS)
			set(${PREFIX}_FOUND ${${PKG_PREFIX}_FOUND})
			var_global(${PREFIX}_FOUND)
			set(${PREFIX}_INCLUDE_DIRS ${${PKG_PREFIX}_INCLUDE_DIRS})
			var_global(${PREFIX}_INCLUDE_DIRS)
			set(${PREFIX}_INCLUDE_DIR ${${PKG_PREFIX}_INCLUDE_DIRS})
			var_global(${PREFIX}_INCLUDE_DIR)
			set(${PREFIX}_LIBRARY_DIRS ${${PKG_PREFIX}_LIBRARY_DIRS})
			var_global(${PREFIX}_LIBRARY_DIRS)
			set(${PREFIX}_LIBRARIES ${${PKG_PREFIX}_LIBRARIES})
			var_global(${PREFIX}_LIBRARIES)
			set(${PREFIX}_LIBRARY ${${PKG_PREFIX}_LIBRARIES})
			var_global(${PREFIX}_LIBRARY)
		else()
			cp_message(STATUS "Could not find ${LIB} via pkg-config")
		endif()
	endif()
	if (NOT _${PREFIX}_FOUND)
		find_path(${PREFIX}_INCLUDE_DIR ${HEADER}
			HINTS ENV ${PREFIX}DIR
			PATH_SUFFIXES include ${SUFFIX}
			PATHS
				${${PKG_PREFIX}_INCLUDE_DIRS}}
				${_SEARCH_PATHS}
		)
		find_library(${PREFIX}_LIBRARY
			${LIB}
			HINTS ENV ${PREFIX}DIR
			PATH_SUFFIXES lib64 lib lib/${_PROCESSOR_ARCH}
			PATHS
				${${PKG_PREFIX}_LIBRARY_DIRS}}
				${_SEARCH_PATHS}
		)
		include(FindPackageHandleStandardArgs)
		find_package_handle_standard_args(${LIB} DEFAULT_MSG ${PREFIX}_LIBRARIES ${PREFIX}_INCLUDE_DIRS)
		mark_as_advanced(${PREFIX}_INCLUDE_DIRS ${PREFIX}_LIBRARIES ${PREFIX}_LIBRARY)
	endif()
endmacro()

macro(cp_recurse_resolve_dependencies LIB DEPS)
	list(APPEND ${DEPS} ${LIB})
	get_property(_DEPS GLOBAL PROPERTY ${LIB}_DEPS)
	foreach(DEP ${_DEPS})
		cp_message("=> resolved dependency ${DEP} for ${LIB}")
		cp_recurse_resolve_dependencies(${DEP} ${DEPS})
	endforeach()
endmacro()

macro(cp_resolve_dependencies LIB DEPS)
	get_property(_DEPS GLOBAL PROPERTY ${LIB}_DEPS)
	list(APPEND ${DEPS} ${LIB})
	foreach(DEP ${_DEPS})
		cp_message("=> resolved dependency ${DEP} for ${LIB}")
		cp_recurse_resolve_dependencies(${DEP} ${DEPS})
	endforeach()
endmacro()

macro(cp_target_link_libraries)
	set(_OPTIONS_ARGS)
	set(_ONE_VALUE_ARGS TARGET)
	set(_MULTI_VALUE_ARGS LIBS)

	cmake_parse_arguments(_LINKLIBS "${_OPTIONS_ARGS}" "${_ONE_VALUE_ARGS}" "${_MULTI_VALUE_ARGS}" ${ARGN} )

	if (NOT _LINKLIBS_TARGET)
		message(FATAL_ERROR "cp_target_link_libraries requires the TARGET argument")
	endif()
	if (NOT _LINKLIBS_LIBS)
		message(FATAL_ERROR "cp_target_link_libraries requires the LIBS argument")
	endif()
	set(LINK_LIBS)
	cp_message("Resolve dependencies for ${ColorGreen}${_LINKLIBS_TARGET}${ColorReset}")
	foreach(LIB ${_LINKLIBS_LIBS})
		cp_resolve_dependencies(${LIB} LINK_LIBS)
	endforeach()
	if (LINK_LIBS)
		list(REMOVE_DUPLICATES LINK_LIBS)
	endif()
	message("Dependencies for ${ColorGreen}${_LINKLIBS_TARGET}${ColorReset}: ${LINK_LIBS}")

	string(TOUPPER ${_LINKLIBS_TARGET} TARGET)

	set(LINKERFLAGS)
	set(COMPILERFLAGS)
	set(LIBRARIES)

	foreach(LIB ${LINK_LIBS})
		string(TOUPPER ${LIB} PREFIX)
		if (${PREFIX}_LINKERFLAGS)
			list(APPEND LINKERFLAGS ${${PREFIX}_LINKERFLAGS})
			cp_message("Add linker flags from ${LIB} to ${_LINKLIBS_TARGET}")
		endif()
		if (${PREFIX}_COMPILERFLAGS)
			list(APPEND COMPILERFLAGS ${${PREFIX}_COMPILERFLAGS})
			cp_message("Add compiler flags from ${LIB} to ${_LINKLIBS_TARGET}")
		endif()
		cp_message("${PREFIX}_COMPILERFLAGS: ${${PREFIX}_COMPILERFLAGS}")
		if (NOT ${PREFIX}_LINKERFLAGS AND NOT ${PREFIX}_COMPILERFLAGS)
			if (${PREFIX}_LIBRARIES)
				list(APPEND LIBRARIES ${${PREFIX}_LIBRARIES})
			endif()
			if (${PREFIX}_LIBRARY)
				list(APPEND LIBRARIES ${${PREFIX}_LIBRARY})
			endif()
		else()
			cp_message("${PREFIX}_LINKERFLAGS: ${${PREFIX}_LINKERFLAGS}")
		endif()
	endforeach()
	if (LINKERFLAGS)
		list(REMOVE_DUPLICATES LINKERFLAGS)
		string(REPLACE ";" " " ${TARGET}_LINKERFLAGS "${LINKERFLAGS}")
		cp_message("LDFLAGS for ${_LINKLIBS_TARGET}: ${${TARGET}_LINKERFLAGS}")
		var_global(${TARGET}_LINKERFLAGS)
		set_target_properties(${_LINKLIBS_TARGET} PROPERTIES LINK_FLAGS "${${TARGET}_LINKERFLAGS}")
	else()
		cp_message("no special LDFLAGS for ${_LINKLIBS_TARGET} (${LINK_LIBS})")
	endif()
	if (COMPILERFLAGS)
		list(REMOVE_DUPLICATES COMPILERFLAGS)
		string(REPLACE ";" " " ${TARGET}_COMPILERFLAGS "${COMPILERFLAGS}")
		cp_message("CFLAGS for ${_LINKLIBS_TARGET}: ${${TARGET}_COMPILERFLAGS}")
		var_global(${TARGET}_COMPILERFLAGS)
		set_target_properties(${_LINKLIBS_TARGET} PROPERTIES COMPILE_FLAGS "${${TARGET}_COMPILERFLAGS}")
	else()
		cp_message("no special CFLAGS for ${_LINKLIBS_TARGET} (${LINK_LIBS})")
	endif()

	set_property(GLOBAL PROPERTY ${_LINKLIBS_TARGET}_DEPS ${_LINKLIBS_LIBS})
	if (LIBRARIES)
		list(REMOVE_DUPLICATES LIBRARIES)
		target_link_libraries(${_LINKLIBS_TARGET} optimized ${LIBRARIES})
	endif()
endmacro()