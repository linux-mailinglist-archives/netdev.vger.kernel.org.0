Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD34416B5A7
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 00:33:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728316AbgBXXdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 18:33:06 -0500
Received: from mail-vi1eur05on2069.outbound.protection.outlook.com ([40.107.21.69]:27980
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726651AbgBXXdF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Feb 2020 18:33:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fugnVVRf+hA70+f+xQa/eb0mvvDsIx/rEZGq95JoIsAXIV79iM6H1p4i+aBQSPS8Pqp8bCXbP+EdHXkosT+GLSf3l61LAdASmmD6EBzC6ZMF4uKBrueXOapffGHsNdPwEaFLu2x6ptoKThnKALVImKY4X4ptDd1LOqXOSkhfMpxhk4SC+D+6d7Z8TgCVBMXLvXRhKhrRAEizkU1k4rhLuuXbPdLPQ6NIJi/J7DC5B3fSuEBo0Y5pNjU4d9l5Y5dwGz+p6fXV4zsFSYisokZ3xMJQYCbSR9G9HdXkYiPtdbIg2pWXI0CWAeBqHvHKQOJ9Jd7g4o055XWho6rpiF+How==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hJZzkpriBSZitEhJSb1pxW7f5nY0ByDJzDPV+5EIMDk=;
 b=S9Y40PiCb2/fv3L0Uh8Y4QtpSiTyzLEV2B2IUwILhnvgnBkqDHUGMNA+Zgtfcjba1QR0OPJoBdFSl10wnbKLUBF1IKBdFh+PdMdVuEdEhEUtoulrscanOrfTgL8eeNikQImiNL+akJSQK2vAz7QuFdoV7FktKjRF0JxLFog6yAAyu6kyYhBS3CuedU/VI9qSkgWCpQlUwLQRcj93jy3IDMy7DR0WY57I54Gynrqn1lCr8eJgp6uK8OS42BzQ+F70bLnSmG7K9YUzMFhgw+F+tcRa0QI/HfMXM6w3ej6Tc1oECoqspbtqHZ933cBKYJ1kjbHIJBHuMJl3dBNLN3YfXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hJZzkpriBSZitEhJSb1pxW7f5nY0ByDJzDPV+5EIMDk=;
 b=mY2CEG00v4QWMg2o+vhmSKAtbc668qU4wlcUf3JTsk40FEHzScur5fDipPW0c0xakHU/IG2oGfceByYPbb1UbLTaKLSRYxYetLiFmOTnzCrVtJ0rAIgM4P9iURON7Uj5ePvh/RjkFMTL0l3nyMLpZggJIJpV1LHLD+/UYM4ilR0=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6304.eurprd05.prod.outlook.com (20.179.25.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.21; Mon, 24 Feb 2020 23:32:58 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2750.021; Mon, 24 Feb 2020
 23:32:58 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "yishaih@dev.mellanox.co.il" <yishaih@dev.mellanox.co.il>
CC:     Jason Gunthorpe <jgg@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "rosenbaumalex@gmail.com" <rosenbaumalex@gmail.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>
Subject: Re: [PATCH mlx5-next 1/2] net/mlx5: Expose raw packet pacing APIs
Thread-Topic: [PATCH mlx5-next 1/2] net/mlx5: Expose raw packet pacing APIs
Thread-Index: AQHV51eOx5+84+K2R0K/zzS76Ar13agmBOeAgAJ5y4CAAofKgA==
Date:   Mon, 24 Feb 2020 23:32:58 +0000
Message-ID: <df68bb933da1c20bbd1c131653895f9233249c9e.camel@mellanox.com>
References: <20200219190518.200912-1-leon@kernel.org>
         <20200219190518.200912-2-leon@kernel.org>
         <ea7589ad4d3f847f49e4b4f230cdc130ed4b83a8.camel@mellanox.com>
         <449186ce-c66f-a762-24c3-139c4ced3b1c@dev.mellanox.co.il>
In-Reply-To: <449186ce-c66f-a762-24c3-139c4ced3b1c@dev.mellanox.co.il>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e544a114-9144-417e-d69d-08d7b981e199
x-ms-traffictypediagnostic: VI1PR05MB6304:|VI1PR05MB6304:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6304207046F65968B5EB8642BEEC0@VI1PR05MB6304.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 032334F434
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(39860400002)(376002)(136003)(366004)(189003)(199004)(8676002)(6512007)(6862004)(316002)(54906003)(186003)(6506007)(26005)(5660300002)(53546011)(4326008)(2616005)(81166006)(71200400001)(81156014)(66446008)(2906002)(66946007)(76116006)(91956017)(64756008)(36756003)(8936002)(86362001)(66476007)(478600001)(6486002)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6304;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ir7NwBt+vAd0BDXzJ3ycPaRgG/utSWA36zYBLh7zrnrQTR3GVZ46ObXujIOirYGrx8Jdykr6cvSU7rcUQsmR+xQ8IrTpW8aRM/twTk4vOBZfI9Vsgz4noV16ZWz8oGEOFiOPmL5WUefSBiHkNTe2F93ba/5jf3Cp9dHTBOGL/lmJ99WKORYW1QSuIg7G1600xRNl5j7q8eBjMghdJGSTDbe2/ich5ccaZdP+3B/zD4FK5fKI7ISm1T6hHt4yj3oXjitW5oeVbAdzz9lV4n4nWe2FSe2j1UIAp7Zov4r/h3r9JC0Galcd3ZVh4rb0BJj/7VYqd01ZQ1UEI6c/c+fFiNRB5zJloWxbHMzMOiodVWZ/Pu8enKIS9PRLcMNIehkF6RQQiATvS9aO1AlioFyuqQYGLvMOvjdzccl5vQfiWPZ6X3YLiAKH6PmcAoXC0T7A
x-ms-exchange-antispam-messagedata: woFBPDoW+als8cMgBge4PcXdA2rNXFizTA6xa5Wwe6z5tcPx4Ez8fYWR5uFzKJxjUZAX8+kVPJ+YDCxV6ogSa6Uru+LwshyQbfK0WP31vMdPkviISi8u0OPseodCnHbkAyKPmzxulRnvwqwShuteOg==
Content-Type: text/plain; charset="utf-8"
Content-ID: <5A8C0B4E5F601242A469EC3BEE60E1E0@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e544a114-9144-417e-d69d-08d7b981e199
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2020 23:32:58.1860
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rw1bqhtWSyQp7TLZi5/sHUbTJuy89AkjIpXdEaGC6qStwucgQa3+CQg+zX7Z8WOsyXtfg7lnuJ/zAJHjW88B4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6304
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU3VuLCAyMDIwLTAyLTIzIGF0IDEwOjUzICswMjAwLCBZaXNoYWkgSGFkYXMgd3JvdGU6DQo+
IE9uIDIvMjEvMjAyMCA5OjA0IFBNLCBTYWVlZCBNYWhhbWVlZCB3cm90ZToNCj4gPiBPbiBXZWQs
IDIwMjAtMDItMTkgYXQgMjE6MDUgKzAyMDAsIExlb24gUm9tYW5vdnNreSB3cm90ZToNCj4gPiA+
IEZyb206IFlpc2hhaSBIYWRhcyA8eWlzaGFpaEBtZWxsYW5veC5jb20+DQo+ID4gPiANCj4gPiA+
IEV4cG9zZSByYXcgcGFja2V0IHBhY2luZyBBUElzIHRvIGJlIHVzZWQgYnkgREVWWCBiYXNlZA0K
PiA+ID4gYXBwbGljYXRpb25zLg0KPiA+ID4gVGhlIGV4aXN0aW5nIGNvZGUgd2FzIHJlZmFjdG9y
ZWQgdG8gaGF2ZSBhIHNpbmdsZSBmbG93IHdpdGggdGhlDQo+ID4gPiBuZXcNCj4gPiA+IHJhdw0K
PiA+ID4gQVBJcy4NCj4gPiA+IA0KPiA+ID4gVGhlIG5ldyByYXcgQVBJcyBjb25zaWRlcmVkIHRo
ZSBpbnB1dCBvZiAncHBfcmF0ZV9saW1pdF9jb250ZXh0JywNCj4gPiA+IHVpZCwNCj4gPiA+ICdk
ZWRpY2F0ZWQnLCB1cG9uIGxvb2tpbmcgZm9yIGFuIGV4aXN0aW5nIGVudHJ5Lg0KPiA+ID4gDQo+
ID4gPiBUaGlzIHJhdyBtb2RlIGVuYWJsZXMgZnV0dXJlIGRldmljZSBzcGVjaWZpY2F0aW9uIGRh
dGEgaW4gdGhlIHJhdw0KPiA+ID4gY29udGV4dCB3aXRob3V0IGNoYW5naW5nIHRoZSBleGlzdGlu
ZyBsb2dpYyBhbmQgY29kZS4NCj4gPiA+IA0KPiA+ID4gVGhlIGFiaWxpdHkgdG8gYXNrIGZvciBh
IGRlZGljYXRlZCBlbnRyeSBnaXZlcyBjb250cm9sIGZvcg0KPiA+ID4gYXBwbGljYXRpb24NCj4g
PiA+IHRvIGFsbG9jYXRlIGVudHJpZXMgYWNjb3JkaW5nIHRvIGl0cyBuZWVkcy4NCj4gPiA+IA0K
PiA+ID4gQSBkZWRpY2F0ZWQgZW50cnkgbWF5IG5vdCBiZSB1c2VkIGJ5IHNvbWUgb3RoZXIgcHJv
Y2VzcyBhbmQgaXQNCj4gPiA+IGFsc28NCj4gPiA+IGVuYWJsZXMgdGhlIHByb2Nlc3Mgc3ByZWFk
aW5nIGl0cyByZXNvdXJjZXMgdG8gc29tZSBkaWZmZXJlbnQNCj4gPiA+IGVudHJpZXMNCj4gPiA+
IGZvciB1c2UgZGlmZmVyZW50IGhhcmR3YXJlIHJlc291cmNlcyBhcyBwYXJ0IG9mIGVuZm9yY2lu
ZyB0aGUNCj4gPiA+IHJhdGUuDQo+ID4gPiANCj4gPiANCj4gPiBJdCBzb3VuZHMgbGlrZSB0aGUg
ZGVkaWNhdGVkIG1lYW5zICJubyBzaGFyaW5nIiB3aGljaCBtZWFucyB5b3UNCj4gPiBkb24ndA0K
PiA+IG5lZWQgdG8gdXNlIHRoZSBtbHg1X2NvcmUgQVBJIGFuZCB5b3UgY2FuIGdvIGRpcmVjdGx5
IHRvIEZXLi4gVGhlDQo+ID4gcHJvYmxlbSBpcyB0aGF0IHRoZSBlbnRyeSBpbmRpY2VzIGFyZSBt
YW5hZ2VkIGJ5IGRyaXZlciwgYW5kIGkNCj4gPiBndWVzcw0KPiA+IHRoaXMgaXMgdGhlIHJlYXNv
biB3aHkgeW91IGhhZCB0byBleHBhbmQgdGhlIG1seDVfY29yZSBBUEkuLg0KPiA+IA0KPiANCj4g
VGhlIG1haW4gcmVhc29uIGZvciBpbnRyb2R1Y2luZyB0aGUgbmV3IG1seDVfY29yZSBBUElzIHdh
cyB0aGUgbmVlZA0KPiB0byANCj4gc3VwcG9ydCB0aGUgInNoYXJlZCBtb2RlIiBpbiBhICJyYXcg
ZGF0YSIgZm9ybWF0IHRvIHByZXZlbnQgZnV0dXJlIA0KPiB0b3VjaGluZyB0aGUga2VybmVsIG9u
Y2UgUFJNIHdpbGwgc3VwcG9ydCBleHRyYSBmaWVsZHMuDQo+IEFzIHRoZSBSTCBpbmRpY2VzIGFy
ZSBtYW5hZ2VkIGJ5IHRoZSBkcml2ZXIgKG1seDVfY29yZSkgaW5jbHVkaW5nDQo+IHRoZSANCj4g
c2hhcmluZywgd2UgY291bGRu4oCZdCBnbyBkaXJlY3RseSB0byBGVywgdGhlIGxlZ2FjeSBBUEkg
d2FzDQo+IHJlZmFjdG9yZWQgDQo+IGluc2lkZSB0aGUgY29yZSB0byBoYXZlIG9uZSBmbG93IHdp
dGggdGhlIG5ldyByYXcgQVBJcy4NCj4gU28gd2UgbWF5IG5lZWQgdGhvc2UgQVBJcyByZWdhcmRs
ZXNzIHRoZSBkZWRpY2F0ZWQgbW9kZS4NCj4gDQoNCkkgbm90IGEgZmFuIG9mIGxlZ2FjeSBBUElz
LCBhbGwgb2YgdGhlIEFQSXMgYXJlIG1seDUgaW50ZXJuYWxzIGFuZCBpDQp3b3VsZCBsaWtlIHRv
IGtlZXAgb25lIEFQSSB3aGljaCBpcyBvbmx5IFBSTSBkZXBlbmRlbnQgYXMgbXVjaCBhcw0KcG9z
c2libGUuDQoNCkFueXdheSB0aGFua3MgZm9yIHRoZSBjbGFyaWZpY2F0aW9uLCBpIHRoaW5rIHRo
ZSBwYXRjaCBpcyBnb29kIGFzIGlzLA0Kd2UgY2FuIGltcHJvdmUgYW5kIHJlbW92ZSB0aGUgbGVn
YWN5IEFQSSBpbiB0aGUgZnV0dXJlIGFuZCBrZWVwIHRoZSByYXcNCkFQSS4NCg0KPiANCj4gPiBJ
IHdvdWxkIGxpa2UgdG8gc3VnZ2VzdCBzb21lIGFsdGVybmF0aXZlcyB0byBzaW1wbGlmeSB0aGUg
YXBwcm9hY2gNCj4gPiBhbmQNCj4gPiBhbGxvdyB1c2luZyBSQVcgUFJNIGZvciBERVZYIHByb3Bl
cmx5Lg0KPiA+IA0KPiA+IDEuIHByZXNlcnZlIFJMIGVudHJpZXMgZm9yIERFVlggYW5kIGxldCBE
RVZYIGFjY2VzcyBGVyBkaXJlY3RseQ0KPiA+IHdpdGgNCj4gPiBQUk0gY29tbWFuZHMuDQo+ID4g
Mi4ga2VlcCBtbHg1X2NvcmUgQVBJIHNpbXBsZSBhbmQgaW5zdGVhZCBvZiBhZGRpbmcgdGhpcyBy
YXcvbm9uIHJhdw0KPiA+IGFwaQ0KPiA+IGFuZCBjb21wbGljYXRpbmcgdGhlIFJMIEFQSSB3aXRo
IHRoaXMgZGVkaWNhdGVkIGJpdDoNCj4gPiANCj4gPiBqdXN0IGFkZCBtbHg1X3JsX3thbGxvYy9m
cmVlfV9pbmRleCgpLCB0aGlzIHdpbGwgZGVkaWNhdGUgZm9yIHlvdQ0KPiA+IHRoZQ0KPiA+IFJM
IGluZGV4IGZvcm0gdGhlIGVuZCBvZiB0aGUgUkwgaW5kaWNlcyBkYXRhYmFzZSBhbmQgeW91IGFy
ZSBmcmVlDQo+ID4gdG8NCj4gPiBhY2Nlc3MgdGhlIEZXIHdpdGggdGhpcyBpbmRleCB0aGUgd2F5
IHlvdSBsaWtlIHZpYSBkaXJlY3QgUFJNDQo+ID4gY29tbWFuZHMuDQo+ID4gDQo+IEFzIG1lbnRp
b25lZCBhYm92ZSwgd2UgbWF5IHN0aWxsIG5lZWQgdGhlIG5ldyBtbHg1X2NvcmUgcmF3IEFQSXMg
Zm9yDQo+IHRoZSANCj4gc2hhcmVkIG1vZGUgd2hpY2ggaXMgdGhlIG1haW4gdXNhZ2Ugb2YgdGhl
IEFQSSwgd2UgZm91bmQgaXQNCj4gcmVhc29uYWJsZSANCj4gdG8gaGF2ZSB0aGUgZGVkaWNhdGUg
ZmxhZyBpbiB0aGUgbmV3IHJhdyBhbGxvYyBBUEkgaW5zdGVhZCBvZg0KPiBleHBvc2luZyANCj4g
bW9yZSB0d28gbmV3IEFQSXMgb25seSBmb3IgdGhhdC4NCj4gDQo+IFBsZWFzZSBub3RlIHRoYXQg
ZXZlbiBpZiB3ZSdsbCBnbyB3aXRoIHRob3NlIDIgZXh0cmEgQVBJcyBmb3IgdGhlIA0KPiBkZWRp
Y2F0ZWQgbW9kZSwgd2UgbWF5IHN0aWxsIG5lZWQgdG8gbWFpbnRhaW4gaW4gdGhlIGNvcmUgdGhp
cyANCj4gaW5mb3JtYXRpb24gdG8gcHJldmVudCByZXR1cm5pbmcgdGhpcyBlbnRyeSBmb3Igb3Ro
ZXIgY2FzZXMuDQo+IA0KPiBBbHNvIHRoZSBpZGVhIHRvIHByZXNlcnZlIHNvbWUgZW50cmllcyBh
dCB0aGUgZW5kIG1pZ2h0IGJlIHdhc3RlZnVsDQo+IGFzIA0KPiB0aGVyZSBpcyBubyBndWFyYW50
ZWUgdGhhdCBERVZYIHdpbGwgcmVhbGx5IGJlIHVzZWQsIGFuZCBldmVuIHNvIGl0DQo+IG1heSAN
Cj4gbm90IGFzayBmb3IgZW50cmllcyBpbiBhIGRlZGljYXRlZCBtb2RlLg0KPiANCj4gUHJlc2Vy
aW5nIHRoZW0gZm9yIHRoaXMgb3B0aW9uYWwgdXNlIGNhc2UgbWlnaHQgcHJldmVudCB1c2luZyB0
aGVtDQo+IGZvciANCj4gYWxsIG90aGVyIGNhc2VzLg0KPiANCj4gDQo+ID4gPiBUaGUgY291bnRl
ciBwZXIgZW50cnkgbWFzIGNoYW5nZWQgdG8gYmUgdTY0IHRvIHByZXZlbnQgYW55IG9wdGlvbg0K
PiA+ID4gdG8NCj4gPiAgICAgICAgICAgICAgICAgICAgIHR5cG8gXl5eIHdhcw0KPiANCj4gU3Vy
ZSwgdGhhbmtzLg0KPiANCg0KTGVvbiwgT3RoZXIgdGhhbiB0aGUgdHlwbyBpIGFtIGdvb2Qgd2l0
aCB0aGlzIHBhdGNoLg0KeW91IGNhbiBmaXggdXAgdGhlIHBhdGNoIHByaW9yIHRvIHB1bGxpbmcg
aW50byBtbHg1LW5leHQsIG5vIG5lZWQgZm9yDQp2Mi4NCg0KQWNrZWQtYnk6IFNhZWVkIE1haGFt
ZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPiANCg0KDQp0aGFua3MsDQpTYWVlZC4NCg0K
