Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 377511079F3
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 22:27:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726813AbfKVV1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 16:27:05 -0500
Received: from mail-eopbgr50063.outbound.protection.outlook.com ([40.107.5.63]:59697
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726620AbfKVV1E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 16:27:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QLA55yJGqT1WqNY9NSC8ehkSZQdLNbQpVMj2cvjWIJ33LW3VyBML84TwOK71vyzAdQfBlLG5Zdb/7eK8T+CIlVUWz5p+5XpDZrky90FubGLMJblkkSCM6YBJofnEjmgWJEoqKvMgG9vjM86cofFsvKJj36a98g0Qh+ko6SpaMNLzS2zMzN1pmlLhxwXWty6BMMkwlkQzrbxlF3F2vktGYRFULc7NhpMJPn7Hvm3Y9mdcj2GQ3lyWHzY83tjzBk0d5rC5EzXdl/DRi1pIBDuRxYtthJ5GvhQXtcN1h9to3MkRWWGImJ8tUf3+4l6Dv9k5w2LDI2JoqJ7dHwggLECncA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z5EkNI4BOcGYXjTqzJOvfwVxIrZOVQUnx4LDWOdMhSM=;
 b=LfF9oTfesTDnHuU9kaXoHdrmLwCejKLgM0Z9fOeHcB6qdZt/VgWjgDg9PySTkny/e1cJMzSal57DLdg8NCYyslFEYn4ZHekwGIbRbc0z8QYiypeNOuZmkAlPiWtqsAr58xa3GeA7yHLh+vIqPMgnMtEfawzgOPd+IIhW2C7aDsTX3BpCpXnU8sxHTi+Xtiww72HGsk6v+8h+b/dnzZBqsX+pzCCuVuSdRjAkzDTrBq+VCbFSjmLAl6zvX41gHzKTpp/W9f9PuwTKDvXH+XiVseu+5vfM7zCWKK+WWmaXSnsuxraOv30AFev0T7a8o4QHz7fzIBqF9+0TM75ILJlxHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z5EkNI4BOcGYXjTqzJOvfwVxIrZOVQUnx4LDWOdMhSM=;
 b=eMM2c4PZdicP+e9CTfpn+Qib5qL9kSTh6FyTrAVsuW+0JYrk1FI2H1HtmTP+6ePm3f/s3ixi+v0cwsDnJe0iPgOAhG244NUMWRRw5byjB0XlnkY1rrzUNr4bFSJ797nuXIOgjjUPUljpsGpVUjBaCgcKa5Ql8GBJId9Uyv+RzYw=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4350.eurprd05.prod.outlook.com (52.134.31.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.21; Fri, 22 Nov 2019 21:26:55 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2474.019; Fri, 22 Nov 2019
 21:26:55 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Eli Cohen <eli@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: [net-next 5/6] net/mlx5e: TC, Stub out ipv6 tun create header
 function
Thread-Topic: [net-next 5/6] net/mlx5e: TC, Stub out ipv6 tun create header
 function
Thread-Index: AQHVoXuQOfrlUbF+l02iyWxCOft5pg==
Date:   Fri, 22 Nov 2019 21:26:55 +0000
Message-ID: <20191122212541.17715-6-saeedm@mellanox.com>
References: <20191122212541.17715-1-saeedm@mellanox.com>
In-Reply-To: <20191122212541.17715-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR03CA0016.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::26) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3933dbf0-a7f4-47ca-7929-08d76f92b2aa
x-ms-traffictypediagnostic: VI1PR05MB4350:|VI1PR05MB4350:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB43501F6014990CAC3B267893BE490@VI1PR05MB4350.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 02296943FF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(136003)(346002)(376002)(39860400002)(189003)(199004)(256004)(6512007)(1076003)(76176011)(107886003)(66946007)(50226002)(6506007)(66476007)(86362001)(52116002)(66066001)(8676002)(6916009)(386003)(81166006)(25786009)(64756008)(8936002)(4326008)(99286004)(66556008)(66446008)(81156014)(6436002)(6486002)(5660300002)(36756003)(2906002)(54906003)(102836004)(316002)(7736002)(71200400001)(71190400001)(3846002)(6116002)(305945005)(186003)(26005)(478600001)(2616005)(14454004)(11346002)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4350;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: M+1l0nO9Igd74u+3wr5SiTAY44h/Lb5DFnQrCvCGNJq/nfOilUwOyf8z5mEeH42lYNAuUHVgsGulGBd2NTAkPv/evoQf2+0sBC7pxmSKqtY07ldK1boiB4iZp0k3ru3ZBmA00hlgP9lNoWK5+3inwXFUS8qyR5SFL5Td5Qc97bEKPlD4cWGx9X59kq6Kc2VqTUCMaDCDEX3INC6kRNGBEpq0Ne7qKFV/7tKdx3r67IFN7QRyU+DJ+lv46X9cnhOyrLueHotFMvhFlPhYdI+fB3Msci04CyB0Qos7QTRJ/fwIKIObVb2ITFOjXZzjWTPAEx1iiaTfVRTouVGJScoBVx+gyejxbFYdhL4W/VpoF1WHFAK6eCEgOOj+9a7PclM80RgWN9gTHyOTO+Oqk+qcDFlYO4uG+bHOFH2jLo7nGBPIUzeppnx/HAiidawiTVTg
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3933dbf0-a7f4-47ca-7929-08d76f92b2aa
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2019 21:26:55.1298
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YsiimeNg/IVg9j1hY+3JjH4Ftql7JUHiPZCKhhoMK1VZsRVuUzgwsxvGOCCG/BSehuPEF0xl6MMrRkyshXs8Uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4350
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Improve mlx5e_route_lookup_ipv6 function structure by avoiding #ifdef then
return -EOPNOTSUPP in the middle of the function code.

To do so, we stub out mlx5e_tc_tun_create_header_ipv6 which is the only
caller of this helper function to avoid calling it altogether
when ipv6 is compiled out, which should also cleanup some compiler
warnings of unused variables.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Reviewed-by: Eli Cohen <eli@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c | 4 ----
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h | 7 +++++++
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c b/drivers/=
net/ethernet/mellanox/mlx5/core/en/tc_tun.c
index 5316cedd78bf..fe227713fe94 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -141,7 +141,6 @@ static int mlx5e_route_lookup_ipv6(struct mlx5e_priv *p=
riv,
 	struct dst_entry *dst;
 	struct neighbour *n;
=20
-#if IS_ENABLED(CONFIG_INET) && IS_ENABLED(CONFIG_IPV6)
 	int ret;
=20
 	ret =3D ipv6_stub->ipv6_dst_lookup(dev_net(mirred_dev), NULL, &dst,
@@ -157,9 +156,6 @@ static int mlx5e_route_lookup_ipv6(struct mlx5e_priv *p=
riv,
 		dst_release(dst);
 		return ret;
 	}
-#else
-	return -EOPNOTSUPP;
-#endif
=20
 	n =3D dst_neigh_lookup(dst, &fl6->daddr);
 	dst_release(dst);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h b/drivers/=
net/ethernet/mellanox/mlx5/core/en/tc_tun.h
index c362b9225dc2..6f9a78c85ffd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h
@@ -58,9 +58,16 @@ int mlx5e_tc_tun_create_header_ipv4(struct mlx5e_priv *p=
riv,
 				    struct net_device *mirred_dev,
 				    struct mlx5e_encap_entry *e);
=20
+#if IS_ENABLED(CONFIG_INET) && IS_ENABLED(CONFIG_IPV6)
 int mlx5e_tc_tun_create_header_ipv6(struct mlx5e_priv *priv,
 				    struct net_device *mirred_dev,
 				    struct mlx5e_encap_entry *e);
+#else
+static inline int
+mlx5e_tc_tun_create_header_ipv6(struct mlx5e_priv *priv,
+				struct net_device *mirred_dev,
+				struct mlx5e_encap_entry *e) { return -EOPNOTSUPP; }
+#endif
=20
 bool mlx5e_tc_tun_device_to_offload(struct mlx5e_priv *priv,
 				    struct net_device *netdev);
--=20
2.21.0

