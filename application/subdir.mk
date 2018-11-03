# APPLICATION
APP_DIR = application

APP_SRCS += $(APP_DIR)/user/system_stm32f7xx.c \
			$(APP_DIR)/gcc/syscalls.c \
			$(APP_DIR)/user/stm32f7xx_hal_msp.c \
			$(APP_DIR)/user/main.c \
			$(APP_DIR)/user/stm32f7xx_it.c

S_SRCS += $(APP_DIR)/gcc/startup_stm32f746xx.s
# S_OBJS = $(addsuffix .o, $(basename $(S_SRCS)))

APP_INC = $(APP_DIR)/inc

APP_OBJS = $(addsuffix .o, $(basename $(S_SRCS) $(APP_SRCS)))
