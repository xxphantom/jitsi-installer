#!/bin/bash

# ===================================================================================
#                           JITSI MEET DOCKER INSTALLER
#                              by uphantom
# ===================================================================================

LANG_CODE="${LANG_CODE:-ru}"
while [[ $# -gt 0 ]]; do
    case $1 in
        --lang=*)
            LANG_CODE="${1#*=}"
            shift
            ;;
        --lang)
            LANG_CODE="$2"
            shift 2
            ;;
        *)
            shift
            ;;
    esac
done

# ===================================================================================
#                                    CONSTANTS
# ===================================================================================

VERSION="1.2.0"
JITSI_DIR="/opt/jitsi"
JITSI_CONFIG_DIR="/opt/jitsi/.jitsi-meet-cfg"

BOLD_BLUE=$(tput setaf 4)
BOLD_GREEN=$(tput setaf 2)
BOLD_YELLOW=$(tput setaf 11)
LIGHT_GREEN=$(tput setaf 10)
BOLD_BLUE_MENU=$(tput setaf 6)
ORANGE=$(tput setaf 3)
BOLD_RED=$(tput setaf 1)
BLUE=$(tput setaf 6)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
NC=$(tput sgr0)

# ===================================================================================
#                              INTERNATIONALIZATION
# ===================================================================================

declare -A TRANSLATIONS_EN
declare -A TRANSLATIONS_RU

TRANSLATIONS_EN[error_root_required]="Error: This script must be run as root (sudo)"
TRANSLATIONS_EN[error_invalid_choice]="Invalid choice, please try again."
TRANSLATIONS_EN[error_enter_yn]="Please enter 'y' or 'n'."

TRANSLATIONS_EN[main_menu_title]="Jitsi Meet Docker Installer v"
TRANSLATIONS_EN[main_menu_install]="Install Jitsi Meet"
TRANSLATIONS_EN[main_menu_uninstall]="Uninstall Jitsi Meet"
TRANSLATIONS_EN[main_menu_restart]="Restart Jitsi Meet"
TRANSLATIONS_EN[main_menu_view_logs]="View logs"
TRANSLATIONS_EN[main_menu_manage_users]="Manage users"
TRANSLATIONS_EN[main_menu_show_info]="Show credentials"
TRANSLATIONS_EN[main_menu_exit]="Exit"
TRANSLATIONS_EN[main_menu_select_option]="Select option:"

TRANSLATIONS_EN[users_menu_title]="User Management"
TRANSLATIONS_EN[users_menu_create]="Create user"
TRANSLATIONS_EN[users_menu_delete]="Delete user"
TRANSLATIONS_EN[users_menu_list]="List users"
TRANSLATIONS_EN[users_menu_change_password]="Change password"
TRANSLATIONS_EN[users_menu_back]="Back to main menu"

TRANSLATIONS_EN[prompt_yes_no_suffix]=" (y/n): "
TRANSLATIONS_EN[prompt_enter_to_continue]="Press Enter to continue..."
TRANSLATIONS_EN[prompt_enter_to_return]="Press Enter to return to menu..."

TRANSLATIONS_EN[install_domain_prompt]="Enter your domain (e.g., meet.example.com)"
TRANSLATIONS_EN[install_timezone_prompt]="Enter timezone (default: Europe/Moscow)"
TRANSLATIONS_EN[install_enable_auth]="Enable authentication (recommended)?"
TRANSLATIONS_EN[install_enable_guests]="Allow guests to join after host?"
TRANSLATIONS_EN[install_admin_username]="Enter admin username"
TRANSLATIONS_EN[install_admin_password]="Enter admin password"
TRANSLATIONS_EN[install_confirm_password]="Confirm password"

TRANSLATIONS_EN[install_downloading]="Downloading Jitsi Meet..."
TRANSLATIONS_EN[install_extracting]="Extracting files..."
TRANSLATIONS_EN[install_generating_passwords]="Generating component passwords..."
TRANSLATIONS_EN[install_creating_config]="Creating configuration..."
TRANSLATIONS_EN[install_creating_dirs]="Creating directories..."
TRANSLATIONS_EN[install_starting]="Starting Jitsi Meet..."
TRANSLATIONS_EN[install_creating_admin]="Creating admin user..."
TRANSLATIONS_EN[install_waiting_cert]="Waiting for SSL certificate..."
TRANSLATIONS_EN[install_success]="Jitsi Meet installed successfully!"
TRANSLATIONS_EN[install_access_url]="Access URL:"
TRANSLATIONS_EN[install_admin_credentials]="Admin credentials:"
TRANSLATIONS_EN[install_generating_admin]="Generating admin credentials..."
TRANSLATIONS_EN[install_admin_generated]="Admin credentials generated"
TRANSLATIONS_EN[install_deps_done]="Dependencies installed"
TRANSLATIONS_EN[install_downloaded]="Downloaded"
TRANSLATIONS_EN[install_passwords_generated]="Passwords generated"
TRANSLATIONS_EN[install_config_created]="Configuration created"
TRANSLATIONS_EN[install_dirs_created]="Directories created"
TRANSLATIONS_EN[install_waiting_prosody]="Waiting for Prosody..."
TRANSLATIONS_EN[install_applying_config]="Applying configuration..."
TRANSLATIONS_EN[install_jitsi_started]="Jitsi Meet started"
TRANSLATIONS_EN[install_admin_created]="Admin user created"
TRANSLATIONS_EN[install_title]="Jitsi Meet Installation"
TRANSLATIONS_EN[install_creds_saved]="Credentials saved to:"
TRANSLATIONS_EN[install_email_prompt]="Email for Let's Encrypt SSL certificate"

TRANSLATIONS_EN[error_start_failed]="Failed to start containers"
TRANSLATIONS_EN[error_docker_install]="Failed to install Docker"

TRANSLATIONS_EN[uninstall_confirm]="Are you sure you want to uninstall Jitsi Meet? ALL DATA WILL BE LOST!"
TRANSLATIONS_EN[uninstall_stopping]="Stopping containers..."
TRANSLATIONS_EN[uninstall_removing]="Removing files..."
TRANSLATIONS_EN[uninstall_success]="Jitsi Meet uninstalled successfully."
TRANSLATIONS_EN[uninstall_cancelled]="Uninstallation cancelled."

TRANSLATIONS_EN[restart_success]="Jitsi Meet restarted successfully."
TRANSLATIONS_EN[restart_stopping]="Stopping containers..."
TRANSLATIONS_EN[restart_starting]="Starting containers..."

TRANSLATIONS_EN[logs_viewing]="Viewing logs (Ctrl+C to exit)..."
TRANSLATIONS_EN[logs_select]="Select component:"
TRANSLATIONS_EN[logs_all]="All containers"
TRANSLATIONS_EN[logs_web]="Web (nginx)"
TRANSLATIONS_EN[logs_prosody]="Prosody (XMPP)"
TRANSLATIONS_EN[logs_jicofo]="Jicofo"
TRANSLATIONS_EN[logs_jvb]="JVB (Video Bridge)"

TRANSLATIONS_EN[users_enter_username]="Enter username:"
TRANSLATIONS_EN[users_enter_password]="Enter password:"
TRANSLATIONS_EN[users_created]="User created successfully."
TRANSLATIONS_EN[users_deleted]="User deleted successfully."
TRANSLATIONS_EN[users_password_changed]="Password changed successfully."
TRANSLATIONS_EN[users_list_title]="Registered users:"
TRANSLATIONS_EN[users_no_users]="No users found."
TRANSLATIONS_EN[users_confirm_delete]="Are you sure you want to delete user"

TRANSLATIONS_EN[error_not_installed]="Jitsi Meet is not installed."
TRANSLATIONS_EN[error_already_installed]="Jitsi Meet is already installed."
TRANSLATIONS_EN[error_download_failed]="Failed to download Jitsi Meet."
TRANSLATIONS_EN[error_extract_failed]="Failed to extract archive."
TRANSLATIONS_EN[error_passwords_no_match]="Passwords do not match. Please try again."
TRANSLATIONS_EN[error_containers_not_running]="Containers are not running."
TRANSLATIONS_EN[error_prosody_not_ready]="Prosody failed to start."
TRANSLATIONS_EN[error_admin_creation_failed]="Failed to create admin user."
TRANSLATIONS_EN[error_cert_timeout]="Certificate not ready, check logs."

TRANSLATIONS_EN[info_title]="Jitsi Meet Connection Info"
TRANSLATIONS_EN[info_url]="URL:"
TRANSLATIONS_EN[info_status]="Status:"
TRANSLATIONS_EN[info_running]="Running"
TRANSLATIONS_EN[info_stopped]="Stopped"

TRANSLATIONS_EN[spinner_installing_deps]="Installing dependencies..."
TRANSLATIONS_EN[spinner_updating_apt]="Updating package cache..."
TRANSLATIONS_EN[spinner_configuring_firewall]="Configuring firewall..."

TRANSLATIONS_EN[firewall_opening_ports]="Opening required ports..."
TRANSLATIONS_EN[firewall_ports_opened]="Ports opened: 80/tcp, 443/tcp, 10000/udp"

TRANSLATIONS_EN[deps_docker_installed]="Docker is already installed."
TRANSLATIONS_EN[deps_installing_docker]="Installing Docker..."
TRANSLATIONS_EN[deps_docker_success]="Docker installed successfully."

TRANSLATIONS_EN[network_invalid_domain]="Invalid domain format."
TRANSLATIONS_EN[network_invalid_email]="Invalid email format."

TRANSLATIONS_EN[cleanup_failed]="Installation failed, cleaning up..."

TRANSLATIONS_RU[error_root_required]="Ошибка: Этот скрипт должен быть запущен от имени root (sudo)"
TRANSLATIONS_RU[error_invalid_choice]="Неверный выбор, попробуйте снова."
TRANSLATIONS_RU[error_enter_yn]="Пожалуйста, введите 'y' или 'n'."

TRANSLATIONS_RU[main_menu_title]="Jitsi Meet Docker Installer v"
TRANSLATIONS_RU[main_menu_install]="Установить Jitsi Meet"
TRANSLATIONS_RU[main_menu_uninstall]="Удалить Jitsi Meet"
TRANSLATIONS_RU[main_menu_restart]="Перезапустить Jitsi Meet"
TRANSLATIONS_RU[main_menu_view_logs]="Просмотр логов"
TRANSLATIONS_RU[main_menu_manage_users]="Управление пользователями"
TRANSLATIONS_RU[main_menu_show_info]="Показать учётные данные"
TRANSLATIONS_RU[main_menu_exit]="Выход"
TRANSLATIONS_RU[main_menu_select_option]="Выберите опцию:"

TRANSLATIONS_RU[users_menu_title]="Управление пользователями"
TRANSLATIONS_RU[users_menu_create]="Создать пользователя"
TRANSLATIONS_RU[users_menu_delete]="Удалить пользователя"
TRANSLATIONS_RU[users_menu_list]="Список пользователей"
TRANSLATIONS_RU[users_menu_change_password]="Изменить пароль"
TRANSLATIONS_RU[users_menu_back]="Вернуться в главное меню"

TRANSLATIONS_RU[prompt_yes_no_suffix]=" (y/n): "
TRANSLATIONS_RU[prompt_enter_to_continue]="Нажмите Enter для продолжения..."
TRANSLATIONS_RU[prompt_enter_to_return]="Нажмите Enter для возврата в меню..."

TRANSLATIONS_RU[install_domain_prompt]="Введите ваш домен (например, meet.example.com)"
TRANSLATIONS_RU[install_timezone_prompt]="Введите часовой пояс (по умолчанию: Europe/Moscow)"
TRANSLATIONS_RU[install_enable_auth]="Включить аутентификацию (рекомендуется)?"
TRANSLATIONS_RU[install_enable_guests]="Разрешить гостям присоединяться после хоста?"
TRANSLATIONS_RU[install_admin_username]="Введите имя администратора"
TRANSLATIONS_RU[install_admin_password]="Введите пароль администратора"
TRANSLATIONS_RU[install_confirm_password]="Подтвердите пароль"

TRANSLATIONS_RU[install_downloading]="Загрузка Jitsi Meet..."
TRANSLATIONS_RU[install_extracting]="Распаковка файлов..."
TRANSLATIONS_RU[install_generating_passwords]="Генерация паролей компонентов..."
TRANSLATIONS_RU[install_creating_config]="Создание конфигурации..."
TRANSLATIONS_RU[install_creating_dirs]="Создание директорий..."
TRANSLATIONS_RU[install_starting]="Запуск Jitsi Meet..."
TRANSLATIONS_RU[install_creating_admin]="Создание администратора..."
TRANSLATIONS_RU[install_waiting_cert]="Ожидание SSL сертификата..."
TRANSLATIONS_RU[install_success]="Jitsi Meet успешно установлен!"
TRANSLATIONS_RU[install_access_url]="URL для доступа:"
TRANSLATIONS_RU[install_admin_credentials]="Учётные данные администратора:"
TRANSLATIONS_RU[install_generating_admin]="Генерация учётных данных администратора..."
TRANSLATIONS_RU[install_admin_generated]="Учётные данные администратора сгенерированы"
TRANSLATIONS_RU[install_deps_done]="Зависимости установлены"
TRANSLATIONS_RU[install_downloaded]="Загружено"
TRANSLATIONS_RU[install_passwords_generated]="Пароли сгенерированы"
TRANSLATIONS_RU[install_config_created]="Конфигурация создана"
TRANSLATIONS_RU[install_dirs_created]="Директории созданы"
TRANSLATIONS_RU[install_waiting_prosody]="Ожидание Prosody..."
TRANSLATIONS_RU[install_applying_config]="Применение конфигурации..."
TRANSLATIONS_RU[install_jitsi_started]="Jitsi Meet запущен"
TRANSLATIONS_RU[install_admin_created]="Администратор создан"
TRANSLATIONS_RU[install_title]="Установка Jitsi Meet"
TRANSLATIONS_RU[install_creds_saved]="Учётные данные сохранены в:"
TRANSLATIONS_RU[install_email_prompt]="Email для SSL-сертификата Let's Encrypt"

TRANSLATIONS_RU[error_start_failed]="Не удалось запустить контейнеры"
TRANSLATIONS_RU[error_docker_install]="Не удалось установить Docker"

TRANSLATIONS_RU[uninstall_confirm]="Вы уверены, что хотите удалить Jitsi Meet? ВСЕ ДАННЫЕ БУДУТ ПОТЕРЯНЫ!"
TRANSLATIONS_RU[uninstall_stopping]="Остановка контейнеров..."
TRANSLATIONS_RU[uninstall_removing]="Удаление файлов..."
TRANSLATIONS_RU[uninstall_success]="Jitsi Meet успешно удалён."
TRANSLATIONS_RU[uninstall_cancelled]="Удаление отменено."

TRANSLATIONS_RU[restart_success]="Jitsi Meet успешно перезапущен."
TRANSLATIONS_RU[restart_stopping]="Остановка контейнеров..."
TRANSLATIONS_RU[restart_starting]="Запуск контейнеров..."

TRANSLATIONS_RU[logs_viewing]="Просмотр логов (Ctrl+C для выхода)..."
TRANSLATIONS_RU[logs_select]="Выберите компонент:"
TRANSLATIONS_RU[logs_all]="Все контейнеры"
TRANSLATIONS_RU[logs_web]="Web (nginx)"
TRANSLATIONS_RU[logs_prosody]="Prosody (XMPP)"
TRANSLATIONS_RU[logs_jicofo]="Jicofo"
TRANSLATIONS_RU[logs_jvb]="JVB (Video Bridge)"

TRANSLATIONS_RU[users_enter_username]="Введите имя пользователя:"
TRANSLATIONS_RU[users_enter_password]="Введите пароль:"
TRANSLATIONS_RU[users_created]="Пользователь успешно создан."
TRANSLATIONS_RU[users_deleted]="Пользователь успешно удалён."
TRANSLATIONS_RU[users_password_changed]="Пароль успешно изменён."
TRANSLATIONS_RU[users_list_title]="Зарегистрированные пользователи:"
TRANSLATIONS_RU[users_no_users]="Пользователи не найдены."
TRANSLATIONS_RU[users_confirm_delete]="Вы уверены, что хотите удалить пользователя"

TRANSLATIONS_RU[error_not_installed]="Jitsi Meet не установлен."
TRANSLATIONS_RU[error_already_installed]="Jitsi Meet уже установлен."
TRANSLATIONS_RU[error_download_failed]="Не удалось загрузить Jitsi Meet."
TRANSLATIONS_RU[error_extract_failed]="Не удалось распаковать архив."
TRANSLATIONS_RU[error_passwords_no_match]="Пароли не совпадают. Попробуйте снова."
TRANSLATIONS_RU[error_containers_not_running]="Контейнеры не запущены."
TRANSLATIONS_RU[error_prosody_not_ready]="Prosody не запустился."
TRANSLATIONS_RU[error_admin_creation_failed]="Не удалось создать администратора."
TRANSLATIONS_RU[error_cert_timeout]="Сертификат не готов, проверьте логи."

TRANSLATIONS_RU[info_title]="Информация о подключении Jitsi Meet"
TRANSLATIONS_RU[info_url]="URL:"
TRANSLATIONS_RU[info_status]="Статус:"
TRANSLATIONS_RU[info_running]="Работает"
TRANSLATIONS_RU[info_stopped]="Остановлен"

TRANSLATIONS_RU[spinner_installing_deps]="Установка зависимостей..."
TRANSLATIONS_RU[spinner_updating_apt]="Обновление кэша пакетов..."
TRANSLATIONS_RU[spinner_configuring_firewall]="Настройка брандмауэра..."

TRANSLATIONS_RU[firewall_opening_ports]="Открытие необходимых портов..."
TRANSLATIONS_RU[firewall_ports_opened]="Открыты порты: 80/tcp, 443/tcp, 10000/udp"

TRANSLATIONS_RU[deps_docker_installed]="Docker уже установлен."
TRANSLATIONS_RU[deps_installing_docker]="Установка Docker..."
TRANSLATIONS_RU[deps_docker_success]="Docker успешно установлен."

TRANSLATIONS_RU[network_invalid_domain]="Неверный формат домена."
TRANSLATIONS_RU[network_invalid_email]="Неверный формат email."

TRANSLATIONS_RU[cleanup_failed]="Установка не удалась, очистка..."

t() {
    local key="$1"
    local value=""

    case "$LANG_CODE" in
        "ru")
            value="${TRANSLATIONS_RU[$key]:-}"
            ;;
        "en"|*)
            value="${TRANSLATIONS_EN[$key]:-}"
            ;;
    esac

    if [ -n "$value" ]; then
        echo "$value"
    else
        echo "[$key]"
    fi
}

# ===================================================================================
#                            CREDENTIAL GENERATION FUNCTIONS
# ===================================================================================

generate_secure_password() {
    local length="${1:-16}"
    local password=""
    local special_chars='!%^&*_+.,'
    local uppercase_chars='ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    local lowercase_chars='abcdefghijklmnopqrstuvwxyz'
    local number_chars='0123456789'
    local alphanumeric_chars="${uppercase_chars}${lowercase_chars}${number_chars}"

    if command -v openssl &>/dev/null; then
        password="$(openssl rand -base64 48 | tr -dc "$alphanumeric_chars" | head -c "$length")"
    else
        password="$(head -c 100 /dev/urandom | tr -dc "$alphanumeric_chars" | head -c "$length")"
    fi

    if ! [[ "$password" =~ [$uppercase_chars] ]]; then
        local position=$((RANDOM % length))
        local one_uppercase="$(echo "$uppercase_chars" | fold -w1 | shuf | head -n1)"
        password="${password:0:$position}${one_uppercase}${password:$((position + 1))}"
    fi

    if ! [[ "$password" =~ [$lowercase_chars] ]]; then
        local position=$((RANDOM % length))
        local one_lowercase="$(echo "$lowercase_chars" | fold -w1 | shuf | head -n1)"
        password="${password:0:$position}${one_lowercase}${password:$((position + 1))}"
    fi

    if ! [[ "$password" =~ [$number_chars] ]]; then
        local position=$((RANDOM % length))
        local one_number="$(echo "$number_chars" | fold -w1 | shuf | head -n1)"
        password="${password:0:$position}${one_number}${password:$((position + 1))}"
    fi

    local special_count=$((length / 4))
    special_count=$((special_count > 0 ? special_count : 1))
    special_count=$((special_count < 3 ? special_count : 3))

    for ((i = 0; i < special_count; i++)); do
        local position=$((RANDOM % (length - 2) + 1))
        local one_special="$(echo "$special_chars" | fold -w1 | shuf | head -n1)"
        password="${password:0:$position}${one_special}${password:$((position + 1))}"
    done

    echo "$password"
}

generate_readable_login() {
    local length="${1:-8}"
    local consonants=('b' 'c' 'd' 'f' 'g' 'h' 'j' 'k' 'l' 'm' 'n' 'p' 'r' 's' 't' 'v' 'w' 'x' 'z')
    local vowels=('a' 'e' 'i' 'o' 'u' 'y')
    local login=""
    local type="consonant"

    while [ ${#login} -lt $length ]; do
        if [ "$type" = "consonant" ]; then
            login+=${consonants[$RANDOM % ${#consonants[@]}]}
            type="vowel"
        else
            login+=${vowels[$RANDOM % ${#vowels[@]}]}
            type="consonant"
        fi
    done

    local add_number=$((RANDOM % 2))
    if [ $add_number -eq 1 ]; then
        login+=$((RANDOM % 100))
    fi

    echo "$login"
}

# ===================================================================================
#                                 DISPLAY FUNCTIONS
# ===================================================================================

show_success() {
    local message="$1"
    echo -e "${BOLD_GREEN}✓ ${message}${NC}"
}

show_error() {
    local message="$1"
    echo -e "${BOLD_RED}✗ ${message}${NC}" >&2
}

show_warning() {
    local message="$1"
    echo -e "${BOLD_YELLOW}⚠ ${message}${NC}"
}

show_info() {
    local message="$1"
    local color="${2:-$ORANGE}"
    echo -e "${color}${message}${NC}"
}

spinner() {
    local pid=$1
    local text=$2
    local spinstr='⣷⣯⣟⡿⢿⣻⣽⣾'
    local delay=0.12

    printf "${BOLD_GREEN}%s${NC}" "$text" >/dev/tty

    while kill -0 "$pid" 2>/dev/null; do
        for ((i = 0; i < ${#spinstr}; i++)); do
            printf "\r${BOLD_GREEN}[%s] %s${NC}" "${spinstr:$i:1}" "$text" >/dev/tty
            sleep $delay
        done
    done

    wait "$pid"
    local exit_code=$?

    printf "\r\033[K" >/dev/tty

    return $exit_code
}

# ===================================================================================
#                                  INPUT FUNCTIONS
# ===================================================================================

prompt_input() {
    local prompt_text="$1"
    local default_value="$2"

    if [ -n "$default_value" ]; then
        echo -ne "${ORANGE}${prompt_text} [${default_value}]: ${NC}" >&2
    else
        echo -ne "${ORANGE}${prompt_text}: ${NC}" >&2
    fi

    read input_value

    if [ -z "$input_value" ] && [ -n "$default_value" ]; then
        input_value="$default_value"
    fi

    echo "$input_value"
}

prompt_password() {
    local prompt_text="$1"

    echo -ne "${ORANGE}${prompt_text}: ${NC}" >&2
    stty -echo
    read password_value
    stty echo
    echo >&2

    echo "$password_value"
}

prompt_yes_no() {
    local prompt_text="$1"
    local default="${2:-}"

    while true; do
        echo -ne "${ORANGE}${prompt_text}$(t prompt_yes_no_suffix)${NC}" >&2
        read answer

        answer=$(echo "$answer" | tr '[:upper:]' '[:lower:]')
        [ -z "$answer" ] && answer="$default"

        if [ "$answer" = "y" ] || [ "$answer" = "yes" ]; then
            return 0
        elif [ "$answer" = "n" ] || [ "$answer" = "no" ]; then
            return 1
        else
            echo -e "${BOLD_RED}$(t error_enter_yn)${NC}" >&2
        fi
    done
}

# ===================================================================================
#                               VALIDATION FUNCTIONS
# ===================================================================================

validate_domain() {
    local domain="$1"

    if [[ "$domain" =~ ^[a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?(\.[a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?)+$ ]]; then
        return 0
    fi
    return 1
}

validate_email() {
    local email="$1"

    if [[ "$email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
        return 0
    fi
    return 1
}

# ===================================================================================
#                                SYSTEM FUNCTIONS
# ===================================================================================

check_jitsi_installed() {
    [ -d "$JITSI_DIR" ] && [ -f "$JITSI_DIR/docker-compose.yml" ]
}

check_containers_running() {
    if ! check_jitsi_installed; then
        return 1
    fi

    cd "$JITSI_DIR"
    docker compose ps -q 2>/dev/null | grep -q .
}

set_env_var() {
    local key="$1"
    local value="$2"
    local file="$3"

    sed -i "/^#\?${key}=/d" "$file"
    echo "${key}=${value}" >> "$file"
}

cleanup_failed_install() {
    show_warning "$(t cleanup_failed)"
    cd /
    rm -rf "$JITSI_DIR" "$JITSI_CONFIG_DIR" 2>/dev/null
}

install_dependencies() {
    show_info "$(t spinner_installing_deps)" "$BOLD_GREEN"

    (apt-get update -qq) &
    if ! spinner $! "$(t spinner_updating_apt)"; then
        show_error "Failed to update apt cache"
        return 1
    fi

    local packages=(ca-certificates curl gnupg unzip wget ufw)
    local missing=()

    for pkg in "${packages[@]}"; do
        if ! dpkg -s "$pkg" &>/dev/null; then
            missing+=("$pkg")
        fi
    done

    if [ ${#missing[@]} -gt 0 ]; then
        (DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends "${missing[@]}" >/dev/null 2>&1) &
        if ! spinner $! "Installing: ${missing[*]}"; then
            show_error "Failed to install packages"
            return 1
        fi
    fi

    if ! command -v docker &>/dev/null; then
        show_info "$(t deps_installing_docker)"

        install -m 0755 -d /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
        chmod a+r /etc/apt/keyrings/docker.gpg

        echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

        (apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin >/dev/null 2>&1) &
        if ! spinner $! "$(t deps_installing_docker)"; then
            show_error "$(t error_docker_install)"
            return 1
        fi

        systemctl enable --now docker >/dev/null 2>&1
        show_success "$(t deps_docker_success)"
    else
        show_info "$(t deps_docker_installed)"
    fi

    if command -v ufw &>/dev/null; then
        show_info "$(t firewall_opening_ports)"
        ufw allow 80/tcp >/dev/null 2>&1
        ufw allow 443/tcp >/dev/null 2>&1
        ufw allow 10000/udp >/dev/null 2>&1
        show_success "$(t firewall_ports_opened)"
    fi

    echo
    show_success "$(t install_deps_done)"
    echo
}

# ===================================================================================
#                              INSTALLATION FUNCTIONS
# ===================================================================================

collect_install_config() {
    echo

    while true; do
        JITSI_DOMAIN=$(prompt_input "$(t install_domain_prompt)")
        if validate_domain "$JITSI_DOMAIN"; then
            break
        fi
        show_error "$(t network_invalid_domain)"
    done

    while true; do
        JITSI_EMAIL=$(prompt_input "$(t install_email_prompt)")
        if [ -z "$JITSI_EMAIL" ]; then
            show_error "$(t network_invalid_email)"
            continue
        fi
        if validate_email "$JITSI_EMAIL"; then
            break
        fi
        show_error "$(t network_invalid_email)"
    done

    JITSI_TIMEZONE=$(prompt_input "$(t install_timezone_prompt)" "Europe/Moscow")

    if prompt_yes_no "$(t install_enable_auth)" "y"; then
        ENABLE_AUTH=1

        if prompt_yes_no "$(t install_enable_guests)" "y"; then
            ENABLE_GUESTS=1
        else
            ENABLE_GUESTS=0
        fi

        show_info "$(t install_generating_admin)"
        ADMIN_USERNAME=$(generate_readable_login 8)
        ADMIN_PASSWORD=$(generate_secure_password 16)
        show_success "$(t install_admin_generated)"
    else
        ENABLE_AUTH=0
        ENABLE_GUESTS=1
    fi

    echo
}

download_jitsi() {
    show_info "$(t install_downloading)"

    mkdir -p "$JITSI_DIR"
    cd "$JITSI_DIR" || { show_error "Cannot cd to $JITSI_DIR"; return 1; }

    local release_url
    release_url=$(wget -q -O - https://api.github.com/repos/jitsi/docker-jitsi-meet/releases/latest | grep -o '"zipball_url": *"[^"]*"' | cut -d'"' -f4)

    if [ -z "$release_url" ]; then
        show_error "$(t error_download_failed)"
        return 1
    fi

    (wget -q "$release_url" -O jitsi-release.zip) &
    if ! spinner $! "$(t install_downloading)"; then
        show_error "$(t error_download_failed)"
        return 1
    fi

    if [ ! -f jitsi-release.zip ]; then
        show_error "$(t error_download_failed)"
        return 1
    fi

    show_info "$(t install_extracting)"
    if ! unzip -q jitsi-release.zip; then
        show_error "$(t error_extract_failed)"
        return 1
    fi

    local extracted_dir
    extracted_dir=$(find . -maxdepth 1 -type d -name "jitsi-docker-jitsi-meet-*" | head -1)

    if [ -z "$extracted_dir" ]; then
        show_error "$(t error_extract_failed)"
        return 1
    fi

    mv "$extracted_dir"/* . || return 1
    rm -rf "$extracted_dir" jitsi-release.zip

    show_success "$(t install_downloaded)"
    echo
}

generate_jitsi_passwords() {
    show_info "$(t install_generating_passwords)"

    cd "$JITSI_DIR"

    cp env.example .env

    if [ -f ./gen-passwords.sh ]; then
        chmod +x ./gen-passwords.sh
        ./gen-passwords.sh >/dev/null 2>&1
    fi

    show_success "$(t install_passwords_generated)"
    echo
}

create_jitsi_config() {
    show_info "$(t install_creating_config)"

    cd "$JITSI_DIR"

    set_env_var "CONFIG" "$JITSI_CONFIG_DIR" ".env"

    set_env_var "HTTP_PORT" "80" ".env"
    set_env_var "HTTPS_PORT" "443" ".env"
    set_env_var "ENABLE_HTTP_REDIRECT" "1" ".env"

    set_env_var "TZ" "$JITSI_TIMEZONE" ".env"

    set_env_var "PUBLIC_URL" "https://$JITSI_DOMAIN" ".env"

    set_env_var "ENABLE_LETSENCRYPT" "1" ".env"
    set_env_var "LETSENCRYPT_DOMAIN" "$JITSI_DOMAIN" ".env"
    if [ -n "$JITSI_EMAIL" ]; then
        set_env_var "LETSENCRYPT_EMAIL" "$JITSI_EMAIL" ".env"
    fi
    set_env_var "LETSENCRYPT_ACME_SERVER" "letsencrypt" ".env"

    if [ "$ENABLE_AUTH" = "1" ]; then
        set_env_var "ENABLE_AUTH" "1" ".env"
        set_env_var "AUTH_TYPE" "internal" ".env"
    fi

    if [ "$ENABLE_GUESTS" = "1" ]; then
        set_env_var "ENABLE_GUESTS" "1" ".env"
    fi

    set_env_var "RESTART_POLICY" "unless-stopped" ".env"

    show_success "$(t install_config_created)"
    echo
}

create_jitsi_directories() {
    show_info "$(t install_creating_dirs)"

    mkdir -p "$JITSI_CONFIG_DIR"/{web,transcripts,prosody/config,prosody/prosody-plugins-custom,jicofo,jvb,jigasi,jibri}

    show_success "$(t install_dirs_created)"
    echo
}

wait_for_certificate() {
    local domain="$1"
    local max_attempts=60
    local attempt=0

    show_info "$(t install_waiting_cert)"

    while [ $attempt -lt $max_attempts ]; do
        if [ -f "$JITSI_CONFIG_DIR/web/keys/cert.crt" ]; then
            return 0
        fi

        if curl -sf --max-time 5 "https://$domain" -o /dev/null 2>/dev/null; then
            return 0
        fi

        sleep 5
        ((attempt++))
    done

    show_warning "$(t error_cert_timeout)"
    return 1
}

start_jitsi() {
    show_info "$(t install_starting)"

    cd "$JITSI_DIR"

    (docker compose up -d >/dev/null 2>&1) &
    if ! spinner $! "$(t install_starting)"; then
        show_error "$(t error_start_failed)"
        return 1
    fi

    wait_for_certificate "$JITSI_DOMAIN"

    show_success "$(t install_jitsi_started)"
    echo
}

create_admin_user() {
    if [ "$ENABLE_AUTH" != "1" ] || [ -z "$ADMIN_USERNAME" ]; then
        return 0
    fi

    show_info "$(t install_creating_admin)"

    cd "$JITSI_DIR"

    local max_attempts=45
    local attempt=0

    show_info "$(t install_waiting_prosody)"

    while [ $attempt -lt $max_attempts ]; do
        if docker compose exec -T prosody prosodyctl --config /config/prosody.cfg.lua about >/dev/null 2>&1; then
            sleep 3
            break
        fi
        sleep 2
        ((attempt++))
    done

    if [ $attempt -eq $max_attempts ]; then
        show_error "$(t error_prosody_not_ready)"
        return 1
    fi

    if ! docker compose exec -T prosody prosodyctl --config /config/prosody.cfg.lua \
        register "$ADMIN_USERNAME" meet.jitsi "$ADMIN_PASSWORD" >/dev/null 2>&1; then
        show_error "$(t error_admin_creation_failed)"
        return 1
    fi

    (docker compose restart >/dev/null 2>&1) &
    spinner $! "$(t install_applying_config)"

    show_success "$(t install_admin_created)"
    echo
}

install_jitsi() {
    if check_jitsi_installed; then
        show_error "$(t error_already_installed)"
        echo -e "${BOLD_YELLOW}$(t prompt_enter_to_return)${NC}"
        read -r
        return 1
    fi

    clear
    echo -e "${BOLD_GREEN}$(t install_title)${NC}"
    echo

    collect_install_config
    install_dependencies || { cleanup_failed_install; return 1; }

    if ! download_jitsi; then
        cleanup_failed_install
        return 1
    fi

    generate_jitsi_passwords
    create_jitsi_config
    create_jitsi_directories

    if ! start_jitsi; then
        cleanup_failed_install
        return 1
    fi

    create_admin_user

    display_install_results
}

display_install_results() {
    local url="https://$JITSI_DOMAIN"

    echo
    echo -e "${BOLD_GREEN}════════════════════════════════════════════════════════${NC}"
    echo -e "${BOLD_GREEN}         $(t install_success)${NC}"
    echo -e "${BOLD_GREEN}════════════════════════════════════════════════════════${NC}"
    echo
    echo -e "${BOLD_GREEN}$(t install_access_url)${NC}"
    echo -e "  ${BLUE}$url${NC}"
    echo

    if [ "$ENABLE_AUTH" = "1" ] && [ -n "$ADMIN_USERNAME" ]; then
        echo -e "${BOLD_GREEN}$(t install_admin_credentials)${NC}"
        echo -e "  Username: ${YELLOW}$ADMIN_USERNAME${NC}"
        echo -e "  Password: ${YELLOW}$ADMIN_PASSWORD${NC}"
        echo
    fi

    echo -e "${BOLD_GREEN}════════════════════════════════════════════════════════${NC}"
    echo

    cat > "$JITSI_DIR/credentials.txt" << EOF
Jitsi Meet Installation
========================

URL: https://$JITSI_DOMAIN
Domain: $JITSI_DOMAIN
EOF

    if [ -n "$JITSI_EMAIL" ]; then
        echo "Email: $JITSI_EMAIL" >> "$JITSI_DIR/credentials.txt"
    fi
    echo "" >> "$JITSI_DIR/credentials.txt"

    if [ "$ENABLE_AUTH" = "1" ] && [ -n "$ADMIN_USERNAME" ]; then
        cat >> "$JITSI_DIR/credentials.txt" << EOF
Admin Credentials:
Username: $ADMIN_USERNAME
Password: $ADMIN_PASSWORD
EOF
    fi

    chmod 600 "$JITSI_DIR/credentials.txt"
    echo -e "${ORANGE}$(t install_creds_saved) $JITSI_DIR/credentials.txt${NC}"
    echo

    echo -e "${BOLD_YELLOW}$(t prompt_enter_to_return)${NC}"
    read -r
}

# ===================================================================================
#                              UNINSTALL FUNCTIONS
# ===================================================================================

uninstall_jitsi() {
    if ! check_jitsi_installed; then
        show_error "$(t error_not_installed)"
        echo -e "${BOLD_YELLOW}$(t prompt_enter_to_return)${NC}"
        read -r
        return 1
    fi

    echo
    if ! prompt_yes_no "$(t uninstall_confirm)"; then
        show_info "$(t uninstall_cancelled)"
        echo -e "${BOLD_YELLOW}$(t prompt_enter_to_return)${NC}"
        read -r
        return 0
    fi

    cd "$JITSI_DIR"

    (docker compose down -v --rmi all >/dev/null 2>&1) &
    spinner $! "$(t uninstall_stopping)"

    (rm -rf "$JITSI_DIR" "$JITSI_CONFIG_DIR" >/dev/null 2>&1) &
    spinner $! "$(t uninstall_removing)"

    echo
    show_success "$(t uninstall_success)"

    echo -e "${BOLD_YELLOW}$(t prompt_enter_to_return)${NC}"
    read -r
}

# ===================================================================================
#                                RESTART FUNCTIONS
# ===================================================================================

restart_jitsi() {
    if ! check_jitsi_installed; then
        show_error "$(t error_not_installed)"
        echo -e "${BOLD_YELLOW}$(t prompt_enter_to_return)${NC}"
        read -r
        return 1
    fi

    cd "$JITSI_DIR"

    echo
    (docker compose down >/dev/null 2>&1) &
    spinner $! "$(t restart_stopping)"

    (docker compose up -d >/dev/null 2>&1) &
    spinner $! "$(t restart_starting)"

    echo
    show_success "$(t restart_success)"

    echo -e "${BOLD_YELLOW}$(t prompt_enter_to_return)${NC}"
    read -r
}

# ===================================================================================
#                                  LOGS FUNCTIONS
# ===================================================================================

view_logs() {
    if ! check_jitsi_installed; then
        show_error "$(t error_not_installed)"
        echo -e "${BOLD_YELLOW}$(t prompt_enter_to_return)${NC}"
        read -r
        return 1
    fi

    if ! check_containers_running; then
        show_error "$(t error_containers_not_running)"
        echo -e "${BOLD_YELLOW}$(t prompt_enter_to_return)${NC}"
        read -r
        return 1
    fi

    echo
    echo -e "${BOLD_GREEN}$(t logs_select)${NC}"
    echo
    echo -e "${GREEN}1.${NC} $(t logs_all)"
    echo -e "${GREEN}2.${NC} $(t logs_web)"
    echo -e "${GREEN}3.${NC} $(t logs_prosody)"
    echo -e "${GREEN}4.${NC} $(t logs_jicofo)"
    echo -e "${GREEN}5.${NC} $(t logs_jvb)"
    echo -e "${GREEN}0.${NC} $(t users_menu_back)"
    echo
    echo -ne "${BOLD_BLUE_MENU}$(t main_menu_select_option) ${NC}"
    read choice

    cd "$JITSI_DIR"

    case $choice in
        1) docker compose logs -f -t ;;
        2) docker compose logs -f -t web ;;
        3) docker compose logs -f -t prosody ;;
        4) docker compose logs -f -t jicofo ;;
        5) docker compose logs -f -t jvb ;;
        0) return ;;
    esac
}

# ===================================================================================
#                              USER MANAGEMENT FUNCTIONS
# ===================================================================================

list_users() {
    if ! check_containers_running; then
        show_error "$(t error_containers_not_running)"
        return 1
    fi

    cd "$JITSI_DIR"

    echo
    echo -e "${BOLD_GREEN}$(t users_list_title)${NC}"
    echo

    local users=$(docker compose exec -T prosody find /config/data/meet%2ejitsi/accounts -type f -exec basename {} .dat \; 2>/dev/null)

    if [ -z "$users" ]; then
        echo -e "${YELLOW}$(t users_no_users)${NC}"
    else
        echo "$users" | while read -r user; do
            echo -e "  ${GREEN}•${NC} $user"
        done
    fi
    echo
}

create_user() {
    if ! check_containers_running; then
        show_error "$(t error_containers_not_running)"
        return 1
    fi

    echo
    local username=$(prompt_input "$(t users_enter_username)")

    while true; do
        local password=$(prompt_password "$(t users_enter_password)")
        local password_confirm=$(prompt_password "$(t install_confirm_password)")

        if [ "$password" = "$password_confirm" ]; then
            break
        fi
        show_error "$(t error_passwords_no_match)"
    done

    cd "$JITSI_DIR"

    if docker compose exec -T prosody prosodyctl --config /config/prosody.cfg.lua \
        register "$username" meet.jitsi "$password" >/dev/null 2>&1; then
        echo
        show_success "$(t users_created)"
    else
        echo
        show_error "$(t error_admin_creation_failed)"
    fi
}

delete_user() {
    if ! check_containers_running; then
        show_error "$(t error_containers_not_running)"
        return 1
    fi

    list_users

    local username=$(prompt_input "$(t users_enter_username)")

    if prompt_yes_no "$(t users_confirm_delete) '$username'?"; then
        cd "$JITSI_DIR"
        docker compose exec -T prosody prosodyctl --config /config/prosody.cfg.lua unregister "$username" meet.jitsi >/dev/null 2>&1

        echo
        show_success "$(t users_deleted)"
    fi
}

change_user_password() {
    if ! check_containers_running; then
        show_error "$(t error_containers_not_running)"
        return 1
    fi

    list_users

    local username=$(prompt_input "$(t users_enter_username)")

    while true; do
        local password=$(prompt_password "$(t users_enter_password)")
        local password_confirm=$(prompt_password "$(t install_confirm_password)")

        if [ "$password" = "$password_confirm" ]; then
            break
        fi
        show_error "$(t error_passwords_no_match)"
    done

    cd "$JITSI_DIR"

    docker compose exec -T prosody prosodyctl --config /config/prosody.cfg.lua \
        unregister "$username" meet.jitsi >/dev/null 2>&1

    if docker compose exec -T prosody prosodyctl --config /config/prosody.cfg.lua \
        register "$username" meet.jitsi "$password" >/dev/null 2>&1; then
        echo
        show_success "$(t users_password_changed)"
    else
        echo
        show_error "Failed to change password"
    fi
}

show_users_menu() {
    if ! check_jitsi_installed; then
        show_error "$(t error_not_installed)"
        echo -e "${BOLD_YELLOW}$(t prompt_enter_to_return)${NC}"
        read -r
        return
    fi

    while true; do
        clear
        echo -e "${BOLD_GREEN}$(t users_menu_title)${NC}"
        echo
        echo -e "${GREEN}1.${NC} $(t users_menu_list)"
        echo -e "${GREEN}2.${NC} $(t users_menu_create)"
        echo -e "${GREEN}3.${NC} $(t users_menu_delete)"
        echo -e "${GREEN}4.${NC} $(t users_menu_change_password)"
        echo
        echo -e "${GREEN}0.${NC} $(t users_menu_back)"
        echo
        echo -ne "${BOLD_BLUE_MENU}$(t main_menu_select_option) ${NC}"
        read choice

        case $choice in
            1)
                list_users
                echo -e "${BOLD_YELLOW}$(t prompt_enter_to_return)${NC}"
                read -r
                ;;
            2)
                create_user
                echo -e "${BOLD_YELLOW}$(t prompt_enter_to_return)${NC}"
                read -r
                ;;
            3)
                delete_user
                echo -e "${BOLD_YELLOW}$(t prompt_enter_to_return)${NC}"
                read -r
                ;;
            4)
                change_user_password
                echo -e "${BOLD_YELLOW}$(t prompt_enter_to_return)${NC}"
                read -r
                ;;
            0)
                return
                ;;
            *)
                show_error "$(t error_invalid_choice)"
                sleep 1
                ;;
        esac
    done
}

# ===================================================================================
#                                  INFO FUNCTIONS
# ===================================================================================

show_connection_info() {
    echo
    if [ -f "/opt/jitsi/credentials.txt" ]; then
        cat /opt/jitsi/credentials.txt
    else
        echo -e "${BOLD_RED}File /opt/jitsi/credentials.txt not found${NC}"
    fi
    echo
    echo -e "${BOLD_YELLOW}Press Enter to return to menu...${NC}"
    read -r
}

# ===================================================================================
#                                    MAIN MENU
# ===================================================================================

show_main_menu() {
    clear
    echo -e "${BOLD_GREEN}$(t main_menu_title)${VERSION}${NC}"
    echo
    echo -e "${GREEN}1.${NC} $(t main_menu_install)"
    echo -e "${GREEN}2.${NC} $(t main_menu_uninstall)"
    echo -e "${GREEN}3.${NC} $(t main_menu_restart)"
    echo -e "${GREEN}4.${NC} $(t main_menu_view_logs)"
    echo -e "${GREEN}5.${NC} $(t main_menu_manage_users)"
    echo -e "${GREEN}6.${NC} $(t main_menu_show_info)"
    echo
    echo -e "${GREEN}0.${NC} $(t main_menu_exit)"
    echo
    echo -ne "${BOLD_BLUE_MENU}$(t main_menu_select_option) ${NC}"
}

main() {
    while true; do
        show_main_menu
        read choice

        case $choice in
            1) install_jitsi ;;
            2) uninstall_jitsi ;;
            3) restart_jitsi ;;
            4) view_logs ;;
            5) show_users_menu ;;
            6) show_connection_info ;;
            0)
                echo "Goodbye!"
                exit 0
                ;;
            *)
                show_error "$(t error_invalid_choice)"
                sleep 1
                ;;
        esac
    done
}

# ===================================================================================
#                                      ENTRY POINT
# ===================================================================================

if [ "$(id -u)" -ne 0 ]; then
    echo -e "${BOLD_RED}$(t error_root_required)${NC}"
    exit 1
fi

main
