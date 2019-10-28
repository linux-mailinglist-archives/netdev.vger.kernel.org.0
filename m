Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCD3AE7CEB
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 00:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731590AbfJ1XfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 19:35:02 -0400
Received: from mail-eopbgr60072.outbound.protection.outlook.com ([40.107.6.72]:18405
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725951AbfJ1XfB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Oct 2019 19:35:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jMksi0FtDnZODoXtGFeCscucxvIWjTLRah+vS1JJHPajdeWUxLQsKj0TAl/NEwi4TbNEss2AmK1EC6vyYeuV4DUYc1bj91v7jXYtgx0OKDY10qEXJs3ryphaGDwrlqAve+D+T00yPVjwbTzEjNXZ1BR8PYaewf60niLza4QcfAHdRJPceZHJa3e6rxWLQn7+PDZIwcuLmdLxILGrrVpr/fCQ3NuIGcmzGwq959iE0AYrvTSeP2ONz3Nk0CA9mC+kloqDcgt9yw/qvGNtjXw0tgWdyRG1rmGbduJM61lVktAfffvycZ/W9Bz16Dcnd+VT5ZFHET0TmyEu7SonwwD4vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pkuIRp8nItLZn/xHGjn2c2QuYgfYNBv2nzegUoIiR9Y=;
 b=EdWvNLzGyLv/XHw41RnKKGLM9/VuwJS+LLXszt9yoqtA4BAW4+nrlqusmtuGrVL6PmyE8IlzA5I/65lzEum+v9dwW3lvqe0E3czZuEKazshRa936q+mkdGICdc9cL7nHS6+efhQxCGCM42LHd5iYt9jqRarDYHWLW4A17xCuueabEXXKKLKxd5CzhTdLt8Qw9ePTXmuhVrWwinsh7PB1JEilndVqnPJly7tHzLvk+GzZrKaFfbO6PiwHLQwLMzJDhBdAkwBYJ/Tr/w2WaBi3i49rfLzCi6vvyi65iifguC45qg8iUreEB+Pi6aiPeHcV64toGz1d7g3EF7IBlANjZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pkuIRp8nItLZn/xHGjn2c2QuYgfYNBv2nzegUoIiR9Y=;
 b=aazUPItWSdCY+xGpBoaYFncfpC23mIPZ7DjqH2qdWGwjJIl8Ff3arR6qK+LytSTaRAp2yEPHIUhKbASTzzA9oWmYz3umMBxmch3i60kve9WgfYpiw+GbZ3K+05kpPpYXZG7HjxMseC0R7TMih2lus/kdJ/Ggnb+CEIK2xdJsDsE=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6448.eurprd05.prod.outlook.com (20.179.28.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.22; Mon, 28 Oct 2019 23:34:57 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2387.027; Mon, 28 Oct 2019
 23:34:56 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Qing Huang <qing.huang@oracle.com>
Subject: [PATCH mlx5-next 01/18] net/mlx5: Fixed a typo in a comment in
 esw_del_uc_addr()
Thread-Topic: [PATCH mlx5-next 01/18] net/mlx5: Fixed a typo in a comment in
 esw_del_uc_addr()
Thread-Index: AQHVjehOKVn118KPQUSkRxW0IXSHAw==
Date:   Mon, 28 Oct 2019 23:34:56 +0000
Message-ID: <20191028233440.5564-2-saeedm@mellanox.com>
References: <20191028233440.5564-1-saeedm@mellanox.com>
In-Reply-To: <20191028233440.5564-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR13CA0021.namprd13.prod.outlook.com
 (2603:10b6:a03:180::34) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: dd7b8af5-01eb-4307-a56d-08d75bff70ed
x-ms-traffictypediagnostic: VI1PR05MB6448:|VI1PR05MB6448:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6448D276977E747AF2392A5CBE660@VI1PR05MB6448.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 0204F0BDE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(346002)(396003)(39860400002)(189003)(199004)(3846002)(305945005)(8936002)(316002)(478600001)(4744005)(50226002)(86362001)(99286004)(71200400001)(81156014)(8676002)(81166006)(71190400001)(186003)(66446008)(386003)(102836004)(6636002)(6506007)(14444005)(66476007)(66946007)(256004)(36756003)(52116002)(476003)(2616005)(11346002)(486006)(446003)(64756008)(6512007)(76176011)(6116002)(4326008)(26005)(7736002)(5660300002)(66066001)(14454004)(2906002)(110136005)(6436002)(6486002)(54906003)(1076003)(25786009)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6448;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZDuVVsichE43BdliTYn7Gc1waG63sZvIP+G8xNngS03uvazb0/DNWEsvbCTYg+S37clnTPMIYcJQ5JlTcxsYrPt41VMW2HEcuB/Qv4KXZOwI/Yw7Y7AypRwNdVCVVeV5wJmQmnWYRp+NxQACr1uLc2TOQFhmpPcMKknwLZEh9rJiLMix/G6znKDtYcB66LmITcIbRUMOV0jUcC85pe00f+HHhj8Mbp/kX8tqB8/af0i2t3ICDWREL+Pkqdkrdmu1CYnmbIQ+MGVIfo53vaVMHGTzur6CI/ujX8rVxlz8Yj7w9Su/9/uw9Bp1k+wh+VtCgYn1Y7oHhSjF3vOwt7yazg0AQ4NOo32UmNec2iYr44xrWLFOgRBpL+62Q1H0lVU1d2EtNI7LqKG3dil93xlPZnJQ4hwQ5xMTS7AKzzxfjwhmT0qdcfq2CI0b8yq4XIyv
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd7b8af5-01eb-4307-a56d-08d75bff70ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2019 23:34:56.9053
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Oghn4XeDBGx84CX9Cxf2Aldke1ZtwVNv4btFY6TvGtoymIZIf2OcoNg6gUe2t9ClGcT/7+fb0Y72NQ9SMa1Gqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6448
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qing Huang <qing.huang@oracle.com>

Changed "managerss" to "managers".

Fixes: a1b3839ac4a4 ("net/mlx5: E-Switch, Properly refer to the esw manager=
 vport")
Signed-off-by: Qing Huang <qing.huang@oracle.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.c
index 30aae76b6a1d..4c18ac1299ae 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -530,7 +530,7 @@ static int esw_del_uc_addr(struct mlx5_eswitch *esw, st=
ruct vport_addr *vaddr)
 	u16 vport =3D vaddr->vport;
 	int err =3D 0;
=20
-	/* Skip mlx5_mpfs_del_mac for eswitch managerss,
+	/* Skip mlx5_mpfs_del_mac for eswitch managers,
 	 * it is already done by its netdev in mlx5e_execute_l2_action
 	 */
 	if (!vaddr->mpfs || esw->manager_vport =3D=3D vport)
--=20
2.21.0

