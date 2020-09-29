Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2B5E27CBE5
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 14:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732252AbgI2Mam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 08:30:42 -0400
Received: from mail-vi1eur05on2053.outbound.protection.outlook.com ([40.107.21.53]:41024
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728639AbgI2L30 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 07:29:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Syb8MSv8WbJtN6Zca0nompmdmGS96OPo9xm4e31VVX/8cQOlUzefMswXCUb8Xv1AjMRfaNbmvz28Xmsc2Q+BcjqT684QdqxB4MG7FIuJ11vvAJ7FQIsKhSYAKU6aP8uCK4R/gasvL53ECsWMV2BtVehlvPeqrBg4ZOiCR/RayoyW5j+XeNjvZN5Tk+ZAQC78QjonNSZsMKBJMWkdVV1PbihIw1dfVnrQ7GYO4qJIcshpR1UlE6bztKEiW5PzCeMt/VqMa+POoO5w6EumetK6lo/0ino9CEQ1/i3TOrM71BZ62YTpNkpZmbvJwJGu3GylxbKGpXGtZhPXSRlPjgVoWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EP5jy3zzmCbNl5i03vJbi6DS6CKvhKiVPD1sJCXZKUA=;
 b=CymMjjfVRtLk6tzZeDnPQhKBUYqlRnwb/YOlTyWq0qH5DaWkBppO7Q7yTkcEEeBKbM9pAzguvUu05OmGCfgyOMssUw7BV++en18y4MrVJ5JHSULyZgRBb5FMsnUb9e8Mlz5AbvgF+nTLmwvVqT96c14QJBkrKZzHRmp7Mba2KW/NkBu+aNncjdil+8LYEk7QNii3fctuGx+fCrwR6DLd6/9zm896VQXhRWPqe1IefkCxems0V/GVNGFLFi1l5kaWGLQRMUlkWazP7d93GahAP96Og1CUtdqbThVLk1giM+f4NKE2jctUpV0HHvVcFIMYfC/5vkWbbsrQHj/P5L6UNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EP5jy3zzmCbNl5i03vJbi6DS6CKvhKiVPD1sJCXZKUA=;
 b=J05qPpAz2gzQ4WmUTjoHODpS2086nxLm8VmxaXaj5JQRw2x4tWh3bwx2KEL9fMuxpl+tOQa8u8g3UHWOv3vxyAqhGtMEp+N019JZdBqalDQSsAVuYVNx0U69Mh22vjS3kQFCXueD/KM37chcnf2lPlvlD+HEMBsn3FfVSwr1oro=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB6971.eurprd04.prod.outlook.com (2603:10a6:10:113::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32; Tue, 29 Sep
 2020 11:27:32 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68%8]) with mapi id 15.20.3412.029; Tue, 29 Sep 2020
 11:27:32 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: RE: [PATCH V3 1/3] can: flexcan: initialize all flexcan memory for
 ECC function
Thread-Topic: [PATCH V3 1/3] can: flexcan: initialize all flexcan memory for
 ECC function
Thread-Index: AQHWlX6LIgjQf3dNuUOzXhPgMCIyi6l/cq0AgAADNeA=
Date:   Tue, 29 Sep 2020 11:27:32 +0000
Message-ID: <DB8PR04MB6795C370AFF065F239935F9FE6320@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20200928180253.1454-1-qiangqing.zhang@nxp.com>
 <20200928180253.1454-2-qiangqing.zhang@nxp.com>
 <32c4ab0a-2e16-5cf2-5c26-7917d91f3429@pengutronix.de>
In-Reply-To: <32c4ab0a-2e16-5cf2-5c26-7917d91f3429@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e77632fd-0dd7-4fa2-90c4-08d8646aa862
x-ms-traffictypediagnostic: DB8PR04MB6971:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB697183050C9D8B5FBB68002AE6320@DB8PR04MB6971.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gfHz7xbdOeba+16mq/hz1VA1yZbs+E/FLm4upGA5K7dIUM/uk0VAAZiJv/a1EwOZOumVT+ZIypT1h/boyIcLOf56M/RKT0eiyaM4jM1/szDcvexWLZNqiaGuh/z2+HfZwdWgP1g24PZwB8Ef0F47WD80r55wAJnRueHpfl1KSiYhn+li1VgOd24YJiUxMGbEAG484FPsiGItZn2hsaPj18qaRRmA7Zsx6q0WTqXHUew4gODw3HHF4PL/Kdlu67AdwRaUZN4CaxB/09nTwvPv6ZqqF7jEYCdBIfF7/Zc6XX4KucdnyY7DuZLQfKtCy3ntMM0qf9Ccgd7r3828bR51nTEPJlauwa86CQWtssTzm5H8O3jPHqsLcMGS5GAQB7nc2ce78C48d5bazsi+X4AI6A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(9686003)(2906002)(83080400001)(55016002)(8936002)(83380400001)(76116006)(498600001)(8676002)(54906003)(966005)(86362001)(110136005)(5660300002)(7696005)(6506007)(52536014)(53546011)(26005)(186003)(64756008)(33656002)(66946007)(66446008)(66556008)(66476007)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: SbjXF4M7SSUf+VX9qRPigH77eBsQZnp++McFeuHWu9KzcHZZlU7lgZZtFQYWwDZMXVZAR0gJzCro65y4qS57ggJwFNC+rYbnJMmuX/ABVZQ7J2kPrXcz/YrcMzHTcOPXhSjrk+UptbS8GJfoA/tPwqo+vLDfcI8LHwI/c6loYD5Uh8vo8O+dIwYMY2hJ4RCCxs1/XBMBWsV/gAZzTuA0CwSfY5rKJigH/VxHccdim+7UV0wiEzsuY8J2eG9vPt+KoYbcdRAcVJgLNOZ42NnEDbt1AUBkAtiJD/XOFat0HJg3NY7rHwv/giZYP5Frob4rWKh7gCY47Cx+g1rVHbD4j3xjOAf55JngHvjY+F9VUAxECrW0iOXy80uKiiwsXSYVznNZ8nJugNZI+CXjMzRo18NGFSpQEf0TdHiJnlrKZZt3dLX9u+4AW0FYZOG/spAWDhH0fNqwa6nkkQyFrXNwNQn8bjOxyan9fPM8Yc3aA52eVvPK/WklHjygNl3IcTwtReo1Vv7CTgv7UAYnP22tsppsTx7hRgXAWuWLB+Hm0aZ/lAsZm/Gbk0tq0aS70ZMiYr0MFfTZYQ4vl+q+D14bRRSjT1/bRglgW5dzhfJIX6RJT6Mx3CUxOXuKdxoFV6Emea+ycZSRFkcdOjngiyzZPA==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e77632fd-0dd7-4fa2-90c4-08d8646aa862
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2020 11:27:32.7019
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9/5sfEThFqAgY7HjmKKAGVNdygn3iS00K809yD5PTAqPQ/50CXSrDv3zuQJcFwpkHBlvr7gvHlJdpFKG9uyc6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6971
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IE1hcmMgS2xlaW5lLUJ1ZGRl
IDxta2xAcGVuZ3V0cm9uaXguZGU+DQo+IFNlbnQ6IDIwMjDlubQ55pyIMjnml6UgMTg6NTQNCj4g
VG86IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+OyBsaW51eC1jYW5Admdl
ci5rZXJuZWwub3JnDQo+IENjOiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBkbC1saW51eC1pbXgg
PGxpbnV4LWlteEBueHAuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIFYzIDEvM10gY2FuOiBm
bGV4Y2FuOiBpbml0aWFsaXplIGFsbCBmbGV4Y2FuIG1lbW9yeSBmb3IgRUNDDQo+IGZ1bmN0aW9u
DQoNClsuLi5dDQo+ID4gKwlyZWdfY3RybDIgPSBwcml2LT5yZWFkKCZyZWdzLT5jdHJsMik7DQo+
ID4gKwlyZWdfY3RybDIgfD0gRkxFWENBTl9DVFJMMl9XUk1GUlo7DQo+ID4gKwlwcml2LT53cml0
ZShyZWdfY3RybDIsICZyZWdzLT5jdHJsMik7DQo+ID4gKw0KPiA+ICsJLyogcmFuZ2luZyBmcm9t
IDB4MDA4MCB0byAweDBBREYsIHJhbSBkZXRhaWxzIGFzIGJlbG93IGxpc3Q6DQo+ID4gKwkgKiAw
eDAwODAtLTB4MDg3RjoJMTI4IE1Ccw0KPiA+ICsJICogMHgwODgwLS0weDBBN0Y6CTEyOCBSWElN
UnMNCj4gPiArCSAqIDB4MEE4MC0tMHgwQTk3Ogk2IFJYRklScw0KPiA+ICsJICogMHgwQTk4LS0w
eDBBOUY6CVJlc2VydmVkDQo+ID4gKwkgKiAweDBBQTAtLTB4MEFBMzoJUlhNR01BU0sNCj4gPiAr
CSAqIDB4MEFBNC0tMHgwQUE3OglSWEZHTUFTSw0KPiA+ICsJICogMHgwQUE4LS0weDBBQUI6CVJY
MTRNQVNLDQo+ID4gKwkgKiAweDBBQUMtLTB4MEFBRjoJUlgxNU1BU0sNCj4gPiArCSAqIDB4MEFC
MC0tMHgwQUJGOglUWF9TTUINCj4gPiArCSAqIDB4MEFDMC0tMHgwQUNGOglSWF9TTUIwDQo+ID4g
KwkgKiAweDBBRDAtLTB4MEFERjoJUlhfU01CMQ0KPiANCj4gSSBkb24ndCBsaWtlIHRvIGhhdmUg
dGhlIHJlZ2lzdGVyIGRlZmluaXRpb24gaGVyZSAqYWdhaW4pLCB3ZSBoYXZlIHN0cnVjdA0KPiBm
bGV4Y2FuX3JlZ3MgZm9yIHRoaXMuDQoNCkRvIHlvdSBtZWFuIHN0aWxsIG1vdmUgdGhlc2UgcmVn
aXN0ZXIgZGVmaW5pdGlvbnMgaW50byBmbGV4Y2FuX3JlZ3MsIHJpZ2h0Pw0KDQo+ID4gKwkgKi8N
Cj4gPiArCW1lbXNldF9pbygodm9pZCBfX2lvbWVtICopcmVncyArIDB4ODAsIDAsIDB4YWRmIC0g
MHg4MCArIDEpOw0KPiANCj4gd2h5IHRoZSBjYXN0Pw0KDQpZZXMsIG5vIG5lZWQsIHdpbGwgcmVt
b3ZlIGl0Lg0KDQo+IENhbiB5b3UgdXNlIHRoZSAiJnJlZ3MtPmZvbyAtICZyZWdzLT5iYXIgKyB4
IiB0byBnZXQgdGhlIGxlbmd0aCBmb3IgdGhlDQo+IG1lbXNldD8NCg0KQWZ0ZXIgbW92ZSBhYm92
ZSByZWdpc3RlciBkZWZpbml0aW9uIGludG8gZmxleGNhbl9yZWdzLCBJIGNhbiBjaGFuZ2UgdG8g
dXNlIHRoaXMgd2F5IHRvIGdldCB0aGUgbGVuZ3RoIGZvciB0aGUgbWVtc2V0X2lvLg0KDQoNCj4g
PiArDQo+ID4gKwkvKiByYW5naW5nIGZyb20gMHgwRjI4IHRvIDB4MEZGRiB3aGVuIENBTiBGRCBm
ZWF0dXJlIGlzIGVuYWJsZWQsDQo+ID4gKwkgKiByYW0gZGV0YWlscyBhcyBiZWxvdyBsaXN0Og0K
PiA+ICsJICogMHgwRjI4LS0weDBGNkY6CVRYX1NNQl9GRA0KPiA+ICsJICogMHgwRjcwLS0weDBG
Qjc6CVJYX1NNQjBfRkQNCj4gPiArCSAqIDB4MEZCOC0tMHgwRkZGOglSWF9TTUIwX0ZEDQo+ID4g
KwkgKi8NCj4gPiArCW1lbXNldF9pbygodm9pZCBfX2lvbWVtICopcmVncyArIDB4ZjI4LCAwLCAw
eGZmZiAtIDB4ZjI4ICsgMSk7DQo+IA0KPiBzYW1lIGhlcmUNCg0KV2lsbCBjaGFuZ2UuDQoNCkhp
IE1hcmMsIEknbSBnb2luZyBvbiBob2xpZGF5IGZyb20gdG9tb3Jyb3csIHNvIEkgd291bGQgZGVs
YXkgdG8gc2VuZCBvdXQgYSBWNCB0byByZXZpZXcgdW50aWwgSSBjb21lIGJhY2ssIHNvcnJ5IGZv
ciB0aGlzLg0KVGhhbmtzIGZvciB5b3VyIGNvbW1lbnRzIG9mICJjYW46IGZsZXhjYW46IGFkZCBD
QU4gd2FrZXVwIGZ1bmN0aW9uIGZvciBpLk1YOCIsIHdpbGwgcmV3b3JrIHRoZSBwYXRjaCBsYXRl
ci4NCiANCkJlc3QgUmVnYXJkcywNCkpvYWtpbSBaaGFuZw0KPiA+ICsNCj4gPiArCXJlZ19jdHJs
MiAmPSB+RkxFWENBTl9DVFJMMl9XUk1GUlo7DQo+ID4gKwlwcml2LT53cml0ZShyZWdfY3RybDIs
ICZyZWdzLT5jdHJsMik7IH0NCj4gPiArDQo+ID4gIC8qIGZsZXhjYW5fY2hpcF9zdGFydA0KPiA+
ICAgKg0KPiA+ICAgKiB0aGlzIGZ1bmN0aW9ucyBpcyBlbnRlcmVkIHdpdGggY2xvY2tzIGVuYWJs
ZWQgQEAgLTEzMTYsNiArMTM2Myw5DQo+ID4gQEAgc3RhdGljIGludCBmbGV4Y2FuX2NoaXBfc3Rh
cnQoc3RydWN0IG5ldF9kZXZpY2UgKmRldikNCj4gPiAgCWlmIChlcnIpDQo+ID4gIAkJZ290byBv
dXRfY2hpcF9kaXNhYmxlOw0KPiA+DQo+ID4gKwlpZiAocHJpdi0+ZGV2dHlwZV9kYXRhLT5xdWly
a3MgJiBGTEVYQ0FOX1FVSVJLX1NVUFBPUlRfRUNDKQ0KPiA+ICsJCWZsZXhjYW5faW5pdF9yYW0o
ZGV2KTsNCj4gPiArDQo+ID4gIAlmbGV4Y2FuX3NldF9iaXR0aW1pbmcoZGV2KTsNCj4gPg0KPiA+
ICAJLyogTUNSDQo+ID4NCj4gDQo+IE1hcmMNCj4gDQo+IC0tDQo+IFBlbmd1dHJvbml4IGUuSy4g
ICAgICAgICAgICAgICAgIHwgTWFyYyBLbGVpbmUtQnVkZGUgICAgICAgICAgIHwNCj4gRW1iZWRk
ZWQgTGludXggICAgICAgICAgICAgICAgICAgfCBodHRwczovL3d3dy5wZW5ndXRyb25peC5kZSAg
fA0KPiBWZXJ0cmV0dW5nIFdlc3QvRG9ydG11bmQgICAgICAgICB8IFBob25lOiArNDktMjMxLTI4
MjYtOTI0ICAgICB8DQo+IEFtdHNnZXJpY2h0IEhpbGRlc2hlaW0sIEhSQSAyNjg2IHwgRmF4OiAg
ICs0OS01MTIxLTIwNjkxNy01NTU1IHwNCg0K
