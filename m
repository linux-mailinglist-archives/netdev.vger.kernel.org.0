Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E19EA8F428
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 21:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732531AbfHOTKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 15:10:00 -0400
Received: from mail-eopbgr00085.outbound.protection.outlook.com ([40.107.0.85]:9262
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731697AbfHOTJ7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 15:09:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nu3eftXF9M+rSKFc6G9ma15lsepOAUnPcZbFBF0acUFMqel7NjwTfKzeuApufbmTnF3tacOJ9ZsyHuU68i4Vyj+0XJyC3tjwTKgqz8TSpW6DSf1plH0tLchpfUXHqu3XTGsEpLKP8ubicOyRB0rymduXG0VuBdt6EVUY/Jxap5kimMPFBHkYdyWvhlrBASEGfqwcm8QkUkWD9Dz3rGJTzXtmz9AVCt1Aewym3z21hg1qgV+/ERpaasJt6eVJv58V6yn4p/U4kBU/nAvNLyQKGbprCc5Ogi/Loc94CCBpvi5qWTFXI9FHmJ0S7VGuZzFV5ufQkhgFshIi2vl4t6HCRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sefntsX9BxQkDRp/w6faBYZs46PT/qhtMlhVFzxA8E0=;
 b=cIYxC+Cjfx/yUClxkBzZ7E6J/X9rOl3DASaujhFe7d0Kiv/iFFCcJ5jg8IbG9xMZ1Yti+ToGPZ/IoO8CPSoDeJHukqtXAQ4UjrYZEHtEOURQ+942wP6up/mFEOW7blZXv/54ZXmwPt4n61ObVYRx1GjUBuI7pi4jTd9aZ5vHGOqqWgpxhKtMlW9sADQ18RmkRfPfP3eykiYFfGDKiW0W7O8ORC0YSOIBmXtUEEX3d9lAEtQPuRfoGkP5MIQd7dpN5lAhzIxDiD6tsIK4/Mm6v4PxhdtZ4cmmlNAXu/X7/OHoUT7ofzFXk5Pj1kdpVkenNfyZJe4qQu8oyxSjPXDYnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sefntsX9BxQkDRp/w6faBYZs46PT/qhtMlhVFzxA8E0=;
 b=am5ElcLtxRiAttTASs0sZDG7cBD5Ap4Zzz0DSKGH8FotLRkgG50ez4l6Cx+ERrXRypDf3wd3O/yCpJX55GLu6r5SAjkP2lrJQn0jc0PYWbNtdrC7yk3D9ZuMMKGpkccKTOBJtk5htwCE1Je59F0ULp05YpsiBoeEeg125pZw8Ic=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2440.eurprd05.prod.outlook.com (10.168.71.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.18; Thu, 15 Aug 2019 19:09:50 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2178.016; Thu, 15 Aug 2019
 19:09:50 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 02/16] net/mlx5e: Change naming convention for reporter's
 functions
Thread-Topic: [net-next 02/16] net/mlx5e: Change naming convention for
 reporter's functions
Thread-Index: AQHVU50DCyaam3Kg80qgKCVLfaHOhw==
Date:   Thu, 15 Aug 2019 19:09:50 +0000
Message-ID: <20190815190911.12050-3-saeedm@mellanox.com>
References: <20190815190911.12050-1-saeedm@mellanox.com>
In-Reply-To: <20190815190911.12050-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR04CA0017.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::27) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 95c544e7-c728-4fc7-e144-08d721b4258e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2440;
x-ms-traffictypediagnostic: DB6PR0501MB2440:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0501MB24402E9D57F35F5B4A7EACFEBEAC0@DB6PR0501MB2440.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2276;
x-forefront-prvs: 01304918F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(346002)(396003)(366004)(376002)(199004)(189003)(6916009)(2616005)(36756003)(446003)(76176011)(186003)(11346002)(52116002)(305945005)(386003)(7736002)(478600001)(476003)(102836004)(6506007)(99286004)(486006)(14454004)(3846002)(6116002)(8676002)(8936002)(5660300002)(81156014)(81166006)(66066001)(26005)(256004)(50226002)(6486002)(6436002)(107886003)(71200400001)(6512007)(54906003)(71190400001)(316002)(1076003)(2906002)(66446008)(53936002)(66946007)(66556008)(66476007)(64756008)(25786009)(86362001)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2440;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: EeSECVUx1TV66hrOSCmpP/EAdJGE2mA40A0Ra8Yt+Zoiml9rbw84drzqxV+rEgDRXmrlIX6+En5doCKcOLoVBYkYA48Cnu9kQAe4wsuGKmcGMjq+keizGVWrnVuYfvRVKNFbg7o1lnKtwslIy64XmTEapA94t/klkwDoHvBx+YO944grItfXgC9T0p6VRt2dbzktqjOgwgCSUs3qnunx3wGY3pRhw0yQyojKbM5nFv/S0A/B4iWRI8vMTdfF+/itTyqHBYFhhkb3iyHNRiTxoMu2yMIG0Li8BCRbMu99lWaYLfWyz38FHg+85jJIawXXipexAkJVdIkib2H69kuxPR2a9Pxy33agnxFG2+xybRucgYoGHXaAQrcKFVXOk12etODKKJSYZPsUXXw2ULSWSNaYYhsZ/lOuouodOClWipY=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95c544e7-c728-4fc7-e144-08d721b4258e
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2019 19:09:50.6384
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ffYYcQwiBVQg84mOmwyC8AUbv0erkrTwO1SIWtV/JcupTUr0CUmLMIU/XiThCoTwhw37z/8hDHMoX8VcQh9ktA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2440
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
index 7aac9cc92181..fc308efa2e3c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -124,7 +124,7 @@ static int mlx5_tx_health_report(struct devlink_health_=
reporter *tx_reporter,
 	return devlink_health_report(tx_reporter, err_str, err_ctx);
 }
=20
-void mlx5e_tx_reporter_err_cqe(struct mlx5e_txqsq *sq)
+void mlx5e_reporter_tx_err_cqe(struct mlx5e_txqsq *sq)
 {
 	char err_str[MLX5E_TX_REPORTER_PER_SQ_MAX_LEN];
 	struct mlx5e_tx_err_ctx err_ctx =3D {0};
@@ -157,7 +157,7 @@ static int mlx5e_tx_reporter_timeout_recover(struct mlx=
5e_txqsq *sq)
 	return 0;
 }
=20
-int mlx5e_tx_reporter_timeout(struct mlx5e_txqsq *sq)
+int mlx5e_reporter_tx_timeout(struct mlx5e_txqsq *sq)
 {
 	char err_str[MLX5E_TX_REPORTER_PER_SQ_MAX_LEN];
 	struct mlx5e_tx_err_ctx err_ctx;
@@ -286,7 +286,7 @@ static const struct devlink_health_reporter_ops mlx5_tx=
_reporter_ops =3D {
=20
 #define MLX5_REPORTER_TX_GRACEFUL_PERIOD 500
=20
-int mlx5e_tx_reporter_create(struct mlx5e_priv *priv)
+int mlx5e_reporter_tx_create(struct mlx5e_priv *priv)
 {
 	struct devlink_health_reporter *reporter;
 	struct mlx5_core_dev *mdev =3D priv->mdev;
@@ -306,7 +306,7 @@ int mlx5e_tx_reporter_create(struct mlx5e_priv *priv)
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
index 9fc7bc93d607..aa71530a043c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1380,7 +1380,7 @@ static void mlx5e_tx_err_cqe_work(struct work_struct =
*recover_work)
 	struct mlx5e_txqsq *sq =3D container_of(recover_work, struct mlx5e_txqsq,
 					      recover_work);
=20
-	mlx5e_tx_reporter_err_cqe(sq);
+	mlx5e_reporter_tx_err_cqe(sq);
 }
=20
 int mlx5e_open_icosq(struct mlx5e_channel *c, struct mlx5e_params *params,
@@ -3202,7 +3202,7 @@ static void mlx5e_cleanup_nic_tx(struct mlx5e_priv *p=
riv)
 {
 	int tc;
=20
-	mlx5e_tx_reporter_destroy(priv);
+	mlx5e_reporter_tx_destroy(priv);
 	for (tc =3D 0; tc < priv->profile->max_tc; tc++)
 		mlx5e_destroy_tis(priv->mdev, priv->tisn[tc]);
 }
@@ -4272,7 +4272,7 @@ static void mlx5e_tx_timeout_work(struct work_struct =
*work)
 		if (!netif_xmit_stopped(dev_queue))
 			continue;
=20
-		if (mlx5e_tx_reporter_timeout(sq))
+		if (mlx5e_reporter_tx_timeout(sq))
 			report_failed =3D true;
 	}
=20
@@ -5078,7 +5078,7 @@ static int mlx5e_init_nic_tx(struct mlx5e_priv *priv)
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

