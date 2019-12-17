Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6BEA1231B9
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 17:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728927AbfLQQRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 11:17:01 -0500
Received: from mail-bn7nam10on2078.outbound.protection.outlook.com ([40.107.92.78]:31534
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728522AbfLQQQG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 11:16:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wr2yMnuf/26/ucrpMj2/xWg2CCm5d/iToXlXBmVcmyL+hIunThAcVsbvqRnA19q7s4DkVB/BQYXTTTqsBvRTmrCOj6X63Oym9nHcnoACTBP2rOZzLco16B0ISnD54K4VY0qs0QxHRmyZTl32Ijj7S6VVn3QzFh3V6sOhIpGh50Iz8Vnc5Ec9G3qgnpHX8a+joYtJjwQM+q3aelfTF1+DjEahTf0HxRtUxF6yMMxr32g6WD9KL3O7MYvZJjyrmWG2h38BdUoGQsBrgT7RsXKqHSO7fYu+VtURwJox/Z0wmTXnRiTSov8IE7cDqGHDIeLQvBmHopai0OSGJMvhRZ/oPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mu0mjoAQJzGjXwx+jJTT1bjBwlNSB4kdrjnvQDQ3lVc=;
 b=hnn9n98R8UjOTFstDPSGcWvjTJ+GlGcLSxnexj0TR8M3XxGidfsIQjDPtBo3YIEb/lw+lFoMfKsxar5YoFfY3C8WILDpjVWA0TOHkS2fZwxdqHVC2N6ip531KTi7ldKHTYF8V8wGRuae9EWTcu/YWAlhe9HeAR9jaAOWVcxuon5ry9xAf7bnq2e8Neer2qA/F7OqXU6y6ZD+Ole5lT6Qg5Omp/xbc5FvgVpeyPq1pvXT6j5QFROOqymLAMnPQc2X7gBVGejSsSTshq6ci6yh+9mb0Coz/0RYAL9Sl3qOjvG+2Twyyy4ViEgmOMC4UHh/7LORuz56l5l+SsTa2hUD7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mu0mjoAQJzGjXwx+jJTT1bjBwlNSB4kdrjnvQDQ3lVc=;
 b=D4NOo8/MH/G3oqsD5wP3542nQeA4PUqoE/z2b4SVpyJVVQ4GBTJhtw4YWqlqcvqJiNJISPJQr48Z1oLfPAnyWhaJMAT/g7JkQBKtof7gnfXaY3ieNF7Aoos56A82WpVxMszES+eMm/jX6Z71Swt/foAENYaZ67sIDJpmLls7wTE=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4208.namprd11.prod.outlook.com (52.135.36.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.20; Tue, 17 Dec 2019 16:16:03 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 16:16:03 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 53/55] staging: wfx: delayed_link_loss cannot happen
Thread-Topic: [PATCH v2 53/55] staging: wfx: delayed_link_loss cannot happen
Thread-Index: AQHVtPU5XBjY6+iTL0u1q/qrv4sC6Q==
Date:   Tue, 17 Dec 2019 16:15:39 +0000
Message-ID: <20191217161318.31402-54-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: d55df1c4-5ce5-49a4-dfc6-08d7830c5baa
x-ms-traffictypediagnostic: MN2PR11MB4208:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4208C650993BF20C5D1AA5E693500@MN2PR11MB4208.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(396003)(366004)(136003)(376002)(346002)(199004)(189003)(5660300002)(316002)(6506007)(85182001)(478600001)(71200400001)(2906002)(36756003)(186003)(26005)(81166006)(54906003)(1076003)(110136005)(66574012)(4326008)(8676002)(86362001)(6486002)(6666004)(52116002)(6512007)(64756008)(85202003)(66946007)(66476007)(66446008)(66556008)(8936002)(107886003)(2616005)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4208;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /ARgdrUUOqN22siMyq4IENtfTivLj+Oj3tKD8RWKC+DiKgq8fAaYULiV3TmeEG7RUeBnxZhxc+C0k9qL7gTTaa/RCNtGfgXHw/0PrpBdsVUyb54W6hUHXy+X3ZAH2TGEjJPISMR21Z1waO//qPnfa7hCqBRcM4XGBq3l9TI5Esw3+H7fFFnqlVUPY117dd01I9xsNbMjhuQGrljRmK+SRfPU0P/uQ8B/VOc9MuxT45bG17A22H3kIFppCAlQJUW5v0RjrNrrV68b9cS9L3r84hRQnLcebflXNG6b3UMi1sBB6qJ4kIxa7mZhADBz5WYnnQYFwP3YKOthjNBV+V/eY77ypFAFRcZtYg0+eGRn6LdOFphfPalGps8XgqBPUOKn+YK0yJ3ZAG/F3P6eCUiQHVHSk+TuPjqTWr0C6OpnO8Pb/Le/jDaufk+ZeHutjtFa
Content-Type: text/plain; charset="utf-8"
Content-ID: <4014511410AD2A4DAB4D17017AEDD18B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d55df1c4-5ce5-49a4-dfc6-08d7830c5baa
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 16:15:39.8464
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SblUKLvPCvREFLNgCRvXH5ksnfs9CL809G+bQ4jLeodnePkYj/PDaXZiPCLz4QiGGsOVZjO9LSbz1u+mbFruWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4208
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKT3Jp
Z2luYWwgY29kZSBhbGxvd3MgdG8gZGV0ZWN0IGFuIEJTUyBsb3NzIGR1cmluZyBhIHNjYW4gYW5k
IGRlbGF5aW5nCnRoZSBoYW5kbGluZyBvZiBCU1MgbG9zcy4gSG93ZXZlciwgdGhlcmUgaXQgaXMg
bm8gcmVhbCBwcm9ibGVtIHRvIGp1c3QKbWFrZSB0aGVzZSB0d28gZXZlbnRzIG11dHVhbGx5IGV4
Y2x1c2l2ZSAodGhlcmUgaXMganVzdCBhIHBlcmZvcm1hbmNlCnBlbmFsdHkpLgoKU2lnbmVkLW9m
Zi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0K
IGRyaXZlcnMvc3RhZ2luZy93Zngvc2Nhbi5jIHwgIDQgLS0tLQogZHJpdmVycy9zdGFnaW5nL3dm
eC9zdGEuYyAgfCAxOCArKystLS0tLS0tLS0tLS0tLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvd2Z4
LmggIHwgIDEgLQogMyBmaWxlcyBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDIwIGRlbGV0aW9u
cygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc2Nhbi5jIGIvZHJpdmVycy9z
dGFnaW5nL3dmeC9zY2FuLmMKaW5kZXggYmRiY2U2OTI2ZTkxLi5kZGUyZjg4NjgxNDcgMTAwNjQ0
Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc2Nhbi5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93
Zngvc2Nhbi5jCkBAIC05NSwxMCArOTUsNiBAQCB2b2lkIHdmeF9od19zY2FuX3dvcmsoc3RydWN0
IHdvcmtfc3RydWN0ICp3b3JrKQogCW11dGV4X3VubG9jaygmd3ZpZi0+d2Rldi0+Y29uZl9tdXRl
eCk7CiAJbXV0ZXhfdW5sb2NrKCZ3dmlmLT5zY2FuX2xvY2spOwogCV9faWVlZTgwMjExX3NjYW5f
Y29tcGxldGVkX2NvbXBhdCh3dmlmLT53ZGV2LT5odywgcmV0IDwgMCk7Ci0JaWYgKHd2aWYtPmRl
bGF5ZWRfbGlua19sb3NzKSB7Ci0JCXd2aWYtPmRlbGF5ZWRfbGlua19sb3NzID0gZmFsc2U7Ci0J
CXdmeF9jcW1fYnNzbG9zc19zbSh3dmlmLCAxLCAwLCAwKTsKLQl9CiB9CiAKIGludCB3ZnhfaHdf
c2NhbihzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywgc3RydWN0IGllZWU4MDIxMV92aWYgKnZpZiwK
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgYi9kcml2ZXJzL3N0YWdpbmcv
d2Z4L3N0YS5jCmluZGV4IDdhZTc2M2U5NjQ1NS4uMzI5NmJjMzUyMWQ1IDEwMDY0NAotLS0gYS9k
cml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMK
QEAgLTYzLDcgKzYzLDYgQEAgdm9pZCB3ZnhfY3FtX2Jzc2xvc3Nfc20oc3RydWN0IHdmeF92aWYg
Knd2aWYsIGludCBpbml0LCBpbnQgZ29vZCwgaW50IGJhZCkKIAlpbnQgdHggPSAwOwogCiAJbXV0
ZXhfbG9jaygmd3ZpZi0+YnNzX2xvc3NfbG9jayk7Ci0Jd3ZpZi0+ZGVsYXllZF9saW5rX2xvc3Mg
PSAwOwogCWNhbmNlbF93b3JrX3N5bmMoJnd2aWYtPmJzc19wYXJhbXNfd29yayk7CiAKIAlpZiAo
aW5pdCkgewpAQCAtNDI5LDE4ICs0MjgsOSBAQCBzdGF0aWMgdm9pZCB3ZnhfZXZlbnRfaGFuZGxl
cl93b3JrKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykKIAkJc3dpdGNoIChldmVudC0+ZXZ0LmV2
ZW50X2lkKSB7CiAJCWNhc2UgSElGX0VWRU5UX0lORF9CU1NMT1NUOgogCQkJY2FuY2VsX3dvcmtf
c3luYygmd3ZpZi0+dW5qb2luX3dvcmspOwotCQkJaWYgKG11dGV4X3RyeWxvY2soJnd2aWYtPnNj
YW5fbG9jaykpIHsKLQkJCQl3ZnhfY3FtX2Jzc2xvc3Nfc20od3ZpZiwgMSwgMCwgMCk7Ci0JCQkJ
bXV0ZXhfdW5sb2NrKCZ3dmlmLT5zY2FuX2xvY2spOwotCQkJfSBlbHNlIHsKLQkJCQkvKiBTY2Fu
IGlzIGluIHByb2dyZXNzLiBEZWxheSByZXBvcnRpbmcuCi0JCQkJICogU2NhbiBjb21wbGV0ZSB3
aWxsIHRyaWdnZXIgYnNzX2xvc3Nfd29yawotCQkJCSAqLwotCQkJCXd2aWYtPmRlbGF5ZWRfbGlu
a19sb3NzID0gMTsKLQkJCQkvKiBBbHNvIHN0YXJ0IGEgd2F0Y2hkb2cuICovCi0JCQkJc2NoZWR1
bGVfZGVsYXllZF93b3JrKCZ3dmlmLT5ic3NfbG9zc193b3JrLAotCQkJCQkJICAgICAgNSAqIEha
KTsKLQkJCX0KKwkJCW11dGV4X2xvY2soJnd2aWYtPnNjYW5fbG9jayk7CisJCQl3ZnhfY3FtX2Jz
c2xvc3Nfc20od3ZpZiwgMSwgMCwgMCk7CisJCQltdXRleF91bmxvY2soJnd2aWYtPnNjYW5fbG9j
ayk7CiAJCQlicmVhazsKIAkJY2FzZSBISUZfRVZFTlRfSU5EX0JTU1JFR0FJTkVEOgogCQkJd2Z4
X2NxbV9ic3Nsb3NzX3NtKHd2aWYsIDAsIDAsIDApOwpAQCAtNDk3LDggKzQ4Nyw2IEBAIHN0YXRp
YyB2b2lkIHdmeF9kb191bmpvaW4oc3RydWN0IHdmeF92aWYgKnd2aWYpCiB7CiAJbXV0ZXhfbG9j
aygmd3ZpZi0+d2Rldi0+Y29uZl9tdXRleCk7CiAKLQl3dmlmLT5kZWxheWVkX2xpbmtfbG9zcyA9
IGZhbHNlOwotCiAJaWYgKCF3dmlmLT5zdGF0ZSkKIAkJZ290byBkb25lOwogCmRpZmYgLS1naXQg
YS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3dmeC5oIGIvZHJpdmVycy9zdGFnaW5nL3dmeC93ZnguaApp
bmRleCA1ZTdjOTExZGIwMjQuLmRiNDMzYmVlODdhZiAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFn
aW5nL3dmeC93ZnguaAorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3dmeC5oCkBAIC03MCw3ICs3
MCw2IEBAIHN0cnVjdCB3ZnhfdmlmIHsKIAlpbnQJCQlpZDsKIAllbnVtIHdmeF9zdGF0ZQkJc3Rh
dGU7CiAKLQlpbnQJCQlkZWxheWVkX2xpbmtfbG9zczsKIAlpbnQJCQlic3NfbG9zc19zdGF0ZTsK
IAl1MzIJCQlic3NfbG9zc19jb25maXJtX2lkOwogCXN0cnVjdCBtdXRleAkJYnNzX2xvc3NfbG9j
azsKLS0gCjIuMjQuMAoK
