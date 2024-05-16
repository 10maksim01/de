#!/bin/bash
cat ./ProxmoxInterfaces.txt >> /etc/network/interfaces;
systemctl restart networking;
apt-get install python3-pip python3-venv -y;
python3 -m venv myenv;
source myenv/bin/activate;
pip3 install wldhx.yadisk-direct;
read -p "Введите имя вашего локального хранилища: " STORAGE
curl -L $(yadisk-direct https://disk.yandex.ru/d/TOg9N-oZVjXfdw) -o ISP-disk001.vmdk
qm create 100 --name "ISP" --cores 2 --memory 2048 --ostype l26 --scsihw virtio-scsi-single --net0 e1000,bridge=vmbr1 --net1 e1000,bridge=vmbr2 --net2 e1000,bridge=vmbr5 --net3 e1000
qm importdisk 100 ISP-disk001.vmdk $STORAGE --format qcow2 
qm set 100 -ide0 $STORAGE:vm-100-disk-0 --boot order=ide0
echo "ISP is done!!!"
curl -L $(yadisk-direct https://disk.yandex.ru/d/TOg9N-oZVjXfdw) -o HQ-R-disk001.vmdk
qm create 101 --name "HQ-R" --cores 2 --memory 2048 --ostype l26 --scsihw virtio-scsi-single --net0 e1000,bridge=vmbr1 --net1 e1000,bridge=vmbr3 --net2 e1000 
qm importdisk 101 HQ-R-disk001.vmdk $STORAGE --format qcow2 
qm set 101 -ide0 $STORAGE:vm-101-disk-0 --boot order=ide0
echo "HQ-R is done!!!"
curl -L $(yadisk-direct https://disk.yandex.ru/d/TOg9N-oZVjXfdw) -o BR-R-disk001.vmdk
qm create 102 --name "BR-R" --cores 2 --memory 2048 --ostype l26 --scsihw virtio-scsi-single --net0 e1000,bridge=vmbr2 --net1 e1000,bridge=vmbr4 --net2 e1000 
qm importdisk 102 BR-R-disk001.vmdk $STORAGE --format qcow2 
qm set 102 -ide0 $STORAGE:vm-102-disk-0 --boot order=ide0
echo "BR-R is done!!!"
curl -L $(yadisk-direct https://disk.yandex.ru/d/TOg9N-oZVjXfdw) -o BR-SRV-disk001.vmdk
qm create 103 --name "BR-SRV" --cores 2 --memory 2048 --ostype l26 --scsihw virtio-scsi-single --net0 e1000,bridge=vmbr4 --net1 e1000
qm importdisk 103 BR-SRV-disk001.vmdk $STORAGE --format qcow2 
qm set 103 -ide0 $STORAGE:vm-103-disk-0 --boot order=ide0
echo "BR-SRV is done!!!"
curl -L $(yadisk-direct https://disk.yandex.ru/d/TOg9N-oZVjXfdw) -o HQ-SRV-disk001.vmdk
qm create 104 --name "HQ-SRV" --cores 2 --memory 2048 --ostype l26 --scsihw virtio-scsi-single --net0 e1000,bridge=vmbr3 --net1 e1000
qm importdisk 104 HQ-SRV-disk001.vmdk $STORAGE --format qcow2 
qm set 104 -ide0 $STORAGE:vm-104-disk-0 --boot order=ide0
echo "HQ-SRV is done!!!"
curl -L $(yadisk-direct https://disk.yandex.ru/d/Vf9gwcrzDPE1FQ) -o CLI-disk001.vmdk
qm create 105 --name "CLI" --cores 2 --memory 2048 --ostype l26 --scsihw virtio-scsi-single --net0 e1000,bridge=vmbr5 --net1 e1000,
qm importdisk 105 CLI-disk001.vmdk $STORAGE --format qcow2 
qm set 105 -ide0 $STORAGE:vm-105-disk-0 --boot order=ide0
echo "CLI is done!!!"
echo "ALL DONE!!!"
