-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Nov 19, 2024 at 06:23 AM
-- Server version: 10.5.26-MariaDB
-- PHP Version: 8.1.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `pinsandpoker_main`
--

-- --------------------------------------------------------

--
-- Table structure for table `cards`
--

CREATE TABLE `cards` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `suit` enum('Clubs','Diamonds','Hearts','Spades') DEFAULT NULL,
  `rank` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `disputes`
--

CREATE TABLE `disputes` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `moderator_id` bigint(20) UNSIGNED NOT NULL,
  `game_id` bigint(20) UNSIGNED NOT NULL,
  `disputer_id` bigint(20) UNSIGNED NOT NULL,
  `disputed_against_id` bigint(20) UNSIGNED NOT NULL,
  `cell_index` varchar(255) DEFAULT NULL,
  `status` enum('pending','resolved') NOT NULL DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `games`
--

CREATE TABLE `games` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `league_id` bigint(20) UNSIGNED NOT NULL,
  `participants` int(11) NOT NULL DEFAULT 0,
  `name` varchar(255) DEFAULT NULL,
  `lane` int(11) DEFAULT NULL,
  `start_time` varchar(255) DEFAULT NULL,
  `status` enum('pending','started','ended') NOT NULL DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `games`
--

INSERT INTO `games` (`id`, `user_id`, `league_id`, `participants`, `name`, `lane`, `start_time`, `status`, `created_at`, `updated_at`) VALUES
(1, 4, 1, 0, 'Tuesday', 1, '0101PM', 'pending', '2024-11-19 15:35:31', '2024-11-19 15:35:31'),
(2, 4, 2, 0, 'Onee', 1, '0101AM', 'pending', '2024-11-19 15:46:29', '2024-11-19 15:46:29');

-- --------------------------------------------------------

--
-- Table structure for table `game_requests`
--

CREATE TABLE `game_requests` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `game_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `assigned_lane` int(11) DEFAULT NULL,
  `status` enum('pending','accepted') NOT NULL DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `game_requests`
--

INSERT INTO `game_requests` (`id`, `game_id`, `user_id`, `assigned_lane`, `status`, `created_at`, `updated_at`) VALUES
(1, 1, 6, NULL, 'pending', '2024-11-19 15:36:47', '2024-11-19 15:36:47'),
(2, 2, 6, NULL, 'pending', '2024-11-19 15:47:20', '2024-11-19 15:47:20');

-- --------------------------------------------------------

--
-- Table structure for table `game_scores`
--

CREATE TABLE `game_scores` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `game_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `rolls` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`rolls`)),
  `cell_scores` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`cell_scores`)),
  `cards` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`cards`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `leagues`
--

CREATE TABLE `leagues` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `participants` int(11) NOT NULL DEFAULT 0,
  `prize_pool` int(11) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `start_time` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `leagues`
--

INSERT INTO `leagues` (`id`, `user_id`, `name`, `participants`, `prize_pool`, `image`, `start_time`, `created_at`, `updated_at`) VALUES
(1, 4, 'Tuesday', 1, 1, 'uploads/images/moderator/leagues/league_igesnwTNWztnJpf0kHct6TdgIGYDaoBVp98PlSRt.png', '0100PM', '2024-11-19 15:34:56', '2024-11-19 15:36:24'),
(2, 4, 'Onee', 2, 1, 'uploads/images/moderator/leagues/league_ImM4hvqswUX478Wlc5xHD6OKufE5kiaKLUkcqmZF.png', '0100PM', '2024-11-19 15:44:40', '2024-11-19 15:47:10');

-- --------------------------------------------------------

--
-- Table structure for table `league_requests`
--

CREATE TABLE `league_requests` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `league_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `status` enum('pending','accepted') NOT NULL DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `league_requests`
--

INSERT INTO `league_requests` (`id`, `league_id`, `user_id`, `status`, `created_at`, `updated_at`) VALUES
(1, 1, 6, 'accepted', '2024-11-19 15:35:48', '2024-11-19 15:36:24'),
(3, 2, 6, 'accepted', '2024-11-19 15:45:07', '2024-11-19 15:47:10'),
(4, 2, 7, 'accepted', '2024-11-19 15:46:53', '2024-11-19 15:47:05');

-- --------------------------------------------------------

--
-- Table structure for table `league_rules`
--

CREATE TABLE `league_rules` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `league_id` bigint(20) UNSIGNED NOT NULL,
  `rule_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `league_rules`
--

INSERT INTO `league_rules` (`id`, `league_id`, `rule_id`, `created_at`, `updated_at`) VALUES
(1, 1, 3, '2024-11-19 15:34:56', '2024-11-19 15:34:56'),
(2, 1, 2, '2024-11-19 15:34:56', '2024-11-19 15:34:56'),
(3, 1, 12, '2024-11-19 15:34:56', '2024-11-19 15:34:56'),
(4, 2, 1, '2024-11-19 15:44:40', '2024-11-19 15:44:40'),
(5, 2, 2, '2024-11-19 15:44:40', '2024-11-19 15:44:40'),
(6, 2, 13, '2024-11-19 15:44:40', '2024-11-19 15:44:40');

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
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
(5, '2024_08_16_131103_create_leagues_table', 1),
(6, '2024_08_16_131129_create_rules_table', 1),
(7, '2024_08_16_143953_create_league_rules_table', 1),
(8, '2024_09_19_153203_create_league_requests_table', 1),
(9, '2024_09_23_110851_create_games_table', 1),
(10, '2024_09_25_175606_create_game_requests_table', 1),
(11, '2024_10_04_161443_create_cards_table', 1),
(12, '2024_11_06_130413_create_game_scores_table', 1),
(13, '2024_11_12_154450_create_disputes_table', 1);

-- --------------------------------------------------------

--
-- Table structure for table `password_resets`
--

CREATE TABLE `password_resets` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `created_at`, `updated_at`) VALUES
(1, 'App\\Models\\User', 6, 'PinsAndPoker', '8427ec84b411779b93c5202ec2650592c39abc62cb14786341de1c660ee3bf07', '[\"*\"]', '2024-11-19 15:36:46', '2024-11-19 15:32:46', '2024-11-19 15:36:46'),
(2, 'App\\Models\\User', 4, 'PinsAndPoker', '7096afeb2f3882280ae4c3b01e817b17b163b56769b0b4c018904bc30770be44', '[\"*\"]', '2024-11-19 15:49:46', '2024-11-19 15:33:42', '2024-11-19 15:49:46'),
(3, 'App\\Models\\User', 7, 'PinsAndPoker', '58578e1c26a305168f143bfebf6e309f3608296855859bb4e6f2dd3e6d00a131', '[\"*\"]', '2024-11-19 15:43:41', '2024-11-19 15:35:14', '2024-11-19 15:43:41'),
(4, 'App\\Models\\User', 6, 'PinsAndPoker', 'b1867db44ca9fde604ffec7ad9a88786106be0e3d679e82ab81aad56780b8c6f', '[\"*\"]', '2024-11-19 15:47:28', '2024-11-19 15:43:57', '2024-11-19 15:47:28'),
(5, 'App\\Models\\User', 7, 'PinsAndPoker', '4be373d2c6b6e1a0373d7357b1624f547e132544fab13fced01e285a34382b2b', '[\"*\"]', '2024-11-19 15:48:12', '2024-11-19 15:44:10', '2024-11-19 15:48:12'),
(6, 'App\\Models\\User', 7, 'PinsAndPoker', 'cc3a76449abe947d292f49ebfe6b5c29b195950122e59bdba6c00b75c8a44532', '[\"*\"]', '2024-11-19 16:17:26', '2024-11-19 15:51:35', '2024-11-19 16:17:26');

-- --------------------------------------------------------

--
-- Table structure for table `rules`
--

CREATE TABLE `rules` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `type` enum('general','special') DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `rules`
--

INSERT INTO `rules` (`id`, `user_id`, `type`, `description`, `created_at`, `updated_at`) VALUES
(1, 1, 'special', 'Strike awards the particular player a card', '2024-11-19 15:28:22', '2024-11-19 15:28:22'),
(2, 1, 'special', 'Spare awards the particular player a card', '2024-11-19 15:28:22', '2024-11-19 15:28:22'),
(3, 1, 'special', 'Minimum 1 card in hand to Minimum 5 cards in hand with interchangeable cards from onwards on a strike (new card before accepting would be visible to the user)', '2024-11-19 15:28:22', '2024-11-19 15:28:22'),
(4, 1, 'special', 'Minimum 1 card in hand to maximum 24 cards in hands', '2024-11-19 15:28:22', '2024-11-19 15:28:22'),
(5, 1, 'special', 'Joker (Wild Card) would be changed automatically to the card considering what client would need to make the winning pairs', '2024-11-19 15:28:22', '2024-11-19 15:28:22'),
(6, 1, 'special', 'If a split happens and 2 hands altogether make a spare, Than the spare rule would be implemented.', '2024-11-19 15:28:22', '2024-11-19 15:28:22'),
(7, 1, 'special', 'The moderator will have the ability to award any card to the any of the player', '2024-11-19 15:28:22', '2024-11-19 15:28:22'),
(8, 1, 'special', 'The Moderator will have the ability to play the game of any user if he/she has any malfunctions on the phone or unable to use the phone.', '2024-11-19 15:28:22', '2024-11-19 15:28:22'),
(9, 1, 'general', '1. Lorem Ipsum is simply dummy text of the printing and typesetting industry. 2. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. 3. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. 4. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages.', '2024-11-19 15:28:22', '2024-11-19 15:28:22'),
(12, 4, 'general', 'general rules hn ye', '2024-11-19 15:34:56', '2024-11-19 15:34:56'),
(13, 4, 'general', 'general rules here', '2024-11-19 15:44:40', '2024-11-19 15:44:40');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `player_id` bigint(20) UNSIGNED DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `user_type` enum('user','moderator','admin') NOT NULL DEFAULT 'user',
  `avatar_image` varchar(255) DEFAULT NULL,
  `auth_provider` enum('guest','normal','google','apple') DEFAULT NULL,
  `platform` enum('android','ios') DEFAULT NULL,
  `is_social` enum('0','1') NOT NULL DEFAULT '0',
  `is_blocked` enum('0','1') NOT NULL DEFAULT '0',
  `social_id` varchar(255) DEFAULT NULL,
  `device_token` longtext DEFAULT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `player_id`, `username`, `email`, `password`, `phone`, `user_type`, `avatar_image`, `auth_provider`, `platform`, `is_social`, `is_blocked`, `social_id`, `device_token`, `email_verified_at`, `deleted_at`, `created_at`, `updated_at`) VALUES
(1, 62909138708, 'Admin', 'admin@pap.com', NULL, NULL, 'admin', 'uploads/images/user/default.png', 'apple', 'ios', '1', '0', 'LtZaztsOBKSXxOlS9XNpdrfRklLQ13Vc', 'sA0YijMjfPwBbtJlK6YbDBkuixaw5DKKxC8rmfCD', '2024-11-19 15:28:21', NULL, '2024-11-19 15:28:21', '2024-11-19 15:28:21'),
(2, 96685118063, 'Blaze', 'blaze@pap.com', NULL, NULL, 'user', 'uploads/images/user/default.png', 'apple', 'ios', '1', '0', '84KgGeyOQPbm3da8fjUn3uZXB6yqRrxn', '3Xm4Qm1Tl0bflyYyDYyvozsOjR95sgRmKtF7zfxR', '2024-11-19 15:28:21', NULL, '2024-11-19 15:28:21', '2024-11-19 15:28:21'),
(3, 70890313137, 'Stalker', 'stalker@pap.com', NULL, NULL, 'user', 'uploads/images/user/default.png', 'apple', 'ios', '1', '0', 'mUoH8CJT9TsDVpSuPNGRlFnYAGyiKA5P', 'BdlTLu1GuMq2e9rOvUJRVTEZEj7uswoee6zIeUeW', '2024-11-19 15:28:21', NULL, '2024-11-19 15:28:21', '2024-11-19 15:28:21'),
(4, 52176117554, 'Moderator', 'sara_mod@pap.com', '$2y$10$LZTLbJghPybZPOaY5QCen.RUXo993d9ZjrnYNMJchHugFWqdl4OpS', '1234543212', 'moderator', 'uploads/images/moderator/moderator_Wis2LfAJfLmjTYFjpWI9ZTlkQq6J4iYmtES5wJ9t.png', 'normal', 'ios', '1', '0', 'cKaY01eVenzFGBtBUJ7j9d7LKJK2WpHG', '5cc87993e3158961e9da72d9b8841afb5c7427cf', '2024-11-19 15:28:21', NULL, '2024-11-19 15:28:21', '2024-11-19 15:34:00'),
(5, 99285893640, 'Angelina', 'angelina@pap.com', '$2y$10$vqcwZVScnGiqeA7x7Quc4eV2VhZP1kX/K3BuKOpXQeFYACkuVbb2S', '1(987)-654-321', 'moderator', 'uploads/images/user/default.png', 'apple', 'ios', '1', '0', 'IdPASo55iVr2PXBmUeVCfNJBuV9KASn0', 'jWIguXZoFDoRWVJhNsIROY6HTMoQ3Vq8JtUPet47', '2024-11-19 15:28:21', NULL, '2024-11-19 15:28:21', '2024-11-19 15:28:21'),
(6, 93402129651, 'Berngo', 'berngo93402129651@pap.com', NULL, NULL, 'user', 'uploads/images/user/user_qD8pscVaGrjCFRT5jpZ6DNVS7z8YIwe9zn6HZtS3.png', 'guest', 'ios', '0', '0', NULL, 'ila', NULL, NULL, '2024-11-19 15:32:46', '2024-11-19 15:32:46'),
(7, 87241344335, 'Ramsey', 'ramsey87241344335@pap.com', NULL, NULL, 'user', 'uploads/images/user/user_cB9rq0aeQGWw52rBRA0YLhxh0hZP3EnWZ3c8qqh5.png', 'guest', 'ios', '0', '0', NULL, 'user1', NULL, NULL, '2024-11-19 15:35:14', '2024-11-19 15:35:14');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cards`
--
ALTER TABLE `cards`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `disputes`
--
ALTER TABLE `disputes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `disputes_moderator_id_foreign` (`moderator_id`),
  ADD KEY `disputes_game_id_foreign` (`game_id`),
  ADD KEY `disputes_disputer_id_foreign` (`disputer_id`),
  ADD KEY `disputes_disputed_against_id_foreign` (`disputed_against_id`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `games`
--
ALTER TABLE `games`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `games_name_unique` (`name`),
  ADD KEY `games_user_id_foreign` (`user_id`),
  ADD KEY `games_league_id_foreign` (`league_id`);

--
-- Indexes for table `game_requests`
--
ALTER TABLE `game_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `game_requests_game_id_foreign` (`game_id`),
  ADD KEY `game_requests_user_id_foreign` (`user_id`);

--
-- Indexes for table `game_scores`
--
ALTER TABLE `game_scores`
  ADD PRIMARY KEY (`id`),
  ADD KEY `game_scores_game_id_foreign` (`game_id`),
  ADD KEY `game_scores_user_id_foreign` (`user_id`);

--
-- Indexes for table `leagues`
--
ALTER TABLE `leagues`
  ADD PRIMARY KEY (`id`),
  ADD KEY `leagues_user_id_foreign` (`user_id`);

--
-- Indexes for table `league_requests`
--
ALTER TABLE `league_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `league_requests_league_id_foreign` (`league_id`),
  ADD KEY `league_requests_user_id_foreign` (`user_id`);

--
-- Indexes for table `league_rules`
--
ALTER TABLE `league_rules`
  ADD PRIMARY KEY (`id`),
  ADD KEY `league_rules_league_id_foreign` (`league_id`),
  ADD KEY `league_rules_rule_id_foreign` (`rule_id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

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
-- Indexes for table `rules`
--
ALTER TABLE `rules`
  ADD PRIMARY KEY (`id`),
  ADD KEY `rules_user_id_foreign` (`user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_player_id_unique` (`player_id`),
  ADD UNIQUE KEY `users_email_unique` (`email`),
  ADD UNIQUE KEY `users_social_id_unique` (`social_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `cards`
--
ALTER TABLE `cards`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `disputes`
--
ALTER TABLE `disputes`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `games`
--
ALTER TABLE `games`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `game_requests`
--
ALTER TABLE `game_requests`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `game_scores`
--
ALTER TABLE `game_scores`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `leagues`
--
ALTER TABLE `leagues`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `league_requests`
--
ALTER TABLE `league_requests`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `league_rules`
--
ALTER TABLE `league_rules`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `rules`
--
ALTER TABLE `rules`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `disputes`
--
ALTER TABLE `disputes`
  ADD CONSTRAINT `disputes_disputed_against_id_foreign` FOREIGN KEY (`disputed_against_id`) REFERENCES `users` (`player_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `disputes_disputer_id_foreign` FOREIGN KEY (`disputer_id`) REFERENCES `users` (`player_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `disputes_game_id_foreign` FOREIGN KEY (`game_id`) REFERENCES `games` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `disputes_moderator_id_foreign` FOREIGN KEY (`moderator_id`) REFERENCES `users` (`player_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `games`
--
ALTER TABLE `games`
  ADD CONSTRAINT `games_league_id_foreign` FOREIGN KEY (`league_id`) REFERENCES `leagues` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `games_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `game_requests`
--
ALTER TABLE `game_requests`
  ADD CONSTRAINT `game_requests_game_id_foreign` FOREIGN KEY (`game_id`) REFERENCES `games` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `game_requests_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `game_scores`
--
ALTER TABLE `game_scores`
  ADD CONSTRAINT `game_scores_game_id_foreign` FOREIGN KEY (`game_id`) REFERENCES `games` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `game_scores_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `leagues`
--
ALTER TABLE `leagues`
  ADD CONSTRAINT `leagues_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `league_requests`
--
ALTER TABLE `league_requests`
  ADD CONSTRAINT `league_requests_league_id_foreign` FOREIGN KEY (`league_id`) REFERENCES `leagues` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `league_requests_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `league_rules`
--
ALTER TABLE `league_rules`
  ADD CONSTRAINT `league_rules_league_id_foreign` FOREIGN KEY (`league_id`) REFERENCES `leagues` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `league_rules_rule_id_foreign` FOREIGN KEY (`rule_id`) REFERENCES `rules` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `rules`
--
ALTER TABLE `rules`
  ADD CONSTRAINT `rules_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
