Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66C8C12320D
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 17:19:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728741AbfLQQPG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 11:15:06 -0500
Received: from mail-eopbgr770080.outbound.protection.outlook.com ([40.107.77.80]:48866
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728695AbfLQQPD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 11:15:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iwX54tfGoUP28z9wz2srqKvpV/SowmBsZr7OF5crVPBzUYAeNlEuf4Wlyy5MPjcrN/i41rYR4CNXn4VbEKoTXwtwxgZh96TXWlgT5qFp6es5XYNtnvcbB7zf5i/VbQCgRqhJi38Ym49eCOZWIazI/xF+/13CuVIpdAyKw+ixFiXA3ja0IUNM/E9ksZrbEXWZ7PJMiuH5zGcLRwcEs9I5BjAXHv+fGKeEMIQF3bl02UsjkHxQ9ykyzo4lPK/pDXY6nE/sX69Y5k6pjJyEJjjzL0uDu9FITA/1jlS5sQOQ6x7X32F/BpFJWY9MXMWRufGU5a4oAn1j7Ne3eUSLgq/2yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GLJulXtZXLF4hTJYoJHr3dn0XVZLmzPWYVzhDxmGKF8=;
 b=lX4Uvgq61UMahcOdkYUEqEbc5S2Jt0jpOXVcdb53adzBOW6AVzJAq10nc1/EGqqaHGE8BfXIHPe3oM7XePaKhtr/bmLvfnbHhZYNFfiVThWMXcIHJ7xU06pr3MVBs3Gr73hDJRvWhqTv9i9cLKt4ZHNvzStyOrhRsWhVriPHqL3BaC9I+RGlEuq9uLPUsHthAH1sbxyPmZB8q0u/qvE9UFD9ZeslmSLToHPBo1oM30SFhJAkxdOdHGGSl0AmF8T6ic2EF9cVTMwmp0myTvqxYuDaZPjs+HYr/ZRxx9/eynD0giPvymnuNN8kMbUE9GdKRj0a20Gc5LfOR3SJCvYXYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GLJulXtZXLF4hTJYoJHr3dn0XVZLmzPWYVzhDxmGKF8=;
 b=Q2i1TBFM9878BqaQb0QFVcdZcq7i52hSxcJEgIL+S8QGrFhaLWGB3W8A/blS3PSW3RcUY9Z8rykjcB4+cMyFbo7a2M9Va7AoPJFDXS46tGLORuIO2UhS43YUxGDLgKaG40/nqrTDF8AbpT9opo7DfX0mHkg+mRdvvV4llOFz/ak=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3678.namprd11.prod.outlook.com (20.178.254.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.16; Tue, 17 Dec 2019 16:14:58 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 16:14:58 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 21/55] staging: wfx: ensure that traces never modify
 arguments
Thread-Topic: [PATCH v2 21/55] staging: wfx: ensure that traces never modify
 arguments
Thread-Index: AQHVtPUgW+Ohf8j0AUOqHXo5Q0PSqA==
Date:   Tue, 17 Dec 2019 16:14:58 +0000
Message-ID: <20191217161318.31402-22-Jerome.Pouiller@silabs.com>
References: <20191217161318.31402-1-Jerome.Pouiller@silabs.com>
In-Reply-To: <20191217161318.31402-1-Jerome.Pouiller@silabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0174.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1c::18) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.24.0
x-originating-ip: [37.71.187.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 31a79391-3971-48af-3d4b-08d7830c42dd
x-ms-traffictypediagnostic: MN2PR11MB3678:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB367851756FC1CE509088967C93500@MN2PR11MB3678.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(396003)(366004)(39860400002)(136003)(199004)(189003)(6512007)(1076003)(478600001)(86362001)(8936002)(110136005)(316002)(2616005)(26005)(6506007)(5660300002)(36756003)(6486002)(66946007)(66476007)(66556008)(64756008)(66446008)(71200400001)(52116002)(85182001)(81166006)(81156014)(8676002)(54906003)(107886003)(2906002)(4326008)(186003)(85202003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3678;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: syhr7gArjFoiKMoAeKI75YtTkyylzuTpie965gXNhsbDjuP5S7C+YxILLgaRJlI+iGvECI+NYGclsHEDMxVfpb6jiet2cD/fSOqWnuJmkpr2cy3K+OglOPlAiryiXYcyLieMXipnoeHN0Hd3iMiXY9hRxxwKy6oJgZ6im+fjnJLzQzTGXR2pYjiZ/LsvWev81lcifyy0XyXswiCVUL6V77jNWYGY5h1v82Dk/WAN1KiJ15qeFhKNeSGiIPOb44thAUWn+7gFostAArWKnQSJXZ8KPvgpmKmKjjC735K8emvAYZ+tx1YAijbdBN29Db7z5xetn05nH2AE6Qsa24UcnnrZ3KfCPUsRvhQ/FMJaPyIeYM98UKZKg6gelBBfJGMJapZUoi7gtqsd3TILt3V3vue4PkCuB23wnNuZPU8PvGjC/v2xuUZyRbVNh47ANi5V
Content-Type: text/plain; charset="utf-8"
Content-ID: <99293B299756D34A9B41BBF6897BB063@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31a79391-3971-48af-3d4b-08d7830c42dd
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 16:14:58.2365
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sA1Qy3+d9EPZYBwqGpJnnofL/tPTkGnLmg3sgdojuQUFGnmCID4HKXfcHG5Ijymdsr11+W+VV2LH3DbRzafaAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3678
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
cmUgaXMgbm8gcmVhc29uIGZvciBhIHRyYWNlIHRvIGNoYW5nZSBhbnkgYml0IG9mIHRoZSBhcmd1
bWVudC4gU28sCmxldCdzIG1ha2Ugc3VyZSB0aGF0IGlzIHRoZSBjYXNlIGJ5IGRlY2xhcmluZyB0
aGUgYXJndW1lbnRzIGNvbnN0YW50LgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIg
PGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvdHJh
Y2VzLmggfCAxNCArKysrKysrKy0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDggaW5zZXJ0aW9ucygr
KSwgNiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3RyYWNl
cy5oIGIvZHJpdmVycy9zdGFnaW5nL3dmeC90cmFjZXMuaAppbmRleCAzZjYxOThhYjIyMzUuLjMw
YzZhMTNmMGUyMiAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC90cmFjZXMuaAorKysg
Yi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3RyYWNlcy5oCkBAIC0xNTMsNyArMTUzLDcgQEAgaGlmX21p
Yl9saXN0X2VudW0KICNkZWZpbmUgaGlmX21pYl9saXN0IGhpZl9taWJfbGlzdF9lbnVtIHsgLTEs
IE5VTEwgfQogCiBERUNMQVJFX0VWRU5UX0NMQVNTKGhpZl9kYXRhLAotCVRQX1BST1RPKHN0cnVj
dCBoaWZfbXNnICpoaWYsIGludCB0eF9maWxsX2xldmVsLCBib29sIGlzX3JlY3YpLAorCVRQX1BS
T1RPKGNvbnN0IHN0cnVjdCBoaWZfbXNnICpoaWYsIGludCB0eF9maWxsX2xldmVsLCBib29sIGlz
X3JlY3YpLAogCVRQX0FSR1MoaGlmLCB0eF9maWxsX2xldmVsLCBpc19yZWN2KSwKIAlUUF9TVFJV
Q1RfX2VudHJ5KAogCQlfX2ZpZWxkKGludCwgdHhfZmlsbF9sZXZlbCkKQEAgLTIwMywxMiArMjAz
LDEyIEBAIERFQ0xBUkVfRVZFTlRfQ0xBU1MoaGlmX2RhdGEsCiAJKQogKTsKIERFRklORV9FVkVO
VChoaWZfZGF0YSwgaGlmX3NlbmQsCi0JVFBfUFJPVE8oc3RydWN0IGhpZl9tc2cgKmhpZiwgaW50
IHR4X2ZpbGxfbGV2ZWwsIGJvb2wgaXNfcmVjdiksCisJVFBfUFJPVE8oY29uc3Qgc3RydWN0IGhp
Zl9tc2cgKmhpZiwgaW50IHR4X2ZpbGxfbGV2ZWwsIGJvb2wgaXNfcmVjdiksCiAJVFBfQVJHUyho
aWYsIHR4X2ZpbGxfbGV2ZWwsIGlzX3JlY3YpKTsKICNkZWZpbmUgX3RyYWNlX2hpZl9zZW5kKGhp
ZiwgdHhfZmlsbF9sZXZlbClcCiAJdHJhY2VfaGlmX3NlbmQoaGlmLCB0eF9maWxsX2xldmVsLCBm
YWxzZSkKIERFRklORV9FVkVOVChoaWZfZGF0YSwgaGlmX3JlY3YsCi0JVFBfUFJPVE8oc3RydWN0
IGhpZl9tc2cgKmhpZiwgaW50IHR4X2ZpbGxfbGV2ZWwsIGJvb2wgaXNfcmVjdiksCisJVFBfUFJP
VE8oY29uc3Qgc3RydWN0IGhpZl9tc2cgKmhpZiwgaW50IHR4X2ZpbGxfbGV2ZWwsIGJvb2wgaXNf
cmVjdiksCiAJVFBfQVJHUyhoaWYsIHR4X2ZpbGxfbGV2ZWwsIGlzX3JlY3YpKTsKICNkZWZpbmUg
X3RyYWNlX2hpZl9yZWN2KGhpZiwgdHhfZmlsbF9sZXZlbClcCiAJdHJhY2VfaGlmX3JlY3YoaGlm
LCB0eF9maWxsX2xldmVsLCB0cnVlKQpAQCAtMzU5LDcgKzM1OSw4IEBAIFRSQUNFX0VWRU5UKGJo
X3N0YXRzLAogCXRyYWNlX2JoX3N0YXRzKGluZCwgcmVxLCBjbmYsIGJ1c3ksIHJlbGVhc2UpCiAK
IFRSQUNFX0VWRU5UKHR4X3N0YXRzLAotCVRQX1BST1RPKHN0cnVjdCBoaWZfY25mX3R4ICp0eF9j
bmYsIHN0cnVjdCBza19idWZmICpza2IsIGludCBkZWxheSksCisJVFBfUFJPVE8oY29uc3Qgc3Ry
dWN0IGhpZl9jbmZfdHggKnR4X2NuZiwgY29uc3Qgc3RydWN0IHNrX2J1ZmYgKnNrYiwKKwkJIGlu
dCBkZWxheSksCiAJVFBfQVJHUyh0eF9jbmYsIHNrYiwgZGVsYXkpLAogCVRQX1NUUlVDVF9fZW50
cnkoCiAJCV9fZmllbGQoaW50LCBwa3RfaWQpCkBAIC0zNzUsOCArMzc2LDkgQEAgVFJBQ0VfRVZF
TlQodHhfc3RhdHMsCiAJCS8vIEtlZXAgc3luYyB3aXRoIHdmeF9yYXRlcyBkZWZpbml0aW9uIGlu
IG1haW4uYwogCQlzdGF0aWMgY29uc3QgaW50IGh3X3JhdGVbXSA9IHsgMCwgMSwgMiwgMywgNiwg
NywgOCwgOSwKIAkJCQkJICAgICAgIDEwLCAxMSwgMTIsIDEzIH07Ci0JCXN0cnVjdCBpZWVlODAy
MTFfdHhfaW5mbyAqdHhfaW5mbyA9IElFRUU4MDIxMV9TS0JfQ0Ioc2tiKTsKLQkJc3RydWN0IGll
ZWU4MDIxMV90eF9yYXRlICpyYXRlcyA9IHR4X2luZm8tPmRyaXZlcl9yYXRlczsKKwkJY29uc3Qg
c3RydWN0IGllZWU4MDIxMV90eF9pbmZvICp0eF9pbmZvID0KKwkJCShjb25zdCBzdHJ1Y3QgaWVl
ZTgwMjExX3R4X2luZm8gKilza2ItPmNiOworCQljb25zdCBzdHJ1Y3QgaWVlZTgwMjExX3R4X3Jh
dGUgKnJhdGVzID0gdHhfaW5mby0+ZHJpdmVyX3JhdGVzOwogCQlpbnQgaTsKIAogCQlfX2VudHJ5
LT5wa3RfaWQgPSB0eF9jbmYtPnBhY2tldF9pZDsKLS0gCjIuMjQuMAoK
