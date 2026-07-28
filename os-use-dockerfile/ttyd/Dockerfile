# os-use 의 ttyd 서비스(스톡 docker:cli 이미지 + 바인드 마운트)를
# 이미지 빌드 시점에 ttyd 바이너리/기동 스크립트를 굽는 방식으로 재구현한 버전.
FROM docker:cli

COPY ttyd /usr/local/bin/ttyd
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/ttyd /usr/local/bin/start.sh

ENTRYPOINT ["/bin/sh", "/usr/local/bin/start.sh"]
