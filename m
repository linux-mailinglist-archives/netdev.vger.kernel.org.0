Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1CCBCF79D
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 12:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730579AbfJHK4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 06:56:52 -0400
Received: from mail-eopbgr790080.outbound.protection.outlook.com ([40.107.79.80]:64603
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730026AbfJHK4v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Oct 2019 06:56:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lnijGp4FvEQOqKQ6rEmkTyxswRCJI00yN2Q2DEigq3vNasm/kYKzsqFtlXNRG7Ke+mgeHRMWZmxnr0ZB/PaF+ZqBvSFRGtBIbdw96cHF1uT++gbqxIHUYEG7nPNg5l5NxVET4nDHnMm8IcEgdrhqNLbdrppSriIbOcBKl+k4PKqcfo6+TFX6B+azKNViLqSOHlHKOnQbrD3p+OUO+OoH4pXCqgT6geJh3BGNmieBF503j2whe2kw6n/BXP4nekP48VNh3IJvX340y3qmLIkM8KhclyWCIyCN9AplRfV/TY374Uyh+zwyh+8M9Tim5uw/y/32YmNz3kLDvz96qHpfbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eDnd+r94a07ED+vgdhyrcJ8HrqHtTB8XDGLrPxSw5t8=;
 b=OVt9nQ+IJ00cGxwlFw5Fn9ALEmBflgVtplf/KVaG2Kh6AGFEvpehQOFgJHdaNb5MsHLlrnbV+aNBUmbHbAhLgoh6Teuqc5jy+8kfK8sNq83/DaHvnf+dhSOyL+1NwxeRQBInVqoaajYYWRxrKLuXdvzFm0b1GbC+rT2ziOh92/DZ8CwaTjHkYQkw+mkt2Yv+crPJmIWK9+BENXwvNiwMdFQMxqin32mZeFlDdMkltwBBGc1OOF+TyLrFb6JcfYAM3CSdU7seGlG2/bGj9ApfRvDSbjenta8UxjAvEWcIqI46i2cJy3QBkkMk3bddAXKJURUtKWpXSO17N9VRqfqe/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eDnd+r94a07ED+vgdhyrcJ8HrqHtTB8XDGLrPxSw5t8=;
 b=dj/QDT24h8VRbzqQv5xqrdVMT0GpukOAGJX3JppV2sHbX7se4q8KTsGPrmMW5gTNNyjOIymzq1rof7gIPMgOMVPwmLRLG8w7UfHuTwUrq9/tVDPm5amgb8vplSZsOEmY8YfAl2QQLFHcoHgZ3BkgkZxGscWC2Ht0pnb1SEyZUVA=
Received: from BN8PR11MB3762.namprd11.prod.outlook.com (20.178.221.83) by
 BN8PR11MB3666.namprd11.prod.outlook.com (20.178.221.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.24; Tue, 8 Oct 2019 10:56:38 +0000
Received: from BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f]) by BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f%3]) with mapi id 15.20.2347.016; Tue, 8 Oct 2019
 10:56:38 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Egor Pomozov <Egor.Pomozov@aquantia.com>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Simon Edelhaus <sedelhaus@marvell.com>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>
Subject: [PATCH v2 net-next 02/12] net: aquantia: unify styling of bit enums
Thread-Topic: [PATCH v2 net-next 02/12] net: aquantia: unify styling of bit
 enums
Thread-Index: AQHVfccPodbSSShC/0CpgbsRdtAAqA==
Date:   Tue, 8 Oct 2019 10:56:38 +0000
Message-ID: <e109ffd5253f59f25f71faf57f4f6c081c080ec8.1570531332.git.igor.russkikh@aquantia.com>
References: <cover.1570531332.git.igor.russkikh@aquantia.com>
In-Reply-To: <cover.1570531332.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0215.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1f::35) To BN8PR11MB3762.namprd11.prod.outlook.com
 (2603:10b6:408:8d::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7e59b0a9-4568-4416-bf4d-08d74bde317b
x-ms-traffictypediagnostic: BN8PR11MB3666:
x-ld-processed: 83e2e134-991c-4ede-8ced-34d47e38e6b1,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR11MB3666CF16A44BD7500F358130989A0@BN8PR11MB3666.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:820;
x-forefront-prvs: 01842C458A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(346002)(376002)(396003)(39850400004)(136003)(189003)(199004)(118296001)(71190400001)(71200400001)(2501003)(256004)(14444005)(6916009)(305945005)(316002)(107886003)(2351001)(4326008)(2906002)(44832011)(6116002)(7736002)(3846002)(54906003)(6486002)(6436002)(11346002)(5640700003)(6512007)(99286004)(25786009)(66556008)(50226002)(76176011)(52116002)(5660300002)(8936002)(2616005)(81156014)(66446008)(102836004)(81166006)(8676002)(386003)(6506007)(508600001)(14454004)(26005)(36756003)(86362001)(446003)(64756008)(476003)(486006)(66946007)(186003)(66476007)(66066001)(1730700003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR11MB3666;H:BN8PR11MB3762.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3b4BtM7xR5SzKyXNLbvUFv8WVShnmzoyQ9xVCkupXmrug/zEtsz8El0lKaKs6VPOSqlsl9lIHpHhsYWDxCzatMr3P02syIR24R9rd+vRCuHl1QvY/+WQehlDw6CVOl1aukIc272ZoWsxCD8fQPhuCQ8TI7ky7vtVHzecLkzAhJtvH2NlZQIQfOzYu4CHW7eKcf4q4G4WeLUNV9bjAbuum9wlZyBR9g/lL9pj2cmX2ahaNjzISqXuERy3zythVWasUF2UpajA26wKiLt/p1Er5xDh//HxGwoGzjkbm+ViUY70SYdaB5hcH8xqKlANJjse7/nrJYw3Pcax39Y7mhfH6Gmzln/mvaLtoVtdALiFvYO1hdS2S1LjSUd8DAAygpMXEFdz9IVHuZNRpic2/SC5W+BdQ2iWPQB//GvTc0qSsyM=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e59b0a9-4568-4416-bf4d-08d74bde317b
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2019 10:56:38.3949
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9o8s/2vJbuTxXy+SiX+0ZdpqoUzpfBhfvtnCuN+18hLJkhJkOzG7zjO8jxAwYtZ/pkaavscFKqlM+EYV4Mz38Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3666
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Bezrukov <dmitry.bezrukov@aquantia.com>

Make some other bit-enums more clear about positioning,
this helps on debugging and development

Signed-off-by: Dmitry Bezrukov <dmitry.bezrukov@aquantia.com>
Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>
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

