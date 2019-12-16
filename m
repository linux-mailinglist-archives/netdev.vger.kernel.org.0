Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 787FC121136
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 18:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727707AbfLPRGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 12:06:45 -0500
Received: from mail-dm6nam11on2045.outbound.protection.outlook.com ([40.107.223.45]:6092
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727680AbfLPRGj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 12:06:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WfdZlfME1+tp8qBVK+ULDzvk+/ZAGgZACP3lk0ku1RxMZkfgEz39etIiq2dzCmSI2JUspTl7DVsluEUYlI6RwR0w65MzTfu3DsRTBPzosb3t5h0NxBqaIxeZohUvOOuMOHAWOSb58XNWg/g2hRq7GlHRqz9wxgyhDnEgtkLKqvmK66kTTHhhOcNFUfovhh1s/r9m/Ll6D2spRcVsQVFVPo1969cIlTDx56yH1fE9N4Bh1ffmhcNZ+6rZzW0uOMW3a/wE+byYwJupfWP5fFMuLFsvcPZge5I0mf3eXbz2Hk9XBJ0SqfN4iSh/e1bfGyJVwkS/A69tY41KiLF+G0+TOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JG+rcLalwIMErQWue0ONO4yw13jA+ZjZ1Q/OcOoxsQw=;
 b=Mu3NB4lydyDIGEoumtI/3wbTvLsmvrAZCEY4XPBjCSZkGvAAlqNFQ1TlI2DoQAYfmAFLjino2K9RebMwPw2r71EhTZxuZbEjl73a1l0ZqrdeXwDH+j6m/ScBtXdLxE+zumZcEMxDbCtymoZr3+6vffxZYB4k0+hRkQo/06lUrrKLK7Pevdm38IQ0GO4E0Ou/jtvdaT6YbQMZyr9ne/FK2uj/AXQF0iLnUIgJcx8xihD1c8sPwXZf5IgvxPTpsfKXHyxYzDMUFPRv/QD1EkWg67qHvIaiuP6qYZipMlJi6NP5Wk9B6Qg11ZQoxauSbARfa+F+S0C61z61O6rGo6+EZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JG+rcLalwIMErQWue0ONO4yw13jA+ZjZ1Q/OcOoxsQw=;
 b=Ck2j5iUIx2kZBU+MwHyPbFp2f95axWHJIh4mRh4xGuOaXtGqy1P9aoGJkidaQY5zv8SoER1ixO2Q29GQLofpZDd77uXnkCFnJJ1EqrdGqib2Lapl8nVPI6EsTu0HPKzLNNdaRT9T5IHfHJeUH4Igp/6gtDA6GQOYGh0UxN5ob2A=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4445.namprd11.prod.outlook.com (52.135.37.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Mon, 16 Dec 2019 17:06:36 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 17:06:36 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 30/55] staging: wfx: firmware already handle powersave mode
 during scan
Thread-Topic: [PATCH 30/55] staging: wfx: firmware already handle powersave
 mode during scan
Thread-Index: AQHVtDLJbvQgzn6bd06+Ts6mLZQVUw==
Date:   Mon, 16 Dec 2019 17:03:49 +0000
Message-ID: <20191216170302.29543-31-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 7e6f3cbc-8089-4d26-9d30-08d7824a4f7c
x-ms-traffictypediagnostic: MN2PR11MB4445:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB444556DA356D06423651025D93510@MN2PR11MB4445.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(366004)(39850400004)(396003)(136003)(189003)(199004)(110136005)(6486002)(107886003)(36756003)(186003)(316002)(66946007)(54906003)(5660300002)(66574012)(66446008)(66556008)(85182001)(66476007)(76116006)(91956017)(64756008)(2616005)(6506007)(85202003)(2906002)(26005)(71200400001)(6512007)(4326008)(8936002)(81166006)(1076003)(478600001)(86362001)(81156014)(6666004)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4445;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a2tExh+kWnVqYEudy755XI6ZZiPeF9yLUejaDzWrhSBvY13TFn7/ee0ELSRANG+uYEUzaEfJIEp9V+hraktJjhTThGqyPiZgjBFQGi25S7BkPcPV5H+X4ZJH7xTdXQNQs4ODb3DTuCC3hSMU0cP0NvB9lOSwxRlEbp3ErrTsRxYK+bzndrC1f+GfAl1bTOhFqSS6ZlXCvdwmHhCsuFtgGHXfctLHWKlA3mBZetzv1EgchkWo4QUQOdurqTlrp74bhQqY5TqutUf2fSar7Non4aTiD2umPBW4ySUe9L2Jl9pPwwojZbovLe4RnSmwAfCv51nD5humr6h7DZa8W+ymQQNH9Nc5+GjbsOD+bo5lB6dHoI0qpRCS2MRMKw4Q/ClV6rYLwbgD3uMyxQW9jUAoIVHJinKhVYuLifElcrYdyE0ZXBW9yeEAExbQ3xscNcgH
Content-Type: text/plain; charset="utf-8"
Content-ID: <4CD238A560745B448A84B576215B7673@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e6f3cbc-8089-4d26-9d30-08d7824a4f7c
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 17:03:49.3700
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v06ura1SAqKem4NyM8IJJNhXZRgmJYOMIQ/Hbk1AsdYlK/HZzwmKGUkRV1KPKc8pFttlqRYjt01DKNB39chmRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4445
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPg0KDQpX
aGVuIHVzZXIgdHJ5IHRvIGxhdW5jaCBzY2FuIHdoaWxlIGNvbm5lY3RlZCwgaXQgaXMgbmVjZXNz
YXJ5IHRvIG5vdGlmeQ0KdGhlIEFQIHRoYXQgd2UgY2Fubm90IHJlY2VpdmUgZGF0YSAodXNpbmcg
cG93ZXIgc2F2ZSBtb2RlKS4NCg0KRmlybXdhcmUgYWxyZWFkeSBoYW5kbGVzIHRoaXMgYXV0b21h
dGljYWxseSBzbyB0aGUgY29kZSBpbiB0aGUgZHJpdmVyIGlzDQpyZWR1bmRhbnQgYW5kIGNhbiBi
ZSBkcm9wcGVkLg0KDQpCeSBlZGdlIGVmZmVjdCwgaGFjayBvZiBzY2FuIHN0YXR1cyBpbiB3Znhf
c2V0X3BtKCkgaXMgbm93IHVzZWxlc3MuDQoNClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWls
bGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4NCi0tLQ0KIGRyaXZlcnMvc3RhZ2luZy93
Zngvc2Nhbi5jIHwgMTQgLS0tLS0tLS0tLS0tLS0NCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5j
ICB8ICA3ICstLS0tLS0NCiAyIGZpbGVzIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAyMCBkZWxl
dGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc2Nhbi5jIGIvZHJp
dmVycy9zdGFnaW5nL3dmeC9zY2FuLmMNCmluZGV4IGNiN2ExZmRkMDAwMS4uNGI5NWU2YTk3ZGY3
IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zY2FuLmMNCisrKyBiL2RyaXZlcnMv
c3RhZ2luZy93Zngvc2Nhbi5jDQpAQCAtMTQxLDIyICsxNDEsMTEgQEAgdm9pZCB3Znhfc2Nhbl93
b3JrKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykNCiAJCS5zY2FuX3JlcS5zY2FuX3R5cGUudHlw
ZSA9IDAsICAgIC8qIEZvcmVncm91bmQgKi8NCiAJfTsNCiAJc3RydWN0IGllZWU4MDIxMV9jaGFu
bmVsICpmaXJzdDsNCi0JYm9vbCBmaXJzdF9ydW4gPSAod3ZpZi0+c2Nhbi5iZWdpbiA9PSB3dmlm
LT5zY2FuLmN1cnIgJiYNCi0JCQkgIHd2aWYtPnNjYW4uYmVnaW4gIT0gd3ZpZi0+c2Nhbi5lbmQp
Ow0KIAlpbnQgaTsNCiANCiAJZG93bigmd3ZpZi0+c2Nhbi5sb2NrKTsNCiAJbXV0ZXhfbG9jaygm
d3ZpZi0+d2Rldi0+Y29uZl9tdXRleCk7DQogDQotCWlmIChmaXJzdF9ydW4pIHsNCi0JCWlmICh3
dmlmLT5zdGF0ZSA9PSBXRlhfU1RBVEVfU1RBICYmDQotCQkgICAgISh3dmlmLT5wb3dlcnNhdmVf
bW9kZS5wbV9tb2RlLmVudGVyX3BzbSkpIHsNCi0JCQlzdHJ1Y3QgaGlmX3JlcV9zZXRfcG1fbW9k
ZSBwbSA9IHd2aWYtPnBvd2Vyc2F2ZV9tb2RlOw0KLQ0KLQkJCXBtLnBtX21vZGUuZW50ZXJfcHNt
ID0gMTsNCi0JCQl3Znhfc2V0X3BtKHd2aWYsICZwbSk7DQotCQl9DQotCX0NCiANCiAJaWYgKCF3
dmlmLT5zY2FuLnJlcSB8fCB3dmlmLT5zY2FuLmN1cnIgPT0gd3ZpZi0+c2Nhbi5lbmQpIHsNCiAJ
CWlmICh3dmlmLT5zY2FuLm91dHB1dF9wb3dlciAhPSB3dmlmLT53ZGV2LT5vdXRwdXRfcG93ZXIp
DQpAQCAtMTc3LDkgKzE2Niw2IEBAIHZvaWQgd2Z4X3NjYW5fd29yayhzdHJ1Y3Qgd29ya19zdHJ1
Y3QgKndvcmspDQogCQlfX2llZWU4MDIxMV9zY2FuX2NvbXBsZXRlZF9jb21wYXQod3ZpZi0+d2Rl
di0+aHcsDQogCQkJCQkJICB3dmlmLT5zY2FuLnN0YXR1cyA/IDEgOiAwKTsNCiAJCXVwKCZ3dmlm
LT5zY2FuLmxvY2spOw0KLQkJaWYgKHd2aWYtPnN0YXRlID09IFdGWF9TVEFURV9TVEEgJiYNCi0J
CSAgICAhKHd2aWYtPnBvd2Vyc2F2ZV9tb2RlLnBtX21vZGUuZW50ZXJfcHNtKSkNCi0JCQl3Znhf
c2V0X3BtKHd2aWYsICZ3dmlmLT5wb3dlcnNhdmVfbW9kZSk7DQogCQlyZXR1cm47DQogCX0NCiAJ
Zmlyc3QgPSAqd3ZpZi0+c2Nhbi5jdXJyOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93
Zngvc3RhLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jDQppbmRleCA2MmU2NTQ5M2E0ZmUu
LmZiNDVhYTY2ZmM1NiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMNCisr
KyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMNCkBAIC0zNzUsNyArMzc1LDYgQEAgaW50IHdm
eF9zZXRfcG0oc3RydWN0IHdmeF92aWYgKnd2aWYsIGNvbnN0IHN0cnVjdCBoaWZfcmVxX3NldF9w
bV9tb2RlICphcmcpDQogew0KIAlzdHJ1Y3QgaGlmX3JlcV9zZXRfcG1fbW9kZSBwbSA9ICphcmc7
DQogCXUxNiB1YXBzZF9mbGFnczsNCi0JaW50IHJldDsNCiANCiAJaWYgKHd2aWYtPnN0YXRlICE9
IFdGWF9TVEFURV9TVEEgfHwgIXd2aWYtPmJzc19wYXJhbXMuYWlkKQ0KIAkJcmV0dXJuIDA7DQpA
QCAtMzk2LDExICszOTUsNyBAQCBpbnQgd2Z4X3NldF9wbShzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwg
Y29uc3Qgc3RydWN0IGhpZl9yZXFfc2V0X3BtX21vZGUgKmFyZykNCiAJCQkJCSBtc2Vjc190b19q
aWZmaWVzKDMwMCkpKQ0KIAkJZGV2X3dhcm4od3ZpZi0+d2Rldi0+ZGV2LA0KIAkJCSAidGltZW91
dCB3aGlsZSB3YWl0aW5nIG9mIHNldF9wbV9tb2RlX2NvbXBsZXRlXG4iKTsNCi0JcmV0ID0gaGlm
X3NldF9wbSh3dmlmLCAmcG0pOw0KLQkvLyBGSVhNRTogd2h5ID8NCi0JaWYgKC1FVElNRURPVVQg
PT0gd3ZpZi0+c2Nhbi5zdGF0dXMpDQotCQl3dmlmLT5zY2FuLnN0YXR1cyA9IDE7DQotCXJldHVy
biByZXQ7DQorCXJldHVybiBoaWZfc2V0X3BtKHd2aWYsICZwbSk7DQogfQ0KIA0KIGludCB3Znhf
c2V0X3J0c190aHJlc2hvbGQoc3RydWN0IGllZWU4MDIxMV9odyAqaHcsIHUzMiB2YWx1ZSkNCi0t
IA0KMi4yMC4xDQo=
