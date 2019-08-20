Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16DFB96A72
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 22:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730878AbfHTUYT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 16:24:19 -0400
Received: from mail-eopbgr50051.outbound.protection.outlook.com ([40.107.5.51]:14918
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730821AbfHTUYS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 16:24:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RjheOF3UGfKuvgNWHQhlIB+I7ZwlmHsd47duluG98J/usFlm0CQoRKqkAc1kMNed7tJGj/feQisr29IfVMHPEdc6qMfrXQmCqjN+esg2vqmBasVAGtZCOO0XW2NOpTwWO/xywWXG0EqnVGGeSoQU/ziokHhiy/mNRn89PlQbRhyN6FKI1GuxMM1bNc03FrEUesuc+luAeJ7JHK6MCbUfGFmqafS/91y9lgJSFlxgNkmVgJI9rgvZCCPvfQAVWDk3msVV5KY9EBjG7JsKqoJP1McbI4Y265HRplBEPE1PDgF2Iw6PfxGjSRyatvXBjfEiWijOuM7Dk7tnO/yEwVvZcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cxJYmGpIlQ49B+8FxVndCcpSaNP00AR4rPAI19hDUec=;
 b=Xzkd2NFofqRSlhRP6WTGhfA+jUdeNy7nk27kkqwy5XU1a3fvvfUK8se9cJpL/G9PlbX/gxka9uRwQzPWOd6uqkzTJF9hHvaYK+Qs+06lzLqWQdAGSxWl/rcKOyIqll/7b2iCPIf3Y6KrMChvbS0lkfHmyJRrSUxPsFb1ej75oXwnmOO10dZcF6fHeH/89pAY98SHU/zNbkdSLvijGQJEyCfho7UUiFWzlB/MX1jE4F7rVj19zaB4ueWNVZ713Y4BcR9kEuICaufRr7SGV1AFUJQlNW63TWso/7RWdm04d0SIGsZWNH7xEiALZDP6AI8M6+ZmAV7XHMWFzr9UKb8gBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cxJYmGpIlQ49B+8FxVndCcpSaNP00AR4rPAI19hDUec=;
 b=djDah5XbgATsBQgJYItPcYhDeInsFk1/wCJU3W0btBXXGIkNC/sbRDq34VGltIual9MNvm0WwXAwNUISepaq303baVlFzIJTL0kih3Ne830wBOdGm1XJlrkvni1+2NLoEL8lDYG7V3ojnN8geKmmEJBFpiA1NWrGPGU01qfI1QI=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2680.eurprd05.prod.outlook.com (10.172.226.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Tue, 20 Aug 2019 20:24:12 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2178.018; Tue, 20 Aug 2019
 20:24:12 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next v2 01/16] net/mlx5e: Rename reporter header file
Thread-Topic: [net-next v2 01/16] net/mlx5e: Rename reporter header file
Thread-Index: AQHVV5U61Gpb89dmZUaY/bS7ivK2aA==
Date:   Tue, 20 Aug 2019 20:24:12 +0000
Message-ID: <20190820202352.2995-2-saeedm@mellanox.com>
References: <20190820202352.2995-1-saeedm@mellanox.com>
In-Reply-To: <20190820202352.2995-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0046.namprd02.prod.outlook.com
 (2603:10b6:a03:54::23) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 23f23a2d-a752-44c3-0e62-08d725ac5d4b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2680;
x-ms-traffictypediagnostic: DB6PR0501MB2680:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0501MB2680D393576B324EBECA6723BEAB0@DB6PR0501MB2680.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 013568035E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(346002)(39860400002)(396003)(199004)(189003)(446003)(11346002)(486006)(86362001)(476003)(8676002)(14454004)(81156014)(8936002)(25786009)(26005)(6486002)(102836004)(386003)(53936002)(6506007)(5660300002)(36756003)(6436002)(478600001)(7736002)(186003)(52116002)(99286004)(76176011)(6512007)(81166006)(66066001)(2906002)(2616005)(50226002)(4326008)(1076003)(64756008)(66556008)(256004)(66446008)(6116002)(66946007)(3846002)(6916009)(66476007)(316002)(71190400001)(71200400001)(107886003)(305945005)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2680;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: REB4pTCUqKOI9lW4weHh7EsgI/Y0armrKfeP1GIxQbc2b1tnft3OC0KhbvEbh5R8P8FV1QozHPwXAB4hU18rwNa3u3UhACRpfQHwq7bOUva40qyXxmOdu2ynm4KZPwJZJEB/PH960a6PuwDUjpNRcIMREHkurVlbbJrA6idLPy8oQja/T9/gy0KfagQ09eWPivuTxwe4n8fhyJMSnxkvlkAcpMLYFLu7TNf1ELscT5uFRIIIz25rvDzXNQ1bEwh73h9YV2Ayn1CNbdoPfr4R3K+wSUCZs/QI4fIBwWusD1QvTyOTtBnNrxLxAfSCzub6m3J9P1Bc4xiiNMRSu1ZvMZFFRuBKTRDLvB3jOpP1gNA/MZ63FQp0uryZDYvDwwEyvcZp3yanvvBACNFK9lKbO+rT4Pl5+OAMu5nWEVUNCnA=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23f23a2d-a752-44c3-0e62-08d725ac5d4b
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2019 20:24:12.8336
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6YpckB1wWTJGZpX8gb8QsYJ+0/Gm1p/fXnKdaqDF6aVU+CDPmuaI+lUyLfIURFJPkPwk6oBQG0mMWphoFCLknQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2680
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
index 817c6ea7e349..9ff19d69619f 100644
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
index 0c8e847a9eee..09a68b84cce0 100644
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

