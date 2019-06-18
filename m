Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 123704AA57
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 20:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730469AbfFRSvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 14:51:51 -0400
Received: from mail-eopbgr00071.outbound.protection.outlook.com ([40.107.0.71]:58242
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730268AbfFRSvu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 14:51:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=31v47k/6chRyBn2sKf+SxhaQIZeC1jcTfvrLvnRGLSY=;
 b=Gj4/L2yVoHHmzrhsNAiFlr0bstKRLRoI68q4YXhbKU1KVUg/b+7VZnJVtak88A7xrNKCImQlLIbo/O1iJZpx85LG1a6dTFMTnOAXif/0x9mN2BDZ6vozjx633lMVqryalM9+3/jqTv/DMwiSp0hunwDwxAgGriWuEzLPt2kWTy0=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2472.eurprd05.prod.outlook.com (10.168.77.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.12; Tue, 18 Jun 2019 18:51:45 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.1987.014; Tue, 18 Jun 2019
 18:51:45 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Jason Gunthorpe <jgg@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>
CC:     Yishai Hadas <yishaih@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Leon Romanovsky <leonro@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH rdma-next v1 00/12] DEVX asynchronous events
Thread-Topic: [PATCH rdma-next v1 00/12] DEVX asynchronous events
Thread-Index: AQHVJfl5PSbKJXA400e2KA/0k+cTY6ahwcuA
Date:   Tue, 18 Jun 2019 18:51:45 +0000
Message-ID: <19107c92279cf4ad4d870fa54514423c5e46b748.camel@mellanox.com>
References: <20190618171540.11729-1-leon@kernel.org>
In-Reply-To: <20190618171540.11729-1-leon@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.2 (3.32.2-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 206cc886-4f95-4ef3-a485-08d6f41e0303
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2472;
x-ms-traffictypediagnostic: DB6PR0501MB2472:
x-microsoft-antispam-prvs: <DB6PR0501MB24728F103EBE15B80BE93740BEEA0@DB6PR0501MB2472.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-forefront-prvs: 007271867D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(396003)(136003)(39860400002)(366004)(54534003)(199004)(189003)(6436002)(2501003)(76116006)(2201001)(99286004)(14454004)(86362001)(2906002)(3846002)(81166006)(8936002)(6486002)(91956017)(5660300002)(36756003)(81156014)(8676002)(53936002)(71190400001)(118296001)(68736007)(478600001)(71200400001)(6116002)(66556008)(14444005)(66476007)(66446008)(64756008)(256004)(73956011)(76176011)(305945005)(66066001)(7736002)(2616005)(102836004)(54906003)(58126008)(110136005)(476003)(486006)(316002)(229853002)(6506007)(6512007)(6246003)(26005)(186003)(4326008)(11346002)(446003)(66946007)(25786009);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2472;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: YoBnbA9GCCPK0rx+heowV++flQQZvOt3ubmOlX35A+qDcQ2dbbc5mLIgHmAHo04oEmC9ULqrd/GgFyKHU2B5cOYdYKdrVutU1ZgGNgrkDGKeIfYyxjWosj/JlcrTqsUPa1fZc096PqMaEetABYDPjFEgU5zxGxfE3iv3aOxndfxkE/KiPXJvw/Ijp8K/RBL6uKB/1qy1IuThDTLmsnQ1lWHXtdx+19bJ+KWalumIrlh9rxm0AciiIjerN4fLrChnnXQqcqwr9xNP41bIR4yWKJYuHIDWM3VXwtO9K8UQgE+bRWv8klWRMR3ZT1p+DE9IU6MGn0Y6aRRH/G6ukGRl4LKMs3WrlL3+dHe3D6DQ7mtqDv2YUNAk69ZVTopo7j53DamC3KQlJG9MtzJqUS5aRWJqxXg+D3vtEFET7Rm/d3Y=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FD5DA140C74B884991F6563B38619E98@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 206cc886-4f95-4ef3-a485-08d6f41e0303
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2019 18:51:45.4338
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2472
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTA2LTE4IGF0IDIwOjE1ICswMzAwLCBMZW9uIFJvbWFub3Zza3kgd3JvdGU6
DQo+IEZyb206IExlb24gUm9tYW5vdnNreSA8bGVvbnJvQG1lbGxhbm94LmNvbT4NCj4gDQo+IENo
YW5nZWxvZzoNCj4gIHYwIC0+IHYxOg0KDQpOb3JtYWxseSAxc3Qgc3VibWlzc2lvbiBpcyBWMSBh
bmQgMm5kIGlzIFYyLg0Kc28gdGhpcyBzaG91bGQgaGF2ZSBiZWVuIHYxLT52Mi4NCg0KRm9yIG1s
eDUtbmV4dCBwYXRjaGVzOg0KDQpBY2tlZC1ieTogU2FlZWQgTWFoYW1lZWQgPHNhZWVkbUBtZWxs
YW5veC5jb20+DQoNCg0KPiAgKiBGaXggdGhlIHVuYmluZCAvIGhvdCB1bnBsdWcgZmxvd3MgdG8g
d29yayBwcm9wZXJseS4NCj4gICogRml4IFJlZiBjb3VudCBoYW5kbGluZyBvbiB0aGUgZXZlbnRm
ZCBtb2RlIGluIHNvbWUgZmxvdy4NCj4gICogUmViYXNlZCB0byBsYXRlc3QgcmRtYS1uZXh0DQo+
IA0KPiBUaGFua3MNCj4gDQo+IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gLS0tLS0tLS0tLS0tLS0tLS0NCj4gRnJv
bSBZaXNoYWk6DQo+IA0KPiBUaGlzIHNlcmllcyBlbmFibGVzIFJETUEgYXBwbGljYXRpb25zIHRo
YXQgdXNlIHRoZSBERVZYIGludGVyZmFjZSB0bw0KPiBzdWJzY3JpYmUgYW5kIHJlYWQgZGV2aWNl
IGFzeW5jaHJvbm91cyBldmVudHMuDQo+IA0KPiBUaGUgc29sdXRpb24gaXMgZGVzaWduZWQgdG8g
YWxsb3cgZXh0ZW5zaW9uIG9mIGV2ZW50cyBpbiB0aGUgZnV0dXJlDQo+IHdpdGhvdXQgbmVlZCB0
byBwZXJmb3JtIGFueSBjaGFuZ2VzIGluIHRoZSBkcml2ZXIgY29kZS4NCj4gDQo+IFRvIGVuYWJs
ZSB0aGF0IGZldyBjaGFuZ2VzIGhhZCBiZWVuIGRvbmUgaW4gbWx4NV9jb3JlLCBpdCBpbmNsdWRl
czoNCj4gICogUmVhZGluZyBkZXZpY2UgZXZlbnQgY2FwYWJpbGl0aWVzIHRoYXQgYXJlIHVzZXIg
cmVsYXRlZA0KPiAgICAoYWZmaWxpYXRlZCBhbmQgdW4tYWZmaWxpYXRlZCkgYW5kIHNldCB0aGUg
bWF0Y2hpbmcgbWFzayB1cG9uDQo+ICAgIGNyZWF0aW5nIHRoZSBtYXRjaGluZyBFUS4NCj4gICog
RW5hYmxlIERFVlgvbWx4NV9pYiB0byByZWdpc3RlciBmb3IgQU5ZIGV2ZW50IGluc3RlYWQgb2Yg
dGhlDQo+IG9wdGlvbiB0bw0KPiAgICBnZXQgc29tZSBoYXJkLWNvZGVkIG9uZXMuDQo+ICAqIEVu
YWJsZSBERVZYL21seDVfaWIgdG8gZ2V0IHRoZSBkZXZpY2UgcmF3IGRhdGEgZm9yIENRIGNvbXBs
ZXRpb24NCj4gZXZlbnRzLg0KPiAgKiBFbmhhbmNlIG1seDVfY29yZV9jcmVhdGUvZGVzdHJveSBD
USB0byBlbmFibGUgREVWWCB1c2luZyB0aGVtIHNvDQo+IHRoYXQgQ1ENCj4gICAgZXZlbnRzIHdp
bGwgYmUgcmVwb3J0ZWQgYXMgd2VsbC4NCj4gDQo+IEluIG1seDVfaWIgbGF5ZXIgdGhlIGJlbG93
IGNoYW5nZXMgd2VyZSBkb25lOg0KPiAgKiBBIG5ldyBERVZYIEFQSSB3YXMgaW50cm9kdWNlZCB0
byBhbGxvY2F0ZSBhbiBldmVudCBjaGFubmVsIGJ5DQo+IHVzaW5nDQo+ICAgIHRoZSB1dmVyYnMg
RkQgb2JqZWN0IHR5cGUuDQo+ICAqIEltcGxlbWVudCB0aGUgRkQgY2hhbm5lbCBvcGVyYXRpb25z
IHRvIGVuYWJsZSByZWFkL3Bvby9jbG9zZSBvdmVyDQo+IGl0Lg0KPiAgKiBBIG5ldyBERVZYIEFQ
SSB3YXMgaW50cm9kdWNlZCB0byBzdWJzY3JpYmUgZm9yIHNwZWNpZmljIGV2ZW50cw0KPiBvdmVy
IGFuDQo+ICAgIGV2ZW50IGNoYW5uZWwuDQo+ICAqIE1hbmFnZSBhbiBpbnRlcm5hbCBkYXRhIHN0
cnVjdHVyZSAgb3ZlciBYQShzKSB0bw0KPiBzdWJzY3JpYmUvZGlzcGF0Y2ggZXZlbnRzDQo+ICAg
IG92ZXIgdGhlIGRpZmZlcmVudCBldmVudCBjaGFubmVscy4NCj4gICogVXNlIGZyb20gREVWWCB0
aGUgbWx4NV9jb3JlIEFQSXMgdG8gY3JlYXRlL2Rlc3Ryb3kgYSBDUSB0byBiZSBhYmxlDQo+IHRv
DQo+ICAgIGdldCBpdHMgcmVsZXZhbnQgZXZlbnRzLg0KPiANCj4gWWlzaGFpDQo+IA0KPiBZaXNo
YWkgSGFkYXMgKDEyKToNCj4gICBuZXQvbWx4NTogRml4IG1seDVfY29yZV9kZXN0cm95X2NxKCkg
ZXJyb3IgZmxvdw0KPiAgIG5ldC9tbHg1OiBVc2UgZXZlbnQgbWFzayBiYXNlZCBvbiBkZXZpY2Ug
Y2FwYWJpbGl0aWVzDQo+ICAgbmV0L21seDU6IEV4cG9zZSB0aGUgQVBJIHRvIHJlZ2lzdGVyIGZv
ciBBTlkgZXZlbnQNCj4gICBuZXQvbWx4NTogbWx4NV9jb3JlX2NyZWF0ZV9jcSgpIGVuaGFuY2Vt
ZW50cw0KPiAgIG5ldC9tbHg1OiBSZXBvcnQgYSBDUSBlcnJvciBldmVudCBvbmx5IHdoZW4gYSBo
YW5kbGVyIHdhcyBzZXQNCj4gICBuZXQvbWx4NTogUmVwb3J0IEVRRSBkYXRhIHVwb24gQ1EgY29t
cGxldGlvbg0KPiAgIG5ldC9tbHg1OiBFeHBvc2UgZGV2aWNlIGRlZmluaXRpb25zIGZvciBvYmpl
Y3QgZXZlbnRzDQo+ICAgSUIvbWx4NTogSW50cm9kdWNlIE1MWDVfSUJfT0JKRUNUX0RFVlhfQVNZ
TkNfRVZFTlRfRkQNCj4gICBJQi9tbHg1OiBSZWdpc3RlciBERVZYIHdpdGggbWx4NV9jb3JlIHRv
IGdldCBhc3luYyBldmVudHMNCj4gICBJQi9tbHg1OiBFbmFibGUgc3Vic2NyaXB0aW9uIGZvciBk
ZXZpY2UgZXZlbnRzIG92ZXIgREVWWA0KPiAgIElCL21seDU6IEltcGxlbWVudCBERVZYIGRpc3Bh
dGNoaW5nIGV2ZW50DQo+ICAgSUIvbWx4NTogQWRkIERFVlggc3VwcG9ydCBmb3IgQ1EgZXZlbnRz
DQo+IA0KPiAgZHJpdmVycy9pbmZpbmliYW5kL2h3L21seDUvY3EuYyAgICAgICAgICAgICAgIHwg
ICAgNSArLQ0KPiAgZHJpdmVycy9pbmZpbmliYW5kL2h3L21seDUvZGV2eC5jICAgICAgICAgICAg
IHwgMTA4Mg0KPiArKysrKysrKysrKysrKysrLQ0KPiAgZHJpdmVycy9pbmZpbmliYW5kL2h3L21s
eDUvbWFpbi5jICAgICAgICAgICAgIHwgICAxMCArLQ0KPiAgZHJpdmVycy9pbmZpbmliYW5kL2h3
L21seDUvbWx4NV9pYi5oICAgICAgICAgIHwgICAxMiArDQo+ICBkcml2ZXJzL2luZmluaWJhbmQv
aHcvbWx4NS9vZHAuYyAgICAgICAgICAgICAgfCAgICAzICstDQo+ICBkcml2ZXJzL2luZmluaWJh
bmQvaHcvbWx4NS9xcC5jICAgICAgICAgICAgICAgfCAgICAyICstDQo+ICBkcml2ZXJzL25ldC9l
dGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvY3EuYyAgfCAgIDIxICstDQo+ICBkcml2ZXJzL25l
dC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4uaCAgfCAgICAyICstDQo+ICAuLi4vbmV0
L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9tYWluLmMgfCAgICAzICstDQo+ICAuLi4v
bmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl90eHJ4LmMgfCAgICAyICstDQo+ICBk
cml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXEuYyAgfCAgIDY4ICstDQo+
ICAuLi4vZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2ZwZ2EvY29ubi5jICAgfCAgICA2ICst
DQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZncuYyAgfCAgICA2
ICsNCj4gIC4uLi9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2xpYi9lcS5oICB8ICAg
IDUgKy0NCj4gIGluY2x1ZGUvbGludXgvbWx4NS9jcS5oICAgICAgICAgICAgICAgICAgICAgICB8
ICAgIDYgKy0NCj4gIGluY2x1ZGUvbGludXgvbWx4NS9kZXZpY2UuaCAgICAgICAgICAgICAgICAg
ICB8ICAgIDYgKy0NCj4gIGluY2x1ZGUvbGludXgvbWx4NS9kcml2ZXIuaCAgICAgICAgICAgICAg
ICAgICB8ICAgIDIgKw0KPiAgaW5jbHVkZS9saW51eC9tbHg1L2VxLmggICAgICAgICAgICAgICAg
ICAgICAgIHwgICAgNCArLQ0KPiAgaW5jbHVkZS9saW51eC9tbHg1L21seDVfaWZjLmggICAgICAg
ICAgICAgICAgIHwgICAzNCArLQ0KPiAgaW5jbHVkZS91YXBpL3JkbWEvbWx4NV91c2VyX2lvY3Rs
X2NtZHMuaCAgICAgIHwgICAxOSArDQo+ICBpbmNsdWRlL3VhcGkvcmRtYS9tbHg1X3VzZXJfaW9j
dGxfdmVyYnMuaCAgICAgfCAgICA5ICsNCj4gIDIxIGZpbGVzIGNoYW5nZWQsIDEyMzcgaW5zZXJ0
aW9ucygrKSwgNzAgZGVsZXRpb25zKC0pDQo+IA0KPiAtLQ0KPiAyLjIwLjENCj4gDQo=
