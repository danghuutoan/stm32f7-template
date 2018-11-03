# MIDDLEWARE
MIDDLEWARE_DIR = middlewares
FreeRTOS_SRCS += FreeRTOS/Source/croutine.c \
					FreeRTOS/Source/list.c \
					FreeRTOS/Source/queue.c \
					FreeRTOS/Source/tasks.c \
					FreeRTOS/Source/timers.c \
					FreeRTOS/Source/portable/MemMang/heap_4.c \
					FreeRTOS/Source/portable/GCC/ARM_CM7/r0p1/port.c \
					FreeRTOS/Source/CMSIS_RTOS/cmsis_os.c

FreeRTOS_INC += FreeRTOS/Source/CMSIS_RTOS \
				FreeRTOS/Source/include \
				FreeRTOS/Source/portable/GCC/ARM_CM7/r0p1

MIDDLEWARE_INC = $(addprefix $(MIDDLEWARE_DIR)/, $(FreeRTOS_INC))
MIDDLEWARE_SRCS = $(addprefix $(MIDDLEWARE_DIR)/, $(FreeRTOS_SRCS))
MIDDLEWARE_OBJS = $(addsuffix .o, $(basename $(MIDDLEWARE_SRCS)))