FROM python:alpine3.18 as builder

WORKDIR /app

COPY ./giropops-senhas/requirements.txt .

RUN pip install --disable-pip-version-check -r requirements.txt --target /packages

COPY ./giropops-senhas .

FROM cgr.dev/chainguard/python:latest

WORKDIR /app

COPY --from=builder /app /app
COPY --from=builder /packages /packages

ENV PYTHONPATH=/packages
# instead of ENV PYTHONPATH=/usr/local/lib/python/site-packages

EXPOSE 5000

CMD ["/packages/bin/flask", "run", "--host=0.0.0.0"]
