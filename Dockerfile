FROM docker.cnb.cool/srebro/pidin/chromium:latest

WORKDIR /app

RUN curl -L -o /app/linux_amd64 \
    https://github.com/jxhczhl/JsRpc/releases/download/v1.095/linux_amd64 \
 && chmod +x /app/linux_amd64

COPY entrypoint.sh .
RUN chmod +x /app/entrypoint.sh

EXPOSE 3000 3001 12080 12443

CMD ["bash", "-c", "/app/linux_amd64", "&"]