# Ansibile

---

## REFERECNE

---

- 
- 

## Install
```bash
# install ansible SERVER
dnf install rhel-system-roles ansible-core
```
```bash
# install ansible LOCALHOST
pip3 install ansible
```

# Check Install
```bash
ansible --version
ansible [core 2.14.3]
  config file = None
  configured module search path = ['/Users/kihoonyang/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /opt/homebrew/Cellar/ansible/7.3.0/libexec/lib/python3.11/site-packages/ansible
  ansible collection location = /Users/kihoonyang/.ansible/collections:/usr/share/ansible/collections
  executable location = /opt/homebrew/bin/ansible
  python version = 3.11.2 (main, Feb 16 2023, 02:55:59) [Clang 14.0.0 (clang-1400.0.29.202)] (/opt/homebrew/Cellar/ansible/7.3.0/libexec/bin/python3.11)
  jinja version = 3.1.2
  libyaml = True
```

# Check ansible ping
```bash
ansible localhost -m ping
[WARNING]: No inventory was parsed, only implicit localhost is available
localhost | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

# Set inventory file
- NCP CLI로 Inventory List 조회
```bash
sudo vi /etc/ansible/hosts
[test]
127.0.0.1
```


# Configure SSH Authentication
- https://therealmarv.com/ansible-vault-file-handling/
- pem 파일 등록

## API Authentication
```
# ICT Key
  - Access Key ID = C2AF5118B23A1E190253
  - Secret Key = 7E92A25543BDE8696F4E2FA7D093BFD42AE9089B
  
  - IP : 221.168.39.193
  - PW : U4=rM5n=i24rc
```

## TEMP
apt install openjdk-11-jre-headless  # version 11.0.11+9-0ubuntu2~20.04





Step 9: Disable Password Authentication
$sudo vi /etc/ssh/sshd_config


Update PasswordAuthentication from “yes” to “no” as below:
# Change to no to disable tunnelled clear text passwords
PasswordAuthentication no


Step 10: Restart Linux Server
$sudo reboot



## for storage playbook
ansible-galaxy collection install community.general

# storage 확인
~]# fdisk -l

# 실행
ansible-playbook site.yml -i inventory_dev




function create_server_image() {
instanceNo=$(echo "$1" | jq . -r '.serverInstanceNo')
serverName=$(echo "$1" | jq . -r '.serverName')

timestamp=$(date +%Y%m%d)

imageName=${serverName}+"-"+${timestamp}

./ncloud vserver createMemberServerImageInstance --regionCode FKR --serverInstanceNo $instanceNo --memberServerImageName $imageName
}

create_server_image ${instance_list}


