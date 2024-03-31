#!/bin/sh

# 定时构建命令(作者原版，先删除容器如遇拉取错误，可能会导致容器丢失）
# docker stop iptv-sources && docker rm iptv-sources && docker pull herberthe0229/iptv-sources:latest && docker run --name iptv-sources -p 3000:8080 -d herberthe0229/iptv-sources:latest

# 定义容器名称和镜像名称
container_name="iptv-sources"
image_name="herberthe0229/iptv-sources:latest"

# 检查是否有新的镜像可用
docker pull $image_name > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "发现新的镜像，停止原容器并创建新容器..."
    # 停止原容器
    docker stop $container_name > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "原容器已停止"
    else
        echo "停止原容器失败"
        exit 1
    fi

    # 删除原容器
    docker rm $container_name > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "原容器已删除"
    else
        echo "删除原容器失败"
        exit 1
    fi

    # 创建新容器
    docker run -d -p 3000:8080 --name $container_name $image_name
    if [ $? -eq 0 ]; then
        echo "新容器已创建"
    else
        echo "创建新容器失败"
        exit 1
    fi
else
    echo "没有发现新的镜像"
fi



# 获取历史版本
UNUSED_IMAGES=$(docker images -q herberthe0229/iptv-sources --filter "dangling=true")

# 删除历史版本
if [ -n "$UNUSED_IMAGES" ];
then
docker rmi $UNUSED_IMAGES
fi
