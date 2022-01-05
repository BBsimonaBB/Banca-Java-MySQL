package com.company;

import javax.swing.*;
import javax.swing.border.EmptyBorder;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.*;

public class LichidareDepozit extends JFrame {
    private JPanel contentPane;
    private Connection connection;
    private JButton btnNewButton;
    private JTextField id_depozit = new JTextField(7);
    private JButton genereaza = new JButton("Lichidare depozit");

    public static void main(String[] args) {
        EventQueue.invokeLater(new Runnable() {
            public void run() {
                try {
                    DetaliiCont frame = new DetaliiCont();
                    frame.setVisible(true);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        });
    }

    public LichidareDepozit(int id, Connection connection){
        setBounds(450, 190, 500, 350);
        setResizable(false);
        contentPane = new JPanel();
        contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));
        setContentPane(contentPane);
        contentPane.setLayout(null);
        contentPane.add(id_depozit);
        contentPane.add(genereaza);
        JTextField mesaj1 = new JTextField("Introduceti ID-ul depozitului");
        mesaj1.setBounds(100,20,250,20);
        mesaj1.setEditable(false);
        contentPane.add(mesaj1);
        id_depozit.setBounds(100,140,150,20);

        genereaza.setBounds(100,200,200,50);

        genereaza.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                String finalUserInput = "";
                try {
                    String userInput = id_depozit.getText();
                    finalUserInput = userInput;
                } catch (NumberFormatException nfex) {
                    nfex.printStackTrace();
                }
                System.out.println(finalUserInput);
                try {
                    PreparedStatement st = (PreparedStatement) connection
                            .prepareStatement("Call lichidare_depozit(?,0);");

                    st.setString(1, finalUserInput);
                    ResultSet rs = st.executeQuery();


                    int suma = 0;
                    try(Statement stmt = connection.createStatement()) {
                        ResultSet rs2 = stmt.executeQuery("Select * from depozit ");
                        while(rs2.next()) {
                            if(finalUserInput.equals(String.valueOf(rs2.getInt("id"))))
                            {
                                suma = rs2.getInt("suma_depozit");
                            }
                        }
                    } catch (SQLException e2) {
                        e2.printStackTrace();
                    }
                    System.out.println(suma);
                    if(suma > 500000)
                        JOptionPane.showMessageDialog(btnNewButton, "Suma e mai mare de 500000. Se asteapta acceptul unui admin");
                    else
                        JOptionPane.showMessageDialog(btnNewButton, "Depozitul dumneavoastra din contul cu IBAN-ul " + finalUserInput + " a fost lichidat");
                    //dispose();
                    // setVisible(false);


                } catch (SQLException throwables) {
                    throwables.printStackTrace();
                }
            }
        });
    }
}
