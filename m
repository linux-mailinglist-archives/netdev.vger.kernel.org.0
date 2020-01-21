Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33E71144622
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 21:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729061AbgAUU4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 15:56:22 -0500
Received: from mail-eopbgr130040.outbound.protection.outlook.com ([40.107.13.40]:56022
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728741AbgAUU4V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jan 2020 15:56:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KzsmQzaoFlyepaJ2IgIwCe3U7VXo67Bmkfx5vKrfkF61qkCzQsr2a90q7ZNq8EqcxHam9yCzLVCQ/aJ0xcZ1kyOdi+Ri/K9Vz2Clw/F6q5UBrB9zx1y6ZLtqMQxHoKSHYZ8go91uO/kIJJJ8afygFi7THYglwRfqLPgnIAS/VdJuG1E+Xg/97IrXWNzLFQtArO4Wr7+Y4XD/QYMRAs40/YMRxAsxUYPpsd4pW3TNWZbVvkJQXOlYrUn1jxfZxi8tPiKd//Im62kYar2nDLqBsxPU2KolEQGpm5jt7RSzkmngJTeI6MOfq6k9/ONN2Jol06PUEn0vJhFnmhZk8mthyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R4UNmPB4cLua+XSwBHaxTbQfqGmpGdCPirDO2vJZr7o=;
 b=aEl/SC4BHxiEVDL9f4JEqB4tYP8ZLdfUhdSxVubcbKnTgQq8kr0PpmA429zAKI09WATpYAk8PRkMpKaowmPxUbpTzV/lTn6837DzP7Yr+X/Amt3kzUaCXeIfq46Lxo0eun9rjsnurmOS0C0Spd9Jhl7ORLSNe0Zt1X0bDkmVdwPfRAdOwUlbQPQ2EClLMEe6M2V4JM/wiql3gHhWpaAL0btgV4Q4GCAv0+YF8jrvtA2DmeMmXZPdbfuRuSM1yV65Zzqv0JzWe6L67eZxxRVuDNYt18oEPwnpP2hr3r0RH8hlAhmO5D0s8jtQBtdaqCclyj+MoCAL+Yndb+AIQUG5bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R4UNmPB4cLua+XSwBHaxTbQfqGmpGdCPirDO2vJZr7o=;
 b=lXZzeAG/nw0QBc1YR4F/6/uO2Z0y/Q8QI5QGT748HV6kEe3FENz+bpGUPRsZuGpgvTCKxcoQQeaGwQNK2+uWP8JzVHm6ZBzEwjHd8Sd79m8wGNhUu4HcAtjKpdHTgQby6o2iRMnCHs49eGv89xoKyiZg9feAIjOLhmvO9F+VDG0=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4768.eurprd05.prod.outlook.com (20.176.7.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Tue, 21 Jan 2020 20:56:16 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Tue, 21 Jan 2020
 20:56:16 +0000
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
Thread-Index: AQHVxTsc0R/oby9wVku6xKhcy3y5W6fqrMyAgAA10oCAAJTOAIAKOI0A
Date:   Tue, 21 Jan 2020 20:56:16 +0000
Message-ID: <fac29985c39902b1cb50426da02615285824dd6b.camel@mellanox.com>
References: <1578388566-27310-1-git-send-email-wenxu@ucloud.cn>
         <c4d6fe12986bd2b21faf831eb76f0f472ef903d1.camel@mellanox.com>
         <c6d4c563-f173-9ff6-83e5-95b246d90526@ucloud.cn>
         <09401ab5-1888-a19b-9e27-bd9c0cf408fe@mellanox.com>
In-Reply-To: <09401ab5-1888-a19b-9e27-bd9c0cf408fe@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 6274e2b0-ae8a-4016-fd8c-08d79eb45b94
x-ms-traffictypediagnostic: VI1PR05MB4768:|VI1PR05MB4768:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4768C6843793E6594D201580BE0D0@VI1PR05MB4768.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0289B6431E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(346002)(396003)(39860400002)(366004)(189003)(199004)(86362001)(71200400001)(6486002)(316002)(53546011)(2616005)(26005)(66446008)(66556008)(64756008)(6506007)(91956017)(66946007)(66476007)(76116006)(186003)(478600001)(81156014)(2906002)(8936002)(110136005)(4326008)(6636002)(6512007)(81166006)(5660300002)(8676002)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4768;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H+0KESQKzvt7QhPsaP93rwyHLpfKDs6wACuDgyVxLNbSxnHcPMeONuYWqMaUVzowemS4teDTDga08nnwZvFRS387TvZouHXizGUzpfYW9VgywoDCq+YznokXKR0AyDQnmGZp/QfKWrbl5qlIOJFwOblEd6pbw79h0g9ZQkjQp1miBMrn7x3p0BuRiyBrwLAYaCDzkai/oLnV5X0Vgn88bEwC4qtWQ60m7j3H8SF61BvskRnOL2d7J9JUDyxPXo34ORxg9NP5FQEm9cl+q5mBSN77MXUN5fdOz380ny57keLnTDX1qi5/o6MJAe+h37TABjw08QlPrZAszNRWAj8dmbkJkvZEx7oHQKC5/feEUU7M1CNGgtJvpOM0gsX4QW9ChfpjW1VFbi7RB+oGN3Rp5dhTSe5f+oNjur96lPhD4j0uhaFNVh0xnHs5Ik4hUFQ9
Content-Type: text/plain; charset="utf-8"
Content-ID: <44717B6FDF487C4289204236BAE1F544@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6274e2b0-ae8a-4016-fd8c-08d79eb45b94
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2020 20:56:16.3497
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s29Sk1rcoOW+ySE3TBzpW19WovDedPf0XPjbKhuWHc5Tn4n+lKganIaS+DJ0TCEf0PsC6x2QZ5C7rnwEhmnk5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4768
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIwLTAxLTE1IGF0IDA4OjUxICswMDAwLCBSb2kgRGF5YW4gd3JvdGU6DQo+IA0K
PiBPbiAyMDIwLTAxLTE1IDE6NTggQU0sIHdlbnh1IHdyb3RlOg0KPiA+ICAyMDIwLzEvMTUgNDo0
NiwgU2FlZWQgTWFoYW1lZWQgOg0KPiA+ID4gSGkgV2VueHUsDQo+ID4gPiANCj4gPiA+IEFjY29y
ZGluZyB0byBvdXIgcmVncmVzc2lvbiBUZWFtLCBUaGlzIGNvbW1pdCBpcyBicmVha2luZyB2eGxh
bg0KPiA+ID4gb2ZmbG9hZA0KPiA+ID4gQ0MnZWQgUGF1bCwgUm9pIGFuZCBWbGFkLCB0aGV5IHdp
bGwgYXNzaXN0IHlvdSBpZiB5b3UgbmVlZCBhbnkNCj4gPiA+IGhlbHAuDQo+ID4gPiANCj4gPiA+
IGNhbiB5b3UgcGxlYXNlIGludmVzdGlnYXRlIHRoZSBmb2xsb3dpbmcgY2FsbCB0cmFjZSA/DQo+
ID4gDQo+ID4gSGkgU2FlZWQgJiBQYXVsLA0KPiA+IA0KPiA+IA0KPiA+IFRoaXMgcGF0Y2gganVz
dCBjaGVjayB0aGUgbWV0YSBrZXkgbWF0Y2ggd2l0aCB0aGUgZmlsdGVyX2Rldi4gIElmDQo+ID4g
dGhpcyBtYXRjaCBmYWlsZWQsDQo+ID4gDQo+ID4gVGhlIG5ldyBmbG93ZXIgaW5zdGFsbCB3aWxs
IGZhaWxlZCBhbmQgbmV2ZXIgYWxsb2NhdGUgbmV3DQo+ID4gbWx4NV9mc19mdGVzLg0KPiA+IA0K
PiA+IEhvdyBjYW4gSSByZXByb2R1Y2UgdGhpcyBjYXNlPyBDYW4geW91IHByb3ZpZGUgdGhlIHRl
c3QgY2FzZQ0KPiA+IHNjcmlwdD8NCj4gPiANCj4gPiANCj4gPiBCUg0KPiA+IA0KPiA+IHdlbnh1
DQo+IA0KPiBIaSBTYWVlZCwgV2VueHUsDQo+IA0KPiBJIHJldmlld2VkIHRoZSBwYXRjaCBhbmQg
dmVyaWZpZWQgbWFudWFsbHkganVzdCBpbiBjYXNlLiBTdWNoIGlzc3VlDQo+IHNob3VsZA0KPiBu
b3QgYmUgcmVwcm9kdWNlZCBmcm9tIHRoaXMgcGF0Y2ggYW5kIGluZGVlZCBJIGRpZCBub3QgcmVw
cm9kdWNlIGl0Lg0KPiBJJ2xsIHRha2UgdGhlIGlzc3VlIHdpdGggb3VyIHJlZ3Jlc3Npb24gdGVh
bS4NCj4gSSBhY2tlZCB0aGUgcGF0Y2guIGxvb2tzIGdvb2QgdG8gbWUuDQo+IA0KPiBUaGFua3Ms
DQo+IFJvaQ0KPiANCj4gDQoNCg0KVGhhbmtzIFJvaSwgDQoNCklmIHRoZSBkaXNjdXNzaW9uIGlz
IG92ZXIgYW5kIHlvdSBhY2sgdGhlIHBhdGNoLCBwbGVhc2UgcHJvdmlkZSBhDQpmb3JtYWwgIkFj
a2VkLWJ5IiB0YWcgc28gaSB3aWxsIHB1bGwgdGhpcyBwYXRjaCBpbnRvIG5ldC1uZXh0LW1seDUu
DQoNClRoYW5rcywNClNhZWVkLg0KDQo=
