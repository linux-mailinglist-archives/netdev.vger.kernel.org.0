Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13B96ECA96
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 22:59:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727280AbfKAV7G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 17:59:06 -0400
Received: from mail-eopbgr20063.outbound.protection.outlook.com ([40.107.2.63]:44510
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725989AbfKAV7F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Nov 2019 17:59:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AzWSIXHj/eY1nkjSoOG35PebmJWWreOyUnTvS8vlDgIglikQbHugbG1CuKkd8u5dV1zM1GnTGE3s4Rq6PTDGUyKqjudCGJujfHsFH3tMIPmv97YFgugBmpGReMRHlM8+b60Bli0OHuYNM5tq2BPkOawRHt22TxtUcbh4kq15vp2YJCwaeV/tQKdiD8tZmqYtjxzrmuOPtnr5ZR+CYm53TvCu6Q/f3KMTp+IcF7uaUpUkHKCflNTlvmt0ZF9mX+NaXcTAqJFdFBMpeajZanoLwEcyNdK1057e+xEID8q75AQ+G+rnAEKfmIb3k+04PBZIg94do6CYSQGLEEIk4Rbifw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OoY5bDFajYDw6hSnbkxSaCtEKC4/3R190uw228i7rew=;
 b=dbgHHgRvY3pWocw0WrQIBRVW4mWQYfebiUUEPnS+A7BMf7OF4bCpl66WtoHTWTZIDYsr7BgB+MsN1MyVdFrqgAwVXmm/JIN/pPt0fW0KDvASP/QxTn+Vs3tY930aeLgfcovkR8zdDMmTC9FiBqKmuCI9zMxu/DNTDD9DNyC0fZGxm5cVivVIeAtPbSYWgejwEbMA4xB8Gja9msfKPktQUmVYw9OTxMg5XYTysdlrZixNRMl6FNunbpihHd5dldpDgX0qYhqqckd5yMkciP5x1Rm9rZwFebbpgQs6589yfOXi8GEQUONlguvdKjmp0JrD5tS/QCHtc5w9szaztYWyvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OoY5bDFajYDw6hSnbkxSaCtEKC4/3R190uw228i7rew=;
 b=HAcgyWJ9sAOalUPgt2p5I00GhWACHLooQPMi7MlKeUGFQnsl/tnz0OjPeXBDH77G5jSJgcyfHVqJ6Nh8ykqbVj8A7qtizlMsl6MZrlMF6Kb3BhagGG7bD7ItpJfYOSikAGFmVETiQS7suLTwcMMwnO+A7kmYbGbTxaiuXY0kTGY=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6173.eurprd05.prod.outlook.com (20.178.123.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.24; Fri, 1 Nov 2019 21:59:01 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2408.024; Fri, 1 Nov 2019
 21:59:01 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        zhong jiang <zhongjiang@huawei.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 03/15] net/mlx5: Remove unneeded variable in
 mlx5_unload_one
Thread-Topic: [net-next 03/15] net/mlx5: Remove unneeded variable in
 mlx5_unload_one
Thread-Index: AQHVkP+R87Ea8dUsQEK/ff7+0/2eZQ==
Date:   Fri, 1 Nov 2019 21:59:00 +0000
Message-ID: <20191101215833.23975-4-saeedm@mellanox.com>
References: <20191101215833.23975-1-saeedm@mellanox.com>
In-Reply-To: <20191101215833.23975-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR05CA0076.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::17) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4c3a8ef3-7894-4060-6bdc-08d75f16b3c5
x-ms-traffictypediagnostic: VI1PR05MB6173:|VI1PR05MB6173:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6173604AE84FEF586965C280BE620@VI1PR05MB6173.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:813;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(396003)(376002)(39860400002)(136003)(189003)(199004)(476003)(5660300002)(486006)(14454004)(107886003)(76176011)(7736002)(478600001)(66066001)(52116002)(2906002)(71190400001)(8676002)(71200400001)(6486002)(102836004)(81166006)(36756003)(81156014)(50226002)(6436002)(386003)(8936002)(6506007)(25786009)(66446008)(66476007)(6512007)(6116002)(3846002)(6916009)(26005)(99286004)(11346002)(66946007)(64756008)(86362001)(305945005)(54906003)(4326008)(316002)(1076003)(186003)(446003)(2616005)(256004)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6173;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 01c2vpcU3ZxymcTc+eL+9zdAV1WM1RbEfIAeCjCyY9Bc+eLhoBJ8Ha4eD9KmjwRanQgiTtG43m3ijUp++vX+mF18A8gi8gXarht+Q2IJ6cTQqk5+yjVkXFtCo6VFKhfblV0eV0FL88WVwyqhV5ry1ZUKx6+DWnBU6Xss83BxaHXotccdGmkr7I7L5sbhRh0fizVfIVTSyF902T+z6thYG5DcFF3qq5hGxLIU8jzb/2WFj4Pr8CdlPl16B3FUv1aZ8HIGEjwdqgPuXFTLPSxLAMNp+5bhVrjZ5fo8USks/b/dbQWzwE58brdB//tPcwKHCMrilia3MVlSgCpg2Nc9mftvc0YJWqv98yNS46OQCs9590krxVzOzfSyn6gvunRj1lFR3L45sG4AkpHG6nGHsPgmCPgNq0QDNuNOw8W9mcrSLzuB7QtMr7RdHPExpZKq
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c3a8ef3-7894-4060-6bdc-08d75f16b3c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 21:59:01.0041
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IhnmnaiutaM+hcw5uCREaxro6TPmS/e2nrydB/RKGQA9b9L9DMpLIGYurGE9DzO1p4uNtfmWgXg8VfCxj50Elg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6173
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: zhong jiang <zhongjiang@huawei.com>

mlx5_unload_one do not need local variable to store different value,
Hence just remove it.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
Acked-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/e=
thernet/mellanox/mlx5/core/main.c
index e47dd7c1b909..c9a091d3226c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1228,8 +1228,6 @@ static int mlx5_load_one(struct mlx5_core_dev *dev, b=
ool boot)
=20
 static int mlx5_unload_one(struct mlx5_core_dev *dev, bool cleanup)
 {
-	int err =3D 0;
-
 	if (cleanup) {
 		mlx5_unregister_device(dev);
 		mlx5_drain_health_wq(dev);
@@ -1257,7 +1255,7 @@ static int mlx5_unload_one(struct mlx5_core_dev *dev,=
 bool cleanup)
 	mlx5_function_teardown(dev, cleanup);
 out:
 	mutex_unlock(&dev->intf_state_mutex);
-	return err;
+	return 0;
 }
=20
 static int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
--=20
2.21.0

