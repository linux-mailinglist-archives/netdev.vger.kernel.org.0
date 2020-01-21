Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D55114460D
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 21:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729112AbgAUUoI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 15:44:08 -0500
Received: from mail-eopbgr30071.outbound.protection.outlook.com ([40.107.3.71]:3552
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729043AbgAUUoI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jan 2020 15:44:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lsw5dJiVXvL8G83EnvgP3aOh70t+HlfZj8yM6MbDGy7QTVRAfuxpF9fQeh3iTj+8OAxai8tsK/8uaYmhFgdYABtF+RFVlOza/pv2GDq2RUcE5fyfnZRuTB02bijnmeiNr+0Vkfpd+osDAkqqd7aZT72T+O4o8CgfsqarjpbFtOuuhRL8qB8hl3IGHk8gYsMwtYjUjBbVl+OPRUitc51Dc186eteZJ1iN5BY+SLSX+9NmnK8Z3trd66YiodSNuTAC+mtljACRmRBsUHoHC2BEfdPCOsKhzw6X4GbMYENQO3tbHS4Q/13qVW1YilVXwlzNB4hdzn4rNNOrQFfyDh92uA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZKMxq/Tr9J1OA9pbR76MTW/quUEcazlgZ2v5wGRWwvE=;
 b=NEOMZQ24iV9Jar6Yh82RSmhFXyDJ8bQPS8FG6sGMwH62kbI4kkQv9E9p6aZvkLUv3MEivmSI1+8UekEYdaCYjSnHszQY58AyjfvrzgZlNO7eZbdjUiqssmcFjQO6mOJnrjG7k/ftOPENMt+4+fAFeGARZTdOQTMkGXNpEI4LX29+fOVhcDn1ib+LEx3A4S9ljqbvXfuh0lXHD8DSGy8TkmEdUls470uSLJiDExrVD14VSumh8nCp2fgAw8bJp4NMYjp5C4J0QhExCOAKrhQ2NsXLpepKjIzh+PSs2h3z9GdnJi9JmcmYbDmvAXbeW5hmD9ThLub/RmLsEMbtzT0zDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZKMxq/Tr9J1OA9pbR76MTW/quUEcazlgZ2v5wGRWwvE=;
 b=fWtfwC3WyZnHzieK9avlnDSWNcXDo9uMIKBmaYCcqmJIzTgZxXvEt9/IxugKfCytaPOHPiW2BdkE3AqUF+zXPQmUg7Z1TXluSgwN+9zc3FmYvperi5oFR4GnpdoU3z3mP8QHHNSPlSQzNJraWCD98tosIlHPh6UNZ+jQ6RSggCA=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4381.eurprd05.prod.outlook.com (52.133.13.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.25; Tue, 21 Jan 2020 20:44:02 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Tue, 21 Jan 2020
 20:44:02 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Oz Shlomo <ozsh@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "chenwandun@huawei.com" <chenwandun@huawei.com>,
        "leon@kernel.org" <leon@kernel.org>
Subject: Re: [PATCH next] net/mlx5: make the symbol 'ESW_POOLS' static
Thread-Topic: [PATCH next] net/mlx5: make the symbol 'ESW_POOLS' static
Thread-Index: AQHVz4z4hjZDf32jQkufw0C47aSDGKfzne6AgAH5/AA=
Date:   Tue, 21 Jan 2020 20:44:02 +0000
Message-ID: <0e4bd8d1346c5393c2986c0ed5b02661feb0b0c1.camel@mellanox.com>
References: <20200120124153.32354-1-chenwandun@huawei.com>
         <846abf8c-8c81-a054-9f89-4ad56b104d99@mellanox.com>
In-Reply-To: <846abf8c-8c81-a054-9f89-4ad56b104d99@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.3 (3.34.3-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c1b03b75-9020-4846-02da-08d79eb2a653
x-ms-traffictypediagnostic: VI1PR05MB4381:|VI1PR05MB4381:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB438190546A29BF72B1DA92F1BE0D0@VI1PR05MB4381.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-forefront-prvs: 0289B6431E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(376002)(39860400002)(396003)(346002)(189003)(199004)(91956017)(81166006)(66446008)(81156014)(66556008)(86362001)(8676002)(66476007)(66946007)(8936002)(64756008)(76116006)(2616005)(53546011)(6506007)(26005)(186003)(316002)(110136005)(5660300002)(36756003)(6486002)(478600001)(2906002)(6512007)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4381;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +/AP64FkntWUjhqLTNJIObLAYeVCfUFF628+vddCWB4zzWHotPwERD5EYSnKqOf3j46fTie8vjg8ypAsaabSxEMMkh/uJatn/PgTEP0xIbQw4gim6TMzcVP2BLPcqOGxs2Cx41OT1NsJxaViJAHyDp+iJbLeg9qth44VdTc16vBwaEZ851SsTC84jI/k4j0QPLNiaa0JL8vzXZWNByeqhSLrdNCow658UsgE4qqnhOC+O9lE6SvvQCMayRnSFFF4J2FmSEwnHvnverh+KvvWLoRSwNp2to5vY/NMCl03ioOlDrIy4qTGXXtfhAwJ26Qkm4oCAD3IlvhRg7oNS5rDz3E4yFt69jmAcIWzAFmYDSFzBgSlWrh/v955lpThb5fhIc2XKYUBEbkHWtJVs3JekaneqDplVfDmBj9idlRbcsOIAIfKV2hpLqXk8/lhiPx+
Content-Type: text/plain; charset="utf-8"
Content-ID: <B4D1103943658140B36224D3E5BAC88A@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1b03b75-9020-4846-02da-08d79eb2a653
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2020 20:44:02.6990
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4LZSxsntqOpj4rrqj8ueaoWE1NB5tQu4ItYiuku80dxIRLsZ3+miHxffrJuHYRSAumqYasIeA4tEN2e6a/8yHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4381
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIwLTAxLTIwIGF0IDE0OjMzICswMDAwLCBQYXVsIEJsYWtleSB3cm90ZToNCj4g
T24gMS8yMC8yMDIwIDI6NDEgUE0sIENoZW4gV2FuZHVuIHdyb3RlOg0KPiA+IEZpeCB0aGUgZm9s
bG93aW5nIHNwYXJzZSB3YXJuaW5nOg0KPiA+IGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94
L21seDUvY29yZS9lc3dpdGNoX29mZmxvYWRzX2NoYWlucy5jOjMNCj4gPiA1OjIwOiB3YXJuaW5n
OiBzeW1ib2wgJ0VTV19QT09MUycgd2FzIG5vdCBkZWNsYXJlZC4gU2hvdWxkIGl0IGJlDQo+ID4g
c3RhdGljPw0KPiA+IA0KPiA+IEZpeGVzOiAzOWFjMjM3Y2UwMDkgKCJuZXQvbWx4NTogRS1Td2l0
Y2gsIFJlZmFjdG9yIGNoYWlucyBhbmQNCj4gPiBwcmlvcml0aWVzIikNCj4gPiBTaWduZWQtb2Zm
LWJ5OiBDaGVuIFdhbmR1biA8Y2hlbndhbmR1bkBodWF3ZWkuY29tPg0KPiA+IC0tLQ0KPiA+ICAg
Li4uL2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lc3dpdGNoX29mZmxvYWRzX2NoYWlucy5j
IHwgOA0KPiA+ICsrKystLS0tDQo+ID4gICAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCsp
LCA0IGRlbGV0aW9ucygtKQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQNCj4gPiBhL2RyaXZlcnMvbmV0
L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lc3dpdGNoX29mZmxvYWRzX2NoYWlucy5jDQo+
ID4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXN3aXRjaF9vZmZs
b2Fkc19jaGFpbnMuYw0KPiA+IGluZGV4IDNhNjBlYjUzNjBiZC4uYzVhNDQ2ZTI5NWFhIDEwMDY0
NA0KPiA+IC0tLQ0KPiA+IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3Jl
L2Vzd2l0Y2hfb2ZmbG9hZHNfY2hhaW5zLmMNCj4gPiArKysNCj4gPiBiL2RyaXZlcnMvbmV0L2V0
aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lc3dpdGNoX29mZmxvYWRzX2NoYWlucy5jDQo+ID4g
QEAgLTMyLDEwICszMiwxMCBAQA0KPiA+ICAgICogcG9vbHMuDQo+ID4gICAgKi8NCj4gPiAgICNk
ZWZpbmUgRVNXX1NJWkUgKDE2ICogMTAyNCAqIDEwMjQpDQo+ID4gLWNvbnN0IHVuc2lnbmVkIGlu
dCBFU1dfUE9PTFNbXSA9IHsgNCAqIDEwMjQgKiAxMDI0LA0KPiA+IC0JCQkJICAgMSAqIDEwMjQg
KiAxMDI0LA0KPiA+IC0JCQkJICAgNjQgKiAxMDI0LA0KPiA+IC0JCQkJICAgNCAqIDEwMjQsIH07
DQo+ID4gK3N0YXRpYyBjb25zdCB1bnNpZ25lZCBpbnQgRVNXX1BPT0xTW10gPSB7IDQgKiAxMDI0
ICogMTAyNCwNCj4gPiArCQkJCQkgIDEgKiAxMDI0ICogMTAyNCwNCj4gPiArCQkJCQkgIDY0ICog
MTAyNCwNCj4gPiArCQkJCQkgIDQgKiAxMDI0LCB9Ow0KPiA+ICAgDQo+ID4gICBzdHJ1Y3QgbWx4
NV9lc3dfY2hhaW5zX3ByaXYgew0KPiA+ICAgCXN0cnVjdCByaGFzaHRhYmxlIGNoYWluc19odDsN
Cj4gDQo+IEFja2VkLWJ5OiBQYXVsIEJsYWtleSA8cGF1bGJAbWVsbGFub3guY29tPg0KPiANCg0K
QXBwbGllZCB0byBuZXQtbmV4dC1tbHg1LA0KDQpUaGFua3MhDQo=
