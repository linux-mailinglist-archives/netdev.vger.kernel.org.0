Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2ABD310ACAC
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 10:36:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbfK0Jgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 04:36:46 -0500
Received: from mail-eopbgr50085.outbound.protection.outlook.com ([40.107.5.85]:33252
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726130AbfK0Jgq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Nov 2019 04:36:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QvmlhdXlqzNjfdc8nnbeaJ3EBlCVYJOXLcI+HxOGUfJfy0BwsIGTtn+u5yGcSekYKPpZzgLVpfW7MJMLqvyh0AGQTIxZx/JsR7jJ9vlKsrJuyTZiif1Gz8dXU1NprM2Hcw1J6Go1C98K51kOuVVApxRmAnoXEwq9vn8Je5OeH3idC+9pn/NE/0eMeMCa5K93J5ZegVBXejatFwaIY3f1rh8NaJbPpiPGnaNBOwfLELVJGzVuTGBZYpf0KsTjCRyyJ5v4Y23bYrsWG+ITPYOlavBv4so8VOKlKUKbTUufZzsOHRp2MCJCfX9UjSQKZGkYnnH00BNvDru6tEdxXO6YYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W8GYJsHlCjZr0z0iqmbdDO1bdtYtbasuWv3bbjkbnLk=;
 b=k+7/HGTiWkhG+Q4JXehu0cD30n6fRmLozSYCSjklzjl2eeAPEBFviwP6H8c+gaVkZ/FC3T4SU+R9vmVhugbln/k66o47fH1aW0hTBMomru80zeE6raZ+Jw13aCEpB91EJcbvl6c6+7oxbD2ZNGgsXExx8eMtmuG3VyTERCPbVBNDpLsEnYQZkg7UZgb8Mx/i8zaiNSM39EJO2AmMiab91aYe5Pgthi0IdCBTUaztjEusLroPydau+uJ0cCQ0KO1V76eZ0JcPIWyPFyL7VlqR0y+cwSNRpEFZ0ML1TznxzSxdB1OZ4bpw6EkQBLqc3x6bvuReHiK8ECQtMd/iPV4PIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W8GYJsHlCjZr0z0iqmbdDO1bdtYtbasuWv3bbjkbnLk=;
 b=lPjA/Uqpu42TGi6tS81tD9XS6OyuW2J9mgG2SCvjzXi/Yk67SrVtPIiwx5lFaUjzMWn8WQSqYDzv/vkH9gvODkUlA6c7x+/gXHwP7B86NQWpTNCQGsC7z36sa4z4LZJtOY8UUGAENuXd2r0NVBlr5tSt46Y7j+Ld6N3n+E70y5w=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB5052.eurprd04.prod.outlook.com (20.176.234.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.21; Wed, 27 Nov 2019 09:36:39 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6%4]) with mapi id 15.20.2474.023; Wed, 27 Nov 2019
 09:36:39 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Sean Nyekjaer <sean@geanix.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH V2 0/4] can: flexcan: fixes for stop mode
Thread-Topic: [PATCH V2 0/4] can: flexcan: fixes for stop mode
Thread-Index: AQHVpOdxXAI9W9cZiUqxHtJbOFpoG6eeiWMAgAAhqwCAABa5QA==
Date:   Wed, 27 Nov 2019 09:36:39 +0000
Message-ID: <DB7PR04MB46186472F0437A825548CE11E6440@DB7PR04MB4618.eurprd04.prod.outlook.com>
References: <20191127055334.1476-1-qiangqing.zhang@nxp.com>
 <e936b9b1-d602-ac38-213c-7272df529bef@geanix.com>
 <4a9c2e4a-c62d-6e88-bd9e-01778dab503b@geanix.com>
In-Reply-To: <4a9c2e4a-c62d-6e88-bd9e-01778dab503b@geanix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e153b981-1467-4ff1-7cfe-08d7731d4e2e
x-ms-traffictypediagnostic: DB7PR04MB5052:|DB7PR04MB5052:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB50529F6680D66AF72027CEF4E6440@DB7PR04MB5052.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 023495660C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(346002)(366004)(39860400002)(396003)(199004)(189003)(13464003)(66446008)(229853002)(76176011)(4326008)(2906002)(6506007)(7696005)(316002)(54906003)(5660300002)(110136005)(53546011)(102836004)(26005)(256004)(71200400001)(6436002)(66946007)(9686003)(66476007)(52536014)(33656002)(99286004)(3846002)(186003)(71190400001)(6116002)(14444005)(55016002)(66556008)(6246003)(305945005)(81156014)(2201001)(66066001)(8936002)(64756008)(81166006)(25786009)(76116006)(8676002)(2501003)(74316002)(86362001)(7736002)(11346002)(478600001)(14454004)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB5052;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QH1Kd7ow5AO8R2EcFexBi9kcnYDvsRMROkzhbyRsw7TDhBE0aB4AECRrmkxtuRoVL2wcrwrMpIjuLXsiop4pibqJQ57JOfl9SV/Chwj6lfIKfBr6+GdAC6HAeygWAR+hkY8DKTnwVcYw3RdwcZXw6Loo778RZAnXxSRPlul2yAfxVLhOOiFKuwpPbc168NwN84X6b+BewVQG55JYRpoXmMxsI0jyOaum3sHzC7d6vRCpk1ZlVcQdjvbV0MNWX9h8sLLSV1HpJDRzmk6MwV/KfgPbJ8lTOELrKz/c9BE6pIp3cyn+W0oSCdKYidvb828WiRTpSQzHqlJbLSHU14fydMWyiwJHBRFxqdxILfKnD50HN/WTFbAQn4VynCKfMyDroXhKL+BhUeEEZSeS3llWBwJ14CMTgRv3fHjLoC4SZnOg7yrv9UKXvgxZBXAwc8vM
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e153b981-1467-4ff1-7cfe-08d7731d4e2e
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Nov 2019 09:36:39.7071
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HgJTYlNmXAfiQkXvj3ufX+S/TnI4mMtx/CxN8uGvcUdlufAeVGP9ke82msPbjQ516fHAnCEjcZm9Zh8gAH1uKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5052
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFNlYW4gTnlla2phZXIgPHNl
YW5AZ2Vhbml4LmNvbT4NCj4gU2VudDogMjAxOeW5tDEx5pyIMjfml6UgMTY6MTMNCj4gVG86IEpv
YWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+OyBta2xAcGVuZ3V0cm9uaXguZGU7
DQo+IGxpbnV4LWNhbkB2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IGRsLWxpbnV4LWlteCA8bGludXgt
aW14QG54cC5jb20+OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFU
Q0ggVjIgMC80XSBjYW46IGZsZXhjYW46IGZpeGVzIGZvciBzdG9wIG1vZGUNCj4gDQo+IA0KPiAN
Cj4gT24gMjcvMTEvMjAxOSAwNy4xMiwgU2VhbiBOeWVramFlciB3cm90ZToNCj4gPg0KPiA+DQo+
ID4gT24gMjcvMTEvMjAxOSAwNi41NiwgSm9ha2ltIFpoYW5nIHdyb3RlOg0KPiA+PiDCoMKgwqDC
oENvdWxkIHlvdSBoZWxwIGNoZWNrIHRoZSBwYXRjaCBzZXQ/IFdpdGggeW91ciBzdWdnZXN0aW9u
cywgSSBoYXZlDQo+ID4+IGNvb2tlZCBhIHBhdGNoIHRvIGV4aXQgc3RvcCBtb2RlIGR1cmluZyBw
cm9iZSBzdGFnZS4NCj4gPj4NCj4gPj4gwqDCoMKgwqBJTUhPLCBJIHRoaW5rIHRoaXMgcGF0Y2gg
aXMgdW5uZWVkLCBub3cgaW4gZmxleGNhbiBkcml2ZXIsIGVudGVyDQo+ID4+IHN0b3AgbW9kZSB3
aGVuIHN1c3BlbmQsIGFuZCB0aGVuIGV4aXQgc3RvcCBtb2RlIHdoZW4gcmVzdW1lLg0KPiA+PiBB
RkFJSywgYXMgbG9uZyBhcyBmbGV4Y2FuX3N1c3BlbmQgaGFzIGJlZW4gY2FsbGVkLCBmbGV4Y2Fu
X3Jlc3VtZQ0KPiA+PiB3aWxsIGJlIGNhbGxlZCwgdW5sZXNzIHRoZSBzeXN0ZW0gaGFuZyBkdXJp
bmcgc3VzcGVuZC9yZXN1bWUuIElmIHNvLA0KPiA+PiBvbmx5IGNvZGUgcmVzZXQgY2FuIGFjdGl2
YXRlIE9TIGFnYWluLiBDb3VsZCB5b3UgcGxlYXNlIHRlbGwgbWUgaG93DQo+ID4+IGRvZXMgQ0FO
IHN0dWNrZWQgaW4gc3RvcCBtb2RlIGF0IHlvdXIgc2lkZT8NCj4gPg0KPiA+IEhpIEpvYWtpbSwN
Cj4gPg0KPiA+IFRoYW5rcyBJJ2xsIHRlc3QgdGhpcyA6LSkNCj4gPiBHdWVzcyBJIHdpbGwgaGF2
ZSBkbyBzb21lIGhhY2tpbmcgdG8gZ2V0IGl0IHN0dWNrIGluIHN0b3AgbW9kZS4NCj4gPg0KPiA+
IFdlIGhhdmUgYSBsb3Qgb2YgZGV2aWNlcyBpbiB0aGUgZmllbGQgdGhhdCBkb2Vzbid0IGhhdmU6
DQo+ID4gImNhbjogZmxleGNhbjogZml4IGRlYWRsb2NrIHdoZW4gdXNpbmcgc2VsZiB3YWtldXAi
DQo+ID4NCj4gPiBBbmQgdGhleSBoYXZlIHRyYWZmaWMgb24gYm90aCBDQU4gaW50ZXJmYWNlcywg
dGhhdCB3YXkgaXQncyBxdWl0ZSBlYXN5DQo+ID4gdG8gZ2V0IHRoZW0gc3R1Y2sgaW4gc3RvcCBt
b2RlLg0KPiA+DQo+ID4gL1NlYW4NCj4gDQo+IEhpIEpvYWtpbSwNCj4gDQo+IEkgaGF2ZSBiZWVu
IHRlc3RpbmcgdGhpcy4NCj4gSSBoYXZlIGEgaGFja2VkIHZlcnNpb24gb2YgdGhlIGRyaXZlciB0
aGF0IGNhbGxzDQo+IGZsZXhjYW5fZW50ZXJfc3RvcF9tb2RlKCkgYXMgdGhlIGxhc3Qgc3RlcCBp
biB0aGUgcHJvYmUgZnVuY3Rpb24uDQo+IA0KPiBGaXJzdCBpbnNlcnQgb2YgZmxleGNhbi5rbyB3
aGVuIHN0b3AgbW9kZSBpcyBhY3RpdmF0ZWQ6DQo+IGZsZXhjYW4gMjA5MDAwMC5mbGV4Y2FuOiBM
aW5rZWQgYXMgYSBjb25zdW1lciB0byByZWd1bGF0b3IuNA0KPiANCj4gZmxleGNhbiAyMDkwMDAw
LmZsZXhjYW46IHJlZ2lzdGVyaW5nIG5ldGRldiBmYWlsZWQNCj4gDQo+IGZsZXhjYW4gMjA5MDAw
MC5mbGV4Y2FuOiBEcm9wcGluZyB0aGUgbGluayB0byByZWd1bGF0b3IuNA0KPiANCj4gZmxleGNh
bjogcHJvYmUgb2YgMjA5MDAwMC5mbGV4Y2FuIGZhaWxlZCB3aXRoIGVycm9yIC0xMTANCj4gDQo+
IGZsZXhjYW4gMjA5NDAwMC5mbGV4Y2FuOiBMaW5rZWQgYXMgYSBjb25zdW1lciB0byByZWd1bGF0
b3IuNA0KPiANCj4gZmxleGNhbiAyMDk0MDAwLmZsZXhjYW46IHJlZ2lzdGVyaW5nIG5ldGRldiBm
YWlsZWQNCj4gDQo+IGZsZXhjYW4gMjA5NDAwMC5mbGV4Y2FuOiBEcm9wcGluZyB0aGUgbGluayB0
byByZWd1bGF0b3IuNA0KPiANCj4gZmxleGNhbjogcHJvYmUgb2YgMjA5NDAwMC5mbGV4Y2FuIGZh
aWxlZCB3aXRoIGVycm9yIC0xMTANCj4gDQo+IA0KPiBXaGVuIEkgaW5zZXJ0IGEgZmxleGNhbi5r
byB3aXRoIHRoZSBwYXRjaA0KPiAiY2FuOiBmbGV4Y2FuOiB0cnkgdG8gZXhpdCBzdG9wIG1vZGUg
ZHVyaW5nIHByb2JlIHN0YWdlIjoNCj4gZmxleGNhbiAyMDkwMDAwLmZsZXhjYW46IExpbmtlZCBh
cyBhIGNvbnN1bWVyIHRvIHJlZ3VsYXRvci40DQo+IA0KPiBmbGV4Y2FuIDIwOTAwMDAuZmxleGNh
bjogVW5iYWxhbmNlZCBwbV9ydW50aW1lX2VuYWJsZSENCj4gDQo+IGZsZXhjYW4gMjA5NDAwMC5m
bGV4Y2FuOiBMaW5rZWQgYXMgYSBjb25zdW1lciB0byByZWd1bGF0b3IuNA0KPiANCj4gZmxleGNh
biAyMDk0MDAwLmZsZXhjYW46IFVuYmFsYW5jZWQgcG1fcnVudGltZV9lbmFibGUhDQo+IA0KPiBJ
IHdvcmtzIGFzIEkgZXhwZWN0ZWQgYnV0LCBJIHRoaW5rIHdlIG5lZWQgdG8gZG8gc29tZSBwbV9y
dW50aW1lIGNsZWFudXANCj4gd2hlbiBiYWlsaW5nIHdpdGggZXJyb3IgLTExMC4NCj4gQW55d2F5
cyBpdCB3b3JrcyBncmVhdCwgdGhhbmtzIGZvciB5b3VyIHdvcmsgb24gdGhpcy4NCg0KSGkgU2Vh
biwNCg0KVGhhbmtzIGZvciB5b3VyIHF1aXJrIHRlc3QsIEkgdXNlZCB1bmJpbmQvYmluZCB0byB0
ZXN0LCBkbyBub3QgbWVldCBzdWNoIGlzc3VlLg0KSSB3aWxsIGJ1aWxkIGFzIGEgbW9kdWxlIHRv
IGhhdmUgYSB0ZXN0Lg0KDQpCZXN0IFJlZ2FyZHMsDQpKb2FraW0gWmhhbmcNCj4gL1NlYW4NCg==
