Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC802121103
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 18:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbfLPRHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 12:07:01 -0500
Received: from mail-eopbgr690050.outbound.protection.outlook.com ([40.107.69.50]:60371
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727875AbfLPRG7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 12:06:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T6dDRQMJcxnyau95z8FRcsmyfTRU5Vxv+yWQjH7Go7NoXvK4iwGL9EHr3O2OkZo3lT1obKjlP8yfJLWcyeopA69QWCHa3CyVZyiHMd7ywHPsQB0RJatB9nVlVtgvV98iemnZ9XVeTqN35O6nWKZG5+E+EraQWtqDwcuD5D/yBSzFA4TAo7CZZKzZIjiWuN8wrCxfOnEL7dq/3cmZKoRLpS2wv5Tvq3VW8IOYA5k1GjxSbLU5ZooKEa4zn0A0Ydfy+D5ANrITDhNYX16tPIFkcNM3qafvLF5R9Qvm+u9hebSACPX7pYWjT5C50y13mplpp/jDg8OcV9o3B//UVKhvcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3I6uLtCmTopaYKhwbNqFgFvT0LPiGRjr3lx3yDmpLLA=;
 b=DJf1b3VmDrtI6UCJofoDQ9z1veavzEPhqmL3X9NjnuY2b2FpG8XhP8/YCAOXLgLoJ1lDWJiY1CwDjy7eS/NpWi5QI2ZJFksUJvlEEh2v8jHmrU2rLDVV5mYeUwO9y5ov/LloCoIFhfVteNa7ReFX/J+0U6TaX6KLWnYDqzfXi2JdZzgmSAECIj6jKi6SXV5zOEEhlo0RI2TIOq2xZiBu31eMjBiCb0rAAuq1N3zr2Se+hABbZbb3XYs2oDbWjSRmv4uBtN34T/oveBsDO55LaxZKNNPK5DLBucI5rRwlxgfcqp4jwfllwSqGmAiSmOdVO/88Si0q02eqTrPuTTQYVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3I6uLtCmTopaYKhwbNqFgFvT0LPiGRjr3lx3yDmpLLA=;
 b=ZzdRgnS1IM7RT44xBfrKTf0BjDU7GYQYmGnaTQ0iR26udhI1Al1CFRhEp7SE4m9XJRMQhiv8qDxQErLFDdWpvTq6UVS/KCOgJJhHI46wCS9zUej+mPnTEBgs61CZ2GC1ZfFyI93W1t+DwCLC78rGnvv11oM9mdBUt6Cz/O9emoI=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4142.namprd11.prod.outlook.com (20.179.149.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.15; Mon, 16 Dec 2019 17:06:45 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 17:06:45 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 44/55] staging: wfx: hif_scan() never fails
Thread-Topic: [PATCH 44/55] staging: wfx: hif_scan() never fails
Thread-Index: AQHVtDLNDPsXBjorwEOj2oBe9WWPaA==
Date:   Mon, 16 Dec 2019 17:03:56 +0000
Message-ID: <20191216170302.29543-45-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 0e7b4041-f3e9-48a3-3f52-08d7824a549e
x-ms-traffictypediagnostic: MN2PR11MB4142:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB41423445B450C69B57C9C86093510@MN2PR11MB4142.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(346002)(136003)(376002)(39850400004)(199004)(189003)(6512007)(71200400001)(91956017)(6486002)(8676002)(2906002)(54906003)(81166006)(81156014)(186003)(76116006)(478600001)(36756003)(85182001)(85202003)(6666004)(66556008)(66476007)(66446008)(64756008)(1076003)(316002)(2616005)(4326008)(6506007)(26005)(8936002)(110136005)(5660300002)(107886003)(66946007)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4142;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +PD8z0tQUSse1vZLwKaHJeg6ymZItvjB2cDQUy3ycOpTZaY7ao/YSERs9mhy4d5pxGNwdCPHMbS0QmsWQEUaXfzzRnkKOwk9S0lNCdiD6vt8CoD7xGKS7QAOcTB4cdon41GfpNCzgrAobrAxZxGXZWbPGnKf3t5uc3L7xTfaVM+MGs9ZqlQ4e4WxaV2VyG4d93+s5EH29o7/SqbYRK+j/iRJO1bNQShOKE2YrBgNd6elHkOHZ/XkZnDcKu+vOrTs134Ci8hr2LF/zp6TIoyeB5yXVVymuZy8NRnac2onyCTRw8pdGDBniqe44uZ14DZTieb0ZPNlcDmpNryhUnZuY02vXtUdffCczzW5O0coUJFXDApkPF9suLvVgVKsHbS7igM9xDx8ApHq4A6uEAaGxmBwVxyYy96dkWMIo612R9FavaPeucgxpV6sLCQL7SHI
Content-Type: text/plain; charset="utf-8"
Content-ID: <A66B2ED4F740974CA606362DC5A5A164@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e7b4041-f3e9-48a3-3f52-08d7824a549e
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 17:03:56.2211
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EGbLEvmmDrcLNXh4C6lVK7KOvXFY1TpRv2OQmKmSrm1wj20HNcr0uEmI6+5mo3hIVZhBaYxfwLaOFQzKJoJp5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4142
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPg0KDQpJ
ZiBzY2FuIGZhaWxzLCBzdGF0dXMgaXMgcmV0dXJuZWQgaW4gaGlmX2luZF9zY2FuX2NtcGwuIGhp
Zl9zY2FuDQphbHdheXMgcmV0dXJuIGEgc3VjY2Vzcy4gU28sIHdlIGNhbiBzaW1wbGlmeSB0aGUg
Y29kZS4NCg0KU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxl
ckBzaWxhYnMuY29tPg0KLS0tDQogZHJpdmVycy9zdGFnaW5nL3dmeC9zY2FuLmMgfCAyMCArKy0t
LS0tLS0tLS0tLS0tLS0tLQ0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc2Nhbi5oIHwgIDEgLQ0KIDIg
ZmlsZXMgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAxOSBkZWxldGlvbnMoLSkNCg0KZGlmZiAt
LWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc2Nhbi5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9z
Y2FuLmMNCmluZGV4IDRiOTVlNmE5N2RmNy4uY2RjY2I2N2NiMzBlIDEwMDY0NA0KLS0tIGEvZHJp
dmVycy9zdGFnaW5nL3dmeC9zY2FuLmMNCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc2Nhbi5j
DQpAQCAtMzYsNyArMzYsNiBAQCBzdGF0aWMgdm9pZCB3Znhfc2Nhbl9yZXN0YXJ0X2RlbGF5ZWQo
c3RydWN0IHdmeF92aWYgKnd2aWYpDQogDQogc3RhdGljIGludCB3Znhfc2Nhbl9zdGFydChzdHJ1
Y3Qgd2Z4X3ZpZiAqd3ZpZiwgc3RydWN0IHdmeF9zY2FuX3BhcmFtcyAqc2NhbikNCiB7DQotCWlu
dCByZXQ7DQogCWludCB0bW8gPSA1MDA7DQogDQogCWlmICh3dmlmLT5zdGF0ZSA9PSBXRlhfU1RB
VEVfUFJFX1NUQSkNCkBAIC00OCwxNSArNDcsOCBAQCBzdGF0aWMgaW50IHdmeF9zY2FuX3N0YXJ0
KHN0cnVjdCB3ZnhfdmlmICp3dmlmLCBzdHJ1Y3Qgd2Z4X3NjYW5fcGFyYW1zICpzY2FuKQ0KIAlh
dG9taWNfc2V0KCZ3dmlmLT53ZGV2LT5zY2FuX2luX3Byb2dyZXNzLCAxKTsNCiANCiAJc2NoZWR1
bGVfZGVsYXllZF93b3JrKCZ3dmlmLT5zY2FuLnRpbWVvdXQsIG1zZWNzX3RvX2ppZmZpZXModG1v
KSk7DQotCXJldCA9IGhpZl9zY2FuKHd2aWYsIHNjYW4pOw0KLQlpZiAocmV0KSB7DQotCQl3Znhf
c2Nhbl9mYWlsZWRfY2Iod3ZpZik7DQotCQlhdG9taWNfc2V0KCZ3dmlmLT5zY2FuLmluX3Byb2dy
ZXNzLCAwKTsNCi0JCWF0b21pY19zZXQoJnd2aWYtPndkZXYtPnNjYW5faW5fcHJvZ3Jlc3MsIDAp
Ow0KLQkJY2FuY2VsX2RlbGF5ZWRfd29ya19zeW5jKCZ3dmlmLT5zY2FuLnRpbWVvdXQpOw0KLQkJ
d2Z4X3NjYW5fcmVzdGFydF9kZWxheWVkKHd2aWYpOw0KLQl9DQotCXJldHVybiByZXQ7DQorCWhp
Zl9zY2FuKHd2aWYsIHNjYW4pOw0KKwlyZXR1cm4gMDsNCiB9DQogDQogaW50IHdmeF9od19zY2Fu
KHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LA0KQEAgLTI0NSwxNCArMjM3LDYgQEAgc3RhdGljIHZv
aWQgd2Z4X3NjYW5fY29tcGxldGUoc3RydWN0IHdmeF92aWYgKnd2aWYpDQogCXdmeF9zY2FuX3dv
cmsoJnd2aWYtPnNjYW4ud29yayk7DQogfQ0KIA0KLXZvaWQgd2Z4X3NjYW5fZmFpbGVkX2NiKHN0
cnVjdCB3ZnhfdmlmICp3dmlmKQ0KLXsNCi0JaWYgKGNhbmNlbF9kZWxheWVkX3dvcmtfc3luYygm
d3ZpZi0+c2Nhbi50aW1lb3V0KSA+IDApIHsNCi0JCXd2aWYtPnNjYW4uc3RhdHVzID0gLUVJTzsN
Ci0JCXNjaGVkdWxlX3dvcmsoJnd2aWYtPnNjYW4udGltZW91dC53b3JrKTsNCi0JfQ0KLX0NCi0N
CiB2b2lkIHdmeF9zY2FuX2NvbXBsZXRlX2NiKHN0cnVjdCB3ZnhfdmlmICp3dmlmLA0KIAkJCSAg
Y29uc3Qgc3RydWN0IGhpZl9pbmRfc2Nhbl9jbXBsICphcmcpDQogew0KZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvc3RhZ2luZy93Zngvc2Nhbi5oIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zY2FuLmgNCmlu
ZGV4IGM3YzBhYjE3OGM4Ny4uZTcxZTVmMGY1MjJlIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zdGFn
aW5nL3dmeC9zY2FuLmgNCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc2Nhbi5oDQpAQCAtMzgs
NiArMzgsNSBAQCB2b2lkIHdmeF9zY2FuX3dvcmsoc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKTsN
CiB2b2lkIHdmeF9zY2FuX3RpbWVvdXQoc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKTsNCiB2b2lk
IHdmeF9zY2FuX2NvbXBsZXRlX2NiKHN0cnVjdCB3ZnhfdmlmICp3dmlmLA0KIAkJCSAgY29uc3Qg
c3RydWN0IGhpZl9pbmRfc2Nhbl9jbXBsICphcmcpOw0KLXZvaWQgd2Z4X3NjYW5fZmFpbGVkX2Ni
KHN0cnVjdCB3ZnhfdmlmICp3dmlmKTsNCiANCiAjZW5kaWYgLyogV0ZYX1NDQU5fSCAqLw0KLS0g
DQoyLjIwLjENCg==
