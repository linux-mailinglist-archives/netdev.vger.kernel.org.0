Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2A87163B11
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 04:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbgBSDXX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 22:23:23 -0500
Received: from mail-db8eur05on2089.outbound.protection.outlook.com ([40.107.20.89]:22272
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726346AbgBSDXW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 22:23:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M3CRirLwN0MvnlpkIyT45DwNNYEMgUgNh/xMHPD/CncxOG6ajHGV3sZPfTebwMlusN99m8Wpb0UwE50NsZx5/H1P0lKELqMT3JXyE+Ra6oolshWXv4wjoP2jezNVaLMpMReVAkC7SJvHLTUzEugSC/KjrQCHqqaCzXJnAHS5HhNtL7S/Jk2nRKELVDZaBynub6TjT3sWFLIgEECu/iVu7k9VHG3FOXE6mNmlncvh7ciS7+JSP4Eazc5OeagTIxZKTpDo88GjMLK1epoq625tM5kprgyZOfp4aqV5+G34g4Uaka38YSgc38jZyg1T+4eOfa6ACGHTb+SdujjoP3HBgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J7Lr1wBce73mKpULZgJ61NEpBs4TTds3qCF26sbgUGM=;
 b=X/anvIXe6PzmRcKDGw/98IVh3+yNcjUQ80FWeedTL87AzLPZZ1rnLRdfB804CHljwFgIFmqz3k8ZgFsOyl0gr9Few1adlsqLE0nTrKm8rsZQgb2nozsI1lM6w8BT5WGzPAXf8jNPWnGk6UNAiG0Z6Ro+7Oeph+NSexKQMlCn/LdCRb44JGOPNScdgOeq1ThCgRATE2MGkZUJMHjKTbYEGTxD7h6O1znXlrlZHH/UN2KocfI/VdMCnY4tBQJOIhTlhLI7xuFOHvMX8dRh4G660TtHPl4NCMtyKdK+BfiacVuCv7WFmpJHKZuG7YE0GH6DTcD9fwpsYecwlMqpRniAuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J7Lr1wBce73mKpULZgJ61NEpBs4TTds3qCF26sbgUGM=;
 b=eVYho8Xadb6LeCOOUNNGn6XXftVvqttH7sfa+IUJucqowxLtFTwAqpHufJCCvfgJZ2faG2Cv395FvG0WZwUvb+y4RCeppwZz0gUYjM3eBFYO7x44NcwaTWeddbVMMGXIHcFtavgl0qqUmCnw0k/mxMLowIWQmhF9kn8PSlCqEIk=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4590.eurprd05.prod.outlook.com (20.176.5.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.27; Wed, 19 Feb 2020 03:23:12 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2729.028; Wed, 19 Feb 2020
 03:23:12 +0000
Received: from smtp.office365.com (73.15.39.150) by BYAPR02CA0001.namprd02.prod.outlook.com (2603:10b6:a02:ee::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.22 via Frontend Transport; Wed, 19 Feb 2020 03:23:10 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joe Perches <joe@perches.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V4 06/13] mlx5: Use proper logging and tracing line
 terminations
Thread-Topic: [net-next V4 06/13] mlx5: Use proper logging and tracing line
 terminations
Thread-Index: AQHV5tPqQTM2I0duNEqf/qr5pHxHWA==
Date:   Wed, 19 Feb 2020 03:23:12 +0000
Message-ID: <20200219032205.15264-7-saeedm@mellanox.com>
References: <20200219032205.15264-1-saeedm@mellanox.com>
In-Reply-To: <20200219032205.15264-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR02CA0001.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::14) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e59af5b1-fa83-4176-e364-08d7b4eb0cdc
x-ms-traffictypediagnostic: VI1PR05MB4590:|VI1PR05MB4590:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB45909E01430A29B8D136A880BE100@VI1PR05MB4590.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:651;
x-forefront-prvs: 0318501FAE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(376002)(396003)(136003)(39860400002)(189003)(199004)(2616005)(956004)(16526019)(186003)(478600001)(66446008)(66556008)(71200400001)(26005)(86362001)(66946007)(66476007)(6512007)(36756003)(6486002)(64756008)(107886003)(4326008)(110136005)(8676002)(2906002)(5660300002)(316002)(54906003)(8936002)(52116002)(81156014)(81166006)(6506007)(1076003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4590;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SLlGJrjt09YWM9wrQnkzxmYKRSNKUHDD4alytWQhBuqXo24jksJySQgdjckZqsFkxgZhUoDH1RW4lFONo05Z8hPkPNarvCZRH0hnUJE7lLsUXdUgNOZKVFCOfmqk4DTuEbiIzX6S01UBoU16TUp2GqwVTQ4J+iapQOgO4D2QRkR6M4KDLAOujt95xmis6Li+X2ZaRDwzrNbuPFmEOfaeVfZ6bI3VWrb0TJ00NOpPC4s8jAooKyQ6zLmb8vy2VIPzsI7uBOb80S40Ewlotpj+vEPSndVgAz5nEELF7riGU2pycBTeQdM+L9ZNzjWNe7lbNEXQydzr8HKuKjsmwvnHF4VJoRu6ajgxkvL8xWdD2tm49nF2nwwoITaEY8YlszrNIEGUB/UdhxJ4SkP+bkmHydRMqkNqvCkwtyg8DJHjbq/0obq5eq8Ut4hKSRkW8drnmHFNWQZ/XBm6AvHv1oYo2dAqt4JKd7vYjy9dDVd/7UO+qXoRMvosnPuIDHubHH4hPvUw8QH3CBxUjnObJzmL0sRU/T7ICCL0S0Q2RLalo3Q=
x-ms-exchange-antispam-messagedata: MyOXUQb9RwdtHMPj/LoHs9hFmaeT+Txlf6Uq3obD9WTvO+RMOMXwZz/MYNAVMDJALQoNF4Nf/pjrVKij4oJocdP03f6iGDWfFZ/wXijNAYizBv565+LGH1Yoq+6iahLGTfgAAhn7OWOF8aX3NzSuUw==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e59af5b1-fa83-4176-e364-08d7b4eb0cdc
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Feb 2020 03:23:12.5639
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YRCE5r7pD9Ed3li7ZIyCIB2iEe5glYMD8sV7PXm5p3sv0Qp6ZQHAfG3wbg0tdmJnXOVjw7PMyAN7/Zydm9Xewg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4590
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Perches <joe@perches.com>

netdev_err should use newline termination but mlx5_health_report
is used in a trace output function devlink_health_report where
no newline should be used.

Remove the newlines from a couple formats and add a format string
of "%s\n" to the netdev_err call to not directly output the
logging string.

Also use snprintf to avoid any possible output string overrun.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/health.c    |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en/reporter_rx.c   |  9 +++++----
 .../net/ethernet/mellanox/mlx5/core/en/reporter_tx.c   | 10 +++++-----
 3 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c b/drivers/=
net/ethernet/mellanox/mlx5/core/en/health.c
index 7178f421d2cb..68d019b27642 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
@@ -198,7 +198,7 @@ int mlx5e_health_report(struct mlx5e_priv *priv,
 			struct devlink_health_reporter *reporter, char *err_str,
 			struct mlx5e_err_ctx *err_ctx)
 {
-	netdev_err(priv->netdev, err_str);
+	netdev_err(priv->netdev, "%s\n", err_str);
=20
 	if (!reporter)
 		return err_ctx->recover(&err_ctx->ctx);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/dri=
vers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index 9599fdd620a8..ce2b41c61090 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -519,8 +519,9 @@ void mlx5e_reporter_rx_timeout(struct mlx5e_rq *rq)
 	err_ctx.ctx =3D rq;
 	err_ctx.recover =3D mlx5e_rx_reporter_timeout_recover;
 	err_ctx.dump =3D mlx5e_rx_reporter_dump_rq;
-	sprintf(err_str, "RX timeout on channel: %d, ICOSQ: 0x%x RQ: 0x%x, CQ: 0x=
%x\n",
-		icosq->channel->ix, icosq->sqn, rq->rqn, rq->cq.mcq.cqn);
+	snprintf(err_str, sizeof(err_str),
+		 "RX timeout on channel: %d, ICOSQ: 0x%x RQ: 0x%x, CQ: 0x%x",
+		 icosq->channel->ix, icosq->sqn, rq->rqn, rq->cq.mcq.cqn);
=20
 	mlx5e_health_report(priv, priv->rx_reporter, err_str, &err_ctx);
 }
@@ -534,7 +535,7 @@ void mlx5e_reporter_rq_cqe_err(struct mlx5e_rq *rq)
 	err_ctx.ctx =3D rq;
 	err_ctx.recover =3D mlx5e_rx_reporter_err_rq_cqe_recover;
 	err_ctx.dump =3D mlx5e_rx_reporter_dump_rq;
-	sprintf(err_str, "ERR CQE on RQ: 0x%x", rq->rqn);
+	snprintf(err_str, sizeof(err_str), "ERR CQE on RQ: 0x%x", rq->rqn);
=20
 	mlx5e_health_report(priv, priv->rx_reporter, err_str, &err_ctx);
 }
@@ -548,7 +549,7 @@ void mlx5e_reporter_icosq_cqe_err(struct mlx5e_icosq *i=
cosq)
 	err_ctx.ctx =3D icosq;
 	err_ctx.recover =3D mlx5e_rx_reporter_err_icosq_cqe_recover;
 	err_ctx.dump =3D mlx5e_rx_reporter_dump_icosq;
-	sprintf(err_str, "ERR CQE on ICOSQ: 0x%x", icosq->sqn);
+	snprintf(err_str, sizeof(err_str), "ERR CQE on ICOSQ: 0x%x", icosq->sqn);
=20
 	mlx5e_health_report(priv, priv->rx_reporter, err_str, &err_ctx);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/dri=
vers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index 1772c9ce3938..2028ce9b151f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -375,7 +375,7 @@ void mlx5e_reporter_tx_err_cqe(struct mlx5e_txqsq *sq)
 	err_ctx.ctx =3D sq;
 	err_ctx.recover =3D mlx5e_tx_reporter_err_cqe_recover;
 	err_ctx.dump =3D mlx5e_tx_reporter_dump_sq;
-	sprintf(err_str, "ERR CQE on SQ: 0x%x", sq->sqn);
+	snprintf(err_str, sizeof(err_str), "ERR CQE on SQ: 0x%x", sq->sqn);
=20
 	mlx5e_health_report(priv, priv->tx_reporter, err_str, &err_ctx);
 }
@@ -389,10 +389,10 @@ int mlx5e_reporter_tx_timeout(struct mlx5e_txqsq *sq)
 	err_ctx.ctx =3D sq;
 	err_ctx.recover =3D mlx5e_tx_reporter_timeout_recover;
 	err_ctx.dump =3D mlx5e_tx_reporter_dump_sq;
-	sprintf(err_str,
-		"TX timeout on queue: %d, SQ: 0x%x, CQ: 0x%x, SQ Cons: 0x%x SQ Prod: 0x%=
x, usecs since last trans: %u\n",
-		sq->channel->ix, sq->sqn, sq->cq.mcq.cqn, sq->cc, sq->pc,
-		jiffies_to_usecs(jiffies - sq->txq->trans_start));
+	snprintf(err_str, sizeof(err_str),
+		 "TX timeout on queue: %d, SQ: 0x%x, CQ: 0x%x, SQ Cons: 0x%x SQ Prod: 0x=
%x, usecs since last trans: %u",
+		 sq->channel->ix, sq->sqn, sq->cq.mcq.cqn, sq->cc, sq->pc,
+		 jiffies_to_usecs(jiffies - sq->txq->trans_start));
=20
 	return mlx5e_health_report(priv, priv->tx_reporter, err_str, &err_ctx);
 }
--=20
2.24.1

