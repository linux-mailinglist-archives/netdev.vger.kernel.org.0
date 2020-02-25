Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30E6416F2BC
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 23:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729147AbgBYWue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 17:50:34 -0500
Received: from mail-eopbgr10043.outbound.protection.outlook.com ([40.107.1.43]:59761
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728806AbgBYWue (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 17:50:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NZuIvOaJXrku11G2lNMFft8cj8QKVzIfIBW8oh68bmHFC6cjH8wXyhsKysIIY+gsO9Ba67JUL+2Sfhtpq+dzKXsCk4qDrdkN7Jm2SIqrZHj36a0v+AvqNwHzFZoeAry+iJiWG0XEHlHlmQlfFztDAWJMBSgflogWXn73GwGy234rv/zcoTF7gCuSWZL3vnCbD6Kc2ETQR6NYrOiDoQpZkqk+MBrh0KPWelI2/uxGAYg5XFpU+k9QlqetROn6IQCBeesT5Bed6ITzRAOVUrfxm9o5MrlW20CxNrnCeGpD7nVz7lYDa/8L9x4ts4gVaEdB57/HAZC1mC+erpiwDCEKXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V+0RzS8WlFrnwmnZcUdNeHQQgsnu4U8+W9VVUS+W9as=;
 b=Bc6Uvkz8OWpBD/3dB/AswQRmDDO7KqDRF4RaGiH3aaHrOKx5RV0NFaqGaMQZlxE9hPFglcpOLFG7H8AiKW9Ie1UdpCbF9SJZjJSCVpuxy3zNWzlMNZ5AsuGYRM0KkoHsJp1whk5YIQdjoteP4mWcHOo93wuWAJPae0/NH3UJjWBPLuMEkFfVJBgt7ZLl+HXuUOGGSUq8sFb7+csnOZr0gowL5dtrgnKOtFiZLXMMvcbAzOC9j1KOhd0i+QvC1/FJGMKwiwxlzqhOF+fj1xJs+E/f8SXfMTlljKFob+CnBCXaQn+EDVjg5qp9FvU+CJ9lVlhcZJ6q6LRvYzx+v842cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V+0RzS8WlFrnwmnZcUdNeHQQgsnu4U8+W9VVUS+W9as=;
 b=dTrZEYVSdwrd7O+KFBy+to+zM0880/0GHT4noSkrXOTL39KjWc1di550c+MSIIDa+cLM3zPhgg4259XTNuq905SqKR/SZcfyY2Lnzh3VDDXpcLX3QPGGxj8jYVMGmGG3ITtMzVsZsch+2gR7AzF8YLo+ugTexMh/U5z7Q/euvmg=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5533.eurprd05.prod.outlook.com (20.177.201.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.21; Tue, 25 Feb 2020 22:50:30 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2750.021; Tue, 25 Feb 2020
 22:50:29 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Roi Dayan <roid@mellanox.com>,
        "saeedm@dev.mellanox.co.il" <saeedm@dev.mellanox.co.il>,
        Paul Blakey <paulb@mellanox.com>,
        "xiangxia.m.yue@gmail.com" <xiangxia.m.yue@gmail.com>,
        "gerlitz.or@gmail.com" <gerlitz.or@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [net-next] net/mlx5e: Remove the unnecessary parameter
Thread-Topic: [net-next] net/mlx5e: Remove the unnecessary parameter
Thread-Index: AQHV6/UwlrdDzXR5mEu98mbRGSjEHKgshAeA
Date:   Tue, 25 Feb 2020 22:50:29 +0000
Message-ID: <5361639fee997ea6239d6115978f86f26fb918b4.camel@mellanox.com>
References: <1582646588-91471-1-git-send-email-xiangxia.m.yue@gmail.com>
In-Reply-To: <1582646588-91471-1-git-send-email-xiangxia.m.yue@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: eb525cf4-fa57-42aa-3484-08d7ba451d15
x-ms-traffictypediagnostic: VI1PR05MB5533:|VI1PR05MB5533:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5533BC06C5AA02A5A490AB58BEED0@VI1PR05MB5533.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0324C2C0E2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(396003)(376002)(39860400002)(346002)(199004)(189003)(26005)(186003)(5660300002)(4326008)(36756003)(2616005)(66476007)(91956017)(66446008)(6506007)(6512007)(76116006)(66946007)(66556008)(64756008)(8676002)(6486002)(478600001)(8936002)(81156014)(71200400001)(81166006)(86362001)(110136005)(2906002)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5533;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: U/QgL0DRvzGQTeRbwoc2gcKqVXGtJYt1vQGVy8aAsubYEdVAk5XkznVn00j4G2IFzWjKLjkZTppDtoYqBUdYxid1RSRVhuoq501Zt9cQHgyu2NgKd7Qq1Sv9fhIF1hntGN0PbJmjkc83RBrMbzB1j5l0zFtCwN8Ze9c7sZYPFUDSPynoSTZdmUFm8ghP2g9eHOkoJgcXdOv+OqWJzLn53ameuuphwi/jmNhb/Bi+iZqcu0hEWrHNLyeP3eCXzJh7nn3t3pPhxraj4URI9kOeH9m8DmBS+B5gj5fzURR1CRelKcTnY0133FwvWErMCguuOnaixokeNbMYO97eYcKEyeBjqu5dFlnHw9XWxHaxRiWt0pWWkGSnwJ1qppLY+0ODoXEUq0pBj/qj7iouZmLO6kU3KbwY7b4QTI2zn/LsEZoBcqoksTv4V3cP9XY/C0R7
x-ms-exchange-antispam-messagedata: c/woSjvdEIYPZWEilQpFIpTvt6TBOgJ+KckRHpag0Ti8VyI/Ngw20kJTqfOCnxC5KybQLZ28QsUAmoX1dktHtpH/fJ9gMmNvRxJojnD33yOdHdiwVTioT1rflgLT2ktRqWAb9XlUF1lJ6Ew9B091Ng==
Content-Type: text/plain; charset="utf-8"
Content-ID: <A0875B5C4E951E4085E800832F75B3ED@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb525cf4-fa57-42aa-3484-08d7ba451d15
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Feb 2020 22:50:29.9013
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rkIwQ2/potrf/0A9rGCpr0upfsjjwJ/amBHWIzT8NbbkR2SZYNlTiJmQUYz8JVEoUlLO94WaeY0pm3bCdmMOvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5533
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIwLTAyLTI2IGF0IDAwOjAzICswODAwLCB4aWFuZ3hpYS5tLnl1ZUBnbWFpbC5j
b20gd3JvdGU6DQo+IEZyb206IFRvbmdoYW8gWmhhbmcgPHhpYW5neGlhLm0ueXVlQGdtYWlsLmNv
bT4NCj4gDQo+IFRoZSBwYXJhbWV0ZXIgZGVzaXJlZF9zaXplIGlzIGFsd2F5cyAwLCBhbmQgdGhl
cmUgaXMgb25seSBvbmUNCj4gZnVuY3Rpb24gY2FsbGluZyB0aGUgbWx4NV9lc3dfY2hhaW5zX2dl
dF9hdmFpbF9zel9mcm9tX3Bvb2wuDQo+IERlbGV0aW5nIHRoZSBwYXJhbWV0ZXIgZGVzaXJlZF9z
aXplLg0KDQpQYXVsLCB3aGF0IGlzIHRoZSByZWFzb25pbmcgYmVoaW5kIGRlc2lyZWQgc2l6ZSwg
aSBjb25maXJtIHRoYXQgaXQgIGlzDQpub3QgYWN0dWFsbHkgdXNlZCByaWdodCBub3csIGRvIHdl
IGhhdmUgYSBwZW5kaW5nIHBhdGNoIHRoYXQgbmVlZHMgaXQNCj8gDQppZiB0aGlzIGlzIG5vdCBn
b2luZyB0byBoYXBwZW4gaW4gdGhlIG5lYXIgZnV0dXJlIGkgdm90ZSB0byBhcHBseSB0aGlzDQpw
YXRjaCBhbmQgYnJpbmcgaXQgYmFjayB3aGVuIG5lZWRlZC4NCg0KDQpUaGFua3MsDQpTYWVlZC4N
Cg0KPiANCj4gU2lnbmVkLW9mZi1ieTogVG9uZ2hhbyBaaGFuZyA8eGlhbmd4aWEubS55dWVAZ21h
aWwuY29tPg0KPiAtLS0NCj4gIC4uLi9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Vz
d2l0Y2hfb2ZmbG9hZHNfY2hhaW5zLmMgfCAxMQ0KPiArKystLS0tLS0tLQ0KPiAgMSBmaWxlIGNo
YW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgOCBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQN
Cj4gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXN3aXRjaF9vZmZs
b2Fkc19jaGFpbnMuYw0KPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29y
ZS9lc3dpdGNoX29mZmxvYWRzX2NoYWlucy5jDQo+IGluZGV4IGM1YTQ0NmUuLmNlNWI3ZTEgMTAw
NjQ0DQo+IC0tLQ0KPiBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9l
c3dpdGNoX29mZmxvYWRzX2NoYWlucy5jDQo+ICsrKw0KPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0
L21lbGxhbm94L21seDUvY29yZS9lc3dpdGNoX29mZmxvYWRzX2NoYWlucy5jDQo+IEBAIC0xMzQs
MTkgKzEzNCwxNCBAQCBzdGF0aWMgdW5zaWduZWQgaW50DQo+IG1seDVfZXN3X2NoYWluc19nZXRf
bGV2ZWxfcmFuZ2Uoc3RydWN0IG1seDVfZXN3aXRjaCAqZXN3KQ0KPiAgCXJldHVybiBGREJfVENf
TEVWRUxTX1BFUl9QUklPOw0KPiAgfQ0KPiAgDQo+IC0jZGVmaW5lIFBPT0xfTkVYVF9TSVpFIDAN
Cj4gIHN0YXRpYyBpbnQNCj4gLW1seDVfZXN3X2NoYWluc19nZXRfYXZhaWxfc3pfZnJvbV9wb29s
KHN0cnVjdCBtbHg1X2Vzd2l0Y2ggKmVzdywNCj4gLQkJCQkgICAgICAgaW50IGRlc2lyZWRfc2l6
ZSkNCj4gK21seDVfZXN3X2NoYWluc19nZXRfYXZhaWxfc3pfZnJvbV9wb29sKHN0cnVjdCBtbHg1
X2Vzd2l0Y2ggKmVzdykNCj4gIHsNCj4gIAlpbnQgaSwgZm91bmRfaSA9IC0xOw0KPiAgDQo+ICAJ
Zm9yIChpID0gQVJSQVlfU0laRShFU1dfUE9PTFMpIC0gMTsgaSA+PSAwOyBpLS0pIHsNCj4gLQkJ
aWYgKGZkYl9wb29sX2xlZnQoZXN3KVtpXSAmJiBFU1dfUE9PTFNbaV0gPg0KPiBkZXNpcmVkX3Np
emUpIHsNCj4gKwkJaWYgKGZkYl9wb29sX2xlZnQoZXN3KVtpXSkNCj4gIAkJCWZvdW5kX2kgPSBp
Ow0KPiAtCQkJaWYgKGRlc2lyZWRfc2l6ZSAhPSBQT09MX05FWFRfU0laRSkNCj4gLQkJCQlicmVh
azsNCj4gLQkJfQ0KPiAgCX0NCj4gIA0KPiAgCWlmIChmb3VuZF9pICE9IC0xKSB7DQo+IEBAIC0x
OTgsNyArMTkzLDcgQEAgc3RhdGljIHVuc2lnbmVkIGludA0KPiBtbHg1X2Vzd19jaGFpbnNfZ2V0
X2xldmVsX3JhbmdlKHN0cnVjdCBtbHg1X2Vzd2l0Y2ggKmVzdykNCj4gIAkJZnRfYXR0ci5mbGFn
cyB8PSAoTUxYNV9GTE9XX1RBQkxFX1RVTk5FTF9FTl9SRUZPUk1BVCB8DQo+ICAJCQkJICBNTFg1
X0ZMT1dfVEFCTEVfVFVOTkVMX0VOX0RFQ0FQKTsNCj4gIA0KPiAtCXN6ID0gbWx4NV9lc3dfY2hh
aW5zX2dldF9hdmFpbF9zel9mcm9tX3Bvb2woZXN3LA0KPiBQT09MX05FWFRfU0laRSk7DQo+ICsJ
c3ogPSBtbHg1X2Vzd19jaGFpbnNfZ2V0X2F2YWlsX3N6X2Zyb21fcG9vbChlc3cpOw0KPiAgCWlm
ICghc3opDQo+ICAJCXJldHVybiBFUlJfUFRSKC1FTk9TUEMpOw0KPiAgCWZ0X2F0dHIubWF4X2Z0
ZSA9IHN6Ow0K
