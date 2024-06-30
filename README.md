# 🛡️ SecretStash 🛡️

Welcome to **SecretStash** - your ultimate solution for securely encrypting, decrypting, and managing your sensitive files with ease!

## What is SecretStash? 🤔

SecretStash is a nifty tool that allows you to create an encrypted directory, securely store your key files, and manage access with public/private key pairs. It's perfect for anyone who wants to keep their data safe from prying eyes. SecretStash is especially useful when you need to keep project secrets in Git repositories.

## Features 🚀

- **Initialize**: Set up your encrypted directory and create a secure keyfile.
- **Mount/Unmount**: Easily mount your encrypted directory to access your files and unmount it when you're done.
- **Update Recipients**: Manage who can access your encrypted data by updating the list of recipients with public keys.

## Getting Started 🛠

### Prerequisites

- Install [just](https://github.com/casey/just) - a handy way to save and run project-specific commands
- Install [gocryptfs](https://github.com/rfjakob/gocryptfs)
- Install [age](https://github.com/FiloSottile/age)
- Ensure you have SSH keys (`id_ed25519` or `id_rsa`) in your `~/.ssh` directory

### Installation

Clone the repository:

```sh
git clone https://github.com/mirql/secret-stash.git
cd SecretStash
```

### Usage 📘

Run `just` commands to perform various operations:

#### Initialize 🔑

```
just init
```

Initializes the encrypted directory and creates a keyfile. The keyfile is encrypted and stored securely. After initialization, a file with recipients will be available at `plain/recipients.txt`.

#### Open 🔓

```
just open
```

Decrypts the keyfile and mounts the encrypted directory so you can access your files.

#### Close 🔒

```
just close
```

Unmounts the encrypted directory to keep your files safe.

#### Update Recipients 📬

```
just update-recipients
```

Update the list of recipients who can decrypt the keyfile. Modify the `plain/recipients.txt` file before running this command.

## Important Notes 📌

- To change the list of recipients who can decrypt the keyfile, modify the `plain/recipients.txt` file and run the `update-recipients` command.
- SecretStash prefers `ed25519` keys over `rsa` keys. If you don't have `ed25519` keys, make sure to generate them for maximum security!

## Contributing 🤝

We welcome contributions! Feel free to submit pull requests, open issues, or fork the project to add your own spin.

## License 📄

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgements 🙏

- Big thanks to [gocryptfs](https://github.com/rfjakob/gocryptfs) and [age](https://github.com/FiloSottile/age) for making encryption easy and accessible.

---

Keep your secrets safe with SecretStash!
