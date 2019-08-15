Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70D8A8F424
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 21:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732483AbfHOTJ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 15:09:58 -0400
Received: from mail-eopbgr00085.outbound.protection.outlook.com ([40.107.0.85]:9262
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731777AbfHOTJ5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 15:09:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b+5m66opalmXVddzj/79QbevoWIYlRj0+3Ra7NMoeJYhAhMJWOfo7+ujpEWBAB/4AsmjO85oc0jKjPI1wDR3KkjK58D58qD91RpUkfCz1kNQS+ptSJWb77jXoAB1n3kSzyYALVncz24QxR7RiE/aEFtZyIh6V2r0d5Ikos0BzPrw3yPKQCEdxjDDCL+Igwb1N9FXGWl02BzLnR8O2xzXjcH3qWMqPsb6YuyDzCC8fkgrMXnPenxxnlcvbRoVhImCdE6Z06RRkpWzJ1mXR531kDuDmAfCKyp1w0RkTbtFRLLAEJigXBoJEgQNYI51+uyJQKQ6Q5sHpwPZp5tqzCNWXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TB0DDbl1Moe5EPYAuWBIWyJ0pBjitc7ClV/ZwETczoI=;
 b=i2hRjng1sqe06jAI2+gb1FLGXMS9k1cvaXyN/y+lB/5unCuwUasi1cFBvV4DdTXQlSK2uH0VsdamuiDklUl4B4BWmf4RadojpkXCil5ywuHdX6+KG8gPhdXGu8ofVHbxJFlDMVsSs5MUXyVZC0mDRBXtjP69UKJjSO02CMJ38mLoAHSvE1wyaFkgG8++Hes7fjgNG0015mvEvwlxK/J/sJtkdW/GfRk30z2Capd+9OCzfXzINwLg7zvJctl/LFcgGIU0gFW/WLdxm4v5XYgIOBs5xKUhXiHqq0Mt0ZDtvUYTYVvaHNQ8NZOZmtbAAgnu9ZT0PuxwN3Qm2JeKSIjKog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TB0DDbl1Moe5EPYAuWBIWyJ0pBjitc7ClV/ZwETczoI=;
 b=rNvmTJrPskxhqzgVejjnZXdtMYqyTrMmjJ5jwMx/+Y0Bm/5SDHwG25egO6cUwu1dzv0xegYGQJc5Yp4HsKEXi2w2NovV1EfZ+C5kw5SILJrkMzTc+Z3sGmm7YNXHTEVLsOHrDdldxuZXJazoAbvaRdBsPqgMKoKEATedUvEBjh4=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2440.eurprd05.prod.outlook.com (10.168.71.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.18; Thu, 15 Aug 2019 19:09:49 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2178.016; Thu, 15 Aug 2019
 19:09:49 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 01/16] net/mlx5e: Rename reporter header file
Thread-Topic: [net-next 01/16] net/mlx5e: Rename reporter header file
Thread-Index: AQHVU50Cd6BD+VPeRk63I8VFHGvz7w==
Date:   Thu, 15 Aug 2019 19:09:48 +0000
Message-ID: <20190815190911.12050-2-saeedm@mellanox.com>
References: <20190815190911.12050-1-saeedm@mellanox.com>
In-Reply-To: <20190815190911.12050-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR04CA0017.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::27) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 56429a98-f124-4537-de33-08d721b4248f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2440;
x-ms-traffictypediagnostic: DB6PR0501MB2440:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0501MB24404D3E17B4DC6E9EECAE0CBEAC0@DB6PR0501MB2440.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 01304918F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(346002)(396003)(366004)(376002)(199004)(189003)(6916009)(2616005)(36756003)(446003)(76176011)(186003)(11346002)(52116002)(305945005)(386003)(7736002)(478600001)(476003)(102836004)(6506007)(99286004)(486006)(14454004)(3846002)(6116002)(8676002)(8936002)(5660300002)(81156014)(81166006)(66066001)(26005)(256004)(50226002)(6486002)(6436002)(107886003)(71200400001)(6512007)(54906003)(71190400001)(316002)(1076003)(2906002)(66446008)(53936002)(66946007)(66556008)(66476007)(64756008)(25786009)(86362001)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2440;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: yRWkJbKxHCE1tt0088w+kDDiapdt4Ax24MVbulD87w/Q2pk1rga79WpPSjf0aIx7WuLiA7Lx4HwbsJFNm/OT/oQGFInjFQMnd3Fa4eYvMsgNkabCfli1D9ar3rb3ZXXdULQKYRog/7+qPgZyLGDAZy+kRdnav75NNR/LBU/PqSAAbXuE+u+TxmJ0EatVxPkaT0Grai9qPNRb0bKxwY05EljL82VE3zp4g9hdS0HVhwm3aSphIU/sVQKGBFZ4ouP1LoxqCBQNHNwvQoIEfbcsBBkCO1r7ResFfNtV/jFDr79BbMTHHgCwhTfgiBxqkDUTEhDi6SgxntsCaCTUWECuw4FFMF6NFTXuaXZiGDLqy8AA2kuu/8JzkzERgYPk9jkYeedaEpBi4xu1WRgw+QQHMIVAeLM0/UVa8OrJwDiwhkE=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56429a98-f124-4537-de33-08d721b4248f
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2019 19:09:48.8822
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E3KabK/WmGX87IPOPGFhwxIKeBIGjT4PgEDqGQQTv7DU5IR31igEMpnrQ1mYLu8Xgzn9Yc2YSTCIOKK1PGQIuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2440
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Rename reporter.h -> health.h so patches in the set can use it for
health related functionality.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/en/{reporter.h =3D> health.h}   | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c      | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c             | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)
 rename drivers/net/ethernet/mellanox/mlx5/core/en/{reporter.h =3D> health.=
h} (84%)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter.h b/driver=
s/net/ethernet/mellanox/mlx5/core/en/health.h
similarity index 84%
rename from drivers/net/ethernet/mellanox/mlx5/core/en/reporter.h
rename to drivers/net/ethernet/mellanox/mlx5/core/en/health.h
index ed7a3881d2c5..cee840e40a05 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
@@ -1,8 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /* Copyright (c) 2019 Mellanox Technologies. */
=20
-#ifndef __MLX5E_EN_REPORTER_H
-#define __MLX5E_EN_REPORTER_H
+#ifndef __MLX5E_EN_HEALTH_H
+#define __MLX5E_EN_HEALTH_H
=20
 #include "en.h"
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/dri=
vers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index 6e54fefea410..7aac9cc92181 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /* Copyright (c) 2019 Mellanox Technologies. */
=20
-#include "reporter.h"
+#include "health.h"
 #include "lib/eq.h"
=20
 #define MLX5E_TX_REPORTER_PER_SQ_MAX_LEN 256
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index 9a2fcef6e7f0..9fc7bc93d607 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -56,7 +56,7 @@
 #include "en/xdp.h"
 #include "lib/eq.h"
 #include "en/monitor_stats.h"
-#include "en/reporter.h"
+#include "en/health.h"
 #include "en/params.h"
 #include "en/xsk/umem.h"
 #include "en/xsk/setup.h"
--=20
2.21.0

