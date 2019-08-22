Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 572A29A3DE
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 01:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbfHVXfy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 19:35:54 -0400
Received: from mail-eopbgr50056.outbound.protection.outlook.com ([40.107.5.56]:39558
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726568AbfHVXfx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 19:35:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SzJ1+Tg68w9pLR34xMKn5SAEjd8moEZuybf4A2fxne0q45aPFq0uf3hjaibRblMYjFRkb9Az7V2GhPDwEATqTUe+ge7Dhm80pUvjXGJQuqx9wTiwIoQwNcO8Fb5OE7bNCTWQbo8ArQ9d9IHI0I7nKfJ/Io+YS6B+5rGratD8+Ru5MCYSe7ZYJkzQZewbLPmEh6XH/jgjNeXc64LIe3yDdpm5NKCf1uHfbCDK7+mgRwl/xbcUGiMeYxNGix8ZxHYfk+zqx8DOx5hZ9ZQ8VFp39jF9qxFMVVv7pWCzSerXkCS7eYrET6kItg/sOTuXUmrj65/+rsUf9sD8QsWFxYI0IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L+lrhilh79V9cgDHTHZIVcjIeQ4DQeRUKyzMK1NeigM=;
 b=cBQw9YceAM5lBe2+GOV2k8V024gQLl+f0dXsKRw+LXYuTajEPyN8Qf406T1JCJClj0iEVgX+1FbNF+lWvDa6AidJAzgOzYTc+wK/O1XzVDksoz+FEaRdCc9Ei8LorDDcW7WXbUmcTDp/Y6tAdAuzHAKAXskw4tnqOAcl0Guss8cic7PNiKUTqUvFvT3GoTF7A5vDY584rvRTipPSmtR3+zj5WzHYfSfXoetXhR0ZL+T844MAMwbyV60eaCbrszn/mOf4QHIHkBBlpXKAxPPetMCqIUclJ036aBImX11U+p/jDDITFlNlu1L1m3HPPzf2H9LajP3q7AWgUhj9DIWUKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L+lrhilh79V9cgDHTHZIVcjIeQ4DQeRUKyzMK1NeigM=;
 b=FOWzmdDD9ZANl7z1Fjs7AhadP/j3BceXclarnnoi1DiW5whA1DfCNHjrJHuHQ0MWV3hE/xALTmXDyUNrHTfL5Evw9MDXbGHXa1rJ165ncSDmRPE1qL9CvO/u5NoaT0fi51+XM6LmKlNVTYpXnm8l0DL3aF3tegvhMguGsswgIaU=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2817.eurprd05.prod.outlook.com (10.172.215.144) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Thu, 22 Aug 2019 23:35:47 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a%4]) with mapi id 15.20.2178.020; Thu, 22 Aug 2019
 23:35:47 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Erez Alfasi <ereza@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 1/8] net/mlx5e: ethtool, Fix a typo in WOL function names
Thread-Topic: [net-next 1/8] net/mlx5e: ethtool, Fix a typo in WOL function
 names
Thread-Index: AQHVWUJS1vjavLiM/ESIfvFgwUOqcw==
Date:   Thu, 22 Aug 2019 23:35:46 +0000
Message-ID: <20190822233514.31252-2-saeedm@mellanox.com>
References: <20190822233514.31252-1-saeedm@mellanox.com>
In-Reply-To: <20190822233514.31252-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR06CA0036.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::49) To AM4PR0501MB2756.eurprd05.prod.outlook.com
 (2603:10a6:200:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 33d7c464-56fa-419a-fcd7-08d727597509
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM4PR0501MB2817;
x-ms-traffictypediagnostic: AM4PR0501MB2817:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB2817297FA50773CA38FFD1ADBEA50@AM4PR0501MB2817.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1824;
x-forefront-prvs: 01371B902F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(346002)(39860400002)(396003)(136003)(189003)(199004)(256004)(53936002)(14454004)(107886003)(6436002)(4326008)(8676002)(8936002)(81166006)(99286004)(81156014)(50226002)(25786009)(76176011)(316002)(54906003)(52116002)(5660300002)(71190400001)(71200400001)(186003)(386003)(66066001)(6506007)(476003)(102836004)(305945005)(1076003)(486006)(446003)(11346002)(66446008)(64756008)(66556008)(66476007)(66946007)(36756003)(6916009)(6512007)(2906002)(2616005)(26005)(3846002)(86362001)(7736002)(478600001)(6486002)(6116002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2817;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: /MLU1Ncs5PrIzg5n4TLloGSvweMFo+e4y0w4as5XJK/S73EjuLIhFXBXYFVEmR4fcVUmy33P+5m0KckoV8NCO2FFrwtuYBzu4HQnST34zH1a++DnmMUTPgiKpcI1CsKrzCFe63Ycr+dlpn0O6fKZUB0XXHhlnp3HXrNKJZhCH8IjTfv+uVHj8MkCy1jJGC9+Y0b1LTjXCx2/FmWVvECWeFtkq1ETS7zQJ198ltmwavqofBsJ8U9kySERgdkXPHDGa1LliZHhtd43VjVdwz8XnkdlpBn6RcG8sdPUBiw4C9nr2wAkL8uKhOS43H+5015cXt5VxL+DWpBRrXJUL6P5iQrS+mdBA2LUHsNki6Cn8Ia22TDE6h9qdbmD8Y2onLFO12Q2UgaA77fbMiKzah+Pq3/erZvEoBKQBSNQzQ9yCuU=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33d7c464-56fa-419a-fcd7-08d727597509
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2019 23:35:46.8804
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CA7Io4G+ymf9xftwUWOO/lWyBJqYg4jnNnoHLOq1KVJ18Dy1Bs3awHip0k/6i/KVm+PhRHXbWAusgNAVS0kYuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2817
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

