const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');

const app = express();
const port = 3000;

app.use(cors());  // ✅ Habilitar CORS
app.use(express.json());  // ✅ Habilitar JSON no body

// 🔹 Conexão com o banco
const connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'monitoramento_de_temperatura',
  port: 3306
});

connection.connect(err => {
  if (err) {
    console.error('❌ Erro ao conectar ao MySQL:', err.message);
  } else {
    console.log('✅ Conectado ao banco de dados MySQL com sucesso!');
  }
});

// 🔹 ROTAS USUÁRIO

// GET - Listar todos
app.get('/usuarios', (req, res) => {
  connection.query('SELECT * FROM usuario', (err, results) => {
    if (err) return res.status(500).send('Erro ao buscar usuários');
    res.json(results);
  });
});

// GET - Buscar por ID
app.get('/usuarios/:id', (req, res) => {
  const { id } = req.params;
  connection.query('SELECT * FROM usuario WHERE id = ?', [id], (err, results) => {
    if (err) return res.status(500).send('Erro ao buscar usuário');
    if (results.length === 0) return res.status(404).send('Usuário não encontrado');
    res.json(results[0]);
  });
});

// POST - Criar
app.post('/usuarios', (req, res) => {
  const { nome, cpf, telefone, email, senha } = req.body;
  const query = 'INSERT INTO usuario (nome, cpf, telefone, email, senha) VALUES (?, ?, ?, ?, ?)';
  connection.query(query, [nome, cpf, telefone, email, senha], (err, result) => {
    if (err) return res.status(500).send('Erro ao criar usuário');
    res.status(201).json({ id: result.insertId, ...req.body });
  });
});

// POST - Login
app.post('/login', (req, res) => {
  const { email, senha } = req.body;
  const query = 'SELECT * FROM usuario WHERE email = ? AND senha = ?';
  connection.query(query, [email, senha], (err, results) => {
    if (err) return res.status(500).send('Erro ao buscar usuário');
    if (results.length === 0) return res.status(401).send('Credenciais inválidas');
    res.json({ mensagem: 'Login bem-sucedido', usuario: results[0] });
  });
});


// PUT - Atualizar
app.put('/usuarios/:id', (req, res) => {
  const { id } = req.params;
  const { nome, cpf, telefone, email, senha } = req.body;
  const query = 'UPDATE usuario SET nome = ?, cpf = ?, telefone = ?, email = ?, senha = ? WHERE id = ?';
  connection.query(query, [nome, cpf, telefone, email, senha, id], (err) => {
    if (err) return res.status(500).send('Erro ao atualizar usuário');
    res.send('Usuário atualizado com sucesso');
  });
});

// DELETE - Excluir
app.delete('/usuarios/:id', (req, res) => {
  const { id } = req.params;
  const query = 'DELETE FROM usuario WHERE id = ?';
  connection.query(query, [id], (err) => {
    if (err) return res.status(500).send('Erro ao excluir usuário');
    res.send('Usuário excluído com sucesso');
  });
});

// 🔹 INICIAR SERVIDOR
app.listen(port, () => {
  console.log(`✅ Servidor rodando em http://localhost:${port}`);
});
