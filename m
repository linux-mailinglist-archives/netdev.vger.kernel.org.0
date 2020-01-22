Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2BD3145C56
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 20:17:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726135AbgAVTRQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 14:17:16 -0500
Received: from mail-eopbgr80089.outbound.protection.outlook.com ([40.107.8.89]:29573
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725884AbgAVTRP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jan 2020 14:17:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d9fMh2BdXyKriHfcjL+lxSghG8oZrRTGnQiOEMdk6etIkDvcT62xrmD9I1kkN4on+xIFdFtQynBQqMj+fKYMA6AKaeb4E4Z5925GFyZZzqTbWoQIMXrKOOSzMK39NHNRsD6CTnl3c8kTd8rU+BMmDvtS0MCvq16iSts+vlPaevg/T86RUz09f95zv2rZikF4ageUpCqHwN+qCXzmlLwTQo1CEBR1/MgWO8gXhyd+NnuGgSG4CXGsBk8QkpAkZG5iXeQgJMDGqNk4p7lDQdPffrV6ABGXCWs5fR82z7UGZasLC1Zmt+OhFTewOGA4is34+vHboAcVEYbobsiVz2tDfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j7eT1FHUn/L6yZps2GAJoJTv+lxgDqFaNfJg6B050nU=;
 b=hhJTiSuJLOc+e9tTEWI1KKmibaYr8DMuvsZQT8RbGL3g64oRRJ/sDEtXPiCSumrqK2Xq5nL+GdWZ2WRuOzw0I3owTf4gvHpS1a+VMqNizX3KEw0M8oMliLPjPug8DcKAVN7EVP2/yI/dOAkZyVaWXK3X2cALI4yHZhHNNax4aLg70+JDjrsnR5e9q7j/4JV8WwBkMPl7ZlGAl6aRF8j3Nr8eZS1c7YUyVMP+Rf0iyaOM39yCGVQVFLFxk4J6Twbhp3syOIpCIp4wu9JFArdEvlSgitjsJbcx9tyYY+N3q4EcJXbejflrGsmRnroXBLp/BtXs98fDyIg7Tq5d2PdsQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j7eT1FHUn/L6yZps2GAJoJTv+lxgDqFaNfJg6B050nU=;
 b=JMmbF0FpncS+97ux+ec0DlpEew/pcHDGlu2oRVcvgODeMTWY/yXRHAxUA4+HJM0uWT7ixsx+vdGqrUqeByv7hwW4sl3cz4OgFAxZgkaTWvvicnITgUgssjK845OUvGjqsD3ItndV+VUTa6iAf0elndOmx142knvSBOAr2a5tWoQ=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB3389.eurprd05.prod.outlook.com (10.170.238.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.24; Wed, 22 Jan 2020 19:17:09 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Wed, 22 Jan 2020
 19:17:08 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "wenxu@ucloud.cn" <wenxu@ucloud.cn>, Roi Dayan <roid@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2] net/mlx5e: Add mlx5e_flower_parse_meta
 support
Thread-Topic: [PATCH net-next v2] net/mlx5e: Add mlx5e_flower_parse_meta
 support
Thread-Index: AQHVxTsc0R/oby9wVku6xKhcy3y5W6fqrMyAgAA10oCAAJTOAIAKOI0AgADHiwCAAK8XAA==
Date:   Wed, 22 Jan 2020 19:17:08 +0000
Message-ID: <7033c80519f0fe37e2b42688be263fa35285b3f0.camel@mellanox.com>
References: <1578388566-27310-1-git-send-email-wenxu@ucloud.cn>
         <c4d6fe12986bd2b21faf831eb76f0f472ef903d1.camel@mellanox.com>
         <c6d4c563-f173-9ff6-83e5-95b246d90526@ucloud.cn>
         <09401ab5-1888-a19b-9e27-bd9c0cf408fe@mellanox.com>
         <fac29985c39902b1cb50426da02615285824dd6b.camel@mellanox.com>
         <cf04db18-a989-91a1-7a37-35b17dbe36ef@mellanox.com>
In-Reply-To: <cf04db18-a989-91a1-7a37-35b17dbe36ef@mellanox.com>
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
x-ms-office365-filtering-correlation-id: d03f05e4-7e1b-4634-5a6b-08d79f6fad0e
x-ms-traffictypediagnostic: VI1PR05MB3389:|VI1PR05MB3389:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB338920F9222E5094D4DCFA56BE0C0@VI1PR05MB3389.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 029097202E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(39860400002)(366004)(396003)(136003)(189003)(199004)(66946007)(64756008)(66556008)(66476007)(5660300002)(76116006)(91956017)(66446008)(6636002)(2906002)(316002)(8936002)(81156014)(478600001)(110136005)(8676002)(81166006)(71200400001)(6506007)(186003)(26005)(53546011)(4326008)(6512007)(36756003)(86362001)(6486002)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3389;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UR1NTMja29wQA2FbwZ9Jl4YgEr15/5gGLlw53dV3XJGXMgxX8Nj9i7ON7icCurmGZg3IDANUi673yFQPOaceO56mcLu5q9Sl4BAyMCZiNIrz6ayslWza2P/odJgse8cwL5jCBUC1jKLCbkhm18YWuyVMKwViN+MVs/Oeqndqf43FqaO7KqplGIe1ogDk2LoNLu9K1Mep3R4TEzE5/1YJcBzzqW5u+WS9jybeUGsGrb2PIhxc+qg4ykBg9qEnBaQjGULxUWHnhsG7YBWBV+5zs9FBpcTYX6xOURf6MikkRudmyvF8VHUVDTVGtmr6xKf9PXdbzavTRCqoaLlxT1XijdC2Og4by6xrtBrPRss0aAL5YnP44f8Vqr9mBusLGaY6B6Vc5wXQbjKOw/VvqAH/7f4GeBsTonytw/6Svz3+4RaTHpMcwNDpRg91H07JV0M/
Content-Type: text/plain; charset="utf-8"
Content-ID: <DAD92424E0BD8F4BA2AD08863ECE9E76@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d03f05e4-7e1b-4634-5a6b-08d79f6fad0e
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2020 19:17:08.8370
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LU6M9FF4ZPF7/7xncrF1ocSmGbL78jyLINTYL9jnN7D7y6ejXdBzFsd6jWVwr32NAwbz6sFOMBB/BmwXStyXBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3389
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIwLTAxLTIyIGF0IDA4OjUwICswMDAwLCBSb2kgRGF5YW4gd3JvdGU6DQo+IA0K
PiBPbiAyMDIwLTAxLTIxIDEwOjU2IFBNLCBTYWVlZCBNYWhhbWVlZCB3cm90ZToNCj4gPiBPbiBX
ZWQsIDIwMjAtMDEtMTUgYXQgMDg6NTEgKzAwMDAsIFJvaSBEYXlhbiB3cm90ZToNCj4gPiA+IE9u
IDIwMjAtMDEtMTUgMTo1OCBBTSwgd2VueHUgd3JvdGU6DQo+ID4gPiA+ICAyMDIwLzEvMTUgNDo0
NiwgU2FlZWQgTWFoYW1lZWQgOg0KPiA+ID4gPiA+IEhpIFdlbnh1LA0KPiA+ID4gPiA+IA0KPiA+
ID4gPiA+IEFjY29yZGluZyB0byBvdXIgcmVncmVzc2lvbiBUZWFtLCBUaGlzIGNvbW1pdCBpcyBi
cmVha2luZw0KPiA+ID4gPiA+IHZ4bGFuDQo+ID4gPiA+ID4gb2ZmbG9hZA0KPiA+ID4gPiA+IEND
J2VkIFBhdWwsIFJvaSBhbmQgVmxhZCwgdGhleSB3aWxsIGFzc2lzdCB5b3UgaWYgeW91IG5lZWQN
Cj4gPiA+ID4gPiBhbnkNCj4gPiA+ID4gPiBoZWxwLg0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IGNh
biB5b3UgcGxlYXNlIGludmVzdGlnYXRlIHRoZSBmb2xsb3dpbmcgY2FsbCB0cmFjZSA/DQo+ID4g
PiA+IA0KPiA+ID4gPiBIaSBTYWVlZCAmIFBhdWwsDQo+ID4gPiA+IA0KPiA+ID4gPiANCj4gPiA+
ID4gVGhpcyBwYXRjaCBqdXN0IGNoZWNrIHRoZSBtZXRhIGtleSBtYXRjaCB3aXRoIHRoZQ0KPiA+
ID4gPiBmaWx0ZXJfZGV2LiAgSWYNCj4gPiA+ID4gdGhpcyBtYXRjaCBmYWlsZWQsDQo+ID4gPiA+
IA0KPiA+ID4gPiBUaGUgbmV3IGZsb3dlciBpbnN0YWxsIHdpbGwgZmFpbGVkIGFuZCBuZXZlciBh
bGxvY2F0ZSBuZXcNCj4gPiA+ID4gbWx4NV9mc19mdGVzLg0KPiA+ID4gPiANCj4gPiA+ID4gSG93
IGNhbiBJIHJlcHJvZHVjZSB0aGlzIGNhc2U/IENhbiB5b3UgcHJvdmlkZSB0aGUgdGVzdCBjYXNl
DQo+ID4gPiA+IHNjcmlwdD8NCj4gPiA+ID4gDQo+ID4gPiA+IA0KPiA+ID4gPiBCUg0KPiA+ID4g
PiANCj4gPiA+ID4gd2VueHUNCj4gPiA+IA0KPiA+ID4gSGkgU2FlZWQsIFdlbnh1LA0KPiA+ID4g
DQo+ID4gPiBJIHJldmlld2VkIHRoZSBwYXRjaCBhbmQgdmVyaWZpZWQgbWFudWFsbHkganVzdCBp
biBjYXNlLiBTdWNoDQo+ID4gPiBpc3N1ZQ0KPiA+ID4gc2hvdWxkDQo+ID4gPiBub3QgYmUgcmVw
cm9kdWNlZCBmcm9tIHRoaXMgcGF0Y2ggYW5kIGluZGVlZCBJIGRpZCBub3QgcmVwcm9kdWNlDQo+
ID4gPiBpdC4NCj4gPiA+IEknbGwgdGFrZSB0aGUgaXNzdWUgd2l0aCBvdXIgcmVncmVzc2lvbiB0
ZWFtLg0KPiA+ID4gSSBhY2tlZCB0aGUgcGF0Y2guIGxvb2tzIGdvb2QgdG8gbWUuDQo+ID4gPiAN
Cj4gPiA+IFRoYW5rcywNCj4gPiA+IFJvaQ0KPiA+ID4gDQo+ID4gPiANCj4gPiANCj4gPiBUaGFu
a3MgUm9pLCANCj4gPiANCj4gPiBJZiB0aGUgZGlzY3Vzc2lvbiBpcyBvdmVyIGFuZCB5b3UgYWNr
IHRoZSBwYXRjaCwgcGxlYXNlIHByb3ZpZGUgYQ0KPiA+IGZvcm1hbCAiQWNrZWQtYnkiIHRhZyBz
byBpIHdpbGwgcHVsbCB0aGlzIHBhdGNoIGludG8gbmV0LW5leHQtbWx4NS4NCj4gPiANCj4gPiBU
aGFua3MsDQo+ID4gU2FlZWQuDQo+ID4gDQo+IA0KPiBJIHRob3VnaHQgSSBkaWQuIHNvcnJ5Lg0K
PiANCj4gQWNrZWQtYnk6IFJvaSBEYXlhbiA8cm9pZEBtZWxsYW5veC5jb20+DQoNCkFwcGxpZWQg
dG8gbmV0LW5leHQtbWx4NSwNCg0KVGhhbmtzIQ0K
