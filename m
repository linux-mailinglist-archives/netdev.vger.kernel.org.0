Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAF011D5C21
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 00:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbgEOWR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 18:17:28 -0400
Received: from mail-db8eur05on2063.outbound.protection.outlook.com ([40.107.20.63]:6026
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726183AbgEOWR1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 18:17:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jl+aRHha42kp7MCEXpb1zss/mrQH3AsazgohZPHHa29x8Dz+2085PsoOgEU3fl+MwLUzi3K9ZBL1HhOp20ZncUD42tpWITGgzkumWVcEdJrdZKNCNTon6EVtfV9QusxFaziaDetBphiwB1M5HIHA82Y9AV1/9M9xTIQvGRm1p/mrYMN48/njZrCqpTYEq//PCQICAaJ6TzUoyC+MGH2He0jpGBooll72C9PDI5XUaVXHh9XwnENv8TcKnJ63yHr9Vi4VX6zAO/wEHbkGDxw8hd8w+pEmRVq5Q7uJKSEnGTVbysRJr0Sn+J8NBx+beamljoq+Fiu/TXPW7HnMuD7MIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nbgDG5AmNBpMVEVtEw1wQeTxF98Ls2nGU2zh6/Vp368=;
 b=adrmQMSn/Z/msfZihV8VFSfsfbBrUcSLZRwcVLBfvBrCAR4an6YvpXnIaVqRCLN4yPMlUZTnZ41XE/RNhzsYJdmLfsR2E92tlHd4C/S/ncQk8AkNvk9kVxYpLwpcI8ymikL2S4TYrHtbLqsHaL7kl8coqWzUkAI+U4wTEkc31hjbfb2bAMMZznwOIbc6OUcCn7oVMmDGp4xV0+ZyJrAs41j2j/E4jYvjCJDtnax1BpcVABEIV2y4Xtg7Z3RPYA/cRiiSS8Wz04WYGI7DORgnvWkfwRZyy8COwyastys62gU5R8KE9RtGHqdAb/5JKWHEf4TA7K1GqW0DnNcuyyismA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nbgDG5AmNBpMVEVtEw1wQeTxF98Ls2nGU2zh6/Vp368=;
 b=Ete+py19tl8VRHOiCu7jgT1rqK+NPa65WfNKTYGg69O4f5dq8uQMwVLSxI9rT3OWtpUiqoP6YBn91Angg6zdTwH1bKetpnxEirRMGi/duQ0RINvDId6JM2MdIKhFexRCnLFAbWvP8edqJrXDdbdvgKhzV44KZkBWYU/UTTm9hp4=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4301.eurprd05.prod.outlook.com (2603:10a6:803:41::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.25; Fri, 15 May
 2020 22:17:23 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3000.022; Fri, 15 May 2020
 22:17:23 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH mlx5-next 0/3] Mellanox, updates for mlx5 next 15-05-2020
Date:   Fri, 15 May 2020 15:16:51 -0700
Message-Id: <20200515221654.14224-1-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0047.prod.exchangelabs.com (2603:10b6:a03:94::24)
 To VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR01CA0047.prod.exchangelabs.com (2603:10b6:a03:94::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend Transport; Fri, 15 May 2020 22:17:22 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6d4b65c2-7740-4856-813c-08d7f91dbdf4
X-MS-TrafficTypeDiagnostic: VI1PR05MB4301:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4301FF2B6FC91EEF1DF0EF7DBEBD0@VI1PR05MB4301.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-Forefront-PRVS: 04041A2886
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JahTfH9uoDXU6coszbACt/36sBq94tOHB5cDTwx4tpXD2w6ifPU0/HfDYkSVJrvnwP1mGj7Beh+CXZpSXUVWNEnN8kzjbockWRzirpm8whC6Kx2evIOQW70Xj4LgB6cHC6iL0V4ICNHz1JVa6CN3mAbb90igg/k0rUBKEJFtndjw18E0Fc0ZP00KmCEIgYg8aF7MK/tmK5GsG1Eh8iOxIqKYC3npDQ1cAE59/j52CCDJlB94ATF+7jL4reCtVpoaCGYm8PJKmcywGxUIhHby9z2VGS/2GYE1VGlS/l2b8DzOUGFscgzqqVFPdv7FA7RtnP1K/BBdt3cfJc3+TbaFBU8r8w84FdDDlclNbMGzWs8EQ+a9fiVyQ7QRHTJFFc5e+NV/XbwIREzAyj43CATo26gNbBV35DiY4gW+wOGTf+BBKFiMvrbU4z9n4j3O1BWuBX9g8kp8h2gGEq9UY0BeCy/zm6JFl9govsLB+u82Z7V64NMHFHx+VmuJIpMPBX2a
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(396003)(39860400002)(376002)(346002)(86362001)(6512007)(450100002)(4326008)(8676002)(5660300002)(478600001)(4744005)(6486002)(15650500001)(6636002)(1076003)(66946007)(316002)(66556008)(66476007)(110136005)(52116002)(6506007)(8936002)(16526019)(26005)(186003)(2616005)(36756003)(956004)(2906002)(6666004)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: AB5y2DW1P2CweRY8xXXkg7YMXpJTdRfBcvnf6oCyucKHXa0EYK/+9a1K+Eredqsshh9N7T+EsU5LprTHcmqoOA1ejql0k7dkwA4UYgG4hsfg5rLnQvFiyM+4gKWI+OyxopLysB1CGHJtC+JKHNh21oi22dhSaZ05+ZkbHVaJ4FCwwfeLEx3W4mWCmfnuTeAmOBGo021a9EP9jXTn+/YdbXwglkpBosBOwkHXm36/MxHA3LhBCNd28nzlsdEdt9WmU6mQ+XLGNSI8dtCY8Mmy2UztBrEOOQ7Hb9BNs8ax4uBQVoKQ673GT57hOTXdxIhCPMF+/f+fhgDqQDJctWKe7gydSIkFPjP0FUCuxkLLIu8ZqyxnIc9yJSVoouB/3mFDUyiQA1eFVDDZQhcaP8lEWe7uMD2EmUvaeF+cc+let+vy0z9Qez3PbQjBvcLakusHpA+5Vti5DEZNLyZEv/vo7xe2ZXTzR6ykbgiJdhdbe70=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d4b65c2-7740-4856-813c-08d7f91dbdf4
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2020 22:17:23.6147
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dJTTqFi0M8G59gAxbjyL3lm63Fb2aJ8ST+J2spzocQBU1hG92gSZpvtvGrCh1sLT10wJAk8PTZF6tnN8Qnslrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4301
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This patchset is for mlx5-next branch with misc updates to
mlx5 core driver.

1) Header modify support for RDMA TX Flow table
2) Two small cleanups.

Thanks,
Saeed.

---

Michael Guralnik (1):
  net/mlx5: Add support for RDMA TX FT headers modifying

Parav Pandit (1):
  net/mlx5: Move iseg access helper routines close to mlx5_core driver

Raed Salem (1):
  net/mlx5: Cleanup mlx5_ifc_fte_match_set_misc2_bits

 drivers/infiniband/hw/mlx5/flow.c                      |  5 ++++-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c          |  5 +++++
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c       |  4 ++++
 drivers/net/ethernet/mellanox/mlx5/core/main.c         |  5 +++++
 .../net/ethernet/mellanox/mlx5/core/steering/dr_ste.c  |  1 -
 .../ethernet/mellanox/mlx5/core/steering/dr_types.h    |  3 +--
 include/linux/mlx5/driver.h                            | 10 ----------
 include/linux/mlx5/mlx5_ifc.h                          |  4 +---
 8 files changed, 20 insertions(+), 17 deletions(-)

-- 
2.25.4
r
