#!/bin/sh
# ttyd 인스턴스 5개를 포트별로 기동한다.
# 각 인스턴스는 지정된 OS 컨테이너로 docker exec 하여 bash 셸을 연결한다.
# (docker:cli 는 alpine 기반이라 bash 가 없으므로 POSIX sh 문법 사용)
set -e

# .env → compose → 컨테이너 env 로 전달된 인증 정보
USER_ID="${TTY_USER:-solcho}"
USER_PW="${TTY_PASS:-changeme}"

# "포트:OS컨테이너이름" 매핑 (nginx default.conf 와 맞춰야 함)
#  - 접속 경로 및 base-path 는 /term/<컨테이너명> 으로 통일
for MAP in \
  "7681:ubuntu2404" \
  "7682:ubuntu2604" \
  "7683:rocky89" \
  "7684:rocky93" \
  "7685:kali"
do
  PORT="${MAP%%:*}"        # ':' 앞부분  -> 포트
  CONTAINER="${MAP##*:}"   # ':' 뒷부분  -> 컨테이너명
  echo "[ttyd] :${PORT}  (/term/${CONTAINER})  ->  docker exec ${CONTAINER} bash"

  ttyd \
    --port "${PORT}" \
    --base-path "/term/${CONTAINER}" \
    --credential "${USER_ID}:${USER_PW}" \
    --writable \
    --client-option fontSize=15 \
    docker exec -it "${CONTAINER}" bash &
done

# 백그라운드로 띄운 ttyd 프로세스들이 종료될 때까지 대기
wait
