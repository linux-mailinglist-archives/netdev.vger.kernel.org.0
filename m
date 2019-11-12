Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5276F96CA
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 18:14:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727361AbfKLROC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 12:14:02 -0500
Received: from mail-eopbgr60074.outbound.protection.outlook.com ([40.107.6.74]:60022
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726954AbfKLROB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 12:14:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X0a529ESoLQKFqnIcaHmcIa7/8Po4eJRHvfichTCrl0zQZuyrEb9mGhOgeN+NvGZ4zxqm1EAJosx5rA71z2rGPZ7wKYA2u9dwZHTRO3ort9htijI3QPmEXcsWTdrcobZkKejC8wyNNG9Q/XZazxMJZUNQuVzaTAOuGy+MLAJtQoCwCwU7z0mUmYcmSN0XtUbQeo8yhBI+wWSGerQX0IAymyNUf+09P2EeD1dhXH3WF8101Z9aADQ3L3qYMQnIM3NfjFBrDFgqG2Dn7w4wvQMpyjhvr3CBN6Z/tYUobRJY0Lp9Ivowbm/+E41Ui1OqhFvcfrTqxEAxtvhgL+iFA0Slg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lxpWWJqx8SGzPA72QSju271vqByq6OPFcGGbA+i1laM=;
 b=n5Lapnp1Q5rbfItarVSGEWBg2cL9hdKuGpuOeyy2ETSVEfuFagvBZHZ0hlBzuKvaQ4q2W40Ps3z0hI+RPO14/70j3ABHIjvpgIQ4xFUQ2AzPFPGTiwItGXLoTPVe4G/BRK1toDrtvxPBDQEOlaV0ym1h9QV4nB7WFSEY/7c4AQm8Qxw8qAfokJZEFyce+tn2Ax85WBRRS6FkAy5c+s3s4KGrgQoWgfMkD8VpE4txQNsV2j7vrK8EpcEFh2+ZAiY7gRDZk0EkMfXvRG6mV7OTCf9o94ZjEunGWiGDYE/8hNPEPm/9j1rYFYLdmzLyJ+mI4AbFPdpk5IDDBaQ3MqxbLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lxpWWJqx8SGzPA72QSju271vqByq6OPFcGGbA+i1laM=;
 b=LtcYRELfSVz1mN9k/FhdXM0P7opAJFYCb3sxtXs9jmfs8VDY1h8EAcybpupJZhklrokFI7ZprKdzmQK0ZqC0wWPYU1NdqDbClVPDqEex/KVIHr+3GPloJsL4+AxqEE26mcha3RRW4AAFUDSd6hADhXNxYoRkEZuHEb4UI/mTH5c=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6078.eurprd05.prod.outlook.com (20.178.125.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.22; Tue, 12 Nov 2019 17:13:44 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2430.027; Tue, 12 Nov 2019
 17:13:44 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eli Cohen <eli@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 3/8] net/mlx5: Remove redundant NULL initializations
Thread-Topic: [net-next 3/8] net/mlx5: Remove redundant NULL initializations
Thread-Index: AQHVmXyJtlXe0EsY3EmIvUgHVx4yZw==
Date:   Tue, 12 Nov 2019 17:13:44 +0000
Message-ID: <20191112171313.7049-4-saeedm@mellanox.com>
References: <20191112171313.7049-1-saeedm@mellanox.com>
In-Reply-To: <20191112171313.7049-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR06CA0059.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::36) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1dae51e3-172d-4710-ade8-08d76793ac03
x-ms-traffictypediagnostic: VI1PR05MB6078:|VI1PR05MB6078:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6078BEE7374B2FA6852355CCBE770@VI1PR05MB6078.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:580;
x-forefront-prvs: 021975AE46
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(366004)(396003)(376002)(39860400002)(199004)(189003)(71200400001)(446003)(71190400001)(11346002)(3846002)(76176011)(6506007)(386003)(52116002)(256004)(316002)(476003)(2616005)(486006)(6116002)(66446008)(1076003)(102836004)(66946007)(54906003)(6512007)(64756008)(66556008)(66476007)(86362001)(5660300002)(305945005)(2906002)(6916009)(7736002)(8676002)(81166006)(50226002)(8936002)(6436002)(478600001)(6486002)(14454004)(81156014)(36756003)(26005)(186003)(25786009)(99286004)(4326008)(107886003)(66066001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6078;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fc0ShXPy4Wbe0p0+d/uhsKX9rmLCGf62fLNcdoJ0psAfQ22ccQ2gsDPeJqNztNfl2J2F8HQS6FZLAIuhm6e9Cij4fLxEka1yerYTs8AAiTp+UTkjd1IHkhQojhezVEfL824C2IybJiDyAgjeyZ2GqVVIMImt6TWNJd4touVpol0jBQ+BeTCwCenrQw6S2t1FP7LtXvrDcC/BoJcoatqOtC1MwQ44NRaGrqbQUDNKG+JqiXohvnJs5kVoVI/XISFJziGimFEIvvS5l1mV5njKou8jLA8uh1caN+b3FoJ3KcgiNA50exMo88frArWWQo1NavbKHrgBIQlm3VPDznpDw7e9YOGgdRKFYNMrnyt2bZ8XYovaJw5+vazI2Ov4j+AOqcoLWw7Fu8ZOYvweX0dD/D4S1AKd4eyMvIPyuw5u76DnTu/EUAAindBtUl0RFSIN
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dae51e3-172d-4710-ade8-08d76793ac03
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2019 17:13:44.1799
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gxeWOH+59x9LK9o/Jcou6arj/AUqUi0n2U81ND8FSuXNFCY1yKOC4QzrjRBzroYMFcqKiQ2qb5kYpOBUCK5LIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6078
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <eli@mellanox.com>

Neighbour initializations to NULL are not necessary as the pointers are
not used if an error is returned, and if success returned, pointers are
initialized.

Signed-off-by: Eli Cohen <eli@mellanox.com>
Reviewed-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c b/drivers/=
net/ethernet/mellanox/mlx5/core/en/tc_tun.c
index 13af72556987..4f78efeb6ee8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -77,8 +77,8 @@ static int mlx5e_route_lookup_ipv4(struct mlx5e_priv *pri=
v,
 				   struct neighbour **out_n,
 				   u8 *out_ttl)
 {
+	struct neighbour *n;
 	struct rtable *rt;
-	struct neighbour *n =3D NULL;
=20
 #if IS_ENABLED(CONFIG_INET)
 	struct mlx5_core_dev *mdev =3D priv->mdev;
@@ -138,8 +138,8 @@ static int mlx5e_route_lookup_ipv6(struct mlx5e_priv *p=
riv,
 				   struct neighbour **out_n,
 				   u8 *out_ttl)
 {
-	struct neighbour *n =3D NULL;
 	struct dst_entry *dst;
+	struct neighbour *n;
=20
 #if IS_ENABLED(CONFIG_INET) && IS_ENABLED(CONFIG_IPV6)
 	int ret;
@@ -212,8 +212,8 @@ int mlx5e_tc_tun_create_header_ipv4(struct mlx5e_priv *=
priv,
 	int max_encap_size =3D MLX5_CAP_ESW(priv->mdev, max_encap_header_size);
 	const struct ip_tunnel_key *tun_key =3D &e->tun_info->key;
 	struct net_device *out_dev, *route_dev;
-	struct neighbour *n =3D NULL;
 	struct flowi4 fl4 =3D {};
+	struct neighbour *n;
 	int ipv4_encap_size;
 	char *encap_header;
 	u8 nud_state, ttl;
@@ -328,9 +328,9 @@ int mlx5e_tc_tun_create_header_ipv6(struct mlx5e_priv *=
priv,
 	int max_encap_size =3D MLX5_CAP_ESW(priv->mdev, max_encap_header_size);
 	const struct ip_tunnel_key *tun_key =3D &e->tun_info->key;
 	struct net_device *out_dev, *route_dev;
-	struct neighbour *n =3D NULL;
 	struct flowi6 fl6 =3D {};
 	struct ipv6hdr *ip6h;
+	struct neighbour *n;
 	int ipv6_encap_size;
 	char *encap_header;
 	u8 nud_state, ttl;
--=20
2.21.0

