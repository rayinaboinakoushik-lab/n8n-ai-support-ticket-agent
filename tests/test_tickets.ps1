# Sends the 6 test tickets to the ticket workflow, one by one, and prints what came back.
# Usage:  .\test_tickets.ps1            (all 6)      .\test_tickets.ps1 -Only 1   (just ticket 1)
# The workflow must be active (Publish) - otherwise use -Url with the test URL.
param([int]$Only = 0, [string]$Url = "http://localhost:5678/webhook/support-ticket")
$tickets = @(
  @{ label = "1 refund, angry -> urgent";       name = "Anna Weber";  email = "anna.weber@example.com"; subject = "Charged twice, want my money back"; message = "I was charged twice for my subscription this month. This is unacceptable, I want a refund for the duplicate payment immediately." },
  @{ label = "2 billing question -> medium";    name = "Rahul Mehta"; email = "rahul@example.com";      subject = "Invoice address";                    message = "How can I change the billing address shown on my invoices? Our company moved last month." },
  @{ label = "3 account, simple -> low";        name = "Lena Fischer"; email = "lena@example.com";      subject = "Password reset";                     message = "Hi, how do I reset my password? Thanks!" },
  @{ label = "4 vague -> low confidence";       name = "Max";         email = "max@example.com";        subject = "Problem";                            message = "it doesn't work" },
  @{ label = "5 off-topic -> fallback";         name = "Sara Ko";     email = "sara@example.com";       subject = "Office dog policy";                  message = "Can I bring my dog to your office when I visit next week?" },
  @{ label = "6 invalid email -> rejected";     name = "Tom";         email = "tom-at-example";         subject = "Help";                               message = "Please call me." }
)
$i = 0
foreach ($t in $tickets) {
  $i++
  if ($Only -and $Only -ne $i) { continue }
  Write-Host "`n=== $($t.label) ===" -ForegroundColor Cyan
  $body = @{ name = $t.name; email = $t.email; subject = $t.subject; message = $t.message } | ConvertTo-Json
  try { Invoke-RestMethod -Method Post -Uri $Url -ContentType "application/json" -Body $body | ConvertTo-Json -Depth 5 }
  catch { Write-Host "Request failed: $($_.Exception.Message)" -ForegroundColor Red }
}
