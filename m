Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 550CA206B5A
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 06:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728808AbgFXErX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 00:47:23 -0400
Received: from mail-eopbgr150040.outbound.protection.outlook.com ([40.107.15.40]:19185
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728681AbgFXErW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 00:47:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oAPKjh0gC7GgdkP2W9wxyCgs794f2Onx8xHI/hIPpdrVLTA0n2Vk99BTuJHGQ5RdY0rxz9erJbZrX/zT987QFmL92SJx1htzuPz2bY4jwu6j8256Y5hXXLU5P+krnwlOFQKThtmHn6wdlHTC7QARbK5GVAjWOBuvijVP7hnY7lpwRQzxXPDNPXI6gYIZyJbqM83POYWa3pnLu5oWdK5Fs1bmem7nPaej+/CPmVUjnvB4XrBElkk2n08Hih/kzOruUsbpSeyDKPEFsmEp+t1nCNCbV62aoZsIUYtsqL103fM4rtFLyY2tio1nR7pzjf09vZY1LrYITs7t5dSTQWfl+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+k+qYzbhgjjxFyM88y9BoJqy8hSrPmoB3GD9tyGMP6s=;
 b=ivhqi63l8EBjgmc3XuLQ1cXI/MaTwtE1ZqQGf8yLniSDgKHwzTN0W3r3zlEHHRLrZWLytfjD94GNLI7kyZieR00zH0kk/C2k5JfpwddrFx9CKoJPafloNYh6JHVwFeJM9ub1oEJg2Be0vGARXa1+W7AsA3qnDTQIqT9ygz5ktPcFlPWINaw434DgT5pQXjModCSGKXuyHbicB80mJkaTGa+FA8W0qIWoEw632ZnIprRThXgWUhuj98u2lyStbEUwYMMgxUoEjcWhKe3G2mPxSewtmUrQihJRQuH5/f9kPFA8UTN8m4WysHogsdGad5mYTJhDle9rMLypMPn684eupw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+k+qYzbhgjjxFyM88y9BoJqy8hSrPmoB3GD9tyGMP6s=;
 b=sGwDAQAbF+XGU4mWX0u7abLi2s5JClffy8XqJk926/zlY1t0I3KCwFBjmr3zd3zW+smhHbyC86EtjDf4vN3GX5tq1yb4oNH0XxtUvyv2dUoPTQGxJAx3rXNadf79cg8Qsu5R8YYvBw1psggP/h7aal1mVztpYyXEfInZz2aCnrE=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5135.eurprd05.prod.outlook.com (2603:10a6:803:af::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21; Wed, 24 Jun
 2020 04:47:16 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3131.020; Wed, 24 Jun 2020
 04:47:16 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net-next V3 0/9] mlx5 updates 2020-06-23
Date:   Tue, 23 Jun 2020 21:46:06 -0700
Message-Id: <20200624044615.64553-1-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0051.namprd02.prod.outlook.com
 (2603:10b6:a03:54::28) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (216.228.112.22) by BYAPR02CA0051.namprd02.prod.outlook.com (2603:10b6:a03:54::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Wed, 24 Jun 2020 04:47:14 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [216.228.112.22]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 597aec26-33c9-4346-8156-08d817f9ab44
X-MS-TrafficTypeDiagnostic: VI1PR05MB5135:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB5135AE7554A16D943039ADEFBE950@VI1PR05MB5135.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-Forefront-PRVS: 0444EB1997
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fS8mDoTrzhDdhVNygnTlqmHJk2mtoOHK7/eNWh1cKWUbI8bXYSY4nsJBvef/MEQhxXbkeYtrth9aZMGOu0vQubZgPD7q35HYWtWJrkHf5tiy8rWXEoLk5+mNvkn+HWefQdiHELwawna/Nxx3U9voNj0/FgujLQmakHqoWkmbeX2xUe+nJuE3rRCPHNz2aSpLrR1XKSRU7FkB04fc/7thqh7Rq98ubscVonqfSywt/HoAMOGFKHPbZ33sMOggHs4MxTfGE1K0JITf0dnch1QMplOSgpEBAljP43Kh6qOGaR/Bp20NNembPdbyYMLs/ylUhptn4+FgD1uskEqyFq3C0qdc3C5tHRFlZSf1TCJD/XiLwpfWpP9AIH2T6ZIEI3Rp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(39850400004)(376002)(366004)(396003)(136003)(107886003)(52116002)(86362001)(8676002)(8936002)(478600001)(26005)(83380400001)(5660300002)(6512007)(2906002)(4326008)(956004)(186003)(6666004)(16526019)(15650500001)(316002)(2616005)(6506007)(66556008)(66476007)(6486002)(1076003)(66946007)(36756003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: RH26aWYbTQnNG2dd3r4LgweLdrP7bHWFM6tNkR4ttlb9CKTG++nhZtqNXLxlr9pkybQ9v9lqRwg6h5654SOXHrkUH1GbUtOjh3Ird8g3PpsrhG9bwtvfrWnrCE0IobUC32AvZyvFuuL2HkeMAGQKaDq4dERdT0KlaoFb8cAxDHUxkJo4FV9Mqpq2igXr31/urL6EAY1QVwoVb2axAyrtsniksfx/BvR2NnIQw/dp+nXo/UhWSqRMt9Ke2utDExCh0OB0wC8qnn58ZLx8K/VDOXBH06gm+3qLxcF5VsKgOGlzcNNkOs/nKknw9OnXvqXUKpCukJctqtfGxDSdzw4go/Bir1dCVqEeca95ZncsOxVTi1WnqPdclA9/76vXS+YLnzx/B+VlFu67zLk1vlchf+4gH/YLI+CKvpAf6TmxJA7pDKlQxJftJeLb42dIDD1UTB87qqtGDvOLLyWAZVEjXxlUVnjo+O+vr7Y2nEHtYdswXegQ0f45wAAYmuOgAyy4
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 597aec26-33c9-4346-8156-08d817f9ab44
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2020 04:47:16.3742
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B8bvNzl7phSLvQqQRukGXZzmgJjdbuQIYbzcr5khJCOPzzWr+6uAAhxBTZlA5SMq4sElkQoW+b1sOwAXRqafhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5135
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave, Jakub

This series adds misc updates and one small feature, Relaxed ordering, 
to mlx5 driver.

v1->v2:
 - Removed unnecessary Fixes Tags 

v2->v3:
 - Drop "macro undefine" patch, it has no value

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit 8af7b4525acf5012b2f111a8b168b8647f2c8d60:

  Merge branch 'net-atlantic-additional-A2-features' (2020-06-22 21:10:22 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2020-06-23

for you to fetch changes up to b640dc10a027523a3fa2ed6c497a76feb97f53e8:

  net/mlx5e: Add support for PCI relaxed ordering (2020-06-23 19:48:35 -0700)

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

Hu Haowen (1):
      net/mlx5: FWTrace: Add missing space

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
 include/linux/mlx5/driver.h                        | 10 +++-
 17 files changed, 193 insertions(+), 89 deletions(-)
