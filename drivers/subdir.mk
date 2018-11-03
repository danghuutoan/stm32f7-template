# DRIVER
DRIVER_DIR = drivers
# SRC
# CMSIS_SRCS+= CMSIS/Device/ST/STM32F7xx/Source/Templates/system_stm32f7xx.c

# INC
CMSIS_INC += CMSIS/Include \
			CMSIS/Device/ST/STM32F7xx/Include

HAL_SRC_DIR = STM32F7xx_HAL_Driver/Src
HAL_SRCS += $(HAL_SRC_DIR)/stm32f7xx_hal.c \
			$(HAL_SRC_DIR)/stm32f7xx_hal_cortex.c \
			$(HAL_SRC_DIR)/stm32f7xx_hal_dma.c \
			$(HAL_SRC_DIR)/stm32f7xx_hal_gpio.c \
			$(HAL_SRC_DIR)/stm32f7xx_hal_rcc.c \
			$(HAL_SRC_DIR)/stm32f7xx_hal_uart.c \
			$(HAL_SRC_DIR)/stm32f7xx_hal_pwr_ex.c

BSP_INC = BSP/STM32746G-Discovery
BSP_SRCS = BSP/STM32746G-Discovery/stm32746g_discovery.c
HAL_INCS += STM32F7xx_HAL_Driver/Inc 

DRIVER_INC = $(addprefix $(DRIVER_DIR)/, $(CMSIS_INC) $(HAL_INCS) $(BSP_INC))
DRIVER_SRCS = $(addprefix $(DRIVER_DIR)/, $(CMSIS_SRCS) $(BSP_SRCS) $(HAL_SRCS))
DRIVER_OBJS = $(addsuffix .o, $(basename $(DRIVER_SRCS)))
