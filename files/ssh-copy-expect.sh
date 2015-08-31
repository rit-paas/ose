#!/usr/bin/expect -f 

set host \$0
set pw   \$1

set timeout 60

spawn ssh-copy-id -i /root/.ssh/id_rsa.pub $argv

expect { 
  "assword: " { 
    send "$pw\n" 
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
        send "PASSWORD!!\n" 
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

expect {
    timeout { send_user "\nFailed to get password prompt\n"; exit 1 }
    eof { send_user "\nSSH failure for $hostname\n"; exit 1 }

    "*re you sure you want to continue connecting" {
        send "yes\r"
        exp_continue
    }
    "*assword*" {
        send "PASSWORD!!\r"
    }
}
