Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51AB41210A3
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 18:05:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727436AbfLPRFD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 12:05:03 -0500
Received: from mail-eopbgr700045.outbound.protection.outlook.com ([40.107.70.45]:49121
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727014AbfLPRD5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 12:03:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NJC1zfVCBsud4b2F0spUt7h9MLBz+SBQN+PChhhqh+ppfIAv78SIEJbBVjiIIfb9OtIgejzU7mZ3x1dfNrH/Uo0kxv75eWBR3e3O6hwZohm1dNa/um9Qbz3scIAHvpVTNm2ZH+LnuvwmfIED8XZixHdQDzLEKNcbumM8ROjK0V7wUVCwFb0c7E9MjYpn1h78bAR7VXDtOAieFzD31I1TwDSbdL2BkKXZDmOZ17hcvstrw09X9hnfW+xmGscB4Vb3xNZc4z70OE3jN1PRqnVA2ma/JKcdH+7v+/JZXc64NvYqCWFWsxXqJam5RxYhjE8swY+TzYlxfaDNTJnE73UFkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WBQvaAN7T/oh4yuJy8t0W5XVBFMQQF3pkgjJtSY5LsQ=;
 b=celenVDz2D6tE9lYomQOWvyTF7BvOtM4eWd9vXOqQP4esvMlwjCJsXWcz/dC4K6/myl6fsaOm5Z6/SeIK3vqJ+4H9hUk0TgSz8cK38NgOJs3RpKUT4flpU/pUhA7+lKzaFVyepEnpgRBHQWF99tY2ygJOrNC9zNgkttdyaVdEJp/hZidrW0uuxxDH3qiyVihMa4EoUe8rID09hvr/tfn7tqXAJYGMl+eb+Gq5ijRfMStdoOSUOe3xxmb8J9cQVvOeyt51wU9cSHdTvEZmlgXPkcfNOLwcnBL0cHFR5XhIMmeF9GJ4xRV+NddXB+ekHV80JiYfohqo38Ej30bYP90GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WBQvaAN7T/oh4yuJy8t0W5XVBFMQQF3pkgjJtSY5LsQ=;
 b=iiMzplUG3NgtTvVTYzXXIh4pHbzduZ3piuULYy77UqHVim9jsJFIj1q7oyclIcKC7YbDiJc4k3fX5Xp2zMpTRwpFVH1Q36M95NMYAjGp5jx9BS4AiJ+5OeLI9rmTHvqCF6u8VYsn+jne24XT+mLTXLY0up2rUCoIvF2MKPJVTVs=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4351.namprd11.prod.outlook.com (52.135.39.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.19; Mon, 16 Dec 2019 17:03:50 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 17:03:50 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 17/55] staging: wfx: use meaningful names for CFG_BYTE_ORDER_*
Thread-Topic: [PATCH 17/55] staging: wfx: use meaningful names for
 CFG_BYTE_ORDER_*
Thread-Index: AQHVtDLE78zIHJwiN0ma3+cloHitWw==
Date:   Mon, 16 Dec 2019 17:03:42 +0000
Message-ID: <20191216170302.29543-18-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 95037123-30b6-4ac8-868a-08d78249ec26
x-ms-traffictypediagnostic: MN2PR11MB4351:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB43518A365C82CE300983165293510@MN2PR11MB4351.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2150;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(376002)(346002)(396003)(39860400002)(199004)(189003)(66556008)(66446008)(64756008)(66476007)(76116006)(85202003)(91956017)(66946007)(54906003)(107886003)(4326008)(478600001)(110136005)(71200400001)(6512007)(81156014)(8676002)(81166006)(186003)(36756003)(2906002)(85182001)(6666004)(66574012)(1076003)(316002)(6506007)(5660300002)(86362001)(26005)(2616005)(6486002)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4351;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bLTnrt7UNQAXoKib7mYy5xjko4lbTHMh7i/3tTrM1uibqqHBSNinmz4HyfxAEl6L4k/cWTzd7ZetPXUupymIkncja9G++RGQA48gl0fjsFbQqx/wYmVPUzAHDAzCwEZcHyktJZgiPduwNBqAlwAdJCZaWsICCsHwMaK/DSjiIR6GiMu+xDF1OflXH/K5+bx0mziiF775gCQG/EUsbaf1W7DFDOrtmFa75aXmz3szt7Kw2kWodTuolGZdsesVYEXPg75HquVKXtzhYJdV0tBFjCwHz7N82sUTPjixz5pbxFg8xhzPzNeOnhAOIuVibW1E056LCjmo2j42rth2o4nhuu81ACl72KP/dgeuLM+WSMh2qBDEZCWAhH7nDIRaJ8l8ntvVbG3E7oylouB2AAatOqS3i1HyVVST9VpFU8sj0Sc7EZMHde8qogbOgbuBwk3I
Content-Type: text/plain; charset="utf-8"
Content-ID: <9207438124E92F4EB4716A2485A0211F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95037123-30b6-4ac8-868a-08d78249ec26
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 17:03:42.3141
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s/XMg2IwmcibGByA3kC9pDY4L98Ndmm6p8QNZoulpOg5Y2XAX8miXQPG388DPy0lZBooPD3YA4xf8ptU5+BJAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4351
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPg0KDQpU
aGlzIG5ldyBuYW1pbmcgYWxsb3dzIHRvIHNhdmUgYSBjb21tZW50Lg0KDQpTaWduZWQtb2ZmLWJ5
OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+DQotLS0NCiBk
cml2ZXJzL3N0YWdpbmcvd2Z4L2J1c19zcGkuYyB8ICAyICsrDQogZHJpdmVycy9zdGFnaW5nL3dm
eC9md2lvLmMgICAgfCAgMiArLQ0KIGRyaXZlcnMvc3RhZ2luZy93ZngvaHdpby5oICAgIHwgMTUg
KysrKystLS0tLS0tLS0tDQogMyBmaWxlcyBjaGFuZ2VkLCA4IGluc2VydGlvbnMoKyksIDExIGRl
bGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9idXNfc3BpLmMg
Yi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2J1c19zcGkuYw0KaW5kZXggMGEwNTVjNDA0MWFmLi40MGJj
MzMwMzVkZTIgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2J1c19zcGkuYw0KKysr
IGIvZHJpdmVycy9zdGFnaW5nL3dmeC9idXNfc3BpLmMNCkBAIC0xMDcsNiArMTA3LDggQEAgc3Rh
dGljIGludCB3Znhfc3BpX2NvcHlfdG9faW8odm9pZCAqcHJpdiwgdW5zaWduZWQgaW50IGFkZHIs
DQogDQogCWNwdV90b19sZTE2cygmcmVnYWRkcik7DQogDQorCS8vIFJlZ2lzdGVyIGFkZHJlc3Mg
YW5kIENPTkZJRyBjb250ZW50IGFsd2F5cyB1c2UgMTZiaXQgYmlnIGVuZGlhbg0KKwkvLyAoIkJB
REMiIG9yZGVyKQ0KIAlpZiAoYnVzLT5uZWVkX3N3YWIpDQogCQlzd2FiMTZzKCZyZWdhZGRyKTsN
CiAJaWYgKGJ1cy0+bmVlZF9zd2FiICYmIGFkZHIgPT0gV0ZYX1JFR19DT05GSUcpDQpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9md2lvLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2Z3
aW8uYw0KaW5kZXggNDdlNjI3YmYwZjhlLi45ZDYxMDgyYzFlNmMgMTAwNjQ0DQotLS0gYS9kcml2
ZXJzL3N0YWdpbmcvd2Z4L2Z3aW8uYw0KKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9md2lvLmMN
CkBAIC0zMzksNyArMzM5LDcgQEAgaW50IHdmeF9pbml0X2RldmljZShzdHJ1Y3Qgd2Z4X2RldiAq
d2RldikNCiAJa3RpbWVfdCBub3csIHN0YXJ0Ow0KIAl1MzIgcmVnOw0KIA0KLQlyZWcgPSBDRkdf
RElSRUNUX0FDQ0VTU19NT0RFIHwgQ0ZHX0NQVV9SRVNFVCB8IENGR19XT1JEX01PREUyOw0KKwly
ZWcgPSBDRkdfRElSRUNUX0FDQ0VTU19NT0RFIHwgQ0ZHX0NQVV9SRVNFVCB8IENGR19CWVRFX09S
REVSX0FCQ0Q7DQogCWlmICh3ZGV2LT5wZGF0YS51c2VfcmlzaW5nX2NsaykNCiAJCXJlZyB8PSBD
RkdfQ0xLX1JJU0VfRURHRTsNCiAJcmV0ID0gY29uZmlnX3JlZ193cml0ZSh3ZGV2LCByZWcpOw0K
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaHdpby5oIGIvZHJpdmVycy9zdGFnaW5n
L3dmeC9od2lvLmgNCmluZGV4IGIyYzFhNjZkZTk2My4uNGI2ZWYwNjFiNDBiIDEwMDY0NA0KLS0t
IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9od2lvLmgNCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngv
aHdpby5oDQpAQCAtMzcsMTYgKzM3LDExIEBAIGludCBhaGJfcmVnX3dyaXRlKHN0cnVjdCB3Znhf
ZGV2ICp3ZGV2LCB1MzIgYWRkciwgdTMyIHZhbCk7DQogI2RlZmluZSBDRkdfRVJSX0hPU1RfTk9f
SU5fUVVFVUUgICAweDAwMDAwMDQwDQogI2RlZmluZSBDRkdfRVJSX0hPU1RfQ1JDX01JU1MgICAg
ICAweDAwMDAwMDgwIC8vIG9ubHkgd2l0aCBTRElPDQogI2RlZmluZSBDRkdfU1BJX0lHTk9SRV9D
UyAgICAgICAgICAweDAwMDAwMDgwIC8vIG9ubHkgd2l0aCBTUEkNCi0vKiBCeXRlcyBvcmRlcmlu
ZyAob25seSB3cml0YWJsZSBpbiBTUEkpOiAqLw0KLSNkZWZpbmUgQ0ZHX1dPUkRfTU9ERV9NQVNL
ICAgICAgICAgMHgwMDAwMDMwMA0KLS8qDQotICogQjEsQjAsQjMsQjIgKEluIFNQSSwgcmVnaXN0
ZXIgYWRkcmVzcyBhbmQNCi0gKiBDT05GSUcgZGF0YSBhbHdheXMgdXNlIHRoaXMgbW9kZSkNCi0g
Ki8NCi0jZGVmaW5lICAgICBDRkdfV09SRF9NT0RFMCAgICAgICAgIDB4MDAwMDAwMDANCi0jZGVm
aW5lICAgICBDRkdfV09SRF9NT0RFMSAgICAgICAgIDB4MDAwMDAxMDAgLy8gICBCMyxCMixCMSxC
MA0KLSNkZWZpbmUgICAgIENGR19XT1JEX01PREUyICAgICAgICAgMHgwMDAwMDIwMCAvLyAgIEIw
LEIxLEIyLEIzIChTRElPKQ0KLSNkZWZpbmUgQ0ZHX0RJUkVDVF9BQ0NFU1NfTU9ERSAgICAgMHgw
MDAwMDQwMCAvLyBEaXJlY3Qgb3IgcXVldWUgYWNjZXNzIG1vZGUNCisjZGVmaW5lIENGR19CWVRF
X09SREVSX01BU0sgICAgICAgIDB4MDAwMDAzMDAgLy8gb25seSB3cml0YWJsZSB3aXRoIFNQSQ0K
KyNkZWZpbmUgICAgIENGR19CWVRFX09SREVSX0JBREMgICAgMHgwMDAwMDAwMA0KKyNkZWZpbmUg
ICAgIENGR19CWVRFX09SREVSX0RDQkEgICAgMHgwMDAwMDEwMA0KKyNkZWZpbmUgICAgIENGR19C
WVRFX09SREVSX0FCQ0QgICAgMHgwMDAwMDIwMCAvLyBTRElPIGFsd2F5cyB1c2UgdGhpcyB2YWx1
ZQ0KKyNkZWZpbmUgQ0ZHX0RJUkVDVF9BQ0NFU1NfTU9ERSAgICAgMHgwMDAwMDQwMA0KICNkZWZp
bmUgQ0ZHX1BSRUZFVENIX0FIQiAgICAgICAgICAgMHgwMDAwMDgwMA0KICNkZWZpbmUgQ0ZHX0RJ
U0FCTEVfQ1BVX0NMSyAgICAgICAgMHgwMDAwMTAwMA0KICNkZWZpbmUgQ0ZHX1BSRUZFVENIX1NS
QU0gICAgICAgICAgMHgwMDAwMjAwMA0KLS0gDQoyLjIwLjENCg==
