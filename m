Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B25B2860B
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 20:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731639AbfEWShe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 14:37:34 -0400
Received: from mail-eopbgr140055.outbound.protection.outlook.com ([40.107.14.55]:51942
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731383AbfEWShd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 14:37:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=isU6vnB1Oh4zsbKGVZx9uRWskyvXd2dv5b/+1wDiJUI=;
 b=kcSAsZBUBcBLtH4ml8PnfiSgamn7/+54PcFlEdPszZq1UEREB93KQldvMdrs14Wpfa2ZWbcB18sm4WLpJh6M+nPKZ9B3AA8b4sEYD9BXO8YwH/uKldUlFdyEkQG4T+ocIdv/0xQWuDDUyH6DolGpvVuVEldjf7i0i7Wa+K87v7I=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB6043.eurprd05.prod.outlook.com (20.179.11.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.17; Thu, 23 May 2019 18:37:28 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::7159:5f3a:906:6aab]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::7159:5f3a:906:6aab%7]) with mapi id 15.20.1922.013; Thu, 23 May 2019
 18:37:28 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "jiri@resnulli.us" <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        mlxsw <mlxsw@mellanox.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "leon@kernel.org" <leon@kernel.org>
Subject: Re: [patch net-next 0/7] expose flash update status to user
Thread-Topic: [patch net-next 0/7] expose flash update status to user
Thread-Index: AQHVEUw4codgs1S5BkKU8ojCpm54JaZ5CooA
Date:   Thu, 23 May 2019 18:37:28 +0000
Message-ID: <c4bd07725a1e5a4d09066eb73094623d8b37082b.camel@mellanox.com>
References: <20190523094510.2317-1-jiri@resnulli.us>
In-Reply-To: <20190523094510.2317-1-jiri@resnulli.us>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.2 (3.32.2-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b07e0700-fe08-416e-127a-08d6dfadb565
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB6043;
x-ms-traffictypediagnostic: DB8PR05MB6043:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <DB8PR05MB604306711147785C41C869EFBE010@DB8PR05MB6043.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 00462943DE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(366004)(39860400002)(346002)(376002)(199004)(189003)(25786009)(5660300002)(305945005)(6246003)(446003)(8936002)(4326008)(316002)(14454004)(66446008)(66556008)(7736002)(2616005)(118296001)(476003)(71200400001)(486006)(71190400001)(86362001)(256004)(64756008)(66476007)(66946007)(11346002)(14444005)(91956017)(73956011)(76116006)(229853002)(68736007)(6436002)(966005)(53936002)(36756003)(2501003)(478600001)(99286004)(102836004)(6506007)(66066001)(110136005)(76176011)(54906003)(15650500001)(6116002)(6306002)(186003)(3846002)(6486002)(58126008)(2906002)(6512007)(26005)(81166006)(81156014)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB6043;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 8RR9z23cC8anf4LJi+VFvYBY3xg+kdg6qiXj8kdw/kW2hK8wz+u6Hl0lZhPs4rK5V7jHTAVc0GN++tGVpwvPjR70/ZjoEY3Cygxtl9WUfklkOWKOgQ5RloGheK+SCl8MFdLqb5NRvLOJZOPj9ESAkBTN0Rca9G/gRSrm4tljKgdVL+KUgjfZqw4GJz7Y5qff+9sCI4g9Y0pnu0smyWykRTatcdvuxxFvLtF6E7IKNyaFd2KY4GyCVBybqETFS7VUt+iHCPxMPwkZyrLvhlqxEx4YT882nUufEtI1hKcjqFloPlFIZDdnTw5H8DIxjosjCqavp2ng3vV/IqMutUHSz0EsRZ/4NXgjDF9+KCWyCJG7Scu0UnuNem28E+EZGEAEWsSwAgJNNvIfXPqenc/Pb+Q+StZebTpMudFNtPrNFTM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <52A92A1EAE44F64E91231BE3F31DAD59@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b07e0700-fe08-416e-127a-08d6dfadb565
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2019 18:37:28.3181
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB6043
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDE5LTA1LTIzIGF0IDExOjQ1ICswMjAwLCBKaXJpIFBpcmtvIHdyb3RlOg0KPiBG
cm9tOiBKaXJpIFBpcmtvIDxqaXJpQG1lbGxhbm94LmNvbT4NCj4gDQo+IFdoZW4gdXNlciBpcyBm
bGFzaGluZyBkZXZpY2UgdXNpbmcgZGV2bGluaywgaGUgY3VycmVubHkgZG9lcyBub3Qgc2VlDQo+
IGFueQ0KPiBpbmZvcm1hdGlvbiBhYm91dCB3aGF0IGlzIGdvaW5nIG9uLCBwZXJjZW50YWdlcywg
ZXRjLg0KPiBEcml2ZXJzLCBmb3IgZXhhbXBsZSBtbHhzdyBhbmQgbWx4NSwgaGF2ZSBub3Rpb24g
YWJvdXQgdGhlIHByb2dyZXNzDQo+IGFuZCB3aGF0IGlzIGhhcHBlbmluZy4gVGhpcyBwYXRjaHNl
dCBleHBvc2VzIHRoaXMgcHJvZ3Jlc3MNCj4gaW5mb3JtYXRpb24gdG8gdXNlcnNwYWNlLg0KPiAN
Cg0KVmVyeSBjb29sIHN0dWZmLCBcbGV0J3MgdXBkYXRlIGRldmxpbmsgZG9jcyB3aXRoIHRoZSBu
ZXcgcG90ZW50aWFsDQpvdXRwdXQgb2YgdGhlIGZ3IGZsYXNoIGNvbW1hbmRzLCBhbmQgc2hvdyB1
cyBzb21lIG91dHB1dCBleGFtcGxlIGhlcmUNCm9yIG9uIG9uZSBvZiB0aGUgY29tbWl0IG1lc3Nh
Z2VzLCBpdCB3b3VsZCByZWFsbHkgaGVscCBnZXR0aW5nIGFuIGlkZWENCm9mIHdoYXQgdGhpcyBj
b29sIHBhdGNoc2V0IHByb3ZpZGVzLiANCg0KPiBTZWUgdGhpcyBjb25zb2xlIHJlY29yZGluZyB3
aGljaCBzaG93cyBmbGFzaGluZyBGVyBvbiBhIE1lbGxhbm94DQo+IFNwZWN0cnVtIGRldmljZToN
Cj4gaHR0cHM6Ly9hc2NpaW5lbWEub3JnL2EvMjQ3OTI2DQo+IA0KPiBKaXJpIFBpcmtvICg3KToN
Cj4gICBtbHhzdzogTW92ZSBmaXJtd2FyZSBmbGFzaCBpbXBsZW1lbnRhdGlvbiB0byBkZXZsaW5r
DQo+ICAgbWx4NTogTW92ZSBmaXJtd2FyZSBmbGFzaCBpbXBsZW1lbnRhdGlvbiB0byBkZXZsaW5r
DQo+ICAgbWx4Znc6IFByb3BhZ2F0ZSBlcnJvciBtZXNzYWdlcyB0aHJvdWdoIGV4dGFjaw0KPiAg
IGRldmxpbms6IGFsbG93IGRyaXZlciB0byB1cGRhdGUgcHJvZ3Jlc3Mgb2YgZmxhc2ggdXBkYXRl
DQo+ICAgbWx4Znc6IEludHJvZHVjZSBzdGF0dXNfbm90aWZ5IG9wIGFuZCBjYWxsIGl0IHRvIG5v
dGlmeSBhYm91dCB0aGUNCj4gICAgIHN0YXR1cw0KPiAgIG1seHN3OiBJbXBsZW1lbnQgZmxhc2gg
dXBkYXRlIHN0YXR1cyBub3RpZmljYXRpb25zDQo+ICAgbmV0ZGV2c2ltOiBpbXBsZW1lbnQgZmFr
ZSBmbGFzaCB1cGRhdGluZyB3aXRoIG5vdGlmaWNhdGlvbnMNCj4gDQo+ICBkcml2ZXJzL25ldC9l
dGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4uaCAgfCAgIDIgLQ0KPiAgLi4uL2V0aGVybmV0
L21lbGxhbm94L21seDUvY29yZS9lbl9ldGh0b29sLmMgIHwgIDM1IC0tLS0tLQ0KPiAgZHJpdmVy
cy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Z3LmMgIHwgICA2ICstDQo+ICAuLi4v
bWVsbGFub3gvbWx4NS9jb3JlL2lwb2liL2V0aHRvb2wuYyAgICAgICAgfCAgIDkgLS0NCj4gIC4u
Li9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL21haW4uYyAgICB8ICAyMCArKysrDQo+
ICAuLi4vZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL21seDVfY29yZS5oICAgfCAgIDMgKy0N
Cj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seGZ3L21seGZ3LmggICB8ICAxMSAr
LQ0KPiAgLi4uL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHhmdy9tbHhmd19mc20uYyAgIHwgIDU3
ICsrKysrKysrLS0NCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seHN3L2NvcmUu
YyAgICB8ICAxNSArKysNCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seHN3L2Nv
cmUuaCAgICB8ICAgMyArDQo+ICAuLi4vbmV0L2V0aGVybmV0L21lbGxhbm94L21seHN3L3NwZWN0
cnVtLmMgICAgfCAgNzUgKysrKysrKy0tLS0tLQ0KPiAgZHJpdmVycy9uZXQvbmV0ZGV2c2ltL2Rl
di5jICAgICAgICAgICAgICAgICAgIHwgIDM1ICsrKysrKw0KPiAgaW5jbHVkZS9uZXQvZGV2bGlu
ay5oICAgICAgICAgICAgICAgICAgICAgICAgIHwgICA4ICsrDQo+ICBpbmNsdWRlL3VhcGkvbGlu
dXgvZGV2bGluay5oICAgICAgICAgICAgICAgICAgfCAgIDUgKw0KPiAgbmV0L2NvcmUvZGV2bGlu
ay5jICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgMTAyDQo+ICsrKysrKysrKysrKysrKysr
Kw0KPiAgMTUgZmlsZXMgY2hhbmdlZCwgMjk1IGluc2VydGlvbnMoKyksIDkxIGRlbGV0aW9ucygt
KQ0KPiANCg0KUmV2aWV3ZWQtYnk6IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29t
Pg0K
