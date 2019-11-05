Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC6A6EF573
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 07:16:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730433AbfKEGQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 01:16:38 -0500
Received: from mail-eopbgr30085.outbound.protection.outlook.com ([40.107.3.85]:30982
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725991AbfKEGQh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Nov 2019 01:16:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BQnqEDD2hO4G7ak1vHFGCwccUYPn91nUNN4fwfxA5asGyW20zUwA2vfhqEkZKMJnjKst/soojz4f9pw4zFka5w0e4DB7i1eMu/yI5hJjU94s0BP91dB08UJ5QaHDr5DOd1OlBes7L/A8s6ZV8NHALwqxt2E2MLNOKU3JzpXxJT9ScoVerp9rNEV73q4kN0agUHd78TLLrJPpaihdvdkkxzvw2PT84LmZXOyYCvQV/FR5KBCdNuMvu9TO6BQfV7iL787ll1DwpDOsQaW+NjmDoCZClcOWxblyddy0AIXZOb2ONmIzOIvew/I04wnRzqaBHZC/VH0nnTLWQNKsX+8L+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bMVO+Cd6k3yhKH1S+W/isoRL/fnXdfRwl2bnVGNbqvg=;
 b=cPtY43sWRtKLvMao7p5i98BDL+Mah4tc7JAz/YzBmKd7RHaYISRl+6pogoOffE2DZ9eHpfcmAswWvuGReEy0g8Nom8xlBoh+PTo0CrBEata4Ri2d3s6CdA+eaeWDRn5YNwjco3PMi1IKTdswFpPvvdZ9dEu7n6ipp3rqeRyQolVoppxTOm1Zdd/7COloyhjO/TvvhklApuOVl734Qia7M5tZbBl6ROyOLWDVFkGs7jhnrENR+6fYfBUMQ9B6tNpjc7RhF9LurGcZiWIYj7k5xLLKWZ33Uf1dhBCr841qA75Fmxqg3w9MMHDxS07xM0rpWgEeR643d8S/DtZpZSaBYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bMVO+Cd6k3yhKH1S+W/isoRL/fnXdfRwl2bnVGNbqvg=;
 b=FHdeK8l5wdkwupuRQdOlateqRvfb5ZhD4AvRZEugyiiO04lNP75pLZ0pyiw5OpJSUYp2WBfc2id4uB7aCB5dv9EjhdDDtm2shqo5fMIiBjrZbpD5Xi//RryOoUplcOEb2dAlkm25X97iTqMff2lUXeSQZNYuywUNHVpBpllno6Q=
Received: from VE1PR04MB6768.eurprd04.prod.outlook.com (10.255.118.26) by
 VE1PR04MB6751.eurprd04.prod.outlook.com (20.179.235.216) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Tue, 5 Nov 2019 06:16:32 +0000
Received: from VE1PR04MB6768.eurprd04.prod.outlook.com
 ([fe80::50aa:3111:47b1:82d4]) by VE1PR04MB6768.eurprd04.prod.outlook.com
 ([fe80::50aa:3111:47b1:82d4%4]) with mapi id 15.20.2408.024; Tue, 5 Nov 2019
 06:16:32 +0000
From:   Qiang Zhao <qiang.zhao@nxp.com>
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Leo Li <leoyang.li@nxp.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>
CC:     "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Scott Wood <oss@buserror.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v3 35/36] net/wan: make FSL_UCC_HDLC explicitly depend on
 PPC32
Thread-Topic: [PATCH v3 35/36] net/wan: make FSL_UCC_HDLC explicitly depend on
 PPC32
Thread-Index: AQHVkLHl/ovt4Kon106Gz+Xx9ElXg6d2gb8AgABlGYCAA84fAIABZ7FQ
Date:   Tue, 5 Nov 2019 06:16:32 +0000
Message-ID: <VE1PR04MB67686E14A4E0D33C77B43EA6917E0@VE1PR04MB6768.eurprd04.prod.outlook.com>
References: <20191018125234.21825-1-linux@rasmusvillemoes.dk>
 <20191101124210.14510-1-linux@rasmusvillemoes.dk>
 <20191101124210.14510-36-linux@rasmusvillemoes.dk>
 <4e2ac670-2bf4-fb47-2130-c0120bcf0111@c-s.fr>
 <VE1PR04MB6687D4620E32176BDC120DBA8F620@VE1PR04MB6687.eurprd04.prod.outlook.com>
 <24ea27b6-adea-cc74-f480-b68de163f531@rasmusvillemoes.dk>
In-Reply-To: <24ea27b6-adea-cc74-f480-b68de163f531@rasmusvillemoes.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiang.zhao@nxp.com; 
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ded1ab11-2eb0-42eb-b9b1-08d761b7b401
x-ms-traffictypediagnostic: VE1PR04MB6751:|VE1PR04MB6751:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB6751B988F165ACCE8390AE09917E0@VE1PR04MB6751.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2512;
x-forefront-prvs: 0212BDE3BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(136003)(39860400002)(376002)(366004)(189003)(199004)(13464003)(33656002)(14454004)(66574012)(64756008)(66446008)(66946007)(6436002)(76116006)(7736002)(2906002)(5660300002)(52536014)(478600001)(66066001)(74316002)(305945005)(25786009)(54906003)(110136005)(81166006)(86362001)(316002)(186003)(8676002)(81156014)(3846002)(11346002)(486006)(6116002)(8936002)(446003)(7696005)(76176011)(102836004)(476003)(6506007)(99286004)(55016002)(9686003)(4326008)(229853002)(44832011)(71200400001)(71190400001)(256004)(66476007)(66556008)(14444005)(53546011)(26005)(6246003);DIR:OUT;SFP:1101;SCL:1;SRVR:VE1PR04MB6751;H:VE1PR04MB6768.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 68Ji0u1jwaoMKBF4RrQtEiHgZZmXR1Lv6Io5HbTGeqXxoRpO2qNuBVHB0y6eTjdYmmselWcMjiHUJoamGGft8IKwVf1qdgIEcg930bKis8ySMjfGoh3xgkho2uiwAMPJiD4ik55FMUmMfMcSQ9rdk2GNfQPJNIKSWtLy7B+tAwYPCse4gRbOBv/gJTPqRdZcWLq8MFB+5ClyhLVj1VBAvAFNX0mkD4zK5gFKWeCJu918paR5WfnMezQm6SuCGbYBxJeqeRvszh0mH72BprugK5lneJ05I0Qp8YiEK/+W2DREhIKWrPw5ve/Ap2sHAcaVkYoHz21oav/ryB/Hc88werWTbK466LPfWjN5L630dw6MyTgHa8wmkqYVzosqrHol99HKzjCeJqjbMkFMwprAZq7OkFjPVB+9uu+8RnheJIk7i3+7gOfUC0UDV3A/5Tjn
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ded1ab11-2eb0-42eb-b9b1-08d761b7b401
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2019 06:16:32.1956
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MEFOJautTtDWN7qpwRxeKzmP5P8LQMuypYlnL6C1FY1uJp4sK8Ts2fUnhNdQbCFJQBUoDLmVUXTD9qTuG9qjiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6751
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDEvMTEvMjAxOSAyMzozMSwgUmFzbXVzIFZpbGxlbW9lcyB3cm90ZSA6DQoNCg0KPiAtLS0t
LU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBSYXNtdXMgVmlsbGVtb2VzIDxsaW51eEBy
YXNtdXN2aWxsZW1vZXMuZGs+DQo+IFNlbnQ6IDIwMTnlubQxMeaciDTml6UgMTY6MzgNCj4gVG86
IExlbyBMaSA8bGVveWFuZy5saUBueHAuY29tPjsgQ2hyaXN0b3BoZSBMZXJveSA8Y2hyaXN0b3Bo
ZS5sZXJveUBjLXMuZnI+Ow0KPiBRaWFuZyBaaGFvIDxxaWFuZy56aGFvQG54cC5jb20+DQo+IENj
OiBsaW51eHBwYy1kZXZAbGlzdHMub3psYWJzLm9yZzsgbGludXgtYXJtLWtlcm5lbEBsaXN0cy5p
bmZyYWRlYWQub3JnOw0KPiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBTY290dCBXb29k
IDxvc3NAYnVzZXJyb3IubmV0PjsNCj4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0
OiBSZTogW1BBVENIIHYzIDM1LzM2XSBuZXQvd2FuOiBtYWtlIEZTTF9VQ0NfSERMQyBleHBsaWNp
dGx5IGRlcGVuZA0KPiBvbiBQUEMzMg0KPiANCj4gT24gMDEvMTEvMjAxOSAyMy4zMSwgTGVvIExp
IHdyb3RlOg0KPiA+DQo+ID4NCj4gPj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPj4g
RnJvbTogQ2hyaXN0b3BoZSBMZXJveSA8Y2hyaXN0b3BoZS5sZXJveUBjLXMuZnI+DQo+ID4+IFNl
bnQ6IEZyaWRheSwgTm92ZW1iZXIgMSwgMjAxOSAxMTozMCBBTQ0KPiA+PiBUbzogUmFzbXVzIFZp
bGxlbW9lcyA8bGludXhAcmFzbXVzdmlsbGVtb2VzLmRrPjsgUWlhbmcgWmhhbw0KPiA+PiA8cWlh
bmcuemhhb0BueHAuY29tPjsgTGVvIExpIDxsZW95YW5nLmxpQG54cC5jb20+DQo+ID4+IENjOiBs
aW51eHBwYy1kZXZAbGlzdHMub3psYWJzLm9yZzsNCj4gPj4gbGludXgtYXJtLWtlcm5lbEBsaXN0
cy5pbmZyYWRlYWQub3JnOw0KPiA+PiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBTY290
dCBXb29kIDxvc3NAYnVzZXJyb3IubmV0PjsNCj4gPj4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZw0K
PiA+PiBTdWJqZWN0OiBSZTogW1BBVENIIHYzIDM1LzM2XSBuZXQvd2FuOiBtYWtlIEZTTF9VQ0Nf
SERMQyBleHBsaWNpdGx5DQo+ID4+IGRlcGVuZCBvbiBQUEMzMg0KPiA+Pg0KPiA+Pg0KPiA+Pg0K
PiA+PiBMZSAwMS8xMS8yMDE5IMOgIDEzOjQyLCBSYXNtdXMgVmlsbGVtb2VzIGEgw6ljcml0wqA6
DQo+ID4+PiBDdXJyZW50bHksIEZTTF9VQ0NfSERMQyBkZXBlbmRzIG9uIFFVSUNDX0VOR0lORSwg
d2hpY2ggaW4gdHVybg0KPiA+PiBkZXBlbmRzDQo+ID4+PiBvbiBQUEMzMi4gQXMgcHJlcGFyYXRp
b24gZm9yIHJlbW92aW5nIHRoZSBsYXR0ZXIgYW5kIHRodXMgYWxsb3dpbmcNCj4gPj4+IHRoZSBj
b3JlIFFFIGNvZGUgdG8gYmUgYnVpbHQgZm9yIG90aGVyIGFyY2hpdGVjdHVyZXMsIG1ha2UNCj4g
Pj4+IEZTTF9VQ0NfSERMQyBleHBsaWNpdGx5IGRlcGVuZCBvbiBQUEMzMi4NCj4gPj4NCj4gPj4g
SXMgdGhhdCByZWFsbHkgcG93ZXJwYyBzcGVjaWZpYyA/IENhbid0IHRoZSBBUk0gUUUgcGVyZm9y
bSBIRExDIG9uIFVDQyA/DQo+IA0KPiBJIHRoaW5rIHRoZSBkcml2ZXIgd291bGQgYnVpbGQgb24g
QVJNLiBXaGV0aGVyIGl0IHdvcmtzIEkgZG9uJ3Qga25vdy4gSSBrbm93IGl0DQo+IGRvZXMgbm90
IGJ1aWxkIG9uIDY0IGJpdCBob3N0cyAoc2VlIGtidWlsZCByZXBvcnQgZm9yIHYyLDIzLzIzKS4N
Cj4gDQo+ID4gTm8uICBBY3R1YWxseSB0aGUgSERMQyBhbmQgVERNIGFyZSB0aGUgbWFqb3IgcmVh
c29uIHRvIGludGVncmF0ZSBhIFFFIG9uDQo+IHRoZSBBUk0gYmFzZWQgTGF5ZXJzY2FwZSBTb0Nz
Lg0KPiANCj4gW2NpdGF0aW9uIG5lZWRlZF0uDQo+IA0KPiA+IFNpbmNlIFJhc211cyBkb2Vzbid0
IGhhdmUgdGhlIGhhcmR3YXJlIHRvIHRlc3QgdGhpcyBmZWF0dXJlIFFpYW5nIFpoYW8NCj4gcHJv
YmFibHkgY2FuIGhlbHAgdmVyaWZ5IHRoZSBmdW5jdGlvbmFsaXR5IG9mIFRETSBhbmQgd2UgY2Fu
IGRyb3AgdGhpcyBwYXRjaC4NCj4gDQo+IE5vLCB0aGlzIHBhdGNoIGNhbm5vdCBiZSBkcm9wcGVk
LiBQbGVhc2Ugc2VlIHRoZSBrYnVpbGQgY29tcGxhaW50cyBmb3INCj4gdjIsMjMvMjMgYWJvdXQg
dXNlIG9mIElTX0VSUl9WQUxVRSBvbiBub3Qtc2l6ZW9mKGxvbmcpIGVudGl0aWVzLiBJIHNlZSBr
YnVpbGQNCj4gaGFzIGNvbXBsYWluZWQgYWJvdXQgdGhlIHNhbWUgdGhpbmcgZm9yIHYzIHNpbmNl
IGFwcGFyZW50bHkgdGhlIHNhbWUgdGhpbmcNCj4gYXBwZWFycyBpbiB1Y2Nfc2xvdy5jLiBTbyBJ
J2xsIGZpeCB0aGF0Lg0KPiANCj4gTW9yZW92ZXIsIGFzIHlvdSBzYXkgYW5kIGtub3csIEkgZG8g
bm90IGhhdmUgdGhlIGhhcmR3YXJlIHRvIHRlc3QgaXQsIHNvIEknbQ0KPiBub3QgZ29pbmcgdG8g
ZXZlbiBhdHRlbXB0IHRvIGZpeCB1cCBmc2xfdWNjX2hkbGMuYy4gSWYgUWlhbmcgWmhhbyBvciBz
b21lYm9keQ0KPiBlbHNlIGNhbiB2ZXJpZnkgdGhhdCBpdCB3b3JrcyBqdXN0IGZpbmUgb24gQVJN
IGFuZCBmaXhlcyB0aGUgYWxsbW9kY29uZmlnDQo+IHByb2JsZW0ocyksIGhlL3NoZSBpcyBtb3Jl
IHRoYW4gd2VsY29tZSB0byBzaWduIG9mZiBvbiBhIHBhdGNoIHRoYXQgcmVtb3Zlcw0KPiB0aGUg
Q09ORklHX1BQQzMyIGRlcGVuZGVuY3kgb3IgcmVwbGFjZXMgaXQgd2l0aCBzb21ldGhpbmcgZWxz
ZS4NCj4gDQoNCkkgdGVzdGVkIHlvdXIgdjMgcGF0Y2hlcyBvbiBsczEwNDNhcmRiIHdoaWNoIGlz
IGFybTY0IGZvciBmc2xfdWNjX2hkbGMsIGl0IGNhbiB3b3JrLA0KT25seSBpdCB3aWxsIHB1dCBh
IGNvbXBpbGUgd2FybmluZywgSSBhbHNvIG1hZGUgYSBwYXRjaCB0byBmaXggaXQuDQpJIGNhbiBz
ZW5kIGEgcGF0Y2ggdG8gcmVtb3ZlIFBQQzMyIGRlcGVuZGVuY3kgd2hlbiBJIHNlbmQgbXkgcGF0
Y2ggdG8gc3VwcG9ydCBBUk02NC4NCk9yIEkgYWRkIG15IHBhdGNoIGluIHlvdXIgcGF0Y2hzZXQu
DQoNCkJlc3QgUmVnYXJkcw0KUWlhbmcgWmhhbw0K
