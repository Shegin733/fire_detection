import cv2
import playsound
import smtplib
import threading
import numpy as np
from collections import deque
from datetime import datetime
from pydantic import BaseModel
from typing import Optional, Tuple, Union


def send_mail(recp: str = "sender_email"):
    try:
        recp = recp.lower()
        server = smtplib.SMTP('smtp.gmail.com', 587)
        server.ehlo()
        server.starttls()
        server.login("sender_email", 'sender_password')
        server.sendmail('sender_email', recp,
                        "Warning fire accident has been reported")
        print("Alert mail sent successfully to forestofficeridukki@gmail.com")
        server.close()
    except Exception as e:
        print(e)


class FireResponse(BaseModel):
    detection: bool
    timestamp: str
    desc: str


class FireDetector:
    def __init__(self, cap_url: Union[str, int] = 0, model_path: str = "fire_detection_cascade_model.xml"):
        self.detection_state = False
        self.cap = None
        self.cap_url = cap_url
        self.fire_cascade = cv2.CascadeClassifier(model_path)
        self.detection_thread = None
        self.res_q: deque = deque(maxlen=20)
        self.lock = threading.Lock()

    def start_detection(self):
        with self.lock:
            self.detection_state = True
            self.res_q.clear()
        if not self.detection_thread or not self.detection_thread.is_alive():
            self.cap = cv2.VideoCapture(self.cap_url)
            self.detection_thread = threading.Thread(target=self.run_detection)
        self.detection_thread.start()

    def stop_detection(self):
        with self.lock:
            self.detection_state = False
            self.res_q.clear()
        self.cap.release()
        if self.detection_thread and self.detection_thread.is_alive():
            self.detection_thread.join()

    def run_detection(self):
        while self.detection_state and self.cap:
            ret, frame = self.cap.read()
            if ret:
                gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
                fire = self.fire_cascade.detectMultiScale(frame, 1.2, 5)
                if len(fire) > 0:
                    for (x, y, w, h) in fire:
                        cv2.rectangle(frame, (x - 20, y - 20),
                                      (x + w + 20, y + h + 20), (255, 0, 0), 2)
                        
                    with self.lock:
                        self.res_q.append((frame, FireResponse(
                            detection=True, desc="Fire detected", timestamp=datetime.now().isoformat())))
                    playsound('Alarm Sound.mp3')
                else:
                    with self.lock:
                        self.res_q.append((frame, FireResponse(
                            detection=False, desc="No Fire detected", timestamp=datetime.now().isoformat())))
            else:
                break

    def get_res(self) -> Optional[Tuple[np.ndarray, FireResponse]]:
        with self.lock:
            if self.res_q:
                return self.res_q.pop()
        return None

    def __delete__(self):
        self.cap.release()
