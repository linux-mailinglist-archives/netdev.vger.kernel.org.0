Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43866BC53F
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 11:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504405AbfIXJv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 05:51:58 -0400
Received: from mail-eopbgr70047.outbound.protection.outlook.com ([40.107.7.47]:24526
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390921AbfIXJv6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Sep 2019 05:51:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A5JBQhGAO3kDtTCG33+eNLFwov7X9lOMKrdNO02iLaayRvktvGKNdAd/HT6y6ytW5pMbPhSVmvl6RMddsvUPJ6fwhbbL9Kl5tCT3TmpaX/Hb3Tf+Zt1MNosSSkMEJP/2RkTdQr9ATCgtRA+DalMWxzXKYOkQSQasxAO6pvsxNZ/zwCo3j9amgh8v4exEE14Qtr4rHOxQZVnJBy/9a/vHZe6fKUoZu2q3YGk6JDGObwAcufoxlAfAN48edpTLeB9wLqzWOnWkB+ylpb/MFu6j/3pTPLQ3iYoP/THBce/5t8nVDkSo7QhgiUzzfNOn1F0JUEDncjk06Mb1jORjVsEjrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+sn5u9vv1l3kUaB2zgteyEoD/P7Us6rdmC9hmxcIv5k=;
 b=VQYBIr3vOMLypGYSLd7nR2yRUaM1MyuqzhQXcmThUC7EBXIRnqlDGf6vuYJ/J/DBGcy3GMXeIhTq/pjupUFSEVd/3aXdsNaXjsBPcSilBvZdL4LKe6I0aElotRFjAyJjc3bp22pUqHmPxFp/y2JW9TszTcfeUoMlVUz8YbFGit/nOrHKl9hRRUDdydnJzlhHE7XWZwXKLDZIEjyml5+O6VD40/qkXWbq19mvf5h7OpoBZj3aOrKROCqhKcp6EBc0eF4c36tjIVq8Os7mQuxHDaNGsGIOj/bxchLMH6AkshWM0FWIdgcn4CdLajBq4g8zwvpA1+/fkNzWx7wL9e6ZCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+sn5u9vv1l3kUaB2zgteyEoD/P7Us6rdmC9hmxcIv5k=;
 b=T6JkAb5dnpFVYaOgKPsEFwzyQ+kKRCpwgTKcXGOCSjJ6Jl0k9toKm0EBADUxr1zcmb8F1/J8J3/UIAKgtY83o9Xx98c6JFX+j4qkSPJ+ndqbFlP6vMUl0K9T1aio0TQ3lQ6TadibQDkaVIchMj2IJoIG1mKqBrqEoKXbCpy3+E0=
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com (10.172.11.140) by
 VI1PR0501MB2510.eurprd05.prod.outlook.com (10.168.135.142) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.23; Tue, 24 Sep 2019 09:51:51 +0000
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::c4f0:4270:5311:f4b9]) by VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::c4f0:4270:5311:f4b9%5]) with mapi id 15.20.2284.023; Tue, 24 Sep 2019
 09:51:50 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [pull request][net 0/7] Mellanox, mlx5 fixes 2019-09-24
Thread-Topic: [pull request][net 0/7] Mellanox, mlx5 fixes 2019-09-24
Thread-Index: AQHVcrw3LhU11gL9q0K904XWKmy+0ac6leIA
Date:   Tue, 24 Sep 2019 09:51:50 +0000
Message-ID: <e54d042319eef6a272c1a3e987a0f8513f0de5b7.camel@mellanox.com>
References: <20190924094047.15915-1-saeedm@mellanox.com>
In-Reply-To: <20190924094047.15915-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ad9c9586-ac9b-4238-2669-08d740d4d2ac
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0501MB2510;
x-ms-traffictypediagnostic: VI1PR0501MB2510:
x-microsoft-antispam-prvs: <VI1PR0501MB2510C29F8F79135FB9F4A0E6BE840@VI1PR0501MB2510.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0170DAF08C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(136003)(376002)(396003)(39860400002)(189003)(199004)(2351001)(64756008)(5660300002)(66556008)(71200400001)(66476007)(6506007)(476003)(36756003)(2616005)(81166006)(81156014)(71190400001)(1730700003)(3846002)(6116002)(8936002)(8676002)(305945005)(66066001)(7736002)(6436002)(2501003)(118296001)(486006)(5640700003)(229853002)(2906002)(6486002)(58126008)(478600001)(86362001)(25786009)(26005)(76116006)(6512007)(11346002)(316002)(14454004)(66446008)(186003)(6916009)(102836004)(76176011)(256004)(446003)(66946007)(91956017)(99286004)(6246003)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2510;H:VI1PR0501MB2765.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: NFwrbMCEtQcGtTmPj9t6QI5/FE5+ZTjFn/UD8uwA++7spansKHhc5HCkmvZA+LdHA6U0CKY/T+YO238yCdrWiA9OuGiu7zObRQ9cKsFwdGPpEi1b5su3Ydi5xrp06KP3HUeO2CBjYqzxo+c5eCb8DrJotCktSxZN7Lj0ZsCcNuqpoRXi428532/0dH6NabbG17kCgmx0iOo9jxK5QgTufd6ALRHMg0eB79aogma13SAar+ncs5YleTkL/Wk6oPPVZEupaHWS6yNMGDHY90GatqyniWDTOGQTFHBJGt3bm61kcZrjSCPVy1EK1WvoytzaiXhRpVP0gK0JpKz+zsie1rffOOL8xDikifQiucMuRcEqpQq32Gj0p2phKOSZ/oSRcr/1nlQP1Ug88ZKxYpFfpjPcvwEgJkJ7SVovsDXJnqQ=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <42C852821FA9FE47B39DBBCD65DA9B6B@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad9c9586-ac9b-4238-2669-08d740d4d2ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2019 09:51:50.6756
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MGLcdYb6OW6sypEtl6u/4yhuzxx6+rmQN9mSVQTk5jhfF5xHg1L1kToA9MNNLrFwWU3vam2QUadnR1UMk9gOUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2510
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTA5LTI0IGF0IDA5OjQxICswMDAwLCBTYWVlZCBNYWhhbWVlZCB3cm90ZToN
Cj4gSGkgRGF2ZSwNCj4gDQo+IFRoaXMgc2VyaWVzIGludHJvZHVjZXMgc29tZSBmaXhlcyB0byBt
bHg1IGRyaXZlci4NCj4gRm9yIG1vcmUgaW5mb3JtYXRpb24gcGxlYXNlIHNlZSB0YWcgbG9nIGJl
bG93Lg0KPiANCj4gUGxlYXNlIHB1bGwgYW5kIGxldCBtZSBrbm93IGlmIHRoZXJlIGlzIGFueSBw
cm9ibGVtLg0KPiANCj4gRm9yIC1zdGFibGUgdjQuMTA6DQoNCmNvcnJlY3Rpb246IDQuMjAsIE5P
VCA0LjEwLg0KDQo+ICAoJ25ldC9tbHg1ZTogRml4IHRyYWZmaWMgZHVwbGljYXRpb24gaW4gZXRo
dG9vbCBzdGVlcmluZycpDQo+IA0KPiBGb3IgLXN0YWJsZSB2NC4xOToNCj4gICgnbmV0L21seDU6
IEFkZCBkZXZpY2UgSUQgb2YgdXBjb21pbmcgQmx1ZUZpZWxkLTInKQ0KPiANCj4gRm9yIC1zdGFi
bGUgdjUuMzoNCj4gICgnbmV0L21seDVlOiBGaXggbWF0Y2hpbmcgb24gdHVubmVsIGFkZHJlc3Nl
cyB0eXBlJykNCj4gDQo+IFRoYW5rcywNCj4gU2FlZWQuDQo+IA0KPiAtLS0NCj4gVGhlIGZvbGxv
d2luZyBjaGFuZ2VzIHNpbmNlIGNvbW1pdA0KPiAzNGI0Njg4NDI1ZDk4NDFhMTlhMTVmYTZhZTJi
ZmMxMmEzNzI2NTBmOg0KPiANCj4gICBuZXQ6IGRzYTogVXNlIHRoZSBjb3JyZWN0IHN0eWxlIGZv
ciBTUERYIExpY2Vuc2UgSWRlbnRpZmllciAoMjAxOS0NCj4gMDktMjIgMTU6MjU6MDggLTA3MDAp
DQo+IA0KPiBhcmUgYXZhaWxhYmxlIGluIHRoZSBHaXQgcmVwb3NpdG9yeSBhdDoNCj4gDQo+ICAg
Z2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3NhZWVkL2xpbnV4
LmdpdA0KPiB0YWdzL21seDUtZml4ZXMtMjAxOS0wOS0yNA0KPiANCj4gZm9yIHlvdSB0byBmZXRj
aCBjaGFuZ2VzIHVwIHRvDQo+IGZlMTU4N2E3ZGU5NDkxMmVkNzViYTVkZGJmYWJmMDc0MWY5Zjgy
Mzk6DQo+IA0KPiAgIG5ldC9tbHg1ZTogRml4IG1hdGNoaW5nIG9uIHR1bm5lbCBhZGRyZXNzZXMg
dHlwZSAoMjAxOS0wOS0yNA0KPiAxMjozODowOCArMDMwMCkNCj4gDQo+IC0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gbWx4
NS1maXhlcy0yMDE5LTA5LTI0DQo+IA0KPiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+IEFsYWEgSGxlaWhlbCAoMSk6DQo+
ICAgICAgIG5ldC9tbHg1OiBEUiwgQWxsb3cgbWF0Y2hpbmcgb24gdnBvcnQgYmFzZWQgb24gdmhj
YV9pZA0KPiANCj4gQWxleCBWZXNrZXIgKDIpOg0KPiAgICAgICBuZXQvbWx4NTogRFIsIFJlbW92
ZSByZWR1bmRhbnQgdnBvcnQgbnVtYmVyIGZyb20gYWN0aW9uDQo+ICAgICAgIG5ldC9tbHg1OiBE
UiwgRml4IGdldHRpbmcgaW5jb3JyZWN0IHByZXYgbm9kZSBpbiBzdGVfZnJlZQ0KPiANCj4gQm9k
b25nIFdhbmcgKDEpOg0KPiAgICAgICBuZXQvbWx4NTogQWRkIGRldmljZSBJRCBvZiB1cGNvbWlu
ZyBCbHVlRmllbGQtMg0KPiANCj4gRG15dHJvIExpbmtpbiAoMSk6DQo+ICAgICAgIG5ldC9tbHg1
ZTogRml4IG1hdGNoaW5nIG9uIHR1bm5lbCBhZGRyZXNzZXMgdHlwZQ0KPiANCj4gU2FlZWQgTWFo
YW1lZWQgKDEpOg0KPiAgICAgICBuZXQvbWx4NWU6IEZpeCB0cmFmZmljIGR1cGxpY2F0aW9uIGlu
IGV0aHRvb2wgc3RlZXJpbmcNCj4gDQo+IFlldmdlbnkgS2xpdGV5bmlrICgxKToNCj4gICAgICAg
bmV0L21seDU6IERSLCBGaXggU1cgc3RlZXJpbmcgSFcgYml0cyBhbmQgZGVmaW5pdGlvbnMNCj4g
DQo+ICAuLi4vZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX2ZzX2V0aHRvb2wuYyAgICB8
ICA0ICstDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fdGMu
YyAgICB8IDg5DQo+ICsrKysrKysrKysrKystLS0tLS0tLS0NCj4gIGRyaXZlcnMvbmV0L2V0aGVy
bmV0L21lbGxhbm94L21seDUvY29yZS9tYWluLmMgICAgIHwgIDEgKw0KPiAgLi4uL21lbGxhbm94
L21seDUvY29yZS9zdGVlcmluZy9kcl9hY3Rpb24uYyAgICAgICAgfCAgNCArLQ0KPiAgLi4uL21l
bGxhbm94L21seDUvY29yZS9zdGVlcmluZy9kcl9tYXRjaGVyLmMgICAgICAgfCAxMyArKy0tDQo+
ICAuLi4vZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL3N0ZWVyaW5nL2RyX3J1bGUuYyB8ICAy
ICstDQo+ICAuLi4vZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL3N0ZWVyaW5nL2RyX3N0ZS5j
ICB8IDUwICsrKysrKysrLS0tLQ0KPiAgLi4uL21lbGxhbm94L21seDUvY29yZS9zdGVlcmluZy9k
cl90eXBlcy5oICAgICAgICAgfCAgNyArLQ0KPiAgaW5jbHVkZS9saW51eC9tbHg1L21seDVfaWZj
LmggICAgICAgICAgICAgICAgICAgICAgfCAyOCArKystLS0tDQo+ICA5IGZpbGVzIGNoYW5nZWQs
IDExOSBpbnNlcnRpb25zKCspLCA3OSBkZWxldGlvbnMoLSkNCg==
