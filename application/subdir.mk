# APPLICATION
APP_DIR = application

APP_SRCS += $(APP_DIR)/user/main.c
APP_SRCS += $(APP_DIR)/gcc/syscalls.c

APP_INC = $(APP_DIR)/inc

APP_OBJS = $(addsuffix .o, $(basename $(APP_SRCS)))
