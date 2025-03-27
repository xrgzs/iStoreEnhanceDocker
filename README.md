# iStore 增强 Docker iStoreEnhanceDocker

此项目将 iStore 增强 的 IPK 打包成 Docker 镜像，方便在非 iStoreOS 设备上使用。

iStore 增强插件可以有效的解决 Docker 等网络问题，让 iStore 更好用。

## 使用方法

### 搭建

Docker：

```shell
docker pull ghcr.io/xrgzs/istoreenhance:main
docker run -p 5003:5003 -p 5443:5443 -v /usr/share/iStoreEnhance:/usr/share/iStoreEnhance ghcr.io/xrgzs/istoreenhance:main
```

Docker Compose：

```yaml
name: istoreenhance
services:
  istoreenhance:
    image: m.ixdev.cn/ghcr.io/xrgzs/istoreenhance:main
    container_name: iStoreEnhance
    ports:
      - "5003:5003" # 管理面板
      - "5443:5443" # 注册表镜像
    environment:
      - TZ=Asia/Shanghai
    volumes:
      - ./data:/usr/share/iStoreEnhance
    restart: always
```

### 使用

https://www.bilibili.com/video/BV1GvQWYZEt9/

本机使用：

如果只考虑本机使用，建议将端口改为 `127.0.0.1:5443:5443`，避免外部访问

```shell
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<EOF
{
    "registry-mirrors": [
        "https://registry.linkease.net:5443"
    ]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker
```

其他机器使用：

假设已经运行 iStoreEnhance 的机器 IP 为 192.168.1.2


```shell
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<EOF
{
    "registry-mirrors": [
        "https://192.168.1.2:5443"
    ],
    "insecure-registries": [
        "192.168.1.2:5443"
    ]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker
```

或：

```shell
sudo echo "192.168.1.2 registry.linkease.net" >> /etc/hosts
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<EOF
{
    "registry-mirrors": [
        "https://registry.linkease.net:5443"
    ]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker
```

### 管理

假设已经运行 iStoreEnhance 的机器 IP 为 192.168.1.2，访问 http://192.168.1.2:5003 即可打开管理面板查看统计信息。

![](https://github.com/user-attachments/assets/9d103770-84ee-4689-bf52-ab3c571e2b08)

## 免责声明

使用 iStore 增强 Docker（iStoreEnhanceDocker）项目及其相关服务，即表示您已阅读、理解并同意以下所有条款。如果您不同意本免责声明的任何部分，请勿使用该项目。

1. 本工具按“现状”提供，开发者不承诺其功能性、安全性或兼容性。用户需自行承担使用后的一切风险及后果，包括但不限于数据丢失、服务中断或设备故障。
2. 开发者不对因使用本工具导致的直接或间接损失（如网络攻击、配置错误引发的安全漏洞等）承担责任。用户需自行评估网络配置（如开放端口、非安全注册表）的风险。
3. 用户应确保使用行为符合所在地区的法律法规，禁止用于非法用途。第三方资源（如Docker镜像）的合法性由提供方负责，与本项目无关。
4. 本工具涉及的组件（如Docker注册表镜像）可能存在稳定性或兼容性问题，开发者不保证其长期可用性。建议用户定期检查镜像源状态。
5. 公开5443/5003端口可能暴露服务至公共网络。若未配置防火墙或HTTPS加密，用户需自行承担数据泄露风险。
6. 本声明可能未经通知随时更新，持续使用即视为接受修订内容。建议定期查阅最新声明。
7. 本项目版权归属 iStore 团队，如果侵权请联系开发者删除。
