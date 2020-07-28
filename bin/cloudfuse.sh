#!/usr/bin/env bash
set -euf -o pipefail

# Removable drive names go here, separated by spaces
DRIVE_NAMES=()

# Removable and cloud drives are mounted in this local directory
DRIVE_MOUNT_ROOT="/mnt/data/cloudfuse"
# Name of folder for root of encrypted storage on drives
ENCRYPTED_DIR_NAME="encrypted"
# Rclone remote name for pooled drives
RCLONE_POOL_NAME="encrypted_pool"
# Local path for mounting decrypted drive pool
DECRYPTED_MOUNT_PATH="/mnt/data/cloudfuse/decrypted_pool"

# Helper for joining array items with `:`
function semicolon_join { local IFS=':'; echo "$*"; }

# Helper for unmounting on exit
function finish {
  echo "Cleaning up and unmounting ..."

  if mount | grep -q "$DECRYPTED_MOUNT_PATH"; then
    echo "Unmounting merged rclone at $DECRYPTED_MOUNT_PATH"
    fusermount -u "$DECRYPTED_MOUNT_PATH" > /dev/null 2>&1
  fi

  if mount | grep -q "$DRIVE_MOUNT_ROOT/merged"; then
    echo "Unmounting mergerfs at $DRIVE_MOUNT_ROOT/merged"
    fusermount -u "$DRIVE_MOUNT_ROOT/merged" > /dev/null 2>&1
  fi

  for name in "${CLOUD_DRIVE_NAMES[@]}"; do
    mount_path="$DRIVE_MOUNT_ROOT/$name"
    if mount | grep -q "$mount_path"; then
      echo "Unmounting cloud remote $name"
      fusermount -u "$mount_path" > /dev/null 2>&1
    fi
  done
}

trap finish EXIT

VALID_MOUNTS=()
echo "Checking removable drives"
for name in "${DRIVE_NAMES[@]}"; do
  mount_path="$DRIVE_MOUNT_ROOT/$name/$ENCRYPTED_DIR_NAME" 
  if [ -d "$mount_path" ]; then
    VALID_MOUNTS+=("$mount_path")
  fi
done

# Mount cloud drives, if any
CLOUD_DRIVE_NAMES=(mega-pfuse jotta-pfuse yandex-pfuse)
echo "Checking cloud drives"
for name in "${CLOUD_DRIVE_NAMES[@]}"; do
  mount_path="$DRIVE_MOUNT_ROOT/$name"
  if ! mount | grep -q "rclone_$name"; then
    echo "Mounting rclone remote $name ..."
    rclone mount "$name:/$ENCRYPTED_DIR_NAME" "$mount_path" \
      --allow-other --read-only &
  fi

  VALID_MOUNTS+=("$mount_path")
done
echo "Found drives: ${VALID_MOUNTS[*]}"

echo "Mounting pool via mergerfs"
mergerfs "$(semicolon_join "${VALID_MOUNTS[@]}")" "$DRIVE_MOUNT_ROOT/merged" \
  -o defaults,allow_other,moveonenospc=true \
  -o fsname=encrypted_merged,category.create=epmfs,func.getattr=newest

echo "Mounting decrypted pool"
rclone mount "$RCLONE_POOL_NAME:/" "$DECRYPTED_MOUNT_PATH" \
  --allow-other --no-modtime &

echo "Mounting complete, hit Control-C to unmount and exit"
wait