Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 736291D5C81
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 00:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726301AbgEOWtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 18:49:21 -0400
Received: from mail-db8eur05on2084.outbound.protection.outlook.com ([40.107.20.84]:33656
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726183AbgEOWtV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 18:49:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZOXOk8Uzikf/AUUuYfotm/mhAga70wtOu/dfWNfJHXh2CLpplodhm6Q3/v4j9pA49ClDGYrpmwNinGiT89PHdQIxfk/PAUs7yLAmZ+3DOoB+lqLPWhdHMpn67SaZ4Hf74+Vwz7ZwKeNj60jY/gp11kPtFPKOBOStcDcNmVzI5yWgceKF+IBYC91yD4mT18v/CXeCLZdct2xE8ShFS+QntSuIAwI3Z353B02EyCddsz6hSTLIXNnP7eiyCsPrV6FSeEqWJ1Hgx9QmB5WkDOvb2sk5TH39sLvSbXU4Xbi1LQu1bXaeJHdXK+0hDgUfAbPuFSGT5K94KnmkB7VpU+H77A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ulwrpaHHpNM4WtVQDxuL+x3grXM2OmjBlOCJ8qPpmo=;
 b=WoywIVRWfhLmpZ3OhgAoIHUBDjzRgVi69w75f1c4yQAB+EaGChpBpKvWFrGO+kUl6Sin/c0xQYUwFBPZw1nKZqPrb52sB2B/CyK1F/McWHx968P1shVXrZeqn24kHtMydstpPJDTwsHYRsAfqibkS3VwGeJ7A0Oky3hElkW+7yOv6ZTubaVQSr0i96HkHor5MnkpNKja/0ULpud0VcFAZ1vXctQl9JCb7oR6QolGwx+DWztkCeS8/A97t1+BXwNzuH5fHj6avHvDkr6U2oI9dLJ+Cl2TYLOOQziquo+Jrm3disxPoQHglbTVW1kQ7sNJl92us2ioKJPfiIYLtNjDdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ulwrpaHHpNM4WtVQDxuL+x3grXM2OmjBlOCJ8qPpmo=;
 b=PeQDq5JbrmD4F88vhHJrqZ4YPrppUZQuCLYaeTJWh5FzYHjXIW0TcrZXsF5AMCpBPJyNZ1MFcrJVnFsvHNLICjQouIIIeI3InWBvKD4GS98MyNSGGUT8eeQmAN6Bvw+OTFVNZKNuT7k0ZjJb9P72zqQ5zlpWsuQ7aIVAlWisV8Q=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3200.eurprd05.prod.outlook.com (2603:10a6:802:1b::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.24; Fri, 15 May
 2020 22:49:15 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3000.022; Fri, 15 May 2020
 22:49:15 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net-next 00/11] Mellanox, mlx5 misc updates 2020-05-15
Date:   Fri, 15 May 2020 15:48:43 -0700
Message-Id: <20200515224854.20390-1-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0053.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::30) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0053.namprd06.prod.outlook.com (2603:10b6:a03:14b::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend Transport; Fri, 15 May 2020 22:49:14 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 681de464-46fe-48fa-cae6-08d7f92231b5
X-MS-TrafficTypeDiagnostic: VI1PR05MB3200:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB3200C8C633675313F901CCF6BEBD0@VI1PR05MB3200.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 04041A2886
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GxkvaKXmeyJfsTaCxWxtnbxtvUY6OT5EIA250UERcPouxWav3APZscQomoeUeW+G2Oiq7XG5Ym1KipXAGqXJnxEb7MrqljvWx9dZnq5r2dkZx9LKZ6vIJKhLacVvnPy5lAg81nUGIlXEwzylWUDyo4YUF5KcJAYr6gJKOvV2JNqKzvmY4HHK/sLd7eHle2cAEXNTBMFjA2QWL/k32f1QVP9tLB3w4fQBN9yDiGeNva4ExV4NOkGvGUfosjM4iAz6Xyj0Ova5jiScMaNF4wikwLxmdPy6vlgQiRLFdD1B5678w1DjsLOytb2P3hGoEdb4pn/UmiR0c904lHr762q+tEduvh9JTnoY5kZtBhEvFZl0HfFanEb6hJ6wKNr73gHKcpF6tXEvJeZ7YI9spAqw+6qkmjbwkFQ2JIs9SDaQrTWgzwwlnSER2sCYMRlSFunB/JP/guy5w8M97sxnQkMxZ/fEH5rqj/r5LYv6v9OKDjJtX9lmK5j2K2/MBE3dCX3i
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(39860400002)(346002)(396003)(136003)(16526019)(26005)(107886003)(4326008)(6512007)(6486002)(6666004)(478600001)(66476007)(2616005)(66946007)(66556008)(956004)(52116002)(316002)(6506007)(186003)(1076003)(86362001)(5660300002)(8936002)(8676002)(2906002)(15650500001)(36756003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 1kKHj9QNRFzdCWbS2IAk4e2zx5inhcYlG9y2havAYt3EmrA4v/GRY3NxeFZvd2BzYc4lD8RtXmgwuINMBhWnY+4XDquaPYyhkf8dUi1EvRTBZZRi+lNxXGPEPTFJD8j7ALAdSej7+MeRdT6NCJH4G4HyKY76ck62wEJFwj4Ufl9CkCHlL+vgsI3aW+3EEno8CZxyCARR9uv0rVd33zxbnYKHnQeE90hRcZj0q445Tan2J0oSXI1wtdhcnqZP9a/BWcjHkjq9eEm9kpxtR/8pcpeYOwtZf1NcsPCkamaJXSifS3qy2SY5dwkSoJWh0V8mku2XaK/YOapQSF7j8w0QUGW4DLavCEcOXRuVgiLIIr0Md3FHWcvWTnRIKuKCpMJ3xXrZlIAKLPFZZ9yDyCtgawtXE+UYd+CkEe4of0SKRHQ5euIUMkwa82rYWPH2KsN3oL+iUcEv9Hhn0SeaTPJkd+uCBt1mLSllYZyof4ZRHdE=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 681de464-46fe-48fa-cae6-08d7f92231b5
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2020 22:49:15.6175
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sSifF2K62nJ2/nWj0vXEtC2+ueElv0PToBp1r0YVCJVSxpruWp0AySJWnZtn9vJNdQ1aycjQPpdvdCKf3eK4xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3200
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series provides misc updates to mlx5.

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit da07f52d3caf6c24c6dbffb5500f379d819e04bd:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2020-05-15 13:48:59 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2020-05-15

for you to fetch changes up to 3f3ab178c71b12295b5950792b72d2198f0e77c7:

  net/mlx5e: Take DCBNL-related definitions into dedicated files (2020-05-15 15:44:36 -0700)

----------------------------------------------------------------
mlx5-updates-2020-05-15

mlx5 core and mlx5e (netdev) updates:

1) Two fixes for release all FW pages support.
2) Improvement in calculating the send queue stop room on tx
3) Flow steering auto-groups creation improvements
4) TC offload fix for Connection tracking with NAT action
5) IPoIB support for self looback to allow communication between ipoib
pkey child interfaces on the same host.
6) DCBNL cleanup to avoid #ifdef DCBNL all over the main mlx5e code
7) Small and trivial code cleanup

----------------------------------------------------------------
Eran Ben Elisha (3):
      net/mlx5: Dedicate fw page to the requesting function
      net/mlx5: Fix a bug of releasing wrong chunks on > 4K page size systems
      net/mlx5: Move internal timer read function to clock library

Erez Shitrit (2):
      net/mlx5e: IPoIB, Enable loopback packets for IPoIB interfaces
      net/mlx5e: IPoIB, Drop multicast packets that this interface sent

Maxim Mikityanskiy (1):
      net/mlx5e: Calculate SQ stop room in a robust way

Parav Pandit (2):
      net/mlx5: Have single error unwinding path
      net/mlx5: Drain wq first during PCI device removal

Paul Blakey (1):
      net/mlx5: Wait for inactive autogroups

Roi Dayan (1):
      net/mlx5e: CT: Fix offload with CT action after CT NAT action

Tariq Toukan (1):
      net/mlx5e: Take DCBNL-related definitions into dedicated files

 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  54 +---
 drivers/net/ethernet/mellanox/mlx5/core/en/dcbnl.h |  54 ++++
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 308 +++++++++++++++++++--
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |  40 +--
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h   |   2 -
 .../ethernet/mellanox/mlx5/core/en_accel/ktls.c    |  13 +
 .../ethernet/mellanox/mlx5/core/en_accel/ktls.h    |  12 +-
 .../net/ethernet/mellanox/mlx5/core/en_accel/tls.c |  14 +
 .../net/ethernet/mellanox/mlx5/core/en_accel/tls.h |   7 +
 .../net/ethernet/mellanox/mlx5/core/en_common.c    |  13 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c |  28 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  46 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   9 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  15 +-
 .../net/ethernet/mellanox/mlx5/core/en_selftest.c  |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   8 +-
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |   7 +-
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h  |   2 +
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c |   2 +-
 .../net/ethernet/mellanox/mlx5/core/lib/clock.c    |  21 ++
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  32 +--
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |   3 -
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    |  60 ++--
 24 files changed, 554 insertions(+), 204 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/dcbnl.h
