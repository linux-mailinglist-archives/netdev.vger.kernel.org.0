Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A50A296A73
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 22:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730903AbfHTUYV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 16:24:21 -0400
Received: from mail-eopbgr50051.outbound.protection.outlook.com ([40.107.5.51]:14918
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730830AbfHTUYU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 16:24:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bafv8YZ5GUWksex8SaQDxmYBC0S7bXPmieM2M6hU5G8Cua6UIlq9P3DCUdm8nKwXrD1Qrl91LfWiHAqNjq68nNX61uQ+ZYuhxr7kAlmtjHmzYUTPIBuzX+iDPcNAf0j5yVQ7stULqOO6mcLF2OqTR+rYB7X5sMgiU76jwHMEgVhahVEUpzb2zVUj1vXMYzVrNR3milJn7982M4umR1cKzrMOthn80xUIEVdEVhUO5q37zQTDR0M+Tqex/F4ILa6M/dvQpU9KO4iZdrf5MV6KqOrV5K3kHPXUOjYRzZ3ekphSYWdtz/StMRbJWpMoLwhLuJkofthwuXY23DjQI5wXcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b1ZOwgMwMCHI6GgwCsoG0khq241u+wJNPNjD4WVEuto=;
 b=oPXUDg1VfHv5kAsYXIwKT4i7U4IeQ1pOFZh/87n5J8LlctQBrfGpy2YdWBs4LCn7xISi39knjN3IzP7m8KedeeZ6MI19na5sxKsFZKCDAsURWaLp5RW4aE9FsGOe87cUW4WJQJ3w4+bDZhuVvBOrXxd+8tCq+qkqciQPo15O/0NoMuYF+gGngiYLrwYw4mMteHTM4jwlOc6E8KZ/Qm1ctQOVp5hUp/TrPpWJzMlx1hMbB7uHcKfxRhNzMw16qIlGvpVhfjMxnTFKmPwB4jpgaq7ExJCOQADgOqbFntqqyewzLWDUbY6+4dTuyDjM5mww1fJE+xckPkhpNpH4qEJdrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b1ZOwgMwMCHI6GgwCsoG0khq241u+wJNPNjD4WVEuto=;
 b=chrhTEHWp9Z4aMifsq4p2mPzZLMKmtlnbjiQv1XqYSozF7NGhhOslEaykqLzF6HdApeajCIRgGbfPJg6PwHWkfXRuDrLk+QWU+abE9dVdY7+sWyCkcZEqrD8U8Sssfj5/xVWVSrIpiAW9sAdhoDYsl9bkb6cwOKup3eWaCRO44o=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2680.eurprd05.prod.outlook.com (10.172.226.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Tue, 20 Aug 2019 20:24:14 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2178.018; Tue, 20 Aug 2019
 20:24:14 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next v2 02/16] net/mlx5e: Change naming convention for
 reporter's functions
Thread-Topic: [net-next v2 02/16] net/mlx5e: Change naming convention for
 reporter's functions
Thread-Index: AQHVV5U8AYgRdWrquUG1ooTpbklQBQ==
Date:   Tue, 20 Aug 2019 20:24:14 +0000
Message-ID: <20190820202352.2995-3-saeedm@mellanox.com>
References: <20190820202352.2995-1-saeedm@mellanox.com>
In-Reply-To: <20190820202352.2995-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0046.namprd02.prod.outlook.com
 (2603:10b6:a03:54::23) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8aab9222-980b-4c9a-78b4-08d725ac5e6b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2680;
x-ms-traffictypediagnostic: DB6PR0501MB2680:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0501MB2680D19148C54C608BE2B36ABEAB0@DB6PR0501MB2680.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2276;
x-forefront-prvs: 013568035E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(346002)(39860400002)(396003)(199004)(189003)(446003)(11346002)(486006)(86362001)(476003)(8676002)(14454004)(81156014)(8936002)(25786009)(26005)(6486002)(102836004)(386003)(53936002)(6506007)(5660300002)(36756003)(6436002)(478600001)(7736002)(186003)(52116002)(99286004)(76176011)(6512007)(81166006)(66066001)(2906002)(2616005)(50226002)(4326008)(1076003)(64756008)(66556008)(256004)(66446008)(6116002)(66946007)(3846002)(6916009)(66476007)(316002)(71190400001)(71200400001)(107886003)(305945005)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2680;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: uAhvRT5224PzNviw4IeFHj4ISTKtltttfEYmN+O9BMgSgo65286Nf9PyIm2IiTe1J6EeCGz0slOjRYQqvbfwyTo6SSfaxv0WREO4lX7HsVJHrUqiNP3R3NiW6t9DQDvKQqiLetPess/qjnjLhSafD1hCIJ2TKUWWEQ9CvuhAYYSiQRzGeVvE+oGxV6OQeEUXwZeCAWkQ5ehmmcFDU6AnfsjICuA4EZrdeu3iYICLmvB8moq9eddcORuTwYg0FYwbw4odegP/FhQgV/88mTFYhpdDHy83IrRonI/7R4GEoEX2cF5oK9VWLS+SylVdI6zu2kojNf6rYd2BgNgrzq7xhmQ+2BvSCrSjmiTNFITNJsIVUMVIWgy2z6+gpnP6npTY4hEb1wC+SgxHRGTLeWhoipwzuSO1t88xDUZSRc3Tj2Y=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8aab9222-980b-4c9a-78b4-08d725ac5e6b
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2019 20:24:14.6607
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: C6wMHrh9HLih4wlmRTGA+usCX025UesKBdcobW2rcSKWKB80cB1THGEfxZbYZKdf1vwJVHPiC1nhejDE+Jwhyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2680
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Change from mlx5e_tx_reporter_* to mlx5e_reporter_tx_*. In the following
patches in the set rx reporter is added, the new naming convention is
more uniformed.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/health.h      | 8 ++++----
 drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c | 8 ++++----
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c        | 8 ++++----
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h b/drivers/=
net/ethernet/mellanox/mlx5/core/en/health.h
index cee840e40a05..c7a5a149011e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
@@ -6,9 +6,9 @@
=20
 #include "en.h"
=20
-int mlx5e_tx_reporter_create(struct mlx5e_priv *priv);
-void mlx5e_tx_reporter_destroy(struct mlx5e_priv *priv);
-void mlx5e_tx_reporter_err_cqe(struct mlx5e_txqsq *sq);
-int mlx5e_tx_reporter_timeout(struct mlx5e_txqsq *sq);
+int mlx5e_reporter_tx_create(struct mlx5e_priv *priv);
+void mlx5e_reporter_tx_destroy(struct mlx5e_priv *priv);
+void mlx5e_reporter_tx_err_cqe(struct mlx5e_txqsq *sq);
+int mlx5e_reporter_tx_timeout(struct mlx5e_txqsq *sq);
=20
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/dri=
vers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index 9ff19d69619f..62b95f62e4dc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -123,7 +123,7 @@ static int mlx5_tx_health_report(struct devlink_health_=
reporter *tx_reporter,
 	return devlink_health_report(tx_reporter, err_str, err_ctx);
 }
=20
-void mlx5e_tx_reporter_err_cqe(struct mlx5e_txqsq *sq)
+void mlx5e_reporter_tx_err_cqe(struct mlx5e_txqsq *sq)
 {
 	char err_str[MLX5E_TX_REPORTER_PER_SQ_MAX_LEN];
 	struct mlx5e_tx_err_ctx err_ctx =3D {0};
@@ -156,7 +156,7 @@ static int mlx5e_tx_reporter_timeout_recover(struct mlx=
5e_txqsq *sq)
 	return 0;
 }
=20
-int mlx5e_tx_reporter_timeout(struct mlx5e_txqsq *sq)
+int mlx5e_reporter_tx_timeout(struct mlx5e_txqsq *sq)
 {
 	char err_str[MLX5E_TX_REPORTER_PER_SQ_MAX_LEN];
 	struct mlx5e_tx_err_ctx err_ctx;
@@ -285,7 +285,7 @@ static const struct devlink_health_reporter_ops mlx5_tx=
_reporter_ops =3D {
=20
 #define MLX5_REPORTER_TX_GRACEFUL_PERIOD 500
=20
-int mlx5e_tx_reporter_create(struct mlx5e_priv *priv)
+int mlx5e_reporter_tx_create(struct mlx5e_priv *priv)
 {
 	struct devlink_health_reporter *reporter;
 	struct mlx5_core_dev *mdev =3D priv->mdev;
@@ -305,7 +305,7 @@ int mlx5e_tx_reporter_create(struct mlx5e_priv *priv)
 	return 0;
 }
=20
-void mlx5e_tx_reporter_destroy(struct mlx5e_priv *priv)
+void mlx5e_reporter_tx_destroy(struct mlx5e_priv *priv)
 {
 	if (!priv->tx_reporter)
 		return;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index 09a68b84cce0..695c75a8d1ab 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1379,7 +1379,7 @@ static void mlx5e_tx_err_cqe_work(struct work_struct =
*recover_work)
 	struct mlx5e_txqsq *sq =3D container_of(recover_work, struct mlx5e_txqsq,
 					      recover_work);
=20
-	mlx5e_tx_reporter_err_cqe(sq);
+	mlx5e_reporter_tx_err_cqe(sq);
 }
=20
 int mlx5e_open_icosq(struct mlx5e_channel *c, struct mlx5e_params *params,
@@ -3201,7 +3201,7 @@ static void mlx5e_cleanup_nic_tx(struct mlx5e_priv *p=
riv)
 {
 	int tc;
=20
-	mlx5e_tx_reporter_destroy(priv);
+	mlx5e_reporter_tx_destroy(priv);
 	for (tc =3D 0; tc < priv->profile->max_tc; tc++)
 		mlx5e_destroy_tis(priv->mdev, priv->tisn[tc]);
 }
@@ -4271,7 +4271,7 @@ static void mlx5e_tx_timeout_work(struct work_struct =
*work)
 		if (!netif_xmit_stopped(dev_queue))
 			continue;
=20
-		if (mlx5e_tx_reporter_timeout(sq))
+		if (mlx5e_reporter_tx_timeout(sq))
 			report_failed =3D true;
 	}
=20
@@ -5077,7 +5077,7 @@ static int mlx5e_init_nic_tx(struct mlx5e_priv *priv)
 #ifdef CONFIG_MLX5_CORE_EN_DCB
 	mlx5e_dcbnl_initialize(priv);
 #endif
-	mlx5e_tx_reporter_create(priv);
+	mlx5e_reporter_tx_create(priv);
 	return 0;
 }
=20
--=20
2.21.0

