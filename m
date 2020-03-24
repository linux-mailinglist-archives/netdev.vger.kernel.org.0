Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1595191C4E
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 22:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728329AbgCXVxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 17:53:24 -0400
Received: from mail-vi1eur05on2072.outbound.protection.outlook.com ([40.107.21.72]:6069
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727040AbgCXVxX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 17:53:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ajshj2fbrimcuduWbWi+xXWBRfg52IRakgtc+Hly1ljd549b4VTowqXP/WjXhCxA/nhz/rcrPCmxJ/l/bwwoFqX6ZJMZjgKS3bZTiNaCnX2FI7CVw+h+IMfjrZkRkltClXbObiDKim6DNlzComT+IWYJHBHym9Liy4NU9PfKNfTP8tdVf4wnO+LuMlIL3liyiaZGFEW+yEbycBEvMxsYOKDiRJ4cfF7Vj3oHN+TD2GNUH9XHv7875zCOfA6AanxNEPs0iEJnj1M7+vmSN6rSzvK9PWlGV9TjOPEX+zoPd34ULjN3Iw232vkJAMV+jMvkyWJLq0IlnJPRtOh/EAlOMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lyjmx2WR5ydUwCWFJBBYB/w2okH1b2a6BitEMmT6QH8=;
 b=MFdMTFp39MEX/KXOOK66yqU5rlxJJX82YzxfiDs3FrCsA44uag/TyvVoTbDjeACzdtEmYlyYBSUHO0T5UyooVFrLWGhfsqHjJqGpFIwF3tSJ1uvhUw8gwo/xWxLwE0FgS9PG5+c6Qqn6/r4ZMtVdvTs+hTZ3KBb2xbd1GlHmQe1A7nC0q+m/R5VgP9uM6S50oBFhtPRjfJ3tsKMdLEmBg1/zw1CM0YSwMFAk46Pf8QHH//mIh8zev1n5AyWE8XlwHk5GOz0AuFOzl3QTaKEhLVgLssPYNl6RFdKnyXhoapucDgAL4f4RkSgj7uNOeukm0PCaGG0RRfb7eX/I0iGdgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lyjmx2WR5ydUwCWFJBBYB/w2okH1b2a6BitEMmT6QH8=;
 b=S7nZFiuahwjbYMCIL2Qdtu2gLfvBkf0hE7Nv8wswyjIWC7xIhHtXZIYw/WcxFqhxrwFCHaLTbv3NSk9won4dfOmpd6A/PdAmhqJ7Afu59gvuVn1bQvVl8J6C6w/h9qEXsXXQOEZXs7QyYpxfMH7S+dVup1p5ilMGF+QKSnc0VTY=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4973.eurprd05.prod.outlook.com (20.177.52.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.20; Tue, 24 Mar 2020 21:53:20 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2835.023; Tue, 24 Mar 2020
 21:53:20 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net 0/5] Mellanox, mlx5 fixes 2020-03-24
Date:   Tue, 24 Mar 2020 14:52:52 -0700
Message-Id: <20200324215257.150911-1-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0049.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::26) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0049.namprd06.prod.outlook.com (2603:10b6:a03:14b::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.19 via Frontend Transport; Tue, 24 Mar 2020 21:53:18 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5c2baa8f-c56c-448f-b839-08d7d03dc40f
X-MS-TrafficTypeDiagnostic: VI1PR05MB4973:|VI1PR05MB4973:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4973944DE6614D66198325A5BEF10@VI1PR05MB4973.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-Forefront-PRVS: 03524FBD26
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(39860400002)(346002)(366004)(396003)(6666004)(107886003)(8936002)(2616005)(16526019)(8676002)(81156014)(86362001)(956004)(36756003)(6486002)(81166006)(186003)(66946007)(6512007)(52116002)(2906002)(5660300002)(6916009)(66476007)(66556008)(316002)(26005)(6506007)(478600001)(4326008)(1076003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4973;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j9xG2VTHvX6EModjJcPTdSBj3poslrRJRV+W1I9nG6VaB+/tcx52EXnEFIwNioCjNTVYhtdQ4v7rACbbsUwUeLbC73zRQOhASofIxiXICC0nQNGlBgts7l7r66OXJhAgeWwsBpKG+Zv+evV4h/l/4QkNLCe0Uof1LagCyyfJGKjFeDG5hewPF+4gQUp/Twx0rk/Fbr3PrUXwMjAo32zhmniMFKKOYJVf9Dwn+1wUZGFYgECwTaR2LIC82nNtZQKPuY7EHPBSt/l+xFG57srdHKcLJPEkyTfhgo/iBG+o6ksAaPa2hU7i4UCHw7jNMCgbuZGW4tAOtfz/1X7qdByjFCWTe7YEo0Uh+fNvmX60N+1iIhIcz059x8gWUWGR3gHDiw3hUl0r84Nx1WupAGPE2VYTnSGO6h25E++Ek1mh/P7hya5t8OH391BU5qgK/Ibc2eznksqk/kfcBeU2EYxH6ObhmNLesOfnpaxiJNdOjtb78YFGN7ulrlJ9pOdM0kSkHiNHXt2M2d7US07V56PLQlv/aoL+MXzc3uRiE+hz4gE=
X-MS-Exchange-AntiSpam-MessageData: 6BDWf3PWOLUZX2DNZCGWSMqOq3Lh8b2vxaeOaIVUaosYHFJM3dFQlxSjsNN/nDdKIb0yCgDwZikLZisEueELG5yjdCBnA79EL1hwgKgM4X8aSUNZb2s6HyxwGzOauKPNvW3QM52NQJioihRC96asrg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c2baa8f-c56c-448f-b839-08d7d03dc40f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2020 21:53:19.9460
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kz+wkCzt9Dpd7UcmkZRsjlOwKiOLwGb1swcq7hk4a66bUZkpycMYrHP6PAB1VNYmuU3dfsHPjd4G8MvSZ8H9uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4973
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series introduces some fixes to mlx5 driver.

From Aya, Fixes to the RX error recovery flows
From Leon, Fix IB capability mask

Please pull and let me know if there is any problem.

For -stable v5.5
 ('net/mlx5_core: Set IB capability mask1 to fix ib_srpt connection failure')

For -stable v5.4
 ('net/mlx5e: Fix ICOSQ recovery flow with Striding RQ')
 ('net/mlx5e: Do not recover from a non-fatal syndrome')
 ('net/mlx5e: Fix missing reset of SW metadata in Striding RQ reset')
 ('net/mlx5e: Enhance ICOSQ WQE info fields')

The above patch ('net/mlx5e: Enhance ICOSQ WQE info fields')
will fail to apply cleanly on v5.4 due to a trivial contextual conflict, 
but it is an important fix, do I need to do something about it or just
assume Greg will know how to handle this ?

Thanks,
Saeed.

---
The following changes since commit 81573b18f26defe672a7d960f9af9ac2c97f324d:

  selftests/net/forwarding: add Makefile to install tests (2020-03-23 21:55:30 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2020-03-24

for you to fetch changes up to 187a9830c921d92c4a9a8e2921ecc4b35a97532c:

  net/mlx5e: Do not recover from a non-fatal syndrome (2020-03-24 14:43:07 -0700)

----------------------------------------------------------------
mlx5-fixes-2020-03-24

----------------------------------------------------------------
Aya Levin (4):
      net/mlx5e: Enhance ICOSQ WQE info fields
      net/mlx5e: Fix missing reset of SW metadata in Striding RQ reset
      net/mlx5e: Fix ICOSQ recovery flow with Striding RQ
      net/mlx5e: Do not recover from a non-fatal syndrome

Leon Romanovsky (1):
      net/mlx5_core: Set IB capability mask1 to fix ib_srpt connection failure

 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  2 ++
 .../net/ethernet/mellanox/mlx5/core/en/health.h    |  3 +--
 .../ethernet/mellanox/mlx5/core/en/reporter_rx.c   |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |  6 +++--
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 31 +++++++++++++++++-----
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    | 11 ++++----
 drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c  |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/vport.c    |  3 +++
 8 files changed, 41 insertions(+), 18 deletions(-)
