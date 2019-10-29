Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F425E9353
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 00:09:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726266AbfJ2XJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 19:09:09 -0400
Received: from mail-eopbgr140070.outbound.protection.outlook.com ([40.107.14.70]:61765
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726203AbfJ2XJJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Oct 2019 19:09:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fXqStIEyaPgZCAkGm4pIxX5wTVCylLeNb91HIyoxUMHi6OnIp8yaxgT2cdcfEGRyWxTQYXhDirJ+qKjTkuKfW5q0I4z0Jr2mrZ+aPOYMj1oDkytRupRKUSthRdi6z/C6KWQYO4LblmyaqdRNrzaMA8ntzhw0bmpq5duppw7uZvptYgM3YAkDEajwA0Q1RnZQLMrHMa3weUby1AspSd1eL+2kaRjTfnE8fK7wkAHKf5tRf7ha4cvTh8aiSSQcjLx9jKN5UlFigk53rdgx0IMwn8gX0D+XqB1eM4WnzodoAsYadkMExRsP/Ev2+7N2scG5kTykN1or3B5kFEsSZ8vcYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7R6D2Izr64NoAFXATBlwZETGuBVBunmhp0OvBqngBes=;
 b=Ov9hQTLc95xi/VO0UGJqXZt7SYcqfHr6IvVhQ6RINxaltODvjhBFsdgvZOk2vE2RzHKI8i08tjQXbcbuLYRJkbhQqSrkrd37R4Jp4vM9M/B1mv6AFYFjIRKW9cfe01qorWgfM5xmcI5d4E64uuhjaYiReNblgRlZwQ11WbnTgwkNDvOhTVYA8Pw0zv1hg/HBbsdRNl9jyVsSECUxrGjQR3FtVsWAkKCF6J8wifdA3kNM+7R1ywWm1kTgUVisPkFroNMUpHo3eWIdy9wBY7EkcJTJ8/e2OTBdXKNxMuSNmOIUuB8TeU6JelIU47VQeB+zrFaR5DWpN8cevXLuA7W6tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7R6D2Izr64NoAFXATBlwZETGuBVBunmhp0OvBqngBes=;
 b=F1ln3R8znXLvzVJLva5ls4+YG5V48t4rzCdJyqivgxD9VpD04IMm+mhbcuiPXxsy2tNjrGUA5NHdqGjR3lWyjhpZul7ZniwAm2AKeMh8ZYcUNQTdK0mO7HinPZr/QhGsJMXyzqqhiv6u7Dkbav4/4KlbN6GC3H/04XdzvgrNsSk=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB3407.eurprd05.prod.outlook.com (10.170.238.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.24; Tue, 29 Oct 2019 23:09:03 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2387.027; Tue, 29 Oct 2019
 23:09:03 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Tariq Toukan <tariqt@mellanox.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [net 11/11] Documentation: TLS: Add missing counter description
Thread-Topic: [net 11/11] Documentation: TLS: Add missing counter description
Thread-Index: AQHViqKwypFr0YjBW0+s0rv71ft9FKdqUQWAgAdpjACAAIvdgA==
Date:   Tue, 29 Oct 2019 23:09:03 +0000
Message-ID: <c1a48a1a470e10acefb52ec13ab799514c1cd31d.camel@mellanox.com>
References: <20191024193819.10389-1-saeedm@mellanox.com>
         <20191024193819.10389-12-saeedm@mellanox.com>
         <20191024143651.795705df@cakuba.hsd1.ca.comcast.net>
         <86bb1c88-c650-d262-8d14-180af563dc10@mellanox.com>
In-Reply-To: <86bb1c88-c650-d262-8d14-180af563dc10@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 44f10acc-378c-4065-4108-08d75cc4fdb7
x-ms-traffictypediagnostic: VI1PR05MB3407:|VI1PR05MB3407:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB3407B0F5A591EF7F3014BE37BE610@VI1PR05MB3407.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0205EDCD76
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(376002)(136003)(396003)(366004)(189003)(199004)(58126008)(2906002)(3846002)(71200400001)(71190400001)(6512007)(6486002)(6116002)(6436002)(5660300002)(8936002)(81166006)(81156014)(8676002)(11346002)(110136005)(99286004)(25786009)(91956017)(76116006)(316002)(66446008)(66556008)(64756008)(478600001)(446003)(7736002)(305945005)(66476007)(66946007)(229853002)(36756003)(2616005)(118296001)(256004)(14444005)(2501003)(14454004)(6506007)(186003)(86362001)(53546011)(6246003)(4326008)(102836004)(54906003)(476003)(4001150100001)(76176011)(26005)(66066001)(486006);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3407;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KBBOEe0wRY0vakm5Vnv2RHDL+aMumQYsW8O+a5egs1YC0mydYLRoPiO53uB6APx4hp/feBL1ads+D51ofL7mc8iJ/fokGnLtdaQ+P8JcXo6yPsB07Iy+JLeLqu27W02QgRQycr2d9v2he0OtkMlD5V7cNXM1dkWg5sc9d5h1HjlzU4HQRrOTD+6R3d44N88cAksZ8XlM3RbNWZg21Zr15fyte7kpPcKpL+pB1FtGBCZR81D7nstilY3SvezzaUE45dgCWQoJ3dxKdLs/SA8u1RCXTXRZTkWvppGmNhOxjJ5tB8wXcXq3/0vHu0q3Bu5zhD/3gOTjjbpPCqpMFOFVQUcZ6hGsm74eiIPoaLce+myAn0JsUjE5W+l6+iVZBMyDU33p97NyJDjCh7110pCxKptA/kUvCMFoDBEXJgK7FaHdTvEPWgTNRKLTo3o1tIap
Content-Type: text/plain; charset="utf-8"
Content-ID: <65BD341CEB3DB846857D4E39D90CBAA4@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44f10acc-378c-4065-4108-08d75cc4fdb7
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2019 23:09:03.5035
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dspUT/SIFLCdF2/lKpjAnpwskeBvjJZeuhAs8lK3G6J4djqR9iaVTpkzwx0lc38BgP9e8EeWc4+4hm0MX2luFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3407
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTEwLTI5IGF0IDE0OjQ4ICswMDAwLCBUYXJpcSBUb3VrYW4gd3JvdGU6DQo+
IA0KPiBPbiAxMC8yNS8yMDE5IDEyOjM2IEFNLCBKYWt1YiBLaWNpbnNraSB3cm90ZToNCj4gPiBP
biBUaHUsIDI0IE9jdCAyMDE5IDE5OjM5OjAyICswMDAwLCBTYWVlZCBNYWhhbWVlZCB3cm90ZToN
Cj4gPiA+IEZyb206IFRhcmlxIFRvdWthbiA8dGFyaXF0QG1lbGxhbm94LmNvbT4NCj4gPiA+IA0K
PiA+ID4gQWRkIFRMUyBUWCBjb3VudGVyIGRlc2NyaXB0aW9uIGZvciB0aGUgcGFja2V0cyB0aGF0
IHNraXAgdGhlDQo+ID4gPiByZXN5bmMNCj4gPiA+IHByb2NlZHVyZSBhbmQgaGFuZGxlZCBpbiB0
aGUgcmVndWxhciB0cmFuc21pdCBmbG93LCBhcyB0aGV5DQo+ID4gPiBjb250YWluDQo+ID4gPiBu
byBkYXRhLg0KPiA+ID4gDQo+ID4gPiBGaXhlczogNDZhM2VhOTgwNzRlICgibmV0L21seDVlOiBr
VExTLCBFbmhhbmNlIFRYIHJlc3luYyBmbG93IikNCj4gPiA+IFNpZ25lZC1vZmYtYnk6IFRhcmlx
IFRvdWthbiA8dGFyaXF0QG1lbGxhbm94LmNvbT4NCj4gPiA+IFNpZ25lZC1vZmYtYnk6IFNhZWVk
IE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPg0KPiA+ID4gLS0tDQo+ID4gPiAgIERvY3Vt
ZW50YXRpb24vbmV0d29ya2luZy90bHMtb2ZmbG9hZC5yc3QgfCAzICsrKw0KPiA+ID4gICAxIGZp
bGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspDQo+ID4gPiANCj4gPiA+IGRpZmYgLS1naXQgYS9E
b2N1bWVudGF0aW9uL25ldHdvcmtpbmcvdGxzLW9mZmxvYWQucnN0DQo+ID4gPiBiL0RvY3VtZW50
YXRpb24vbmV0d29ya2luZy90bHMtb2ZmbG9hZC5yc3QNCj4gPiA+IGluZGV4IDBkZDNmNzQ4MjM5
Zi4uODdkYjg3MDk5NjA3IDEwMDY0NA0KPiA+ID4gLS0tIGEvRG9jdW1lbnRhdGlvbi9uZXR3b3Jr
aW5nL3Rscy1vZmZsb2FkLnJzdA0KPiA+ID4gKysrIGIvRG9jdW1lbnRhdGlvbi9uZXR3b3JraW5n
L3Rscy1vZmZsb2FkLnJzdA0KPiA+ID4gQEAgLTQzNiw2ICs0MzYsOSBAQCBieSB0aGUgZHJpdmVy
Og0KPiA+ID4gICAgICBlbmNyeXB0aW9uLg0KPiA+ID4gICAgKiBgYHR4X3Rsc19vb29gYCAtIG51
bWJlciBvZiBUWCBwYWNrZXRzIHdoaWNoIHdlcmUgcGFydCBvZiBhDQo+ID4gPiBUTFMgc3RyZWFt
DQo+ID4gPiAgICAgIGJ1dCBkaWQgbm90IGFycml2ZSBpbiB0aGUgZXhwZWN0ZWQgb3JkZXIuDQo+
ID4gPiArICogYGB0eF90bHNfc2tpcF9ub19zeW5jX2RhdGFgYCAtIG51bWJlciBvZiBUWCBwYWNr
ZXRzIHdoaWNoDQo+ID4gPiB3ZXJlIHBhcnQgb2YNCj4gPiA+ICsgICBhIFRMUyBzdHJlYW0gYW5k
IGFycml2ZWQgb3V0LW9mLW9yZGVyLCBidXQgc2tpcHBlZCB0aGUgSFcNCj4gPiA+IG9mZmxvYWQg
cm91dGluZQ0KPiA+ID4gKyAgIGFuZCB3ZW50IHRvIHRoZSByZWd1bGFyIHRyYW5zbWl0IGZsb3cg
YXMgdGhleSBjb250YWluZWQgbm8NCj4gPiA+IGRhdGEuDQo+ID4gDQo+ID4gVGhhdCBkb2Vzbid0
IHNvdW5kIHJpZ2h0LiBJdCBzb3VuZHMgbGlrZSB5b3UncmUgdGFsa2luZyBhYm91dCBwdXJlDQo+
ID4gQWNrcw0KPiA+IGFuZCBvdGhlciBzZWdtZW50cyB3aXRoIG5vIGRhdGEuIEZvciBtbHg1IHRo
b3NlIGFyZSBza2lwcGVkDQo+ID4gZGlyZWN0bHkgaW4NCj4gPiBtbHg1ZV9rdGxzX2hhbmRsZV90
eF9za2IoKS4NCj4gPiANCj4gPiBUaGlzIGNvdW50ZXIgaXMgZm9yIHNlZ21lbnRzIHdoaWNoIGFy
ZSByZXRyYW5zbWlzc2lvbiBvZiBkYXRhDQo+ID4gcXVldWVkIHRvDQo+ID4gdGhlIHNvY2tldCBi
ZWZvcmUga2VybmVsIGdvdCB0aGUga2V5cyBpbnN0YWxsZWQuDQo+ID4gDQo+ID4gWW91IGV4cGxh
aW5lZCBpdCByZWFzb25hYmx5IHdlbGwgaW4gNDZhM2VhOTgwNzRlICgibmV0L21seDVlOiBrVExT
LA0KPiA+IEVuaGFuY2UgVFggcmVzeW5jIGZsb3ciKToNCj4gPiANCj4gPiAgICAgIEhvd2V2ZXIs
IGluIGNhc2UgdGhlIFRMUyBTS0IgaXMgYSByZXRyYW5zbWlzc2lvbiBvZiB0aGUNCj4gPiBjb25u
ZWN0aW9uDQo+ID4gICAgICBoYW5kc2hha2UsIGl0IGluaXRpYXRlcyB0aGUgcmVzeW5jIGZsb3cg
KGFzIHRoZSB0Y3Agc2VxIGNoZWNrDQo+ID4gaG9sZHMpLA0KPiA+ICAgICAgd2hpbGUgcmVndWxh
ciBwYWNrZXQgaGFuZGxlIGlzIGV4cGVjdGVkLg0KPiA+IA0KPiANCj4gUmlnaHQuIEknbGwgcmVw
aHJhc2UuDQo+IA0KDQpUaGFua3MgVGFyaXEsIEkgd2lsbCBkcm9wIHRoaXMgcGF0Y2ggZnJvbSBt
eSBzZXJpZXMsIHBsZWFzZSBzZW5kIGl0IHRvDQpuZXQgYnJhbmNoIGFzIHN0YW5kIGFsb25lIHdo
ZW4gcmVhZHkuDQoNClRoYW5rcywNClNhZWVkLg0K
