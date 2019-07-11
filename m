Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 783A466015
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 21:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728813AbfGKTkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 15:40:01 -0400
Received: from mail-eopbgr50050.outbound.protection.outlook.com ([40.107.5.50]:33188
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728799AbfGKTkA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jul 2019 15:40:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vCAq98GWOfyqXweQMjkq5CKQCWWIGCg5VLXKTS51rtE=;
 b=JJDxWKefdrTKdQJPVV3nletiL31bDu1Ukd49od8VvG+xyanRRLL6OPKqWsXdGdpV3R4ppM1Sv1zZ9g/e9picgqlLGQKqSP6o8dCpE+KarUvXtw7oE6o3bvqQDztGfb2W9+oMiQMgoNzNmkwngQTeMYdIhik5YSBPwwz7ALcR0TU=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2851.eurprd05.prod.outlook.com (10.172.216.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.19; Thu, 11 Jul 2019 19:39:55 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::4828:eda7:c6d:69e1]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::4828:eda7:c6d:69e1%9]) with mapi id 15.20.2052.022; Thu, 11 Jul 2019
 19:39:55 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Mao Wenan <maowenan@huawei.com>
Subject: [PATCH net-next 1/3] net/mlx5e: Fix compilation error in TLS code
Thread-Topic: [PATCH net-next 1/3] net/mlx5e: Fix compilation error in TLS
 code
Thread-Index: AQHVOCBq0ybF8VESfEaFeozMmWN1fw==
Date:   Thu, 11 Jul 2019 19:39:55 +0000
Message-ID: <20190711193937.29802-2-saeedm@mellanox.com>
References: <20190711193937.29802-1-saeedm@mellanox.com>
In-Reply-To: <20190711193937.29802-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR11CA0070.namprd11.prod.outlook.com
 (2603:10b6:a03:80::47) To AM4PR0501MB2756.eurprd05.prod.outlook.com
 (2603:10a6:200:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 65ee2474-51b9-41c5-ad70-08d706378cd3
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2851;
x-ms-traffictypediagnostic: AM4PR0501MB2851:
x-microsoft-antispam-prvs: <AM4PR0501MB2851573EC65BE114816B5F75BEF30@AM4PR0501MB2851.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-forefront-prvs: 0095BCF226
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(376002)(39860400002)(136003)(346002)(199004)(189003)(66946007)(66066001)(26005)(66446008)(71200400001)(66476007)(71190400001)(186003)(81156014)(8936002)(6506007)(5660300002)(1076003)(305945005)(66556008)(36756003)(99286004)(81166006)(86362001)(25786009)(14444005)(52116002)(102836004)(64756008)(53936002)(8676002)(386003)(478600001)(76176011)(446003)(6436002)(476003)(3846002)(11346002)(54906003)(6486002)(6916009)(2906002)(2616005)(6116002)(6512007)(486006)(68736007)(256004)(4326008)(7736002)(316002)(14454004)(50226002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2851;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: wqJqHhvCx5zWjOnfmND5wR+CSjdqBL93shskpzTlPbGeA8NHrbMJkyt7vFrBe8L3Y6CqgtVABdE6EApBetnaVrtsSekJp9dYnWiH1x9kK0vxt0DHbUCuiluvgMZRRByOrNTQP/y2X/sGhgiqecqJ235sEW1gvIjmKOpcxNnoVEo9V6lCHlRx/rI+muytS7pCj9YFTGHHywalm3rHnJXjZPM7n3ipfF7FpA8DdJsZaWwvEDg1ciey5k+xfUtaQjiURW/QCX/BWDoYGEXWO1wrnBD8dWV/IAony0YR7GuwiqtAw9E981qbzMo0P/Ph3vMYud8UrdZvoOM3/f+oElzamTkAwKF9O9H11JCysMow//tm2/BW5f43CMFTRtl6i2yWlwiFmwbBqx+2apNh7/b7HZqpmda+yDOX2brJAiOmZZk=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65ee2474-51b9-41c5-ad70-08d706378cd3
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2019 19:39:55.4713
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2851
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

In the cited patch below, the Kconfig flags combination of:
CONFIG_MLX5_FPGA is not set
CONFIG_MLX5_TLS=3Dy
CONFIG_MLX5_EN_TLS=3Dy

leads to the compilation error:

./include/linux/mlx5/device.h:61:39: error: invalid application of
sizeof to incomplete type struct mlx5_ifc_tls_flow_bits.

Fix it.

Fixes: 90687e1a9a50 ("net/mlx5: Kconfig, Better organize compilation flags"=
)
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
CC: Mao Wenan <maowenan@huawei.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/accel/tls.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.h b/drivers/=
net/ethernet/mellanox/mlx5/core/accel/tls.h
index 879321b21616..d787bc0a4155 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.h
@@ -81,7 +81,6 @@ mlx5e_ktls_type_check(struct mlx5_core_dev *mdev,
 		      struct tls_crypto_info *crypto_info) { return false; }
 #endif
=20
-#ifdef CONFIG_MLX5_FPGA_TLS
 enum {
 	MLX5_ACCEL_TLS_TX =3D BIT(0),
 	MLX5_ACCEL_TLS_RX =3D BIT(1),
@@ -103,6 +102,7 @@ struct mlx5_ifc_tls_flow_bits {
 	u8         reserved_at_2[0x1e];
 };
=20
+#ifdef CONFIG_MLX5_FPGA_TLS
 int mlx5_accel_tls_add_flow(struct mlx5_core_dev *mdev, void *flow,
 			    struct tls_crypto_info *crypto_info,
 			    u32 start_offload_tcp_sn, u32 *p_swid,
--=20
2.21.0

