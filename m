Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06E0512108F
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 18:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727230AbfLPREG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 12:04:06 -0500
Received: from mail-eopbgr700081.outbound.protection.outlook.com ([40.107.70.81]:14720
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726252AbfLPRED (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 12:04:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bHTtOJgggTek0FG6KBXqM/WSOui5SAjFpFiE63roxOuYAu8iHwOx+zRrBE6V/PixYrfouKbeJ45hqe3Ic7vJnCffMhnrBq9BX+fhtewq7i9pwUZR8cIGaPOiK+JHQzWCO3wFNiVK6wihnEqtFl4U51W8grLiQt5EdvyRL1HidKt1TXCEPI7td/r5m/9BViLSsd3grJi6fuj4O9VN5/L2rf976YlI/6C2xbCa6rpgqL0vLdWDRkjOWO6SKee0zRrIiTttQva0KB2haMcZbBmsFPUJiJwaXJIaBYvE/+SaJJlxpkTZMEQlfeO1wCIdU1QIH2wZcbTWwncX1nDhgI3rNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/zqsPaKApTZnfOGYQ6HyXyVh4KolOyQoMkJqS4dYTYs=;
 b=dGTzgIYFF2KoX8KY0Z5FY4EaQwT4ml1BR8gZFJJCHH3bb2BuE/l13vtR9+y6VcmA3c1ZoC54LhvWIJ8PyziVOe0fufkU8wUMPG4aw34JDrY/Ar+kGMoTxZ8lRyoxJNuSnrl1Y2nxPpnyXv0xaLepS7+PK6nYGPhedtLuCZJ53QuCwQ+OSpLyUGzEO3GS/37ABYoPIJhxsZ4OKOmFp9KOwuavDIhGlAzgoF/rYFHd/Rfyf7lLi7HInKWQ2hv60HR2hzECIkm6465C87hRkeIhjtXWomGsfZPbajAN++MjPYLfu3kual6FrzbX0muFYrBki9uEmKC6rr4sDHIBNxG+lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/zqsPaKApTZnfOGYQ6HyXyVh4KolOyQoMkJqS4dYTYs=;
 b=dDcdPNxctAy/q0EYzFK8y52gozqQfIjtHtqrCSU6ML8qX9s152lTeXUKfTUWJKBCfF2fzaZdVSd0ElzH9T971EZel06Mxt3uky4vO2EZu9Z6DGIT8196pUa738m/ScxTsRDHRJuJaGLfYk/lnQJ5KhntVl//w7+WYYifSLVV3ck=
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
Subject: [PATCH 24/55] staging: wfx: fix typo in "num_i_es"
Thread-Topic: [PATCH 24/55] staging: wfx: fix typo in "num_i_es"
Thread-Index: AQHVtDLHGFd3gvqiy0ia04l1QjyuJw==
Date:   Mon, 16 Dec 2019 17:03:46 +0000
Message-ID: <20191216170302.29543-25-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 72fd01e2-b595-479d-cac5-08d78249ee24
x-ms-traffictypediagnostic: MN2PR11MB4351:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB43513539683E8A5D976CB98793510@MN2PR11MB4351.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:328;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(376002)(346002)(396003)(39860400002)(199004)(189003)(66556008)(66446008)(64756008)(66476007)(76116006)(85202003)(91956017)(66946007)(54906003)(107886003)(4326008)(478600001)(110136005)(71200400001)(6512007)(81156014)(8676002)(81166006)(186003)(36756003)(2906002)(85182001)(6666004)(66574012)(1076003)(316002)(6506007)(5660300002)(86362001)(26005)(2616005)(6486002)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4351;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5wbfrkrWg/rNFFpsz0niyfnnw/df15N+X+Br85SlF6UvGVGXxBWu4KJXyZUDua6xH36SJR5l457YPgo8XJ60nbQ52CG6XAmtxqT1AylJH7NkrsA1bxnoDQJcgaxt1bKpAP1BKl8HgC84alKb5kof+0zGvJy+YWdOpomYH5OzFs/oGbYTueHM9a9S8YnG4FgvxosaOzwt2X8O1hIgn+d/PiWs+zLf5DTS6C0Ac3GoKHV5udO61i9kA1tc4UFtd6E7aayW7XdQeDbNaJ/8WWGgMQGXWT+efRlw0ZXoeUUKNkZ3MPYM9F2pkPK7A+oWNuKuleL0FHxgFSg7wARSgDAvIqMc8/6UXn0YGJjFBIau/ni5mbjRtxzyM+WvNFdxw5WBT7JCGVKo4ePTXj2kVDmjVoeoLC9i/4SMVegAmTieWiRRxSYHhKkpcbWRjqX9V0XM
Content-Type: text/plain; charset="utf-8"
Content-ID: <D787B846B11123478E4F837DE062338F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72fd01e2-b595-479d-cac5-08d78249ee24
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 17:03:46.2708
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: A/0YgY/bz8qk4IaTj8HkvGYSSq03/Rfh1FwAk71GUEOQuP6w69tqqooJsf1eqHeNv0Wd388Eh723CUj6Rvysdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4351
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPg0KDQpU
aGUgc2NyaXB0IHRoYXQgaGFzIGltcG9ydGVkIEFQSSBoZWFkZXIgaGFzIG1hZGUgYSBtaXN0YWtl
ICJudW1faV9lcyIuDQoNClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUu
cG91aWxsZXJAc2lsYWJzLmNvbT4NCi0tLQ0KIGRyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9j
bWQuaCB8IDIgKy0NCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5jICAgICAgfCAyICstDQog
MiBmaWxlcyBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQoNCmRpZmYg
LS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfY21kLmggYi9kcml2ZXJzL3N0YWdp
bmcvd2Z4L2hpZl9hcGlfY21kLmgNCmluZGV4IDkwYmE2ZTliODJlYS4uM2U3N2ZiZTNkNWZmIDEw
MDY0NA0KLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfYXBpX2NtZC5oDQorKysgYi9kcml2
ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfY21kLmgNCkBAIC0xMzcsNyArMTM3LDcgQEAgc3RydWN0
IGhpZl9pZV90bHYgew0KIA0KIHN0cnVjdCBoaWZfcmVxX3VwZGF0ZV9pZSB7DQogCXN0cnVjdCBo
aWZfaWVfZmxhZ3MgaWVfZmxhZ3M7DQotCXUxNiAgIG51bV9pX2VzOw0KKwl1MTYgICBudW1faWVz
Ow0KIAlzdHJ1Y3QgaGlmX2llX3RsdiBpZVtdOw0KIH0gX19wYWNrZWQ7DQogDQpkaWZmIC0tZ2l0
IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHguYyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlm
X3R4LmMNCmluZGV4IDJmNzRhYmNhMmI2MC4uNmZiOThkZGJjMGUyIDEwMDY0NA0KLS0tIGEvZHJp
dmVycy9zdGFnaW5nL3dmeC9oaWZfdHguYw0KKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZf
dHguYw0KQEAgLTQyOSw3ICs0MjksNyBAQCBpbnQgaGlmX3VwZGF0ZV9pZShzdHJ1Y3Qgd2Z4X3Zp
ZiAqd3ZpZiwgY29uc3Qgc3RydWN0IGhpZl9pZV9mbGFncyAqdGFyZ2V0X2ZyYW1lLA0KIAlzdHJ1
Y3QgaGlmX3JlcV91cGRhdGVfaWUgKmJvZHkgPSB3ZnhfYWxsb2NfaGlmKGJ1Zl9sZW4sICZoaWYp
Ow0KIA0KIAltZW1jcHkoJmJvZHktPmllX2ZsYWdzLCB0YXJnZXRfZnJhbWUsIHNpemVvZihzdHJ1
Y3QgaGlmX2llX2ZsYWdzKSk7DQotCWJvZHktPm51bV9pX2VzID0gY3B1X3RvX2xlMTYoMSk7DQor
CWJvZHktPm51bV9pZXMgPSBjcHVfdG9fbGUxNigxKTsNCiAJbWVtY3B5KGJvZHktPmllLCBpZXMs
IGllc19sZW4pOw0KIAl3ZnhfZmlsbF9oZWFkZXIoaGlmLCB3dmlmLT5pZCwgSElGX1JFUV9JRF9V
UERBVEVfSUUsIGJ1Zl9sZW4pOw0KIAlyZXQgPSB3ZnhfY21kX3NlbmQod3ZpZi0+d2RldiwgaGlm
LCBOVUxMLCAwLCBmYWxzZSk7DQotLSANCjIuMjAuMQ0K
