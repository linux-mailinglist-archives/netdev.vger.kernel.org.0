Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3400016F4D1
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 02:13:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729835AbgBZBNZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 20:13:25 -0500
Received: from mail-db8eur05on2044.outbound.protection.outlook.com ([40.107.20.44]:6175
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729346AbgBZBNY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 20:13:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D9Q2FECukkmdSet9I6fENhWogdCfTSYk0I6hbCmYjvBv8UbMpgdGnBlPTuiR7AWFjBUItJ8CcR0dTlJa023Xs2TqE5vQZ3qYJA/Oy5YyRvbFPDY5aYXtdbTLr/0B3n5ag0odwn2bygyoMQ/GJTcICWs8h2yPjspQ2n/mFn9JGdBVezTaFemDPYK3gQf+BMtrxXnvLkhtbBZ1fENbpnoxkVLUp4d2s1H4JIE5NIwBPFC9GYu32z12zDv7R4urJpSpjZnSRdVYWzQz2AlFkg4CKm0NcGrBPe+WZJWTSItfUAb/KkdG6BWLsevG314r83o+KNoYM+iBbdpZiAcjOJgr9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/luZodJeDLTrRpLc4i2J1kqpMZSDdH/xLI8+kksnZXs=;
 b=MLyEUTlbJ0dAZZIGvDrKtRKvPd6ugUTCRR90jFXvEE+IrQOTcrPeoQce8LCL7VocLxbUkgcYPxUbyL9zGH8ZJygTIEVOXHVRqJ+DL1c7EiOusmZkBdhY+3PHzdTLe8aTgOh+GhE+sfOyubAFhfedCiFtmAqTYfVt/N4CkeP7e/sAtOpAw5KdolX6OerBgYxKqHOb6pj1gj4bwDDsjoiXoCuAqqZrlEEZSivrqubFX5aRxQjs6eSPSCtJmBTW9rCgAMWLgMHiK1NuKxnM7ByauBoZEMJLeRb5miPP3tbgW0D18UNNDgLpPdFMfJq2KRYc67CrMKOFXG9Hku2Lijogkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/luZodJeDLTrRpLc4i2J1kqpMZSDdH/xLI8+kksnZXs=;
 b=YzFhH1xynzDM4HCCssNxGn5lbNE9p/dqGqa5yC4XlD0ephKudYM/Y2tT+YYjHQAGc4QBe+MKYZr/IEZUqTyDUp6hrwegGprrqvqLDZZNip+zFVsjGQT3LTxtWR0ZTAXlIJidKhuDa8rtQZxydHRXxjyaDsSjBA3IPdaRbE/O0Ag=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB7038.eurprd05.prod.outlook.com (10.141.234.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.21; Wed, 26 Feb 2020 01:13:10 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2750.021; Wed, 26 Feb 2020
 01:13:10 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net-next 00/16] Mellanox, mlx5 updates 2020-02-25
Date:   Tue, 25 Feb 2020 17:12:30 -0800
Message-Id: <20200226011246.70129-1-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0019.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::29) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR04CA0019.namprd04.prod.outlook.com (2603:10b6:a03:1d0::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Wed, 26 Feb 2020 01:13:08 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 09d3dc0f-8b45-4a8a-3c42-08d7ba590b0d
X-MS-TrafficTypeDiagnostic: VI1PR05MB7038:|VI1PR05MB7038:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB703858413FF29A48E6946A64BEEA0@VI1PR05MB7038.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2043;
X-Forefront-PRVS: 0325F6C77B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(376002)(136003)(366004)(396003)(189003)(199004)(81156014)(66556008)(15650500001)(6666004)(4326008)(36756003)(66946007)(1076003)(5660300002)(66476007)(16526019)(6486002)(186003)(8676002)(81166006)(8936002)(6512007)(2906002)(2616005)(86362001)(316002)(956004)(26005)(52116002)(478600001)(107886003)(6506007)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB7038;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dwvmLlER88LcH++aAwchDN8TMCx7MLuRCS8fpHy/1WvG+8FBkVWHZIqAcW2pb5cL9yzvikT/s8stsnReJke6QLJslJ6fs7MY9ZPN0+D52wmfg/H0hb3NMFobxJLpvdYyvXf7g0SKYIVnqKsjEMVhxjSZCWLN6bXI9nrgB38LPBLHVP1wSgl0/WtqXlVT9N1Wy2BCvqXMVJIZVuO8FH8FB2K6K3vX46sKt9eObn5sSJ2TLdz151M5MwdHLJYvwmnADwlBp9lA/nJ2nwNkPuyOQezVXuwX/UEBQWvm66HU5ETV2l7nrbtDOfkmPG3XBUG5HyU71X0/qHBpK5qRmFDdj8e4BoYlrkF+MyhScB392/+kv+fz7c7sVQoUn1KLIa4/KRFoZL+VKJdmRRe3LzCHM5ZwpQwmU5d4U3H011duLuEeHQ7BcoiQugUZ5MiVJ1wQZngDaA7DWHOi41AKODBLViTdTqmaPpP0WUv/Xs3LtiwHHH3R66O6cBBpt2P+ZTrZ00L5gv43oY6kizEpwma2WtjDfTrV5g3IqNca0Rp5tzM=
X-MS-Exchange-AntiSpam-MessageData: 1ypQtRqUzosiMqDDHfPzjeyYHggG1TbOrIj9x7UrXPuL1R9qP66Caf7wzC5B5/mLhQrOULy/k6ncMVSEcpIck1GGVxQoYJ2zMBe1VQmf1UGcM1harfFwcVZYgv2xgjxut+Z0ALSt4SNyzVnPQHLrqg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09d3dc0f-8b45-4a8a-3c42-08d7ba590b0d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2020 01:13:10.0604
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: apzzS4HpDyRXpWfkEPIARZIyyAF7IZV+oyuCERjbTDe5TlRSgXnPFo11PZzL5lAu7bjg8/zoA94lYKowWFZsEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB7038
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series adds misc updates to mlx5 driver.

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit f13e4415d2715145017cbdc35f33634acf935a6f:

  Merge branch 'mlxsw-Implement-ACL-dropped-packets-identification' (2020-02-25 11:05:55 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2020-02-25

for you to fetch changes up to 586ee9e8a3b00757836787d91b4c369bc36d7928:

  net/mlx5: sparse: warning: Using plain integer as NULL pointer (2020-02-25 17:06:21 -0800)

----------------------------------------------------------------
mlx5-updates-2020-02-25

The following series provides some misc updates to mlx5 driver:

1) From Maxim, Refactoring for mlx5e netdev channels recreation flow.
  - Add error handling
  - Add context to the preactivate hook
  - Use preactivate hook with context where it can be used
    and subsequently unify channel recreation flow everywhere.
  - Fix XPS cpumask to not reset upon channel recreation.

2) From Tariq:
  - Use indirect calls wrapper on RX.
  - Check LRO capability bit

3) Multiple small cleanups

----------------------------------------------------------------
Eran Ben Elisha (1):
      net/mlx5e: Define one flow for TXQ selection when TCs are configured

Hans Wippel (1):
      Documentation: fix vxlan typo in mlx5.rst

Maxim Mikityanskiy (8):
      net/mlx5e: Encapsulate updating netdev queues into a function
      net/mlx5e: Rename hw_modify to preactivate
      net/mlx5e: Use preactivate hook to set the indirection table
      net/mlx5e: Fix configuration of XPS cpumasks and netdev queues in corner cases
      net/mlx5e: Remove unneeded netif_set_real_num_tx_queues
      net/mlx5e: Allow mlx5e_switch_priv_channels to fail and recover
      net/mlx5e: Add context to the preactivate hook
      net/mlx5e: Change inline mode correctly when changing trust state

Nathan Chancellor (1):
      net/mlx5: Fix header guard in rsc_dump.h

Saeed Mahameed (2):
      net/mlx5: sparse: warning: incorrect type in assignment
      net/mlx5: sparse: warning: Using plain integer as NULL pointer

Tariq Toukan (3):
      net/mlx5e: Add missing LRO cap check
      net/mlx5e: RX, Use indirect calls wrapper for posting descriptors
      net/mlx5e: RX, Use indirect calls wrapper for handling compressed completions

 .../networking/device_drivers/mellanox/mlx5.rst    |   2 +-
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.c   |   2 +-
 .../ethernet/mellanox/mlx5/core/diag/rsc_dump.h    |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  29 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c |  55 +++---
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  23 +--
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 195 +++++++++++++--------
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |  13 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c  |  11 +-
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/lib/dm.c   |   2 +-
 13 files changed, 216 insertions(+), 128 deletions(-)
