Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA8B8FB5B
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 08:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbfHPGrd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 02:47:33 -0400
Received: from mail-eopbgr00073.outbound.protection.outlook.com ([40.107.0.73]:24649
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725945AbfHPGrd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Aug 2019 02:47:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h/uVQgOmNY/9Y1o0+97MGvmbakH+sHHeePXnKYXSPXolXZADQjWcYFoS+H3YGlJv8Zcch1DAPdYDM1hfZMh5J2OjN52FAevBbicd50wXyYz4nfAggLrkl/sOfcZd5bUiG9p9DstxPReLnxLUXHb618mmVmyDnuJ9MfvLdNUe+BOfqFmP7QT/b/UkUhqUgueBVQEq8SNvsXHNsVKOj7wVmV2qV2QsD5a/2rCXxacpV5ptx4bljfAx17Y9K5TbolNLZ4/VFnC6Fh4WYI6z0ygIjdOV0YSx46VrQ6nzKanJFLqf2Y0TArgfOSwFFmtiavHACLD4LZLDpYFP4Ep29dU9eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g/kEHcTzK/cJxIpNAhB4jeMieH06umSElahvwRo70lU=;
 b=ecapmNoEGjnnozKyEW4fIbh1FKlMLL9OxClm2wslgF6gtuNitLOGMxB8DBwhoeQhuCK5OgRXV3kRfdErpJdiS7+8qTG8hUFIPhvsmb2WVlU4FYemgfxvZvRyq0YThuSVJkft9pFlMV2kZvwCGV1e4O7hok+cIkHcjk66sKnFJUHjQpYPJqUGVekA+mBX1af4INhNW7lMKQalP215hxOnwjMM2UkB2aXPSarvhYO5ngBojy6qQdZckuaTh0iVXW30tgF7IIae2tYMMimGKX7jv7gs6HhHUb0YJGrx9KhUitFg8UN6paM1sNpxd/oliUZoB9E+Yn4S1d1Lg39tnZVJ7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g/kEHcTzK/cJxIpNAhB4jeMieH06umSElahvwRo70lU=;
 b=haIf0+FvC960sJApJSMBumurB6X38zCupVgMt7vJZw+2gYMwjCZ2kdhCpAqKIvLvfFcnJktDwrzKjhnzl4twpI+mSUXg3d/X0FWkAJXgQOTfpBDkBj5s5MQJMqSfqfDGSVcUtcxr/Fj9LruXyntgBPwhi+zvDoG304JeWArIYYI=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB5353.eurprd04.prod.outlook.com (20.178.85.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Fri, 16 Aug 2019 06:47:29 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::c8ca:1c9c:6c3:fb6f]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::c8ca:1c9c:6c3:fb6f%4]) with mapi id 15.20.2157.022; Fri, 16 Aug 2019
 06:47:29 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     "wg@grandegger.com" <wg@grandegger.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: RE: [PATCH] can: flexcan: add LPSR mode support for i.MX7D
Thread-Topic: [PATCH] can: flexcan: add LPSR mode support for i.MX7D
Thread-Index: AQHVR2S0Rdpah0lS20a879tXPe4dwqb9bhaw
Date:   Fri, 16 Aug 2019 06:47:29 +0000
Message-ID: <DB7PR04MB46188FBD9DC87E620BBA8838E6AF0@DB7PR04MB4618.eurprd04.prod.outlook.com>
References: <20190731055401.15454-1-qiangqing.zhang@nxp.com>
In-Reply-To: <20190731055401.15454-1-qiangqing.zhang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 15556c37-e5ef-498f-361d-08d722159b87
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DB7PR04MB5353;
x-ms-traffictypediagnostic: DB7PR04MB5353:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB535385FB63AE1292F5359761E6AF0@DB7PR04MB5353.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0131D22242
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(136003)(346002)(366004)(396003)(13464003)(189003)(199004)(9686003)(229853002)(6436002)(4326008)(446003)(26005)(55016002)(53936002)(8676002)(81166006)(81156014)(6506007)(476003)(478600001)(5660300002)(53546011)(110136005)(54906003)(71190400001)(71200400001)(66066001)(99286004)(11346002)(14444005)(486006)(2906002)(25786009)(256004)(186003)(102836004)(76176011)(316002)(7696005)(3846002)(76116006)(6116002)(569044001)(66556008)(66446008)(66476007)(64756008)(66946007)(305945005)(2501003)(7736002)(74316002)(86362001)(33656002)(8936002)(6246003)(14454004)(52536014);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB5353;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: xpsoy3oKDRQiaRKgh0JKUx12+qarCu9pJxEznf1P6VcVwv62CXymSyLTGdU2kmBTQQjadnOId65Fx5qxTrO+ILHZrAlXvitWrp72K7iceBmQd6VRLV5tJZhUjjJR1jRwuk6QNZK1yeHXdrBIPM7Lnh623CwBrGEt092Z9WpUANQ8L/GeVf+TfWeIE86+s8I5/G0eqCZiGgu8f4g+aOnpzZcPHykJQtNAoxrbFmi+BBQoNYmpsDJ4Sf8RWbaD7T2TapWYJCNO68wiF4JEZGxmMJijFTJwifYuZ7Nm0ybOk7CkGZZEMH8ohVJdTNFu3evHovxTl4mXADy7Z4Hxmwmf0pR7ZCh/MYYPKS+UQY1T5cNozVzI7T12T2mRrhS5Vhs/CzYt/KIXjtZkndA248wxSj4r7VOuPqdAjnz8Mcf9/k8=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15556c37-e5ef-498f-361d-08d722159b87
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2019 06:47:29.4052
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: su64mv4VHB7d0HYDp9ZGku9xVdexjLZOqDgvJ1BEiyXG0RyaIXxobw66+Ev/3wBFQCkbPI7usa8Q+Yvrsxy18Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5353
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpLaW5kbHkgUGluZy4uLg0KDQpCZXN0IFJlZ2FyZHMsDQpKb2FraW0gWmhhbmcNCg0KPiAtLS0t
LU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKb2FraW0gWmhhbmcNCj4gU2VudDogMjAx
OcTqN9TCMzHI1SAxMzo1Nw0KPiBUbzogbWtsQHBlbmd1dHJvbml4LmRlOyBsaW51eC1jYW5Admdl
ci5rZXJuZWwub3JnDQo+IENjOiB3Z0BncmFuZGVnZ2VyLmNvbTsgbmV0ZGV2QHZnZXIua2VybmVs
Lm9yZzsgZGwtbGludXgtaW14DQo+IDxsaW51eC1pbXhAbnhwLmNvbT47IEpvYWtpbSBaaGFuZyA8
cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+DQo+IFN1YmplY3Q6IFtQQVRDSF0gY2FuOiBmbGV4Y2Fu
OiBhZGQgTFBTUiBtb2RlIHN1cHBvcnQgZm9yIGkuTVg3RA0KPiANCj4gRm9yIGkuTVg3RCBMUFNS
IG1vZGUsIHRoZSBjb250cm9sbGVyIHdpbGwgbG9zdCBwb3dlciBhbmQgZ290IHRoZSBjb25maWd1
cmF0aW9uDQo+IHN0YXRlIGxvc3QgYWZ0ZXIgc3lzdGVtIHJlc3VtZSBiYWNrLiAoY29taW5nIGku
TVg4UU0vUVhQIHdpbGwgYWxzbw0KPiBjb21wbGV0ZWx5IHBvd2VyIG9mZiB0aGUgZG9tYWluLCB0
aGUgY29udHJvbGxlciBzdGF0ZSB3aWxsIGJlIGxvc3QgYW5kIG5lZWRzDQo+IHJlc3RvcmUpLg0K
PiBTbyB3ZSBuZWVkIHRvIHNldCBwaW5jdHJsIHN0YXRlIGFnYWluIGFuZCByZS1zdGFydCBjaGlw
IHRvIGRvIHJlLWNvbmZpZ3VyYXRpb24NCj4gYWZ0ZXIgcmVzdW1lLg0KPiANCj4gRm9yIHdha2V1
cCBjYXNlLCBpdCBzaG91bGQgbm90IHNldCBwaW5jdHJsIHRvIHNsZWVwIHN0YXRlIGJ5DQo+IHBp
bmN0cmxfcG1fc2VsZWN0X3NsZWVwX3N0YXRlLg0KPiBGb3IgaW50ZXJmYWNlIGlzIG5vdCB1cCBi
ZWZvcmUgc3VzcGVuZCBjYXNlLCB3ZSBkb24ndCBuZWVkIHJlLWNvbmZpZ3VyZSBhcyBpdA0KPiB3
aWxsIGJlIGNvbmZpZ3VyZWQgYnkgdXNlciBsYXRlciBieSBpbnRlcmZhY2UgdXAuDQo+IA0KPiBT
aWduZWQtb2ZmLWJ5OiBKb2FraW0gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPg0KPiAt
LS0NCj4gIGRyaXZlcnMvbmV0L2Nhbi9mbGV4Y2FuLmMgfCAyMSArKysrKysrKysrKysrKy0tLS0t
LS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAxNCBpbnNlcnRpb25zKCspLCA3IGRlbGV0aW9ucygtKQ0K
PiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2Nhbi9mbGV4Y2FuLmMgYi9kcml2ZXJzL25l
dC9jYW4vZmxleGNhbi5jIGluZGV4DQo+IGMyMWIzNTA3MTIzZS4uMjI4ZDA3ZTg0ZGRjIDEwMDY0
NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9jYW4vZmxleGNhbi5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0
L2Nhbi9mbGV4Y2FuLmMNCj4gQEAgLTI2LDYgKzI2LDcgQEANCj4gICNpbmNsdWRlIDxsaW51eC9w
bGF0Zm9ybV9kZXZpY2UuaD4NCj4gICNpbmNsdWRlIDxsaW51eC9wbV9ydW50aW1lLmg+DQo+ICAj
aW5jbHVkZSA8bGludXgvcmVndWxhdG9yL2NvbnN1bWVyLmg+DQo+ICsjaW5jbHVkZSA8bGludXgv
cGluY3RybC9jb25zdW1lci5oPg0KPiAgI2luY2x1ZGUgPGxpbnV4L3JlZ21hcC5oPg0KPiANCj4g
ICNkZWZpbmUgRFJWX05BTUUJCQkiZmxleGNhbiINCj4gQEAgLTE4ODksNyArMTg5MCw3IEBAIHN0
YXRpYyBpbnQgX19tYXliZV91bnVzZWQgZmxleGNhbl9zdXNwZW5kKHN0cnVjdA0KPiBkZXZpY2Ug
KmRldmljZSkgIHsNCj4gIAlzdHJ1Y3QgbmV0X2RldmljZSAqZGV2ID0gZGV2X2dldF9kcnZkYXRh
KGRldmljZSk7DQo+ICAJc3RydWN0IGZsZXhjYW5fcHJpdiAqcHJpdiA9IG5ldGRldl9wcml2KGRl
dik7DQo+IC0JaW50IGVyciA9IDA7DQo+ICsJaW50IGVycjsNCj4gDQo+ICAJaWYgKG5ldGlmX3J1
bm5pbmcoZGV2KSkgew0KPiAgCQkvKiBpZiB3YWtldXAgaXMgZW5hYmxlZCwgZW50ZXIgc3RvcCBt
b2RlIEBAIC0xODk5LDI1ICsxOTAwLDI3DQo+IEBAIHN0YXRpYyBpbnQgX19tYXliZV91bnVzZWQg
ZmxleGNhbl9zdXNwZW5kKHN0cnVjdCBkZXZpY2UgKmRldmljZSkNCj4gIAkJCWVuYWJsZV9pcnFf
d2FrZShkZXYtPmlycSk7DQo+ICAJCQlmbGV4Y2FuX2VudGVyX3N0b3BfbW9kZShwcml2KTsNCj4g
IAkJfSBlbHNlIHsNCj4gLQkJCWVyciA9IGZsZXhjYW5fY2hpcF9kaXNhYmxlKHByaXYpOw0KPiAr
CQkJZmxleGNhbl9jaGlwX3N0b3AoZGV2KTsNCj4gKw0KPiArCQkJZXJyID0gcG1fcnVudGltZV9m
b3JjZV9zdXNwZW5kKGRldmljZSk7DQo+ICAJCQlpZiAoZXJyKQ0KPiAgCQkJCXJldHVybiBlcnI7
DQo+IA0KPiAtCQkJZXJyID0gcG1fcnVudGltZV9mb3JjZV9zdXNwZW5kKGRldmljZSk7DQo+ICsJ
CQlwaW5jdHJsX3BtX3NlbGVjdF9zbGVlcF9zdGF0ZShkZXZpY2UpOw0KPiAgCQl9DQo+ICAJCW5l
dGlmX3N0b3BfcXVldWUoZGV2KTsNCj4gIAkJbmV0aWZfZGV2aWNlX2RldGFjaChkZXYpOw0KPiAg
CX0NCj4gIAlwcml2LT5jYW4uc3RhdGUgPSBDQU5fU1RBVEVfU0xFRVBJTkc7DQo+IA0KPiAtCXJl
dHVybiBlcnI7DQo+ICsJcmV0dXJuIDA7DQo+ICB9DQo+IA0KPiAgc3RhdGljIGludCBfX21heWJl
X3VudXNlZCBmbGV4Y2FuX3Jlc3VtZShzdHJ1Y3QgZGV2aWNlICpkZXZpY2UpICB7DQo+ICAJc3Ry
dWN0IG5ldF9kZXZpY2UgKmRldiA9IGRldl9nZXRfZHJ2ZGF0YShkZXZpY2UpOw0KPiAgCXN0cnVj
dCBmbGV4Y2FuX3ByaXYgKnByaXYgPSBuZXRkZXZfcHJpdihkZXYpOw0KPiAtCWludCBlcnIgPSAw
Ow0KPiArCWludCBlcnI7DQo+IA0KPiAgCXByaXYtPmNhbi5zdGF0ZSA9IENBTl9TVEFURV9FUlJP
Ul9BQ1RJVkU7DQo+ICAJaWYgKG5ldGlmX3J1bm5pbmcoZGV2KSkgew0KPiBAQCAtMTkyNiwxNSAr
MTkyOSwxOSBAQCBzdGF0aWMgaW50IF9fbWF5YmVfdW51c2VkDQo+IGZsZXhjYW5fcmVzdW1lKHN0
cnVjdCBkZXZpY2UgKmRldmljZSkNCj4gIAkJaWYgKGRldmljZV9tYXlfd2FrZXVwKGRldmljZSkp
IHsNCj4gIAkJCWRpc2FibGVfaXJxX3dha2UoZGV2LT5pcnEpOw0KPiAgCQl9IGVsc2Ugew0KPiAr
CQkJcGluY3RybF9wbV9zZWxlY3RfZGVmYXVsdF9zdGF0ZShkZXZpY2UpOw0KPiArDQo+ICAJCQll
cnIgPSBwbV9ydW50aW1lX2ZvcmNlX3Jlc3VtZShkZXZpY2UpOw0KPiAgCQkJaWYgKGVycikNCj4g
IAkJCQlyZXR1cm4gZXJyOw0KPiANCj4gLQkJCWVyciA9IGZsZXhjYW5fY2hpcF9lbmFibGUocHJp
dik7DQo+ICsJCQllcnIgPSBmbGV4Y2FuX2NoaXBfc3RhcnQoZGV2KTsNCj4gKwkJCWlmIChlcnIp
DQo+ICsJCQkJcmV0dXJuIGVycjsNCj4gIAkJfQ0KPiAgCX0NCj4gDQo+IC0JcmV0dXJuIGVycjsN
Cj4gKwlyZXR1cm4gMDsNCj4gIH0NCj4gDQo+ICBzdGF0aWMgaW50IF9fbWF5YmVfdW51c2VkIGZs
ZXhjYW5fcnVudGltZV9zdXNwZW5kKHN0cnVjdCBkZXZpY2UgKmRldmljZSkNCj4gLS0NCj4gMi4x
Ny4xDQoNCg==
