FROM python:3.13.3-alpine3.21
COPY . /app
WORKDIR /app
RUN pip install --no-cache-dir -r requirements.txt
CMD [ "flask","run","--host=0.0.0.0","--port=8080" ]
EXPOSE 8080