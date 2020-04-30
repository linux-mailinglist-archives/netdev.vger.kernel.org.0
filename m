Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12BE51C03C9
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 19:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726902AbgD3RVR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 13:21:17 -0400
Received: from mail-eopbgr70055.outbound.protection.outlook.com ([40.107.7.55]:6237
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726355AbgD3RVP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 13:21:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SgiHtfHAWt/chHfR+I15FhhxYH6DT2rMEygkHTRGsL3eG98g2Ln4ZkbwTy5y6AfBIiQWoBzkQ59AmTOiXg/3JyBIa7zlnm35GN8JihhcAzKmjVXtGrPw47ezU/Nl9W6ReiRNKMvnihkiOMrylDRTS2Okxr8vlVsU3AZgzSD9HUYEw1Vde4PsSQhMMv0VZT7BKM9Xp6H7/m5BW+QuGLjZOtBOMLf8NzvcI/+6RgFKpJ0pSfmm/2sq/5GzKwQbgTXxorCdyBj7Wd4JmDUcG1UlHa+WfBL7pyUG62+8nhFWoObPB5YtO0zuA+HNHiMP7yLwSCgKP/SreNjB66pQv68Yjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iDP2bjbpUQnzq7GHXBTPn6hSvWxMCgs+Z1Cru7QtM6o=;
 b=ZQt8SO85vUjynbdt+5eDGuBGNorK99QdA5c3FtE/GplHnWBjHHGPA1QLSJ00wV1ADDv/ebuU+14YwV/5u+X++yXH6a7Z9hxFZJW3C383gE2BBkgQrFL42RCd/3wt8pyfzjtQGfA81kJ6eFIKAl7joZhX4Hj/bAg+OH2T0Yr3qP7szj3efF2nEDny5fxnSxsaYUg/gNYlurWQJtfcqmsE06Q5tmKCCI+p41VyTq1XeHgpbrC1x0GXMBelFPZB0VqhNtKJwvxmcho7l7sn+VplexjdvNNHdBHQIfPl8FfxLvrsumsufWpvAbXyFCbnl9liSNEwk9IR67XisFU3d7r+AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iDP2bjbpUQnzq7GHXBTPn6hSvWxMCgs+Z1Cru7QtM6o=;
 b=QH9NOwKb5PcZiFlUkJCNq6isBKw0YqbpKw+2b4cykXG1OKOssOEKQmd61ASmwK+vQ2jfzQ9xahtDziyvmbsZaxiHdhCoO9jWA1J2G5Zv1yEaVdaQveqyHcKho54Oy8tMGQcEMn4q89IcTwRlv+XXt49D5K1zNMSR3/cVKV332x0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3296.eurprd05.prod.outlook.com (2603:10a6:802:1c::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Thu, 30 Apr
 2020 17:21:09 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2937.028; Thu, 30 Apr 2020
 17:21:09 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Tal Gilboa <talgi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 06/15] net/mlx5: Remove unused field in EQ
Date:   Thu, 30 Apr 2020 10:18:26 -0700
Message-Id: <20200430171835.20812-7-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200430171835.20812-1-saeedm@mellanox.com>
References: <20200430171835.20812-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0030.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::43) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR17CA0030.namprd17.prod.outlook.com (2603:10b6:a03:1b8::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Thu, 30 Apr 2020 17:21:07 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 33e14195-e38c-409c-2e44-08d7ed2adf6f
X-MS-TrafficTypeDiagnostic: VI1PR05MB3296:|VI1PR05MB3296:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB32964EDCAA2CDE37DCE50826BEAA0@VI1PR05MB3296.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-Forefront-PRVS: 0389EDA07F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ymCDjHHjB257qsf+V4BRueZnq9djpabSAEGGAypVNhIjgMTHq8fxj5yHAX2PlhhtojQMZPzbf/Hwbq4rv/YZXuaAyLgLTETZHZZd/4rUkJZKdNi5QJf7B59lFUx5Xli9jOPdoUNd0dh2vYWSWISecReNIc4cylwj8s3j0RI/uX/NmxaM//vXxcnB9gMM+WLYIvzo1Vm0APk+SR2+AcxJa0Lsw/7R4VdSC7TOh2/MqqLlyZUwS6AfGF8xU5ciBha7ISZQdwIdn/z+lqWDxEkHKUX29KtTB41+Co9/UJJp0k4Lowc6IgrvYxTZBA0gPnqHyKHENOUD2C8+0/6vR+zJPeUywdJlOSlsC11C61OFIZCS33VOZZZ+T1NaPaRGBuWpKcT2gxMDLp+R/aLb4GgjZ06XGMOE7RbiAGYK8ZxECb4fPgZw7XdjpJxiVSU0Aq5kaxR2a6KNscOnph8VvgtoMb+h4Z8+omdidKul8zYv6Yhtm9qZ3WC7rZ7ZV9t+S/qb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(39860400002)(366004)(136003)(346002)(52116002)(6666004)(54906003)(2616005)(956004)(316002)(2906002)(478600001)(107886003)(4326008)(66946007)(86362001)(66476007)(66556008)(36756003)(6486002)(16526019)(186003)(26005)(8936002)(6512007)(8676002)(6506007)(1076003)(4744005)(5660300002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 4I1AaTP3u0KvEXHXr59TW6FGHVAvSStZjb7kKrjbRgmnoDWyGqVudeoSTIVf19HMTgF4dn805PByW3zhL+ISZ2cRDUWqfbUrPRjSYOTQdpp2Qot/BEbGOb2DGDyS/FYrahX58+1iD/GmvcVbp+zGenhzEIAcI4YeEjrlOoBRVp/wX3gnHCCTAiYo4/Xz1zJyfaGEp5rAipd/w9WURP3pD9lXcXZvD6US28GKlL9eMU2I5bVcqtBM1h3kNLn6hXArMg3xd5vNfN684VaayzxnKnMXvbHiq94vFT+mdMFB9CiWGRkcrJqnSeufdgyzH07ScncD94vriQ5X1KMnXxyWlnk+O1c26CXAmDenGXBQnXGZVdY8Cn9TiM2UBxp0/vZvQsqCqntAikJti0/j9xRI3l1MV7Dc1ztAme5PPz23/kW6ZDEZfGECA6R4Wdyu1mqKE9gg5waLz9gEuuSaGd2p0Tm4cfuamBbCVcE+gr+NDR8c/4YAb1EqAdAd1o019AqpolAfc0LGMVoxkaLhUT61Hm6jRe0rKvXS2yjf7qawEUa6rqTq+bRqtOrCzXVYNBzD2M1I7vVGHkFgLOpU30wRwN9yjU0izSM5Eh85LZQznLXxT1Cv9Q/MjhE4VX2QTW6KFPQCjgeoFkzt1CD0stURcHuhTK56cuOk7TqJr06M3SrPCnXqm8/jqy1gvgHtXemmN9guSYp420MBH5fdUUtNaqde3h7VqkyiJX5+01BqaqiDqVb6JhMXO/aRAG/EYv7qQPaM6do1ga3Fljxqh/fDZz5AYj3p38FnkaqE9ZOVNXc=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33e14195-e38c-409c-2e44-08d7ed2adf6f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 17:21:09.6205
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ud+w0igL+ZTjEDUONuQbi/agG9dVd5+lzWjD8JLNg4ZvOSamJPYAEX/pfrU0RMOT+mkPR23M1BE8X6NKr/qqcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3296
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

The size field in EQ is not in use.
Remove it.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Tal Gilboa <talgi@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
index 4be4d2d36218..4aaca7400fb2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
@@ -27,7 +27,6 @@ struct mlx5_eq {
 	__be32 __iomem	        *doorbell;
 	u32                     cons_index;
 	struct mlx5_frag_buf    buf;
-	int                     size;
 	unsigned int            vecidx;
 	unsigned int            irqn;
 	u8                      eqn;
-- 
2.25.4

