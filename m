Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03FF21CBEFE
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 10:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727902AbgEII3U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 04:29:20 -0400
Received: from mail-eopbgr80077.outbound.protection.outlook.com ([40.107.8.77]:60182
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726214AbgEII3T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 04:29:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T/IH6SVchZ3/WJcYyudxmW+vlX3142nsuq1evHHGTThgoL4jeXtB6t/vJeOVjqyrQTHJa6b3Iad/6iCZXUwQHCbZCDZxG1qTnRPJXzhHkKo4x6qi0aMCUN9oCp7bDy83EJn8/1iDuSLrd8TZZ5SIX9z8DHS4cZQlUW8gohtPI30Ea6OoUjWYvTNfCrUFueu7QYUA9ck5NCHPFRBEoXu/mA8p+TVtyiLYx2+VFA3fy/jg3JW8E8Fu4pDJG/qGAnvB7p5YuV5Dz+IaaXFfrxP+4wwba4HvClSra6ZsNCupg+PWJTyjWL7I0JNmoKYZp52VZ45ZAmd4qEBqOAzFELcrWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ctg7e/1F1GsebuD3036XsEpqmrRzBm0JrGQgQ2/Il7s=;
 b=bM/ZcVfUQFOKpXTumYn7l/kEODh7HI5KeH6C53MmWLtJhUARH9zne4cWxMgEomFG1h8Gnwi25qEFd/7n7SJZojUaeF+xZwmfJjg2JJ7g1NVyD6gJ6t/xWOpC/Br6iMXD5g2DfwaAuNoE2nrJtYKF3rFYrnXauPDRZzWVXIntxxViuCU//3Obe9VU9WmpSFt9VttcjLSubbJBBYcb4meeUtbUMcilEZtBEQMmb+zumEpyhutTSp++jaJttvWEBauVVmHR7Z1L/bH3BsbhMRctCflVGAym4GL1slhDgrh0HBPgqjBjqWJKMLNO2/PEbMiElQE+sh1p0NS/O80Dlv2vRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ctg7e/1F1GsebuD3036XsEpqmrRzBm0JrGQgQ2/Il7s=;
 b=Z8lzs/sda42OiMlV5OQyJmHNbupP4EbLmyOFQ56oVFhiexJR/ReINbcoOq5s1VataI3kIFUxgf6K0BMuJ0QeSkyA+jbf2y710hDlIEunG5w9FobbDqYwfB64YnRbR/8TNtWjjbZvjXQp3040Yge0/bhQL2+kELH3/nFDtAbeHHQ=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4813.eurprd05.prod.outlook.com (2603:10a6:803:52::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.29; Sat, 9 May
 2020 08:29:14 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2979.033; Sat, 9 May 2020
 08:29:14 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net-next 00/13] Mellanox, mlx5 and bonding updates 2020-05-09
Date:   Sat,  9 May 2020 01:28:43 -0700
Message-Id: <20200509082856.97337-1-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0011.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::24) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR07CA0011.namprd07.prod.outlook.com (2603:10b6:a02:bc::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26 via Frontend Transport; Sat, 9 May 2020 08:29:13 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ea25347a-0b92-4aef-e581-08d7f3f30e93
X-MS-TrafficTypeDiagnostic: VI1PR05MB4813:|VI1PR05MB4813:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4813949F4AD03FFAC6A07A55BEA30@VI1PR05MB4813.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 03982FDC1D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lDZ1Ut8L50/JeOJ6wiZdaPS+mKJA57snGjgJe6CsDucVWvlo07zcendx7EUnmMe40LhvzC9wj3sYBd89tqCNAPVXOvkFUtxmB4hCM8hkYJJbDnPiQUsFgz78EzaOrQZVACcb45+6Xa+jW2oNwVpBUBu+CTLDZFDBLeTB/X4JKcggFYlimOjz8yD4S46y6YKDZx0S+OYoKJaq2IGO+U0bCsR+PbPLlOYD6jgcI+IjB9L02OW6+n8tVSICszWY4Kgm2AZl0ADlOkhr4KyY5MtlyjZ/G5vtbFdCBldyhMKphLFdLKAKllBLXDuHhYZ50ZC5xg6dfZkp3ojKq7mIDjetwYYPoxkrt/WNrpoUJ7c6i2gGg061ytLbcfTZC2AyzCNcOKJ6DrBgsU+p/gxyhSjBfTWV3ELpPl6KtuihVjv8RVnDCZ1CiAPxXOxc5Ks+zSC1Y08k800KGgnCgOe0/KTnwALiF+1XsFLEql8lXmN9pGkeCjdCMxzhS0OCCdpqFm2CespvVQZZ37QBpJrDqcBCIdNtRr5i2QMM7m0HGEaYvPfkM30JjyrZoGPv/91Vg8ZX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(346002)(136003)(39860400002)(376002)(33430700001)(26005)(6506007)(2616005)(6666004)(15650500001)(4326008)(6512007)(1076003)(6486002)(36756003)(8936002)(33440700001)(66556008)(66476007)(5660300002)(956004)(8676002)(316002)(107886003)(66946007)(2906002)(16526019)(52116002)(86362001)(186003)(478600001)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: WsTdMvVzlfyTtwxo2diTXvokH0cEybQJGcAdjRx3xbcwmo00G7nF01IDBzw1F6J7ps8f6uE6FCclEJtGtoPibjZPo1t+mbxUe7CZ4TcCcjFjGQIrOsv66SoCeqGy+SZW3TN7HsFwEmGi3h4ks7BZRLLitdSPwbv8xstRBgdvS6lBdratHjbIQyykYYkfHybK9ZPE0Fxdt1p6tVATJWf9FTPMh7ufw1KRdsCQRb/+vDgZyBO2CsZWN8PPq0xxKO4/0Xgbp3yjTxPxWJoIUoZpMlNqIAk2ETD148gRDUlP0jmyCoGBXnL26dCz8cQFHd3GYSNPC7cxmJ6+Ajjo1KdtEtVLDwmKUjWfbg9UhoGxTBmHvd9z51skshoaQo20r4GX7qJCLJmNMWZBINOzzoJiOvODqHlcn4pfl4Nn/p1X/YoVU2mm6zet4GlXT+jN0HX1ftg4PqJDRCaKxiOU7gLsQ0QkVq64SOAZ7Rg5+UZxdMk=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea25347a-0b92-4aef-e581-08d7f3f30e93
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2020 08:29:14.5559
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6zBzxauk11OZjo31tsjHiTTNVSwvpUzNtTDZOehYNy06N/6ORsaY+9/gotA6+hrBYM93G/teYwnVd5B+ng5LAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4813
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series includes updates to mlx5 driver and a merge commit to the
earlier bonding series which was submitted by Maor to mlx5-next branch.

For more information please see tag log below.

Please pull and let me know if there is any problem.

Please note that the series starts with a merge of mlx5-next branch,
to resolve and avoid dependency with rdma tree.

A minor conflict between Maor's bonding series [1] and Eric's [2] is
already handled in this merge commit.

[1] bonding: Add support to get xmit slave
[2] bonding: report transmit status to callers

Thanks,
Saeed.

---
The following changes since commit 76cd622fe2c2b10c1f0a7311ca797feccacc329d:

  Merge branch 'mlx5-next' of git://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux (2020-05-09 01:05:30 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2020-05-09

for you to fetch changes up to 28bff09518e9ef942173e41e7521b93ea7be0cf0:

  net/mlx5e: Enhance ICOSQ WQE info fields (2020-05-09 01:05:42 -0700)

----------------------------------------------------------------
mlx5-updates-2020-05-09

This series includes updates to mlx5 netdev driver and bonding updates
to support getting the next active tx slave.

1) merge commit with mlx5-next that includes bonding updates from Maor
   Bonding: Add support to get xmit slave
2) Maxim makes some general code improvements to TX data path
3) Tariq makes some general code improvements to kTLS and mlx5 accel layer
in preparation for mlx5 TLS RX.

----------------------------------------------------------------
Maxim Mikityanskiy (7):
      net/mlx5e: Return bool from TLS and IPSEC offloads
      net/mlx5e: Unify checks of TLS offloads
      net/mlx5e: Return void from mlx5e_sq_xmit and mlx5i_sq_xmit
      net/mlx5e: Pass only eseg to IPSEC offload
      net/mlx5e: Make TLS offload independent of wqe and pi
      net/mlx5e: Update UDP fields of the SKB for GSO first
      net/mlx5e: Split TX acceleration offloads into two phases

Tariq Toukan (6):
      net/mlx5e: kTLS, Fill work queue edge separately in TX flow
      net/mlx5e: kTLS, Do not fill edge for the DUMP WQEs in TX flow
      net/mlx5e: Take TX WQE info structures out of general EN header
      net/mlx5e: Use struct assignment for WQE info updates
      net/mlx5: Accel, Remove unnecessary header include
      net/mlx5e: Enhance ICOSQ WQE info fields

 .../net/ethernet/mellanox/mlx5/core/accel/accel.h  |  1 -
 drivers/net/ethernet/mellanox/mlx5/core/en.h       | 31 +---------
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  | 29 ++++++++-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h   |  5 ++
 .../mellanox/mlx5/core/en_accel/en_accel.h         | 48 ++++++++++-----
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.c       | 15 +++--
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h       |  6 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls.h    |  8 +--
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c | 66 +++++++--------------
 .../mellanox/mlx5/core/en_accel/tls_rxtx.c         | 69 +++++++++++-----------
 .../mellanox/mlx5/core/en_accel/tls_rxtx.h         | 13 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 16 ++---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    | 24 +++++---
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    | 35 ++++++-----
 drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c  |  7 ++-
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |  4 +-
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h  |  5 +-
 17 files changed, 197 insertions(+), 185 deletions(-)

Saeed Mahameed (1):
      Merge branch 'mlx5-next' of git://git.kernel.org/.../mellanox/linux

 drivers/net/bonding/bond_alb.c                |  39 +++++++++++++------
 drivers/net/bonding/bond_main.c               | 252 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------------------------
 drivers/net/ethernet/mellanox/mlx5/core/lag.c |  66 +++++++++++++++++++++-----------
 include/linux/mlx5/driver.h                   |   2 +
 include/linux/netdevice.h                     |  12 ++++++
 include/net/bond_alb.h                        |   4 ++
 include/net/bonding.h                         |   3 +-
 net/core/dev.c                                |  22 +++++++++++
 8 files changed, 301 insertions(+), 99 deletions(-)

