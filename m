Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3EB1205C34
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 21:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387497AbgFWTxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 15:53:03 -0400
Received: from mail-eopbgr20045.outbound.protection.outlook.com ([40.107.2.45]:63363
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387427AbgFWTxB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 15:53:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hloNR4l44ytGtGvtXMbLvQTA2+IXYKtEVt1/xebS9v2xN0tW24AfbKlHCcqaf6soQbxHYN8Y7WptvfhybIDTdI1rBhUQstukoL8zR4cggKPGXIgqxLropHJmr3mc0KyukpUwTuWChJoBtncFutSzpAlYx2WAFh4rKjN4O8K98WT5zH3MJWNOrFY5w+VhTMtz4kaRMNglgQGIlt0NfiFfiQXUjYyiaZ2TYwTIRNvNK/Fk8c5OSuzcClasXT1BasGOwPEVxFtXjs2si7J6Mq7EuEgAil4imi3TLSazNgkKT+KMZQIkYYMoRyyt/X3mMlJB2HvMkxMGiREV7tmUN3M6ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HPsoofTwBiPlMIUXgajOn0uqpDcqq+qocai8f5hN9KI=;
 b=Yh/L5Xej4JEmlvF2rf+7nEYKz0KFEQwgmG6JvFaD+Tp+eVqUN3XPvksWce7E547L2D/uPedeAmr2SDPNOt4sCZNsm0V6JAihNzoKF7sJZ2KVFZxhR6+mzik94vcwVmd2ouNO9wKimdUZGF834t19Vx5V1ccYTA7a5SDM1TYkHFNzoHpCS7oKllRnDzvBgSG2G0W2zbfNnGFxE24u28k4IKUlBz5fx9+bg3FNcAC+mAoojDSh0C8odEJUu3uGtoDPeF3dFea3EbqkyFUKJQgSBumNxFHWxAPYubHxusZT2DrPh5BTQVQE6pWPS5qDoe+ANqCnnWdVtTux3PfOytjygQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HPsoofTwBiPlMIUXgajOn0uqpDcqq+qocai8f5hN9KI=;
 b=ORgaoPmKPlaFv48ZTROmCeNyQ8/SDwRPTzx5qJe3EMGt6AMS/3q+EnjS34XCc7h8D8irzbfO5+2pjfZQMDjRlyF8BCHRdjggB8pWe5/Rg/51s+vwrkWEb/+c7wNgO3J8inCsdIidCJj/6Y8zCelOrSQtGAn+SXOJ5E/HqBUpIEM=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com (2603:10a6:20b:9::29)
 by AM6PR05MB4374.eurprd05.prod.outlook.com (2603:10a6:209:41::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.23; Tue, 23 Jun
 2020 19:52:53 +0000
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::b9f1:d8a2:666:43d5]) by AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::b9f1:d8a2:666:43d5%6]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 19:52:53 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net-next 00/10] mlx5 updates 2020-06-23
Date:   Tue, 23 Jun 2020 12:52:19 -0700
Message-Id: <20200623195229.26411-1-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0081.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::22) To AM6PR05MB5094.eurprd05.prod.outlook.com
 (2603:10a6:20b:9::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR11CA0081.namprd11.prod.outlook.com (2603:10b6:a03:f4::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Tue, 23 Jun 2020 19:52:52 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d2d98e8c-ae01-4e62-f1c4-08d817af046b
X-MS-TrafficTypeDiagnostic: AM6PR05MB4374:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB4374CBB15609E3B63B5E7F36BE940@AM6PR05MB4374.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 04433051BF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wErG0xXT8tM6ul3V/I4TVxVljEMGo0gSVGPqj9J3kcP+nN39rSr/rJIotWsbJViIEMSnZzSR17XcrqxmrJh/gF0xulQrJsQiy5iKVQUuwoKqVpcPAJCLE4wB4wL5bAtiX3kiOqsa7G3451hcvXDIYl80UWr4c1LzEkRGY40CzhrlEYDNsCd2kNqfhxOwjikAWJt7pHIWOHj8lMfdCHnIY0eBu2lVLQBt3NZaQGNhMkZx+EW+dUswcID+z9woGKcg/8jSgTarApHN9OUbui5TLM6NrkaxsweKHYnDWhxU1ffq9d7WppOT9pSgtXP1K1FzF3WoJOAYlZhxYO3qr3h1NzhXEj+1PN8JBsEMrvC125AJgzslZ5bfwVySAKE0sNuj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB5094.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(39850400004)(346002)(376002)(136003)(15650500001)(6512007)(2906002)(26005)(4326008)(16526019)(186003)(107886003)(6506007)(316002)(52116002)(36756003)(478600001)(8936002)(1076003)(8676002)(5660300002)(86362001)(6486002)(956004)(2616005)(66556008)(83380400001)(6666004)(66476007)(66946007)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: CdEhvXOMRIuzS3/yoY/3l4K6CCsubPYvJCMkCVKsdxONbmunept4avI4Y+eUvJcqT95vaPg7wep8zR/IvgKbNnQy6uca65gSWEsXJXXxvErtsRRROOBfO18W0GSRnwdeWnhYGurCCnw7PJXm3kvXLXz0A+c9Bb8crFHwjPPtSCinpaiEyX4MnHKi6ModRg3/bc8f54gTnIGCTNlKOZ9Rpr5F7jjFYyAy/Zwj7pNCEMhePYCavcLk5oq3LAgqwxNDtDQG5NrdwhlREP+N2LnQvOj7C0hq4LDeouOYwlg3ZHUV1be/sglZ6velRm6rMzRCEUkBANSWIfMrHKTwa8Xmbw/e6bdVGjuD8Rk/HNDdIW/daZmHzWqb3dEFHDQmXrJGeiwA7kOe+zDb5guPqQ0HpLA4YJ0kyOjoup1ZMBDyf9Kv+KwiBD9LUZaSvWGWtK+voO9dJaNBYa0Zj+wHCDQx6J0NXhs2iHj2JITDB2KbMCI=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2d98e8c-ae01-4e62-f1c4-08d817af046b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2020 19:52:53.5612
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nzZczb19ynPnSDGSv5WE3rne4eEwvpG9AlLPU3oaNIfd/SdFxUQrqBhNgcYGym92UVxtR+ZRv2WuBednz+t5Gg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4374
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave, Jakub

This series adds misc updates and one small feature, Relaxed ordering, 
to mlx5 driver.

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit 8af7b4525acf5012b2f111a8b168b8647f2c8d60:

  Merge branch 'net-atlantic-additional-A2-features' (2020-06-22 21:10:22 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2020-06-23

for you to fetch changes up to 378dd789c6335191ca38f57b71c88a8ff4387335:

  net/mlx5e: Add support for PCI relaxed ordering (2020-06-23 12:49:14 -0700)

----------------------------------------------------------------
mlx5-updates-2020-06-23

1) Misc updates and cleanup
2) Use RCU instead of spinlock for vxlan table
3) Support for PCI relaxed ordering
    On some systems, especially ARM and AMD systems, with relaxed
    ordering set, traffic on the remote-numa is at the same
    level as when on the local numa. Running TCP single stream over
    ConnectX-4 LX, ARM CPU on remote-numa has 300% improvement in the
    bandwidth.
    With relaxed ordering turned off: BW:10 [GB/s]
    With relaxed ordering turned on:  BW:40 [GB/s]

----------------------------------------------------------------
Alaa Hleihel (1):
      net/mlx5e: Move including net/arp.h from en_rep.c to rep/neigh.c

Aya Levin (1):
      net/mlx5e: Add support for PCI relaxed ordering

Denis Efremov (1):
      net/mlx5: Use kfree(ft->g) in arfs_create_groups()

Hu Haowen (2):
      net/mlx5: FWTrace: Add missing space
      net/mlx5: Add a missing macro undefinition

Maxim Mikityanskiy (1):
      net/mlx5e: Remove unused mlx5e_xsk_first_unused_channel

Parav Pandit (1):
      net/mlx5: Avoid eswitch header inclusion in fs core layer

Saeed Mahameed (2):
      net/mlx5e: vxlan: Use RCU for vxlan table lookup
      net/mlx5e: vxlan: Return bool instead of opaque ptr in port_lookup()

Vlad Buslov (1):
      net/mlx5e: Move TC-specific function definitions into MLX5_CLS_ACT

 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.c   |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  3 +
 .../net/ethernet/mellanox/mlx5/core/en/rep/neigh.c |  1 +
 .../net/ethernet/mellanox/mlx5/core/en/xsk/umem.c  | 13 -----
 .../net/ethernet/mellanox/mlx5/core/en/xsk/umem.h  |  2 -
 drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c  |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_common.c    | 67 ++++++++++++++++++++--
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   | 46 +++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 29 ++++++++--
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  1 -
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    | 16 +++---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  | 10 ----
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |  1 -
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h  | 10 ++++
 .../net/ethernet/mellanox/mlx5/core/lib/vxlan.c    | 64 +++++++++------------
 .../net/ethernet/mellanox/mlx5/core/lib/vxlan.h    |  5 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  2 +
 include/linux/mlx5/driver.h                        | 10 +++-
 18 files changed, 195 insertions(+), 89 deletions(-)
