Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7949FADA15
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 15:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729576AbfIINiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 09:38:46 -0400
Received: from mail-eopbgr780077.outbound.protection.outlook.com ([40.107.78.77]:14016
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728895AbfIINiq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Sep 2019 09:38:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ih+7LRUvOjS4z7c4yGmCC1H8Qo0xjY9yEGV/T0lMUqmsNrTtv98li0/mronmuyC+LgZtLvQWsWuAgq93e+t6a4hVRArpQeT8x+xzxv+rBwFKUJLGtprdm49LAdMZBPLytwgo9yKONWhSTdh8HA8Z9snWrzHhuI9+LZpFEGYr+T2RIVBxFUJvVjmCvQAJdTVKyLJHgSOXXi3FG+JtjHC/gw0QjjJhZXWyeylcStQVzchEqCsTSasLhng7NG+CJNAi75AL+pWDzIbXDZEki+J1FVN5+mU7bTLegKJZIbQdr8C+Phqgm0Wq7amrGqs6jekKHzqXlDzpR+mB01rQ76MlCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eDnd+r94a07ED+vgdhyrcJ8HrqHtTB8XDGLrPxSw5t8=;
 b=l2tzSKrsrhJ7MarcaFlkqaWWFV6yGKH2hdt1l4EtM7aqfwCqBNpP3NqkwIEXrtIXb8donrky8Wuzwqw20ZTY/lOofGTyOE03MXqz0GVd+zqPJ/bXkk5xqV4mHH5Z0TQdegJ+907jsIc6Te3T/29AjocBeLDnN4fVQ6F00IXtHOv+S95x5r8S2MRbmb9qchjm7fZ3QbpEVYzN6+bUgaXNc53WxmS7m6dvIuOTNg89ogcWxfrzlROXNcaFwkE1vLc2h1dTJkrBwyoTYwg5VvJMDlpvo32EzFUmz9+9KZJUpcaqwwhwTEb7bgmGNuOtGoIfJRfbiaEULkqg2Yp0ktM+Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eDnd+r94a07ED+vgdhyrcJ8HrqHtTB8XDGLrPxSw5t8=;
 b=NdNBTWcRIOlOKN6+p0eL6Iyxi9iMxraWGMHV0SH3Rj2duQVr4/rosC8WB1kEyPVA7AzXWyHUDgkQ6Euw51Ok4fwdDyf2CnUxEQcTBDKzBH3ugasqLWG3TQtqIRqaTq3W1myzFHGJDO5rbuKiiTJM7f+Ipm6TaRM8wbYLc8+xOJQ=
Received: from BN6PR11MB4081.namprd11.prod.outlook.com (10.255.128.166) by
 BN6PR11MB1892.namprd11.prod.outlook.com (10.175.100.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.13; Mon, 9 Sep 2019 13:38:40 +0000
Received: from BN6PR11MB4081.namprd11.prod.outlook.com
 ([fe80::95ec:a465:3f5f:e3e5]) by BN6PR11MB4081.namprd11.prod.outlook.com
 ([fe80::95ec:a465:3f5f:e3e5%3]) with mapi id 15.20.2241.018; Mon, 9 Sep 2019
 13:38:40 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Egor Pomozov <Egor.Pomozov@aquantia.com>,
        Sergey Samoilenko <Sergey.Samoilenko@aquantia.com>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>
Subject: [PATCH net-next 02/11] net: aquantia: unify styling of bit enums
Thread-Topic: [PATCH net-next 02/11] net: aquantia: unify styling of bit enums
Thread-Index: AQHVZxPjj3AsZVvUjk6hGW2TW0i1OA==
Date:   Mon, 9 Sep 2019 13:38:40 +0000
Message-ID: <19562d2b92eadb56ea8b925f3273d491280eda88.1568034880.git.igor.russkikh@aquantia.com>
References: <cover.1568034880.git.igor.russkikh@aquantia.com>
In-Reply-To: <cover.1568034880.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR05CA0298.eurprd05.prod.outlook.com
 (2603:10a6:7:93::29) To BN6PR11MB4081.namprd11.prod.outlook.com
 (2603:10b6:405:78::38)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8593c0d7-eaa1-4bf5-9e57-08d7352b0650
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN6PR11MB1892;
x-ms-traffictypediagnostic: BN6PR11MB1892:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB18920D065E2200E83A51937898B70@BN6PR11MB1892.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:820;
x-forefront-prvs: 01559F388D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(376002)(346002)(396003)(366004)(39840400004)(189003)(199004)(4326008)(99286004)(25786009)(7736002)(52116002)(6916009)(14454004)(8936002)(2906002)(44832011)(54906003)(2616005)(446003)(11346002)(71200400001)(476003)(71190400001)(316002)(50226002)(102836004)(478600001)(118296001)(6506007)(386003)(36756003)(53936002)(76176011)(6116002)(486006)(107886003)(6436002)(2351001)(6486002)(8676002)(186003)(64756008)(66446008)(5660300002)(66946007)(81166006)(14444005)(81156014)(1730700003)(26005)(66556008)(66476007)(86362001)(305945005)(256004)(2501003)(6512007)(66066001)(3846002)(5640700003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR11MB1892;H:BN6PR11MB4081.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: tF00oB+uy6sANBsQ3fcQ81gvUt96vQonN3gdr2LZ5LZrx2uLgE88hMyzqwfNYnqzSfvq+e238vyzb+34deGJE+XaTocs14Nupw6SRmj5kQm2ufbL4vHMbJlJt1Tg8onyQY9mAtPV9GUjYY9mjVsufcNzkfePHjiDsdfMYrhwZmBZ4sceVwoj9Nyw886coiTeDhwxZrZmfCVy4mxrLjybtDum6Nexe5H5qmDoXY/APp2YUbK1oNnWbkyVX6BG4bBGbtgbksOvWdfiRxTDmeipLE9AoMuQ0vdW7GBXfKVTMKZ74wK6qTUhejQqYqfvtadpHLeNAFqw9VwA49wD7aca4bpxE6teemWhbcL3612mHEwmgrdhw+IvR/i7HzEnclfvxKgyhCuyI/3IMkkwzu21wqZAx2S3W8hJnUy5QXsu+Zc=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8593c0d7-eaa1-4bf5-9e57-08d7352b0650
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2019 13:38:40.3416
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jnwAp9CmiOmvyjn8R5jLuFGZiixvR4IKm61maT0bJkFxAJYACAGtfmN+ceRDQch6fQkH0/7OENgUDfjKuM3gUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1892
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

