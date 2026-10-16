# Bonsai Workspace — Локальный AI-агент с памятью

Персональная рабочая среда для DeepSeek Harness с моделью Ternary-Bonsai-2-27B.

## 🚀 Быстрый старт

### Требования
- **DeepSeek Harness** — [скачать](https://www.deepseek.com/en/harness/)
- **Модель**: Ternary-Bonsai-2-27B-PQ2_0.gguf (~8 GB) — [скачать](https://huggingface.co/PrismML/Ternary-Bonsai-2-27B-PQ2_0.gguf)
- **Python 3.7+** (для mem.py)
- **AMD GPU с Vulkan** (RX 6000/7000/9000) или **NVIDIA**

### Установка за 5 минут

1. **Распакуй папку `bonsai`** в удобное место (например, `C:\bonsai`)

2. **Запусти скрипт развёртывания:**
   ```powershell
   cd C:\bonsai
   .\setup-workspace.ps1
   ```
   
### Установка за 5 минут   

- **Записать урок
py -3 C:\workspace\mem.py write --cat gotcha --task "название" --broke "симптом" --fixed "решение"

- **Прочитать урок
py -3 C:\workspace\mem.py read <id>

- **Поиск по урокам
py -3 C:\workspace\mem.py search "ключевое слово"
