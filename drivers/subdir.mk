# DRIVER
DRIVER_DIR = drivers
# SRC
CMSIS_SRCS+= CMSIS/Device/ST/STM32F7xx/Source/Templates/system_stm32f7xx.c

# INC
CMSIS_INC += CMSIS/Include \
			CMSIS/Device/ST/STM32F7xx/Include
HAL_SRCS +=
HAL_INCS += STM32F7xx_HAL_Driver/Inc 

DRIVER_INC = $(addprefix $(DRIVER_DIR)/, $(CMSIS_INC) $(HAL_INCS)) 
DRIVER_SRCS = $(addprefix $(DRIVER_DIR)/, $(CMSIS_SRCS))
DRIVER_OBJS = $(addsuffix .o, $(basename $(DRIVER_SRCS)))

$(info    DRIVER_SRCS is $(DRIVER_SRCS))
$(info    DRIVER_OBJS is $(DRIVER_OBJS))