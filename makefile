
-include application/subdir.mk
-include drivers/subdir.mk

mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))
BINNAME = $(current_dir)
OUTPUT_DIR = output
$(info    BINNAME is $(BINNAME))

TOOLCHAIN_DIR = /Users/toan/study/stm32/gcc-arm-none-eabi-7-2018-q2-update/bin
CC = $(TOOLCHAIN_DIR)/arm-none-eabi-gcc
AS = $(TOOLCHAIN_DIR)/arm-none-eabi-as
CP = $(TOOLCHAIN_DIR)/arm-none-eabi-objcopy
SZ = $(TOOLCHAIN_DIR)/arm-none-eabi-size
# makefile is in the root directory
ROOT_DIR = $(shell echo `pwd`)
# $(info    ROOT_DIR is $(ROOT_DIR))

C_SRCS += $(DRIVER_SRCS) $(MIDDLEWARE_SRCS) $(APP_SRCS)

INC = $(addprefix -I, $(addprefix $(ROOT_DIR)/, $(DRIVER_INC) $(MIDDLEWARE_INC) $(APP_INC)))

S_SRCS += $(DRIVER_DIR)/CMSIS/Device/ST/STM32F7xx/Source/Templates/gcc/startup_stm32f746xx.s
S_OBJS = $(addsuffix .o, $(basename $(S_SRCS)))
S_DEPS = $(addsuffix .d, $(basename $(S_SRCS)))



OBJS += $(addprefix $(OUTPUT_DIR)/, $(APP_OBJS) $(S_OBJS) $(DRIVER_OBJS) $(MIDDLEWARE_OBJS))
DEPS += $(addsuffix .d, $(basename $(OBJS)))

LINKER_SRC = $(ROOT_DIR)/$(APP_DIR)/gcc/STM32F746NGHx_FLASH.ld
DEFS = -DUSE_HAL_DRIVER -DSTM32F746xx -DUSE_STM32746G_DISCOVERY

ASFLAGS = -mcpu=cortex-m7 -mthumb -mfloat-abi=hard -mfpu=fpv5-sp-d16
CFLAGS = $(ASFLAGS) -Os -g3 -fmessage-length=0 -ffunction-sections -c -fmessage-length=0
LDFLAGS = -mcpu=cortex-m7 -mthumb -mfloat-abi=hard -mfpu=fpv5-sp-d16 -specs=nosys.specs -specs=nano.specs -T$(LINKER_SRC) -Wl,-Map=$(OUTPUT_DIR)/output.map -Wl,--gc-sections -lm
# Each subdirectory must supply rules for building sources it contributes

$(OUTPUT_DIR)/%.o: %.c
	@mkdir -p $(@D)
	echo 'Building file: $<'
	echo 'Invoking: Cross GCC Compiler'
	$(CC) $(CFLAGS) $(DEFS) $(INC) -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

$(OUTPUT_DIR)/%.o: %.s
	@mkdir -p $(@D)
	@echo 'Building file: $<'
	@echo 'Invoking: MCU GCC Assembler'
	$(AS) $(ASFLAGS) $(INC) -g -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

# $(info    INC is $(INC))
# All Target
all: $(BINNAME).elf

$(info    OBJS is $(OBJS))
# Tool invocations
$(BINNAME).elf: $(OBJS)
	@mkdir -p $(OUTPUT_DIR)
	@echo 'Building target: $@'
	@echo 'Invoking: MCU GCC Linker'
	$(CC)  $(LDFLAGS) -o $@ $(OBJS) $(LIBS)
	@echo 'Finished building target: $@'
	@echo ' '
	$(MAKE) --no-print-directory post-build

# Other Targets
clean:
	-$(RM) -rf $(OUTPUT_DIR) $(BINNAME).*
	-@echo ' '

post-build:
	-@echo 'Generating binary and Printing size information:'
	-$(CP) -O binary $(BINNAME).elf $(BINNAME).bin && $(SZ) $(BINNAME).elf
	-@echo ' '

.PHONY: all clean dependents
.SECONDARY: post-build
