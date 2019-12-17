Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 526F2123196
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 17:16:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729261AbfLQQQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 11:16:17 -0500
Received: from mail-dm6nam12on2072.outbound.protection.outlook.com ([40.107.243.72]:33729
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728642AbfLQQQQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 11:16:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qq3pnEtudPC0OsI+CTrGex6mHpTyrXQJs0+yKlT4F70qMpJvCV8r5QFwrArTODPf0AB5XpUBeOLHwXCd5zwPrqcRysldwnO2idZy7++wx5l5C63+VQvwxnAkzkYIxF/PtgBdCltk+hp1W1GgjNwf6nYt/28ehBBc/UwHyJ9gTiiGzCVY3kgvDlL9bpi7EBKuHdbwksUnBRUavE90J+pYLYU9mZs9csjLYtIBW0v8bFAnqxYiys4LxaNLfFK3biz2KAD0mpSds77MQ5M0odpvqnZPXf9Oe/H3IZXo28np7xRdeGDCvWHmbl9ih7vtoX6dOzuO0Jo9zw+t9j2ZHCSnBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pBmCupR+XfI8OUMBZwe9ajX+xNfE7EuQEetv3O31LBQ=;
 b=W6hcz9DlR82/7m2VZ9vyKG6I7Fat84lzu1s7mLbNczDjidoZFxgFUsvOmQhgvKMrfzqUxt04Mckp/gxdz9tRM5qMRCFeVjzFZIwt4uqr3bLwh5uP0UF/ux56RRBiBXRDvjwZbUsx++pArMYdWhbnS/NxMKXdNxWUuEDb8GcO4Cmi70a8LEluCmk3IwL4T+CfRpbyz7EHYhtj6WTsE4LzPZrmqjBhGwIejh0RR7PU1I6Ds1Hf/6UDpERKqzY+5nXXEdx14e7TWxif6vm3d+z/UIKi03svcOhU68FzX/BeDNJBzOLalPILJu2/tnMNEJ0eevsRvlnDp4dmEVA6XVH9jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pBmCupR+XfI8OUMBZwe9ajX+xNfE7EuQEetv3O31LBQ=;
 b=hJ4AJ0Lj4xtSYZqdIxs90e7cH3++PHa2IoKPo5bujlbOd0F6B3A1SX/EhJFxIGszBOI7Bq6tRx0XekDM/mLWCLr2oj1bzNx2DHIz8AwZWjGNOr0XWEoXfo3o1aCommVRdTMwGAEOeW8QQqIcZ9Gt3TOJSDrYKsVbmPV0T6TiXUo=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4477.namprd11.prod.outlook.com (52.135.36.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.17; Tue, 17 Dec 2019 16:16:02 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 16:16:02 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 52/55] staging: wfx: delayed_unjoin cannot happen
Thread-Topic: [PATCH v2 52/55] staging: wfx: delayed_unjoin cannot happen
Thread-Index: AQHVtPU4StV4QnRFhEulRZOnDeUv5Q==
Date:   Tue, 17 Dec 2019 16:15:38 +0000
Message-ID: <20191217161318.31402-53-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 560a8ec3-ce4b-4781-31ec-08d7830c5ae9
x-ms-traffictypediagnostic: MN2PR11MB4477:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4477C8B75F21123A84439EC693500@MN2PR11MB4477.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(396003)(136003)(366004)(39860400002)(199004)(189003)(1076003)(66574012)(186003)(107886003)(8676002)(6506007)(86362001)(478600001)(85182001)(5660300002)(81156014)(26005)(4326008)(6486002)(8936002)(316002)(110136005)(54906003)(64756008)(66446008)(66946007)(2616005)(66556008)(66476007)(85202003)(36756003)(6512007)(2906002)(52116002)(6666004)(71200400001)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4477;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PMEc9ycfGc0ybDXiTU8L/wjWn4oktSBAQx/EaygEKnRWZ8wzpVYB110ytO+E2O2HsXD+e50b7b9ww3CZWje7BtRfBV+ednKp08gHNBlBU9ZVxeI2MVLVXsWET+HV8TopPRrIYAJVe4UmSbCa68+WoAaOZWZsnVnK7J0pOHtNUhykbeBQzmG7ob1Jg4hCvULDoGMHII82kcefYF3ZPmHYjRg0vyeUuZCuCDNjOy+qqKRL88Y0DZ9g06SASlx+PEsZynnzGmf24EnfJNKWLekXVy7TU1i8iJ2GyDWRXcz00MXAuqFOkDX/D1TLtIW3DEJ7gE1/HabFGjJXA/k+yfUvMGjXqUJ5JMyaMzHx0AjDBWI8cACeLoZkH+UcM7A/ySYm0Hj7rjIii2izzjcseohGu8+1r1BbFQf5Yze83Kj8saflLjpsY+wlghclMgFBczm7
Content-Type: text/plain; charset="utf-8"
Content-ID: <F752AD458FB63E49A64B962075C02431@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 560a8ec3-ce4b-4781-31ec-08d7830c5ae9
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 16:15:38.6281
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UILzeyrL5vP9YQLvKiCbzE+q5cfB+7bSzQAJ+ET26HdqfsJKgCpy+4uyIp8o6OCVkCGoOAyU0VG7KDz3oxzGqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4477
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKT3Jp
Z2luYWwgY29kZSBhbGxvd3MgdG8gZGV0ZWN0IGFuIHVuam9pbiByZXF1ZXN0IGR1cmluZyBhIHNj
YW4gYW5kCmRlbGF5aW5nIHRoZSB1bmpvaW4gcmVxdWVzdC4gSG93ZXZlciwgaXQgaXMgZmFyIGVh
c2llciB0byBqdXN0IGJsb2NrIHRoZQp1bmpvaW4gcmVxdWVzdCB1bnRpbCB0aGUgZW5kIG9mIHRo
ZSBzY2FuIHJlcXVlc3QuCgpJbiBmYWN0LCBpdCBpcyBhbHJlYWR5IHRoZSBjYXNlIHNpbmNlIHNj
YW4gYW5kIHVuam9pbiBhcmUgcHJvdGVjdGVkIGJ5CmNvbmZfbXV0ZXguIFNvLCBjdXJyZW50bHks
IHRoZSBoYW5kbGluZyBvZiBkZWxheWVkX3Vuam9pbiBpcyBqdXN0IGRlYWQKY29kZS4KClNpZ25l
ZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4K
LS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3NjYW4uYyB8ICA3ICstLS0tLS0KIGRyaXZlcnMvc3Rh
Z2luZy93Zngvc3RhLmMgIHwgMTQgLS0tLS0tLS0tLS0tLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngv
d2Z4LmggIHwgIDEgLQogMyBmaWxlcyBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMjEgZGVsZXRp
b25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zY2FuLmMgYi9kcml2ZXJz
L3N0YWdpbmcvd2Z4L3NjYW4uYwppbmRleCA1NDAwMDliNzIyNDAuLmJkYmNlNjkyNmU5MSAxMDA2
NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zY2FuLmMKKysrIGIvZHJpdmVycy9zdGFnaW5n
L3dmeC9zY2FuLmMKQEAgLTk1LDEyICs5NSw3IEBAIHZvaWQgd2Z4X2h3X3NjYW5fd29yayhzdHJ1
Y3Qgd29ya19zdHJ1Y3QgKndvcmspCiAJbXV0ZXhfdW5sb2NrKCZ3dmlmLT53ZGV2LT5jb25mX211
dGV4KTsKIAltdXRleF91bmxvY2soJnd2aWYtPnNjYW5fbG9jayk7CiAJX19pZWVlODAyMTFfc2Nh
bl9jb21wbGV0ZWRfY29tcGF0KHd2aWYtPndkZXYtPmh3LCByZXQgPCAwKTsKLQlpZiAod3ZpZi0+
ZGVsYXllZF91bmpvaW4pIHsKLQkJd3ZpZi0+ZGVsYXllZF91bmpvaW4gPSBmYWxzZTsKLQkJd2Z4
X3R4X2xvY2sod3ZpZi0+d2Rldik7Ci0JCWlmICghc2NoZWR1bGVfd29yaygmd3ZpZi0+dW5qb2lu
X3dvcmspKQotCQkJd2Z4X3R4X3VubG9jayh3dmlmLT53ZGV2KTsKLQl9IGVsc2UgaWYgKHd2aWYt
PmRlbGF5ZWRfbGlua19sb3NzKSB7CisJaWYgKHd2aWYtPmRlbGF5ZWRfbGlua19sb3NzKSB7CiAJ
CXd2aWYtPmRlbGF5ZWRfbGlua19sb3NzID0gZmFsc2U7CiAJCXdmeF9jcW1fYnNzbG9zc19zbSh3
dmlmLCAxLCAwLCAwKTsKIAl9CmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5j
IGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwppbmRleCA0MzU0YmI4MDgxYzUuLjdhZTc2M2U5
NjQ1NSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYworKysgYi9kcml2ZXJz
L3N0YWdpbmcvd2Z4L3N0YS5jCkBAIC02NiwxMCArNjYsNiBAQCB2b2lkIHdmeF9jcW1fYnNzbG9z
c19zbShzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgaW50IGluaXQsIGludCBnb29kLCBpbnQgYmFkKQog
CXd2aWYtPmRlbGF5ZWRfbGlua19sb3NzID0gMDsKIAljYW5jZWxfd29ya19zeW5jKCZ3dmlmLT5i
c3NfcGFyYW1zX3dvcmspOwogCi0JLyogSWYgd2UgaGF2ZSBhIHBlbmRpbmcgdW5qb2luICovCi0J
aWYgKHd2aWYtPmRlbGF5ZWRfdW5qb2luKQotCQlnb3RvIGVuZDsKLQogCWlmIChpbml0KSB7CiAJ
CXNjaGVkdWxlX2RlbGF5ZWRfd29yaygmd3ZpZi0+YnNzX2xvc3Nfd29yaywgSFopOwogCQl3dmlm
LT5ic3NfbG9zc19zdGF0ZSA9IDA7CkBAIC01MDEsMTYgKzQ5Nyw2IEBAIHN0YXRpYyB2b2lkIHdm
eF9kb191bmpvaW4oc3RydWN0IHdmeF92aWYgKnd2aWYpCiB7CiAJbXV0ZXhfbG9jaygmd3ZpZi0+
d2Rldi0+Y29uZl9tdXRleCk7CiAKLQlpZiAoIW11dGV4X3RyeWxvY2soJnd2aWYtPnNjYW5fbG9j
aykpIHsKLQkJaWYgKHd2aWYtPmRlbGF5ZWRfdW5qb2luKQotCQkJZGV2X2RiZyh3dmlmLT53ZGV2
LT5kZXYsCi0JCQkJImRlbGF5ZWQgdW5qb2luIGlzIGFscmVhZHkgc2NoZWR1bGVkXG4iKTsKLQkJ
ZWxzZQotCQkJd3ZpZi0+ZGVsYXllZF91bmpvaW4gPSB0cnVlOwotCQlnb3RvIGRvbmU7Ci0JfQot
CW11dGV4X3VubG9jaygmd3ZpZi0+c2Nhbl9sb2NrKTsKLQogCXd2aWYtPmRlbGF5ZWRfbGlua19s
b3NzID0gZmFsc2U7CiAKIAlpZiAoIXd2aWYtPnN0YXRlKQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9z
dGFnaW5nL3dmeC93ZnguaCBiL2RyaXZlcnMvc3RhZ2luZy93Zngvd2Z4LmgKaW5kZXggYjVmNzYz
YzNmYWM3Li41ZTdjOTExZGIwMjQgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngvd2Z4
LmgKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC93ZnguaApAQCAtMTIyLDcgKzEyMiw2IEBAIHN0
cnVjdCB3ZnhfdmlmIHsKIAlzdHJ1Y3Qgd29ya19zdHJ1Y3QJc2V0X2N0c193b3JrOwogCiAJaW50
CQkJam9pbl9jb21wbGV0ZV9zdGF0dXM7Ci0JYm9vbAkJCWRlbGF5ZWRfdW5qb2luOwogCXN0cnVj
dCB3b3JrX3N0cnVjdAl1bmpvaW5fd29yazsKIAogCS8qIGF2b2lkIHNvbWUgb3BlcmF0aW9ucyBp
biBwYXJhbGxlbCB3aXRoIHNjYW4gKi8KLS0gCjIuMjQuMAoK
