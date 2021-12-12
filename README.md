#README.md
```
This is a simple command line tool for sending templated emails via Mailgun's API. 

Requirements:
    - Mailgun account, API key and Domain
    - Ruby @2.6.6+


This excellent tutorial will help you: 
    - Setup MacOS's Developer Tools
    - Install Homebrew
    - Install Git
    - Install RVM (or another software version manager)
    - Install Ruby

https://learn-rails.com/install-rails-mac/index.html



Once everything is installed and configured:
    - Clone this repository
    - Navigate to the cloned directory and open it in terminal
    - Make sure the script has executable permissions
    - Execute mailgun_template_cli.rb with the -p option
    - Include a valid JSON payload following the -p option with NO NEWLINE CHARACTERS


A valid example payload looks like this:
    {
        "api_key": "YourMailGunAPIKey",
        "domain": "YourMailgunDomain.mailgun.org",
        "from": "Sender Name <mailgun@YourMailgunDomain.mailgun.org>",
        "to": "YourRecipient@domain.com",
        "subject": "A Subject!",
        "body": "<html><body>Email Text (HTML optional)</body></html>",
        "template": "welcome",
        "parameters": {
            "website_name": "WebsiteName",
            "foos": "Item1",
            "bars": "Item2",
            "bazs": "Item3"
        }
    }
    
 But the payload must be collapsed as such:
  {"api_key": "YourMailGunAPIKey", "domain": "YourMailgunDomain.mailgun.org", "from": "Sender Name <mailgun@YourMailgunDomain.mailgun.org>", "to": "YourRecipient@domain.com", "subject": "A Subject!", "body": "<html><body>Email Text (HTML optional)</body></html>", "template": "welcome", "parameters": { "website_name": "WebsiteName", "foos": "Item1", "bars": "Item2", "bazs": "Item3"}}

Valid template names are: "welcome", "confirm_email", and "reset_password" with the arguments as follows:

welcome:
    website_name: Your website
    foos: An item available on your website
    bars: An item available on your website
    bazs: An item available on your website

confirm_email:
    username: Recipient's username
    website_name: Your website
    url: Confirmation link

reset_password:
    username: Recipient's username
    url: Reset link
    time: Hours until link expires


Once the payload is successfully delivered, your message will be sent shortly. 
If you're using a sandboxed domain, the email will likely land in your spam folder.
```
