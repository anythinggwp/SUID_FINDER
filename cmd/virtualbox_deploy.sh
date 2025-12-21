# !/bin/sh
set -e

if [ -f "./alpine-virtualbox.iso" ]; then
    echo "Файл ISO уже существует: alpine-virtualbox.iso"
else
    echo "Загружаем дистрибутив для virtualbox"
    wget -O alpine-virtualbox.iso https://dl-cdn.alpinelinux.org/alpine/v3.23/releases/x86_64/alpine-standard-3.23.0-x86_64.iso
fi


VM_NAME="alpineVM"
VM_OS_TYPE="Linux64"
VM_RAM=2048
VM_VRAM=16                   
VM_CPU=2
VM_DISK_SIZE=8000           
VM_DISK_PATH="$HOME/VirtualBox VMs/$VM_NAME/$VM_NAME.vdi"
VM_ISO_PATH="./alpine-virtualbox.iso"

# Создаем директорию для хранения vm virtualbox если нет
mkdir -p "$HOME/VirtualBox VMs/$VM_NAME"

echo "--- Создание виртуальной машины ---"
VBoxManage createvm \
    --name "$VM_NAME" \
    --ostype "$VM_OS_TYPE" \
    --register

echo "--- Настройка памяти и CPU ---"
VBoxManage modifyvm "$VM_NAME" \
    --memory $VM_RAM \
    --vram $VM_VRAM \
    --cpus $VM_CPU \
    --boot1 dvd \
    --boot2 disk \
    --ioapic on \
    --hwvirtex on \
    --largepages on

echo "--- Настройка сети ---"
VBoxManage modifyvm "$VM_NAME" \
    --nic1 bridged \
    --bridgeadapter1 br0 \
    --nictype1 82540EM \
    --cableconnected1 on

echo "--- Создание виртуального диска ---"
VBoxManage createmedium disk \
    --filename "$VM_DISK_PATH" \
    --size $VM_DISK_SIZE \
    --format VDI

echo "--- Присоединение диска к SATA контроллеру ---"
VBoxManage storagectl "$VM_NAME" \
    --name "SATA Controller" \
    --add sata \
    --controller IntelAhci

VBoxManage storageattach "$VM_NAME" \
    --storagectl "SATA Controller" \
    --port 0 \
    --device 0 \
    --type hdd \
    --medium "$VM_DISK_PATH"

echo "--- Присоединение ISO к IDE контроллеру для установки ---"
VBoxManage storagectl "$VM_NAME" \
    --name "IDE Controller" \
    --add ide

VBoxManage storageattach "$VM_NAME" \
    --storagectl "IDE Controller" \
    --port 0 \
    --device 0 \
    --type dvddrive \
    --medium "$VM_ISO_PATH"

echo "--- Включение ускорения 3D и гостевых дополнений ---"
VBoxManage modifyvm "$VM_NAME" \
    --graphicscontroller vmsvga \
    --accelerate3d on \
    --audio none

echo "--- Виртуальная машина '$VM_NAME' создана. Запускаем ВМ ---"
VBoxManage startvm "$VM_NAME"
