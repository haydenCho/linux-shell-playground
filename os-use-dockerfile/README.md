# linux-shell-playground (Dockerfile 버전)

[os-use](../os-use) 프로젝트를 동일하게 동작하도록 하되, 스톡 이미지 + 바인드 마운트 대신
**Dockerfile 빌드**로 재구현한 버전입니다.

브라우저에서 nginx가 제공하는 OS 선택 페이지에 접속해, 각 리눅스 배포판 컨테이너의 셸을 ttyd를 통해 웹 터미널로 사용할 수 있습니다.

<br/>

## os-use 와의 차이점

| 구분 | os-use | os-use-dockerfile |
| --- | --- | --- |
| nginx 설정/정적 파일 | `volumes` 바인드 마운트 | `nginx/Dockerfile` 로 이미지에 `COPY` |
| ttyd 바이너리/기동 스크립트 | `volumes` 바인드 마운트 | `ttyd/Dockerfile` 로 이미지에 `COPY` |
| compose 서비스 정의 | `image:` | nginx/ttyd 는 `build:`, OS 컨테이너 5개는 그대로 `image:` |
| OS 컨테이너 5개 | 커스텀 파일이 없어 스톡 이미지 그대로 사용 | 동일 (Dockerfile 불필요) |

OS 컨테이너 5개는 원본과 마찬가지로 셸만 살려두는 용도라 이미지에 추가할 파일이 없으므로
Dockerfile 없이 `image:` + `command: sleep infinity` 로 그대로 둡니다.

<br/>

## 개발 환경

- **Docker / Docker Compose**: nginx, ttyd 는 각각 `Dockerfile` 로 빌드하고, OS 컨테이너 5개는 스톡 이미지를 사용합니다.
- **웹 서버**: `nginx:alpine` 기반 이미지 — 정적 OS 선택 페이지 제공 및 각 터미널로의 리버스 프록시(WebSocket 업그레이드 포함)
- **터미널 브리지**: `docker:cli` 기반 이미지 위에서 [ttyd](https://github.com/tsl0922/ttyd) 바이너리를 실행, `docker exec`로 각 OS 컨테이너의 `bash`에 연결
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
├── docker-compose.yml      # nginx / ttyd(build) + OS 컨테이너 5개(image) 정의
├── .env_exam                # 환경 변수 예시 파일
├── nginx/
│   ├── Dockerfile             # default.conf / html 을 이미지에 COPY
│   ├── default.conf           # 정적 페이지 서빙 + /term/<os> 리버스 프록시 설정
│   └── html/
│       └── index.html         # OS 선택 페이지
└── ttyd/
    ├── Dockerfile             # ttyd 바이너리 / start.sh 를 이미지에 COPY
    ├── ttyd                   # ttyd 바이너리
    └── start.sh                # 포트별 ttyd 인스턴스 5개 기동 스크립트

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

### 2. 컨테이너 빌드 및 실행

nginx / ttyd 이미지를 새로 빌드해야 하므로 `--build` 를 붙여 실행합니다.

```bash
docker compose up -d --build
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
