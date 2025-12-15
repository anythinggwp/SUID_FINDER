# !/bin/sh
set -e

echo "Загружаем дистрибутив для virtualbox"
wget -O alpine-virtualbox.iso https://dl-cdn.alpinelinux.org/alpine/v3.23/releases/x86_64/alpine-standard-3.23.0-x86_64.iso

# echo "Создаем tap интерфейс"
# ip tuntap add dev tap0 mode tap
# ip link set tap0 master br0
# ip link set tap0 up

# --- Настройки виртуальной машины ---
VM_NAME="alpineVM"
VM_OS_TYPE="Linux_64"        
VM_RAM=1024                  
VM_VRAM=16                   
VM_CPU=1
VM_DISK_SIZE=8000           
VM_DISK_PATH="$HOME/VirtualBox VMs/$VM_NAME/$VM_NAME.vdi"
VM_ISO_PATH="./alpine-virtualbox.iso"
VM_NET="nat"                

# Создаем директорию для хранения vm virtualbox
mkdir -p "$HOME/VirtualBoxVMs/$VM_NAME"

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
    --boot3 none \
    --boot4 none \
    --ioapic on \
    --nic1 $VM_NET

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
    --accelerate3d on \
    --audio none

echo "Виртуальная машина '$VM_NAME' создана. Можно запускать через:"
echo "VBoxManage startvm \"$VM_NAME\" --type gui"
