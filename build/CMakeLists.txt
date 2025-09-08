#############################################################################################################################
# file:  CMakeLists.txt
# brief: Template "CMakeLists.txt" for building of executables and static libraries.
#
# usage: Edit "VARIABLES"-section to suit project requirements.
#        For debug build:
#          cmake -DCMAKE_TOOLCHAIN_FILE=cubeide-gcc.cmake  -S ./ -B Debug -G"Unix Makefiles" -DCMAKE_BUILD_TYPE=Debug
#          make -C Debug VERBOSE=1 -j
#        For release build:
#          cmake -DCMAKE_TOOLCHAIN_FILE=cubeide-gcc.cmake  -S ./ -B Release -G"Unix Makefiles" -DCMAKE_BUILD_TYPE=Release
#          make -C Release VERBOSE=1 -j
#############################################################################################################################
cmake_minimum_required(VERSION 3.20)

###################### CONSTANTS ######################################
set (PROJECT_TYPE_EXECUTABLE          "exe")
set (PROJECT_TYPE_STATIC_LIBRARY      "static-lib")
set (MCPU_CORTEX_M0				      "-mcpu=cortex-m0")
set (MCPU_CORTEX_M0PLUS				  "-mcpu=cortex-m0plus")
set (MCPU_CORTEX_M3				      "-mcpu=cortex-m3")
set (MCPU_CORTEX_M4				      "-mcpu=cortex-m4")
set (MCPU_CORTEX_M7				      "-mcpu=cortex-m7")
set (MCPU_CORTEX_M33				  "-mcpu=cortex-m33")
set (MCPU_CORTEX_M55				  "-mcpu=cortex-m55")
set (MCPU_CORTEX_M85				  "-mcpu=cortex-m85")
set (MFPU_FPV4_SP_D16                 "-mfpu=fpv4-sp-d16")
set (MFPU_FPV5_D16                    "-mfpu=fpv5-d16")
set (RUNTIME_LIBRARY_REDUCED_C        "--specs=nano.specs")
set (RUNTIME_LIBRARY_STD_C            "")
set (RUNTIME_LIBRARY_SYSCALLS_MINIMAL "--specs=nosys.specs")
set (RUNTIME_LIBRARY_SYSCALLS_NONE    "")
set (MFLOAT_ABI_SOFTWARE              "-mfloat-abi=soft")
set (MFLOAT_ABI_HARDWARE              "-mfloat-abi=hard")
set (MFLOAT_ABI_MIX                   "-mfloat-abi=softfp")
#######################################################################

###################### VARIABLES ######################################
set (PROJECT_NAME             "EMBEDDED_TEST")
set (PROJECT_TYPE             "exe")
set (LINKER_SCRIPT            "../Cube_Project/STM32F401VEHX_FLASH.ld")
set (MCPU                     "-mcpu=Cortex-M4")
set (MFPU                 "-mfpu=fpv4-sp-d16")
set (MFLOAT_ABI               "")
set (RUNTIME_LIBRARY          "--specs=nano.specs")
set (RUNTIME_LIBRARY_SYSCALLS "--specs=nosys.specs")



set (PROJECT_SOURCES_CUBE_GENERATED
	# LIST CUBE GENERATED SOURCE FILES HERE

	../Cube_Project/Core/Startup/startup_stm32f401vehx.s
	../Cube_Project/Core/Src/main.c
	../Cube_Project/Core/Src/syscalls.c
	../Cube_Project/Core/Src/sysmem.c
	../Cube_Project/Core/Src/system_stm32f4xx.c
	../Cube_Project/Core/Src/stm32f4xx_hal_msp.c
	../Cube_Project/Core/Src/stm32f4xx_it.c

	../Cube_Project/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal.c 
	../Cube_Project/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_cortex.c 
	../Cube_Project/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_dma.c 
	../Cube_Project/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_dma_ex.c 
	../Cube_Project/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_exti.c 
	../Cube_Project/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_flash.c 
	../Cube_Project/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_flash_ex.c 
	../Cube_Project/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_flash_ramfunc.c 
	../Cube_Project/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_gpio.c 
	../Cube_Project/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_pwr.c 
	../Cube_Project/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_pwr_ex.c 
	../Cube_Project/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_rcc.c 
	../Cube_Project/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_rcc_ex.c 

	)
set (PROJECT_SOURCES_EXTERNAL
	# LIST EXTERNAL SOURCE FILES HERE
	../External/printf/printf.c
	)

set (PROJECT_DEFINES
	# LIST COMPILER DEFINITIONS HERE

    )

set (PROJECT_INCLUDES
	# LIST INCLUDE DIRECTORIES HERE
    ../Cube_Project/Core/Inc
	../Cube_Project/Drivers/STM32F4xx_HAL_Driver/Inc
	../Cube_Project/Drivers/STM32F4xx_HAL_Driver/Inc/Legacy
	../Cube_Project/Drivers/CMSIS/Device/ST/STM32F4xx/Include
	../Cube_Project/Drivers/CMSIS/Include
	../External/printf
    )

############ MODIFY ACCORDING TO REQUIREMENTS) ########################

#######################################################################

################## PROJECT SETUP ######################################
project(${PROJECT_NAME})
enable_language(ASM)

if (${PROJECT_TYPE} MATCHES ${PROJECT_TYPE_EXECUTABLE})
  add_executable(${PROJECT_NAME} ${PROJECT_SOURCES_CUBE_GENERATED} ${PROJECT_SOURCES_EXTERNAL})
  add_custom_command(TARGET ${CMAKE_PROJECT_NAME} POST_BUILD COMMAND ${CMAKE_SIZE} $<TARGET_FILE:${CMAKE_PROJECT_NAME}>)
elseif (${PROJECT_TYPE} MATCHES ${PROJECT_TYPE_STATIC_LIBRARY})
  add_library(${PROJECT_NAME} ${PROJECT_SOURCES})
endif()

add_compile_definitions (${PROJECT_DEFINES})
include_directories (${PROJECT_INCLUDES})

set (CMAKE_EXECUTABLE_SUFFIX ".elf")
set (CMAKE_STATIC_LIBRARY_SUFFIX ".a")
set (CMAKE_C_FLAGS "${MCPU} -std=gnu11 ${MFPU} ${MFLOAT_ABI} ${RUNTIME_LIBRARY} -mthumb -Wall -Werror")
set (CMAKE_EXE_LINKER_FLAGS "-T${LINKER_SCRIPT} ${RUNTIME_LIBRARY_SYSCALLS} -Wl,-Map=test.map -Wl,--gc-sections -static -Wl,--start-group -lc -lm -Wl,--end-group")
set (CMAKE_ASM_FLAGS "${CMAKE_C_FLAGS} -x assembler-with-cpp")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DSTM32F401xE")


# Integrate cppcheck for static analysis
find_program(CPPCHECK cppcheck)
if(CPPCHECK)
    message(STATUS "Found cppcheck: ${CPPCHECK}")
set(CPPCHECK_OPTIONS 
    --enable=warning,style,performance,portability
    --suppress=missingIncludeSystem
    --suppress=missingInclude
    --suppress=*:*.h
    --suppress=*:*.hpp
    --inline-suppr
    --quiet
    -j 4
)
    set(CPPCHECK_FILES 
        ${PROJECT_SOURCES_CUBE_GENERATED}
        ${PROJECT_SOURCES_EXTERNAL}
    )
    list(FILTER CPPCHECK_FILES EXCLUDE REGEX "\\.s$")
    add_custom_target(
        cppcheck
        COMMAND ${CPPCHECK} ${CPPCHECK_OPTIONS}  ${CPPCHECK_FILES}
       WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        COMMENT "Running cppcheck static analysis..."
    )
else()
    message(WARNING "cppcheck not found. Static analysis target will not be available.")
endif()