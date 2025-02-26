# Используем официальный образ Golang для сборки
FROM golang:1.23 as builder

# Устанавливаем рабочую директорию внутри контейнера
WORKDIR /app

# Копируем файлы в контейнер
COPY go.mod go.sum ./
RUN go mod tidy

COPY . .

# Собираем бинарный файл
RUN go build -o parcel-tracker .

# Используем минимальный образ для запуска приложения
FROM alpine:latest

WORKDIR /app

# Устанавливаем зависимости
RUN apk add --no-cache sqlite

# Копируем скомпилированное приложение из предыдущего контейнера
COPY --from=builder /app/parcel-tracker .

# Копируем базу данных (если нужна)
COPY tracker.db .

# Запускаем приложение
ENTRYPOINT ["./parcel-tracker"]