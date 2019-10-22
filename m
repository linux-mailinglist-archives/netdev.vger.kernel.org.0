Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84376E012F
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 11:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731581AbfJVJxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 05:53:31 -0400
Received: from mail-eopbgr780077.outbound.protection.outlook.com ([40.107.78.77]:64688
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730312AbfJVJx2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 05:53:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NE67ScS5STQQflrCtN3t9UZb+heaEHLvi9SKx8ZzbytWZsn4FjmMwdFqx3S15bvsOWQSTTtDZcFJ4a6I04PhAg/F3X68ClSErbGgrfqvK6QJ/DG9r8rQO2cy36JiXsRNrDQpK/714Jx0wtt6XcSxKNZj23BQFg3aU5n1nCfYviOXVBJuFL53zE7mig6n5MX4HIqkEymqoUKY6/mOVs6CDDajJBNC7l42ozP5Ojizfq5nYOVouVMrNYWY0pSfSgi9rVSjMCWIXZSXjR5AB5N4Nmeemn4wlgxiRySOX2cXpQreeScfTpK+lbHt9i3LiFuYXVFxvCWTuiiYOnwefPi/BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2kObToUIXWoGPzRYUW5Fa7hbr2djImCCDe9nLlTYt4c=;
 b=cVs7x2ozvRXJbBaTReniyFQgvy5EorwpY9iaxQk/hOootAQc0Bw8NJCMFCLQj16WkShE6+7PRGlnqN37g5AFRoFLNfEBQ3scrtuWuzysJ8UO5JFmn2+vLwZj/sWvp+LvqKSjKeWKaUINEbKgeEkLG+Y0UneoGCd1Mpm9YSfmV6tqYTQud/E5M0tWW62KiXhdY8HhHxjjVzTkJZJ5Afo1c+LmOSLcPYxo21oBDp5bdJmOEKTfqn4s9WNpVuZsQK2bwzBThTfzvB+zeJ/K3PYEL4dywvs6ejTw+xQQ/69RFXObpPp40bItE3r9ettaJLJw8b/cAI1RPy1MovlTg2KfpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2kObToUIXWoGPzRYUW5Fa7hbr2djImCCDe9nLlTYt4c=;
 b=pQs6bCClwa8Ig14b+blI/JDNDlwLwGpj7vWuPSG4OQqshRQuzPx7C0dcTijkUrOvmO7GHBysz/RUYYQge5SCu1owSaj8CRnskuQ0hX4Vzz+9oJwMdAr8VaMbX6JAsrce766xqlLpKH4Z2Os6AvWSlJjwDErr67tuiN28Kjxt450=
Received: from BN8PR11MB3762.namprd11.prod.outlook.com (20.178.221.83) by
 BN8PR11MB3732.namprd11.prod.outlook.com (20.178.218.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.24; Tue, 22 Oct 2019 09:53:25 +0000
Received: from BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f]) by BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f%3]) with mapi id 15.20.2347.028; Tue, 22 Oct 2019
 09:53:25 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "epomozov@marvell.com" <epomozov@marvell.com>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Simon Edelhaus <sedelhaus@marvell.com>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>
Subject: [PATCH v3 net-next 02/12] net: aquantia: unify styling of bit enums
Thread-Topic: [PATCH v3 net-next 02/12] net: aquantia: unify styling of bit
 enums
Thread-Index: AQHViL6L5JemXOh5jUmtKUN3AAX4kQ==
Date:   Tue, 22 Oct 2019 09:53:25 +0000
Message-ID: <90f9fb2f263dc62dfb06c0c1ca862269dafe38bb.1571737612.git.igor.russkikh@aquantia.com>
References: <cover.1571737612.git.igor.russkikh@aquantia.com>
In-Reply-To: <cover.1571737612.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MR2P264CA0092.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:32::32) To BN8PR11MB3762.namprd11.prod.outlook.com
 (2603:10b6:408:8d::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4f3e9a2a-a355-451d-c11b-08d756d5ae4b
x-ms-traffictypediagnostic: BN8PR11MB3732:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR11MB3732351B90D7DD8B6A1AA3B998680@BN8PR11MB3732.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:820;
x-forefront-prvs: 01986AE76B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39850400004)(346002)(366004)(376002)(396003)(199004)(189003)(2616005)(25786009)(8936002)(81166006)(86362001)(486006)(81156014)(1730700003)(44832011)(476003)(8676002)(50226002)(186003)(71190400001)(11346002)(446003)(14444005)(256004)(71200400001)(3846002)(2906002)(118296001)(66556008)(64756008)(66446008)(6116002)(66476007)(5660300002)(66946007)(6512007)(99286004)(5640700003)(4326008)(54906003)(316002)(107886003)(6486002)(7736002)(305945005)(6436002)(66066001)(26005)(6506007)(386003)(14454004)(102836004)(508600001)(6916009)(52116002)(76176011)(36756003)(2351001)(2501003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR11MB3732;H:BN8PR11MB3762.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: T6+0dkJpt1kOForNwCwqZ4oFQXL24HPjgfJLUcp+MyybzitDUtx/L+230fL6NFORIwykVe7nCqIqujbafSEeMs6jdRQhK60VQDpSasIVUINaAMwbgH/WV5klXT9xzDhXr/mmgd7hgbjGfHr5UVaczAGaoh4CqktQvLd4ZcvppyCgLDmPa+OfribUSNXYkx2tFNBnLuZRk9siSNpyNMSf6IjezxrfXNsUGAMufpVDX/Avd6w28f/6zTxaofCcIEB5cRPqEOn+gN4qEoBnmHtXOlqoipKMVOdBUpkxyl6FlER+r654KiXopjHJSKIf6kPyaNcW6QHxCz/T8GbGd4Z7Q51JiuVp0cb+tXDJy0W2QZEMR0jLk6dtrKfT8KDWCwKBOIDzmI/XrLVo3YEp9L2HkCf6IfR3KsXCYHdllD1Xv9AsGig9V/ojrJEWMAt3t6vj
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f3e9a2a-a355-451d-c11b-08d756d5ae4b
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2019 09:53:25.1246
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D2bB4mt0ALqMVJPWo7NaEsRt1xTo3ea0BB51avBKC1amxR9UvBM58fo+QP/gwValVzmkNTwSM6K413SOsIni5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3732
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Bezrukov <dmitry.bezrukov@aquantia.com>

Make some other bit-enums more clear about positioning,
this helps on debugging and development

Signed-off-by: Dmitry Bezrukov <dmitry.bezrukov@aquantia.com>
Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 .../aquantia/atlantic/hw_atl/hw_atl_utils.c   |  2 +-
 .../aquantia/atlantic/hw_atl/hw_atl_utils.h   | 41 +++++++++++--------
 2 files changed, 26 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c b=
/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
index 52646855495e..32512539ae86 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
  * aQuantia Corporation Network Driver
- * Copyright (C) 2014-2017 aQuantia Corporation. All rights reserved
+ * Copyright (C) 2014-2019 aQuantia Corporation. All rights reserved
  */
=20
 /* File hw_atl_utils.c: Definition of common functions for Atlantic hardwa=
re
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h b=
/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h
index 7121248954df..766e02c7fd4e 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h
@@ -386,38 +386,44 @@ enum hw_atl_fw2x_rate {
 	FW2X_RATE_10G     =3D 0x800,
 };
=20
+/* 0x370
+ * Link capabilities resolution register
+ */
 enum hw_atl_fw2x_caps_lo {
-	CAPS_LO_10BASET_HD =3D 0x00,
+	CAPS_LO_10BASET_HD        =3D 0,
 	CAPS_LO_10BASET_FD,
 	CAPS_LO_100BASETX_HD,
 	CAPS_LO_100BASET4_HD,
 	CAPS_LO_100BASET2_HD,
-	CAPS_LO_100BASETX_FD,
+	CAPS_LO_100BASETX_FD      =3D 5,
 	CAPS_LO_100BASET2_FD,
 	CAPS_LO_1000BASET_HD,
 	CAPS_LO_1000BASET_FD,
 	CAPS_LO_2P5GBASET_FD,
-	CAPS_LO_5GBASET_FD,
+	CAPS_LO_5GBASET_FD        =3D 10,
 	CAPS_LO_10GBASET_FD,
 };
=20
+/* 0x374
+ * Status register
+ */
 enum hw_atl_fw2x_caps_hi {
-	CAPS_HI_RESERVED1 =3D 0x00,
+	CAPS_HI_RESERVED1         =3D 0,
 	CAPS_HI_10BASET_EEE,
 	CAPS_HI_RESERVED2,
 	CAPS_HI_PAUSE,
 	CAPS_HI_ASYMMETRIC_PAUSE,
-	CAPS_HI_100BASETX_EEE,
+	CAPS_HI_100BASETX_EEE     =3D 5,
 	CAPS_HI_RESERVED3,
 	CAPS_HI_RESERVED4,
 	CAPS_HI_1000BASET_FD_EEE,
 	CAPS_HI_2P5GBASET_FD_EEE,
-	CAPS_HI_5GBASET_FD_EEE,
+	CAPS_HI_5GBASET_FD_EEE    =3D 10,
 	CAPS_HI_10GBASET_FD_EEE,
 	CAPS_HI_FW_REQUEST,
 	CAPS_HI_RESERVED6,
 	CAPS_HI_RESERVED7,
-	CAPS_HI_RESERVED8,
+	CAPS_HI_RESERVED8         =3D 15,
 	CAPS_HI_RESERVED9,
 	CAPS_HI_CABLE_DIAG,
 	CAPS_HI_TEMPERATURE,
@@ -427,47 +433,50 @@ enum hw_atl_fw2x_caps_hi {
 	CAPS_HI_LINK_DROP,
 	CAPS_HI_SLEEP_PROXY,
 	CAPS_HI_WOL,
-	CAPS_HI_MAC_STOP,
+	CAPS_HI_MAC_STOP          =3D 25,
 	CAPS_HI_EXT_LOOPBACK,
 	CAPS_HI_INT_LOOPBACK,
 	CAPS_HI_EFUSE_AGENT,
 	CAPS_HI_WOL_TIMER,
-	CAPS_HI_STATISTICS,
+	CAPS_HI_STATISTICS        =3D 30,
 	CAPS_HI_TRANSACTION_ID,
 };
=20
+/* 0x36C
+ * Control register
+ */
 enum hw_atl_fw2x_ctrl {
-	CTRL_RESERVED1 =3D 0x00,
+	CTRL_RESERVED1            =3D 0,
 	CTRL_RESERVED2,
 	CTRL_RESERVED3,
 	CTRL_PAUSE,
 	CTRL_ASYMMETRIC_PAUSE,
-	CTRL_RESERVED4,
+	CTRL_RESERVED4            =3D 5,
 	CTRL_RESERVED5,
 	CTRL_RESERVED6,
 	CTRL_1GBASET_FD_EEE,
 	CTRL_2P5GBASET_FD_EEE,
-	CTRL_5GBASET_FD_EEE,
+	CTRL_5GBASET_FD_EEE       =3D 10,
 	CTRL_10GBASET_FD_EEE,
 	CTRL_THERMAL_SHUTDOWN,
 	CTRL_PHY_LOGS,
 	CTRL_EEE_AUTO_DISABLE,
-	CTRL_PFC,
+	CTRL_PFC                  =3D 15,
 	CTRL_WAKE_ON_LINK,
 	CTRL_CABLE_DIAG,
 	CTRL_TEMPERATURE,
 	CTRL_DOWNSHIFT,
-	CTRL_PTP_AVB,
+	CTRL_PTP_AVB              =3D 20,
 	CTRL_RESERVED7,
 	CTRL_LINK_DROP,
 	CTRL_SLEEP_PROXY,
 	CTRL_WOL,
-	CTRL_MAC_STOP,
+	CTRL_MAC_STOP             =3D 25,
 	CTRL_EXT_LOOPBACK,
 	CTRL_INT_LOOPBACK,
 	CTRL_RESERVED8,
 	CTRL_WOL_TIMER,
-	CTRL_STATISTICS,
+	CTRL_STATISTICS           =3D 30,
 	CTRL_FORCE_RECONNECT,
 };
=20
--=20
2.17.1

