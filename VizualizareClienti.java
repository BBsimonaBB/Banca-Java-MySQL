package com.company;

import javax.swing.*;
import javax.swing.border.EmptyBorder;
import java.awt.*;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class VizualizareClienti extends JFrame {
    private JPanel contentPane;
    private Connection connection;

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
    public VizualizareClienti(int id, Connection connection) {
        //setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setBounds(400, 190, 910, 400);
        setResizable(false);
        contentPane = new JPanel();
        contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));
        setContentPane(contentPane);
        contentPane.setLayout(null);
        int x=100;
                    try (Statement stmt2 = connection.createStatement()) {
                        ResultSet rs3 = stmt2.executeQuery("Select * from utilizator");
                        while (rs3.next()) {
                                JTextField tip = new JTextField();
                                if(rs3.getInt("tip") == 0)
                                     tip.setText("Admin");
                                if(rs3.getInt("tip") == 1)
                                    tip.setText("Angajat");
                                if(rs3.getInt("tip") == 2)
                                    tip.setText("Client");
                                JTextField nume = new JTextField("Nume:  " + rs3.getString("nume"));
                                JTextField prenume = new JTextField("Prenume:  " + rs3.getString("prenume"));
                                JTextField iban = new JTextField("IBAN:  " + rs3.getString("iban"));
                                JTextField adresa = new JTextField("Adresa: " + rs3.getString("adresa"));
                                JTextField telefon = new JTextField("Telefon: " + rs3.getString("telefon"));
                                JTextField email = new JTextField("Email: " + rs3.getString("email"));
                                tip.setBounds(30,x,50,20);
                                iban.setBounds(80, x, 150, 20);
                                nume.setBounds(230, x, 100, 20);
                                prenume.setBounds(330, x, 100, 20);
                                adresa.setBounds(430,x,100,20);
                                telefon.setBounds(530,x,170,20);
                                email.setBounds(700,x,180,20);
                                contentPane.add(tip);
                                contentPane.add(nume);
                                contentPane.add(prenume);
                                contentPane.add(iban);
                                contentPane.add(adresa);
                                contentPane.add(telefon);
                                contentPane.add(email);
                                tip.setEditable(false);
                                iban.setEditable(false);
                                nume.setEditable(false);
                                prenume.setEditable(false);
                                adresa.setEditable(false);
                                telefon.setEditable(false);
                                email.setEditable(false);
                                x = x+20;

                        }
                    } catch (SQLException sqlException) {
                        sqlException.printStackTrace();
                    }
            }
}
