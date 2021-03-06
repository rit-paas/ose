#!/usr/bin/expect -f 

set host \$0
set pw   \$1

set timeout 60

spawn ssh-copy-id -i /root/.ssh/id_rsa.pub $argv

expect { 
  "assword: " { 
    send "Install01\n" 
    expect { 
      "again." { exit 1 } 
      "expecting." { } 
      timeout { exit 1 } 
    } 
  } 
  "(yes/no)? " { 
    send "yes\n" 
    expect { 
      "assword: " { 
        send "Install01\n" 
        expect { 
          "again." { exit 1 } 
          "expecting." { } 
          timeout { exit 1 } 
        } 
      } 
    } 
  } 
} 
exit 0 
