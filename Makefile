VERSION_NAME=electronic_experience
BIN_PATH=./bin

CSRC = $(wildcard *.c)
OBJ_NO_DIR = $(CSRC:%.c=%.o)
OBJ = $(patsubst %.c,$(BIN_PATH)/%.o,$(CSRC))

DOCKER_IMAGE_NAME = mighty-arm-development
PORT = /dev/ttyUSB0
EXAMPLE = bluepill_test

UID = $(shell id -u)
GID = $(shell id -g)

build_image:
	sudo docker build --build-arg UID=${UID} \
		--build-arg GID=${GID} \
		-t $(DOCKER_IMAGE_NAME) .

rm_image:
	sudo docker rmi -f $(DOCKER_IMAGE_NAME)

console: build_image
	sudo docker run -v $(shell pwd):/home/src/ \
		-ti \
		--rm \
		--device=$(PORT) \
		$(DOCKER_IMAGE_NAME)

lap_fw: build_image ## Build lapcounter firmware at src/
	sudo docker run -v $(shell pwd):/home/src/ \
		-ti \
		--rm \
		$(DOCKER_IMAGE_NAME) \
		make -C src/ clean all

lap_fw_flash: build_image ## Flash firmware to the board at PORT (default: /dev/ttyUSB0). Example: make buga_fw_flash PORT=/dev/ttyUSB3
	sudo docker run -v $(shell pwd):/home/src/ \
		-ti \
		--rm \
		--device=$(PORT) \
		$(DOCKER_IMAGE_NAME) \
		stm32loader -p $(PORT) -e -w -V -g 0x08000000 -v src/lapcounter.bin

help:
	@printf '\033[33mBase targets:\033[0m\n'
	@printf '\033[36m    %-25s\033[0m %s\n' 'build_image' 'Generate Docker development image. Includes ARM GCC toolchain and stm32loader.'
	@printf '\033[36m    %-25s\033[0m %s\n' 'rm_image' 'Delete Docker development image.'
	@printf '\033[36m    %-25s\033[0m %s\n' 'console' 'Run Docker container with an interactive bash terminal'
	@printf '\033[36m    %-25s\033[0m %s\n' 'lap_fw' 'Build lapcounter firwmare at src/'
	@printf '\033[36m    %-25s\033[0m %s\n' 'lap_fw_flash' 'Load firmware to the board connected to PORT (default: /dev/ttyUSB0). Example: make lap_fw_flash PORT=/dev/ttyUSB3'
	@printf '\n'

.DEFAULT_GOAL := help
