-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Jun 07, 2024 at 03:31 PM
-- Server version: 10.4.22-MariaDB
-- PHP Version: 8.0.13

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `Const`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `login` (IN `userId` INT, IN `ip_address` VARCHAR(30))  NO SQL
BEGIN
     DECLARE custom_error CONDITION FOR SQLSTATE '45000';
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        DECLARE error_msg TEXT;
        GET DIAGNOSTICS CONDITION 1 error_msg = MESSAGE_TEXT;
        ROLLBACK;
        SELECT CONCAT('error: ', error_msg) AS response_msg;
    END;

    START TRANSACTION; 

    -- Check if the user is already logged in
    SET @existing_login = CONCAT('SELECT COUNT(*) INTO @existing_log FROM user_logs WHERE user_id = ', userId, ' AND user_log_status = ''I''');
    
    PREPARE stmt FROM @existing_login;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
  --  SELECT @existing_log AS existing_login_count;

    IF @existing_log > 0 THEN
        -- Update the user log status to 'O' and logout time if the user already exists
        SET @update_log = CONCAT('UPDATE user_logs SET logout_time = NOW(), user_log_status = ''O'' WHERE user_id = ', userId, ' AND user_log_status = ''I''');
        PREPARE updateStmt FROM @update_log;
        EXECUTE updateStmt;
        DEALLOCATE PREPARE updateStmt;
        
        -- After updating the existing status, insert the new user log status        
        SET @insert_log = CONCAT('INSERT INTO user_logs (user_id, ip_address, login_date, login_time, user_log_status, user_log_entry_date, created_at, updated_at) VALUES (', userId, ', ''', ip_address, ''', NOW(), NOW(), ''I'', NOW(), NOW(), NOW())');
        PREPARE insertStmt FROM @insert_log;
        EXECUTE insertStmt;
        DEALLOCATE PREPARE insertStmt;
        
    ELSE
        -- If the user does not exist, insert the user log status into the user_logs table 
        SET @insert_log = CONCAT('INSERT INTO user_logs (user_id, ip_address, login_date, login_time, user_log_status, user_log_entry_date, created_at, updated_at) VALUES (', userId, ', ''', ip_address, ''', NOW(), NOW(), ''I'', NOW(), NOW(), NOW())');
        PREPARE insertStmt FROM @insert_log;
        EXECUTE insertStmt;
        DEALLOCATE PREPARE insertStmt;
    END IF;
  
    SELECT 'success' AS response_msg;

     COMMIT;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `cruds`
--

CREATE TABLE `cruds` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `model` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `route` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `icon` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'fas fa-bars',
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `built` tinyint(1) NOT NULL DEFAULT 0,
  `with_acl` tinyint(1) NOT NULL DEFAULT 0,
  `with_policy` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `languages`
--

CREATE TABLE `languages` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 NOT NULL,
  `code` varchar(2) CHARACTER SET utf8mb4 NOT NULL,
  `status` varchar(255) CHARACTER SET utf8mb4 NOT NULL DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `languages`
--

INSERT INTO `languages` (`id`, `name`, `code`, `status`, `created_at`, `updated_at`) VALUES
(1, 'English', '24', 'active', '2024-05-28 14:35:53', '2024-06-03 13:54:30'),
(2, 'Tamil', '25', 'active', '2024-05-28 14:35:53', '2024-06-03 13:08:52'),
(3, 'Hindi', '29', 'active', '2024-05-28 14:35:53', '2024-06-03 13:37:45');

-- --------------------------------------------------------

--
-- Table structure for table `master_constituency`
--

CREATE TABLE `master_constituency` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `constituency` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `master_constituency`
--

INSERT INTO `master_constituency` (`id`, `constituency`, `created_at`, `updated_at`) VALUES
(1, 'Chennai', '2024-05-29 04:46:30', '2024-06-03 13:42:13'),
(2, 'Madurai', '2024-05-29 04:46:30', '2024-06-03 13:42:31'),
(3, 'Nellai', '2024-05-29 04:46:30', '2024-06-03 13:54:30'),
(4, 'Covai', '2024-05-29 04:46:30', '2024-06-03 13:41:56'),
(5, 'Virudhunagar', '2024-05-29 04:46:30', '2024-06-03 11:47:25');

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2014_10_12_000000_create_users_table', 1),
(2, '2014_10_12_100000_create_password_resets_table', 1),
(3, '2019_08_19_000000_create_failed_jobs_table', 1),
(4, '2019_12_14_000001_create_personal_access_tokens_table', 1),
(5, '2024_05_29_155331_create_master_constituency_table', 1),
(6, '2024_05_29_160533_create_master_language_table', 2),
(7, '2024_05_29_160953_create_store_constituency_table', 3),
(8, '2024_06_03_101026_update_store_constituency_table_make_link_nullable', 4),
(9, '2014_10_12_200000_add_two_factor_columns_to_users_table', 5),
(10, '2024_06_04_074318_create_sessions_table', 5),
(11, '2024_06_04_999999_create_cruds_table_easypanel', 6),
(12, '2024_06_04_999999_create_panel_admins_table_easypanel', 6),
(13, '2024_06_04_999999_create_roles_table', 6),
(14, '2024_06_07_051439_create_user_logs_table', 7),
(15, '2024_06_07_053027_create_user_logs_table', 8),
(16, '2024_06_07_055506_add_status_to_users_table', 9);

-- --------------------------------------------------------

--
-- Table structure for table `panel_admins`
--

CREATE TABLE `panel_admins` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `password_resets`
--

CREATE TABLE `password_resets` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `abilities` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `permissions` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `role_user`
--

CREATE TABLE `role_user` (
  `role_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `payload` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('26vIn5IbCTmmByNvrz3jQp971bgFD8FrwmyWCKhw', 1, '127.0.0.1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36', 'YTo2OntzOjk6Il9wcmV2aW91cyI7YToxOntzOjM6InVybCI7czoyNjoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL2hvbWUiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX1zOjY6Il90b2tlbiI7czo0MDoiZnBZSE1FZGxsS3FoTzIxb2NuRXhGeDZ0SVhNNlkxOGVyRFVUN1NsZCI7czo1MDoibG9naW5fd2ViXzU5YmEzNmFkZGMyYjJmOTQwMTU4MGYwMTRjN2Y1OGVhNGUzMDk4OWQiO2k6MTtzOjEwOiJsb2dpbl90aW1lIjtPOjI1OiJJbGx1bWluYXRlXFN1cHBvcnRcQ2FyYm9uIjozOntzOjQ6ImRhdGUiO3M6MjY6IjIwMjQtMDYtMDcgMTc6MzU6MzguNTA3MzAwIjtzOjEzOiJ0aW1lem9uZV90eXBlIjtpOjM7czo4OiJ0aW1lem9uZSI7czoxMjoiQXNpYS9Lb2xrYXRhIjt9czo3OiJ1c2VyX2lkIjtpOjE7fQ==', 1717761938),
('gChL6giCs1GizSthCqnQMuLjnW2FKJOYBykHfEvA', NULL, '127.0.0.1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36', 'YTozOntzOjk6Il9wcmV2aW91cyI7YToxOntzOjM6InVybCI7czoyNzoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL2xvZ2luIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319czo2OiJfdG9rZW4iO3M6NDA6IktSeDlxbW8zQ2d2WWd1ZXBMZ1ZlVmJuNW9NcGxqZ05DZlBJWW8zWGgiO30=', 1717766995),
('NZ86xSvT0vaBiTYHSgCt5aF0sHVYbtvJzEjJOolz', NULL, '127.0.0.1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSE5MRTk5UTg0Vzh4VFZ4U2x5aDNzaEJEUWZQM2ZrNldGR2hNWFJuciI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6Mjc6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9sb2dpbiI7fX0=', 1717764899),
('RS1L6BRd44CfbOEv9mG9TfaiBm9aidiSrvWuJKZB', 1, '127.0.0.1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36', 'YTo2OntzOjk6Il9wcmV2aW91cyI7YToxOntzOjM6InVybCI7czoyNjoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL2hvbWUiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX1zOjY6Il90b2tlbiI7czo0MDoiZDIyWEhMZHFic0dnNG5zYU5ReWtZNjE5akx3R2owQXR6Z3g2YUlmOCI7czo1MDoibG9naW5fd2ViXzU5YmEzNmFkZGMyYjJmOTQwMTU4MGYwMTRjN2Y1OGVhNGUzMDk4OWQiO2k6MTtzOjEwOiJsb2dpbl90aW1lIjtPOjI1OiJJbGx1bWluYXRlXFN1cHBvcnRcQ2FyYm9uIjozOntzOjQ6ImRhdGUiO3M6MjY6IjIwMjQtMDYtMDcgMTg6NTk6NDguMTgzNDYzIjtzOjEzOiJ0aW1lem9uZV90eXBlIjtpOjM7czo4OiJ0aW1lem9uZSI7czoxMjoiQXNpYS9Lb2xrYXRhIjt9czo3OiJ1c2VyX2lkIjtpOjE7fQ==', 1717766988),
('xFZqsGf2AI93UzDtid1XG3X91t6dtvE6zyJQB4Sq', NULL, '127.0.0.1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36', 'YTo0OntzOjk6Il9wcmV2aW91cyI7YToxOntzOjM6InVybCI7czoyNzoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL2xvZ2luIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319czo2OiJfdG9rZW4iO3M6NDA6Ik81OEQ2Zllaa2Z2d3A1aGpocjRUSU00NDNMcGZ0UUZaUEdMd1FONnoiO3M6MzoidXJsIjthOjE6e3M6ODoiaW50ZW5kZWQiO3M6MjY6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9ob21lIjt9fQ==', 1717766324);

-- --------------------------------------------------------

--
-- Table structure for table `store_constituency`
--

CREATE TABLE `store_constituency` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `constituency_id` int(11) NOT NULL,
  `language_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `link` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `store_constituency`
--

INSERT INTO `store_constituency` (`id`, `constituency_id`, `language_id`, `description`, `link`, `created_at`, `updated_at`, `status`) VALUES
(1, 1, '2', 'hello', 'https://web.whatsapp.com1/', '2024-06-06 13:42:55', '2024-06-06 13:50:30', 'D'),
(2, 2, '1', 'Hello Word', 'https://web.whatsapp.com1/', '2024-06-06 13:56:15', '2024-06-06 13:56:15', 'Y'),
(3, 2, '2', 'hello welcome', 'https://web.whatsapp.com1/', '2024-06-06 14:04:36', '2024-06-06 14:04:36', 'Y'),
(5, 1, '1', 'hello', 'https://web.whatsapp.com/', '2024-06-07 06:35:43', '2024-06-07 06:35:43', 'D'),
(6, 1, '2', 'hello everyone', 'https://web.whatsapp.com/', '2024-06-07 10:00:08', '2024-06-07 10:00:08', 'Y'),
(7, 2, '3', 'hi Madurai', NULL, '2024-06-07 10:11:31', '2024-06-07 10:51:44', 'D'),
(8, 4, '3', 'hello', 'https://web.whatsapp.com/', '2024-06-07 10:51:29', '2024-06-07 10:51:29', 'Y'),
(9, 3, '2', 'hello', 'https://web.whatsapp.com/', '2024-06-07 11:10:53', '2024-06-07 11:10:53', 'Y');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `two_factor_secret` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `two_factor_recovery_codes` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `two_factor_confirmed_at` timestamp NULL DEFAULT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `user_status` char(1) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'I'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `two_factor_secret`, `two_factor_recovery_codes`, `two_factor_confirmed_at`, `remember_token`, `created_at`, `updated_at`, `user_status`) VALUES
(1, 'admin', '', NULL, '$2y$10$xEcaJL5ccR1NzG/RCmEXzuwZDuHk3X.9uWS0shkcA7JFDtKExZamy', NULL, NULL, NULL, NULL, '2024-06-01 07:41:48', '2024-06-05 07:05:33', 'I'),
(7, 'muthu', 'muthu@example.com', NULL, '$2y$10$1AlhHSfVyVfQHG5edk4RXeDKY/SDr5kQSEpBS9une.0/VbDh3UuJ6', NULL, NULL, NULL, NULL, '2024-06-05 12:50:27', '2024-06-05 12:50:27', 'I');

-- --------------------------------------------------------

--
-- Table structure for table `user_logs`
--

CREATE TABLE `user_logs` (
  `user_log_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `ip_address` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `login_date` date NOT NULL,
  `login_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `logout_time` timestamp NULL DEFAULT NULL,
  `user_log_status` char(1) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'I',
  `user_log_entry_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user_logs`
--

INSERT INTO `user_logs` (`user_log_id`, `user_id`, `ip_address`, `login_date`, `login_time`, `logout_time`, `user_log_status`, `user_log_entry_date`, `created_at`, `updated_at`) VALUES
(1, 1, '127.0.0.1', '2024-06-07', '2024-06-07 12:52:12', '2024-06-07 12:52:12', 'O', '2024-06-07 12:41:04', '2024-06-07 12:41:04', '2024-06-07 12:41:04'),
(2, 1, '127.0.0.1', '2024-06-07', '2024-06-07 12:53:41', '2024-06-07 12:53:41', 'O', '2024-06-07 12:52:12', '2024-06-07 12:52:12', '2024-06-07 12:53:41'),
(3, 1, '127.0.0.1', '2024-06-07', '2024-06-07 13:01:35', '2024-06-07 13:01:35', 'O', '2024-06-07 12:58:17', '2024-06-07 12:58:17', '2024-06-07 12:58:17'),
(4, 1, '127.0.0.1', '2024-06-07', '2024-06-07 13:09:13', '2024-06-07 13:09:13', 'O', '2024-06-07 13:01:35', '2024-06-07 13:01:35', '2024-06-07 13:01:35'),
(5, 1, '127.0.0.1', '2024-06-07', '2024-06-07 13:10:07', '2024-06-07 13:10:07', 'O', '2024-06-07 13:09:13', '2024-06-07 13:09:13', '2024-06-07 13:09:13'),
(6, 1, '127.0.0.1', '2024-06-07', '2024-06-07 13:10:26', '2024-06-07 13:10:26', 'O', '2024-06-07 13:10:07', '2024-06-07 13:10:07', '2024-06-07 13:10:07'),
(7, 1, '127.0.0.1', '2024-06-07', '2024-06-07 13:12:04', '2024-06-07 13:12:04', 'O', '2024-06-07 13:10:26', '2024-06-07 13:10:26', '2024-06-07 13:10:26'),
(8, 1, '127.0.0.1', '2024-06-07', '2024-06-07 13:12:20', '2024-06-07 13:12:20', 'O', '2024-06-07 13:12:04', '2024-06-07 13:12:04', '2024-06-07 13:12:04'),
(9, 1, '127.0.0.1', '2024-06-07', '2024-06-07 13:12:36', '2024-06-07 13:12:36', 'O', '2024-06-07 13:12:20', '2024-06-07 13:12:20', '2024-06-07 13:12:20'),
(10, 1, '127.0.0.1', '2024-06-07', '2024-06-07 13:13:10', '2024-06-07 13:13:10', 'O', '2024-06-07 13:12:36', '2024-06-07 13:12:36', '2024-06-07 13:12:36'),
(11, 1, '127.0.0.1', '2024-06-07', '2024-06-07 13:18:34', '2024-06-07 13:18:34', 'O', '2024-06-07 13:13:10', '2024-06-07 13:13:10', '2024-06-07 13:13:10'),
(12, 1, '127.0.0.1', '2024-06-07', '2024-06-07 13:20:23', '2024-06-07 13:20:23', 'O', '2024-06-07 13:18:34', '2024-06-07 13:18:34', '2024-06-07 13:18:34'),
(13, 1, '127.0.0.1', '2024-06-07', '2024-06-07 13:20:40', '2024-06-07 13:20:40', 'O', '2024-06-07 13:20:23', '2024-06-07 13:20:23', '2024-06-07 13:20:23'),
(14, 1, '127.0.0.1', '2024-06-07', '2024-06-07 13:21:14', '2024-06-07 13:21:14', 'O', '2024-06-07 13:20:40', '2024-06-07 13:20:40', '2024-06-07 13:21:14'),
(15, 1, '127.0.0.1', '2024-06-07', '2024-06-07 13:23:55', '2024-06-07 13:23:55', 'O', '2024-06-07 13:23:39', '2024-06-07 13:23:39', '2024-06-07 13:23:39'),
(16, 1, '127.0.0.1', '2024-06-07', '2024-06-07 13:24:01', '2024-06-07 13:24:01', 'O', '2024-06-07 13:23:55', '2024-06-07 13:23:55', '2024-06-07 13:24:01'),
(17, 7, '127.0.0.1', '2024-06-07', '2024-06-07 13:24:26', NULL, 'I', '2024-06-07 13:24:26', '2024-06-07 13:24:26', '2024-06-07 13:24:26'),
(18, 1, '127.0.0.1', '2024-06-07', '2024-06-07 13:28:36', '2024-06-07 13:28:36', 'O', '2024-06-07 13:24:58', '2024-06-07 13:24:58', '2024-06-07 13:24:58'),
(19, 1, '127.0.0.1', '2024-06-07', '2024-06-07 13:29:48', '2024-06-07 13:29:48', 'O', '2024-06-07 13:28:36', '2024-06-07 13:28:36', '2024-06-07 13:28:36'),
(20, 1, '127.0.0.1', '2024-06-07', '2024-06-07 13:29:48', NULL, 'I', '2024-06-07 13:29:48', '2024-06-07 13:29:48', '2024-06-07 13:29:48');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cruds`
--
ALTER TABLE `cruds`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `cruds_name_unique` (`name`),
  ADD UNIQUE KEY `cruds_model_unique` (`model`),
  ADD UNIQUE KEY `cruds_route_unique` (`route`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `languages`
--
ALTER TABLE `languages`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `languages_code_unique` (`code`);

--
-- Indexes for table `master_constituency`
--
ALTER TABLE `master_constituency`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `panel_admins`
--
ALTER TABLE `panel_admins`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `panel_admins_user_id_unique` (`user_id`);

--
-- Indexes for table `password_resets`
--
ALTER TABLE `password_resets`
  ADD KEY `password_resets_email_index` (`email`);

--
-- Indexes for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `role_user`
--
ALTER TABLE `role_user`
  ADD KEY `role_user_role_id_index` (`role_id`),
  ADD KEY `role_user_user_id_index` (`user_id`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indexes for table `store_constituency`
--
ALTER TABLE `store_constituency`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- Indexes for table `user_logs`
--
ALTER TABLE `user_logs`
  ADD PRIMARY KEY (`user_log_id`),
  ADD KEY `user_logs_user_id_foreign` (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `cruds`
--
ALTER TABLE `cruds`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `languages`
--
ALTER TABLE `languages`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `master_constituency`
--
ALTER TABLE `master_constituency`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `panel_admins`
--
ALTER TABLE `panel_admins`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `store_constituency`
--
ALTER TABLE `store_constituency`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `user_logs`
--
ALTER TABLE `user_logs`
  MODIFY `user_log_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `panel_admins`
--
ALTER TABLE `panel_admins`
  ADD CONSTRAINT `panel_admins_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `role_user`
--
ALTER TABLE `role_user`
  ADD CONSTRAINT `role_user_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `role_user_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `user_logs`
--
ALTER TABLE `user_logs`
  ADD CONSTRAINT `user_logs_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
