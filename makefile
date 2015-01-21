CUBE = C:\Users\Theo\Desktop\GIT\STM32Cube_FW_F4_V1.3.0

CC = arm-none-eabi-gcc

NAME = stm32-rtos
BIN = $(OUTDIR)/$(NAME).bin
OUT = $(OUTDIR)/$(NAME).elf

OBJDIR = obj
OUTDIR = bin
SRCDIR = src

#User Source files
SRC := $(wildcard $(SRCDIR)/*.c)
SRC += $(wildcard $(SRCDIR)/*.s)

#User Include directories
CFLAGS := -IInc

#Library Source Files
SRC += $(wildcard $(CUBE)/Drivers/STM32F4xx_HAL_Driver/Src/*.c)
SRC += $(CUBE)/Drivers/BSP/STM32F429I-Discovery/stm32f429i_discovery.c
SRC += $(CUBE)/Drivers/CMSIS/system_stm32f4xx.c
SRC += $(CUBE)/Middlewares/Third_Party/FreeRTOS/Source/list.c
SRC += $(CUBE)/Middlewares/Third_Party/FreeRTOS/Source/queue.c
SRC += $(CUBE)/Middlewares/Third_Party/FreeRTOS/Source/tasks.c
SRC += $(CUBE)/Middlewares/Third_Party/FreeRTOS/Source/timers.c
SRC += $(CUBE)/Middlewares/Third_Party/FreeRTOS/Source/CMSIS_RTOS/cmsis_os.c
SRC += $(CUBE)/Middlewares/Third_Party/FreeRTOS/Source/portable/port.c
SRC += $(CUBE)/Middlewares/Third_Party/FreeRTOS/Source/portable/heap_4.c

#Library include directories
CFLAGS += -I$(CUBE)/Drivers/
CFLAGS += -I$(CUBE)/Drivers/STM32F4xx_HAL_Driver/Inc/
CFLAGS += -I$(CUBE)/Drivers/CMSIS/Device/ST/STM32F4xx/Include/
CFLAGS += -I$(CUBE)/Drivers/BSP/STM32F429I-Discovery/
CFLAGS += -I$(CUBE)/Drivers/BSP/Components/
CFLAGS += -I$(CUBE)/Drivers/CMSIS/Include/
CFLAGS += -I$(CUBE)/Middlewares/Third_Party/FreeRTOS/Source/portable/GCC/ARM_CM4F
CFLAGS += -I$(CUBE)/Middlewares/Third_Party/FreeRTOS/Source/CMSIS_RTOS/
CFLAGS += -I$(CUBE)/Middlewares/Third_Party/FreeRTOS/Source/include/
CFLAGS += -I$(CUBE)/Utilities/

CFLAGS += --specs=rdimon.specs -lc -lrdimon 

OBJS = $(addprefix $(OBJDIR)/, $(notdir $(addsuffix .o, $(basename $(SRC)))))

VPATH := $(SRCDIR)
VPATH += $(CUBE)/Drivers/STM32F4xx_HAL_Driver/Src
VPATH += $(CUBE)/Drivers/BSP/STM32F429I-Discovery
VPATH += $(CUBE)/Drivers/CMSIS/
VPATH += $(CUBE)/Middlewares/Third_Party/FreeRTOS/Source
VPATH += $(CUBE)/Middlewares/Third_Party/FreeRTOS/Source/CMSIS_RTOS
VPATH += $(CUBE)/Middlewares/Third_Party/FreeRTOS/Source/portable/GCC/ARM_CM4F
VPATH += $(CUBE)/Middlewares/Third_Party/FreeRTOS/Source/portable/MemMang

#Additional compilation options
CFLAGS += -std=c99 -g -DSTM32F429xx -DARM_MATH_CM4 -D__FPU_PRESENT -DUSE_HAL_DRIVER -DUSE_STM32F429I_DISCO
CFLAGS += -mlittle-endian -mthumb -mcpu=cortex-m4
CFLAGS += -TSTM32F429ZI_FLASH.ld -mfloat-abi=hard -mfpu=fpv4-sp-d16 -march=armv7e-m -mtune=cortex-m4

$(OBJDIR)/%.o: $(notdir %.c)
	-mkdir $(subst /,\\,$(@D))
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJDIR)/%.o: $(notdir %.s)
	-mkdir $(subst /,\\,$(@D))
	$(CC) $(CFLAGS) -xassembler-with-cpp -c $< -o $@

$(OUT): $(OBJS)
	-mkdir $(subst /,\\,$(@D))
	$(CC) $(CFLAGS) $^ -o $@

all: $(OUT)
	-mkdir $(subst /,\\,$(@D))
	arm-none-eabi-objcopy $(OUT) $(BIN) -O binary

flash:
	openocd -f board/stm32f4discovery.cfg -f flash.cfg

debug:
	@echo $(SRC)
