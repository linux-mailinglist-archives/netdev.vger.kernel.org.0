Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4B7F1210D3
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 18:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727582AbfLPRGK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 12:06:10 -0500
Received: from mail-dm6nam11on2086.outbound.protection.outlook.com ([40.107.223.86]:11937
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727205AbfLPRGH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 12:06:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QVfwmmtjROWoXbJ8m627VciLhCprikCOHN7jxSslfUZeclOVeF3hUNlAnewEclbtDbU/jV/aWHiBquOVk5wyd3z4YbqZupV4JA3PCGxXbnTnmKJSOwVJaDzq4W4wxUvNrzSS/N0/phyAKa+qLlZna1eJiX8peYi3n6KTJ6zv1HNtk8SqfuSn2SK2dUnq2CE/2wxmm3TMkbHEd30Nv393kNp/Ou11mM5DsFisPtimuibC/ptHb4Ulel2zn6L62dW5bexq8OPaf9b1BCT4xuIrc+DQsC5KcawMwbzCitCAPgtn2YFSU7H/Uscnle8VqxQotB+43Y9+jVe1r5H3BOHsbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jV0pqkKIqUnv4oBmI5heTeVQkO+OV5RwEFoWmFK8KT8=;
 b=Ksz/Koz44v2Tg0x7F1gqzSeB9RING7FZnq9YCa+spe9k2NJKd+DlTZAOTm4RZWY4uT/yp3AjLKanJMebjZN8BkRmxm/nIaIHflYnAR31+7pyT4P0tEfseDAD40lCno3CpknmP0PwD2IKtNG036VOEdszas3U9lmI+nl5xX1BVJ1uQMCNuozGiCYOarEvHOIWVLMANnkGHlYP4MJm3kmxNW1BldDmZQWKZUWczIrUy+rFmqY6i2xMghkibJf5FkdWoqa0+wsAFhjM0+JGriQ2tEi5AoSx8iG0l2HpsfP52lZtMjefT7OD9Ss3fEeLDqGfvRxH2T6MvEM+E8NIME67ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jV0pqkKIqUnv4oBmI5heTeVQkO+OV5RwEFoWmFK8KT8=;
 b=JoZir7kxwjOIjwcoKqvLQmVh6ivHHIkgzIHslwL4dccmMnA8/q1oDWj7zYfo2tMIIgBMCUmDl5RtLLJU5i0G+Gauzu4zz6Z4k3mlNXL2G/qycSIPp7DvX3hnhFv1eLS+lqcQ8mI6Kc386yij8DOTguheZ/scbd/Zg9duGEO8Xs4=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4445.namprd11.prod.outlook.com (52.135.37.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Mon, 16 Dec 2019 17:03:54 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 17:03:54 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 27/55] staging: wfx: better naming for
 hif_req_join->short_preamble
Thread-Topic: [PATCH 27/55] staging: wfx: better naming for
 hif_req_join->short_preamble
Thread-Index: AQHVtDLIQHILEZBo3Ey3ISANheZTkA==
Date:   Mon, 16 Dec 2019 17:03:47 +0000
Message-ID: <20191216170302.29543-28-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 48f1df4e-3ee3-4ab5-428d-08d78249eef5
x-ms-traffictypediagnostic: MN2PR11MB4445:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4445104E18F91C4997C255BC93510@MN2PR11MB4445.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(39860400002)(366004)(396003)(136003)(189003)(199004)(110136005)(6486002)(107886003)(36756003)(186003)(316002)(66946007)(54906003)(5660300002)(66446008)(66556008)(85182001)(66476007)(76116006)(91956017)(64756008)(2616005)(6506007)(85202003)(2906002)(26005)(71200400001)(6512007)(4326008)(8936002)(81166006)(1076003)(478600001)(86362001)(81156014)(6666004)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4445;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:3;A:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: D76TUXBOu+mlDkK+2GC4tgoiGL1j4R+4fvKQHzesWVSorS5WMsyJ1S7lytYclz/dX0mMrNaLCvuWF4nymtlq9Pren9EkbynoocpRGx5qaAX/6FmzsmkHbfyEmOmjfEmXHaC54s8iq+jT+vbIOkWrur5bAnNVoG1dlvwRsbjwUtjeiGtSV77S//lyk/5vW1U/BvUqb7yIbJYc/JcgK2wHRzCTO7p/PLPslnC/2F3sncar4Gs7PTj0pPzuKRKekML9LcKafv4MxXtu44uL/5l1v/VKy+CrPpCBbammLA2F066q+ZVAOMbyG8u9vC2aGcpFesj3nuhY029hIrkfhsvL52owdF9tnCahhA7r/Mz9qMtpXvUH0Ei7WxpeQ7QTO/ULAICAst6NTsyXzbBCrR52ypl9hO5NSxxxuLHyxBqjRtqS/myxuKhOhWcvp4VKSRWQ
Content-Type: text/plain; charset="utf-8"
Content-ID: <A8AE359AE63A2D4AA261FC3024D8BAC6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48f1df4e-3ee3-4ab5-428d-08d78249eef5
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 17:03:47.8229
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eNkfRJHPunNzfTO3RfBG5/RxuQWOyp5nYjDUWoSKqhLGdew+IWDM6Esm2etw8FyuDm7QwmsOhdH+fgPY7RyiCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4445
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPg0KDQpI
SUZfUFJFQU1CTEVfU0hPUlRfTE9ORzEyIGlzIG5ldmVyIHVzZWQuIFNvIGl0IGlzIHBvc3NpYmxl
IHRvIGNoYW5nZQ0KInByZWFtYmxlX3R5cGUiIGludG8gYSBib29sZWFuIGFuZCBkcm9wICJlbnVt
IGhpZl9wcmVhbWJsZSIuDQoNClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJv
bWUucG91aWxsZXJAc2lsYWJzLmNvbT4NCi0tLQ0KIGRyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2Fw
aV9jbWQuaCB8IDE2ICsrKysrKy0tLS0tLS0tLS0NCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9h
cGlfbWliLmggfCAgNSArKystLQ0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgICAgICAgICB8
ICA2ICsrKy0tLQ0KIDMgZmlsZXMgY2hhbmdlZCwgMTIgaW5zZXJ0aW9ucygrKSwgMTUgZGVsZXRp
b25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfY21kLmgg
Yi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfY21kLmgNCmluZGV4IGU4NDhiZDMwNzNhMi4u
ZmMwNzhkNTRiZmJmIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfYXBpX2Nt
ZC5oDQorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfY21kLmgNCkBAIC0zNzcsMTIg
KzM3Nyw2IEBAIHN0cnVjdCBoaWZfY25mX2VkY2FfcXVldWVfcGFyYW1zIHsNCiAJdTMyICAgc3Rh
dHVzOw0KIH0gX19wYWNrZWQ7DQogDQotZW51bSBoaWZfcHJlYW1ibGUgew0KLQlISUZfUFJFQU1C
TEVfTE9ORyAgICAgICAgICAgICAgICAgICAgICAgICAgPSAweDAsDQotCUhJRl9QUkVBTUJMRV9T
SE9SVCAgICAgICAgICAgICAgICAgICAgICAgICA9IDB4MSwNCi0JSElGX1BSRUFNQkxFX1NIT1JU
X0xPTkcxMiAgICAgICAgICAgICAgICAgID0gMHgyDQotfTsNCi0NCiBzdHJ1Y3QgaGlmX2pvaW5f
ZmxhZ3Mgew0KIAl1OCAgICByZXNlcnZlZDE6MjsNCiAJdTggICAgZm9yY2Vfbm9fYmVhY29uOjE7
DQpAQCAtMzk3LDkgKzM5MSwxMCBAQCBzdHJ1Y3QgaGlmX3JlcV9qb2luIHsNCiAJdTE2ICAgY2hh
bm5lbF9udW1iZXI7DQogCXU4ICAgIGJzc2lkW0VUSF9BTEVOXTsNCiAJdTE2ICAgYXRpbV93aW5k
b3c7DQotCXU4ICAgIHByZWFtYmxlX3R5cGU7DQorCXU4ICAgIHNob3J0X3ByZWFtYmxlOjE7DQor
CXU4ICAgIHJlc2VydmVkMjo3Ow0KIAl1OCAgICBwcm9iZV9mb3Jfam9pbjsNCi0JdTggICAgcmVz
ZXJ2ZWQ7DQorCXU4ICAgIHJlc2VydmVkMzsNCiAJc3RydWN0IGhpZl9qb2luX2ZsYWdzIGpvaW5f
ZmxhZ3M7DQogCXUzMiAgIHNzaWRfbGVuZ3RoOw0KIAl1OCAgICBzc2lkW0hJRl9BUElfU1NJRF9T
SVpFXTsNCkBAIC00NjIsOCArNDU3LDkgQEAgc3RydWN0IGhpZl9yZXFfc3RhcnQgew0KIAl1MzIg
ICByZXNlcnZlZDE7DQogCXUzMiAgIGJlYWNvbl9pbnRlcnZhbDsNCiAJdTggICAgZHRpbV9wZXJp
b2Q7DQotCXU4ICAgIHByZWFtYmxlX3R5cGU7DQotCXU4ICAgIHJlc2VydmVkMjsNCisJdTggICAg
c2hvcnRfcHJlYW1ibGU6MTsNCisJdTggICAgcmVzZXJ2ZWQyOjc7DQorCXU4ICAgIHJlc2VydmVk
MzsNCiAJdTggICAgc3NpZF9sZW5ndGg7DQogCXU4ICAgIHNzaWRbSElGX0FQSV9TU0lEX1NJWkVd
Ow0KIAl1MzIgICBiYXNpY19yYXRlX3NldDsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcv
d2Z4L2hpZl9hcGlfbWliLmggYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfbWliLmgNCmlu
ZGV4IDk0Yjc4OWNlYjRmZi4uMzRlNDMxMGFkNzFmIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zdGFn
aW5nL3dmeC9oaWZfYXBpX21pYi5oDQorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlf
bWliLmgNCkBAIC00NzEsOCArNDcxLDkgQEAgc3RydWN0IGhpZl9taWJfc2V0X2Fzc29jaWF0aW9u
X21vZGUgew0KIAl1OCAgICBtb2RlOjE7DQogCXU4ICAgIHJhdGVzZXQ6MTsNCiAJdTggICAgc3Bh
Y2luZzoxOw0KLQl1OCAgICByZXNlcnZlZDo0Ow0KLQl1OCAgICBwcmVhbWJsZV90eXBlOw0KKwl1
OCAgICByZXNlcnZlZDE6NDsNCisJdTggICAgc2hvcnRfcHJlYW1ibGU6MTsNCisJdTggICAgcmVz
ZXJ2ZWQyOjc7DQogCXU4ICAgIG1peGVkX29yX2dyZWVuZmllbGRfdHlwZTsNCiAJdTggICAgbXBk
dV9zdGFydF9zcGFjaW5nOw0KIAl1MzIgICBiYXNpY19yYXRlX3NldDsNCmRpZmYgLS1naXQgYS9k
cml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYw0KaW5k
ZXggMjNlYzdhNGE5MjZiLi5lNWM5MzM2NzhjNDcgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3N0YWdp
bmcvd2Z4L3N0YS5jDQorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jDQpAQCAtNjUyLDcg
KzY1Miw3IEBAIHN0YXRpYyB2b2lkIHdmeF9kb19qb2luKHN0cnVjdCB3ZnhfdmlmICp3dmlmKQ0K
IAlzdHJ1Y3QgY2ZnODAyMTFfYnNzICpic3MgPSBOVUxMOw0KIAlzdHJ1Y3QgaGlmX3JlcV9qb2lu
IGpvaW4gPSB7DQogCQkuaW5mcmFzdHJ1Y3R1cmVfYnNzX21vZGUgPSAhY29uZi0+aWJzc19qb2lu
ZWQsDQotCQkucHJlYW1ibGVfdHlwZSA9IGNvbmYtPnVzZV9zaG9ydF9wcmVhbWJsZSA/IEhJRl9Q
UkVBTUJMRV9TSE9SVCA6IEhJRl9QUkVBTUJMRV9MT05HLA0KKwkJLnNob3J0X3ByZWFtYmxlID0g
Y29uZi0+dXNlX3Nob3J0X3ByZWFtYmxlLA0KIAkJLnByb2JlX2Zvcl9qb2luID0gMSwNCiAJCS5h
dGltX3dpbmRvdyA9IDAsDQogCQkuYmFzaWNfcmF0ZV9zZXQgPSB3ZnhfcmF0ZV9tYXNrX3RvX2h3
KHd2aWYtPndkZXYsDQpAQCAtODQzLDcgKzg0Myw3IEBAIHN0YXRpYyBpbnQgd2Z4X3N0YXJ0X2Fw
KHN0cnVjdCB3ZnhfdmlmICp3dmlmKQ0KIAkJLmNoYW5uZWxfbnVtYmVyID0gd3ZpZi0+Y2hhbm5l
bC0+aHdfdmFsdWUsDQogCQkuYmVhY29uX2ludGVydmFsID0gY29uZi0+YmVhY29uX2ludCwNCiAJ
CS5kdGltX3BlcmlvZCA9IGNvbmYtPmR0aW1fcGVyaW9kLA0KLQkJLnByZWFtYmxlX3R5cGUgPSBj
b25mLT51c2Vfc2hvcnRfcHJlYW1ibGUgPyBISUZfUFJFQU1CTEVfU0hPUlQgOiBISUZfUFJFQU1C
TEVfTE9ORywNCisJCS5zaG9ydF9wcmVhbWJsZSA9IGNvbmYtPnVzZV9zaG9ydF9wcmVhbWJsZSwN
CiAJCS5iYXNpY19yYXRlX3NldCA9IHdmeF9yYXRlX21hc2tfdG9faHcod3ZpZi0+d2RldiwNCiAJ
CQkJCQkgICAgICBjb25mLT5iYXNpY19yYXRlcyksDQogCX07DQpAQCAtOTk0LDcgKzk5NCw3IEBA
IHN0YXRpYyB2b2lkIHdmeF9qb2luX2ZpbmFsaXplKHN0cnVjdCB3ZnhfdmlmICp3dmlmLA0KIAlh
c3NvY2lhdGlvbl9tb2RlLm1vZGUgPSAxOw0KIAlhc3NvY2lhdGlvbl9tb2RlLnJhdGVzZXQgPSAx
Ow0KIAlhc3NvY2lhdGlvbl9tb2RlLnNwYWNpbmcgPSAxOw0KLQlhc3NvY2lhdGlvbl9tb2RlLnBy
ZWFtYmxlX3R5cGUgPSBpbmZvLT51c2Vfc2hvcnRfcHJlYW1ibGUgPyBISUZfUFJFQU1CTEVfU0hP
UlQgOiBISUZfUFJFQU1CTEVfTE9ORzsNCisJYXNzb2NpYXRpb25fbW9kZS5zaG9ydF9wcmVhbWJs
ZSA9IGluZm8tPnVzZV9zaG9ydF9wcmVhbWJsZTsNCiAJYXNzb2NpYXRpb25fbW9kZS5iYXNpY19y
YXRlX3NldCA9IGNwdV90b19sZTMyKHdmeF9yYXRlX21hc2tfdG9faHcod3ZpZi0+d2RldiwgaW5m
by0+YmFzaWNfcmF0ZXMpKTsNCiAJYXNzb2NpYXRpb25fbW9kZS5taXhlZF9vcl9ncmVlbmZpZWxk
X3R5cGUgPSB3ZnhfaHRfZ3JlZW5maWVsZCgmd3ZpZi0+aHRfaW5mbyk7DQogCWFzc29jaWF0aW9u
X21vZGUubXBkdV9zdGFydF9zcGFjaW5nID0gd2Z4X2h0X2FtcGR1X2RlbnNpdHkoJnd2aWYtPmh0
X2luZm8pOw0KLS0gDQoyLjIwLjENCg==
