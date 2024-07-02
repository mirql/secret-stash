KEYFILE := "gocryptfs.key"
ENCRYPTED_KEYFILE := "gocryptfs.key.age"
ENCRYPTED_DIR := "encrypted"
PLAIN_DIR := "plain"
ENCRYPTED_RECIPIENTS_FILE := PLAIN_DIR + "/recipients.txt"
USER_PRIVATE_KEY := `if [ -f ~/.ssh/id_ed25519 ]; then echo ~/.ssh/id_ed25519; else echo ~/.ssh/id_rsa; fi`
USER_PUBLIC_KEY := `if [ -f ~/.ssh/id_ed25519.pub ]; then echo ~/.ssh/id_ed25519.pub; else echo ~/.ssh/id_rsa.pub; fi`

help:
	@echo "Usage: just [TARGET]"
	@echo "Targets:"
	@echo "  init:               Initialize an encrypted directory"
	@echo "  open:               Decrypt the keyfile and mount the encrypted directory"
	@echo "  close:              Unmount the encrypted directory"
	@echo "  update-recipients:  Update the recipients of the encrypted directory"
	@echo "  update-justfile:    Redownload the justfile from the given URL"
	@echo ""
	@echo "Note: To change the list of recipients who can decrypt the keyfile, modify the \"{{ENCRYPTED_RECIPIENTS_FILE}}\" file and run the update-recipients command."

init:
	@echo "Initializing encrypted directory and creating keyfile..."
	mkdir -p {{ENCRYPTED_DIR}} {{PLAIN_DIR}}
	dd if=/dev/urandom bs=32 count=1 of={{KEYFILE}}
	gocryptfs -init -passfile {{KEYFILE}} {{ENCRYPTED_DIR}} && \
	age -R {{USER_PUBLIC_KEY}} -a -o {{ENCRYPTED_KEYFILE}} {{KEYFILE}} && \
	rm -f {{KEYFILE}} && \
	age -d -i {{USER_PRIVATE_KEY}} -o - {{ENCRYPTED_KEYFILE}} | gocryptfs {{ENCRYPTED_DIR}} {{PLAIN_DIR}} && \
	cat {{USER_PUBLIC_KEY}} > {{ENCRYPTED_RECIPIENTS_FILE}} && \
	echo -e "\nDecrypted folder mounted to \"{{PLAIN_DIR}}\"" && \
	echo -e "You can check the list of recipients who can decrypt it in \"{{ENCRYPTED_RECIPIENTS_FILE}}\"" || \
	echo -e "\nFailed to decrypt the keyfile"

open:
	@echo "Mounting the encrypted directory..."
	mkdir -p {{PLAIN_DIR}}
	age -d -i {{USER_PRIVATE_KEY}} -o - {{ENCRYPTED_KEYFILE}} | gocryptfs {{ENCRYPTED_DIR}} {{PLAIN_DIR}} && \
	echo -e "\nMounted successfully" || \
	echo -e "\nMounting error"

close:
	@echo "Unmounting the encrypted directory..."
	fusermount -u {{PLAIN_DIR}} && \
	echo "Unmounted successfully" || \
	echo "Unmount error"

update-recipients:
	@echo "Updating recipients..."
	cat {{ENCRYPTED_KEYFILE}} | \
	age -d -i {{USER_PRIVATE_KEY}} -o - | \
	age -R {{ENCRYPTED_RECIPIENTS_FILE}} -a -o {{ENCRYPTED_KEYFILE}} && \
	echo "Recipients updated successfully" || \
	echo "Recipients update error"

update-justfile:
	curl -O https://raw.githubusercontent.com/mirql/secret-stash/main/justfile && \
	echo "justfile updated successfully" || \
	echo "justfile update error"
