Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B428912108A
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 18:05:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727198AbfLPRED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 12:04:03 -0500
Received: from mail-eopbgr700081.outbound.protection.outlook.com ([40.107.70.81]:14720
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727174AbfLPREC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 12:04:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ij7mA0QL1koNCKtmjkJAIKZOIDtqmhy3NeZxcI1dJXwQGfiN9B5lvAa51ex92X/N3hjR4j6/vvzLpg0gtMXstI7zpVL1NsvB7mXeDBnr/hn0lKbLHcP6dtLu/Uk77jNzU5gwWDLJ1Um/xN/M6muYG7yh342mzta2EEHCig25nCkzi7yN1wQCrh59z6+10UNRmrg/k9+9ouGo5QOYSfmeQKnkI8xNFXZBgGrmpYEFp84fG1xKjqGPjeqM1iw295E32D6seF3fTOuQmPZfCxtS4mVhv4KjIJ6vmtFzgQBM1xpNq/CGamTWiOgS27rOwosbmPzKe1r/ThVXcD/zYgc/5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C87gMOFHM1f4Jz18S2Umi6D5PX3tPJ9v63dv6tDdjsQ=;
 b=AeAt+5fQI+DmdhwNUpdiO2NoX8gUQf8Folc+tw180FGOn1TRbhmV2CRqGgAT5EifaKl04sePA7LZtKFrfrTi6a+j3pQ+NSwMcUhFp5/300dh+eBvepGo1KMhY/Xfm4DlnnPd82VHT2lsR1NPBmJdc3Rc1JHb3S3TpjcZSEBTmq4vypr2+HSB+sWJ0f9m17Sxp6WkS6hmj3ZAP0yE+l2U2ZrBLf7SAC36Iba/NND866/9ONe1vuo4xPGfNW825XKuMnpzZfQXeKgnR2VU3BFrHRKamKavuHir7nrXyhKJ24HnG6QbJRNM2ZSovdInQazZxYSl7aGiR2e5JRzDWyiZPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C87gMOFHM1f4Jz18S2Umi6D5PX3tPJ9v63dv6tDdjsQ=;
 b=Bk3cpyTFwH2HjqNIVoGkvWm/1mCpjEMSBj+I5S2FdG7+gaHVfE+7KPHhVmFZgyxM48qkPkKo0ZGiBQFb4bYZwwWEZeGMjZJTepl37Uoyfcs4jOVXoTFyp/MdnqKrgE23tjFYWW1kKYnpsHduZXAFyhAW4jf9HCiDRGBunSHkEZQ=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4351.namprd11.prod.outlook.com (52.135.39.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.19; Mon, 16 Dec 2019 17:03:53 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 17:03:53 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 23/55] staging: wfx: fix typo in "num_of_ssi_ds"
Thread-Topic: [PATCH 23/55] staging: wfx: fix typo in "num_of_ssi_ds"
Thread-Index: AQHVtDLHj69DrwgEJki/D6w1Lg2/sQ==
Date:   Mon, 16 Dec 2019 17:03:45 +0000
Message-ID: <20191216170302.29543-24-Jerome.Pouiller@silabs.com>
References: <20191216170302.29543-1-Jerome.Pouiller@silabs.com>
In-Reply-To: <20191216170302.29543-1-Jerome.Pouiller@silabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-originating-ip: [37.71.187.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1d60a0a7-9ad5-46c4-78ca-08d78249ede0
x-ms-traffictypediagnostic: MN2PR11MB4351:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB43515F3D3E507F55B09D472793510@MN2PR11MB4351.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2512;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(376002)(346002)(396003)(39860400002)(199004)(189003)(66556008)(66446008)(64756008)(66476007)(76116006)(85202003)(91956017)(66946007)(54906003)(107886003)(4326008)(478600001)(110136005)(71200400001)(6512007)(81156014)(8676002)(81166006)(186003)(36756003)(2906002)(85182001)(6666004)(1076003)(316002)(6506007)(5660300002)(86362001)(26005)(2616005)(6486002)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4351;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Eu4fQ4Vr8vWni74f03wBsH4+ZsyDjtxh8cDmwdnBVcAASUxE0rcsomkTxObAfcxW0wvfi/7b7qZs9ns91eaH8ElpdWtTVyeSQBeTUsQU7Ymzgsm+YmN4IJPCCx0wGvEDdAnMf1QvNuZLNHcN7CbR7nbFcDLjyYhtJUN2tISlzG9mPpenmZWZjEuwjV88gvWnOMwn8vcnFOLriC2Ekkom21fCCAHOGF1plr1EqSaF2SDivF1hkHztXSbWYNro/QZeQH5AWuZ/RSgl6mcGzs4IIF8NR2BfX+sHG7jUe3nT9VMkJP0RPeI9y25HEGWgJXbpfOe29di75CrQI17Xyq7S5ilI9DtWhhc3NEGDn08Zt8MmeMaeG3+Pv+7872PZCRjVl0LHkhZuucFZASARForBEP51iEoHZJLgfRRISk1ygLQfk6PmaFhAs252FMDDiBkT
Content-Type: text/plain; charset="utf-8"
Content-ID: <3B49AB0E34D75D48B0116003CD4C66B5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d60a0a7-9ad5-46c4-78ca-08d78249ede0
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 17:03:45.7931
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7xU68afp//PiA8+8mYBBlNGHLVUs8NM5ZKAtGW0rNAKffKutOTrBI1kupCv9PaejSqWPuPPGPGD0iXJmL1A+JA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4351
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPg0KDQpU
aGUgc2NyaXB0IHRoYXQgaGFzIGltcG9ydGVkIEFQSSBoZWFkZXJzIGhhcyBtYWRlIGEgbWlzdGFr
ZSBpbg0KIm51bV9vZl9zc2lfZHMiLg0KDQpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxl
ciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+DQotLS0NCiBkcml2ZXJzL3N0YWdpbmcvd2Z4
L2hpZl9hcGlfY21kLmggfCAgNCArKy0tDQogZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHguYyAg
ICAgIHwgMTAgKysrKystLS0tLQ0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc2Nhbi5jICAgICAgICB8
ICAyICstDQogMyBmaWxlcyBjaGFuZ2VkLCA4IGluc2VydGlvbnMoKyksIDggZGVsZXRpb25zKC0p
DQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfY21kLmggYi9kcml2
ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfY21kLmgNCmluZGV4IGMxNTgzMWRlNGZmNC4uOTBiYTZl
OWI4MmVhIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfYXBpX2NtZC5oDQor
KysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfY21kLmgNCkBAIC0xODAsNyArMTgwLDcg
QEAgc3RydWN0IGhpZl9yZXFfc3RhcnRfc2NhbiB7DQogCXN0cnVjdCBoaWZfYXV0b19zY2FuX3Bh
cmFtIGF1dG9fc2Nhbl9wYXJhbTsNCiAJdTggICAgbnVtX29mX3Byb2JlX3JlcXVlc3RzOw0KIAl1
OCAgICBwcm9iZV9kZWxheTsNCi0JdTggICAgbnVtX29mX3NzaV9kczsNCisJdTggICAgbnVtX29m
X3NzaWRzOw0KIAl1OCAgICBudW1fb2ZfY2hhbm5lbHM7DQogCXUzMiAgIG1pbl9jaGFubmVsX3Rp
bWU7DQogCXUzMiAgIG1heF9jaGFubmVsX3RpbWU7DQpAQCAtMTk2LDcgKzE5Niw3IEBAIHN0cnVj
dCBoaWZfc3RhcnRfc2Nhbl9yZXFfY3N0bmJzc2lkX2JvZHkgew0KIAlzdHJ1Y3QgaGlmX2F1dG9f
c2Nhbl9wYXJhbSBhdXRvX3NjYW5fcGFyYW07DQogCXU4ICAgIG51bV9vZl9wcm9iZV9yZXF1ZXN0
czsNCiAJdTggICAgcHJvYmVfZGVsYXk7DQotCXU4ICAgIG51bV9vZl9zc2lfZHM7DQorCXU4ICAg
IG51bV9vZl9zc2lkczsNCiAJdTggICAgbnVtX29mX2NoYW5uZWxzOw0KIAl1MzIgICBtaW5fY2hh
bm5lbF90aW1lOw0KIAl1MzIgICBtYXhfY2hhbm5lbF90aW1lOw0KZGlmZiAtLWdpdCBhL2RyaXZl
cnMvc3RhZ2luZy93ZngvaGlmX3R4LmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5jDQpp
bmRleCBlOGMyYmQxZWZiYWMuLjJmNzRhYmNhMmI2MCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc3Rh
Z2luZy93ZngvaGlmX3R4LmMNCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4LmMNCkBA
IC0yMjcsMTIgKzIyNywxMiBAQCBpbnQgaGlmX3NjYW4oc3RydWN0IHdmeF92aWYgKnd2aWYsIGNv
bnN0IHN0cnVjdCB3Znhfc2Nhbl9wYXJhbXMgKmFyZykNCiAJc3RydWN0IGhpZl9zc2lkX2RlZiAq
c3NpZHM7DQogCXNpemVfdCBidWZfbGVuID0gc2l6ZW9mKHN0cnVjdCBoaWZfcmVxX3N0YXJ0X3Nj
YW4pICsNCiAJCWFyZy0+c2Nhbl9yZXEubnVtX29mX2NoYW5uZWxzICogc2l6ZW9mKHU4KSArDQot
CQlhcmctPnNjYW5fcmVxLm51bV9vZl9zc2lfZHMgKiBzaXplb2Yoc3RydWN0IGhpZl9zc2lkX2Rl
Zik7DQorCQlhcmctPnNjYW5fcmVxLm51bV9vZl9zc2lkcyAqIHNpemVvZihzdHJ1Y3QgaGlmX3Nz
aWRfZGVmKTsNCiAJc3RydWN0IGhpZl9yZXFfc3RhcnRfc2NhbiAqYm9keSA9IHdmeF9hbGxvY19o
aWYoYnVmX2xlbiwgJmhpZik7DQogCXU4ICpwdHIgPSAodTggKikgYm9keSArIHNpemVvZigqYm9k
eSk7DQogDQogCVdBUk4oYXJnLT5zY2FuX3JlcS5udW1fb2ZfY2hhbm5lbHMgPiBISUZfQVBJX01B
WF9OQl9DSEFOTkVMUywgImludmFsaWQgcGFyYW1zIik7DQotCVdBUk4oYXJnLT5zY2FuX3JlcS5u
dW1fb2Zfc3NpX2RzID4gMiwgImludmFsaWQgcGFyYW1zIik7DQorCVdBUk4oYXJnLT5zY2FuX3Jl
cS5udW1fb2Zfc3NpZHMgPiAyLCAiaW52YWxpZCBwYXJhbXMiKTsNCiAJV0FSTihhcmctPnNjYW5f
cmVxLmJhbmQgPiAxLCAiaW52YWxpZCBwYXJhbXMiKTsNCiANCiAJLy8gRklYTUU6IFRoaXMgQVBJ
IGlzIHVubmVjZXNzYXJ5IGNvbXBsZXgsIGZpeGluZyBOdW1PZkNoYW5uZWxzIGFuZA0KQEAgLTI0
MywxMSArMjQzLDExIEBAIGludCBoaWZfc2NhbihzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgY29uc3Qg
c3RydWN0IHdmeF9zY2FuX3BhcmFtcyAqYXJnKQ0KIAljcHVfdG9fbGUzMnMoJmJvZHktPm1heF9j
aGFubmVsX3RpbWUpOw0KIAljcHVfdG9fbGUzMnMoJmJvZHktPnR4X3Bvd2VyX2xldmVsKTsNCiAJ
bWVtY3B5KHB0ciwgYXJnLT5zc2lkcywNCi0JICAgICAgIGFyZy0+c2Nhbl9yZXEubnVtX29mX3Nz
aV9kcyAqIHNpemVvZihzdHJ1Y3QgaGlmX3NzaWRfZGVmKSk7DQorCSAgICAgICBhcmctPnNjYW5f
cmVxLm51bV9vZl9zc2lkcyAqIHNpemVvZihzdHJ1Y3QgaGlmX3NzaWRfZGVmKSk7DQogCXNzaWRz
ID0gKHN0cnVjdCBoaWZfc3NpZF9kZWYgKikgcHRyOw0KLQlmb3IgKGkgPSAwOyBpIDwgYm9keS0+
bnVtX29mX3NzaV9kczsgKytpKQ0KKwlmb3IgKGkgPSAwOyBpIDwgYm9keS0+bnVtX29mX3NzaWRz
OyArK2kpDQogCQljcHVfdG9fbGUzMnMoJnNzaWRzW2ldLnNzaWRfbGVuZ3RoKTsNCi0JcHRyICs9
IGFyZy0+c2Nhbl9yZXEubnVtX29mX3NzaV9kcyAqIHNpemVvZihzdHJ1Y3QgaGlmX3NzaWRfZGVm
KTsNCisJcHRyICs9IGFyZy0+c2Nhbl9yZXEubnVtX29mX3NzaWRzICogc2l6ZW9mKHN0cnVjdCBo
aWZfc3NpZF9kZWYpOw0KIAltZW1jcHkocHRyLCBhcmctPmNoLCBhcmctPnNjYW5fcmVxLm51bV9v
Zl9jaGFubmVscyAqIHNpemVvZih1OCkpOw0KIAlwdHIgKz0gYXJnLT5zY2FuX3JlcS5udW1fb2Zf
Y2hhbm5lbHMgKiBzaXplb2YodTgpOw0KIAlXQVJOKGJ1Zl9sZW4gIT0gcHRyIC0gKHU4ICopIGJv
ZHksICJhbGxvY2F0aW9uIHNpemUgbWlzbWF0Y2giKTsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0
YWdpbmcvd2Z4L3NjYW4uYyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc2Nhbi5jDQppbmRleCA0NWU3
OGM1NzIyZmYuLmNiN2ExZmRkMDAwMSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngv
c2Nhbi5jDQorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3NjYW4uYw0KQEAgLTIwNCw3ICsyMDQs
NyBAQCB2b2lkIHdmeF9zY2FuX3dvcmsoc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQ0KIAkJc2Nh
bi5zY2FuX3JlcS5tYXhfdHJhbnNtaXRfcmF0ZSA9IEFQSV9SQVRFX0lOREVYX0JfMU1CUFM7DQog
CXNjYW4uc2Nhbl9yZXEubnVtX29mX3Byb2JlX3JlcXVlc3RzID0NCiAJCShmaXJzdC0+ZmxhZ3Mg
JiBJRUVFODAyMTFfQ0hBTl9OT19JUikgPyAwIDogMjsNCi0Jc2Nhbi5zY2FuX3JlcS5udW1fb2Zf
c3NpX2RzID0gd3ZpZi0+c2Nhbi5uX3NzaWRzOw0KKwlzY2FuLnNjYW5fcmVxLm51bV9vZl9zc2lk
cyA9IHd2aWYtPnNjYW4ubl9zc2lkczsNCiAJc2Nhbi5zc2lkcyA9ICZ3dmlmLT5zY2FuLnNzaWRz
WzBdOw0KIAlzY2FuLnNjYW5fcmVxLm51bV9vZl9jaGFubmVscyA9IGl0IC0gd3ZpZi0+c2Nhbi5j
dXJyOw0KIAlzY2FuLnNjYW5fcmVxLnByb2JlX2RlbGF5ID0gMTAwOw0KLS0gDQoyLjIwLjENCg==
