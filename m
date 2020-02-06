Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A789154D9A
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 21:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727860AbgBFU5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 15:57:41 -0500
Received: from mail-eopbgr60056.outbound.protection.outlook.com ([40.107.6.56]:22890
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727526AbgBFU5l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Feb 2020 15:57:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fIWD8hrTfx23oa/KV6h8kDToNeMuDFGUEb4LZtkQoZWdsKxjPf+B11E8CFn8dIEyP8BeVYd499VrXK3AFKMfxo+5Ts3IFb0eQO3aVwRGDKPlUKEOk7B+2wP6as4B8DgC4OZtV5Wfl/6lbzJ7wZDzX4L+Mkp1wxC8uYKgG2R6ctCa1mlaB5TXf9oah3bK/99OzCuZT9phCb0mXNehyYkK/VnqkyutYNmhQxJL/dT5f75k7+PkIWrZIlKywMzrgz9OIZOzNGXOksoJQNbX5XrBq4l2aJOfUkDzglYonWdHRgtEa7fp86Zi/FirwTv0Q0Cs0og+/yKs4XkQCWmDpFZO3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kXVjJnKcmqHyPbw0tsSbmwcXKk6xVt5MMAeLX4bsAXg=;
 b=fARs/hWg1lWdoXm8DyNPEyLj5XSKxi94/pwK0AMdAJ9JRrO2knQ+G9pCOYNvkd9SE9Ficz+YSQRWJhIjeimH1Qgj3Hjx6KWJ1msWqzpnKsHk+rZhKgA3Os/Kula9dG5Mo1wFimaS8gXfPzFEgbazp+DPSGAth+jFeWqlfaPleIy53afplrPw9wQBxDg1xa5RjRRfiBHevFt+3x+1TpfBmuQ/z1nyKOgDnEbaPfXVTi+mrM/0oH/sWeYefTsWRqNtWDG2ow4vfREIaoJGS3iX/gISJCKgLWiZJ5jaO1KjvZJCeZ22KqtF7nZpZOXGuzDR/Lrc3CigOnAGuZiIclVz/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kXVjJnKcmqHyPbw0tsSbmwcXKk6xVt5MMAeLX4bsAXg=;
 b=ZbhEP63QpLhH3xzqlvTtcM7lXYwUnAWYVQ1rojgDXirVEXopwCtX9Lk0B8oBUsK6oLI6nNJ85veStgyKXTv1pe73046ZCV2+y5GB72ZhLeqEt//FtJXRRDykKzCPuNykd0yieBgKFLOVdJjgZCmSkZQ88FcmSNXnUyWWdUhZU1w=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB3280.eurprd05.prod.outlook.com (10.175.243.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.23; Thu, 6 Feb 2020 20:57:38 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2707.024; Thu, 6 Feb 2020
 20:57:38 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net 0/5] Mellanox, mlx5 fixes 2020-02-06
Date:   Thu,  6 Feb 2020 12:57:05 -0800
Message-Id: <20200206205710.26861-1-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR20CA0005.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::18) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
Received: from smtp.office365.com (209.116.155.178) by BY5PR20CA0005.namprd20.prod.outlook.com (2603:10b6:a03:1f4::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2707.21 via Frontend Transport; Thu, 6 Feb 2020 20:57:37 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [209.116.155.178]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 78644827-43d1-49ac-7fc6-08d7ab4732b7
X-MS-TrafficTypeDiagnostic: VI1PR05MB3280:|VI1PR05MB3280:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB3280A3A8996F7608C6C0D24BBE1D0@VI1PR05MB3280.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-Forefront-PRVS: 0305463112
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(376002)(346002)(396003)(366004)(199004)(189003)(86362001)(4326008)(6512007)(107886003)(26005)(5660300002)(16526019)(186003)(6506007)(8676002)(81156014)(6916009)(81166006)(8936002)(2906002)(478600001)(36756003)(52116002)(6486002)(316002)(1076003)(6666004)(956004)(66476007)(2616005)(66556008)(66946007)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3280;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cf4nYuI7N1VCdP8z82cRJyZoQG1Bh3UxqpTPtkv4gjhjQnThOpLo4tsmm5v+llGGeStaLnUGBA6MTN5rtzLucKZqARfa1geHZ3AzXlScEMd5NMAz8TdZqHAUmRutYWULP/NavHIjUKsQ+qQv6IEPSjRwWtG++mqqh8EiPalydF87mAdOF0huUycfkqmxbVPV6oidJA3sUpQeNo1x4KN/8pUlwGonyPp2vpiWj+RPR9r/fovjaMqGkBDTXGjE+cpaI0kckJRxTh9EJ35dk3gZmXQXo37LbMRZn1qa7TlZbTp1iB6pLqJQJtG+PnxYrh2vXe5bGmyz/HRJy4efqYrdeecpC9OA5jLnhpwggIbYk+TOp67RizukE8QPhph3Vbrp1LJTcR1e0lAn1vO+H1IgzJKKSIdvkhG/Q2ZNXmgV45X15Tm//L5XGFm/PTNcnEh3TV/Jry4ipLyWvwvXcQSU/IW2ceRm5dCfHwK5UJ0tswaB1vjSaK7cEXwvzsZW0WELgvSLqNO1NPrXMKqXhCZ6cQPxtZ8Alw6H2V+4QVpsbj8=
X-MS-Exchange-AntiSpam-MessageData: 6OdVXqE3mJh7IpaqiYHJS7N6vi5N0EE72qG1ajRFIRjoj3Yv4v/E2I1aziORZeWVV7jSUx0yOfvKMCcfrNK4B+sc+FH7avjGFJaSSbFV4vISeIJSg6oM1JihSuQ2T8XlDo0eqfHCAAOsetCd7zn0sA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78644827-43d1-49ac-7fc6-08d7ab4732b7
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2020 20:57:37.9927
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NvBe8gL7mvLgRSsCfMGtlLyQ2DqEmctdKFPuwJCi7ZepPF/JXVODdsmw5DgNtEeXs4Aa0yfmJR3HII+OIZlE/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3280
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series introduces some fixes to mlx5 driver.

Please pull and let me know if there is any problem.

For -stable v4.19:
 ('net/mlx5: IPsec, Fix esp modify function attribute')
 ('net/mlx5: IPsec, fix memory leak at mlx5_fpga_ipsec_delete_sa_ctx')

For -stable v5.4:
   ('net/mlx5: Deprecate usage of generic TLS HW capability bit')
   ('net/mlx5: Fix deadlock in fs_core')

For -stable v5.5:
   ('net/mlx5e: TX, Error completion is for last WQE in batch')

Thanks,
Saeed.

---
The following changes since commit 263a425a482fc495d6d3f9a29b9103a664c38b69:

  net: systemport: Avoid RBUF stuck in Wake-on-LAN mode (2020-02-06 14:28:52 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2020-02-06

for you to fetch changes up to 61c00cca41aeeaa8e5263c2f81f28534bc1efafb:

  net/mlx5: Deprecate usage of generic TLS HW capability bit (2020-02-06 12:24:24 -0800)

----------------------------------------------------------------
mlx5-fixes-2020-02-06

----------------------------------------------------------------
Maor Gottlieb (1):
      net/mlx5: Fix deadlock in fs_core

Raed Salem (2):
      net/mlx5: IPsec, Fix esp modify function attribute
      net/mlx5: IPsec, fix memory leak at mlx5_fpga_ipsec_delete_sa_ctx

Tariq Toukan (2):
      net/mlx5e: TX, Error completion is for last WQE in batch
      net/mlx5: Deprecate usage of generic TLS HW capability bit

 .../net/ethernet/mellanox/mlx5/core/accel/tls.h    |  2 +-
 .../mellanox/mlx5/core/en_accel/tls_rxtx.c         |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    | 16 ++++++-----
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    | 33 +++++++++-------------
 .../net/ethernet/mellanox/mlx5/core/fpga/ipsec.c   |  3 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  | 15 +++++-----
 drivers/net/ethernet/mellanox/mlx5/core/fw.c       |  2 +-
 include/linux/mlx5/mlx5_ifc.h                      |  7 +++--
 8 files changed, 40 insertions(+), 40 deletions(-)
