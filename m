Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE0ABF09DE
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 23:52:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730317AbfKEWw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 17:52:26 -0500
Received: from mail-eopbgr30049.outbound.protection.outlook.com ([40.107.3.49]:42470
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729895AbfKEWw0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Nov 2019 17:52:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YjrMn2CfMMbXJHJG3rnrP8JOWqv6cH+Tqd6tpepu7yknTGqRNwjiJ2SD8ZQnvOXLRPbmUd8ckxubd1h/GfdeGTEU9WZAW6QSinDueMKVgWiKgBiw1Oad9+GsWx2J5fVo3QdVai+0BY5g5DIWLHyCTdrS1pe8RiNGfUQl0w6JlVcIwZcDfi1Tgns1K0D0oU5rHpy+fPemoGEZqQp6sp9xit76sqGWgLrCGpnITEYLirDCp8XcIM2lOvG6BJkgNEAjGIu2Yl8BxRg4QU97pqYi/m9I80eoB0zRJzdhoN+hm70q0B8p88vxeQME2MMfmDQSaYwFnUzcwIWVM9dRO3b3WQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PoIyD6HA7GOhYcvXjW28+TZQOCztJIkb34hD9GORtb8=;
 b=eg8c9TNIlr1KIm24JoxJe9NE92jSmLEBfAFhRJAB0WXg/lhEoYQ3M7R9d+/1zdCI4ZFzEg7NF/oWu9HA3MuKN7USMExREaWlV5wtJ6jV+X9oQXnxmFSw5b4B/uc3x+CSD50/f5mPtgW3iS4ZwrgRGDDBZI8nvJmHnV6z5F8ibYzv74/YGpjEUicSiv7Nq4w974SvEHZdGhtU7Bsa0x+fOWOTKiCd02upTl+BK8Ii4ZBqdGrwUMvXrUxOxKyjYReJz+kfoS98CaQRyb3W6PApbSJo9JEzexUJqmqXLKbMQCbohgvcGzJA2pbaQgWOQDzXqVGM7IE/ZHiGILiSGkcmNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PoIyD6HA7GOhYcvXjW28+TZQOCztJIkb34hD9GORtb8=;
 b=sLbhp8RMEKnfu5u97AjJNfcndmraYov8ZQCh7BAQmCbM2zjM+pSfgJDsncrvpAH8xYE3nb1/s7Wp9mi2nKjl7LkG3lQsPJWlzV5VRrNliDsyrM4DiUgNnjOIdlLA8lvoo4Nljv/mMh3kf21+svjVti1x01j+eKKFRbacUhVyjTQ=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5471.eurprd05.prod.outlook.com (20.177.201.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Tue, 5 Nov 2019 22:52:19 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2408.024; Tue, 5 Nov 2019
 22:52:19 +0000
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
Thread-Index: AQHVkCQFGdJo5Spx4U2AGUa6mmGmtKd1dOQAgAFEboCAABz2AIAAMEAAgATMggCAAAKoAIAADVYAgAEmsACAAB2BAIAAD9YA
Date:   Tue, 5 Nov 2019 22:52:18 +0000
Message-ID: <8c740914b7627a10e05313393442d914a42772d1.camel@mellanox.com>
References: <1572551213-9022-1-git-send-email-lariel@mellanox.com>
         <20191031172330.58c8631a@cakuba.netronome.com>
         <8d7db56c-376a-d809-4a65-bfc2baf3254f@mellanox.com>
         <6e0a2b89b4ef56daca9a154fa8b042e7f06632a4.camel@mellanox.com>
         <20191101172102.2fc29010@cakuba.netronome.com>
         <358c84d69f7d1dee24cf97cc0ad6fe59d5c313f5.camel@mellanox.com>
         <78befeac-24b0-5f38-6fd6-f7e1493d673b@gmail.com>
         <20191104183516.64ba481b@cakuba.netronome.com>
         <3da1761ec4a15db87800a180c521bbc7bf01a5b2.camel@mellanox.com>
         <20191105135536.5da90316@cakuba.netronome.com>
In-Reply-To: <20191105135536.5da90316@cakuba.netronome.com>
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
x-ms-office365-filtering-correlation-id: 45851743-53bb-4a9d-b266-08d76242d000
x-ms-traffictypediagnostic: VI1PR05MB5471:|VI1PR05MB5471:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5471C0AF0A331B3BB64F1714BE7E0@VI1PR05MB5471.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0212BDE3BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(376002)(366004)(39860400002)(396003)(189003)(199004)(71200400001)(8936002)(11346002)(446003)(2906002)(305945005)(58126008)(5640700003)(6486002)(4326008)(76176011)(6436002)(476003)(6506007)(2616005)(3846002)(486006)(6116002)(6512007)(6246003)(107886003)(2501003)(54906003)(25786009)(6916009)(71190400001)(26005)(66066001)(2351001)(36756003)(186003)(256004)(14444005)(229853002)(316002)(118296001)(99286004)(7736002)(102836004)(66446008)(64756008)(66556008)(66476007)(478600001)(66946007)(14454004)(5660300002)(91956017)(8676002)(81166006)(81156014)(76116006)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5471;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /S4Du/muwnwHWyTrmXY9Nfka6rz42gYB6zjVVonHZUWLN6xzQH+KSu6xuUotoaJZQerAfPXGcEtGExUZqCij8V6hLcgxSsSyNJgxzuDDLQzfqGDbBV8uvtA6FSZjBoKYav1c1AmDLNN1yG3fo0w0DmlqTl5XKLTf3gbRxqeuN8cPVPWnk518DU4IcZtWlZHljGBmmSwvXbORza5xZxXnMgh5qznCHasylWLyaSz5mOhbmTtNKF7AirSL8nQ/0uaLVmyBqduR9BOLCIrm4A0PFiThyOmUvcPUBel8a7/AysJLHkISdaNUt013ri9u4pQdlgCOYY5/6TBlLyZNKlkR7DE9sLqMxjcX9Sm17pqP31h3+X8OTlVly1JbzDygUy+Gxtu1ybSfwJI2Tp1+F6PG+Ijibxpdvs+loskv3qhEEOBib0dxk8ncZmMB17tTRWLg
Content-Type: text/plain; charset="utf-8"
Content-ID: <BC5262B196627447A0FCE998BB2ABFB3@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45851743-53bb-4a9d-b266-08d76242d000
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2019 22:52:19.0936
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dBUGVY1m8/JjoAFwMBLQtS2FbGYHVb+jXiYq7UhkC4zAgfWd7VUdfJdiOGNGBg4kJAU6Vv/rXltn+Z96d+zlYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5471
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTExLTA1IGF0IDEzOjU1IC0wODAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gVHVlLCA1IE5vdiAyMDE5IDIwOjEwOjAyICswMDAwLCBTYWVlZCBNYWhhbWVlZCB3cm90
ZToNCj4gPiA+ID4gPiBOb3cgaWYgdGhlIG9ubHkgcmVtYWluaW5nIHByb2JsZW0gaXMgdGhlIHVB
UEksIHdlIGNhbg0KPiA+ID4gPiA+IG1pbmltaXplDQo+ID4gPiA+ID4ga2VybmVsIGltcGFjdCBv
ciBldmVuIG1ha2Ugbm8ga2VybmVsIGNoYW5nZXMgYXQgYWxsLCBvbmx5IGlwDQo+ID4gPiA+ID4g
cm91dGUyIGFuZCBkcml2ZXJzLCBieSByZXVzaW5nIHRoZSBjdXJyZW50DQo+ID4gPiA+ID4gc2V0
X3ZmX3ZsYW5fbmRvLiAgICANCj4gPiA+ID4gDQo+ID4gPiA+IEFuZCB0aGlzIGNhdWdodCBteSBl
eWUgYXMgd2VsbCAtLSBpcHJvdXRlMiBkb2VzIG5vdCBuZWVkIHRoZQ0KPiA+ID4gPiBiYWdnYWdl
IGVpdGhlci4NCj4gPiA+ID4gDQo+ID4gPiA+IElzIHRoZXJlIGFueSByZWFzb24gdGhpcyBjb250
aW51ZWQgc3VwcG9ydCBmb3IgbGVnYWN5IHNyaW92IGNhbg0KPiA+ID4gPiBub3QgYmUgZG9uZSBv
dXQgb2YgdHJlZT8gIA0KPiA+ID4gDQo+ID4gPiBFeGFjdGx5LiBNb3ZpbmcgdG8gdXBzdHJlYW0g
aXMgb25seSB2YWx1YWJsZSBpZiBpdCBkb2Vzbid0DQo+ID4gPiByZXF1aXJlDQo+ID4gPiBicmlu
aW5nIGFsbCB0aGUgb3V0LW9mLXRyZWUgYmFnZ2FnZS4gIA0KPiA+IA0KPiA+IHRoaXMgYmFnZ2Fn
ZSBpcyBhIHZlcnkgZXNzZW50aWFsIHBhcnQgZm9yIGV0aCBzcmlvdiwgaXQgaXMgYQ0KPiA+IG1p
c3NpbmcNCj4gPiBmZWF0dXJlIGluIGJvdGggc3dpdGNoZGV2IG1vZGUgKGJyaWRnZSBvZmZsb2Fk
cykgYW5kIGxlZ2FjeS4NCj4gDQo+IEFGQUlLIGZyb20gdUFQSSBwZXJzcGVjdGl2ZSBub3RoaW5n
IGlzIG1pc3NpbmcgaW4gc3dpdGNoZGV2IG1vZGUuDQo+IA0KDQpicmlkZ2Ugb2ZmbG9hZHMgaXMg
bm90IG9uIHRoZSByb2FkIG1hcC4gc2FtZSBhcyBmb3IgbmV0bGluayBldGh0b29sDQphZGFwdGVy
IHdoaWNoIGlzIHN0aWxsIFdJUCBzaW5jZSAyMDE3Lg0KDQo+ID4gR3V5cywgSSBuZWVkIHRvIGtu
b3cgbXkgb3B0aW9ucyBoZXJlIGFuZCBtYWtlIHNvbWUgZWZmb3J0DQo+ID4gYXNzZXNzbWVudC4N
Cj4gPiANCj4gPiAxKSBpbXBsZW1lbnQgYnJpZGdlIG9mZmxvYWRzOiBtb250aHMgb2YgZGV2ZWxv
cG1lbnQsIHllYXJzIGZvcg0KPiA+IGRlcGxveW1lbnQgYW5kIG1pZ3JhdGlvbg0KPiA+IDIpIENs
b3NlIHRoaXMgZ2FwIGluIGxlZ2FjeSBtb2RlOiBkYXlzLg0KPiA+IA0KPiA+IEkgYW0gYWxsIElO
IGZvciBicmlkZ2Ugb2ZmbG9hZHMsIGJ1dCB5b3UgaGF2ZSB0byB1bmRlcnN0YW5kIHdoeSBpDQo+
ID4gcGljaw0KPiA+IDIsIG5vdCBiZWNhdXNlIGl0IGlzIGNoZWFwZXIsIGJ1dCBiZWNhdXNlIGl0
IGlzIG1vcmUgcmVhbGlzdGljIGZvcg0KPiA+IG15DQo+ID4gY3VycmVudCB1c2Vycy4gU2F5aW5n
IG5vIHRvIHRoaXMganVzdCBiZWNhdXNlIHN3aXRjaGRldiBtb2RlIGlzIHRoZQ0KPiA+IGRlDQo+
ID4gZmFjdG8gc3RhbmRhcmQgaXNuJ3QgZmFpciBhbmQgdGhlcmUgc2hvdWxkIGJlIGFuIGFjdGl2
ZSBjbGVhcg0KPiA+IHRyYW5zaXRpb24gcGxhbiwgd2l0aCBzb21ldGhpbmcgYXZhaWxhYmxlIHRv
IHdvcmsgd2l0aCAuLi4gbm90IGp1c3QNCj4gPiBpZGVhcy4NCj4gDQo+IEkgdW5kZXJzdGFuZCB5
b3VyIHBlcnNwZWN0aXZlLiBJdCBpcyBjaGVhcGVyIGZvciB5b3UuDQo+IA0KDQpBZ2Fpbiwgbm90
IGJlY2F1c2UgY2hlYXBlciwgY29uc2lkZXJpbmcgdGhlIGNpcmN1bXN0YW5jZXMgYW5kIHRoZQ0K
YmFzaWNuZXNzIG9mIHRoaXMgZmVhdHVyZSwgdGhpcyBpcyB0aGUgb25seSByaWdodCB3YXkgdG8g
Z28gZm9yIHRoaXMNCnBhcnRpY3VsYXIgY2FzZS4NCg0KPiA+IFlvdXIgY2xhaW1zIGFyZSB2YWxp
ZCBvbmx5IHdoZW4gd2UgYXJlIHRydWx5IHJlYWR5IGZvciBtaWdyYXRpb24uDQo+ID4gd2UNCj4g
PiBhcmUgc2ltcGx5IG5vdCBhbmQgbm8gb25lIGhhcyBhIGNsZWFyIHBsYW4gaW4gdGhlIGhvcml6
b24sIHNvIGkNCj4gPiBkb24ndA0KPiA+IGdldCB0aGlzIHRvdGFsIGZyZWV6ZSBhdHRpdHVkZSBv
ZiBsZWdhY3kgbW9kZSwgDQo+IA0KPiBUaGVyZSB3aWxsIG5ldmVyIGJlIGFueSBMMiBwbGFuIHVu
bGVzcyB3ZSBzYXkgbm8gdG8gbGVnYWN5DQo+IGV4dGVuc2lvbnMuDQo+IA0KDQpBbmQgcGlja2lu
ZyBvbiBiYXNpYy9zaW1wbGUgZXh0ZW5zaW9ucyB3aWxsIGdldCB5b3UgdGhlcmUgPyBpIGRvdWJ0
IGl0Lg0KDQpCZWluZyBzdHJpY3QgaXMgb25lIHRoaW5nIGFuZCBJIHRvdGFsbHkgYWdyZWUgd2l0
aCB0aGUgbW90aXZhdGlvbiwgYnV0DQpJIHN0cm9uZ2x5IGRpc2FncmVlIHdpdGggdGhpcyB0b3Rh
bCBzaHV0ZG93biBwb2xpY3kgd2l0aCBubw0KYWx0ZXJuYXRpdmVzIGFuZCBubyByZWFsIGdyb3Vu
ZHMgb3RoZXIgdGhhbiB0aGUgaG9wZSBzb21lb25lIHdvdWxkDQpldmVudHVhbGx5IGxpc3RlbiBh
bmQgaW1wbGVtZW50IHRoZSBtaWdyYXRpb24gcGF0aCwgbWVhbndoaWxlIEFMTCB1c2Vycw0KTVVT
VCBzdWZmZXIgcmVnYXJkbGVzcyBob3cgdHJpdmlhbCBvciBiYXNpYyB0aGVpciByZXF1ZXN0IGlz
Lg0KDQo+ID4gaXQgc2hvdWxkIGJlIGp1c3QgbGlrZSBldGh0b29sIHdlIHdhbnQgdG8gdG8gcmVw
bGFjZSBpdCBidXQgd2Uga25vdw0KPiA+IHdlIGFyZSBub3QgdGhlcmUgeWV0LCBzbyB3ZSBjYXJl
ZnVsbHkgYWRkIG9ubHkgbmVjZXNzYXJ5IHRoaW5ncw0KPiA+IHdpdGgNCj4gPiBsb3RzIG9mIGF1
ZGl0aW5nLCBzYW1lIHNob3VsZCBnbyBoZXJlLg0KPiANCj4gV29ya2VkIG91dCBhbWF6aW5nbHkg
Zm9yIGV0aHRvb2wsIHJpZ2h0Pw0KDQpPYnZpb3VzbHksIG5vIG9uZSB3b3VsZCBoYXZlIGFncmVl
ZCB0byBzdWNoIHRvdGFsIHNodXRkb3duIGZvciBldGh0b29sLA0Kd2UgZXZlbnR1YWxseSBkZWNp
ZGVkIG5vdCB0byBibG9jayBldGh0b29sIHVubGVzcyB3ZSBoYXZlIHRoZSBuZXRsaW5rDQphZGFw
dGVyIHdvcmtpbmcgLi4gbGVnYWN5IG1vZGUgc2hvdWxkIGdldCB0aGUgc2FtZSB0cmVhdG1lbnQu
DQoNCkJvdHRvbSBsaW5lIGZvciB0aGUgc2FtZSByZWFzb24gd2UgZGVjaWRlZCB0aGF0IGV0aHRv
b2wgaXMgbm90IHRvdGFsbHkNCmRlYWQgdW50aWwgZXRodG9vbCBuZXRsaW5rIGludGVyZmFjZSBp
cyBjb21wbGV0ZSwgd2Ugc2hvdWxkIHN0aWxsDQpzdXBwb3J0IHNlbGVjdGl2ZSBhbmQgYmFzaWMg
c3Jpb3YgbGVnYWN5IG1vZGUgZXh0ZW5zaW9ucyB1bnRpbCBicmlkZ2UNCm9mZmxvYWRzIGlzIGNv
bXBsZXRlLiANCg0KDQoNCg0KDQo=
