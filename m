Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 068C1121123
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 18:09:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727846AbfLPRG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 12:06:57 -0500
Received: from mail-eopbgr690078.outbound.protection.outlook.com ([40.107.69.78]:42057
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727333AbfLPRGz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 12:06:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bZ9Kv/u6b8kbTwAa44GEmKZ5Yg1/kBsQ+FDNGJV8CHWcH8TVsGe5pkvzJflUwzcqL/6aliMZil3IsfxNuf13yMkFGPq56rr1xqmt0UR7FtDU15GAmJTI6YmFDwOExZjbZ5mx+B8R8pcOPzPgrHy3OysaSL1gL8mqbEWRKB21oG9967AgA8jelVgRhS7mQvRLIU96UNJEew9OmjmfU2Nd1ZEeIkMBzWfrngKLmBUSgYY0DDM0w/3hdt5+nFzYMYEWKwLCIzWUHjji74LPeRaVjLpdqaaQ4S/Gv8RM3yK2Wq2XuB/JaYvio7ZHLC4/Nap7BJ+5dujGOnlyCfV4Ys0GDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oPI2+zKloIdi3mw1LJzSr/ob4fEW7wZUVC1yI5KsAqQ=;
 b=lfZH4IQ3Wpw6XgQhR6N9QaOxJfPGDi7yaJSXa/CtOFY3bYuMl8OHimYK/DnS8GaDdJA83d2JeLc27alOBQGE1uY+4kZC2NxfW7a1yIeQ+bEZf+ltQfW9zUSUCCuVKg3grmRV6+RzWo/+hHeExo4OC0+GQ8kbSf1Y6bT8RYHPnUTMrP2NVddpAsiKpWTMYPyveE/mAHRyUU5ZDAo0jfULUra29MkbQ+pTRoulDGRrq3HsmuFSJxHcLF/nk/MXps1PMXMZmqrpyHjitTdbE3irqtGhcmcYE1VrRxGx2G9t+sTCEyuV7t32l7ZRyJ92hIfBw3niwUX5Y/5z3ENhXHr9Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oPI2+zKloIdi3mw1LJzSr/ob4fEW7wZUVC1yI5KsAqQ=;
 b=S4JDh18GoQj3UzoX8fIDhs49fiO8qEoMAD0ZMmhoh3Gr4Y6GqyhwOo/JvNZo/71LSiPr+LSW5OLCgrhGsUipXhXzhN7R7s8CDmWgUM+uNzeXlk0FlYjwS5U1YOEXqJakN668mM1kNzubasdtNEs4tYYdvl/uI2qOKvQU1fnC/aQ=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4142.namprd11.prod.outlook.com (20.179.149.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.15; Mon, 16 Dec 2019 17:06:43 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 17:06:43 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 41/55] staging: wfx: drop struct wfx_edca_params
Thread-Topic: [PATCH 41/55] staging: wfx: drop struct wfx_edca_params
Thread-Index: AQHVtDLMBzawDDar5UiFx9jQRQ1KLQ==
Date:   Mon, 16 Dec 2019 17:03:54 +0000
Message-ID: <20191216170302.29543-42-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: ba5b93bd-bf99-4b25-31f7-08d7824a5336
x-ms-traffictypediagnostic: MN2PR11MB4142:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB41426EF3464DD6002B36444C93510@MN2PR11MB4142.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(346002)(136003)(376002)(39850400004)(199004)(189003)(6512007)(71200400001)(91956017)(6486002)(8676002)(2906002)(54906003)(81166006)(81156014)(186003)(76116006)(478600001)(36756003)(85182001)(85202003)(6666004)(66556008)(66476007)(66446008)(64756008)(1076003)(66574012)(316002)(2616005)(4326008)(6506007)(26005)(8936002)(110136005)(5660300002)(107886003)(66946007)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4142;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /6azdlRo34+khDdwWl/9R4YOxu7Ik4MvtgmQt6s8Y8qrr9SnId72Rpbca3XpyuRqQxGToUj7wAHEyywQP6VJbZZbHxBASnIZ2uN56PbwRrXT+KREZ5SfXLdIuR98EzhZdujDWUeTDDDaAB4EaxUiqvDhSc37ZuZ3gp/DWFkLJI5lIvK6XEvHL9ia/kxRHJU4lXpkn/jHnTRTdlB/jmmj7JSJ+6mOZFWdneuS5EXr5E6a7GOeZ+bVNyi6jFKV0AUpH5EE7HRhb884hd7tvi1nrPY/tf9aiI035TXnl+mYwopJHheIk8HCfv590bHE+sUXm4vycPUraxBcxD7EcIs5b9/LaE6ojL7wxSRpOf8fbxQVRWHWFAgJpkwyagtv/hracj5oJLvd1ekZbI8FWBgdeaWODvmYfDv2msVI0qJXVHIV0oa0HEYK2yw+JuV/HL/0
Content-Type: text/plain; charset="utf-8"
Content-ID: <A1ADD3C74881A642AE27B36D231C38A5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba5b93bd-bf99-4b25-31f7-08d7824a5336
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 17:03:54.6240
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MDHxeyWZj6zA+M8hMRwSH9JOy534dqRVXUythelPOIB3Udd4+1qKCioyG5ljAGT6fFf4lw1q8tjLqoyhPOWxsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4142
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPg0KDQpJ
bnRlcm1lZGlhdGUgc3RydWN0dXJlIHdmeF9lZGNhX3BhcmFtcyBkb2VzIG5vdCBoZWxwLiBUaGlz
IHBhdGNoDQpyZWxvY2F0ZXMgaXRzIG1lbWJlcnMgZGlyZWN0bHkgaW4gc3RydWN0IHdmeF92aWYu
DQoNClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2ls
YWJzLmNvbT4NCi0tLQ0KIGRyaXZlcnMvc3RhZ2luZy93ZngvcXVldWUuYyB8ICA0ICsrLS0NCiBk
cml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jICAgfCAxOCArKysrKysrKystLS0tLS0tLS0NCiBkcml2
ZXJzL3N0YWdpbmcvd2Z4L3N0YS5oICAgfCAgNiAtLS0tLS0NCiBkcml2ZXJzL3N0YWdpbmcvd2Z4
L3dmeC5oICAgfCAgMyArKy0NCiA0IGZpbGVzIGNoYW5nZWQsIDEzIGluc2VydGlvbnMoKyksIDE4
IGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5j
IGIvZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5jDQppbmRleCA2ODBmZWQzMWNlZmIuLjE2MjE2
YWZlNmNmYyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvcXVldWUuYw0KKysrIGIv
ZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5jDQpAQCAtNDUyLDcgKzQ1Miw3IEBAIHN0YXRpYyBp
bnQgd2Z4X2dldF9wcmlvX3F1ZXVlKHN0cnVjdCB3ZnhfdmlmICp3dmlmLA0KIAlmb3IgKGkgPSAw
OyBpIDwgSUVFRTgwMjExX05VTV9BQ1M7ICsraSkgew0KIAkJaW50IHF1ZXVlZDsNCiANCi0JCWVk
Y2EgPSAmd3ZpZi0+ZWRjYS5wYXJhbXNbaV07DQorCQllZGNhID0gJnd2aWYtPmVkY2FfcGFyYW1z
W2ldOw0KIAkJcXVldWVkID0gd2Z4X3R4X3F1ZXVlX2dldF9udW1fcXVldWVkKCZ3dmlmLT53ZGV2
LT50eF9xdWV1ZVtpXSwNCiAJCQkJdHhfYWxsb3dlZF9tYXNrKTsNCiAJCWlmICghcXVldWVkKQ0K
QEAgLTU5NSw3ICs1OTUsNyBAQCBzdHJ1Y3QgaGlmX21zZyAqd2Z4X3R4X3F1ZXVlc19nZXQoc3Ry
dWN0IHdmeF9kZXYgKndkZXYpDQogCQl3dmlmLT5wc3BvbGxfbWFzayAmPSB+QklUKHR4X3ByaXYt
PnJhd19saW5rX2lkKTsNCiANCiAJCS8qIGFsbG93IGJ1cnN0aW5nIGlmIHR4b3AgaXMgc2V0ICov
DQotCQlpZiAod3ZpZi0+ZWRjYS5wYXJhbXNbcXVldWVfbnVtXS50eF9vcF9saW1pdCkNCisJCWlm
ICh3dmlmLT5lZGNhX3BhcmFtc1txdWV1ZV9udW1dLnR4X29wX2xpbWl0KQ0KIAkJCWJ1cnN0ID0g
KGludCl3ZnhfdHhfcXVldWVfZ2V0X251bV9xdWV1ZWQocXVldWUsIHR4X2FsbG93ZWRfbWFzaykg
KyAxOw0KIAkJZWxzZQ0KIAkJCWJ1cnN0ID0gMTsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdp
bmcvd2Z4L3N0YS5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYw0KaW5kZXggYjQwMDdhZmNk
MGM2Li5kNTJmNjE4MDYyYTYgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5j
DQorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jDQpAQCAtMjk5LDcgKzI5OSw3IEBAIHN0
YXRpYyBpbnQgd2Z4X3VwZGF0ZV9wbShzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZikNCiAJCXJldHVybiAw
Ow0KIAlpZiAoIXBzKQ0KIAkJcHNfdGltZW91dCA9IDA7DQotCWlmICh3dmlmLT5lZGNhLnVhcHNk
X21hc2spDQorCWlmICh3dmlmLT51YXBzZF9tYXNrKQ0KIAkJcHNfdGltZW91dCA9IDA7DQogDQog
CS8vIEtlcm5lbCBkaXNhYmxlIFBvd2VyU2F2ZSB3aGVuIG11bHRpcGxlIHZpZnMgYXJlIGluIHVz
ZS4gSW4gY29udHJhcnksDQpAQCAtMzI3LDggKzMyNyw4IEBAIGludCB3ZnhfY29uZl90eChzdHJ1
Y3QgaWVlZTgwMjExX2h3ICpodywgc3RydWN0IGllZWU4MDIxMV92aWYgKnZpZiwNCiAJV0FSTl9P
TihxdWV1ZSA+PSBody0+cXVldWVzKTsNCiANCiAJbXV0ZXhfbG9jaygmd2Rldi0+Y29uZl9tdXRl
eCk7DQotCWFzc2lnbl9iaXQocXVldWUsICZ3dmlmLT5lZGNhLnVhcHNkX21hc2ssIHBhcmFtcy0+
dWFwc2QpOw0KLQllZGNhID0gJnd2aWYtPmVkY2EucGFyYW1zW3F1ZXVlXTsNCisJYXNzaWduX2Jp
dChxdWV1ZSwgJnd2aWYtPnVhcHNkX21hc2ssIHBhcmFtcy0+dWFwc2QpOw0KKwllZGNhID0gJnd2
aWYtPmVkY2FfcGFyYW1zW3F1ZXVlXTsNCiAJZWRjYS0+YWlmc24gPSBwYXJhbXMtPmFpZnM7DQog
CWVkY2EtPmN3X21pbiA9IHBhcmFtcy0+Y3dfbWluOw0KIAllZGNhLT5jd19tYXggPSBwYXJhbXMt
PmN3X21heDsNCkBAIC0zMzcsNyArMzM3LDcgQEAgaW50IHdmeF9jb25mX3R4KHN0cnVjdCBpZWVl
ODAyMTFfaHcgKmh3LCBzdHJ1Y3QgaWVlZTgwMjExX3ZpZiAqdmlmLA0KIAloaWZfc2V0X2VkY2Ff
cXVldWVfcGFyYW1zKHd2aWYsIGVkY2EpOw0KIA0KIAlpZiAod3ZpZi0+dmlmLT50eXBlID09IE5M
ODAyMTFfSUZUWVBFX1NUQVRJT04pIHsNCi0JCWhpZl9zZXRfdWFwc2RfaW5mbyh3dmlmLCB3dmlm
LT5lZGNhLnVhcHNkX21hc2spOw0KKwkJaGlmX3NldF91YXBzZF9pbmZvKHd2aWYsIHd2aWYtPnVh
cHNkX21hc2spOw0KIAkJaWYgKHd2aWYtPnNldGJzc3BhcmFtc19kb25lICYmIHd2aWYtPnN0YXRl
ID09IFdGWF9TVEFURV9TVEEpDQogCQkJd2Z4X3VwZGF0ZV9wbSh3dmlmKTsNCiAJfQ0KQEAgLTE0
MjYsNyArMTQyNiw3IEBAIGludCB3ZnhfYWRkX2ludGVyZmFjZShzdHJ1Y3QgaWVlZTgwMjExX2h3
ICpodywgc3RydWN0IGllZWU4MDIxMV92aWYgKnZpZikNCiAJCX0sDQogCX07DQogDQotCUJVSUxE
X0JVR19PTihBUlJBWV9TSVpFKGRlZmF1bHRfZWRjYV9wYXJhbXMpICE9IEFSUkFZX1NJWkUod3Zp
Zi0+ZWRjYS5wYXJhbXMpKTsNCisJQlVJTERfQlVHX09OKEFSUkFZX1NJWkUoZGVmYXVsdF9lZGNh
X3BhcmFtcykgIT0gQVJSQVlfU0laRSh3dmlmLT5lZGNhX3BhcmFtcykpOw0KIAlpZiAod2Z4X2Fw
aV9vbGRlcl90aGFuKHdkZXYsIDIsIDApKSB7DQogCQlkZWZhdWx0X2VkY2FfcGFyYW1zW0lFRUU4
MDIxMV9BQ19CRV0ucXVldWVfaWQgPSBISUZfUVVFVUVfSURfQkFDS0dST1VORDsNCiAJCWRlZmF1
bHRfZWRjYV9wYXJhbXNbSUVFRTgwMjExX0FDX0JLXS5xdWV1ZV9pZCA9IEhJRl9RVUVVRV9JRF9C
RVNURUZGT1JUOw0KQEAgLTE1MDIsMTIgKzE1MDIsMTIgQEAgaW50IHdmeF9hZGRfaW50ZXJmYWNl
KHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LCBzdHJ1Y3QgaWVlZTgwMjExX3ZpZiAqdmlmKQ0KIA0K
IAloaWZfc2V0X21hY2FkZHIod3ZpZiwgdmlmLT5hZGRyKTsNCiAJZm9yIChpID0gMDsgaSA8IElF
RUU4MDIxMV9OVU1fQUNTOyBpKyspIHsNCi0JCW1lbWNweSgmd3ZpZi0+ZWRjYS5wYXJhbXNbaV0s
ICZkZWZhdWx0X2VkY2FfcGFyYW1zW2ldLA0KKwkJbWVtY3B5KCZ3dmlmLT5lZGNhX3BhcmFtc1tp
XSwgJmRlZmF1bHRfZWRjYV9wYXJhbXNbaV0sDQogCQkgICAgICAgc2l6ZW9mKGRlZmF1bHRfZWRj
YV9wYXJhbXNbaV0pKTsNCi0JCWhpZl9zZXRfZWRjYV9xdWV1ZV9wYXJhbXMod3ZpZiwgJnd2aWYt
PmVkY2EucGFyYW1zW2ldKTsNCisJCWhpZl9zZXRfZWRjYV9xdWV1ZV9wYXJhbXMod3ZpZiwgJnd2
aWYtPmVkY2FfcGFyYW1zW2ldKTsNCiAJfQ0KLQl3dmlmLT5lZGNhLnVhcHNkX21hc2sgPSAwOw0K
LQloaWZfc2V0X3VhcHNkX2luZm8od3ZpZiwgd3ZpZi0+ZWRjYS51YXBzZF9tYXNrKTsNCisJd3Zp
Zi0+dWFwc2RfbWFzayA9IDA7DQorCWhpZl9zZXRfdWFwc2RfaW5mbyh3dmlmLCB3dmlmLT51YXBz
ZF9tYXNrKTsNCiANCiAJd2Z4X3R4X3BvbGljeV9pbml0KHd2aWYpOw0KIAl3dmlmID0gTlVMTDsN
CmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5oIGIvZHJpdmVycy9zdGFnaW5n
L3dmeC9zdGEuaA0KaW5kZXggNzQ3NTVmNmZhMDMwLi45NTk1ZTFmYzYwZGIgMTAwNjQ0DQotLS0g
YS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5oDQorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0
YS5oDQpAQCAtMzQsMTIgKzM0LDYgQEAgc3RydWN0IHdmeF9oaWZfZXZlbnQgew0KIAlzdHJ1Y3Qg
aGlmX2luZF9ldmVudCBldnQ7DQogfTsNCiANCi1zdHJ1Y3Qgd2Z4X2VkY2FfcGFyYW1zIHsNCi0J
LyogTk9URTogaW5kZXggaXMgYSBsaW51eCBxdWV1ZSBpZC4gKi8NCi0Jc3RydWN0IGhpZl9yZXFf
ZWRjYV9xdWV1ZV9wYXJhbXMgcGFyYW1zW0lFRUU4MDIxMV9OVU1fQUNTXTsNCi0JdW5zaWduZWQg
bG9uZyB1YXBzZF9tYXNrOw0KLX07DQotDQogc3RydWN0IHdmeF9ncnBfYWRkcl90YWJsZSB7DQog
CWJvb2wgZW5hYmxlOw0KIAlpbnQgbnVtX2FkZHJlc3NlczsNCmRpZmYgLS1naXQgYS9kcml2ZXJz
L3N0YWdpbmcvd2Z4L3dmeC5oIGIvZHJpdmVycy9zdGFnaW5nL3dmeC93ZnguaA0KaW5kZXggZmYy
OTE2MzQzNmI2Li41YTJmOGFmMTdlYjcgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4
L3dmeC5oDQorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3dmeC5oDQpAQCAtMTEzLDcgKzExMyw4
IEBAIHN0cnVjdCB3ZnhfdmlmIHsNCiAJaW50CQkJY3FtX3Jzc2lfdGhvbGQ7DQogCWJvb2wJCQlz
ZXRic3NwYXJhbXNfZG9uZTsNCiAJc3RydWN0IHdmeF9odF9pbmZvCWh0X2luZm87DQotCXN0cnVj
dCB3ZnhfZWRjYV9wYXJhbXMJZWRjYTsNCisJdW5zaWduZWQgbG9uZwkJdWFwc2RfbWFzazsNCisJ
c3RydWN0IGhpZl9yZXFfZWRjYV9xdWV1ZV9wYXJhbXMgZWRjYV9wYXJhbXNbSUVFRTgwMjExX05V
TV9BQ1NdOw0KIAlzdHJ1Y3QgaGlmX3JlcV9zZXRfYnNzX3BhcmFtcyBic3NfcGFyYW1zOw0KIAlz
dHJ1Y3Qgd29ya19zdHJ1Y3QJYnNzX3BhcmFtc193b3JrOw0KIAlzdHJ1Y3Qgd29ya19zdHJ1Y3QJ
c2V0X2N0c193b3JrOw0KLS0gDQoyLjIwLjENCg==
