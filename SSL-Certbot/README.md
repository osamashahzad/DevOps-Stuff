1. Need to install certbot first for the webserver that youre using. If youre using nginx, run the following command

    ``` sudo apt install certbot python3-certbot-nginx ```
    
2. Now after installation, run the following command followed by the domain you want to assing ssl for

    ``` sudo certbot --nginx -d "**Domain Name**" ```
    
3. You'll be prompted to add your email address.
4. If the above command doesnt work, you will have to assign the certificates manually by running the following command

    ``` sudo certbot certonly --manual --preferred-challenges=dns --email osama.shahzad@kryptomind.com --server https://acme-v02.api.letsencrypt.org/directory -d "Domain-Name" ``` (Can also assign wild card entry by using this command)
5. When you try to assign them manually by running the above command, you will be given a TXT record for your domain. Add that as a DNS record where your domain is hosted.