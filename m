Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA05EF2E6
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 02:38:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730080AbfKEBiP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 20:38:15 -0500
Received: from mail-eopbgr150071.outbound.protection.outlook.com ([40.107.15.71]:34110
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729443AbfKEBiP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Nov 2019 20:38:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B9aMkC7mEw/o/W0mGR4TLP9Md+dUDy/jNx2YSGxREgrfoE8Hf8UQO3+JYZ6IJKEsRPwd2LQMgnMw4Rdq07+E/qa2AOWxW5JhLaUkGMTrc2eYEOPRS9CXEbyH+jjddotoYKZxbcgRCPe2MAQG2FB6dghpdWVngIgNR2eAWRbWnc8bNezFWk7fyJeQyZszW2mGd7P4eDdD4zB54K58xhT/mpf82vUMgZrCCphOlc9zgIJIxnu50aMNSz3V3tZNl/Z4xlJZeCr5aBN9ROWSZx56RhoPMFcUbHgcj+gkxFadU4qRr9XXw9jZW3TqQmw5GWga4GG2lWvXo74VgQA8/Klzdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HiMvQuy67u5esFhFoiQSlLTPOpOZ+0glSX8d0ZN++QI=;
 b=QjjCNd616UfVUFBihEaN/QKUYnGiclSw1hxxDr4OW+ZGXPKMOi77XPNlVWiWwcLVA27K0k0MCHSu2eOWDPgtSzGrcFSVvrDMvGVGUOgXsEEqmIKRf2n09rFJeG6A/LldKAA/wVUnRbjcnBMiwAlyUrhcZ8hTeqAGq7SyFwaMi/DEiwrMiG8ry82DyiYAq9xGLOaHVwAjejQQ97bdu7MGWWtRXd3qhFaW0YaiasRDEF/Hq/1LVP+K0J6K3ZxJ6ngKUaQvnNPLcPbnKFl8pBQ7ITNpqJ1SP6pn+xAsKRh/dZz5h1AUZQpwWXKtpDxSwpC+r0HoEy4mNvweW5nYkOSffg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HiMvQuy67u5esFhFoiQSlLTPOpOZ+0glSX8d0ZN++QI=;
 b=VCaecqEnAnaMsusYDnjmigL0Z8aYVre0QhWcV4yD6MAHNZ4LUzfpGIp2C6kcOkYZ8CQk8oksixd6lyLpcNZlY4dTwi7XmO+Nw0t4MBTyZefDDbBm6d6Bq6n53l4lLbDsammvlAHau/bPlKaCOPOnSBv0i6oNILRaviiawgE3eSQ=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4991.eurprd05.prod.outlook.com (20.177.50.97) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Tue, 5 Nov 2019 01:38:08 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2408.024; Tue, 5 Nov 2019
 01:38:08 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>
CC:     "sbrivio@redhat.com" <sbrivio@redhat.com>,
        "nikolay@cumulusnetworks.com" <nikolay@cumulusnetworks.com>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "sd@queasysnail.net" <sd@queasysnail.net>,
        Jiri Pirko <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        Ariel Levkovich <lariel@mellanox.com>
Subject: Re: [PATCH net-next v2 0/3] VGT+ support
Thread-Topic: [PATCH net-next v2 0/3] VGT+ support
Thread-Index: AQHVkCQFGdJo5Spx4U2AGUa6mmGmtKd1dOQAgAFEboCAABz2AIAAMEAAgATMggA=
Date:   Tue, 5 Nov 2019 01:38:08 +0000
Message-ID: <358c84d69f7d1dee24cf97cc0ad6fe59d5c313f5.camel@mellanox.com>
References: <1572551213-9022-1-git-send-email-lariel@mellanox.com>
         <20191031172330.58c8631a@cakuba.netronome.com>
         <8d7db56c-376a-d809-4a65-bfc2baf3254f@mellanox.com>
         <6e0a2b89b4ef56daca9a154fa8b042e7f06632a4.camel@mellanox.com>
         <20191101172102.2fc29010@cakuba.netronome.com>
In-Reply-To: <20191101172102.2fc29010@cakuba.netronome.com>
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
x-ms-office365-filtering-correlation-id: 9b676f72-e93b-4d61-afd8-08d76190cff0
x-ms-traffictypediagnostic: VI1PR05MB4991:|VI1PR05MB4991:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4991C5B3630B077C3FFAA869BE7E0@VI1PR05MB4991.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0212BDE3BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(396003)(366004)(39860400002)(346002)(189003)(199004)(11346002)(2616005)(6506007)(6486002)(305945005)(14454004)(7736002)(186003)(229853002)(5640700003)(6512007)(2351001)(76176011)(71200400001)(86362001)(71190400001)(6246003)(5660300002)(14444005)(66446008)(66946007)(6916009)(64756008)(66476007)(66556008)(76116006)(6436002)(91956017)(2501003)(8676002)(8936002)(316002)(486006)(3846002)(476003)(81166006)(107886003)(118296001)(54906003)(99286004)(478600001)(36756003)(2906002)(25786009)(26005)(58126008)(66066001)(102836004)(446003)(4326008)(256004)(6116002)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4991;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8usWqXjERf1ZX4q/qwqsPJ8XyeBi5PtTc7GUGO2w+jl3j3MVYXy7Emx1SQB4fIBhNOH12qiLYrlyXBbR7gv0wZsfXTTZiN+mcsU9V6MBKTOpE+0oKFx+ALM8cAXBzF6N1WsXfIN3Afpw1J9VoTPSys/wvPa5uaZrabsV3kU/qejNQsD/U15touxoaggQYnBhWK4YTmwSDvw7y2YXHgYU7tvH3aRFg6ZZwmmTNbhk2SnLKrDYvDA8VcELbK9zg3wLJ7/cMSKhW7W5mn0cgOuZRUx/n4JhnvBOmOP9Iy86pMv+7Vex8/uuAEVaTA4babzLE1rMY1o2pJEzP1V25HL/DlI59YgqvBul3lSNojWP6rKoAyWOT/RbNZl0wZJCG/iijyxO6k4KHPLqhIrGFtd9hvUQ99AD+VmaRCmNntqLEEG8Miaq9dWp6OnmiJNDp+s/
Content-Type: text/plain; charset="utf-8"
Content-ID: <8EE9BD812E1B274BB15DF1886275DB5A@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b676f72-e93b-4d61-afd8-08d76190cff0
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2019 01:38:08.7267
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y9h9vgx2KC4EhtUXGnxiulfqAtR6L6/XRQxOPYNLjofgrI0ekupmBufggmla+Gcsxt7SMbnwmKm84CkOkW/XmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4991
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDE5LTExLTAxIGF0IDE3OjIxIC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gRnJpLCAxIE5vdiAyMDE5IDIxOjI4OjIyICswMDAwLCBTYWVlZCBNYWhhbWVlZCB3cm90
ZToNCj4gPiBKYWt1Yiwgc2luY2UgQXJpZWwgaXMgc3RpbGwgd29ya2luZyBvbiBoaXMgdXBzdHJl
YW0gbWFpbGluZyBsaXN0DQo+ID4gc2tpbGxzDQo+ID4gOiksIGkgd291bGQgbGlrZSB0byBlbXBo
YXNpcyBhbmQgc3VtbWFyaXplIGhpcyBwb2ludCBpbiB0ZXh0IHN0eWxlDQo+ID4gOy0pDQo+ID4g
dGhlIHdheSB3ZSBsaWtlIGl0Lg0KPiANCj4gVGhhbmtzIDopDQo+IA0KPiA+IEJvdHRvbSBsaW5l
LCB3ZSB0cmllZCB0byBwdXNoIHRoaXMgZmVhdHVyZSBhIGNvdXBsZSBvZiB5ZWFycyBhZ28sDQo+
ID4gYW5kDQo+ID4gZHVlIHRvIHNvbWUgaW50ZXJuYWwgaXNzdWVzIHRoaXMgc3VibWlzc2lvbiBp
Z25vcmVkIGZvciBhIHdoaWxlLA0KPiA+IG5vdyBhcw0KPiA+IHRoZSBsZWdhY3kgc3Jpb3YgY3Vz
dG9tZXJzIGFyZSBtb3ZpbmcgdG93YXJkcyB1cHN0cmVhbSwgd2hpY2ggaXMNCj4gPiBmb3IgbWUN
Cj4gPiBhIGdyZWF0IHByb2dyZXNzIEkgdGhpbmsgdGhpcyBmZWF0dXJlIHdvcnRoIHRoZSBzaG90
LCBhbHNvIGFzIEFyaWVsDQo+ID4gcG9pbnRlZCBvdXQsIFZGIHZsYW4gZmlsdGVyIGlzIHJlYWxs
eSBhIGdhcCB0aGF0IHNob3VsZCBiZSBjbG9zZWQuDQo+ID4gDQo+ID4gRm9yIGFsbCBvdGhlciBm
ZWF0dXJlcyBpdCBpcyB0cnVlIHRoYXQgdGhlIHVzZXIgbXVzdCBjb25zaWRlcg0KPiA+IG1vdmlu
ZyB0bw0KPiA+IHdpdGNoZGV2IG1vZGUgb3IgZmluZCBhIGFub3RoZXIgY29tbXVuaXR5IGZvciBz
dXBwb3J0Lg0KPiA+IA0KPiA+IE91ciBwb2xpY3kgaXMgc3RpbGwgc3Ryb25nIHJlZ2FyZGluZyBv
YnNvbGV0aW5nIGxlZ2FjeSBtb2RlIGFuZA0KPiA+IHB1c2hpbmcNCj4gPiBhbGwgbmV3IGZlYXR1
cmUgdG8gc3dpdGNoZGV2IG1vZGUsIGJ1dCBsb29raW5nIGF0IHRoZSBmYWN0cyBoZXJlICBJDQo+
ID4gZG8NCj4gPiB0aGluayB0aGVyZSBpcyBhIHBvaW50IGhlcmUgYW5kIFJPSSB0byBjbG9zZSB0
aGlzIGdhcCBpbiBsZWdhY3kNCj4gPiBtb2RlLg0KPiA+IA0KPiA+IEkgaG9wZSB0aGlzIGFsbCBt
YWtlIHNlbnNlLiANCj4gDQo+IEkgdW5kZXJzdGFuZCBhbmQgc3ltcGF0aGl6ZSwgeW91IGtub3cg
ZnVsbCB3ZWxsIHRoZSBiZW5lZml0cyBvZg0KPiB3b3JraW5nDQo+IHVwc3RyZWFtLWZpcnN0Li4u
DQo+IA0KPiBJIHdvbid0IHJlaXRlcmF0ZSB0aGUgZW50aXJlIHJlc3BvbnNlIGZyb20gbXkgcHJl
dmlvdXMgZW1haWwsIGJ1dCB0aGUNCj4gYm90dG9tIGxpbmUgZm9yIG1lIGlzIHRoYXQgd2UgaGF2
ZW4ndCBhZGRlZCBhIHNpbmdsZSBsZWdhY3kgVkYgTkRPDQo+IHNpbmNlIDIwMTYsIEkgd2FzIGhv
cGluZyB3ZSBuZXZlciB3aWxsIGFkZCBtb3JlIGFuZCBJIHdhcyB0cnlpbmcgdG8NCj4gc3RvcCBh
bnlvbmUgd2hvIHRyaWVkLg0KPiANCg0KVGhlIE5ETyBpcyBub3QgdGhlIHByb2JsZW0gaGVyZSwg
d2UgY2FuIHBlcmZlY3RseSBleHRlbmQgdGhlIGN1cnJlbnQNCnNldF92Zl92bGFuX25kbyB0byBh
Y2hpZXZlIHRoZSBzYW1lIGdvYWwgd2l0aCBtaW5pbWFsIG9yIGV2ZW4gTk8ga2VybmVsDQpjaGFu
Z2VzLCBidXQgZmlyc3QgeW91IGhhdmUgdG8gbG9vayBhdCB0aGlzIGZyb20gbXkgYW5nZWwsIGkg
aGF2ZSBiZWVuDQpkb2luZyBsb3RzIG9mIHJlc2VhcmNoIGFuZCB0aGVyZSBhcmUgbWFueSBwb2lu
dHMgZm9yIHdoeSB0aGlzIHNob3VsZCBiZQ0KYWRkZWQgdG8gbGVnYWN5IG1vZGU6DQoNCjEpIFN3
aXRjaGRldiBtb2RlIGNhbid0IHJlcGxhY2UgbGVnYWN5IG1vZGUgd2l0aCBhIHByZXNzIG9mIGEg
YnV0dG9uLA0KbWFueSBtaXNzaW5nIHBpZWNlcy4NCg0KMikgVXBzdHJlYW0gTGVnYWN5IFNSSU9W
IGlzIGluY29tcGxldGUgc2luY2UgaXQgZ29lcyB0b2dldGhlciB3aXRoDQpmbGV4aWJsZSB2ZiB2
bGFuIGNvbmZpZ3VyYXRpb24sIG1vc3Qgb2YgbWx4NSBsZWdhY3kgc3Jpb3YgdXNlcnMgYXJlDQp1
c2luZyBjdXN0b21pemVkIGtlcm5lbHMgYW5kIGV4dGVybmFsIGRyaXZlcnMsIHNpbmNlIHVwc3Ry
ZWFtIGlzDQpsYWNraW5nIHRoaXMgb25lIGJhc2ljIHZsYW4gZmlsdGVyaW5nIGZlYXR1cmUsIGFu
ZCBtYW55IHVzZXJzIGRlY2xpbmUNCnN3aXRjaGluZyB0byB1cHN0cmVhbSBrZXJuZWwgZHVlIHRv
IHRoaXMgbWlzc2luZyBmZWF0dXJlcy4NCg0KMykgTWFueSBvdGhlciB2ZW5kb3JzIGhhdmUgdGhp
cyBmZWF0dXJlIGluIGN1c3RvbWl6ZWQgZHJpdmVycy9rZXJuZWxzLA0KYW5kIG1hbnkgdmVuZG9y
cy9kcml2ZXJzIGRvbid0IGV2ZW4gc3VwcG9ydCBzd2l0Y2hkZXYgbW9kZSAobWx4NCBmb3INCmV4
YW1wbGUpLCB3ZSBjYW4ndCBqdXN0IHRlbGwgdGhlIHVzZXJzIG9mIHN1Y2ggZGV2aWNlIHdlIGFy
ZSBub3QNCnN1cHBvcnRpbmcgYmFzaWMgc3Jpb3YgbGVnYWN5IG1vZGUgZmVhdHVyZXMgaW4gdXBz
dHJlYW0ga2VybmVsLg0KDQo0KSB0aGUgbW90aXZhdGlvbiBmb3IgdGhpcyBpcyB0byBzbG93bHkg
bW92ZSBzcmlvdiB1c2VycyB0byB1cHN0cmVhbQ0KYW5kIGV2ZW50dWFsbHkgdG8gc3dpdGNoZGV2
IG1vZGUuDQoNClRoaXMgaGFzIGJlZW4gYSBsYXJnZSBnYXAgYW5kIGRpc2FkdmFudGFnZSBpbiB1
cHN0cmVhbSBhbmQgDQp0aGlzIGZlYXR1cmUgaGFzIGJlZW4gbG9uZyB0aW1lIGNvbWluZyBhbmQg
d2UgaGF2ZSBiZWVuIGxheWluZyB0aGUNCmdyb3VuZHMgZm9yIGl0IHNpbmNlIDIwMTYgKElGTEFf
VkZfVkxBTl9MSVNUKSwgaXQgaXMgbm90IHJlYXNvbmFibGUNCnRoYXQgd2UgaGF2ZSBBUElzIHRv
IHNldCBhbGwga2luZHMgb2YgdmYgdmxhbiBhdHRyaWJ1dGVzIGJ1dCBub3Qgdmxhbg0KZmlsdGVy
cywgSSByZWFsbHkgYmVsaWV2ZSB0aGlzIGZlYXR1cmUgc2hvdWxkIGJlIElOLg0KDQpJIHN0aWxs
IGJlbGlldmUgaW4gdGhlIHN3aXRjaGRldiBvbmx5IHBvbGljeSwgYnV0IHZsYW4gZmlsdGVyIGlz
IGEgZ3JheQ0KYXJlYSwgTGVnYWN5IHNyaW92IGlzIGFsbCBhYm91dCBWRiB2bGFucy4NCg0KbXkg
b3BpbmlvbiBpczogVkYgVmxhbiBmaWx0ZXIgIGlzIGEgdmVyeSBiYXNpYyByZXF1aXJlbWVudCBm
b3IgU1JJT1YsDQpub3QgYWxsIEhXIHN1cHBvcnQgc3dpdGNoZGV2IG1vZGUgYW5kIG1hbnkgY3Vz
dG9tZXJzIGFuZCB1c2VjYXNlcyBhcmUNCm1lYW50IHRvIHVzZSBsZWdhY3kgbW9kZSBvbmx5LCBp
dCBpcyB1bmZhaXIgdG8gYmxvY2sgdGhpcyBmZWF0dXJlLCBhbmQNCnRoaXMgaXMgYSBncmVhdCBs
b3NzIG9mIHVzZXJzIGFuZCB1c2UgY2FzZXMgdG8gdGhlIHVwc3RyZWFtIGtlcm5lbC4NCg0KTm93
IGlmIHRoZSBvbmx5IHJlbWFpbmluZyBwcm9ibGVtIGlzIHRoZSB1QVBJLCB3ZSBjYW4gbWluaW1p
emUga2VybmVsDQppbXBhY3Qgb3IgZXZlbiBtYWtlIG5vIGtlcm5lbCBjaGFuZ2VzIGF0IGFsbCwg
b25seSBpcCByb3V0ZTIgYW5kDQpkcml2ZXJzLCBieSByZXVzaW5nIHRoZSBjdXJyZW50IHNldF92
Zl92bGFuX25kby4NCg0KDQo=
