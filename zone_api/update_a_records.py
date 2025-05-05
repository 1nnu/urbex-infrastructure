import requests
import json
import os
import subprocess

DOMAIN = "mahajaetud.ee"
API_URL = f"https://api.zone.eu/v2/dns/{DOMAIN}/a/"
API_KEY = os.getenv("ZONE_API_KEY")
API_USERNAME = "VIIIN"
HETZNER_TOKEN = os.getenv("HETZNER_API_TOKEN")

# Use absolute path to inventory file
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
ANSIBLE_INVENTORY_PATH = os.path.abspath(os.path.join(BASE_DIR, '../inventory/hcloud.yaml'))

def get_load_balancer_ip():
    try:
        result = subprocess.run(
            ["ansible-inventory", "-i", ANSIBLE_INVENTORY_PATH, "--list", "-e", f"hetzner_api_token={HETZNER_TOKEN}"],
            capture_output=True,
            check=True,
            text=True
        )
        print("🔍 Ansible inventory raw output:")
        inventory = json.loads(result.stdout)
        return inventory["_meta"]["hostvars"]["load-balancer"]["ansible_host"]
    except subprocess.CalledProcessError as e:
        print(f"Error running ansible-inventory:\n{e.stderr}")
        return None
    except KeyError:
        print("'load-balancer' or 'ansible_host' not found in inventory output.")
        return None

def get_a_records():
    r = requests.get(API_URL, auth=(API_USERNAME, API_KEY))
    if r.status_code == 200:
        return r.json()
    else:
        print(f"Error fetching A records: {r.status_code} - {r.text}")
        return None

def update_a_record(record_id, new_ip):
    update_url = f"{API_URL}{record_id}"
    data = {
        "destination": new_ip,
        "name": DOMAIN,
    }
    r = requests.put(update_url, auth=(API_USERNAME, API_KEY), json=data)
    if r.status_code == 200:
        print(f"✅ Updated A record {record_id} to {new_ip}")
    else:
        print(f"❌ Error updating A record {record_id}: {r.status_code} - {r.text}")

def main():
    new_ip = get_load_balancer_ip()
    if not new_ip:
        print("Could not retrieve load balancer IP.")
        return

    print(f"🔍 Load balancer IP: {new_ip}")

    a_records = get_a_records()
    if not a_records:
        return

    for record in a_records:
        record_id = record['id']
        current_ip = record['destination']
        if current_ip != new_ip:
            print(f"Updating A record {record_id} from {current_ip} to {new_ip}")
            update_a_record(record_id, new_ip)
        else:
            print(f"A record {record_id} already set to {new_ip}. Skipping.")
    print("✅ All A records processed.")

if __name__ == "__main__":
    main()
