Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF3ADDD0A0
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 22:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395425AbfJRUuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 16:50:55 -0400
Received: from mail-eopbgr40069.outbound.protection.outlook.com ([40.107.4.69]:63213
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728567AbfJRUuy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Oct 2019 16:50:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H4BftrAJJ0aKSoLGKXzVHJj0tuz2vZBjLmP+eh+imf0WKwaIOIe6AO8wdNl8QePigJqVCs2xvWCzFBji8rdc7fmG7lHLT8DX7pe5WGX6ca2LwrwaWUncxylR99iBAwV88L85x+pRkfGPlmNpM8v1hPavwJtAjhTj1r2rsFUlZd+FZY2g/tVTqcbdVSxzgNSKDpL2lqI3kc8X2Bm62Sy0iGkEWIFNcZoi2/alkNP55tdisuJK3PC67gy43q3hAkEeBCHe1KR9YR/O5p5Hr3fJnAkSEkvqPZKSQ2JeoQrwrfGkKECFjx2j1GFo1a43/IlengbQRoGgvArw1rLee8smdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qVdWlupKDAhV5zQelqG2SG1wOPwP+2mYlM18n+AuBQc=;
 b=RMcPpFegw+YTuZlaOAd7DHZBca2aRvmAj5TezZfavTZvi1emCHYnMsSG8QHLzlZSOuhld8VDTEyy7nfRO6Z6xCwA1PTAhXS9p+ItkTHa4n2gTh4hMWw91hLyJmK7WfqO88n8v0Kf+l7f2I2Ya+C+8p0Npz/V1DHfyRpl5M6qXPccJxA8eIdarGPvD6U80M0ob/wzE1OvqfYeq6M7SgHaUrn4JegDny803dWMhZadyU4pavYhv+a7SkIgCnVGn/OnpHD/S2TXAQoFSBYzx4Iq+mnhlBPRnAP/FkJja0FTKhTNgwHG9L6q6DZwS2GVTp0+0RTCmCQ8cL4/fOBEjnC/dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qVdWlupKDAhV5zQelqG2SG1wOPwP+2mYlM18n+AuBQc=;
 b=SKct2U+7gnmSsTNW/a0Kqsp4Y4hu/vk+IKlMj7XZAZhjFtKSZu093DyBQglReDRB9Sa8TzXywzVym3wQsjddrfr4Bb8KbYhsCWkeA7ep9NmVJy3Fb7MIIWeRTPFlWjTVXiJmrvzdd/76S9Ug4BCZe1PewL4g29bP7TsL09kbBuQ=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB3197.eurprd05.prod.outlook.com (10.170.239.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.22; Fri, 18 Oct 2019 20:50:47 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841%7]) with mapi id 15.20.2347.024; Fri, 18 Oct 2019
 20:50:47 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        "brouer@redhat.com" <brouer@redhat.com>
CC:     "kernel-team@fb.com" <kernel-team@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 00/10 net-next] page_pool cleanups
Thread-Topic: [PATCH 00/10 net-next] page_pool cleanups
Thread-Index: AQHVhHQsb02Xj+NegE6uf7PssTGj26dg4oMA
Date:   Fri, 18 Oct 2019 20:50:46 +0000
Message-ID: <1df61f9dedf2e26bbc94298cc2605002a4700ce6.camel@mellanox.com>
References: <20191016225028.2100206-1-jonathan.lemon@gmail.com>
In-Reply-To: <20191016225028.2100206-1-jonathan.lemon@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4c0b5b82-62ae-4ea0-7ed5-08d7540cda0e
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: VI1PR05MB3197:|VI1PR05MB3197:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB3197A329AC429A9586205D5BBE6C0@VI1PR05MB3197.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01949FE337
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(346002)(376002)(396003)(39860400002)(199004)(189003)(2906002)(118296001)(6436002)(81166006)(8936002)(478600001)(81156014)(71190400001)(6512007)(4326008)(102836004)(14444005)(8676002)(256004)(7736002)(99286004)(186003)(26005)(25786009)(71200400001)(14454004)(305945005)(36756003)(6506007)(6486002)(76176011)(316002)(110136005)(2501003)(6246003)(58126008)(486006)(3846002)(6116002)(476003)(2616005)(446003)(11346002)(76116006)(5660300002)(4001150100001)(229853002)(66946007)(66446008)(54906003)(64756008)(66476007)(86362001)(66556008)(66066001)(91956017);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3197;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ENLoTZAVbguEnRySmlsFdx57QS9WxOdx/xNUOmXHH9lEAPFI9Gtksx/ctZsd2xe6O5+PYDtxK/+0NivFHFpSJVGCrQsWskRcpen9Stm2uqSDlcEqkiWjnkL78fjtkavRVnlxmPN55RmccAnR5IZRKamLSEOnTrSJniGNkxRgsnjmgJGZhRpi8LvfVnRiMjMzPPQJhqrPLBCX4bowfDm53BEQqdHJOV6NEIsEuToDmJdXqEoGyQb1ktOFPLZQ+DJv00mOqsZZlFP9advRCkOqxaWkFurDjXMhG5vnL6fF3CU/gRA/w3YqAA4ZB3v2hXkWk8CxOkH6LzjgpytYqrLWCJCs1X+FAxJ/7AoB+tEnqxO83QUunra/iXcVn7m0cSRVC/1D9PAED5Lld0Wq5wStHVOMTjSfrbiDKClMDWHKL2A=
Content-Type: text/plain; charset="utf-8"
Content-ID: <598BF5DC8AB18A4D8F028D7C5201216C@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c0b5b82-62ae-4ea0-7ed5-08d7540cda0e
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2019 20:50:46.9569
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kQ/EPsfNCrYUApGB5k+EqtrsdeUFsLOyUIy//nKL1Qc199H5MYxYEjfTB2rhmfTFht3h14pCzXjjQqzUGLMM9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3197
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDE5LTEwLTE2IGF0IDE1OjUwIC0wNzAwLCBKb25hdGhhbiBMZW1vbiB3cm90ZToN
Cj4gVGhpcyBwYXRjaCBjb21iaW5lcyB3b3JrIGZyb20gdmFyaW91cyBwZW9wbGU6DQo+IC0gcGFy
dCBvZiBUYXJpcSdzIHdvcmsgdG8gbW92ZSB0aGUgRE1BIG1hcHBpbmcgZnJvbQ0KPiAgIHRoZSBt
bHg1IGRyaXZlciBpbnRvIHRoZSBwYWdlIHBvb2wuICBUaGlzIGRvZXMgbm90DQo+ICAgaW5jbHVk
ZSBsYXRlciBwYXRjaGVzIHdoaWNoIHJlbW92ZSB0aGUgZG1hIGFkZHJlc3MNCj4gICBmcm9tIHRo
ZSBkcml2ZXIsIGFzIHRoaXMgY29uZmxpY3RzIHdpdGggQUZfWERQLg0KPiANCj4gLSBTYWVlZCdz
IGNoYW5nZXMgdG8gY2hlY2sgdGhlIG51bWEgbm9kZSBiZWZvcmUNCj4gICBpbmNsdWRpbmcgdGhl
IHBhZ2UgaW4gdGhlIHBvb2wsIGFuZCBmbHVzaGluZyB0aGUNCj4gICBwb29sIG9uIGEgbm9kZSBj
aGFuZ2UuDQo+IA0KDQpIaSBKb25hdGhhbiwgdGhhbmtzIGZvciBzdWJtaXR0aW5nIHRoaXMsDQp0
aGUgcGF0Y2hlcyB5b3UgaGF2ZSBhcmUgbm90IHVwIHRvIGRhdGUsIGkgaGF2ZSBuZXcgb25lcyB3
aXRoIHRyYWNpbmcNCnN1cHBvcnQgYW5kIHNvbWUgZml4ZXMgZnJvbSBvZmZsaXN0IHJldmlldyBp
dGVyYXRpb25zLCBwbHVzIHBlcmZvcm1hbmNlDQpudW1iZXJzIGFuZCBhICBjb3ZlciBsZXR0ZXIu
IA0KDQpJIHdpbGwgc2VuZCBpdCB0byB5b3UgYW5kIHlvdSBjYW4gcG9zdCBpdCBhcyB2MiA/IA0K
DQoNCj4gLSBTdGF0aXN0aWNzIGFuZCBjbGVhbnVwIGZvciBwYWdlIHBvb2wuDQo+IA0KPiBKb25h
dGhhbiBMZW1vbiAoNSk6DQo+ICAgcGFnZV9wb29sOiBBZGQgcGFnZV9wb29sX2tlZXBfcGFnZQ0K
PiAgIHBhZ2VfcG9vbDogYWxsb3cgY29uZmlndXJhYmxlIGxpbmVhciBjYWNoZSBzaXplDQo+ICAg
cGFnZV9wb29sOiBBZGQgc3RhdGlzdGljcw0KPiAgIG5ldC9tbHg1OiBBZGQgcGFnZV9wb29sIHN0
YXRzIHRvIHRoZSBNZWxsYW5veCBkcml2ZXINCj4gICBwYWdlX3Bvb2w6IENsZWFudXAgYW5kIHJl
bmFtZSBwYWdlX3Bvb2wgZnVuY3Rpb25zLg0KPiANCj4gU2FlZWQgTWFoYW1lZWQgKDIpOg0KPiAg
IHBhZ2VfcG9vbDogQWRkIEFQSSB0byB1cGRhdGUgbnVtYSBub2RlIGFuZCBmbHVzaCBwYWdlIGNh
Y2hlcw0KPiAgIG5ldC9tbHg1ZTogUngsIFVwZGF0ZSBwYWdlIHBvb2wgbnVtYSBub2RlIHdoZW4g
Y2hhbmdlZA0KPiANCj4gVGFyaXEgVG91a2FuICgzKToNCj4gICBuZXQvbWx4NWU6IFJYLCBSZW1v
dmUgUlggcGFnZS1jYWNoZQ0KPiAgIG5ldC9tbHg1ZTogUlgsIE1hbmFnZSBSWCBwYWdlcyBvbmx5
IHZpYSBwYWdlIHBvb2wgQVBJDQo+ICAgbmV0L21seDVlOiBSWCwgSW50ZXJuYWwgRE1BIG1hcHBp
bmcgaW4gcGFnZV9wb29sDQo+IA0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4
NS9jb3JlL2VuLmggIHwgIDE4ICstDQo+ICAuLi4vbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUv
Y29yZS9lbi94ZHAuYyAgfCAgMTIgKy0NCj4gIC4uLi9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4
NS9jb3JlL2VuX21haW4uYyB8ICAxOSArLQ0KPiAgLi4uL25ldC9ldGhlcm5ldC9tZWxsYW5veC9t
bHg1L2NvcmUvZW5fcnguYyAgIHwgMTI4ICsrLS0tLS0tLS0NCj4gIC4uLi9ldGhlcm5ldC9tZWxs
YW5veC9tbHg1L2NvcmUvZW5fc3RhdHMuYyAgICB8ICAzOSArKy0tDQo+ICAuLi4vZXRoZXJuZXQv
bWVsbGFub3gvbWx4NS9jb3JlL2VuX3N0YXRzLmggICAgfCAgMTkgKy0NCj4gIGluY2x1ZGUvbmV0
L3BhZ2VfcG9vbC5oICAgICAgICAgICAgICAgICAgICAgICB8IDIxNiArKysrKysrKystLS0tLS0t
DQo+IC0NCj4gIG5ldC9jb3JlL3BhZ2VfcG9vbC5jICAgICAgICAgICAgICAgICAgICAgICAgICB8
IDIyMSArKysrKysrKysrKy0tLS0tDQo+IC0tDQo+ICA4IGZpbGVzIGNoYW5nZWQsIDMxOSBpbnNl
cnRpb25zKCspLCAzNTMgZGVsZXRpb25zKC0pDQo+IA0K
