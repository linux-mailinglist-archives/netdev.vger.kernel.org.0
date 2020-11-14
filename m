Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91ED52B2AB7
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 02:59:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbgKNB6z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 20:58:55 -0500
Received: from mail-am6eur05on2073.outbound.protection.outlook.com ([40.107.22.73]:13792
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725981AbgKNB6y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 20:58:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mRXOIp7+2s0uUX/H/RE0olwJXv8c2Q5VOm99jUUS5We24iHIsiPvlr5e44NOehGFto5J1yv9N185ogIsjWmjj4cspNE/3oFsHLXr/TeAJj2NVQnqCLWCETolcDamqlwIUf7GIX7RzjCgUZopYuj3f2ufPt2+jRiEyblLmZyJjy63XUls4FUu1f6k7O/aFRUgOqS2iW1hcTBLGM8kp4+Q5aLOA0gkFuX9CF6cEpbyWWMtIc1Q1pLvRuVbivgp2pWk51sdXpo9uSVK+skAeioCa+Cn8zps+EhqgSXKGIBHqmxYvc2kIk4WK8kwIvIYG/cFFIc0xu7WnWJZ/e9SIHS8RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4sagwOXyf1IjiiXYszTOfaOBsddkBYt10X1ZHSwEXAg=;
 b=CnyQSI6r587dQwzVNhfEg0LYXg/8K07uuInZ35NtChw/DQSXgDWGcoW/OQxh8nRWbrh2tVy5/ZyH/HtC7m8zsczTYAQoOb7cUMMf1OYxPcWTNmzUlf5zN6gtLrOnv05SdoHwGkHPYd6+/xvNLmA6eC7JiPlk8iDfs+FxU1+gQAtCbBJnhhKGMVUUc3n1A6+lchfZeS34BoKYmL3Wh/LprF9eRtGh8OjMtK12VG+oZgw7eQrsXujSs814YWg9M0/sEwk3BybYCti6VgxmntVDLcV8wAgVga48WNzC2jLVtdgahm2GFZ6YK+CoYAtaJft1oCNlLu5abv3F16yi43hgFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4sagwOXyf1IjiiXYszTOfaOBsddkBYt10X1ZHSwEXAg=;
 b=fsHi/gDLNMHoWZyYsKB/LVXmnLVRbomCyjIsPTg+n38c1WvGnnO/IMVmoDrKLW3V47Y5LRteYbME0xUjNcjSKL64LstAW2TsxiixexzWhNIsyPBpntyIg5z3Y2zEDTPPxLbKRWo7D0TiKmsr682xoLbpBauxswG3zHshDuLmcOU=
Received: from AM8PR04MB7315.eurprd04.prod.outlook.com (2603:10a6:20b:1d4::7)
 by AM0PR0402MB3585.eurprd04.prod.outlook.com (2603:10a6:208:1c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Sat, 14 Nov
 2020 01:58:44 +0000
Received: from AM8PR04MB7315.eurprd04.prod.outlook.com
 ([fe80::a5fd:3540:9ddd:dc60]) by AM8PR04MB7315.eurprd04.prod.outlook.com
 ([fe80::a5fd:3540:9ddd:dc60%6]) with mapi id 15.20.3564.025; Sat, 14 Nov 2020
 01:58:44 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Kegl Rohit <keglrohit@gmail.com>,
        David Laight <David.Laight@aculab.com>
CC:     Eric Dumazet <eric.dumazet@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] Re: Fwd: net: fec: rx descriptor ring out of order
Thread-Topic: [EXT] Re: Fwd: net: fec: rx descriptor ring out of order
Thread-Index: AQHWuD4rFwSOt0MMNkWHUhyv65mYbKnDNjYAgAJ35QCAAFBgAIAA475g
Date:   Sat, 14 Nov 2020 01:58:44 +0000
Message-ID: <AM8PR04MB7315635D8FFC131B04B25E00FFE50@AM8PR04MB7315.eurprd04.prod.outlook.com>
References: <CAMeyCbh8vSCnr-9-odi0kg3E8BGCiETOL-jJ650qYQdsY0wxeA@mail.gmail.com>
 <CAMeyCbjuj2Q2riK2yzKXRfCa_mKToqe0uPXKxrjd6zJQWaXxog@mail.gmail.com>
 <3f069322-f22a-a2e8-1498-0a979e02b595@gmail.com>
 <739b43c5c77448c0ab9e8efadd33dbfb@AcuMS.aculab.com>
 <CAMeyCbj4aVRtVQfzKmHvhUkzh08PqNs2DHS1nobbx0nR4LoXbg@mail.gmail.com>
 <CAMeyCbjOzJw7e3+e-AwnCzRpYWYT5OjFSH=+eEsZcEBrJ4BCYg@mail.gmail.com>
In-Reply-To: <CAMeyCbjOzJw7e3+e-AwnCzRpYWYT5OjFSH=+eEsZcEBrJ4BCYg@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [101.86.122.105]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7084a64a-b110-411c-01a8-08d88840d173
x-ms-traffictypediagnostic: AM0PR0402MB3585:
x-microsoft-antispam-prvs: <AM0PR0402MB3585B12EAC051F98FDE387BAFFE50@AM0PR0402MB3585.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: F6PQAwxiwUAY7/WlXoyJlRRi799oj0iUMerbLVsh0ClzLBkmMeNDORyafjESbjlvTWdOAy/Z/ngdWWUsfFJ6RHY4UtqlOve0auzs9cYP6UWfmOrbaB6KDJXJ78DoX6rOrw3id+X2FeKyLa36ZjLZv2iItpEQyPj4V9bJl62aYqn/gOiNV/CEdNgfiQ5D6jgI9bsIgJ9MQwiglfniaSGSEXpyWdZaAcieKa1E2nImA8meyUF6MPzXhxXYXrfJiEYXgxKSUBVEf31WGLvQYO8sD1uKgrHTRiQBlO8PmPUyChHtt4ECz8kX+IKeU4PbJmngiDlw3oec+thvQpdCQpm+ZUS1JwwwPGeik1+dlz0AgzyA8jESPlMif46EDx3WLtXAmPTZQaXQkqfxT+QXMqyIHi++WbY+nr3o93Ywbf5nt8TKe1qCRdVkY+95b3Xck356ftuWI+uJq413Uo4foIdXdw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR04MB7315.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(396003)(376002)(39850400004)(346002)(316002)(83380400001)(2906002)(186003)(86362001)(9686003)(6506007)(7696005)(53546011)(55016002)(66556008)(4326008)(71200400001)(8676002)(5660300002)(76116006)(66446008)(26005)(66946007)(66476007)(110136005)(54906003)(33656002)(966005)(478600001)(45080400002)(52536014)(64756008)(8936002)(6606295002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: N7C21vAjVBs07IrojNQXiETZNYwMHkyLP0S4ujdPONHmXt7Srhzgbl0pxjScQK10rPby1q6ElLGjDq/pu8R6ON3k4R66IFcHm6MIM6nprT4/SURcxWlfOvQ1OwdC4x6NGGXKWYy6WcqjlxASF5cnRIaq7BGxsLDnmpKuDn+dKpLFQLS7opROigvqu+GFe6bCyX84GQhPQFQmex7/PKEIj7t2FAHK0g6VlfMxucp2o4AvoECj7APzF6d/n4eLwvirJA36Jw7MYS1ByFOl4MleC6GSQ4v2Gb7iVad3autp6R+IuL7vZc4YoEz8KRVSB/VwaiCV3hVFMTGgJFEvPS5BZpfMGcce1pRc4XsC4UTng2gYvhWKu4MLLRutmoBS+euQau6GeEXBWRVIvPNpwRmOukCvWT8eNUSkBM4CTr4B5FkdrCtERD0KKGve1UB+wAZaaFKe6bX8Hdgi/tNMl0JQOH/JWuDGVg3rP2xP+RssSXy+JhgOaLjGG+P96eLmtM1gl0FnIigoIZOnycMKxATd3SASgY0wIUjndnUrnYmy3ruUxBVsEQVEF5GLk6ytmNwqdgEsnh8uzSRfZYsMNOgbcziHhPt49NjotbFtOtac/iaDKSLrWx4ZWOhFESYOe6IoB+v/MWFrlvn4YiLaHKJIXA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM8PR04MB7315.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7084a64a-b110-411c-01a8-08d88840d173
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2020 01:58:44.5458
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +Ps0BPxPGSz6RxvVhsUj+O2dDTsxSWkt7BWIUniJO1oIzHxCu+c1xlHP6m02G/YD+xYiiqzUv4CsC4nv9V/6EA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3585
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogS2VnbCBSb2hpdCA8a2VnbHJvaGl0QGdtYWlsLmNvbT4gU2VudDogRnJpZGF5LCBOb3Zl
bWJlciAxMywgMjAyMCA4OjIxIFBNDQo+IE9uIEZyaSwgTm92IDEzLCAyMDIwIGF0IDg6MzMgQU0g
S2VnbCBSb2hpdCA8a2VnbHJvaGl0QGdtYWlsLmNvbT4gd3JvdGU6DQo+ID4NCj4gPiA+IFdoYXQg
YXJlIHRoZSBhZGRyZXNzZXMgb2YgdGhlIHJpbmcgZW50cmllcz8NCj4gPiA+IEkgYmV0IHRoZXJl
IGlzIHNvbWV0aGluZyB3cm9uZyB3aXRoIHRoZSBjYWNoZSBjb2hlcmVuY3kgYW5kL29yDQo+ID4g
PiBmbHVzaGluZy4NCj4gPiA+DQo+ID4gPiBTbyB0aGUgTUFDIGhhcmR3YXJlIGhhcyBkb25lIHRo
ZSB3cml0ZSBidXQgKHNvbWV3aGVyZSkgaXQgaXNuJ3QNCj4gPiA+IHZpc2libGUgdG8gdGhlIGNw
dSBmb3IgYWdlcy4NCj4gPg0KPiA+IENNQSBtZW1vcnkgaXMgZGlzYWJsZWQgaW4gb3VyIGtlcm5l
bCBjb25maWcuDQo+ID4gU28gdGhlIGRlc2NyaXB0b3JzIGFsbG9jYXRlZCB3aXRoIGRtYV9hbGxv
Y19jb2hlcmVudCgpIHdvbid0IGJlIENNQSBtZW1vcnkuDQo+ID4gQ291bGQgdGhpcyBjYXVzZSBh
IGRpZmZlcmVudCBjYWNoaW5nL2ZsdXNoaW5nIGJlaGF2aW91cj8NCj4gDQo+IFllcywgYWZ0ZXIg
dGVzdHMgSSB0aGluayBpdCBpcyBjYXVzZWQgYnkgdGhlIGRpc2FibGVkIENNQS4NCj4gDQo+IEBB
bmR5DQo+IEkgY291bGQgZmluZCB0aGlzIG1haWwgYW5kIHRoZSBhdHRhY2hlZCAiaS5NWDYgZG1h
IG1lbW9yeSBidWZmZXJhYmxlDQo+IGlzc3VlLnBwdHgiIGluIHRoZSBhcmNoaXZlDQo+IGh0dHBz
Oi8vZXVyMDEuc2FmZWxpbmtzLnByb3RlY3Rpb24ub3V0bG9vay5jb20vP3VybD1odHRwcyUzQSUy
RiUyRm1hcmMuaW5mbw0KPiAlMkYlM0ZsJTNEbGludXgtbmV0ZGV2JTI2bSUzRDE0MDEzNTE0Nzgy
Mzc2MCZhbXA7ZGF0YT0wNCU3QzAxDQo+ICU3Q2Z1Z2FuZy5kdWFuJTQwbnhwLmNvbSU3QzEyMWU3
M2VjNjY2ODRhMTI1ZTJhMDhkODg3Y2VhNTc4JTdDDQo+IDY4NmVhMWQzYmMyYjRjNmZhOTJjZDk5
YzVjMzAxNjM1JTdDMCU3QzAlN0M2Mzc0MDg2Njg5MjQzNjI5ODMNCj4gJTdDVW5rbm93biU3Q1RX
RnBiR1pzYjNkOGV5SldJam9pTUM0d0xqQXdNREFpTENKUUlqb2lWMmx1TXpJaUxDSg0KPiBCVGlJ
NklrMWhhV3dpTENKWFZDSTZNbjAlM0QlN0MxMDAwJmFtcDtzZGF0YT1lN0NtMjRBeTFBeTUyVUt0
elQNCj4gQmlYOUtsaHV1YmxuZFAzMHZud3hBYXVnTSUzRCZhbXA7cmVzZXJ2ZWQ9MA0KPiBXYXMg
dGhpcyBpc3N1ZSBzb2x2ZWQgaW4gc29tZSBrZXJuZWwgdmVyc2lvbnMgbGF0ZXIgb24/DQo+IElz
IENNQSBzdGlsbCBuZWNlc3Nhcnkgd2l0aCBhIDUuNCBLZXJuZWw/DQoNClllcywgQ01BIGlzIHJl
cXVpcmVkLiBPdGhlcndpc2UgaXQgcmVxdWlyZXMgb25lIHBhdGNoIGZvciBMMiBjYWNoZS4NCg==
