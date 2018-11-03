
mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))
BINNAME = $(current_dir)

-include application/subdir.mk
-include drivers/subdir.mk
-include middlewares/subdir.mk

OUTPUT_DIR = output
# $(info    BINNAME is $(BINNAME))

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

OBJS += $(addprefix $(OUTPUT_DIR)/, $(S_OBJS) $(APP_OBJS) $(DRIVER_OBJS) $(MIDDLEWARE_OBJS))
DEPS += $(addsuffix .d, $(basename $(OBJS)))

LINKER_SRC = $(ROOT_DIR)/$(APP_DIR)/gcc/STM32F746NGHx_FLASH.ld
DEFS = -DUSE_HAL_DRIVER -DSTM32F746xx -DUSE_STM32746G_DISCOVERY

ASFLAGS = -mcpu=cortex-m7 -mthumb -mfloat-abi=hard -mfpu=fpv5-sp-d16
CFLAGS = $(ASFLAGS) -Os -g3 -fmessage-length=0 -ffunction-sections -c -fmessage-length=0
LDFLAGS = -mcpu=cortex-m7 -mthumb -mfloat-abi=hard -mfpu=fpv5-sp-d16 -specs=nosys.specs -specs=nano.specs -T$(LINKER_SRC) -Wl,-Map=$(OUTPUT_DIR)/output.map -Wl,--gc-sections -lm
# Each subdirectory must supply rules for building sources it contributes

$(OUTPUT_DIR)/%.o: %.c
	@mkdir -p $(@D)
	@$(CC) $(CFLAGS) $(DEFS) $(INC) -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -o "$@" "$<"
	@echo "CC ${@}"


$(OUTPUT_DIR)/%.o: %.s
	@mkdir -p $(@D)
	@$(AS) $(ASFLAGS) $(INC) -g -o "$@" "$<"
	@echo "AS $@"

# All Target
all: $(BINNAME).elf

# Tool invocations
$(BINNAME).elf: $(OBJS)
	@mkdir -p $(OUTPUT_DIR)
	@$(CC)  $(LDFLAGS) -o $@ $(OBJS) $(LIBS)
	@echo "CC $@"
	@echo ' '
	@$(MAKE) --no-print-directory post-build

# Other Targets
clean:
	-$(RM) -rf $(OUTPUT_DIR) $(BINNAME).*
	-@echo ' '
flash:
	@st-flash write $(BINNAME).bin 0x8000000

post-build:
	-@echo 'Generating binary and Printing size information:'
	-$(CP) -O binary $(BINNAME).elf $(BINNAME).bin
	@$(SZ) $(BINNAME).elf
	-@echo ' '

.PHONY: all clean dependents
.SECONDARY: post-build
