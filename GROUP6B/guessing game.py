import sys
answer = 6
count = 0
user_input = ""

while count != 3:
        count += 1
        user_input = int(input("Please guess a number : "))

        if user_input == answer:
            print("You got it !")
            sys.exit()
        else:
            print("Try again")

print("\nTries exceeded.")
