# os-use 의 nginx 서비스(스톡 이미지 + 바인드 마운트)를
# 이미지 빌드 시점에 설정/정적 파일을 굽는 방식으로 재구현한 버전.
FROM nginx:alpine

COPY default.conf /etc/nginx/conf.d/default.conf
COPY html /usr/share/nginx/html

EXPOSE 80
