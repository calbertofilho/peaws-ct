#! /bin/bash

sudo apt update && sudo apt install -fym apache2 ec2-instance-connect
sudo systemctl enable apache2 --now
echo -ne '<!DOCTYPE html>

<html>
    <head>
        <title>Terraform&apos;s Hello World</title>
        <style>
            * {
                margin: 0;
                padding: 0;
            }
            body {
                background-color: rgb(40, 42, 54);
                color: rgb(241, 250, 140);
            }
            h5 {
                color: rgb(139, 233, 253)
            }
        </style>
    </head>

    <body>
        <center>
            <h1>W E L C O M E    ! ! !</h1>
            <img src="https://i.imgur.com/U7YYtgL.png" alt="Melted smile faces" width="1000" height="500" />
            <h3>This page was created using Terraform&apos;s user_data script.</h3>
            <h5>Instance A</h5>
        </center>
    </body>
</html>' | sudo tee /var/www/html/index.html
sudo apt update && sudo upgrade -fym && sudo apt autoremove
