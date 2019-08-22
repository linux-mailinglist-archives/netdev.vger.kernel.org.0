Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E814C9A3E7
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 01:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbfHVXhS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 19:37:18 -0400
Received: from mail-eopbgr50084.outbound.protection.outlook.com ([40.107.5.84]:49890
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726642AbfHVXhR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 19:37:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fGyUT19+SKyuQQJkTv6z1gQ27G3KhB471NZe+601gJFd0t9pnN80MpN9uQQRsaL+e2S3suynd9NL/qdpkgIQcpxjCAItc0EYEOp3iSp2NV7CW3qWoRDmo2q9zH0pOh5QC8RMaJ2Qq6RVWRnyNhhAQQR1zpscxMPvejp64A9fEfyi9twyJOENw5kJjA/cQvQxv15vqjElIi2xrVDk0yduALn6n8Vpqpq0TwmZvL40OY+rCXVkbmbKgi2mVUxP/1AbzY5hgm71MLYn4EWwCePTZudXK7PMzQQ0YDKorZRYcKJctqyZCIlEHuPGVmTheduqWw8iBH0i/zdMjgTviAsFmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MBRVWyl73DBNjOx+wi68Gw4HbRS07CN+Sy5uOk2Np8Y=;
 b=AoFnmUhdCqIZp4/IWymajBMsczi3JGdOulLR6t3d3MFe1QJlc7jN0A3NZkPtZEAAzZUpK31EIXq/rHahQqBGwLBItSxv2/AgQBijdvTvycbjdaP2u4kwMIh+aVrYl8gRS5hWtlOtr3Bl91KxE6sagqUPinnC/Yiboqq+5SssVsIKxRKMUFNsDdrv4xBC7J60i/DG0MQxBQg1ym0AX+m1GYjdUtqU+nr1Gchw0Q/zQjzc/fxKYxRVxhfFEbOYbMM65Z3pJjjbcGRjKYvb0f91FSOGEge3kna/Y3eQLWldo5KCFaaICloKaY2K+i6JQW6viE6AMq6xKWkT3JCUp60ewQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MBRVWyl73DBNjOx+wi68Gw4HbRS07CN+Sy5uOk2Np8Y=;
 b=f6HRJxNqNCZbF4sFfGSMrwi+UkGcmKr1wKBVgAv43vLAUMLKaXFWOXSYBMCVIFRenuZlRQKUMN2ImaKsw3U7apohEqwWcAB6vJK1TD+rdPacTZE0terirEKAMwUV+1NT+OnWkA5NKP+gihS09p+G1rzP4dIa5HabXNZ3WVSYy6A=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2817.eurprd05.prod.outlook.com (10.172.215.144) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Thu, 22 Aug 2019 23:35:54 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a%4]) with mapi id 15.20.2178.020; Thu, 22 Aug 2019
 23:35:54 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 5/8] net/mlx5e: Change function's position to a more
 fitting file
Thread-Topic: [net-next 5/8] net/mlx5e: Change function's position to a more
 fitting file
Thread-Index: AQHVWUJX1nPFT3TU90Sxwubpw4nylg==
Date:   Thu, 22 Aug 2019 23:35:54 +0000
Message-ID: <20190822233514.31252-6-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: f5f9794d-76ee-4b8f-ae2a-08d7275979ab
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM4PR0501MB2817;
x-ms-traffictypediagnostic: AM4PR0501MB2817:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB2817960072D185558669F56ABEA50@AM4PR0501MB2817.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:590;
x-forefront-prvs: 01371B902F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(346002)(39860400002)(396003)(136003)(189003)(199004)(256004)(14444005)(53936002)(14454004)(107886003)(6436002)(4326008)(8676002)(8936002)(81166006)(99286004)(81156014)(50226002)(25786009)(76176011)(316002)(54906003)(52116002)(5660300002)(71190400001)(71200400001)(186003)(386003)(66066001)(6506007)(476003)(102836004)(305945005)(1076003)(486006)(446003)(11346002)(66446008)(64756008)(66556008)(66476007)(66946007)(36756003)(6916009)(6512007)(2906002)(2616005)(26005)(3846002)(86362001)(7736002)(478600001)(6486002)(6116002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2817;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 2SYLVpsLCPTyPNJ8e7LRG21sY6GtLV8I9GzqR9k/jRDuQbrPbScYnzeSGZIld0RnJSneQO5pNTT8yyX9VUwr9zciBBhYV+BMmgRmboIg6m1oq65mf2AWvIZyr3joJU5a3OfF1zSQeEbbdORtGmJ0/em3E1JlzdsI7Ad9O7uc6Owc52rf4NxSxqonyQuViB9LIFdaG8CI+jujY1BWvxxveeDw3t1tx9Rdi7dFaPD+HxLM73yKJHxx0AIUmC6LvbJ2z+5LJPikvWelfjDiF3DQqIcJwHL+P5Y1dzZT0Wt+Lt0IBlEvPNKtLULkWgyH33WutWU+dE1oOVp7g2sKuDDelQp54VPXnqSgo8sEs3wS6Pm3LaviINL9PKtQHytydYkx32hjbc8eJfbB2GVhlR6Q5Edi43NM4JwfpitTdHgH5iI=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5f9794d-76ee-4b8f-ae2a-08d7275979ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2019 23:35:54.6480
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eQMvJC2Wmx5sg7hTNRz8i1oHMKqZsuBgWU40NSC02sIgpNinNEAkUIIm+qbcBFG3DMDbvylK3IFS9kP/vowIjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2817
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Move function which indicates whether tunnel inner flow table is
supported from en.h to en_fs.c. It fits better right after tunnel
protocol rules definitions.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h    | 6 ------
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h | 2 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c | 6 ++++++
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/eth=
ernet/mellanox/mlx5/core/en.h
index e03f973c962f..8d76452cacdc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1065,12 +1065,6 @@ int mlx5e_modify_sq(struct mlx5_core_dev *mdev, u32 =
sqn,
 void mlx5e_activate_txqsq(struct mlx5e_txqsq *sq);
 void mlx5e_tx_disable_queue(struct netdev_queue *txq);
=20
-static inline bool mlx5e_tunnel_inner_ft_supported(struct mlx5_core_dev *m=
dev)
-{
-	return (MLX5_CAP_ETH(mdev, tunnel_stateless_gre) &&
-		MLX5_CAP_FLOWTABLE_NIC_RX(mdev, ft_field_support.inner_ip_version));
-}
-
 static inline bool mlx5_tx_swp_supported(struct mlx5_core_dev *mdev)
 {
 	return MLX5_CAP_ETH(mdev, swp) &&
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/=
ethernet/mellanox/mlx5/core/en/fs.h
index ca2161b42c7f..5acd982ff228 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -98,6 +98,8 @@ enum mlx5e_tunnel_types {
 	MLX5E_NUM_TUNNEL_TT,
 };
=20
+bool mlx5e_tunnel_inner_ft_supported(struct mlx5_core_dev *mdev);
+
 /* L3/L4 traffic type classifier */
 struct mlx5e_ttc_table {
 	struct mlx5e_flow_table  ft;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_fs.c
index 76cc10e44080..a8340e4fb0b9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -749,6 +749,12 @@ static struct mlx5e_etype_proto ttc_tunnel_rules[] =3D=
 {
 	},
 };
=20
+bool mlx5e_tunnel_inner_ft_supported(struct mlx5_core_dev *mdev)
+{
+	return (MLX5_CAP_ETH(mdev, tunnel_stateless_gre) &&
+		MLX5_CAP_FLOWTABLE_NIC_RX(mdev, ft_field_support.inner_ip_version));
+}
+
 static u8 mlx5e_etype_to_ipv(u16 ethertype)
 {
 	if (ethertype =3D=3D ETH_P_IP)
--=20
2.21.0

