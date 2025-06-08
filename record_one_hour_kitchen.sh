SUBNET="192.168.1"
START=2
END=20
PORT=554
USERNAME="admin"
PASSWORD=""
CHANNEL_PATH="/Streaming/Channels/102"  # Use substream for better compatibility
RECORD_DURATION=900  # 15 minutes per segment
OUTPUT_DIR="$HOME/cctv_recordings"
mkdir -p "$OUTPUT_DIR"

while true; do
    DATE_HOUR=$(date +"%Y-%m-%d %H:00:00")
    
    CURRENT_MINUTE=$(date +%M)
	REMAINING_MINUTES=$((60 - CURRENT_MINUTE))
	CURRENT_SECONDS=$(date +%S)
	REMAINING_SECONDS=$(( (60 - CURRENT_MINUTE) * 60 - CURRENT_SECONDS ))
	START_TIME=$(date +%s)
	
    END_TIME=$((START_TIME + REMAINING_SECONDS))
    echo "End time (Unix timestamp): $END_TIME"

    for ((i=START; i<=END; i++)); do
        IP="$SUBNET.$i"
        STREAM_URL="rtsp://$USERNAME:$PASSWORD@$IP:$PORT$CHANNEL_PATH"
        echo "Checking $IP..."
        

        if nc -z -w 5 "$IP" "$PORT"; then
            SEGMENT=1
            PARTS=()
			
            while true; do
    			NOW=$(date +%s)
    			REMAINING=$((END_TIME - NOW))
    			
    			echo "Number of parts recorded: ${#PARTS[@]}"
				echo "Time Remaining: $REMAINING}"
    			if [ $REMAINING -le 0 ]; then
        			echo "Reached end time. Stopping recordings."
        			break
    			fi
			
    			# Decide how long to record for: 5 mins or remaining time
    			DURATION=$RECORD_DURATION
    			echo "duration: $DURATION"
    			if [ $REMAINING -lt $RECORD_DURATION ]; then
        			echo "Only $REMAINING seconds left. Recording shorter segment."
        			DURATION=$REMAINING
    			fi
			
    			FILENAME="$OUTPUT_DIR/${IP//./_}_${DATE_HOUR}_part_${SEGMENT}.mp4"
				echo "Recording $FILENAME for $DURATION seconds..."
				
  				ffmpeg -rtsp_transport tcp -fflags +genpts -i "$STREAM_URL" -t "$DURATION" \
				  -c:v libx264 -preset ultrafast -crf 23 -c:a aac "$FILENAME"

				
				if [ $? -eq 0 ]; then
    				echo "adding filename into parts...."
    				PARTS+=("$FILENAME")
    				((SEGMENT++))
				else
    				echo "Stream interrupted. Retrying in 10 seconds..."
    				sleep 10
				fi
			done
        fi
    done
done