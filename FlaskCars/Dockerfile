FROM python:3.10.10

WORKDIR /projekt
COPY Lab_3.py .
COPY requirements.txt .

RUN pip install -r requirements.txt

CMD ["python3", "-m", "flask", "--app", "Lab_3.py", "run", "--host=0.0.0.0"]
