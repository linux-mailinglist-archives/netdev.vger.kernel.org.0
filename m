Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98909A0A16
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 20:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbfH1S5z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 14:57:55 -0400
Received: from mail-eopbgr10058.outbound.protection.outlook.com ([40.107.1.58]:44526
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726586AbfH1S5z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 14:57:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QwexwYd7PKj2bQAfwwF8IsaKZleoaXVNHTErrCpl8QPPMUCW9Er4AdjF32ZgAWNLQQInu9HO/I+0Iwhpuk2IyH51gwVmPgs03RQs1LH5xBR0YAz5IVs4tawjt0cOYLp52LhmSfSLofo4ndskhKm/+e+eTvCUUxKf5j0Rqe5MhJgpnhONqwFZZgtwx5iqCXEFlmAku76xl/TCLLz0wU7Q93rplS4slD5LlxWPnNCk28gv8SzY/z3JHABa5ERG+kYkZU93VtoIFF4gUfDs2sCxzTY/UK8NPaO5sVVa2LvElJOfB5T10t71FKqkkKA3njB6O9OzUm8qyWVUMQ5OqujJNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MBRVWyl73DBNjOx+wi68Gw4HbRS07CN+Sy5uOk2Np8Y=;
 b=SxnQwMGPgDJJ2lDb1u3pknFe3anDRorVqN+4TY35ZrLy4uam+poBIBRXdSgph3UOa9nGATR9Qz5xtH+pi7csrvhCBTXF+7kEpkiPi9r6cMPJLGpA7KPyVaPgu7D3VT00PHZ/S63mQqYT3W93YgUBITakXffdTaYqxrMhBxppsj9qRHLqrE6Zws/ZAbT8nxskDNXRy3DbA6YNghKaZ+OPj6eef9StBhNraiDem138u6UbYkui3RrF2rr9dXz9D5SSc4XP6Kc46ybZnh+snDdYKJYQJj/A0qu/vReNBW5pKiSXEC+JxjNHpO2Ovlq3PiTM+ooxamutSmG7GnTV9q+Pag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MBRVWyl73DBNjOx+wi68Gw4HbRS07CN+Sy5uOk2Np8Y=;
 b=YDIHN58WgGGV4hPeWhv+4m4Fh3FEHJKQJ1S3k49bLzFnE21SrBYf9LiEtXmVYEs0vAjoLhjpZP4g8m5mr+YaYZRn4+No5RsQdwGCiq9hIMHWwQ08PP+qBa+szWcwk/TX8E8/KPgxXx43/pq2t5sKzm6xlsf6CUXMDB2QpsaFJgM=
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com (10.172.11.140) by
 VI1PR0501MB2751.eurprd05.prod.outlook.com (10.172.82.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Wed, 28 Aug 2019 18:57:49 +0000
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::5cab:4f5c:d7ed:5e27]) by VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::5cab:4f5c:d7ed:5e27%6]) with mapi id 15.20.2199.021; Wed, 28 Aug 2019
 18:57:49 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next v2 5/8] net/mlx5e: Change function's position to a more
 fitting file
Thread-Topic: [net-next v2 5/8] net/mlx5e: Change function's position to a
 more fitting file
Thread-Index: AQHVXdJ87JcQpQazCEawa0NBL8EWxQ==
Date:   Wed, 28 Aug 2019 18:57:49 +0000
Message-ID: <20190828185720.2300-6-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 5aa924b4-4ffd-418d-fcd2-08d72be99f1e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0501MB2751;
x-ms-traffictypediagnostic: VI1PR0501MB2751:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0501MB27511B01B9C29A87485933B2BEA30@VI1PR0501MB2751.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:590;
x-forefront-prvs: 014304E855
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(346002)(376002)(366004)(396003)(199004)(189003)(66446008)(99286004)(81166006)(6506007)(386003)(81156014)(86362001)(8676002)(26005)(6116002)(2906002)(71200400001)(25786009)(76176011)(1076003)(102836004)(71190400001)(36756003)(186003)(7736002)(66066001)(107886003)(8936002)(52116002)(256004)(14444005)(64756008)(4326008)(54906003)(478600001)(316002)(14454004)(6916009)(50226002)(5660300002)(3846002)(66946007)(6436002)(11346002)(6486002)(6512007)(446003)(486006)(2616005)(476003)(66476007)(53936002)(66556008)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2751;H:VI1PR0501MB2765.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 3S8wFf0MJYESNJCWfx/KMO7uy5SSA7/zUQ3QQT9p6f6o4I9I0UDLxiJUJH8tbECELHKvFGnxRExgbQgQvosiPzUB41qhcwHiMVQ2cYAxFRI2TfqqLIwzQpANk0Ywz5K78i6OiJJe2KAbUo2Yrm98WTW1kFIZ7NeA/jzF9wLGQqfFwKwSgUmOvtdNWj4xVwwFCavox2ou4xe9k7sgXhJBcjxNm5bkqSIXc7Hwyqj6vooQUMED5kFiVWuQE1vbOpEmxhilaEyGTN5sy0bqAqlSeTxXQGKSRxmH0hqooJYkKdY/7L+M4480ZHw/JnV6GLv6//lbxtHPizD+2e8YA8koUODPpYtaiDZBsxYvJJCcxYz3KUd6HiRVehTMN4jaetrECKXmcRPivs1dZ41MHgaI8+O5JaTaS7Wq+jttb3rmKGw=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5aa924b4-4ffd-418d-fcd2-08d72be99f1e
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2019 18:57:49.6075
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xHQFe53KeDBPPPXWwMdxPBnju6oHOX/Dl+m/VJw3hMqiqvR9iamMDclzSqMFBbo9sYmQyXrUdWUG414i6U4NHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2751
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

