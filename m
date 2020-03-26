Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A08F21934EC
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 01:18:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727554AbgCZASC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 20:18:02 -0400
Received: from mail-db8eur05on2066.outbound.protection.outlook.com ([40.107.20.66]:6052
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727498AbgCZASC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 20:18:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OHRQfh6xzBm0/o1CVTC2zmlPV/+k7zgLCCvqj0xLLzSHvM6ZXBl0lpxBplmudv153VfD3PvH2fahSlaBYc/qzJ8rXqKd69yEYgf675yFBQ+IPd5J598rJrIdmJ9UIOzWLNpU5mifu/89IRonhyL5wSQnL7QquUXyj0Uka4fguW1inNVJjcrK0MG4C3/Hdq2R7/ugBxclyR0l85rmbHS85ssBaCIR8frKobyr/+Ljpl3Hbvwp/1tbp1oXt7FsfU26HtbocLe5O/wx/aMV74MOay/8WAeUgFoPI0UXIq2mijAUO4jFj8kWMczswMEik5HNz53POpa9hO4oUkACuxDGmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hk/e5CZGrNmvxs4oz7qsuXPMw/EB+cuBc0AMkkwDYUU=;
 b=LsRj7TXCtZGiSdHIUjvGM0yOH7i1UgAeYl3mQgyoIX9G9/Zef92TxBza/7GvEgq0x0sJ/BSL7eisLbrsOdgXnagsOBDDPHGMxulM9Q8sCSnkEg4x50QBLaawzdN3eIHO1E+iR3Ud7TxumH6+IRi3VT941F4PIFNFMHFF2QScB17vxU3w6IFPU1Vnr3HiDHpGEVJP0aPGfBVVb+7bPJIJirsydWY3ByJLeXjGwPCZy7MYYFO3lgS1FkuR56WazMYSfDU7ydWQBOamhn28pCgfJPszWvjHCF4dLFseMUFLwbp2AO8PO6npfTd+is6nncH2/82/5sYJcn3iBnquYa4HPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hk/e5CZGrNmvxs4oz7qsuXPMw/EB+cuBc0AMkkwDYUU=;
 b=Oy3zBR/yPE3YDc2/3+pYUt8ntW3nmTMdJTgQOYL4y+ZCp7s1aRv0pcMSYDRrLxkiFbjLAKQBjR023a1IhFch0ad27+JJd8xdCrl2a2ep7z6gv49qDPnDvsbMb2UfG1xCby1rtsR8PDz56EYULqMIhnxjxIEAQpknSGaRtRLa+Kk=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5469.eurprd05.prod.outlook.com (20.177.63.79) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.20; Thu, 26 Mar 2020 00:17:58 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2835.023; Thu, 26 Mar 2020
 00:17:58 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "cai@lca.pw" <cai@lca.pw>, Moshe Shemesh <moshe@mellanox.com>
CC:     Jiri Pirko <jiri@mellanox.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Parav Pandit <parav@mellanox.com>,
        Vladyslav Tarasiuk <vladyslavt@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: No networking due to "net/mlx5e: Add support for devlink-port in
 non-representors mode"
Thread-Topic: No networking due to "net/mlx5e: Add support for devlink-port in
 non-representors mode"
Thread-Index: AQHWAloL2CfcbFQGwkiQg3ScmAQ5XKhZs9cAgAAOc4CAAED/gA==
Date:   Thu, 26 Mar 2020 00:17:58 +0000
Message-ID: <6b539e30f4a610b2476fde1c637c31db36fb1e92.camel@mellanox.com>
References: <0DF043A6-F507-4CB4-9764-9BD472ABCF01@lca.pw>
         <52874e86-a8ae-dcf0-a798-a10e8c97d09e@mellanox.com>
         <483B11FF-4004-4909-B89A-06CA48E3BBBC@lca.pw>
In-Reply-To: <483B11FF-4004-4909-B89A-06CA48E3BBBC@lca.pw>
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
x-ms-office365-filtering-correlation-id: de085e53-923c-4736-b1cf-08d7d11b2361
x-ms-traffictypediagnostic: VI1PR05MB5469:|VI1PR05MB5469:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5469E8D1FD576322B42DD882BECF0@VI1PR05MB5469.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0354B4BED2
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(136003)(376002)(39860400002)(346002)(396003)(366004)(6486002)(5660300002)(6506007)(186003)(26005)(53546011)(71200400001)(478600001)(2906002)(64756008)(4326008)(66556008)(66476007)(36756003)(66946007)(91956017)(76116006)(966005)(66446008)(110136005)(8936002)(86362001)(2616005)(81166006)(54906003)(316002)(6636002)(81156014)(6512007)(8676002);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: blfgok5kF9H8AHXNtZ7hz8tJkR+sV6QpIex5VQy1SwlAHeaYLKeTtc3aBrAj4eMYkPrH5PduuRatfvmtOTVBj5oNIUnbJX5fRL2QGypk1LwSkxP6DSEv5p6+ORRzCejtrHwnvU5+kOVQQFkSDWQoBWJp0SbO3YF3DPKWTXjgwN8BRQ0zHGorc23TAo3wnKpcpIhaC/fKDsQ/t552a68RabbJ1lHml/3hASJvMUyIwrXAT7QgsQBtldZ3Xs3gWoBOzR4ZUf9shyLY64HjvM7Wt3qFx8bVLaZIEZXRmb6pLe292gfyjXokiOpLa+9oq/AUr6V5vPBKVXdPm+P2LjswmldrFvJ8MqVpLL/C533M31xQ2UfUJPRvirJaPIggT+M99uY03kDF4xcrDryiknVFAM3Kytpn/2LI9FH2mJ3U7A6fnOZHa0/uydFFyNdkyZdklmh3ah5VqFdz+Y1NJaP7+PKxzAoolywmXnALMeFvzOnoumPABdaF4Y+/yyUqw6ozhq1pVsOu5dW+QWsBwSSTTw==
x-ms-exchange-antispam-messagedata: ZZwU+N9NFL+Kio/w5Jeky+0ZGwHaKz4faSeqMvNUCFRsWffbiNLXa7uMWhVXXi2DXKHC35mdoSqCmeQkBcfM88q605+zJ4DDBzr49wXAKAkV5EgtuIJzMchNFGEwJ7n4NJ9elP11M1jJY2GFYrQR+A==
Content-Type: text/plain; charset="utf-8"
Content-ID: <5FCEB77FEF22C54E83FAFE1DC8EBA4D4@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de085e53-923c-4736-b1cf-08d7d11b2361
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Mar 2020 00:17:58.2902
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4XqfI+GCiTgYYM0YBl4X9BrBw8oEfC2GAAukT7fuBg5EzfxwhCjAU+v4V8UY5LC/xlL6qHG2VGdzsCSrhn/geg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5469
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIwLTAzLTI1IGF0IDE2OjI1IC0wNDAwLCBRaWFuIENhaSB3cm90ZToNCj4gPiBP
biBNYXIgMjUsIDIwMjAsIGF0IDM6MzMgUE0sIE1vc2hlIFNoZW1lc2ggPG1vc2hlQG1lbGxhbm94
LmNvbT4NCj4gPiB3cm90ZToNCj4gPiANCj4gPiANCj4gPiBPbiAzLzI1LzIwMjAgNjowMSBBTSwg
UWlhbiBDYWkgd3JvdGU6DQo+ID4gPiBSZXZlcnRlZCB0aGUgbGludXgtbmV4dCBjb21taXQgYzZh
Y2Q2MjllZSAo4oCcbmV0L21seDVlOiBBZGQNCj4gPiA+IHN1cHBvcnQgZm9yIGRldmxpbmstcG9y
dCBpbiBub24tcmVwcmVzZW50b3JzIG1vZGXigJ0pDQo+ID4gPiBhbmQgaXRzIGRlcGVuZGVuY2ll
cywNCj4gPiA+IA0KPiA+ID4gMTYyYWRkOGNiYWU0ICjigJxuZXQvbWx4NWU6IFVzZSBkZXZsaW5r
IHZpcnR1YWwgZmxhdm91ciBmb3IgVkYNCj4gPiA+IGRldmxpbmsgcG9ydOKAnSkNCj4gPiA+IDMx
ZTg3YjM5YmE5ZCAo4oCcbmV0L21seDVlOiBGaXggZGV2bGluayBwb3J0IHJlZ2lzdGVyIHNlcXVl
bmNl4oCdKQ0KPiA+ID4gDQo+ID4gPiBvbiB0aGUgdG9wIG9mIG5leHQtMjAyMDAzMjQgYWxsb3dl
ZCBOSUNzIHRvIG9idGFpbiBhbiBJUHY0DQo+ID4gPiBhZGRyZXNzIGZyb20gREhDUCBhZ2Fpbi4N
Cj4gPiANCj4gPiBUaGVzZSBwYXRjaGVzIHNob3VsZCBub3QgaW50ZXJmZXJlIERIQ1AuDQo+ID4g
DQo+ID4gWW91IG1pZ2h0IGhhdmUgZGVwZW5kZW5jaWVzIG9uIGludGVyZmFjZSBuYW1lIHdoaWNo
IHdhcyBjaGFuZ2VkIGJ5DQo+ID4gdGhpcyBwYXRjaCwgcGxlYXNlIGNoZWNrLg0KPiANCj4gWWVz
LA0KPiANCj4gQmVmb3JlLA0KPiBbICAyMzguMjI1MTQ5XVsgVDIwMjFdIG1seDVfY29yZSAwMDAw
OjBiOjAwLjEgZW5wMTFzMGYxOiByZW5hbWVkIGZyb20NCj4gZXRoMQ0KPiBbICAyMzguNTExMzI0
XVsgVDIwMzVdIG1seDVfY29yZSAwMDAwOjBiOjAwLjAgZW5wMTFzMGYwOiByZW5hbWVkIGZyb20N
Cj4gZXRoMA0KPiANCj4gTm93LA0KPiBbICAyMzQuNDQ4NDIwXVsgVDIwMTNdIG1seDVfY29yZSAw
MDAwOjBiOjAwLjEgZW5wMTFzMGYxbnAxOiByZW5hbWVkDQo+IGZyb20gZXRoMQ0KPiBbICAyMzQu
NjY0MjM2XVsgVDIwNDJdIG1seDVfY29yZSAwMDAwOjBiOjAwLjAgZW5wMTFzMGYwbnAwOiByZW5h
bWVkDQo+IGZyb20gZXRoMA0KPiANCg0KaXQgaXMgbm90IGEgZ29vZCBpZGVhIHRvIHVzZSB0aGUg
aW50ZXJmYWNlIG5hbWUgYXMgYSB1bmlxdWUgaWRlbnRpZmllciwNCnRoaXMgaXMgbm90IHJlc2ls
aWVudCBmb3Iga2VybmVsIHVwZGF0ZXMgb3IgY29uZmlndXJhdGlvbiB1cGRhdGVzLCBlLmcNCmlu
c3RhbGxpbmcgYW4gZXh0cmEgY2FyZA0KDQpKdXN0IHVzZSB0aGUgSFcgbWFjIGFkZHJlc3MgYXMg
YSB1bmlxdWUgaWRlbnRpZmllciBpbiB0aGUgbmV0d29yayANCnNjcmlwdHM6DQoNCmZyb20gWzFd
Og0KSFdBRERSPU1BQy1hZGRyZXNzDQp3aGVyZSBNQUMtYWRkcmVzcyBpcyB0aGUgaGFyZHdhcmUg
YWRkcmVzcyBvZiB0aGUgRXRoZXJuZXQgZGV2aWNlIGluIHRoZQ0KZm9ybSBBQTpCQjpDQzpERDpF
RTpGRi4gVGhpcyBkaXJlY3RpdmUgbXVzdCBiZSB1c2VkIGluIG1hY2hpbmVzDQpjb250YWluaW5n
IG1vcmUgdGhhbiBvbmUgTklDIHRvIGVuc3VyZSB0aGF0IHRoZSBpbnRlcmZhY2VzIGFyZSBhc3Np
Z25lZA0KdGhlIGNvcnJlY3QgZGV2aWNlIG5hbWVzIHJlZ2FyZGxlc3Mgb2YgdGhlIGNvbmZpZ3Vy
ZWQgbG9hZCBvcmRlciBmb3INCmVhY2ggTklDJ3MgbW9kdWxlLiANCg0KWzFdIA0KaHR0cHM6Ly9h
Y2Nlc3MucmVkaGF0LmNvbS9kb2N1bWVudGF0aW9uL2VuLXVzL3JlZF9oYXRfZW50ZXJwcmlzZV9s
aW51eC82L2h0bWwvZGVwbG95bWVudF9ndWlkZS9zMS1uZXR3b3Jrc2NyaXB0cy1pbnRlcmZhY2Vz
DQoNCg==
