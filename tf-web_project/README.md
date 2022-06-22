





cloudwatch alarm trigger:
aws cloudwatch set-alarm-state \
--alarm-name "Web-Server-SystemFailed" \
--state-value ALARM \
--state-reason "Simulate an EC2 HW failure"
