
#-------------------------------------------------------------------------------
# macros
#-------------------------------------------------------------------------------

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
		set(${VAR} ${${VAR}} CACHE STRING "" FORCE)
	endforeach()
endmacro()

macro(package_global LIB)
	find_package(${LIB})
	set(VARLIST "")
	list(APPEND VARLIST ${LIB}_FOUND)
	list(APPEND VARLIST ${LIB}_INCLUDE_DIR)
	list(APPEND VARLIST ${LIB}_INCLUDE_DIRS)
	list(APPEND VARLIST ${LIB}_LIBRARY)
	list(APPEND VARLIST ${LIB}_LIBRARIES)
	var_global("${VARLIST}")
endmacro()