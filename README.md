# Bonsai Workspace — Локальный AI-агент с памятью

Персональная рабочая среда для DeepSeek Harness с моделью Ternary-Bonsai-2-27B. 
*(Название "Bansai" — это наш боевой клич "БАНЗАЙ!", а модель внутри — Bonsai)*

## 🚀 Быстрый старт

### Требования
- **DeepSeek Harness** — [скачать](https://www.deepseek.com/en/harness/)
- **Модель**: Ternary-Bonsai-2-27B-PQ2_0.gguf (~8 GB) — [скачать](https://huggingface.co/PrismML/Ternary-Bonsai-2-27B-PQ2_0.gguf)
- **Python 3.7+** (для работы `mem.py`)
- **GPU**: AMD с поддержкой Vulkan (RX 6000/7000/9000) или NVIDIA

### Установка за 5 минут

**Перед установкой единожды запусти DeepSeek Harness, чтобы он создал файлы и прописал пути**

1. **Скачай или склонируй этот репозиторий** в удобное место, например: `C:\bansai-local-agent`

2. **Запусти скрипт развёртывания:**
   ```powershell
   cd C:\bansai-local-agent
   .\setup-workspace.ps1
   ```
3. **Скопируй профиль конфигурации в папку профиля Harness:**
   ```powershell
   Copy-Item C:\workspace\cordis.patch.yml "$env:USERPROFILE\.dsh\profiles\desktop\cordis.patch.yml"
   ```
4. **Отредактируй путь к модели в файле C:\workspace\start-server.ps1:**
   Найди строку Set-Location 'C:\AI\bonsai\Bonsai-demo' и замени её на реальный путь к папке, где лежит твой .gguf файл.

5. **Запусти сервер:**
   ```powershell
   cd C:\workspace
   .\start-stack.cmd
   ```
6. **Открой DeepSeek Harness и выбери модель bonsai-2-27b в настройках.**
   
### Работа с памятью (если агент сам не сделал записей)  

- **Записать урок
  ```powershell
   py -3 C:\workspace\mem.py write --cat gotcha --task "название" --broke "симптом" --fixed "решение"
   ```
  
- **Прочитать урок
  ```powershell
   py -3 C:\workspace\mem.py read <id>
   ```
  
- **Поиск по урокам
  ```powershell
   py -3 C:\workspace\mem.py search "ключевое слово"
   ```
