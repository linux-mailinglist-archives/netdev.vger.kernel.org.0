Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D69D7A0A19
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 20:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727002AbfH1S6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 14:58:01 -0400
Received: from mail-eopbgr50085.outbound.protection.outlook.com ([40.107.5.85]:52486
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726586AbfH1S57 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 14:57:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RogzjCvrsM4VM4EveADTCtTLbHayjD8wqj/yE/Y2n3DE7BNJI5SC7RNZGZG5LSmpf7tKvJZezNSvNz2Wkb+stkUQR+DP+p0GxH4pG4MnAZ4qYvHM/PpAnaQVz/aQwkhho4EDsvY0gLluxUTAgoIz31GH+Zjzug8ezeNLo5lWygI4AlXuVotDb5panB/8jp5K8waTEWa2s5PaHdzOBL2cMm5SJS0w0XFyFqbmaSKdqxnndDS7rUyEiAG+fswvdhp7M5Of6ZRaHRV5Rot/EoX5ygX4331vg/ogEdJq0TyYnO9lJRQ0FEmcnD/giW565/HusBepqqXg3whWCCvv+YbHGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L+lrhilh79V9cgDHTHZIVcjIeQ4DQeRUKyzMK1NeigM=;
 b=Xsa+7DQMUhGXv2ckR0twlmCmJjnTlX/KvQK45VVW1e96EcfbJtdpGKlOXOGqFM8ZDQEi6FjWRLgBfzuzvwbbSnrhyY6B9pVcFtoZs+1Yv5PUQUSGirFK2UuaE8rkPuGtxSKmb7fni8ucmyvoUSrk3+U5FVt6SXP6REDIBM5qFEl8xajyWWmCjNGuRcCIWDxdcBM/0PTRomTp0cZ+Ha9uNNCkdFz5iYZOKVimdd7qfS0xJ30jqZo51eI3ddZxavptGbRjyvmNH8PoQs85jIvzGSpBPOMESqkt1rmr9kRFJrGW3JINekhCzbaT/AvJhIgZBY0ErnqGJBsYg2J6OmYFIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L+lrhilh79V9cgDHTHZIVcjIeQ4DQeRUKyzMK1NeigM=;
 b=i5w7OPvUCqCsTZMiO2Crdi6zV5ggL9NDi+WlfckNli63kxqYrEYLQrRxLiQZgCUNdQYykT4jivhkXpx8GHt2+xDUnQEjebzjGA4Ul/kZan2ZBJ2EYEr+DFkXxCD6k+fs6u4hhkGJ2cGt4OLdiyDZ1ZPFsLRJ1FmbiZcGVEANwUA=
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com (10.172.11.140) by
 VI1PR0501MB2638.eurprd05.prod.outlook.com (10.172.80.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Wed, 28 Aug 2019 18:57:42 +0000
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::5cab:4f5c:d7ed:5e27]) by VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::5cab:4f5c:d7ed:5e27%6]) with mapi id 15.20.2199.021; Wed, 28 Aug 2019
 18:57:42 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Erez Alfasi <ereza@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next v2 1/8] net/mlx5e: ethtool, Fix a typo in WOL function
 names
Thread-Topic: [net-next v2 1/8] net/mlx5e: ethtool, Fix a typo in WOL function
 names
Thread-Index: AQHVXdJ4mPa/Muck3UWT7LoM3UIEKA==
Date:   Wed, 28 Aug 2019 18:57:41 +0000
Message-ID: <20190828185720.2300-2-saeedm@mellanox.com>
References: <20190828185720.2300-1-saeedm@mellanox.com>
In-Reply-To: <20190828185720.2300-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR06CA0069.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::46) To VI1PR0501MB2765.eurprd05.prod.outlook.com
 (2603:10a6:800:9a::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5663c946-3a0e-4523-ec65-08d72be99a7b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0501MB2638;
x-ms-traffictypediagnostic: VI1PR0501MB2638:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0501MB2638DDD1893B71B979EC98D3BEA30@VI1PR0501MB2638.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1824;
x-forefront-prvs: 014304E855
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(346002)(396003)(39860400002)(189003)(199004)(8676002)(6512007)(107886003)(6486002)(54906003)(1076003)(25786009)(3846002)(316002)(186003)(8936002)(5660300002)(6116002)(53936002)(81156014)(6436002)(478600001)(86362001)(14454004)(2906002)(6916009)(4326008)(81166006)(36756003)(7736002)(50226002)(66446008)(305945005)(256004)(66946007)(486006)(476003)(11346002)(2616005)(66066001)(446003)(66556008)(66476007)(71200400001)(52116002)(26005)(6506007)(386003)(102836004)(71190400001)(76176011)(64756008)(99286004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2638;H:VI1PR0501MB2765.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: aeh0Lgi7zwLyOrPTmTDDxoU3DRbvUiaEi0wbhYqAVSGrVptBcVKDcRgfEuXZ7kr+FA5fCarKM4m2TWukNA+PH5SvEAttr/dBZi8kiO3o9SQPvbNW5mXUhBWSyFYKwTyiQ2SB6qU3N7V07WIJp81hOZ9nWy5GRR/FnhugROG4dCJkjs0NaLj5anpXBr9SnnXsHplNDez7RU3Jg/nmQMVhcHsiJ+FkE/K6n3odxp7EJZXR40i59jDjB4xEf+mot4K0VkCWUrdXFiPAZWFjdhsrE9+5nbKSvh3oZfkKn4Ju79h+F8PkkCzgVo5AMDXCMkRI4p4tA17PasaIkmPKa4HIFri/o0+agmZc7OpeCHeesGP/Mf124MNOCy0971Cpgw+DfK63qHQM2yMvqsqbTHVB7XsrNpjMb77qzzFK72uefMo=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5663c946-3a0e-4523-ec65-08d72be99a7b
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2019 18:57:41.7850
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jVQSteDz7IHgf94W8vH0Hd+9jI5WLsMXEac5ByUDUKx4OcS6gMeJERb4Mn7FO0gCsiP7rjAdhGBYpd7otJ5Ocw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2638
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Erez Alfasi <ereza@mellanox.com>

Fix a typo in 'mlx5e_refomrat_wol_mode_mlx5_to_linux' and
'mlx5e_refomrat_wol_mode_linux_to_mlx5' function names:
"refomrat" -> "reformat".

Fixes: 928cfe8745a6 ("net/mlx5e: Wake On LAN support")
Signed-off-by: Erez Alfasi <ereza@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers=
/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 7347d673f448..c5a9c20d7f00 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1431,7 +1431,7 @@ static __u32 mlx5e_get_wol_supported(struct mlx5_core=
_dev *mdev)
 	return ret;
 }
=20
-static __u32 mlx5e_refomrat_wol_mode_mlx5_to_linux(u8 mode)
+static __u32 mlx5e_reformat_wol_mode_mlx5_to_linux(u8 mode)
 {
 	__u32 ret =3D 0;
=20
@@ -1459,7 +1459,7 @@ static __u32 mlx5e_refomrat_wol_mode_mlx5_to_linux(u8=
 mode)
 	return ret;
 }
=20
-static u8 mlx5e_refomrat_wol_mode_linux_to_mlx5(__u32 mode)
+static u8 mlx5e_reformat_wol_mode_linux_to_mlx5(__u32 mode)
 {
 	u8 ret =3D 0;
=20
@@ -1505,7 +1505,7 @@ static void mlx5e_get_wol(struct net_device *netdev,
 	if (err)
 		return;
=20
-	wol->wolopts =3D mlx5e_refomrat_wol_mode_mlx5_to_linux(mlx5_wol_mode);
+	wol->wolopts =3D mlx5e_reformat_wol_mode_mlx5_to_linux(mlx5_wol_mode);
 }
=20
 static int mlx5e_set_wol(struct net_device *netdev, struct ethtool_wolinfo=
 *wol)
@@ -1521,7 +1521,7 @@ static int mlx5e_set_wol(struct net_device *netdev, s=
truct ethtool_wolinfo *wol)
 	if (wol->wolopts & ~wol_supported)
 		return -EINVAL;
=20
-	mlx5_wol_mode =3D mlx5e_refomrat_wol_mode_linux_to_mlx5(wol->wolopts);
+	mlx5_wol_mode =3D mlx5e_reformat_wol_mode_linux_to_mlx5(wol->wolopts);
=20
 	return mlx5_set_port_wol(mdev, mlx5_wol_mode);
 }
--=20
2.21.0

