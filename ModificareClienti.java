package com.company;

import javax.swing.*;
import javax.swing.border.EmptyBorder;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class ModificareClienti extends JFrame {
    private JPanel contentPane;
    int id;
    private Connection connection;
    private JButton btnNewButton;
    private JTextField camp = new JTextField(7);
    private JTextField text_nou = new JTextField(7);
    private JTextField id_modificat = new JTextField(7);
    private JButton genereaza = new JButton("Salvati modificarile");

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

    public ModificareClienti(int id, Connection connection){
        this.id =id;
        setBounds(450, 190, 600, 350);
        setResizable(false);
        contentPane = new JPanel();
        contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));
        setContentPane(contentPane);
        contentPane.setLayout(null);
        contentPane.add(camp);
        contentPane.add(text_nou);
        contentPane.add(id_modificat);
        contentPane.add(genereaza);
        JTextField mesaj1 = new JTextField("Introduceti campul de modificat (tip,adresa,nume,prenume,telefon,email)");
        mesaj1.setBounds(100,20,400,20);
        mesaj1.setEditable(false);
        contentPane.add(mesaj1);
        JTextField mesaj2 = new JTextField("Introduceti modificarea");
        mesaj2.setBounds(100,70,250,20);
        mesaj2.setEditable(false);
        contentPane.add(mesaj2);
        JTextField mesaj3 = new JTextField("Introduceti ID-ul clientului de modificat");
        mesaj3.setBounds(100,120,250,20);
        mesaj3.setEditable(false);
        contentPane.add(mesaj3);
        camp.setBounds(100,40,150,20);
        text_nou.setBounds(100,90,150,20);
        id_modificat.setBounds(100,140,150,20);

        genereaza.setBounds(100,200,200,50);

        genereaza.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                String finalUserInput = "";
                String finalUserInput2 = "";
                int finalUserInput3 = 0;
                try {
                    String userInput = camp.getText();
                    finalUserInput = userInput;

                    String userInput2 = text_nou.getText();
                    finalUserInput2 = userInput2;

                    String userInput3 = id_modificat.getText();
                    finalUserInput3 = Integer.parseInt(userInput3);


                } catch (NumberFormatException nfex) {
                    nfex.printStackTrace();
                }
                if(finalUserInput.equals("adresa")) {
                    try {
                        System.out.println(finalUserInput);
                        PreparedStatement st = (PreparedStatement) connection
                                .prepareStatement("UPDATE utilizator SET adresa = ? WHERE id  = ?");

                        // st.setString(1, finalUserInput);
                        st.setString(1, finalUserInput2);
                        st.setInt(2, finalUserInput3);
                        JOptionPane.showMessageDialog(btnNewButton, "Datele au fost modificate");
                        //int rs =
                        st.executeUpdate();
                    } catch (SQLException throwables) {
                        throwables.printStackTrace();
                    }
                }
                if(finalUserInput.equals("tip")) {
                    try {
                        System.out.println(finalUserInput);
                        PreparedStatement st = (PreparedStatement) connection
                                .prepareStatement("UPDATE utilizator SET tip = ? WHERE id  = ?");

                        // st.setString(1, finalUserInput);
                        st.setString(1, finalUserInput2);
                        st.setInt(2, finalUserInput3);
                        JOptionPane.showMessageDialog(btnNewButton, "Datele au fost modificate");
                        //int rs =
                        st.executeUpdate();
                    } catch (SQLException throwables) {
                        throwables.printStackTrace();
                    }
                }
                if(finalUserInput.equals("prenume")) {
                    try {
                        System.out.println(finalUserInput);
                        PreparedStatement st = (PreparedStatement) connection
                                .prepareStatement("UPDATE utilizator SET prenume = ? WHERE id  = ?");

                        // st.setString(1, finalUserInput);
                        st.setString(1, finalUserInput2);
                        st.setInt(2, finalUserInput3);
                        JOptionPane.showMessageDialog(btnNewButton, "Datele au fost modificate");
                        //int rs =
                        st.executeUpdate();
                    } catch (SQLException throwables) {
                        throwables.printStackTrace();
                    }
                }
                if(finalUserInput.equals("nume")) {
                    try {
                        System.out.println(finalUserInput);
                        PreparedStatement st = (PreparedStatement) connection
                                .prepareStatement("UPDATE utilizator SET nume = ? WHERE id  = ?");

                        // st.setString(1, finalUserInput);
                        st.setString(1, finalUserInput2);
                        st.setInt(2, finalUserInput3);
                        JOptionPane.showMessageDialog(btnNewButton, "Datele au fost modificate");
                        //int rs =
                        st.executeUpdate();
                    } catch (SQLException throwables) {
                        throwables.printStackTrace();
                    }
                }
                if(finalUserInput.equals("telefon")) {
                    try {
                        System.out.println(finalUserInput);
                        PreparedStatement st = (PreparedStatement) connection
                                .prepareStatement("UPDATE utilizator SET telefon = ? WHERE id  = ?");

                        // st.setString(1, finalUserInput);
                        st.setString(1, finalUserInput2);
                        st.setInt(2, finalUserInput3);
                        JOptionPane.showMessageDialog(btnNewButton, "Datele au fost modificate");
                        //int rs =
                        st.executeUpdate();
                    } catch (SQLException throwables) {
                        throwables.printStackTrace();
                    }
                }
                if(finalUserInput.equals("email")) {
                    try {
                        System.out.println(finalUserInput);
                        PreparedStatement st = (PreparedStatement) connection
                                .prepareStatement("UPDATE utilizator SET email = ? WHERE id  = ?");

                        // st.setString(1, finalUserInput);
                        st.setString(1, finalUserInput2);
                        st.setInt(2, finalUserInput3);
                        JOptionPane.showMessageDialog(btnNewButton, "Datele au fost modificate");
                        //int rs =
                        st.executeUpdate();
                    } catch (SQLException throwables) {
                        throwables.printStackTrace();
                    }
                }
            }
        });
    }
}
