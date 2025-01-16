from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
import subprocess
import time

class NmapScanView(APIView):
    def post(self, request):
        target = request.data.get('target')
        flags = request.data.get('flags', '')

        if not target:
            return Response({"error": "Target is required"}, status=status.HTTP_400_BAD_REQUEST)

        try:
            # Split the flags string into a list for subprocess
            flags_list = flags.split() if flags else []
            
            # Construct the Nmap command with flags
            command = ['nmap', '-v'] + flags_list + [target]

            # Start the Nmap process
            process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)

            # Stream output to the client
            scan_output = []
            while True:
                line = process.stdout.readline()
                if not line and process.poll() is not None:
                    break
                if line:
                    scan_output.append(line)
                    time.sleep(0.1)  # Simulate delay for readability
            
            # Combine and return the final output
            return Response({"result": ''.join(scan_output)}, status=status.HTTP_200_OK)

        except Exception as e:
            return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
