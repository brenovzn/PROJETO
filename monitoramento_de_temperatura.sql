-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 28/05/2025 às 03:42
-- Versão do servidor: 10.4.32-MariaDB
-- Versão do PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `monitoramento_de_temperatura`
--

DELIMITER $$
--
-- Procedimentos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `excluir_registros_antigos` ()   BEGIN
    DELETE FROM registro_temperatura 
    WHERE data_hora < NOW() - INTERVAL 30 DAY;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `excluir_usuario` (IN `p_id_usuario` INT)   BEGIN
    DELETE FROM login WHERE id_usuario = p_id_usuario;
    DELETE FROM usuario WHERE id = p_id_usuario;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `inserir_registro_temperatura` (IN `p_temperatura` DECIMAL(5,2), IN `p_id_usuario` INT)   BEGIN
    INSERT INTO registro_temperatura (temperatura, id_usuario)
    VALUES (p_temperatura, p_id_usuario);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `inserir_usuario` (IN `p_nome` VARCHAR(255), IN `p_cpf` VARCHAR(14), IN `p_telefone` VARCHAR(20), IN `p_email` VARCHAR(255), IN `p_senha` VARCHAR(255))   BEGIN
    INSERT INTO usuario (nome, cpf, telefone, email, senha)
    VALUES (p_nome, p_cpf, p_telefone, p_email, p_senha);
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura para tabela `login`
--

CREATE TABLE `login` (
  `id_login` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `nome_usuario` varchar(100) NOT NULL,
  `senha` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `log_usuarios`
--

CREATE TABLE `log_usuarios` (
  `id_log` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `excluido_em` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `log_usuarios`
--

INSERT INTO `log_usuarios` (`id_log`, `usuario_id`, `excluido_em`) VALUES
(1, 5, '2025-05-27 21:25:57');

-- --------------------------------------------------------

--
-- Estrutura para tabela `registro_temperatura`
--

CREATE TABLE `registro_temperatura` (
  `id_registro` int(11) NOT NULL,
  `temperatura` decimal(5,2) NOT NULL,
  `data_hora` datetime DEFAULT current_timestamp(),
  `id_usuario` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `usuario`
--

CREATE TABLE `usuario` (
  `id` int(11) NOT NULL,
  `nome` varchar(255) NOT NULL,
  `cpf` varchar(14) NOT NULL,
  `email` varchar(255) NOT NULL,
  `telefone` varchar(20) DEFAULT NULL,
  `senha` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `usuario`
--

INSERT INTO `usuario` (`id`, `nome`, `cpf`, `email`, `telefone`, `senha`) VALUES
(1, 'Teste', '12345678900', 'teste@example.com', '11999999999', '123456'),
(2, 'Breno', '11111111111', 'breno@gmail.com', '00000000000', '101010'),
(3, 'pos', '55555555555', 'projeto@email.com', '66667777777', '0000'),
(4, 'Robson', '1111111111', 'robson@email.com', '2212121212121', '1234');

--
-- Acionadores `usuario`
--
DELIMITER $$
CREATE TRIGGER `log_exclusao_usuario` BEFORE DELETE ON `usuario` FOR EACH ROW BEGIN
    INSERT INTO log_usuarios (usuario_id, excluido_em)
    VALUES (OLD.id, NOW());
END
$$
DELIMITER ;

--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `login`
--
ALTER TABLE `login`
  ADD PRIMARY KEY (`id_login`),
  ADD UNIQUE KEY `nome_usuario` (`nome_usuario`),
  ADD KEY `id_usuario` (`id_usuario`);

--
-- Índices de tabela `log_usuarios`
--
ALTER TABLE `log_usuarios`
  ADD PRIMARY KEY (`id_log`);

--
-- Índices de tabela `registro_temperatura`
--
ALTER TABLE `registro_temperatura`
  ADD PRIMARY KEY (`id_registro`),
  ADD KEY `id_usuario` (`id_usuario`);

--
-- Índices de tabela `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `cpf` (`cpf`);

--
-- AUTO_INCREMENT para tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `login`
--
ALTER TABLE `login`
  MODIFY `id_login` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `log_usuarios`
--
ALTER TABLE `log_usuarios`
  MODIFY `id_log` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de tabela `registro_temperatura`
--
ALTER TABLE `registro_temperatura`
  MODIFY `id_registro` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `usuario`
--
ALTER TABLE `usuario`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Restrições para tabelas despejadas
--

--
-- Restrições para tabelas `login`
--
ALTER TABLE `login`
  ADD CONSTRAINT `login_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id`);

--
-- Restrições para tabelas `registro_temperatura`
--
ALTER TABLE `registro_temperatura`
  ADD CONSTRAINT `registro_temperatura_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
