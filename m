Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 251E310E48
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 22:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbfEAUzI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 16:55:08 -0400
Received: from mail-eopbgr130044.outbound.protection.outlook.com ([40.107.13.44]:55106
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726088AbfEAUzI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 May 2019 16:55:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vmgiOp4GL8s6W4MmnRWHJc3IkKAQ9N8uxlgXqO5+L8w=;
 b=bHxK0cZWFB33cv8WYjFSOutofpmiYJYxcyf8sacpenneK4aIY3LmOA0AecNfTAq/uZVbkoehc+KKeP8GMC+RdJG0j5vVbfPCICR1qyqacG73P6X0Olgb66Lhjv4SCho1062VQZ9NpnCn4t7jOzwTFfZcudmkB2DfPVlpZbBHyiY=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB5883.eurprd05.prod.outlook.com (20.179.11.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.10; Wed, 1 May 2019 20:55:04 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::ed24:8317:76e4:1a07]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::ed24:8317:76e4:1a07%5]) with mapi id 15.20.1856.008; Wed, 1 May 2019
 20:55:04 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Eran Ben Elisha <eranbe@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>
CC:     Jiri Pirko <jiri@mellanox.com>
Subject: Re: [Patch net-next] net: add a generic tracepoint for TX queue
 timeout
Thread-Topic: [Patch net-next] net: add a generic tracepoint for TX queue
 timeout
Thread-Index: AQHU/4WeyjdRzuEHOUOUtfoOZXVRhKZWP6aAgACBmQA=
Date:   Wed, 1 May 2019 20:55:03 +0000
Message-ID: <5b66159c15e5b046158e58692add94db1149f4e4.camel@mellanox.com>
References: <20190430185009.20456-1-xiyou.wangcong@gmail.com>
         <68f5b7e3-4022-edd4-8d18-752b3dfc500f@mellanox.com>
In-Reply-To: <68f5b7e3-4022-edd4-8d18-752b3dfc500f@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.30.5 (3.30.5-1.fc29) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 07726a5f-3cb2-4df4-eecb-08d6ce7748f6
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB5883;
x-ms-traffictypediagnostic: DB8PR05MB5883:
x-microsoft-antispam-prvs: <DB8PR05MB5883C8BE6F7F4250AD9C9EFBBE3B0@DB8PR05MB5883.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 00246AB517
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(376002)(366004)(396003)(39860400002)(199004)(189003)(316002)(68736007)(110136005)(6512007)(66556008)(2906002)(25786009)(305945005)(2501003)(6486002)(14454004)(102836004)(118296001)(58126008)(6506007)(66066001)(53546011)(6436002)(4326008)(229853002)(6116002)(3846002)(36756003)(446003)(476003)(2616005)(486006)(478600001)(11346002)(5660300002)(6246003)(26005)(66946007)(186003)(107886003)(76116006)(66476007)(64756008)(66446008)(71190400001)(81156014)(7736002)(91956017)(8676002)(8936002)(99286004)(71200400001)(76176011)(14444005)(256004)(86362001)(81166006)(2201001)(73956011)(53936002)(41533002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB5883;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: qH29hfHdg2/pteokMG0dDd/6fdEhZ1UacN3GoVE3UlmjrC5hd2u/PXnfWPaW5P/VtZRz939TuKSzF2QWwmcedgXFic+lLvaG+nS7ZpItGShcNq+n6KSebP25CNnyxcjt2fAiEjrt/p7mxknckZ75EjNouDt1InkzOYMG6SbPiHVkeZU7cyMR2QvSyu4fA276Yfbu74iJqNRh06ehbTfePmJE+SAFKoilx8xXefyhODooMGD5VsZuJavhveuOpfrtvQourUP/Uil1ILcRf6HBIlooHxpiilE9gsUkCqU0bYA+mQZihCFw8eV3uNqNDPRCzaU/OHvpCqNp/XNSd0fdEktK4hI4fBUdnDIjUjLn5dmVklZLT/8oqMSzy5lkpn0wkNhl/HRDMmzKA8XnDLR2648EePF08iLWrKdJ21QgpD4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <636B487689C88A4CA9A90B7B654942D6@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07726a5f-3cb2-4df4-eecb-08d6ce7748f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 May 2019 20:55:03.8125
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB5883
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDE5LTA1LTAxIGF0IDEzOjExICswMDAwLCBFcmFuIEJlbiBFbGlzaGEgd3JvdGU6
DQo+IA0KPiBPbiA0LzMwLzIwMTkgOTo1MCBQTSwgQ29uZyBXYW5nIHdyb3RlOg0KPiA+IEFsdGhv
dWdoIGRldmxpbmsgaGVhbHRoIHJlcG9ydCBkb2VzIGEgbmljZSBqb2Igb24gcmVwb3J0aW5nIFRY
DQo+ID4gdGltZW91dCBhbmQgb3RoZXIgTklDIGVycm9ycywgdW5mb3J0dW5hdGVseSBpdCByZXF1
aXJlcyBkcml2ZXJzDQo+ID4gdG8gc3VwcG9ydCBpdCBidXQgY3VycmVudGx5IG9ubHkgbWx4NSBo
YXMgaW1wbGVtZW50ZWQgaXQuDQo+IA0KPiBUaGUgZGV2bGluayBoZWFsdGggd2FzIG5ldmVyIGlu
dGVuZGVkIHRvIGJlIHRoZSBnZW5lcmljIG1lY2hhbmlzbQ0KPiBmb3IgDQo+IG1vbml0b3Jpbmcg
YWxsIGRyaXZlcidzIFRYIHRpbWVvdXRzIG5vdGlmaWNhdGlvbnMuIG1seDVlIGRyaXZlciBjaG9z
ZQ0KPiB0byANCj4gaGFuZGxlIFRYIHRpbWVvdXQgbm90aWZpY2F0aW9uIGJ5IHJlcG9ydGluZyBp
dCB0byB0aGUgbmV3bHkgZGV2bGluayANCj4gaGVhbHRoIG1lY2hhbmlzbS4NCj4gDQo+ID4gQmVm
b3JlIG90aGVyIGRyaXZlcnMgY291bGQgY2F0Y2ggdXAsIGl0IGlzIHVzZWZ1bCB0byBoYXZlIGEN
Cj4gPiBnZW5lcmljIHRyYWNlcG9pbnQgdG8gbW9uaXRvciB0aGlzIGtpbmQgb2YgVFggdGltZW91
dC4gV2UgaGF2ZQ0KPiA+IGJlZW4gc3VmZmVyaW5nIFRYIHRpbWVvdXQgd2l0aCBkaWZmZXJlbnQg
ZHJpdmVycywgd2UgcGxhbiB0bw0KPiA+IHN0YXJ0IHRvIG1vbml0b3IgaXQgd2l0aCByYXNkYWVt
b24gd2hpY2gganVzdCBuZWVkcyBhIG5ldw0KPiA+IHRyYWNlcG9pbnQuDQo+IA0KPiBHcmVhdCBp
ZGVhIHRvIHN1Z2dlc3QgYSBnZW5lcmljIHRyYWNlIG1lc3NhZ2UgdGhhdCBjYW4gYmUgbW9uaXRv
cmVkDQo+IG92ZXIgDQo+IGFsbCBkcml2ZXJzLg0KPiANCg0KKzENCg0KSSB3b3VsZCBhbHNvIGFk
ZCBza2ItPnhtaXRfbW9yZSBpbmRpY2F0aW9uIHRvIG5ldF9kZXZfc3RhcnRfeG1pdA0KdHJhY2Vw
b2ludCAoaW4gYSBzZXBhcmF0ZSBwYXRjaCksIG1hbnkgdHggdGltZW91dCBkZWJ1Z3MgcmV2ZWFs
ZWQgYQ0KYnVnZ3kgdXNhZ2Ugb2Ygc2tiLT54bWl0X21vcmUsIHdoZXJlIHhtaXRfbW9yZSB3YXMg
c2V0IGJ1dCBubyBmdXJ0aGVyDQpTS0JzIGFycml2ZWQuDQoNCj4gPiBTYW1wbGUgb3V0cHV0Og0K
PiA+IA0KPiA+ICAgIGtzb2Z0aXJxZC8xLTE2ICAgIFswMDFdIC4uczIgICAxNDQuMDQzMTczOiBu
ZXRfZGV2X3htaXRfdGltZW91dDoNCj4gPiBkZXY9ZW5zMyBkcml2ZXI9ZTEwMDAgcXVldWU9MA0K
PiA+IA0KPiA+IENjOiBFcmFuIEJlbiBFbGlzaGEgPGVyYW5iZUBtZWxsYW5veC5jb20+DQo+ID4g
Q2M6IEppcmkgUGlya28gPGppcmlAbWVsbGFub3guY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IENv
bmcgV2FuZyA8eGl5b3Uud2FuZ2NvbmdAZ21haWwuY29tPg0KPiA+IC0tLQ0KPiA+ICAgaW5jbHVk
ZS90cmFjZS9ldmVudHMvbmV0LmggfCAyMyArKysrKysrKysrKysrKysrKysrKysrKw0KPiA+ICAg
bmV0L3NjaGVkL3NjaF9nZW5lcmljLmMgICAgfCAgMiArKw0KPiA+ICAgMiBmaWxlcyBjaGFuZ2Vk
LCAyNSBpbnNlcnRpb25zKCspDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvdHJhY2Uv
ZXZlbnRzL25ldC5oDQo+ID4gYi9pbmNsdWRlL3RyYWNlL2V2ZW50cy9uZXQuaA0KPiA+IGluZGV4
IDFlZmQ3ZDliMjVmZS4uMDAyZDZmMDRiOWU1IDEwMDY0NA0KPiA+IC0tLSBhL2luY2x1ZGUvdHJh
Y2UvZXZlbnRzL25ldC5oDQo+ID4gKysrIGIvaW5jbHVkZS90cmFjZS9ldmVudHMvbmV0LmgNCj4g
PiBAQCAtMzAzLDYgKzMwMywyOSBAQCBERUZJTkVfRVZFTlQobmV0X2Rldl9yeF9leGl0X3RlbXBs
YXRlLA0KPiA+IG5ldGlmX3JlY2VpdmVfc2tiX2xpc3RfZXhpdCwNCj4gPiAgIAlUUF9BUkdTKHJl
dCkNCj4gPiAgICk7DQo+ID4gICANCj4gDQo+IEkgd291bGQgaGF2ZSBwdXQgdGhpcyBuZXh0IHRv
IG5ldF9kZXZfeG1pdCB0cmFjZSBldmVudCBkZWNsYXJhdGlvbi4NCj4gDQo+ID4gK1RSQUNFX0VW
RU5UKG5ldF9kZXZfeG1pdF90aW1lb3V0LA0KPiA+ICsNCj4gPiArCVRQX1BST1RPKHN0cnVjdCBu
ZXRfZGV2aWNlICpkZXYsDQo+ID4gKwkJIGludCBxdWV1ZV9pbmRleCksDQo+ID4gKw0KPiA+ICsJ
VFBfQVJHUyhkZXYsIHF1ZXVlX2luZGV4KSwNCj4gPiArDQo+ID4gKwlUUF9TVFJVQ1RfX2VudHJ5
KA0KPiA+ICsJCV9fc3RyaW5nKAluYW1lLAkJZGV2LT5uYW1lCSkNCj4gPiArCQlfX3N0cmluZygJ
ZHJpdmVyLAkJbmV0ZGV2X2RyaXZlcm5hbWUoZGV2KSkNCj4gPiArCQlfX2ZpZWxkKAlpbnQsCQlx
dWV1ZV9pbmRleAkpDQo+ID4gKwkpLA0KPiA+ICsNCj4gPiArCVRQX2Zhc3RfYXNzaWduKA0KPiA+
ICsJCV9fYXNzaWduX3N0cihuYW1lLCBkZXYtPm5hbWUpOw0KPiA+ICsJCV9fYXNzaWduX3N0cihk
cml2ZXIsIG5ldGRldl9kcml2ZXJuYW1lKGRldikpOw0KPiA+ICsJCV9fZW50cnktPnF1ZXVlX2lu
ZGV4ID0gcXVldWVfaW5kZXg7DQo+ID4gKwkpLA0KPiA+ICsNCj4gPiArCVRQX3ByaW50aygiZGV2
PSVzIGRyaXZlcj0lcyBxdWV1ZT0lZCIsDQo+ID4gKwkJX19nZXRfc3RyKG5hbWUpLCBfX2dldF9z
dHIoZHJpdmVyKSwgX19lbnRyeS0NCj4gPiA+cXVldWVfaW5kZXgpDQo+ID4gKyk7DQo+ID4gKw0K
PiA+ICAgI2VuZGlmIC8qIF9UUkFDRV9ORVRfSCAqLw0KPiA+ICAgDQo+ID4gICAvKiBUaGlzIHBh
cnQgbXVzdCBiZSBvdXRzaWRlIHByb3RlY3Rpb24gKi8NCj4gPiBkaWZmIC0tZ2l0IGEvbmV0L3Nj
aGVkL3NjaF9nZW5lcmljLmMgYi9uZXQvc2NoZWQvc2NoX2dlbmVyaWMuYw0KPiA+IGluZGV4IDg0
OGFhYjM2OTNiZC4uY2NlMWU5ZWU4NWFmIDEwMDY0NA0KPiA+IC0tLSBhL25ldC9zY2hlZC9zY2hf
Z2VuZXJpYy5jDQo+ID4gKysrIGIvbmV0L3NjaGVkL3NjaF9nZW5lcmljLmMNCj4gPiBAQCAtMzIs
NiArMzIsNyBAQA0KPiA+ICAgI2luY2x1ZGUgPG5ldC9wa3Rfc2NoZWQuaD4NCj4gPiAgICNpbmNs
dWRlIDxuZXQvZHN0Lmg+DQo+ID4gICAjaW5jbHVkZSA8dHJhY2UvZXZlbnRzL3FkaXNjLmg+DQo+
ID4gKyNpbmNsdWRlIDx0cmFjZS9ldmVudHMvbmV0Lmg+DQo+ID4gICAjaW5jbHVkZSA8bmV0L3hm
cm0uaD4NCj4gPiAgIA0KPiA+ICAgLyogUWRpc2MgdG8gdXNlIGJ5IGRlZmF1bHQgKi8NCj4gPiBA
QCAtNDQxLDYgKzQ0Miw3IEBAIHN0YXRpYyB2b2lkIGRldl93YXRjaGRvZyhzdHJ1Y3QgdGltZXJf
bGlzdCAqdCkNCj4gPiAgIAkJCX0NCj4gPiAgIA0KPiA+ICAgCQkJaWYgKHNvbWVfcXVldWVfdGlt
ZWRvdXQpIHsNCj4gPiArCQkJCXRyYWNlX25ldF9kZXZfeG1pdF90aW1lb3V0KGRldiwgaSk7DQo+
ID4gICAJCQkJV0FSTl9PTkNFKDEsIEtFUk5fSU5GTyAiTkVUREVWDQo+ID4gV0FUQ0hET0c6ICVz
ICglcyk6IHRyYW5zbWl0IHF1ZXVlICV1IHRpbWVkIG91dFxuIiwNCj4gPiAgIAkJCQkgICAgICAg
ZGV2LT5uYW1lLA0KPiA+IG5ldGRldl9kcml2ZXJuYW1lKGRldiksIGkpOw0KPiA+ICAgCQkJCWRl
di0+bmV0ZGV2X29wcy0+bmRvX3R4X3RpbWVvdXQoZGV2KTsNCj4gPiANCg==
