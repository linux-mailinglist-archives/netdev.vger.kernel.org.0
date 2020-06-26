Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C052520ABFA
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 07:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728107AbgFZF5I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 01:57:08 -0400
Received: from mail-db8eur05on2075.outbound.protection.outlook.com ([40.107.20.75]:11712
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726392AbgFZF5I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 01:57:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FNgclOOOlaksgS4ORsqSRdnucKhPpvF4ByftS6SrEfp/VG5W9Jt+bVyFXJxR9iu3hWLlibZlqNt2t/f3xObhHbjxMFWMMy2tND5kiB+sxNAYUAASwWbwuAceOaOAmWQHlBYTVAtHYXA1+m1nekQuXllnBA1FSqdmOkEt5OWpM7HD/RpEYEXGvuRPBxzP5uexVfH33EOCaj+LL8kHzlQp0wdTBUgTbseXpoqmTkwA55W6AUyNVwPugPZHRVuOUrQ/IJDfn/+mAjiw7ZixvelvwnC3UlpqAxY/k8TcaIpuoNiWz32h856peMo7dUVCD5nLOVJGhe6ln0SuQBRuM7jAtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=buldbIEvs0F2XEjp2KUhKYjmXUkWroDHI6gv9bYxyUM=;
 b=b4LJFLDG+ea+BbproDKkd67/i2y4XZBgEDZNEuNsPcr0GEPAU1OoLXXPyabZ1ToVHHeK+8ErjdsIOYB3uj53wn/ALK2CWtcheTqb4YrfSsqQDVCrxvUch9NdEr6VmFfPs8U/Vkb32xIb4dLH157f6zpXxlzdAeY9YO18ac57Lgih8fwPllirDUxPbCJAZkCjf7Im29tLJqgXvqokx7kyHW6FfbnhkkQ+xkYU0J9oJ6vlRIi9jNl10lIEZ0Qln05i6v89iXplHCfYrQwCou6EJ/F7RBcJwFRK4dL3MhCZmAmNGls8VPNo5OVeIiiJhSz7lzl5cS46kOs9zIkE4Uspkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=buldbIEvs0F2XEjp2KUhKYjmXUkWroDHI6gv9bYxyUM=;
 b=Jf/O7EeI98wbfkM8Tpfu+705bEl6RAuScxCeMa1YDWRAM/FRVwuZXmHC2QPsH+OGXBoNeSsvlMFiNO3b1Q5jfJfI8Lhbj+Iw0+7VdUEqGYqwMz7rQmPOG3DoFPghdVScl1NWTSQjT1oBJpXUaxdMZk6nEAyNwh51K9g5e6n7EYE=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0501MB2445.eurprd05.prod.outlook.com (2603:10a6:800:6a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.24; Fri, 26 Jun
 2020 05:57:04 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3131.020; Fri, 26 Jun 2020
 05:57:04 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH mlx5-next 0/3] mlx5 next updates 2020-06-25
Date:   Thu, 25 Jun 2020 22:56:12 -0700
Message-Id: <20200626055612.99645-1-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0079.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::20) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR11CA0079.namprd11.prod.outlook.com (2603:10b6:a03:f4::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Fri, 26 Jun 2020 05:57:03 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1c7a670c-6e6e-4e63-bc41-08d81995c06d
X-MS-TrafficTypeDiagnostic: VI1PR0501MB2445:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0501MB2445353FFBF4B2721127D460BE930@VI1PR0501MB2445.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-Forefront-PRVS: 0446F0FCE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uQPD4wiEwcfg4pQIRgW5MoRapPcNDCUS8PrZD4WC9W9SlUDzdS02p6CZM5cp+7GaCUnLJTumq4wwGb1yin6bWAZQdqwwUXpTnOGsNNR5zBWhyrn4uHTkGkK8RmVJ16j8wi5gYjz/6SFm/lkt5rk1VnDTelsSIryIRjZ8lBCcR+Lq7rQq86ukT6Bxfh26MdBjxZMQqazTGAkAK3ksDMUvuwLK8SqNjdMcTBPoSevFfpOn6ug323T3RlkdaUUbT66SoWlxPTx9r9UjrHuhG9MXUqDDzBOhQd+IwK4PYMU7YDl/AInfMsmdbxf7YyqJkkjCxnRrUGrsw/m04KiFRvqCvXFzU2LXNIwPTfl2XlLNW3V6pjd/ls3FMm7ev0mMnEEd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(39860400002)(396003)(346002)(136003)(4326008)(8676002)(8936002)(52116002)(6486002)(186003)(1076003)(36756003)(26005)(4744005)(2906002)(83380400001)(66556008)(86362001)(6666004)(6512007)(110136005)(66476007)(5660300002)(16526019)(316002)(6506007)(6636002)(450100002)(66946007)(2616005)(478600001)(956004)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: IUcscVdfOYm23c8vZFaevQiwZP1AWASQuHBFwKu7x9sd8/j7zmVKb0OiDjrG3iJRGDOImuGCJwZtk+cdyf/dqmw0CBml3tiL+ZM5r3BVh97KGMRLkTkWVnkYkDLmlgz7fw8XmO+i4xUCegQuQ1RzF+lHDPEmgtQhk4raj7Xaz8/Lk6sTPPekQBVh5A5t0mtMmJMIj+9IFdLONbitEjSvm7fdUPxolCs1q6C2acj21qFx3WFF8gGWr80mMw/LddrZrs5CRDqZtzoN6/MMh6sL1bY0ExEDGVCrpFvKaJE93MLZQO2c9/ak9nR0a5q9tJkC9r6H88yY/hoOOPR09t6f1R5avmkZ9oFAzGcfevfe2MpQXyuqw92spU0o43s/8Yj5fyvEtFbq4QnAEKVDYT+Wj/gVOfP4uHo364oFvEgkz7HIphDL/CbKbtd4kzU1yhu7NK1iVL80qjTT0Z1rDQ6vfgpHFqbQ+6nisHqXThQtyB4=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c7a670c-6e6e-4e63-bc41-08d81995c06d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2020 05:57:04.7080
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9OYf1AsT2fykRbhvYSSx5dYCH04WhQYSmbr0twkJkoz4LeklFJfach4p6imqP5cHPMMUQqeMre4bcYoV0NHitQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2445
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This small patchset includes 3 patches to mlx5-next branch.

1) Include directives cleanup from Parav.
2) TLS Hardware layouts improvements from Tariq.

Thanks,
Saeed.

--

Parav Pandit (2):
  net/mlx5: Avoid RDMA file inclusion in core driver
  net/mlx5: Avoid eswitch header inclusion in fs core layer

Tariq Toukan (1):
  net/mlx5: kTLS, Improve TLS params layout structures

 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |  2 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls.h    |  2 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c | 14 +++++++++-----
 .../mellanox/mlx5/core/en_accel/tls_rxtx.c         |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  | 10 ----------
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |  1 -
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h  | 10 ++++++++++
 include/linux/mlx5/cq.h                            |  1 -
 include/linux/mlx5/device.h                        |  9 +++++++++
 include/linux/mlx5/mlx5_ifc.h                      |  5 +----
 include/linux/mlx5/qp.h                            |  2 +-
 11 files changed, 33 insertions(+), 25 deletions(-)

-- 
2.26.2

