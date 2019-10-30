Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51E9BEA6B3
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 23:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727866AbfJ3WuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 18:50:13 -0400
Received: from mail-eopbgr10082.outbound.protection.outlook.com ([40.107.1.82]:34634
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727852AbfJ3WuM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Oct 2019 18:50:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HuTRno2CR13h+SO1B8KABwIoB0NA/gSe8ZAPw50C10Qah3iYufTngXnb+HZZ0O2NOOE82YTLCox9yldOiXvgfhqxyYbze/Pl82MRbaK4f8A8Bm9LTLaXE7y9OlMn1TV9r9deL0dwSU956aMOpWY7768dJQlmQr9aTdOxyWWVRyUxbJdKr9Am4xpcSItrIpbMnTcRZFDMXlDU/JDyWvx1S9LQLHhN2EJN0Diw6BwTBVDNUYUdpBjpUf7RPbJCyFLmp7ht4rLbVt/wkQDUJ0GVmoe5omQhXb2sg+4fpWKwF5Z0hvdc29tLQlnnmsXVQJ+DfiUBc6W16tJHc1KYApb2uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9lJ9nlVFDXF3p6qYTd9q91t0qMVGZicpI3eCQ/ZA3eY=;
 b=LHHGLUhyNUoFcw9DHXefvuSIYH2+EHSZL8u+iPZnxwgbw8M2C0OZhDE1acHnTQg/tBkfl9D0dC3lKnwarjNOXHnuFTePhOF0NGGtX+lxhO7Vpc0uMyJcr4POz/EG1QbqfPQ0Mhs5S2+WAbPYPHC5py7Gq8Ninp3i89/L4MgCnGosLkXhzSjRyHmV4SGW9AKM4dEsqJ0ROadxfYrE7A+QeITct8MZ7ZN7YDx5SibZksXhNQuXOCF9Ic7SI3s1xhMT+jqlt8B1s0KngsDcEa4H5Aec/8LS4FngmUcPkxmRk2YWgQSw0vsOBTB8s2iWJ/JLQaZ0yqyrw8l7nGKlDq5VWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9lJ9nlVFDXF3p6qYTd9q91t0qMVGZicpI3eCQ/ZA3eY=;
 b=MAQIUnRbqQhKkUtbkaXgeJhHxTkUza5pRj2/BxyUHJ2v3/F8gSwYxev5u3ogegeyC7/YV+VRYsU/I1xKoN5WvXJItvPkugr886jd51O73sTySRPpzOD9srTMio6ua6UNySntktOOApzqetyw8ERWU6bLBJPyvL285ArgWuXbBcA=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5886.eurprd05.prod.outlook.com (20.178.127.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.17; Wed, 30 Oct 2019 22:50:06 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2387.027; Wed, 30 Oct 2019
 22:50:06 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Ariel Levkovich <lariel@mellanox.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>
CC:     "dsahern@gmail.com" <dsahern@gmail.com>,
        "sbrivio@redhat.com" <sbrivio@redhat.com>,
        "nikolay@cumulusnetworks.com" <nikolay@cumulusnetworks.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "gerlitz.or@gmail.com" <gerlitz.or@gmail.com>,
        "sd@queasysnail.net" <sd@queasysnail.net>,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH net-next 2/3] net: Add SRIOV VGT+ support
Thread-Topic: [PATCH net-next 2/3] net: Add SRIOV VGT+ support
Thread-Index: AQHVj2LdKsgfGbOxW0WpT6jm8LtwB6dztO8AgAAVCAA=
Date:   Wed, 30 Oct 2019 22:50:06 +0000
Message-ID: <89b961d92baebe8a2a541d2eb9ff3e1d9e9ddb52.camel@mellanox.com>
References: <1572468274-30748-1-git-send-email-lariel@mellanox.com>
         <1572468274-30748-3-git-send-email-lariel@mellanox.com>
         <20191030143438.00b3ce1a@cakuba.netronome.com>
In-Reply-To: <20191030143438.00b3ce1a@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b72886ce-3211-425a-c9d2-08d75d8b8233
x-ms-traffictypediagnostic: VI1PR05MB5886:|VI1PR05MB5886:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB58867FB5F2FBB9310945B2EFBE600@VI1PR05MB5886.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02065A9E77
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(346002)(39860400002)(376002)(366004)(189003)(199004)(478600001)(107886003)(71200400001)(14454004)(305945005)(2501003)(71190400001)(6512007)(4326008)(91956017)(7736002)(76116006)(66946007)(66066001)(6436002)(14444005)(256004)(6486002)(316002)(6246003)(54906003)(58126008)(36756003)(186003)(26005)(11346002)(6506007)(8936002)(2616005)(2906002)(99286004)(110136005)(76176011)(81166006)(81156014)(5660300002)(66556008)(3846002)(64756008)(86362001)(486006)(476003)(66446008)(229853002)(118296001)(66476007)(25786009)(102836004)(8676002)(4001150100001)(6116002)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5886;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cCqm2fB7XfBMEwBPUmKf3+XT6sTt1wH++m7zTWdg03iowUIcNPE7A0+2CZXwro9MgYi+j0TcAtchqVo/4LI1YvilMyZqFdPz2Vr/83tg4E3uCvdy60l+wjHnFq7cFQCYCI1nQdaD0VKRWx1N8IqD08o0HX1sEl5QMBLqLr4wGEqOylaAWHwK82pQoY+kGMwacJ6oyL7VxwDkPXbbHFi1JSxhyEy+nWrNBxZ+amYC5Q7x258GDxDpeZhfq1GMd9+TciaQUBpZt5qoqVDAKpvVSlQatDm0I0XIFlKarIskYvblQxf6j0SPWh3fau074VpO9VIZuyKDeVOPzmWiEePo1FgMRjUQuprGkFh7npzu8lmOYWtTN8nwZUAnxN8gBbW8pxH7gHr8NKYbKLsAEzaG5GYmrCxQiJYkxzZzRmenYl//aLCDG8zKzuD/gMRxmOz3
Content-Type: text/plain; charset="utf-8"
Content-ID: <D700D864C6E76B43842816B0643F58DA@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b72886ce-3211-425a-c9d2-08d75d8b8233
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2019 22:50:06.1414
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j0xqRqd+28G+olezQUsZV2KvD0PxRzcqe+Vzwv5UuF+kHH46nb98L+Ap4xjUqpbBbtC2xIpHovrj5hP3azT8ag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5886
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDE5LTEwLTMwIGF0IDE0OjM0IC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gV2VkLCAzMCBPY3QgMjAxOSAyMDo0NDo0NCArMDAwMCwgQXJpZWwgTGV2a292aWNoIHdy
b3RlOg0KPiA+IFZHVCsgaXMgYSBzZWN1cml0eSBmZWF0dXJlIHRoYXQgZ2l2ZXMgdGhlIGFkbWlu
aXN0cmF0b3IgdGhlIGFiaWxpdHkNCj4gPiBvZg0KPiA+IGNvbnRyb2xsaW5nIHRoZSBhbGxvd2Vk
IHZsYW4taWRzIGxpc3QgdGhhdCBjYW4gYmUNCj4gPiB0cmFuc21pdHRlZC9yZWNlaXZlZA0KPiA+
IGZyb20vdG8gdGhlIFZGLg0KPiA+IFRoZSBhbGxvd2VkIHZsYW4taWRzIGxpc3QgaXMgY2FsbGVk
ICJ0cnVuayIuDQo+ID4gQWRtaW4gY2FuIGFkZC9yZW1vdmUgYSByYW5nZSBvZiBhbGxvd2VkIHZs
YW4taWRzIHZpYSBpcHRvb2wuDQo+ID4gRXhhbXBsZToNCj4gPiBBZnRlciB0aGlzIHNlcmllcyBv
ZiBjb25maWd1cmF0aW9uIDoNCj4gPiAxKSBpcCBsaW5rIHNldCBldGgzIHZmIDAgdHJ1bmsgYWRk
IDEwIDEwMCAoYWxsb3cgdmxhbi1pZCAxMC0xMDAsDQo+ID4gZGVmYXVsdCB0cGlkIDB4ODEwMCkN
Cj4gPiAyKSBpcCBsaW5rIHNldCBldGgzIHZmIDAgdHJ1bmsgYWRkIDEwNSBwcm90byA4MDIuMXEg
KGFsbG93IHZsYW4taWQNCj4gPiAxMDUgdHBpZCAweDgxMDApDQo+ID4gMykgaXAgbGluayBzZXQg
ZXRoMyB2ZiAwIHRydW5rIGFkZCAxMDUgcHJvdG8gODAyLjFhZCAoYWxsb3cgdmxhbi1pZCANCj4g
PiAxMDUgdHBpZCAweDg4YTgpDQo+ID4gNCkgaXAgbGluayBzZXQgZXRoMyB2ZiAwIHRydW5rIHJl
bSA5MCAoYmxvY2sgdmxhbi1pZCA5MCkNCj4gPiA1KSBpcCBsaW5rIHNldCBldGgzIHZmIDAgdHJ1
bmsgcmVtIDUwIDYwIChibG9jayB2bGFuLWlkcyA1MC02MCkNCj4gPiANCj4gPiBUaGUgVkYgMCBj
YW4gb25seSBjb21tdW5pY2F0ZSBvbiB2bGFuLWlkczogMTAtNDksNjEtODksOTEtMTAwLDEwNQ0K
PiA+IHdpdGgNCj4gPiB0cGlkIDB4ODEwMCBhbmQgdmxhbi1pZCAxMDUgd2l0aCB0cGlkIDB4ODhh
OC4NCj4gPiANCj4gPiBGb3IgdGhpcyBwdXJwb3NlIHdlIGFkZGVkIHRoZSBmb2xsb3dpbmcgbmV0
bGluayBzci1pb3YgY29tbWFuZHM6DQo+ID4gDQo+ID4gMSkgSUZMQV9WRl9WTEFOX1JBTkdFOiB1
c2VkIHRvIGFkZC9yZW1vdmUgYWxsb3dlZCB2bGFuLWlkcyByYW5nZS4NCj4gPiBXZSBhZGRlZCB0
aGUgaWZsYV92Zl92bGFuX3JhbmdlIHN0cnVjdCB0byBzcGVjaWZ5IHRoZSByYW5nZSB3ZSB3YW50
DQo+ID4gdG8NCj4gPiBhZGQvcmVtb3ZlIGZyb20gdGhlIHVzZXJzcGFjZS4NCj4gPiBXZSBhZGRl
ZCBuZG9fYWRkX3ZmX3ZsYW5fdHJ1bmtfcmFuZ2UgYW5kDQo+ID4gbmRvX2RlbF92Zl92bGFuX3Ry
dW5rX3JhbmdlDQo+ID4gbmV0ZGV2IG9wcyB0byBhZGQvcmVtb3ZlIGFsbG93ZWQgdmxhbi1pZHMg
cmFuZ2UgaW4gdGhlIG5ldGRldi4NCj4gPiANCj4gPiAyKSBJRkxBX1ZGX1ZMQU5fVFJVTks6IHVz
ZWQgdG8gcXVlcnkgdGhlIGFsbG93ZWQgdmxhbi1pZHMgdHJ1bmsuDQo+ID4gV2UgYWRkZWQgdHJ1
bmsgYml0bWFwIHRvIHRoZSBpZmxhX3ZmX2luZm8gc3RydWN0IHRvIGdldCB0aGUgY3VycmVudA0K
PiA+IGFsbG93ZWQgdmxhbi1pZHMgdHJ1bmsgZnJvbSB0aGUgbmV0ZGV2Lg0KPiA+IFdlIGFkZGVk
IGlmbGFfdmZfdmxhbl90cnVuayBzdHJ1Y3QgZm9yIHNlbmRpbmcgdGhlIGFsbG93ZWQgdmxhbi1p
ZHMNCj4gPiB0cnVuayB0byB0aGUgdXNlcnNwYWNlLg0KPiA+IFNpbmNlIHRoZSB0cnVuayBiaXRt
YXAgbmVlZHMgdG8gY29udGFpbiBhIGJpdCBwZXIgcG9zc2libGUgZW5hYmxlZA0KPiA+IHZsYW4g
aWQsIHRoZSBzaXplIGFkZGl0aW9uIHRvIGlmbGFfdmZfaW5mbyBpcyBzaWduaWZpY2FudCB3aGlj
aCBtYXkNCj4gPiBjcmVhdGUgYXR0cmlidXRlIGxlbmd0aCBvdmVycnVuIHdoZW4gcXVlcnlpbmcg
YWxsIHRoZSBWRnMuDQo+ID4gDQo+ID4gVGhlcmVmb3JlLCB0aGUgcmV0dXJuIG9mIHRoZSBmdWxs
IGJpdG1hcCBpcyBsaW1pdGVkIHRvIHRoZSBjYXNlDQo+ID4gd2hlcmUgdGhlIGFkbWluIHF1ZXJp
ZXMgYSBzcGVjaWZpYyBWRiBvbmx5IGFuZCBmb3IgdGhlIFZGIGxpc3QNCj4gPiBxdWVyeSB3ZSBp
bnRyb2R1Y2UgYSBuZXcgdmZfaW5mbyBhdHRyaWJ1dGUgY2FsbGVkIGlmbGFfdmZfdmxhbl9tb2Rl
DQo+ID4gdGhhdCB3aWxsIHByZXNlbnQgdGhlIGN1cnJlbnQgVkYgdGFnZ2luZyBtb2RlIC0gVkdU
LCBWU1Qgb3INCj4gPiBWR1QrKHRydW5rKS4NCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBBcmll
bCBMZXZrb3ZpY2ggPGxhcmllbEBtZWxsYW5veC5jb20+DQo+ID4gZGlmZiAtLWdpdCBhL2luY2x1
ZGUvbGludXgvbmV0ZGV2aWNlLmggYi9pbmNsdWRlL2xpbnV4L25ldGRldmljZS5oDQo+ID4gaW5k
ZXggMzIwN2UwYi4uZGE3OTk3NiAxMDA2NDQNCj4gPiAtLS0gYS9pbmNsdWRlL2xpbnV4L25ldGRl
dmljZS5oDQo+ID4gKysrIGIvaW5jbHVkZS9saW51eC9uZXRkZXZpY2UuaA0KPiA+IEBAIC0xMDY3
LDYgKzEwNjcsMTAgQEAgc3RydWN0IG5ldGRldl9uYW1lX25vZGUgew0KPiA+ICAgKiAgICAgIEhh
c2ggS2V5LiBUaGlzIGlzIG5lZWRlZCBzaW5jZSBvbiBzb21lIGRldmljZXMgVkYgc2hhcmUNCj4g
PiB0aGlzIGluZm9ybWF0aW9uDQo+ID4gICAqICAgICAgd2l0aCBQRiBhbmQgcXVlcnlpbmcgaXQg
bWF5IGludHJvZHVjZSBhIHRoZW9yZXRpY2FsDQo+ID4gc2VjdXJpdHkgcmlzay4NCj4gPiAgICog
aW50ICgqbmRvX3NldF92Zl9yc3NfcXVlcnlfZW4pKHN0cnVjdCBuZXRfZGV2aWNlICpkZXYsIGlu
dCB2ZiwNCj4gPiBib29sIHNldHRpbmcpOw0KPiA+ICsgKiBpbnQgKCpuZG9fYWRkX3ZmX3ZsYW5f
dHJ1bmtfcmFuZ2UpKHN0cnVjdCBuZXRfZGV2aWNlICpkZXYsIGludA0KPiA+IHZmLA0KPiA+ICsg
KgkJCQkgICAgICB1MTYgc3RhcnRfdmlkLCB1MTYgZW5kX3ZpZCwNCj4gPiBfX2JlMTYgcHJvdG8p
Ow0KPiA+ICsgKiBpbnQgKCpuZG9fZGVsX3ZmX3ZsYW5fdHJ1bmtfcmFuZ2UpKHN0cnVjdCBuZXRf
ZGV2aWNlICpkZXYsIGludA0KPiA+IHZmLA0KPiA+ICsgKgkJCQkgICAgICB1MTYgc3RhcnRfdmlk
LCB1MTYgZW5kX3ZpZCwNCj4gPiBfX2JlMTYgcHJvdG8pOw0KPiA+ICAgKiBpbnQgKCpuZG9fZ2V0
X3ZmX3BvcnQpKHN0cnVjdCBuZXRfZGV2aWNlICpkZXYsIGludCB2Ziwgc3RydWN0DQo+ID4gc2tf
YnVmZiAqc2tiKTsNCj4gPiAgICogaW50ICgqbmRvX3NldHVwX3RjKShzdHJ1Y3QgbmV0X2Rldmlj
ZSAqZGV2LCBlbnVtIHRjX3NldHVwX3R5cGUNCj4gPiB0eXBlLA0KPiA+ICAgKgkJICAgICAgIHZv
aWQgKnR5cGVfZGF0YSk7DQo+ID4gQEAgLTEzMzIsNiArMTMzNiwxNCBAQCBzdHJ1Y3QgbmV0X2Rl
dmljZV9vcHMgew0KPiA+ICAJaW50CQkJKCpuZG9fc2V0X3ZmX3Jzc19xdWVyeV9lbikoDQo+ID4g
IAkJCQkJCSAgIHN0cnVjdCBuZXRfZGV2aWNlDQo+ID4gKmRldiwNCj4gPiAgCQkJCQkJICAgaW50
IHZmLCBib29sDQo+ID4gc2V0dGluZyk7DQo+ID4gKwlpbnQJCQkoKm5kb19hZGRfdmZfdmxhbl90
cnVua19yYW5nZSkoDQo+ID4gKwkJCQkJCSAgIHN0cnVjdCBuZXRfZGV2aWNlDQo+ID4gKmRldiwN
Cj4gPiArCQkJCQkJICAgaW50IHZmLCB1MTYNCj4gPiBzdGFydF92aWQsDQo+ID4gKwkJCQkJCSAg
IHUxNiBlbmRfdmlkLCBfX2JlMTYNCj4gPiBwcm90byk7DQo+ID4gKwlpbnQJCQkoKm5kb19kZWxf
dmZfdmxhbl90cnVua19yYW5nZSkoDQo+ID4gKwkJCQkJCSAgIHN0cnVjdCBuZXRfZGV2aWNlDQo+
ID4gKmRldiwNCj4gPiArCQkJCQkJICAgaW50IHZmLCB1MTYNCj4gPiBzdGFydF92aWQsDQo+ID4g
KwkJCQkJCSAgIHUxNiBlbmRfdmlkLCBfX2JlMTYNCj4gPiBwcm90byk7DQo+ID4gIAlpbnQJCQko
Km5kb19zZXR1cF90Yykoc3RydWN0IG5ldF9kZXZpY2UgKmRldiwNCj4gPiAgCQkJCQkJZW51bSB0
Y19zZXR1cF90eXBlDQo+ID4gdHlwZSwNCj4gPiAgCQkJCQkJdm9pZCAqdHlwZV9kYXRhKTsNCj4g
DQo+IElzIHRoaXMgb2ZmaWNpYWwgTWVsbGFub3ggcGF0Y2ggc3VibWlzc2lvbiBvciBkbyB5b3Ug
Z3V5cyBuZWVkIHRpbWUNCj4gdG8NCj4gZGVjaWRlIGJldHdlZW4gZWFjaCBvdGhlciBpZiB5b3Ug
bGlrZSBsZWdhY3kgVkYgbmRvcyBvciBub3Q/IDstKQ0KDQpJdCBpcyBvZmZpY2lhbCA6KSwgYXMg
bXVjaCBhcyB3ZSB3YW50IHRvIG1vdmUgYXdheSBmcm9tIGxlZ2FjeSBtb2RlLCB3ZQ0KZG8gc3Rp
bGwgaGF2ZSB0d28gbWFqb3IgY3VzdG9tZXJzIHRoYXQgYXJlIG5vdCBxdWl0ZSByZWFkeSB5ZXQg
dG8gbW92ZQ0KdG8gc3dpdGNoZGV2IG1vZGUuIHRoZSBzaWx2ZXItbGluaW5nIGhlcmUgaXMgdGhh
dCB0aGV5IGFyZSB3ZWxsaW5nIHRvDQptb3ZlIHRvIHVwc3RyZWFtIGtlcm5lbCAoYWR2YW5jZWQg
ZGlzdHJvcyksIGJ1dCB3ZSBuZWVkIHRoaXMgZmVhdHVyZSBpbg0KbGVnYWN5IG1vZGUuDQoNClRo
ZSBhYmlsaXR5IHRvIGNvbmZpZ3VyZSBwZXIgVkYgQUNMIHRhYmxlcyB2bGFuIGZpbHRlcnMgaXMg
YSBtdXN0Lg0KDQpJIHRyaWVkIHRvIHRoaW5rIG9mIGFuIEFQSSB3aGVyZSB3ZSBjYW4gZXhwb3Nl
IHRoZSB3aG9sZSBWRiBBQ0wgdGFibGVzDQp0byB1c2VycyBhbmQgbGV0IHRoZW0gY29uZmlndXJl
IGl0IHRoZSB3YXkgdGhleSB3YW50IHdpdGggVEMgZmxvd2VyDQptYXliZSAoc29ydCBvZiBoeWJy
aWQgbGVnYWN5LXN3aXRjaGRldiBtb2RlIHRoYXQgY2FuIGFjdCBvbmx5IG9uIFZGIEFDTA0KdGFi
bGVzIGJ1dCBub3Qgb24gdGhlIEZEQikuIFRoZSBwcm9ibGVtIHdpdGggdGhpcyBpcyB0aGF0IGl0
IGNhbiBlYXNpbHkNCmNvbmZsaWN0IHdpdGggVlNUL3RydXN0IG1vZGUgYW5kIG90aGVyIHNldHRp
bmdzIHRoYXQgY2FuIGJlIGRvbmUgdmlhDQpsZWdhY3kgVkYgbmRvcy4uLiBzbyBpIGd1ZXNzIHRo
ZSBjb21wbGV4aXR5IG9mIHN1Y2ggQVBJIGlzIG5vdCB3b3J0aHkNCmFuZCBhIHNpbXBsZSB2bGFu
IGxpc3QgZmlsdGVyIEFQSSBpcyBtb3JlIG5hdHVyYWwgZm9yIGxlZ2FjeSBzcmlvdiA/IQ0KDQoN
Cg0K
