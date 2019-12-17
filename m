Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC97123221
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 17:20:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729460AbfLQQUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 11:20:34 -0500
Received: from mail-eopbgr770074.outbound.protection.outlook.com ([40.107.77.74]:51332
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728527AbfLQQOs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 11:14:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eR1+FXhVNOy0VWhphyWBNyb5uU/l7+C6MbqvQDvNZ3Kz86uVqrYmAesgIjO46nHVFU1FJBGWIaxvwgzqme7EWPxqphjg2gfVxLJO7lNhTH9+OF2+NqD5sywTvRsOyiY3utvWYMZ3yahdkgeZ7vjjvVvx2BrkWBBMSNRcHcuN4H4sfHTpnFVtP/fSwO3MfGHqfNmraFazIiyJwipOjC7cNlTePa4PO1ZloO96XQ04L3u09emNZnJBP+vn2VDW9OAjHmlwMfAp7iwBFwaKZUzzn8LeyxKez2ipF9++zDxH+vaJ2glUCnB15E8V7jwfdJRC7DhAoH6YsrLnrXf2WUoR6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ykbHrayhucoW96Q9wsmZFwaTSnAEZu3zX1giZkHNMJc=;
 b=mLtXWAFGwrKH+hgTJtYuPAZ70R9h+vx3B8PinJ5tdvuB7/8i57oP5eVPugPrMYLxO3UUOR0vSbb3UjyL6DoyxGYO83l5Mn3bXw2vptF3A3spsQ41flUrE0SC/RAHus1mgZG1STPz6dkUdTLL6E7NBEwW1ZTwFFZsAqFv+GXgZPhDcZoTwfjpQQOBxuT+SfZ0WSiuFiQSTql6GK8ydGpj7Wyg9jAYFk4GfcXXMhlNYcHPq0yb6w1dPQT4AUmuSb4ScnruT6WsUzrL49q0inN45iCvz3IESLJCarO3cq1bNAIwpgSLcoiHW/bNR8DGRV6dDxQaiEt1kC01WJ7o1cPFmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ykbHrayhucoW96Q9wsmZFwaTSnAEZu3zX1giZkHNMJc=;
 b=IwNuAyvSRckc5iWDJl5PUEuSGCN7wKBf1j3A16Q8fq+CJTxzwPfPKxv18Z8kRWQoP4zKNAzZaob8P2rPKTHK8kZ1yTRlSZ0+b9u6wukkgFsgxmHedvmcaQmSN1DRoCAeVL8mDJECOisHP6nTrXqmXaKsQ6CyneJv/XKe8sb2Uto=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3678.namprd11.prod.outlook.com (20.178.254.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.16; Tue, 17 Dec 2019 16:14:46 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 16:14:46 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 14/55] staging: wfx: improve error message on unexpected
 confirmation
Thread-Topic: [PATCH v2 14/55] staging: wfx: improve error message on
 unexpected confirmation
Thread-Index: AQHVtPUZUTdSWpTmakq/HgUUicrz6Q==
Date:   Tue, 17 Dec 2019 16:14:46 +0000
Message-ID: <20191217161318.31402-15-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 3708457f-b5da-496f-ba4d-08d7830c3b94
x-ms-traffictypediagnostic: MN2PR11MB3678:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB367831550C901E3672F0EF9793500@MN2PR11MB3678.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(396003)(39840400004)(366004)(136003)(199004)(189003)(6512007)(66574012)(1076003)(4744005)(478600001)(86362001)(8936002)(110136005)(316002)(2616005)(26005)(6506007)(5660300002)(36756003)(6486002)(66946007)(66476007)(66556008)(64756008)(66446008)(71200400001)(52116002)(85182001)(81166006)(81156014)(8676002)(54906003)(107886003)(15650500001)(2906002)(4326008)(186003)(85202003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3678;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: roRmMONQI/CTmPNxWunU/3qvpaqt8vL0nafWhQzMZvcghCRaAtg9IWw0mS9X+Tqz0RTrMskGTXqBl5en5zh2ECKysLMkl8awyctsceu/+c9RGSU1GtN8dfhnR3CBMEr7ToH6OjdrJBOk128QdjtIo84tGApOitwJ9y/B4kJiVx0tflDITY77kP1VISjYqtPyHy+e4PCt6II7sqq+lTEruLFD0mhnIqlJPChbw6w3PVnJWk21PaMHX7h7vUUrw+qWfuavx+OQ3cXtXjjXRAW3d0eRDgrNTDrZcA/sbUaC62UmVL2ncUtO4TUf5G9HP+FetJ/Cd+b3u9sZfUdOJ/B/B5uPecWJdALudtInwNeYnz7RE1GWf2aGz1879SXCaQg1tse9RaJnkVrtauGu+ZTcHU+Hp+uMvhgqaqimyxgWOAK5Jtnn6ZJY4sG8YISm/xNS
Content-Type: text/plain; charset="utf-8"
Content-ID: <E44D32BCEBDBC14F91BBE671250F4830@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3708457f-b5da-496f-ba4d-08d7830c3b94
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 16:14:46.2031
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bSAhPy+Vyh67hPrUb6PZQSmJabO4OP22OCr98cm7BsDh+kiL2poTfbV7RfFMBKMbC9swQ9JcLDCkuEzPkUPWaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3678
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKV2hl
biBkcml2ZXIgcmVjZWl2ZXMgYW4gdW5leHBlY3RlZCBhbnN3ZXIgZnJvbSB0aGUgZGV2aWNlLCBp
dCBzaG93cwoidW5zdXBwb3J0ZWQgSElGIElEIi4gVGhhdCBtZXNzYWdlIGRvZXMgbm90IHJlcHJl
c2VudCB0aGUgcmVhbCBlcnJvci4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxq
ZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9y
eC5jIHwgNyArKysrKystCiAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCAxIGRlbGV0
aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfcnguYyBiL2RyaXZl
cnMvc3RhZ2luZy93ZngvaGlmX3J4LmMKaW5kZXggODIwZGUyMTZiZTBjLi4xNDk0YWQ1YTUwN2Ig
MTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3J4LmMKKysrIGIvZHJpdmVycy9z
dGFnaW5nL3dmeC9oaWZfcnguYwpAQCAtMzU4LDcgKzM1OCwxMiBAQCB2b2lkIHdmeF9oYW5kbGVf
cngoc3RydWN0IHdmeF9kZXYgKndkZXYsIHN0cnVjdCBza19idWZmICpza2IpCiAJCQlnb3RvIGZy
ZWU7CiAJCX0KIAl9Ci0JZGV2X2Vycih3ZGV2LT5kZXYsICJ1bnN1cHBvcnRlZCBISUYgSUQgJTAy
eFxuIiwgaGlmX2lkKTsKKwlpZiAoaGlmX2lkICYgMHg4MCkKKwkJZGV2X2Vycih3ZGV2LT5kZXYs
ICJ1bnN1cHBvcnRlZCBISUYgaW5kaWNhdGlvbjogSUQgJTAyeFxuIiwKKwkJCWhpZl9pZCk7CisJ
ZWxzZQorCQlkZXZfZXJyKHdkZXYtPmRldiwgInVuZXhwZWN0ZWQgSElGIGNvbmZpcm1hdGlvbjog
SUQgJTAyeFxuIiwKKwkJCWhpZl9pZCk7CiBmcmVlOgogCWRldl9rZnJlZV9za2Ioc2tiKTsKIH0K
LS0gCjIuMjQuMAoK
