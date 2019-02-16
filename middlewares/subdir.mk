# MIDDLEWARE
MIDDLEWARE_DIR = middlewares
# FreeRTOS_SRCS += FreeRTOS/Source/croutine.c \
# 					FreeRTOS/Source/list.c \
# 					FreeRTOS/Source/queue.c \
# 					FreeRTOS/Source/tasks.c \
# 					FreeRTOS/Source/timers.c \
# 					FreeRTOS/Source/portable/MemMang/heap_4.c \
# 					FreeRTOS/Source/portable/GCC/ARM_CM7/r0p1/port.c \
# 					FreeRTOS/Source/CMSIS_RTOS/cmsis_os.c

FreeRTOS_INC += FreeRTOS/Source/CMSIS_RTOS \
				FreeRTOS/Source/include \
				FreeRTOS/Source/portable/GCC/ARM_CM7/r0p1

FatFs_SRCS += FatFs/src/diskio.c \
				FatFs/src/ff.c \
				FatFs/src/ff_gen_drv.c \
				FatFs/src/drivers/sd_diskio.c \
				FatFs/src/option/ccsbcs.c
				# FatFs/src/option/syscall.c

FatFs_INC += FatFs/src \
			FatFs/src/drivers
MIDDLEWARE_INC = $(addprefix $(MIDDLEWARE_DIR)/, $(FreeRTOS_INC) $(FatFs_INC))
MIDDLEWARE_SRCS = $(addprefix $(MIDDLEWARE_DIR)/, $(FreeRTOS_SRCS) $(FatFs_SRCS))
MIDDLEWARE_OBJS = $(addsuffix .o, $(basename $(MIDDLEWARE_SRCS)))