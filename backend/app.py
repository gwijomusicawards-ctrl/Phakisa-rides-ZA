import os
import uuid
from datetime import datetime, timezone
from flask import Flask, jsonify, request

app = Flask(__name__)
users = {}
drivers = {}
rides = {}

def now():
    return datetime.now(timezone.utc).isoformat()

@app.get("/")
def home():
    return jsonify({
        "app": "Phakisa Rides ZA API",
        "status": "online",
        "developer": "Otsile Graphics Co."
    })

@app.get("/api/health")
def health():
    return jsonify({"status": "ok"})

@app.post("/api/users")
def create_user():
    data = request.get_json(silent=True) or {}
    uid = str(uuid.uuid4())
    users[uid] = {
        "id": uid,
        "name": data.get("name", ""),
        "phone": data.get("phone", ""),
        "role": data.get("role", "passenger"),
        "created_at": now()
    }
    return jsonify(users[uid]), 201

@app.post("/api/drivers")
def create_driver():
    data = request.get_json(silent=True) or {}
    uid = str(uuid.uuid4())
    drivers[uid] = {
        "id": uid,
        "name": data.get("name", ""),
        "phone": data.get("phone", ""),
        "vehicle": data.get("vehicle", {}),
        "online": False,
        "location": None,
        "created_at": now()
    }
    return jsonify(drivers[uid]), 201

@app.post("/api/drivers/<driver_id>/online")
def driver_online(driver_id):
    driver = drivers.get(driver_id)
    if not driver:
        return jsonify({"error": "Driver not found"}), 404
    data = request.get_json(silent=True) or {}
    driver["online"] = bool(data.get("online", True))
    return jsonify(driver)

@app.post("/api/drivers/<driver_id>/location")
def driver_location(driver_id):
    driver = drivers.get(driver_id)
    if not driver:
        return jsonify({"error": "Driver not found"}), 404
    data = request.get_json(silent=True) or {}
    try:
        lat = float(data["latitude"])
        lng = float(data["longitude"])
    except (KeyError, TypeError, ValueError):
        return jsonify({"error": "latitude and longitude are required"}), 400
    driver["location"] = {
        "latitude": lat,
        "longitude": lng,
        "updated_at": now()
    }
    return jsonify(driver)

@app.get("/api/drivers/nearby")
def nearby():
    return jsonify({
        "drivers": [
            d for d in drivers.values()
            if d["online"] and d["location"] is not None
        ]
    })

@app.post("/api/rides")
def create_ride():
    data = request.get_json(silent=True) or {}
    missing = [x for x in ("passenger_id", "pickup", "destination") if x not in data]
    if missing:
        return jsonify({"error": "Missing fields", "fields": missing}), 400
    ride_id = str(uuid.uuid4())
    rides[ride_id] = {
        "id": ride_id,
        "passenger_id": data["passenger_id"],
        "driver_id": None,
        "pickup": data["pickup"],
        "destination": data["destination"],
        "status": "requested",
        "fare": None,
        "created_at": now(),
        "updated_at": now()
    }
    return jsonify(rides[ride_id]), 201

@app.get("/api/rides/<ride_id>")
def get_ride(ride_id):
    ride = rides.get(ride_id)
    if not ride:
        return jsonify({"error": "Ride not found"}), 404
    return jsonify(ride)

@app.post("/api/rides/<ride_id>/accept")
def accept_ride(ride_id):
    ride = rides.get(ride_id)
    if not ride:
        return jsonify({"error": "Ride not found"}), 404
    data = request.get_json(silent=True) or {}
    driver_id = data.get("driver_id")
    if driver_id not in drivers:
        return jsonify({"error": "Valid driver_id is required"}), 400
    if ride["status"] != "requested":
        return jsonify({"error": "Ride is no longer available"}), 409
    ride["driver_id"] = driver_id
    ride["status"] = "accepted"
    ride["updated_at"] = now()
    return jsonify(ride)

@app.post("/api/rides/<ride_id>/status")
def ride_status(ride_id):
    ride = rides.get(ride_id)
    if not ride:
        return jsonify({"error": "Ride not found"}), 404
    status = (request.get_json(silent=True) or {}).get("status")
    allowed = {"accepted", "arriving", "in_progress", "completed", "cancelled"}
    if status not in allowed:
        return jsonify({"error": "Invalid status", "allowed": sorted(allowed)}), 400
    ride["status"] = status
    ride["updated_at"] = now()
    return jsonify(ride)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int(os.environ.get("PORT", "10000")))
