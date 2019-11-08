Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35038F5BFD
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 00:45:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729833AbfKHXpf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 18:45:35 -0500
Received: from mail-eopbgr70072.outbound.protection.outlook.com ([40.107.7.72]:11398
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726804AbfKHXpe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 18:45:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WeVlIq09jpw9zczxxqPK8NYn/ufyb8T0y+2qGUOT4NPcRmZPpSFZfrYbjEc4Sr5INgOdT5uzAVtxcuwtOLfO4R1KOKGInArig56Bkb1ySlxKAUR/3gFxNTnehSAFFqv5nkXd9fhwK7LcIN6lVkZAiZl/lv7t2Sa6+6H/H+cL+mqlOLHuZzwRbozhnjcJ02/rU4oyXrQ1Tzr5YDDxZmrLnOBWn+b7XPPQgwXbmCo9EfMiSRy1dPgXWbRir3uTp7jQxeBeyeQOiFvHDAUpVXbbQ4DlOgl2L73mJkaY/u1nOSYaTtPpCTZQjHMEek7rqSN4sqj3P87heJLgHFPka44Q+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MdREF3SaV5xjB6ZxouAJRJwjU+JNiYS+HwOjxBvysz0=;
 b=gSiTDH7Els+kH9NYekKV/Z3HyacP36/TC6JkRO72B57flREAUYzBabXyrSU3ThHCLHNspP5i5FUuRc3p0aVa5bvGeJvNZf//UYAAHKXij1APVWStWnxghzQDphO6R92OYVTqbf0xDp851Ju/hCljWGfFNZTEsdhNVRWU6HUHsLq113lfiUMk6GUsr+fGYfMsy2GMzkhzEJP1rwwDia6IIB929SuDa9/7oNiNCua8FHYRzwNLfsWxg4/WwsaAShkyNJNg+oAZwe8fnMvfDNzbMVul3b+HYz1g7uJ5a/ijEemaJLkTw1FPfH4RJ1FhHsoukEl9AKDuKfr2BSpFPAAIFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MdREF3SaV5xjB6ZxouAJRJwjU+JNiYS+HwOjxBvysz0=;
 b=JXQtRATNP+upq29RdQ0l7OP3AR4vYKVc/oJygF5gNlU8yqG+zGF+eMzttoyon6LM1Zh8EL5wVDazRE0zCNzCdeWDymC/meCX8L90KwUo91SOIFuPH8Uf7OP1uxNnrTPeaOhDRONEO6713IjvLLvBvzV+NR8K8j0MVlqtwCYKnEA=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4334.eurprd05.prod.outlook.com (52.133.14.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.22; Fri, 8 Nov 2019 23:45:26 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2430.023; Fri, 8 Nov 2019
 23:45:26 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     Jiri Pirko <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Michael Guralnik <michaelgur@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>
Subject: [PATCH mlx5-next 4/5] IB/mlx5: Rename profile and init methods
Thread-Topic: [PATCH mlx5-next 4/5] IB/mlx5: Rename profile and init methods
Thread-Index: AQHVlo6YGTgbKRV75k+EAVrBa/OBcA==
Date:   Fri, 8 Nov 2019 23:45:26 +0000
Message-ID: <20191108234451.31660-5-saeedm@mellanox.com>
References: <20191108234451.31660-1-saeedm@mellanox.com>
In-Reply-To: <20191108234451.31660-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR21CA0030.namprd21.prod.outlook.com
 (2603:10b6:a03:114::40) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6c1e8ee9-6c55-499e-2ce8-08d764a5bace
x-ms-traffictypediagnostic: VI1PR05MB4334:|VI1PR05MB4334:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4334F67EA51DD2B421DE09A1BE7B0@VI1PR05MB4334.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(136003)(396003)(376002)(39860400002)(189003)(199004)(2616005)(102836004)(36756003)(450100002)(52116002)(486006)(71200400001)(1076003)(71190400001)(6636002)(107886003)(14454004)(4326008)(478600001)(110136005)(256004)(66946007)(25786009)(66476007)(66556008)(64756008)(66446008)(86362001)(5660300002)(316002)(6506007)(6116002)(8936002)(50226002)(3846002)(186003)(6436002)(6486002)(81156014)(446003)(8676002)(26005)(14444005)(2906002)(76176011)(305945005)(99286004)(6512007)(386003)(7736002)(66066001)(54906003)(11346002)(81166006)(476003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4334;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 84a+quNlA2v1HgWLTgnrQ4RZUychLdmPjYQFqbF0A0hTeX5LrcoNyJPdnEsXue3y1wo1v7Z9KE76RHpvni7oSUKw3Oq6xGgUC6ILMwf2Zqfrrm5BpC9qf+cmXwes/JNXROHxDMFI26nSnnPr/Z5dYgmx+sJucffA3qoYdtVkLv8oIAgFq8YbDSZ6K5am/Ml8ij9/Z+oPdDCNS0zqQuVGYzSD7suQrxEkan+okvEcmBwyzUdYVnTNsOpMYxSvYqebWB98DsYgJ5phDGrskrhNsGOkiBIxz3G9/EoNYNcbYaA5bYE2Fy/NG2oZANfR23cfRAo0fcPRZuqKCvX0t9dXEPjLeG+QWfl3U1/9mIVhLJ/C8sqV5hvOIG6NnxauVOMU+v5l9c4mWdBwV0XVALTiHQzP9/5YUZf9A3IVFCXhOWEwKEhjg8gcU/vj4ick+kBm
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c1e8ee9-6c55-499e-2ce8-08d764a5bace
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 23:45:26.4548
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L6SjjPE4fNrcuNQgTk96lVJqm0yRt372uAMO0KPyRJJRAStEuvmKd4rHDAfIc+dLOAK+AzbKVTjmm3YBW44ueg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4334
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Guralnik <michaelgur@mellanox.com>

Rename uplink_rep_profile and its unique init and cleanup stages to
suit its upcoming use as the profile when RoCE is disabled.

Signed-off-by: Michael Guralnik <michaelgur@mellanox.com>
Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/infiniband/hw/mlx5/ib_rep.c |  2 +-
 drivers/infiniband/hw/mlx5/ib_rep.h |  2 +-
 drivers/infiniband/hw/mlx5/main.c   | 14 +++++++-------
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/ib_rep.c b/drivers/infiniband/hw/ml=
x5/ib_rep.c
index 74ce9249e75a..5c3d052ac30b 100644
--- a/drivers/infiniband/hw/mlx5/ib_rep.c
+++ b/drivers/infiniband/hw/mlx5/ib_rep.c
@@ -35,7 +35,7 @@ mlx5_ib_vport_rep_load(struct mlx5_core_dev *dev, struct =
mlx5_eswitch_rep *rep)
 	int vport_index;
=20
 	if (rep->vport =3D=3D MLX5_VPORT_UPLINK)
-		profile =3D &uplink_rep_profile;
+		profile =3D &raw_eth_profile;
 	else
 		return mlx5_ib_set_vport_rep(dev, rep);
=20
diff --git a/drivers/infiniband/hw/mlx5/ib_rep.h b/drivers/infiniband/hw/ml=
x5/ib_rep.h
index de43b423bafc..3b6750cba796 100644
--- a/drivers/infiniband/hw/mlx5/ib_rep.h
+++ b/drivers/infiniband/hw/mlx5/ib_rep.h
@@ -10,7 +10,7 @@
 #include "mlx5_ib.h"
=20
 #ifdef CONFIG_MLX5_ESWITCH
-extern const struct mlx5_ib_profile uplink_rep_profile;
+extern const struct mlx5_ib_profile raw_eth_profile;
=20
 u8 mlx5_ib_eswitch_mode(struct mlx5_eswitch *esw);
 struct mlx5_ib_dev *mlx5_ib_get_rep_ibdev(struct mlx5_eswitch *esw,
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5=
/main.c
index 8343a740c91e..d6afe33d56ac 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -6444,7 +6444,7 @@ static const struct ib_device_ops mlx5_ib_dev_port_re=
p_ops =3D {
 	.query_port =3D mlx5_ib_rep_query_port,
 };
=20
-static int mlx5_ib_stage_rep_non_default_cb(struct mlx5_ib_dev *dev)
+static int mlx5_ib_stage_raw_eth_non_default_cb(struct mlx5_ib_dev *dev)
 {
 	ib_set_device_ops(&dev->ib_dev, &mlx5_ib_dev_port_rep_ops);
 	return 0;
@@ -6484,7 +6484,7 @@ static void mlx5_ib_stage_common_roce_cleanup(struct =
mlx5_ib_dev *dev)
 	mlx5_remove_netdev_notifier(dev, port_num);
 }
=20
-static int mlx5_ib_stage_rep_roce_init(struct mlx5_ib_dev *dev)
+static int mlx5_ib_stage_raw_eth_roce_init(struct mlx5_ib_dev *dev)
 {
 	struct mlx5_core_dev *mdev =3D dev->mdev;
 	enum rdma_link_layer ll;
@@ -6500,7 +6500,7 @@ static int mlx5_ib_stage_rep_roce_init(struct mlx5_ib=
_dev *dev)
 	return err;
 }
=20
-static void mlx5_ib_stage_rep_roce_cleanup(struct mlx5_ib_dev *dev)
+static void mlx5_ib_stage_raw_eth_roce_cleanup(struct mlx5_ib_dev *dev)
 {
 	mlx5_ib_stage_common_roce_cleanup(dev);
 }
@@ -6807,7 +6807,7 @@ static const struct mlx5_ib_profile pf_profile =3D {
 		     mlx5_ib_stage_delay_drop_cleanup),
 };
=20
-const struct mlx5_ib_profile uplink_rep_profile =3D {
+const struct mlx5_ib_profile raw_eth_profile =3D {
 	STAGE_CREATE(MLX5_IB_STAGE_INIT,
 		     mlx5_ib_stage_init_init,
 		     mlx5_ib_stage_init_cleanup),
@@ -6818,11 +6818,11 @@ const struct mlx5_ib_profile uplink_rep_profile =3D=
 {
 		     mlx5_ib_stage_caps_init,
 		     NULL),
 	STAGE_CREATE(MLX5_IB_STAGE_NON_DEFAULT_CB,
-		     mlx5_ib_stage_rep_non_default_cb,
+		     mlx5_ib_stage_raw_eth_non_default_cb,
 		     NULL),
 	STAGE_CREATE(MLX5_IB_STAGE_ROCE,
-		     mlx5_ib_stage_rep_roce_init,
-		     mlx5_ib_stage_rep_roce_cleanup),
+		     mlx5_ib_stage_raw_eth_roce_init,
+		     mlx5_ib_stage_raw_eth_roce_cleanup),
 	STAGE_CREATE(MLX5_IB_STAGE_SRQ,
 		     mlx5_init_srq_table,
 		     mlx5_cleanup_srq_table),
--=20
2.21.0

