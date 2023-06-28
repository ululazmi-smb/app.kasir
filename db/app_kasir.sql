-- phpMyAdmin SQL Dump
-- version 4.9.5deb2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jun 29, 2023 at 04:44 AM
-- Server version: 8.0.33-0ubuntu0.20.04.2
-- PHP Version: 7.4.3-4ubuntu2.18

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `app.kasir`
--

-- --------------------------------------------------------

--
-- Table structure for table `menu`
--

CREATE TABLE `menu` (
  `id` int NOT NULL,
  `title` varchar(100) NOT NULL,
  `description` varchar(100) NOT NULL,
  `image` text NOT NULL,
  `price` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `menu`
--

INSERT INTO `menu` (`id`, `title`, `description`, `image`, `price`) VALUES
(1, 'nasi ganteng', 'nasi goreng kecap manis di buat dengan kecap malika pilihan yang sangat lezat', 'asset/img/nasgor.jpg', 10000),
(2, 'mie goreng', 'nasi goreng kecap manis di buat dengan kecap malika pilihan yang sangat lezat', 'asset/img/miegoreng.jpg', 10000),
(12, 'ayam geprek', 'ok', 'asset/img/bae57a11fb9f8a28325126fe27cb01c8images.jpg', 12000);

-- --------------------------------------------------------

--
-- Table structure for table `pesanan`
--

CREATE TABLE `pesanan` (
  `kode_pesanan` varchar(255) NOT NULL,
  `detail` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `paidamount` int NOT NULL DEFAULT '0',
  `tanggal` date NOT NULL,
  `jam` time NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `pesanan`
--

INSERT INTO `pesanan` (`kode_pesanan`, `detail`, `paidamount`, `tanggal`, `jam`) VALUES
('BR00001', '[{\"title\":\"mie goreng\",\"price\":10000,\"quantity\":3}]', 0, '2023-06-27', '05:17:09'),
('BR00002', '[{\"title\":\"ayam geprek\",\"price\":12000,\"quantity\":2},{\"title\":\"mie goreng\",\"price\":10000,\"quantity\":1}]', 50000, '2023-06-27', '18:40:01');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id` int NOT NULL,
  `username` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  `admin` enum('0','1') NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `username`, `password`, `admin`) VALUES
(1, 'superadmin', '21232f297a57a5a743894a0e4a801fc3', '0');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `menu`
--
ALTER TABLE `menu`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `menu`
--
ALTER TABLE `menu`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
