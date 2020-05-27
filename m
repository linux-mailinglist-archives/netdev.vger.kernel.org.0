Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CCBD1E470C
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 17:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389508AbgE0PKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 11:10:21 -0400
Received: from mail-eopbgr140074.outbound.protection.outlook.com ([40.107.14.74]:51778
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388922AbgE0PKU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 11:10:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BVgs67qoZGzhpvuR21Y93xw+AiHcmSDJMq+OCetXj9MZYcc/lC5W2zBmOBX7fQxQHade5PyYNUEvApGd2zLUh4cmOP2pozWpAWAjKmEdcSnS3E6Iqbq1sWUkW6g3zwoSiPtQNsJ/uMMwt4M58XL8IWNwzlCVzmSVg/L/rE4eLoGEWzLqfCPr26PASzJv8Ez/laz3ypguJCmaDmKgwbIKNAJN6UaEp9U0q2U3SsR1SIpSryFKv+qaqf4B7apqQCU8JDAMqOs1Sm8qxV6OIYXoZz9UmNddPRtRTQnLKFC7qSwptDBd+fMBDTkS6d0qcT7sMpksauV1KobLCyleb3NPzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+H4wp9MBDvPR1L7GVL6KlaQVCaPIWQxZQ6RuVpa6+zg=;
 b=LteT9OkMXEFiSZkQ2duW/q9Tc+wZoQFbW3iS23rM97X8l3w1IWsqD2fdzp61L2BFFkyuQD/F/hm+znYyBLWkptDs525j5DuGijQ65CQqOWfBhfPIqPeIDoRNSCEMyipodtBJsGxGXSHc2ifugJjbRzt4qF1TytH8D2bp6sWgo+ftM6anu3/WTHhtRaJV3ZSuOGsvyXUSrjlbn/nZHsLhmj4PY5+lpNFBkGUzEbBehOlmXhpXo84KLzn78bvx9mr6vgGEEeQvFmDf7cUyoNHxEEZfu/I5hqsCFxC8geOm8r0naraGKS41wljLpaGRwSSAVzsUdhngst31lE8yR/aUiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+H4wp9MBDvPR1L7GVL6KlaQVCaPIWQxZQ6RuVpa6+zg=;
 b=GEPKVryaPZBCwJTpSsWPTeJ2MSC3yGZJW96eJtQAWhsp86tk/opCNrPzzwqzWomSesZKooJrdvzC1N3Q7rcsLhfrajulW4Lu/QYFMnSh1dT664IIVACRCuO2qdu6sT80Sfjd4t2KWdlGBP/b4eBH2M+CdHZuYy326qL/EOzgeWU=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6623.eurprd05.prod.outlook.com (2603:10a6:803:df::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17; Wed, 27 May
 2020 15:10:15 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.029; Wed, 27 May 2020
 15:10:15 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "decui@microsoft.com" <decui@microsoft.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     Mark Bloch <markb@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Moshe Shemesh <moshe@mellanox.com>
Subject: Re: [net-next 12/16] net/mlx5: Add basic suspend/resume support
Thread-Topic: [net-next 12/16] net/mlx5: Add basic suspend/resume support
Thread-Index: AQHWM8kuvaRMchA0k0+wLCOmJkNWUqi7i4uAgAB+uYA=
Date:   Wed, 27 May 2020 15:10:15 +0000
Message-ID: <a7118c40f4053d05bcea4117994b0768cc44fb67.camel@mellanox.com>
References: <20200527014924.278327-1-saeedm@mellanox.com>
         <20200527014924.278327-13-saeedm@mellanox.com>
         <HK0P153MB011343BFB6F88FD5AC34F6B9BFB10@HK0P153MB0113.APCP153.PROD.OUTLOOK.COM>
In-Reply-To: <HK0P153MB011343BFB6F88FD5AC34F6B9BFB10@HK0P153MB0113.APCP153.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.2 (3.36.2-1.fc32) 
authentication-results: microsoft.com; dkim=none (message not signed)
 header.d=none;microsoft.com; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8c21c076-160c-4a80-7066-08d802500fbf
x-ms-traffictypediagnostic: VI1PR05MB6623:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6623F6E96A19B236328A7E06BEB10@VI1PR05MB6623.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 04163EF38A
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GNEaNDHc1wWX/RMGUuj3HWJ67QAco/JlbFo9Z2RCmk2o+9YFLWJIgxDXpJPsq/ACz6+iIlUpnAMLmmW1klw+uNy1IpB46sZ9dOOwNc5OwOyoncHnki2Nc1IauQOJnm2SmJ1fXwnMCypbBUyLgL0TtBhh9ZicZ1uSEffH34tkknuRWw3oKvskeSt4cEKSyYZZnrqhmW+fN0rB8BClkmG4bqG7FGi0psT+HBW8LyAutJLLqdKJCBg8u9hu0vg42M577FniVtRZEsd1Ze+BhBSSP+Apa68Txcb33j5bzYQkbfwkgRifUc5LTheN3L0wOh8D
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(366004)(376002)(39860400002)(346002)(4326008)(8936002)(86362001)(6486002)(83380400001)(2906002)(316002)(478600001)(54906003)(15650500001)(91956017)(76116006)(36756003)(6506007)(53546011)(66946007)(107886003)(26005)(2616005)(186003)(6512007)(66556008)(66476007)(64756008)(66446008)(8676002)(5660300002)(110136005)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Z7YjxboTALCISTPIWuz17zFxvupvxvFq197lForpFJpTusayWsPYM8jyBfEeHGkizYllOIeBwFz24A26o1Ie0xWq9ReIRct0rPCokuvD5yLokMncC95A6aeuNixcYwEBFbJhrI8UOWTLhjR5e+/3udTFk37MIxwpH9o5A8EuZb0hHbnC/0k9ZEkLx1qI+K+1v4zHHmX+ZdlDnVWfsz1RiBExrQwXWjMEqUEnvwzceUJIPqMhb8XMClBihOSVI1kGUQaxYgd8ilnp2g3gNIwFNlMJICsnQ3E7iD2FGBVvgIBfmyghVBbtdGcB6DrgTc+6tKlnbIV1oLDmmtj8CtxScNU25hYDZitygVLmzQjGAQsuyPn4jj71BVQpVaccSW6gUSrZAzlk3cyh8hbN3sndFSsvfN7a2MSlVuZEYQ3Zk7sWsau72hCtPi50wpuGIfcNF/cvwfUm+73Rs1y7nGZc53BfqCn89mlon3QSipx2bTA=
Content-Type: text/plain; charset="utf-8"
Content-ID: <04CC3B2CEA39F143A990DECBABBA7D72@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c21c076-160c-4a80-7066-08d802500fbf
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2020 15:10:15.5939
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r4mhdcdaOVlLA5+PJp+HcB6aJ6s9OmhWHvf9eU7lSJoVUc0fDvMCtEeKNv5zEmCaXWU+yeg1ZSoZauGnKAc4lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6623
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIwLTA1LTI3IGF0IDA3OjM2ICswMDAwLCBEZXh1YW4gQ3VpIHdyb3RlOg0KPiA+
IEZyb206IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPg0KPiA+IFNlbnQ6IFR1
ZXNkYXksIE1heSAyNiwgMjAyMCA2OjQ5IFBNDQo+ID4gVG86IERhdmlkIFMuIE1pbGxlciA8ZGF2
ZW1AZGF2ZW1sb2Z0Lm5ldD47IGt1YmFAa2VybmVsLm9yZw0KPiA+IENjOiBuZXRkZXZAdmdlci5r
ZXJuZWwub3JnOyBNYXJrIEJsb2NoIDxtYXJrYkBtZWxsYW5veC5jb20+OyBEZXh1YW4NCj4gPiBD
dWkNCj4gPiA8ZGVjdWlAbWljcm9zb2Z0LmNvbT47IE1vc2hlIFNoZW1lc2ggPG1vc2hlQG1lbGxh
bm94LmNvbT47IFNhZWVkDQo+ID4gTWFoYW1lZWQgPHNhZWVkbUBtZWxsYW5veC5jb20+DQo+ID4g
U3ViamVjdDogW25ldC1uZXh0IDEyLzE2XSBuZXQvbWx4NTogQWRkIGJhc2ljIHN1c3BlbmQvcmVz
dW1lDQo+ID4gc3VwcG9ydA0KPiA+IA0KPiA+IEZyb206IE1hcmsgQmxvY2ggPG1hcmtiQG1lbGxh
bm94LmNvbT4NCj4gPiANCj4gPiBBZGQgY2FsbGJhY2tzIHNvIHRoZSBOSUMgY291bGQgYmUgc3Vz
cGVuZGVkIGFuZCByZXN1bWVkLg0KPiA+IA0KPiA+IFRlc3RlZC1ieTogRGV4dWFuIEN1aSA8ZGVj
dWlAbWljcm9zb2Z0LmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBNYXJrIEJsb2NoIDxtYXJrYkBt
ZWxsYW5veC5jb20+DQo+ID4gUmV2aWV3ZWQtYnk6IE1vc2hlIFNoZW1lc2ggPG1vc2hlQG1lbGxh
bm94LmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG1lbGxh
bm94LmNvbT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4
NS9jb3JlL21haW4uYyB8IDE4DQo+ID4gKysrKysrKysrKysrKysrKysrDQo+ID4gIDEgZmlsZSBj
aGFuZ2VkLCAxOCBpbnNlcnRpb25zKCspDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMv
bmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9tYWluLmMNCj4gPiBiL2RyaXZlcnMvbmV0
L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9tYWluLmMNCj4gPiBpbmRleCAzMGRlM2JmMzVj
NmQuLjQwOGVlNjRhYTMzYiAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9t
ZWxsYW5veC9tbHg1L2NvcmUvbWFpbi5jDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQv
bWVsbGFub3gvbWx4NS9jb3JlL21haW4uYw0KPiA+IEBAIC0xNTM5LDYgKzE1MzksMjIgQEAgc3Rh
dGljIHZvaWQgc2h1dGRvd24oc3RydWN0IHBjaV9kZXYgKnBkZXYpDQo+ID4gIAltbHg1X3BjaV9k
aXNhYmxlX2RldmljZShkZXYpOw0KPiA+ICB9DQo+ID4gDQo+ID4gK3N0YXRpYyBpbnQgbWx4NV9z
dXNwZW5kKHN0cnVjdCBwY2lfZGV2ICpwZGV2LCBwbV9tZXNzYWdlX3Qgc3RhdGUpDQo+ID4gK3sN
Cj4gPiArCXN0cnVjdCBtbHg1X2NvcmVfZGV2ICpkZXYgPSBwY2lfZ2V0X2RydmRhdGEocGRldik7
DQo+ID4gKw0KPiA+ICsJbWx4NV91bmxvYWRfb25lKGRldiwgZmFsc2UpOw0KPiA+ICsNCj4gPiAr
CXJldHVybiAwOw0KPiA+ICt9DQo+ID4gKw0KPiA+ICtzdGF0aWMgaW50IG1seDVfcmVzdW1lKHN0
cnVjdCBwY2lfZGV2ICpwZGV2KQ0KPiA+ICt7DQo+ID4gKwlzdHJ1Y3QgbWx4NV9jb3JlX2RldiAq
ZGV2ID0gcGNpX2dldF9kcnZkYXRhKHBkZXYpOw0KPiA+ICsNCj4gPiArCXJldHVybiBtbHg1X2xv
YWRfb25lKGRldiwgZmFsc2UpOw0KPiA+ICt9DQo+ID4gKw0KPiA+ICBzdGF0aWMgY29uc3Qgc3Ry
dWN0IHBjaV9kZXZpY2VfaWQgbWx4NV9jb3JlX3BjaV90YWJsZVtdID0gew0KPiA+ICAJeyBQQ0lf
VkRFVklDRShNRUxMQU5PWCwgUENJX0RFVklDRV9JRF9NRUxMQU5PWF9DT05ORUNUSUIpIH0sDQo+
ID4gIAl7IFBDSV9WREVWSUNFKE1FTExBTk9YLCAweDEwMTIpLCBNTFg1X1BDSV9ERVZfSVNfVkZ9
LAkvKg0KPiA+IENvbm5lY3QtSUIgVkYgKi8NCj4gPiBAQCAtMTU4Miw2ICsxNTk4LDggQEAgc3Rh
dGljIHN0cnVjdCBwY2lfZHJpdmVyIG1seDVfY29yZV9kcml2ZXIgPSB7DQo+ID4gIAkuaWRfdGFi
bGUgICAgICAgPSBtbHg1X2NvcmVfcGNpX3RhYmxlLA0KPiA+ICAJLnByb2JlICAgICAgICAgID0g
aW5pdF9vbmUsDQo+ID4gIAkucmVtb3ZlICAgICAgICAgPSByZW1vdmVfb25lLA0KPiA+ICsJLnN1
c3BlbmQgICAgICAgID0gbWx4NV9zdXNwZW5kLA0KPiA+ICsJLnJlc3VtZSAgICAgICAgID0gbWx4
NV9yZXN1bWUsDQo+ID4gIAkuc2h1dGRvd24JPSBzaHV0ZG93biwNCj4gPiAgCS5lcnJfaGFuZGxl
cgk9ICZtbHg1X2Vycl9oYW5kbGVyLA0KPiA+ICAJLnNyaW92X2NvbmZpZ3VyZSAgID0gbWx4NV9j
b3JlX3NyaW92X2NvbmZpZ3VyZSwNCj4gPiAtLQ0KPiA+IDIuMjYuMg0KPiANCj4gSGkgRGF2aWQs
DQo+IENhbiB5b3UgcGxlYXNlIGNvbnNpZGVyIHRoaXMgcGF0Y2ggZm9yIHY1LjcgYW5kIHRoZSBz
dGFibGUgdHJlZQ0KPiB2NS42Lnk/DQo+IA0KDQpIaSBEZXh1YW4sIA0KDQpJIHdpbGwgcmUtc3Bp
biBhbmQgZG8gdGhpcyBmb3IgeW91LCB3aXRoIGEgcHJvcGVyIGNvbW1pdCBtZXNzYWdlIGFuZA0K
Rml4ZXMgdGFnIHRoaXMgY2FuIGdvIHRvIG5ldCBhbmQgLXN0YWJsZS4NCg0KPiBJIHVuZGVyc3Rh
bmQgaXQncyBhbHJlYWR5IHY1LjctcmM3IG5vdywgYnV0IElITU8gYXBwbHlpbmcgdGhpcyBwYXRj
aA0KPiB0byB2NS43IGFuZCB2NS42LnkgY2FuIGJyaW5nIGFuIGltbWVkaWF0ZSBiZW5lZml0IGFu
ZCBjYW4gbm90IGJyZWFrDQo+IGFueXRoaW5nIGV4aXN0aW5nOiBjdXJyZW50bHkgYSBMaW51eCBz
eXN0ZW0gd2l0aCB0aGUgbWx4NSBOSUMgYWx3YXlzIA0KPiBjcmFzaGVzIHVwb24gaGliZXJuYXRp
b24uIFdpdGggdGhpcyBwYXRjaCwgaGliZXJuYXRpb24gd29ya3MgZmluZQ0KPiB3aXRoDQo+IHRo
ZSBOSUMgaW4gbXkgdGVzdHMuIA0KPiANCj4gU29tZSB1c2VycyB3aG8gYXJlIHRyeWluZyB0byBo
aWJlcmFudGUgdGhlaXIgVk1zICh3aGljaCBydW4gb24gSHlwZXItDQo+IFYNCj4gYW5kIEF6dXJl
KSBoYXZlIHJlcG9ydGVkIHRoZSBjcmFzaCB0byBtZSBmb3Igc2V2ZXJhbCBtb250aHMsIHNvIElN
SE8NCj4gaXQgd291bGQgYmUgcmVhbGx5IGdyZWF0IGlmIHRoZSBwYXRjaCBjYW4gbGFuZCBpbiB2
NS43IGFuZCB2NS42LnkNCj4gcmF0aGVyIA0KPiB0aGFuIGxhbmQgaW4gdjUuOCBpbiB+MiBtb250
aHMgYW5kIGlzIGJhY2twb3J0ZWQgdG8gdjUuNi55IGFuZA0KPiB2NS43LnkuDQo+IA0KPiBUaGFu
a3MsDQo+IC0tIERleHVhbg0K
