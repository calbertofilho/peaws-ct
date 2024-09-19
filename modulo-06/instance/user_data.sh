#! /bin/bash

sudo apt update && sudo apt install -fym apache2
sudo systemctl start apache2
sudo systemctl enable apache2
echo -ne "<!DOCTYPE html>
<html>
    <head>
        <title>Terraform's Hello World</title>
    </head>
    <body>
        <center>
            <h2>W E L C O M E    ! ! !</h2>
            <img src="https://cdn.vectorstock.com/i/500p/47/37/melted-smile-faces-in-trippy-acid-rave-style-vector-39514737.jpg" alt="Melted smile faces" width="1000" height="500" />
            <h4>This page was created using Terraform's user_data script.</h4>
        </center>
    </body>
</html>" | sudo tee /var/www/html/index.html
sudo apt update && sudo upgrade -fym && sudo apt autoremove
