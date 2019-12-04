Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 609531128B9
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 10:59:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727429AbfLDJ7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 04:59:03 -0500
Received: from mail-eopbgr10048.outbound.protection.outlook.com ([40.107.1.48]:29315
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726166AbfLDJ7C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Dec 2019 04:59:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mI8SKXbH2ticEmC/xiusUw9JXGB9URN1WMu9uYD9bKjNPo07ulcijUEq0wn3gc4vvjBbxxf3ra93ZVub7zAY8CsbVnQvz9I7/3fOu4yq0Rc6cLFN5vz1tw2Kb/l8nRBis+Tg4ELGOdkFAl51cYihlqJTUgZ0BM9DaVgmw/IbQx5iQ6QhXhFq+o3iNEqqH+msX0/ns5/GjRy7vo0vqc8Iq98S77nOMAQEzXUJh4siVeYbHfaTsz3pZfoFX765C7si/FL+Mpkuxvm7yvgTdbqWhmi5ateCpz78cWWIyaD2WIVxvwr8RwVi/xEkHWKIxwvDroMjHbz4weE2ZeyMw7YaJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jIBLxXuboO6frhL42S3EGDuXFeH5dKeolHVBm+tEork=;
 b=N6Tp+bW6PYNP35Jv/NiQ8VrI+kHGCSN3GwPbRXKz+0OA3DhzdO+8WWi0g3Hy9nzMYU+Rw6A9OeIX16M7um07CHi4rxmYFEBFwvJ1QAdUrX/0St26tlrp8iXUZzuh0BlNpJrTSCCf4MWznK1fbM2+yMZ3A7JT61l2BEm9wEVd1PDZjvwZKLdIRQ0ZegzNbVlVUGaBHQH+mSQrEG+iKkp9NEaUK8qGQ9/HT9EAkbWeJJlU9eKt4wSmhHUrXkRNI9kE1J/3osFYMVm5ikRzYcEiVGB/u+lBqTh3L+2aGbTWgebEjaYWdPzL5cVuJNSj2PjAwBpz9dg+JnoQ1LkKg3Y+zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jIBLxXuboO6frhL42S3EGDuXFeH5dKeolHVBm+tEork=;
 b=rVWe1rsg5L4VXn20FSPhOU9zPnSlq76bwn0i7r3JkSG5huqYBQyR1AsedzR3sSKe58sBUUHsw8OCVKZVQ0Enn8OlChvWC0rYEKyRUY7fkpz4ErB8KVBhB11yEpu5X5oVqhS8sBOkv3hhNgbnwlcSfzHxl0CmZTbxs0MCZIOAQk8=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB5036.eurprd04.prod.outlook.com (20.176.234.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.18; Wed, 4 Dec 2019 09:58:56 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6%4]) with mapi id 15.20.2516.003; Wed, 4 Dec 2019
 09:58:56 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "sean@geanix.com" <sean@geanix.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH V2 4/4] can: flexcan: add LPSR mode support
Thread-Topic: [PATCH V2 4/4] can: flexcan: add LPSR mode support
Thread-Index: AQHVpOd3D9txXS3dtUSMzmH9fMhQMaepuIyAgAAQWzA=
Date:   Wed, 4 Dec 2019 09:58:56 +0000
Message-ID: <DB7PR04MB4618D604D85599B1B7E76810E65D0@DB7PR04MB4618.eurprd04.prod.outlook.com>
References: <20191127055334.1476-1-qiangqing.zhang@nxp.com>
 <20191127055334.1476-5-qiangqing.zhang@nxp.com>
 <28bce2f5-8d49-d803-60c7-a8dec87a4fa6@pengutronix.de>
In-Reply-To: <28bce2f5-8d49-d803-60c7-a8dec87a4fa6@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 147d13c6-2fe4-4a98-74f5-08d778a093f4
x-ms-traffictypediagnostic: DB7PR04MB5036:|DB7PR04MB5036:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB5036A67AEC4BC18E8321D0F9E65D0@DB7PR04MB5036.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-forefront-prvs: 0241D5F98C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(376002)(396003)(366004)(136003)(199004)(189003)(54534003)(13464003)(76176011)(86362001)(66476007)(66556008)(99286004)(66446008)(7696005)(9686003)(305945005)(2201001)(55016002)(5660300002)(6306002)(14444005)(256004)(229853002)(25786009)(52536014)(7736002)(76116006)(64756008)(66946007)(6436002)(33656002)(4326008)(966005)(14454004)(478600001)(102836004)(2501003)(316002)(446003)(110136005)(6116002)(8936002)(11346002)(6506007)(3846002)(6246003)(81156014)(71190400001)(2906002)(74316002)(71200400001)(8676002)(81166006)(26005)(53546011)(186003)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB5036;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kiI81LPOG8p7XYkK68rzGukgnImiZa3a77DPEzUU5v6nc4s1KNE+Lg/htrKTTEvFfzlTVdTUK8UBywJtffaguQItLsbS/bkqe6edTvq81MjgIvFI/aFkVZ/VoZDvQTIqnhj9tP5hf2jm56GSECc9QMUVJGvbnuJql7iuaN2XDN3DYPdomby49MCzb1poN7pD6yePxLxcx4bFk/GyS4yGdvEXZ1kzc+Sg6yYcZyPt1DUvZZ1mcfnlzPG0QnvqCRxOd1duFO1EMPErsdsroFrB3lTlKREFr7GFd0BrkxLO+nl7DdlqQ4Mo6joJxCBCUPkQG04Z4O6Z0Z0rHzyAISElxddhgvHQgF1rE3ERP65vt84epbfRpd+C0gK9OjR2C3ymqY5wYIsHr17mAaTdp1b9+3wfmztFIFfZqeHTrbJk973hLe1x9hPoREeuNPtqUja/h8GNt7ZfDmwHkZma7cEJ42o/b06ttGdpkanRNk0V0jw3caaBLY3omk2o5biHr+VlboV951sTGSyYpEsgxvqG8jJDiYjsKNnQ1GYhmr1xoLe7VXRjFEuWdgSs6mP8i+lv
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 147d13c6-2fe4-4a98-74f5-08d778a093f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2019 09:58:56.5948
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Wve9p8le60gh8fBgbE7qO1knnFlM2ogGJkdjqaeD/qjqYIC2n4fbjh1PlLFlGQHmp1Nl0DIhXJJcp5/F00qsCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5036
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IE1hcmMgS2xlaW5lLUJ1ZGRl
IDxta2xAcGVuZ3V0cm9uaXguZGU+DQo+IFNlbnQ6IDIwMTnlubQxMuaciDTml6UgMTc6MDANCj4g
VG86IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+OyBzZWFuQGdlYW5peC5j
b207DQo+IGxpbnV4LWNhbkB2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IGRsLWxpbnV4LWlteCA8bGlu
dXgtaW14QG54cC5jb20+OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBb
UEFUQ0ggVjIgNC80XSBjYW46IGZsZXhjYW46IGFkZCBMUFNSIG1vZGUgc3VwcG9ydA0KPiANCj4g
T24gMTEvMjcvMTkgNjo1NiBBTSwgSm9ha2ltIFpoYW5nIHdyb3RlOg0KPiA+IEZvciBpLk1YN0Qg
TFBTUiBtb2RlLCB0aGUgY29udHJvbGxlciB3aWxsIGxvc3QgcG93ZXIgYW5kIGdvdCB0aGUNCj4g
PiBjb25maWd1cmF0aW9uIHN0YXRlIGxvc3QgYWZ0ZXIgc3lzdGVtIHJlc3VtZSBiYWNrLiAoY29t
aW5nIGkuTVg4UU0vUVhQDQo+ID4gd2lsbCBhbHNvIGNvbXBsZXRlbHkgcG93ZXIgb2ZmIHRoZSBk
b21haW4sIHRoZSBjb250cm9sbGVyIHN0YXRlIHdpbGwNCj4gPiBiZSBsb3N0IGFuZCBuZWVkcyBy
ZXN0b3JlKS4NCj4gPiBTbyB3ZSBuZWVkIHRvIHNldCBwaW5jdHJsIHN0YXRlIGFnYWluIGFuZCBy
ZS1zdGFydCBjaGlwIHRvIGRvDQo+ID4gcmUtY29uZmlndXJhdGlvbiBhZnRlciByZXN1bWUuDQo+
ID4NCj4gPiBGb3Igd2FrZXVwIGNhc2UsIGl0IHNob3VsZCBub3Qgc2V0IHBpbmN0cmwgdG8gc2xl
ZXAgc3RhdGUgYnkNCj4gPiBwaW5jdHJsX3BtX3NlbGVjdF9zbGVlcF9zdGF0ZS4NCj4gPiBGb3Ig
aW50ZXJmYWNlIGlzIG5vdCB1cCBiZWZvcmUgc3VzcGVuZCBjYXNlLCB3ZSBkb24ndCBuZWVkDQo+
ID4gcmUtY29uZmlndXJlIGFzIGl0IHdpbGwgYmUgY29uZmlndXJlZCBieSB1c2VyIGxhdGVyIGJ5
IGludGVyZmFjZSB1cC4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEpvYWtpbSBaaGFuZyA8cWlh
bmdxaW5nLnpoYW5nQG54cC5jb20+DQo+ID4gLS0tLS0tDQo+ID4gQ2hhbmdlTG9nOg0KPiA+IAlW
MS0+VjI6IG5vIGNoYW5nZS4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9uZXQvY2FuL2ZsZXhjYW4u
YyB8IDIxICsrKysrKysrKysrKysrLS0tLS0tLQ0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgMTQgaW5z
ZXJ0aW9ucygrKSwgNyBkZWxldGlvbnMoLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJz
L25ldC9jYW4vZmxleGNhbi5jIGIvZHJpdmVycy9uZXQvY2FuL2ZsZXhjYW4uYw0KPiA+IGluZGV4
IGQxNzgxNDZiM2RhNS4uZDE1MDljZmZkZDI0IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0
L2Nhbi9mbGV4Y2FuLmMNCj4gPiArKysgYi9kcml2ZXJzL25ldC9jYW4vZmxleGNhbi5jDQo+ID4g
QEAgLTI2LDYgKzI2LDcgQEANCj4gPiAgI2luY2x1ZGUgPGxpbnV4L3BsYXRmb3JtX2RldmljZS5o
Pg0KPiA+ICAjaW5jbHVkZSA8bGludXgvcG1fcnVudGltZS5oPg0KPiA+ICAjaW5jbHVkZSA8bGlu
dXgvcmVndWxhdG9yL2NvbnN1bWVyLmg+DQo+ID4gKyNpbmNsdWRlIDxsaW51eC9waW5jdHJsL2Nv
bnN1bWVyLmg+DQo+ID4gICNpbmNsdWRlIDxsaW51eC9yZWdtYXAuaD4NCj4gPg0KPiA+ICAjZGVm
aW5lIERSVl9OQU1FCQkJImZsZXhjYW4iDQo+ID4gQEAgLTE3MDcsNyArMTcwOCw3IEBAIHN0YXRp
YyBpbnQgX19tYXliZV91bnVzZWQNCj4gZmxleGNhbl9zdXNwZW5kKHN0cnVjdA0KPiA+IGRldmlj
ZSAqZGV2aWNlKSAgew0KPiA+ICAJc3RydWN0IG5ldF9kZXZpY2UgKmRldiA9IGRldl9nZXRfZHJ2
ZGF0YShkZXZpY2UpOw0KPiA+ICAJc3RydWN0IGZsZXhjYW5fcHJpdiAqcHJpdiA9IG5ldGRldl9w
cml2KGRldik7DQo+ID4gLQlpbnQgZXJyID0gMDsNCj4gPiArCWludCBlcnI7DQo+ID4NCj4gPiAg
CWlmIChuZXRpZl9ydW5uaW5nKGRldikpIHsNCj4gPiAgCQkvKiBpZiB3YWtldXAgaXMgZW5hYmxl
ZCwgZW50ZXIgc3RvcCBtb2RlIEBAIC0xNzE5LDI1ICsxNzIwLDI3DQo+IEBADQo+ID4gc3RhdGlj
IGludCBfX21heWJlX3VudXNlZCBmbGV4Y2FuX3N1c3BlbmQoc3RydWN0IGRldmljZSAqZGV2aWNl
KQ0KPiA+ICAJCQlpZiAoZXJyKQ0KPiA+ICAJCQkJcmV0dXJuIGVycjsNCj4gPiAgCQl9IGVsc2Ug
ew0KPiA+IC0JCQllcnIgPSBmbGV4Y2FuX2NoaXBfZGlzYWJsZShwcml2KTsNCj4gPiArCQkJZmxl
eGNhbl9jaGlwX3N0b3AoZGV2KTsNCj4gPiArDQo+ID4gKwkJCWVyciA9IHBtX3J1bnRpbWVfZm9y
Y2Vfc3VzcGVuZChkZXZpY2UpOw0KPiA+ICAJCQlpZiAoZXJyKQ0KPiA+ICAJCQkJcmV0dXJuIGVy
cjsNCj4gPg0KPiA+IC0JCQllcnIgPSBwbV9ydW50aW1lX2ZvcmNlX3N1c3BlbmQoZGV2aWNlKTsN
Cj4gPiArCQkJcGluY3RybF9wbV9zZWxlY3Rfc2xlZXBfc3RhdGUoZGV2aWNlKTsNCj4gDQo+IFBs
ZWFzZSBhZGQgZXJyb3IgaGFuZGxpbmcgZm9yIHBpbmN0cmxfcG1fc2VsZWN0X3NsZWVwX3N0YXRl
KCkuDQpHb3QgaXQuDQoNCj4gPiAgCQl9DQo+ID4gIAkJbmV0aWZfc3RvcF9xdWV1ZShkZXYpOw0K
PiA+ICAJCW5ldGlmX2RldmljZV9kZXRhY2goZGV2KTsNCj4gPiAgCX0NCj4gPiAgCXByaXYtPmNh
bi5zdGF0ZSA9IENBTl9TVEFURV9TTEVFUElORzsNCj4gPg0KPiA+IC0JcmV0dXJuIGVycjsNCj4g
PiArCXJldHVybiAwOw0KPiA+ICB9DQo+ID4NCj4gPiAgc3RhdGljIGludCBfX21heWJlX3VudXNl
ZCBmbGV4Y2FuX3Jlc3VtZShzdHJ1Y3QgZGV2aWNlICpkZXZpY2UpICB7DQo+ID4gIAlzdHJ1Y3Qg
bmV0X2RldmljZSAqZGV2ID0gZGV2X2dldF9kcnZkYXRhKGRldmljZSk7DQo+ID4gIAlzdHJ1Y3Qg
ZmxleGNhbl9wcml2ICpwcml2ID0gbmV0ZGV2X3ByaXYoZGV2KTsNCj4gPiAtCWludCBlcnIgPSAw
Ow0KPiA+ICsJaW50IGVycjsNCj4gPg0KPiA+ICAJcHJpdi0+Y2FuLnN0YXRlID0gQ0FOX1NUQVRF
X0VSUk9SX0FDVElWRTsNCj4gPiAgCWlmIChuZXRpZl9ydW5uaW5nKGRldikpIHsNCj4gPiBAQCAt
MTc0OSwxNSArMTc1MiwxOSBAQCBzdGF0aWMgaW50IF9fbWF5YmVfdW51c2VkDQo+IGZsZXhjYW5f
cmVzdW1lKHN0cnVjdCBkZXZpY2UgKmRldmljZSkNCj4gPiAgCQkJaWYgKGVycikNCj4gPiAgCQkJ
CXJldHVybiBlcnI7DQo+ID4gIAkJfSBlbHNlIHsNCj4gPiArCQkJcGluY3RybF9wbV9zZWxlY3Rf
ZGVmYXVsdF9zdGF0ZShkZXZpY2UpOw0KPiANCj4gc2FtZSBoZXJlDQpHb3QgaXQuDQoNCj4gPiAr
DQo+ID4gIAkJCWVyciA9IHBtX3J1bnRpbWVfZm9yY2VfcmVzdW1lKGRldmljZSk7DQo+ID4gIAkJ
CWlmIChlcnIpDQo+ID4gIAkJCQlyZXR1cm4gZXJyOw0KPiA+DQo+ID4gLQkJCWVyciA9IGZsZXhj
YW5fY2hpcF9lbmFibGUocHJpdik7DQo+ID4gKwkJCWVyciA9IGZsZXhjYW5fY2hpcF9zdGFydChk
ZXYpOw0KPiA+ICsJCQlpZiAoZXJyKQ0KPiA+ICsJCQkJcmV0dXJuIGVycjsNCj4gPiAgCQl9DQo+
ID4gIAl9DQo+ID4NCj4gPiAtCXJldHVybiBlcnI7DQo+ID4gKwlyZXR1cm4gMDsNCj4gPiAgfQ0K
PiA+DQo+ID4gIHN0YXRpYyBpbnQgX19tYXliZV91bnVzZWQgZmxleGNhbl9ydW50aW1lX3N1c3Bl
bmQoc3RydWN0IGRldmljZQ0KPiA+ICpkZXZpY2UpDQo+ID4NCg0KDQpCZXN0IFJlZ2FyZHMsDQpK
b2FraW0gWmhhbmcNCj4gTWFyYw0KPiANCj4gLS0NCj4gUGVuZ3V0cm9uaXggZS5LLiAgICAgICAg
ICAgICAgICAgfCBNYXJjIEtsZWluZS1CdWRkZSAgICAgICAgICAgfA0KPiBFbWJlZGRlZCBMaW51
eCAgICAgICAgICAgICAgICAgICB8IGh0dHBzOi8vd3d3LnBlbmd1dHJvbml4LmRlICB8DQo+IFZl
cnRyZXR1bmcgV2VzdC9Eb3J0bXVuZCAgICAgICAgIHwgUGhvbmU6ICs0OS0yMzEtMjgyNi05MjQg
ICAgIHwNCj4gQW10c2dlcmljaHQgSGlsZGVzaGVpbSwgSFJBIDI2ODYgfCBGYXg6ICAgKzQ5LTUx
MjEtMjA2OTE3LTU1NTUgfA0KDQo=
