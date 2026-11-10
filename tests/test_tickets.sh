#!/usr/bin/env bash
# Sends the 6 test tickets (macOS/Linux). Usage: ./tests/test_tickets.sh [URL]
URL="${1:-http://localhost:5678/webhook/support-ticket}"
send() { echo; echo "=== $1 ==="; curl -s -X POST "$URL" -H "Content-Type: application/json" -d "$2"; echo; }
send "1 refund, angry -> urgent"    '{"name":"Anna Weber","email":"anna.weber@example.com","subject":"Charged twice, want my money back","message":"I was charged twice for my subscription this month. This is unacceptable, I want a refund for the duplicate payment immediately."}'
send "2 billing question -> medium" '{"name":"Rahul Mehta","email":"rahul@example.com","subject":"Invoice address","message":"How can I change the billing address shown on my invoices? Our company moved last month."}'
send "3 account, simple"            '{"name":"Lena Fischer","email":"lena@example.com","subject":"Password reset","message":"Hi, how do I reset my password? Thanks!"}'
send "4 vague -> manual review"     '{"name":"Max","email":"max@example.com","subject":"Problem","message":"it doesn'"'"'t work"}'
send "5 off-topic -> fallback"      '{"name":"Sara Ko","email":"sara@example.com","subject":"Office dog policy","message":"Can I bring my dog to your office when I visit next week?"}'
send "6 invalid email -> rejected"  '{"name":"Tom","email":"tom-at-example","subject":"Help","message":"Please call me."}'
