Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05B2A199A6
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 10:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727367AbfEJIYO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 04:24:14 -0400
Received: from mail-eopbgr10057.outbound.protection.outlook.com ([40.107.1.57]:25819
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727156AbfEJIYN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 May 2019 04:24:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OQddC6LdF+ln5q73ivv7ybpsgzLAOLU8565qqlkd+DQ=;
 b=i/LCvEvMnHzT7DXKQhOBV2Heg9rHxPCFRbE+GcqutX704emhFqdGAkfUmvLC9U49Lq55/c9+PERXsJfOehbypTQxxf+YtkhsubR5vpK+vyXETlXlreTYeyg8kW72IfelieaWOzBbKjaaW3G3OliPwVUGb1bZ5N6oT1a9gormQd8=
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com (52.134.5.23) by
 VI1PR0402MB2815.eurprd04.prod.outlook.com (10.172.255.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.22; Fri, 10 May 2019 08:24:06 +0000
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::9889:fa82:4172:14df]) by VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::9889:fa82:4172:14df%6]) with mapi id 15.20.1878.022; Fri, 10 May 2019
 08:24:06 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ynezz@true.cz" <ynezz@true.cz>,
        "john@phrozen.org" <john@phrozen.org>,
        "bgolaszewski@baylibre.com" <bgolaszewski@baylibre.com>,
        Andy Duan <fugang.duan@nxp.com>
Subject: [PATCH net 3/3] dt-bindings: doc: add new properties for
 of_get_mac_address from nvmem
Thread-Topic: [PATCH net 3/3] dt-bindings: doc: add new properties for
 of_get_mac_address from nvmem
Thread-Index: AQHVBwm7Z3/Q/s5Ic0ut6ydV531w8A==
Date:   Fri, 10 May 2019 08:24:06 +0000
Message-ID: <1557476567-17397-4-git-send-email-fugang.duan@nxp.com>
References: <1557476567-17397-1-git-send-email-fugang.duan@nxp.com>
In-Reply-To: <1557476567-17397-1-git-send-email-fugang.duan@nxp.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.7.4
x-clientproxiedby: HK2PR02CA0212.apcprd02.prod.outlook.com
 (2603:1096:201:20::24) To VI1PR0402MB3600.eurprd04.prod.outlook.com
 (2603:10a6:803:a::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e1b87802-e8e0-464c-11b0-08d6d520de13
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB2815;
x-ms-traffictypediagnostic: VI1PR0402MB2815:
x-microsoft-antispam-prvs: <VI1PR0402MB28155D8887EFAF3720691AA9FF0C0@VI1PR0402MB2815.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0033AAD26D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(136003)(396003)(366004)(39860400002)(189003)(199004)(11346002)(486006)(26005)(6436002)(305945005)(2616005)(6116002)(3846002)(68736007)(316002)(7736002)(386003)(6506007)(6486002)(102836004)(446003)(186003)(2906002)(6916009)(50226002)(54906003)(1730700003)(66066001)(66556008)(36756003)(8676002)(66946007)(66476007)(64756008)(76176011)(2351001)(81156014)(476003)(5660300002)(73956011)(86362001)(66446008)(81166006)(14454004)(478600001)(8936002)(25786009)(5640700003)(256004)(14444005)(6512007)(52116002)(71190400001)(71200400001)(2501003)(53936002)(4326008)(99286004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2815;H:VI1PR0402MB3600.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: aovYeSPQ1tlF+2wAt1xkFNHOCCQ3nqGg0OzvJzxn7T9wg7uqmwmkbTjf1cjWD9y/30Y7zJkEz+jkVka+75Fz0SgmCBQFL4ianGKoMz3beJKOuVTavHTTiLFrpB0x3dMyPru+JPHx/nTqBG23Uq+7rAF11i0IAtYs0QV3c7FO+niviwfe3k1bjPxJrtRWg8r2BB7G2J42OUvezB+Yv1XdjYZRd66HCjdog6ErYG618tBCWS1lpbClHOb/ssxazk5mvqY525Mbpve+EuY9/RYXVUcWTjPpYQTHeIlRTb3xQDccWBQgaW1t7BCc9YFQwbsK16SPqPFl87ACwHM5YVaIvu/oPWz+nGZ7Qlr+gQPGcNR2g/HYLmLLWL47/aCoSbQ8P9LQfxAt85syhXZXRA9/4w9VtaiFNTqsO7TkQ8t/MwY=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1b87802-e8e0-464c-11b0-08d6d520de13
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2019 08:24:06.4067
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2815
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Q3VycmVudGx5LCBvZl9nZXRfbWFjX2FkZHJlc3Mgc3VwcG9ydHMgTlZNRU0sIHNvbWUgcGxhdGZv
cm1zDQpNQUMgYWRkcmVzcyB0aGF0IHJlYWQgZnJvbSBOVk1FTSBlZnVzZSByZXF1aXJlcyB0byBz
d2FwIGJ5dGVzDQpvcmRlciwgc28gYWRkIG5ldyBwcm9wZXJ0eSAibnZtZW1fbWFjYWRkcl9zd2Fw
IiB0byBzcGVjaWZ5IHRoZQ0KYmVoYXZpb3IuIElmIHRoZSBNQUMgYWRkcmVzcyBpcyB2YWxpZCBm
cm9tIE5WTUVNLCBhZGQgbmV3IHByb3BlcnR5DQoibnZtZW0tbWFjLWFkZHJlc3MiIGluIGV0aGVy
bmV0IG5vZGUuDQoNClVwZGF0ZSB0aGVzZSB0d28gcHJvcGVydGllcyBpbiB0aGUgYmluZGluZyBk
b2N1bWVudGF0aW9uLg0KDQpTaWduZWQtb2ZmLWJ5OiBGdWdhbmcgRHVhbiA8ZnVnYW5nLmR1YW5A
bnhwLmNvbT4NCi0tLQ0KIERvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvZXRo
ZXJuZXQudHh0IHwgMyArKysNCiAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspDQoNCmRp
ZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L2V0aGVybmV0
LnR4dCBiL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvZXRoZXJuZXQudHh0
DQppbmRleCBlODhjMzY0Li45MjEzNjRhIDEwMDY0NA0KLS0tIGEvRG9jdW1lbnRhdGlvbi9kZXZp
Y2V0cmVlL2JpbmRpbmdzL25ldC9ldGhlcm5ldC50eHQNCisrKyBiL0RvY3VtZW50YXRpb24vZGV2
aWNldHJlZS9iaW5kaW5ncy9uZXQvZXRoZXJuZXQudHh0DQpAQCAtMTAsOCArMTAsMTEgQEAgRG9j
dW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL3BoeS9waHktYmluZGluZ3MudHh0Lg0KICAg
cHJvcGVydHk7DQogLSBsb2NhbC1tYWMtYWRkcmVzczogYXJyYXkgb2YgNiBieXRlcywgc3BlY2lm
aWVzIHRoZSBNQUMgYWRkcmVzcyB0aGF0IHdhcw0KICAgYXNzaWduZWQgdG8gdGhlIG5ldHdvcmsg
ZGV2aWNlOw0KKy0gbnZtZW0tbWFjLWFkZHJlc3M6IGFycmF5IG9mIDYgYnl0ZXMsIHNwZWNpZmll
cyB0aGUgTUFDIGFkZHJlc3MgdGhhdCB3YXMNCisgIHJlYWQgZnJvbSBudm1lbS1jZWxscyBhbmQg
ZHluYW1pY2FsbHkgYWRkIHRoZSBwcm9wZXJ0eSBpbiBkZXZpY2Ugbm9kZTsNCiAtIG52bWVtLWNl
bGxzOiBwaGFuZGxlLCByZWZlcmVuY2UgdG8gYW4gbnZtZW0gbm9kZSBmb3IgdGhlIE1BQyBhZGRy
ZXNzDQogLSBudm1lbS1jZWxsLW5hbWVzOiBzdHJpbmcsIHNob3VsZCBiZSAibWFjLWFkZHJlc3Mi
IGlmIG52bWVtIGlzIHRvIGJlIHVzZWQNCistIG52bWVtX21hY2FkZHJfc3dhcDogc3dhcCBieXRl
cyBvcmRlciBmb3IgdGhlIDYgYnl0ZXMgb2YgTUFDIGFkZHJlc3MNCiAtIG1heC1zcGVlZDogbnVt
YmVyLCBzcGVjaWZpZXMgbWF4aW11bSBzcGVlZCBpbiBNYml0L3Mgc3VwcG9ydGVkIGJ5IHRoZSBk
ZXZpY2U7DQogLSBtYXgtZnJhbWUtc2l6ZTogbnVtYmVyLCBtYXhpbXVtIHRyYW5zZmVyIHVuaXQg
KElFRUUgZGVmaW5lZCBNVFUpLCByYXRoZXIgdGhhbg0KICAgdGhlIG1heGltdW0gZnJhbWUgc2l6
ZSAodGhlcmUncyBjb250cmFkaWN0aW9uIGluIHRoZSBEZXZpY2V0cmVlDQotLSANCjIuNy40DQoN
Cg==
