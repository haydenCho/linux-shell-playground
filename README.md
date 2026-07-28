# linux-shell-playground
여러 버전의 리눅스 쉘 사용 페이지 레포지토리입니다.

브라우저에서 nginx가 제공하는 OS 선택 페이지에 접속해, 각 리눅스 배포판 컨테이너의 셸을 ttyd를 통해 웹 터미널로 사용할 수 있습니다.

<br/>

## 개발 환경

- **Docker / Docker Compose**: 모든 서비스는 Docker Compose로 구성되며, 별도의 Dockerfile 없이 스톡 이미지와 볼륨 마운트만으로 동작합니다.
- **웹 서버**: `nginx:alpine` — 정적 OS 선택 페이지 제공 및 각 터미널로의 리버스 프록시(WebSocket 업그레이드 포함)
- **터미널 브리지**: `docker:cli` 이미지 위에서 [ttyd](https://github.com/tsl0922/ttyd) 바이너리를 실행, `docker exec`로 각 OS 컨테이너의 `bash`에 연결
- **사용 가능한 OS 컨테이너**
  - Ubuntu 24.04 (`ubuntu:24.04`)
  - Ubuntu 26.04 (`ubuntu:26.04`)
  - Rocky Linux 8.9 (`rockylinux:8.9`)
  - Rocky Linux 9.3 (`rockylinux:9.3`)
  - Kali Linux Rolling (`kalilinux/kali-rolling:latest`)

<br/>

## 디렉토리 구조

```
.
├── docker-compose.yml      # nginx / ttyd / OS 컨테이너 5개 정의
├── .env_exam                # 환경 변수 예시 파일
├── nginx/
│   ├── default.conf          # 정적 페이지 서빙 + /term/<os> 리버스 프록시 설정
│   └── html/
│       └── index.html        # OS 선택 페이지
├── ttyd/
│   ├── ttyd                  # ttyd 바이너리
│   └── start.sh               # 포트별 ttyd 인스턴스 5개 기동 스크립트
└── os/                        # OS별 참고/작업용 디렉토리 (현재 비어 있음, Dockerfile 없음)
    ├── ubuntu2404/
    ├── ubuntu2604/
    ├── rocky89/
    ├── rocky93/
    └── kali/
```

<br/>

## 실행 방법

### 1. 환경 변수 설정

`.env_exam`을 복사해 `.env` 파일을 만들고, ttyd 접속에 사용할 계정 정보를 채웁니다.

```bash
cp .env_exam .env
```

```env
TTY_USER=your_id
TTY_PASS=your_password
```

`.env`는 `.gitignore`에 포함되어 있어 git에 커밋되지 않습니다.

<br/>

### 2. 컨테이너 실행

```bash
docker compose up -d
```

`nginx`, `ttyd`, 5개의 OS 컨테이너가 모두 기동됩니다.

<br/>

### 3. 접속

브라우저에서 호스트의 `80` 포트로 접속합니다.

```
http://<호스트 IP>/
```

OS 선택 페이지에서 원하는 배포판을 클릭하면 `/term/<os이름>/` 경로로 해당 컨테이너의 웹 터미널에 연결되며, 접속 시 `.env`에 설정한 계정으로 인증합니다.

<br/>

### 4. 종료

```bash
docker compose down
```
