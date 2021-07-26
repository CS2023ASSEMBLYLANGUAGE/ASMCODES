import java.util.*;
public class Main {
    public static void main(String[] args) throws Exception {
        int count = 0;
        int answer = 6;
        int user_input = 0;
        Scanner ip = new Scanner(System.in);
        while (count != 3){
        
            System.out.println("Guess a number.");
            user_input = ip.nextInt();
            ip.nextLine();

            if (user_input == answer) {
                System.out.println("You got it ! ");
                System.exit(0);
            }
            else{
                System.out.println("Try again.");
            }
        }
        System.out.println("\nTries exceeded!");
        ip.close();
    }
}
