#!/bin/bash

# AppImage 파일을 더 쉽게 사용할 수 있게 해주는 스크립트

show_help() {
    echo "AppImage 헬퍼 스크립트 사용법:"
    echo "  $0 install <AppImage 파일경로> [데스크톱 이름]  - AppImage를 설치하고 데스크톱 바로가기 생성"
    echo "  $0 run <AppImage 파일경로>                     - AppImage 실행"
    echo "  $0 integrate <AppImage 파일경로>               - AppImage 통합 (바로가기/아이콘 생성)"
    echo "  $0 list                                        - 설치된 AppImage 목록 표시"
    echo "  $0 remove <AppImage 이름>                      - 설치된 AppImage 제거"
    echo
    echo "예시:"
    echo "  $0 install ~/Downloads/MyApp-1.0.AppImage MyApp"
    echo "  $0 run ~/apps/MyApp-1.0.AppImage"
}

# AppImage 디렉토리 설정
APPIMAGE_DIR="$HOME/AppImages"
mkdir -p "$APPIMAGE_DIR"
mkdir -p "$HOME/.local/share/applications"

# AppImage 설치 및 바로가기 생성
install_appimage() {
    local appimage_path="$1"
    local app_name="$2"
    
    # 파일 존재 여부 확인
    if [ ! -f "$appimage_path" ]; then
        echo "오류: $appimage_path 파일을 찾을 수 없습니다."
        return 1
    fi
    
    # AppImage 파일인지 확인
    file_type=$(file -b "$appimage_path")
    if [[ ! "$file_type" == *"executable"* ]]; then
        echo "오류: $appimage_path 파일은 실행 가능한 파일이 아닙니다."
        return 1
    fi
    
    # 앱 이름이 제공되지 않은 경우 파일 이름에서 추출
    if [ -z "$app_name" ]; then
        app_name=$(basename "$appimage_path" .AppImage)
    fi
    
    # AppImage 파일 복사
    local dest_path="$APPIMAGE_DIR/$(basename "$appimage_path")"
    cp "$appimage_path" "$dest_path"
    chmod +x "$dest_path"
    
    # 아이콘 추출 시도
    local icon_path="$HOME/.local/share/icons/$app_name.png"
    mkdir -p "$HOME/.local/share/icons"
    
    # 아이콘 추출 (AppImage의 --appimage-extract 옵션 사용)
    echo "아이콘 추출 중..."
    temp_dir=$(mktemp -d)
    
    # AppImage 내부에서 정보 추출
    "$dest_path" --appimage-extract appstream >/dev/null 2>&1
    
    # 아이콘 파일 찾기
    if [ -d "squashfs-root/appstream" ]; then
        # appstream에서 아이콘 경로 찾기
        icon_file=$(find squashfs-root/appstream -name "*.png" | head -n 1)
        
        if [ -n "$icon_file" ]; then
            cp "$icon_file" "$icon_path"
        else
            # 기본 아이콘 사용
            icon_path="application-x-executable"
        fi
        
        # 임시 디렉토리 정리
        rm -rf squashfs-root
    else
        # appstream이 없는 경우 기본 아이콘 사용
        icon_path="application-x-executable"
    fi
    
    # 데스크톱 엔트리 생성
    desktop_file="$HOME/.local/share/applications/$app_name.desktop"
    
    echo "[Desktop Entry]" > "$desktop_file"
    echo "Name=$app_name" >> "$desktop_file"
    echo "Exec=$dest_path" >> "$desktop_file"
    echo "Icon=$icon_path" >> "$desktop_file"
    echo "Type=Application" >> "$desktop_file"
    echo "Categories=Utility;" >> "$desktop_file"
    echo "Terminal=false" >> "$desktop_file"
    
    # 데스크톱 데이터베이스 업데이트
    update-desktop-database "$HOME/.local/share/applications" 2>/dev/null || true
    
    echo "$app_name이(가) $dest_path에 설치되었습니다."
    echo "데스크톱 바로가기가 생성되었습니다."
}

# AppImage 실행
run_appimage() {
    local appimage_path="$1"
    
    if [ ! -f "$appimage_path" ]; then
        echo "오류: $appimage_path 파일을 찾을 수 없습니다."
        return 1
    fi
    
    chmod +x "$appimage_path"
    "$appimage_path" &
}

# 설치된 AppImage 목록 표시
list_appimages() {
    echo "설치된 AppImage 목록:"
    echo "---------------------"
    
    if [ -z "$(ls -A "$APPIMAGE_DIR" 2>/dev/null)" ]; then
        echo "설치된 AppImage가 없습니다."
        return
    fi
    
    for appimage in "$APPIMAGE_DIR"/*.AppImage; do
        if [ -f "$appimage" ]; then
            echo "$(basename "$appimage")"
        fi
    done
}

# AppImage 제거
remove_appimage() {
    local app_name="$1"
    
    if [ -z "$app_name" ]; then
        echo "제거할 AppImage 이름을 지정하세요."
        return 1
    fi
    
    # 해당 이름으로 시작하는 AppImage 찾기
    appimage_files=$(find "$APPIMAGE_DIR" -name "$app_name*.AppImage" 2>/dev/null)
    
    if [ -z "$appimage_files" ]; then
        echo "오류: $app_name과(와) 일치하는 AppImage를 찾을 수 없습니다."
        return 1
    fi
    
    echo "다음 AppImage 파일을 제거합니다:"
    echo "$appimage_files"
    echo "계속하시겠습니까? (y/n)"
    read -r confirm
    
    if [[ "$confirm" == [Yy]* ]]; then
        rm -f $appimage_files
        rm -f "$HOME/.local/share/applications/$app_name.desktop"
        echo "$app_name이(가) 제거되었습니다."
    else
        echo "제거가 취소되었습니다."
    fi
}

# AppImage 통합 (바로가기 및 아이콘 생성)
integrate_appimage() {
    local appimage_path="$1"
    
    if [ ! -f "$appimage_path" ]; then
        echo "오류: $appimage_path 파일을 찾을 수 없습니다."
        return 1
    fi
    
    chmod +x "$appimage_path"
    "$appimage_path" --appimage-mount >/dev/null 2>&1 &
    pid=$!
    
    echo "AppImage를 시스템과 통합하는 중..."
    sleep 2
    kill $pid >/dev/null 2>&1
    
    echo "AppImage가 시스템과 통합되었습니다."
}

# 메인 로직
case "$1" in
    install)
        install_appimage "$2" "$3"
        ;;
    run)
        run_appimage "$2"
        ;;
    list)
        list_appimages
        ;;
    remove)
        remove_appimage "$2"
        ;;
    integrate)
        integrate_appimage "$2"
        ;;
    *)
        show_help
        ;;
esac