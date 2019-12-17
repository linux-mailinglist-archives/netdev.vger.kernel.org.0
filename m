Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 190701235F1
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 20:50:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728112AbfLQTuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 14:50:08 -0500
Received: from mail-eopbgr60055.outbound.protection.outlook.com ([40.107.6.55]:46853
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727786AbfLQTuI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 14:50:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EhnWpmxd9+0QJPb6RozfYg5wp+n9jnAoBUKph8tkV8gMECV94mS5tskRwWKv1UQTs11aJ3H860kSXwITXBPJFhPJ0Ac48It6SHa9OFmcUIDMEMi1YtmVPMq1lH7IZxs6r9rnVVW2/0JsvSj44gaiO/p0Jd+rI/ps5qvQhYX+J40OFwjwFEp4qxi11a+vZhdSPjAnMlDYPKUsfPYPyaxdUOy3Ed3if48x1MHtHJiV2I4HDUsCDkNznMtWqoNMY5mfksJil9fhg0GGH3uQrQmjFnLRctVXVRJGangIKlAjtMqhNlFcGejpVlPZRFp6mIJkWU5Zl9WutHcPEQvdNM9zUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LPW2aYndwkYkxDBKS7N3IVg0C8FP14y9Gl2QMmBAtBE=;
 b=broZH56eqWt+ZKhJRKi/1tIT3tXFGvEKM2hRE/c0LjlEDRAub8WbgAWSCiJCai+Sa0t9SwfscsqsQJZTef3kgYDczS2afe2qh0V+Ttuo/gR79gXgcKjW8nNSu1NY2J9Fbu/pjkNtkYpgCM4z6YXNUHVlys6yU8sUNBIQ9sHAJl6+C+ZN4FgSSDi6ecNu4k+t39u/sfIMzewQYDayxEBJe1SBhYteZ5dTtf5qtso0Osbkzyi15vMbML0zapJ7Whd6xZONz8TCJoChtPa1cEdBFO7kll4fhPKOvopN+5URLWHIswTAMcbDzaXW/ppMQRziI9yF1jPxzzga/8qL14CTTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LPW2aYndwkYkxDBKS7N3IVg0C8FP14y9Gl2QMmBAtBE=;
 b=poNW0tUbEfiBAPDXntjWYCdn1OXL3tk8oTn0ACTwihruFmsKpBVok0flNil+SikISJkOHL7dKSRDP3utfVc5bZKFPLPI8/zyRyoJJsYyD4ZjZjK4wNdzE316r4BRlqtf8rN11msJbM+KS9Fgv6xGukv7kSy0c1KF0A1pHDO6vo8=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6016.eurprd05.prod.outlook.com (20.178.204.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Tue, 17 Dec 2019 19:50:05 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::c872:cf66:4a5c:c881]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::c872:cf66:4a5c:c881%5]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 19:50:05 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "saeedm@dev.mellanox.co.il" <saeedm@dev.mellanox.co.il>,
        Mark Bloch <markb@mellanox.com>,
        "xiangxia.m.yue@gmail.com" <xiangxia.m.yue@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net/mlx5e: Support accept action on nic table
Thread-Topic: [PATCH net-next] net/mlx5e: Support accept action on nic table
Thread-Index: AQHVr2kp/EX/aC6UvEOUiNJkpfK5SKe+x4aA
Date:   Tue, 17 Dec 2019 19:50:05 +0000
Message-ID: <e033c50869a7054270c4a8bd1eb0846b0a5098a1.camel@mellanox.com>
References: <1575989382-7195-1-git-send-email-xiangxia.m.yue@gmail.com>
In-Reply-To: <1575989382-7195-1-git-send-email-xiangxia.m.yue@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.5 (3.32.5-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 655dd46f-4f64-45cf-cc50-08d7832a5017
x-ms-traffictypediagnostic: VI1PR05MB6016:|VI1PR05MB6016:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB60162B51DD44D22DEE516908BE500@VI1PR05MB6016.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(366004)(39860400002)(346002)(376002)(189003)(199004)(76116006)(64756008)(6506007)(2616005)(5660300002)(2906002)(86362001)(478600001)(8676002)(71200400001)(6512007)(26005)(4001150100001)(8936002)(81166006)(4326008)(186003)(6486002)(110136005)(66946007)(66446008)(66556008)(66476007)(36756003)(81156014)(91956017)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6016;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xvuXqmePmO/mcz/38OkhshNkI55ySk0+NRnJfXVYkav503eD2buE5UVGBlSMAcQRBywE2os+hus4Tz1j+w8bQPB8eQmfzc0QfYaL3kLPRW1+93Kvg47sPzw3ZUpv80ZxXqm7F1HyRacBPsAk6A/FfjROGV/vwB1ahLzAUJ0LoMor3Q2a63Hb60/WroVmrtv9NHdlv7s67+5HV8u9grGyzqczPFYoiG9BXICq8r1Bfego/1cLGyfD8xOCVUyaxvhDzgpnekC8pO3U3P67949euzAOoTR2wQMLSL0RZCR1o7KWwuXy8aKMtsiy8qgJSV7mkhaMvV6pgtnNzVhm2pyW+qFiq14+5FAV/UUc+5FTsfCgxM60+AiS0HeNo1DKJCS34QkAGOnKdGVsV+7XSvrH3V2tk6/hHavFlY7ZzmQWngJ9jLWeKRS9HhViPwJJuONI
Content-Type: text/plain; charset="utf-8"
Content-ID: <4E63C4ABA6F2F043A539D3C145B9B2BB@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 655dd46f-4f64-45cf-cc50-08d7832a5017
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 19:50:05.0447
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WzoCkMpTF/rD5YzpkKMolpbWw4wubOGzXy49vpvh3RkrGReXcmJEhFvlazhW8pXeIlq/8BtqpvgXm/bnwfqx9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6016
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTEyLTEwIGF0IDIyOjQ5ICswODAwLCB4aWFuZ3hpYS5tLnl1ZUBnbWFpbC5j
b20gd3JvdGU6DQo+IEZyb206IFRvbmdoYW8gWmhhbmcgPHhpYW5neGlhLm0ueXVlQGdtYWlsLmNv
bT4NCj4gDQo+IEluIG9uZSBjYXNlLCB3ZSBtYXkgZm9yd2FyZCBwYWNrZXRzIGZyb20gb25lIHZw
b3J0DQo+IHRvIG90aGVycywgYnV0IG9ubHkgb25lIHBhY2tldHMgZmxvdyB3aWxsIGJlIGFjY2Vw
dGVkLA0KPiB3aGljaCBkZXN0aW5hdGlvbiBpcCB3YXMgYXNzaWduIHRvIFZGLg0KPiANCj4gKy0t
LS0tKyAgICAgKy0tLS0tKyAgICAgICAgICAgICstLS0tLSsNCj4gPiBWRm4gfCAgICAgfCBWRjEg
fCAgICAgICAgICAgIHwgVkYwIHwgYWNjZXB0DQo+ICstLSstLSsgICAgICstLSstLSsgIGhhaXJw
aW4gICArLS1eLS0rDQo+ICAgIHwgICAgICAgICAgIHwgPC0tLS0tLS0tLS0tLS0tLSB8DQo+ICAg
IHwgICAgICAgICAgIHwgICAgICAgICAgICAgICAgICB8DQo+ICstLSstLS0tLS0tLS0tLXYtKyAg
ICAgICAgICAgICArLS0rLS0tLS0tLS0tLS0tLSsNCj4gPiAgIGVzd2l0Y2ggUEYxICB8ICAgICAg
ICAgICAgIHwgICBlc3dpdGNoIFBGMCAgfA0KPiArLS0tLS0tLS0tLS0tLS0tLSsgICAgICAgICAg
ICAgKy0tLS0tLS0tLS0tLS0tLS0rDQo+IA0KPiB0YyBmaWx0ZXIgYWRkIGRldiAkUEYwIHByb3Rv
Y29sIGFsbCBwYXJlbnQgZmZmZjogcHJpbyAxIGhhbmRsZSAxIFwNCj4gCWZsb3dlciBza2lwX3N3
IGFjdGlvbiBtaXJyZWQgZWdyZXNzIHJlZGlyZWN0IGRldiAkVkYwX1JFUA0KPiB0YyBmaWx0ZXIg
YWRkIGRldiAkVkYwIHByb3RvY29sIGlwICBwYXJlbnQgZmZmZjogcHJpbyAxIGhhbmRsZSAxIFwN
Cj4gCWZsb3dlciBza2lwX3N3IGRzdF9pcCAkVkYwX0lQIGFjdGlvbiBwYXNzDQo+IHRjIGZpbHRl
ciBhZGQgZGV2ICRWRjAgcHJvdG9jb2wgYWxsIHBhcmVudCBmZmZmOiBwcmlvIDIgaGFuZGxlIDIg
XA0KPiAJZmxvd2VyIHNraXBfc3cgYWN0aW9uIG1pcnJlZCBlZ3Jlc3MgcmVkaXJlY3QgZGV2ICRW
RjENCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFRvbmdoYW8gWmhhbmcgPHhpYW5neGlhLm0ueXVlQGdt
YWlsLmNvbT4NCj4gLS0tDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2Nv
cmUvZW5fdGMuYyB8IDQgKysrKw0KPiAgMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKQ0K
PiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29y
ZS9lbl90Yy5jDQo+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Vu
X3RjLmMNCj4gaW5kZXggMGQ1ZDg0Yi4uZjkxZTA1N2UgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMv
bmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl90Yy5jDQo+ICsrKyBiL2RyaXZlcnMv
bmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl90Yy5jDQo+IEBAIC0yODM5LDYgKzI4
MzksMTAgQEAgc3RhdGljIGludCBwYXJzZV90Y19uaWNfYWN0aW9ucyhzdHJ1Y3QNCj4gbWx4NWVf
cHJpdiAqcHJpdiwNCj4gIA0KPiAgCWZsb3dfYWN0aW9uX2Zvcl9lYWNoKGksIGFjdCwgZmxvd19h
Y3Rpb24pIHsNCj4gIAkJc3dpdGNoIChhY3QtPmlkKSB7DQo+ICsJCWNhc2UgRkxPV19BQ1RJT05f
QUNDRVBUOg0KPiArCQkJYWN0aW9uIHw9IE1MWDVfRkxPV19DT05URVhUX0FDVElPTl9GV0RfREVT
VCB8DQo+ICsJCQkJICBNTFg1X0ZMT1dfQ09OVEVYVF9BQ1RJT05fQ09VTlQ7DQo+ICsJCQlicmVh
azsNCj4gIAkJY2FzZSBGTE9XX0FDVElPTl9EUk9QOg0KPiAgCQkJYWN0aW9uIHw9IE1MWDVfRkxP
V19DT05URVhUX0FDVElPTl9EUk9QOw0KPiAgCQkJaWYgKE1MWDVfQ0FQX0ZMT1dUQUJMRShwcml2
LT5tZGV2LA0KDQpBcHBsaWVkIHRvIG5ldC1uZXh0LW1seDUsIHdpbGwgc3VibWl0IHRvIG5ldC1u
ZXh0IHNvb24uDQp0aGFua3MgYSBsb3QNCg==
