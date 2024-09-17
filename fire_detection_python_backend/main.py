import cv2
import time
import uvicorn
import asyncio
import json
import base64
from typing import Dict, Union
from fastapi import FastAPI, WebSocket, BackgroundTasks
from fastapi.responses import Response, FileResponse
from fastapi.staticfiles import StaticFiles
from fastapi.middleware.cors import CORSMiddleware
from fastapi.middleware.gzip import GZipMiddleware
from detection_utils import FireDetector, FireResponse

cap_url = 'http://100.126.13.77:8080/video'
detector = FireDetector(cap_url)
app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


class WsConnPool:
    def __init__(self):
        self.connections = set()

    async def connect(self, websocket: WebSocket):
        await websocket.accept()
        self.connections.add(websocket)

    def disconnect(self, websocket: WebSocket):
        self.connections.remove(websocket)

    async def broadcast(self, data: Dict[str, Union[str, Dict[str, str]]]):
        connections_to_remove = set()
        for connection in self.connections:
            try:
                await connection.send_text(json.dumps(data))
            except RuntimeError:
                connections_to_remove.add(connection)

        for connection in connections_to_remove:
            self.disconnect(connection)


websockets = WsConnPool()


@app.websocket("/")
async def detection_ws(websocket: WebSocket):
    await websockets.connect(websocket)

    while True:
        if detector.detection_state:
            output = detector.get_res()
            if output:
                frame, response = output
                _, image_buffer = cv2.imencode('.jpg', frame)
                encoded_image = base64.b64encode(image_buffer).decode('utf-8')

                await websockets.broadcast({
                    "frame": encoded_image,
                    "response": response.dict()
                })
        else:
            await websocket.close(reason="Fire Detection not currently running")
            break

        await asyncio.sleep(0)


@app.post("/start_detection")
async def start_detection(background_tasks: BackgroundTasks):
    if not detector.detection_state:
        detector.start_detection()
        return Response(content="Fire detection started.", status_code=200)
    else:
        return Response(content="Detection already started.", status_code=400)


@app.post("/stop_detection")
async def stop_detection():
    if detector.detection_state:
        detector.stop_detection()
        return Response(content="Fire detection stopped.", status_code=200)
    else:
        Response(content="Detection already in stopped state.", status_code=400)


if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
