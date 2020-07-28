Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3934623064A
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 11:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728097AbgG1JQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 05:16:10 -0400
Received: from mail-eopbgr50081.outbound.protection.outlook.com ([40.107.5.81]:53954
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727970AbgG1JQJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 05:16:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IT58amYysBFdHusQqmibYQfBzAwHlDrWqneN4XKH6i90tRxrQIgoXwisG47zT7c2sRR6i2/jRhCBOlrxD5EsnGy8EMGbOvGosnqvZ5eFvAkYpOqLAmreq7cBumqhK4jQNa3rb64oMjx/Gsjn6gTOz6Sh7XLn8283CPy2d2VoGH5Ol9YOHpQSE3thVaIqsrh52BpFIIPZLuJPVaZYqxsiGSgC/81A0g8MF69MkTare/3TKuCUwfvS/7uT2/kzpme/XQiqpeBTU9JHfl1oASrk/HdwCTSRsffCuanaLwid/VICp5ckBPEljmOiLRrQnRnNvsh7iGEz9BA/gDg+qWBItg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1xlIjGrvspWOFdQjYKWRWw2cyf6Ln2Uj8+SfLLxGk0E=;
 b=bOszIjVQqIRDceysWC9LTQ2GieB33j9wxpMYqa/3dkM+F7kQLK82Y9MI8OnOJgkho38C3K8ztTErmuUY6ljud6FEx/7qpZSwUsk5/m57xuAfM60OLBxZ9u6OOyL/8FewwfcTiuQeuicQmUp8rvSJeYrAJIs1oGQ0U5ef3q97nK16DqnQ3TiV9H0r2gM6Pnd8ccHVPVBf3t6WRHEZOk+3by/2R6/KpogKlpjgZ88lXNJXTUHm99CEua1hvxAWa9eLblWe3Bc2og21hEFcdUi5+62BmGPYOMaFTBtuNbCwUk6zisTZTOHJSPe6H6/69AXglXJfDijgY5n8WM8urZTOpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1xlIjGrvspWOFdQjYKWRWw2cyf6Ln2Uj8+SfLLxGk0E=;
 b=jnla4LAvT+30ZFvxSzj+hfJOps6i6o8PDCuQ/soxaYYkLdAE7FcQGgnm2/a7eyvModXM4lCyVMLIWrAcc+2SDkcfQLyJT4k05VAT6f5I8VCVlVDkF/AHL+3Zu/AzP6HtBzhufVjoBh/+4d/UZw5AgY7YkMVpvBlrYYfGQseyUT0=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4879.eurprd05.prod.outlook.com (2603:10a6:803:5c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23; Tue, 28 Jul
 2020 09:16:05 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529%5]) with mapi id 15.20.3216.034; Tue, 28 Jul 2020
 09:16:05 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [pull request][net 00/12] mlx5 fixes 2020-07-28
Thread-Topic: [pull request][net 00/12] mlx5 fixes 2020-07-28
Thread-Index: AQHWZL8BU6IPL6yqE0+y0Qk9RqMqYqkctfCA
Date:   Tue, 28 Jul 2020 09:16:05 +0000
Message-ID: <6c1b6d3e5172d98ef4f325666c1ca3bec1939456.camel@mellanox.com>
References: <20200728091035.112067-1-saeedm@mellanox.com>
In-Reply-To: <20200728091035.112067-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.3 (3.36.3-1.fc32) 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 321af0db-b8bf-4d87-248c-08d832d6db75
x-ms-traffictypediagnostic: VI1PR05MB4879:
x-microsoft-antispam-prvs: <VI1PR05MB48795163A70B597466F4B7BDBE730@VI1PR05MB4879.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7dS1DGChWNNm1hmBaqxF8KrCV3/1AKlJpn4jOGxMEl0nHObHrADez5r7j65bp8Kk2E9NdHgnhFq0DKeQ8RLgZLlyvQs6HMzivdPVl2KQZsmh+ysKdJ92trS6EGQze2GsnMxphFowkhIVVzMXQ9dpEulZ9DpnEZLX2GuZZMBT1GyEErffLSQDPERkN7TKhlhYakGInqYApgCDPh7ThKqWxKZx9dnQbM8GaqFHVrH9iwikEhClCngLzhEjIO9KQIJY/130F9D2prhtgBT+S0nU5DA9gyiJ0mFUX9je2K9vwKSrSSXKHtocQJpM3u5mge5i
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(366004)(346002)(376002)(136003)(6512007)(91956017)(8676002)(86362001)(8936002)(2906002)(64756008)(66946007)(66446008)(66556008)(66476007)(76116006)(2616005)(26005)(83380400001)(186003)(36756003)(478600001)(6506007)(316002)(5660300002)(4326008)(71200400001)(110136005)(6486002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 3ioGuE/GiqsyLlrWUOlhVirjrDltt6nQZOZ2bIgPTE1DuOXRSSR3jIG8/FACXiWmndfsRSO1x4D1SwAJZwjuy27yN0N9bE6t15LR5mroEYEUhLoQjcHCbimJev07mhMcGRDxLdT6GAedP+o1hJK8r3jM6ePTHWarfp5PHQj/qtCNS3TqtIp3DhHdGiO6q37MgVup+GDXAHOJR8nN6NkzL5IvccSkzO6QpvEMr813ShiDUFti+BrquQjy7gKR74PeK7suFBGEtp2wDJgCTJmXR3PT45TgyAmE+4U0XsQhvHtyAyC7C2doaWBl/EWctzIS3569bRXcNtSQBmmsFJ2v8xnBc+6TuZ/i0rVNFJJRv9RCXdzI/1LBLp1gVphxsPsQFzUSQqHYJv1OlrAp7SbaiBvIDw3mN57HGFqe1MTq+w7SheLMxZqz9ygQIymtARH72VmhCy4Yy2oddxP5JkRHUVTgBNa+iwFkg7Uksny+RHw=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <6E080581B421C74484D446F9CB91FD4C@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 321af0db-b8bf-4d87-248c-08d832d6db75
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jul 2020 09:16:05.7515
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sWiRq4GK9Yqw2cb2w1gO+KkhZXUhY/oHL6zycf6BfcXGTFiQvyA+uIijrGCF6hEI55b6xH8K+puEnMebYViz+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4879
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIwLTA3LTI4IGF0IDAyOjEwIC0wNzAwLCBTYWVlZCBNYWhhbWVlZCB3cm90ZToN
Cj4gSGkgRGF2ZSwNCj4gDQo+IFRoaXMgc2VyaWVzIGludHJvZHVjZXMgc29tZSBmaXhlcyB0byBt
bHg1IGRyaXZlci4NCj4gDQo+IFBsZWFzZSBwdWxsIGFuZCBsZXQgbWUga25vdyBpZiB0aGVyZSBp
cyBhbnkgcHJvYmxlbS4NCj4gDQoNCkZvciAtU3RhYmxlOg0KDQpGb3IgLXN0YWJsZSB2NC45DQog
KCduZXQvbWx4NWU6IEZpeCBlcnJvciBwYXRoIG9mIGRldmljZSBhdHRhY2gnKQ0KDQpGb3IgLXN0
YWJsZSB2NC4xNQ0KICgnbmV0L21seDU6IFZlcmlmeSBIYXJkd2FyZSBzdXBwb3J0cyByZXF1ZXN0
ZWQgcHRwIGZ1bmN0aW9uIG9uIGEgZ2l2ZW4NCnBpbicpDQoNCkZvciAtc3RhYmxlIHY1LjENCiAo
J25ldC9tbHg1ZTogSG9sZCByZWZlcmVuY2Ugb24gbWlycmVkIGRldmljZXMgd2hpbGUgYWNjZXNz
aW5nIHRoZW0nKQ0KDQpGb3IgLXN0YWJsZSB2NS4zDQogKCduZXQvbWx4NWU6IE1vZGlmeSB1cGxp
bmsgc3RhdGUgb24gaW50ZXJmYWNlIHVwL2Rvd24nKQ0KDQpGb3IgLXN0YWJsZSB2NS40DQogKCdu
ZXQvbWx4NWU6IEZpeCBrZXJuZWwgY3Jhc2ggd2hlbiBzZXR0aW5nIHZmIFZMQU5JRCBvbiBhIFZG
IGRldicpDQogKCduZXQvbWx4NTogRS1zd2l0Y2gsIERlc3Ryb3kgVFNBUiB3aGVuIGZhaWwgdG8g
ZW5hYmxlIHRoZSBtb2RlJykNCg0KRm9yIC1zdGFibGUgdjUuNQ0KICgnbmV0L21seDU6IEUtc3dp
dGNoLCBEZXN0cm95IFRTQVIgYWZ0ZXIgcmVsb2FkIGludGVyZmFjZScpDQoNCkZvciAtc3RhYmxl
IHY1LjcNCiAoJ25ldC9tbHg1OiBGaXggYSBidWcgb2YgdXNpbmcgcHRwIGNoYW5uZWwgaW5kZXgg
YXMgcGluIGluZGV4JykNCg0KPiBUaGFua3MsDQo+IFNhZWVkLg0KPiANCj4gLS0tDQo+IFRoZSBm
b2xsb3dpbmcgY2hhbmdlcyBzaW5jZSBjb21taXQNCj4gMTgxOTY0ZTYxOWI3NmFlMmU3MWJjZGM2
MDAxY2Y5NzdiZWM0Y2Y2ZToNCj4gDQo+ICAgZml4IGEgYnJhaW5vIGluIGNtc2doZHJfZnJvbV91
c2VyX2NvbXBhdF90b19rZXJuKCkgKDIwMjAtMDctMjcNCj4gMTM6MjU6MzkgLTA3MDApDQo+IA0K
PiBhcmUgYXZhaWxhYmxlIGluIHRoZSBHaXQgcmVwb3NpdG9yeSBhdDoNCj4gDQo+ICAgZ2l0Oi8v
Z2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3NhZWVkL2xpbnV4LmdpdA0K
PiB0YWdzL21seDUtZml4ZXMtMjAyMC0wNy0yOA0KPiANCj4gZm9yIHlvdSB0byBmZXRjaCBjaGFu
Z2VzIHVwIHRvDQo+IDBlMjMxMDk4ZTJkOTc4NzlhZDVmY2Y5YzIxN2FlODM2OTgzYmM5ZGY6DQo+
IA0KPiAgIG5ldC9tbHg1ZTogRml4IGtlcm5lbCBjcmFzaCB3aGVuIHNldHRpbmcgdmYgVkxBTklE
IG9uIGEgVkYgZGV2DQo+ICgyMDIwLTA3LTI4IDAyOjA2OjA2IC0wNzAwKQ0KPiANCj4gLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LQ0KPiBtbHg1LWZpeGVzLTIwMjAtMDctMjgNCj4gDQo+IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gQWxhYSBIbGVpaGVs
ICgxKToNCj4gICAgICAgbmV0L21seDVlOiBGaXgga2VybmVsIGNyYXNoIHdoZW4gc2V0dGluZyB2
ZiBWTEFOSUQgb24gYSBWRiBkZXYNCj4gDQo+IEF5YSBMZXZpbiAoMSk6DQo+ICAgICAgIG5ldC9t
bHg1ZTogRml4IGVycm9yIHBhdGggb2YgZGV2aWNlIGF0dGFjaA0KPiANCj4gRWxpIENvaGVuICgx
KToNCj4gICAgICAgbmV0L21seDVlOiBIb2xkIHJlZmVyZW5jZSBvbiBtaXJyZWQgZGV2aWNlcyB3
aGlsZSBhY2Nlc3NpbmcNCj4gdGhlbQ0KPiANCj4gRXJhbiBCZW4gRWxpc2hhICgzKToNCj4gICAg
ICAgbmV0L21seDU6IEZpeCBhIGJ1ZyBvZiB1c2luZyBwdHAgY2hhbm5lbCBpbmRleCBhcyBwaW4g
aW5kZXgNCj4gICAgICAgbmV0L21seDU6IFZlcmlmeSBIYXJkd2FyZSBzdXBwb3J0cyByZXF1ZXN0
ZWQgcHRwIGZ1bmN0aW9uIG9uIGENCj4gZ2l2ZW4gcGluDQo+ICAgICAgIG5ldC9tbHg1OiBRdWVy
eSBQUFMgcGluIG9wZXJhdGlvbmFsIHN0YXR1cyBiZWZvcmUgcmVnaXN0ZXJpbmcNCj4gaXQNCj4g
DQo+IE1hb3IgRGlja21hbiAoMSk6DQo+ICAgICAgIG5ldC9tbHg1ZTogRml4IG1pc3NpbmcgY2xl
YW51cCBvZiBldGh0b29sIHN0ZWVyaW5nIGR1cmluZyByZXANCj4gcnggY2xlYW51cA0KPiANCj4g
TWFvciBHb3R0bGllYiAoMSk6DQo+ICAgICAgIG5ldC9tbHg1OiBGaXggZm9yd2FyZCB0byBuZXh0
IG5hbWVzcGFjZQ0KPiANCj4gUGFyYXYgUGFuZGl0ICgyKToNCj4gICAgICAgbmV0L21seDU6IEUt
c3dpdGNoLCBEZXN0cm95IFRTQVIgd2hlbiBmYWlsIHRvIGVuYWJsZSB0aGUgbW9kZQ0KPiAgICAg
ICBuZXQvbWx4NTogRS1zd2l0Y2gsIERlc3Ryb3kgVFNBUiBhZnRlciByZWxvYWQgaW50ZXJmYWNl
DQo+IA0KPiBSYWVkIFNhbGVtICgxKToNCj4gICAgICAgbmV0L21seDVlOiBGaXggc2xhYi1vdXQt
b2YtYm91bmRzIGluIG1seDVlX3JlcF9pc19sYWdfbmV0ZGV2DQo+IA0KPiBSb24gRGlza2luICgx
KToNCj4gICAgICAgbmV0L21seDVlOiBNb2RpZnkgdXBsaW5rIHN0YXRlIG9uIGludGVyZmFjZSB1
cC9kb3duDQo+IA0KPiAgLi4uL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4vcmVw
L2JvbmQuYyAgfCAgNyArLQ0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9j
b3JlL2VuX21haW4uYyAgfCAyNyArKysrKysrLQ0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVs
bGFub3gvbWx4NS9jb3JlL2VuX3JlcC5jICAgfCAgMyArDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5l
dC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fdGMuYyAgICB8ICA4ICsrLQ0KPiAgZHJpdmVycy9uZXQv
ZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Vzd2l0Y2guYyAgfCAyNyArKysrKy0tLQ0KPiAg
ZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Vzd2l0Y2guaCAgfCAgMiAr
DQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZnNfY29yZS5jICB8
IDI4ICsrLS0tLS0tDQo+ICAuLi4vbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9saWIv
Y2xvY2suYyAgICB8IDc4DQo+ICsrKysrKysrKysrKysrKysrKy0tLS0NCj4gIGluY2x1ZGUvbGlu
dXgvbWx4NS9tbHg1X2lmYy5oICAgICAgICAgICAgICAgICAgICAgIHwgIDEgKw0KPiAgOSBmaWxl
cyBjaGFuZ2VkLCAxMjcgaW5zZXJ0aW9ucygrKSwgNTQgZGVsZXRpb25zKC0pDQo=
