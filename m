Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2925E72B4D
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 11:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbfGXJZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 05:25:02 -0400
Received: from mail-eopbgr130041.outbound.protection.outlook.com ([40.107.13.41]:17892
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725955AbfGXJZB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 05:25:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fPXdKvJBvjAXL6BJhpcX+ZzNHsjmAzPpz3ErmcCELyXhBo0JbaFocew00Y3aicErIxfCiYdd6MdYJFKtY/Cs/pHkfplztP4DKZH1VYVgtYXaqrYZy3/BSaue5Xchrrp47zyG1/YUE9nvSCutekYBg5D9Kj1G2sdr4qHgSTB1DwUUJ7o7diD6qNaBHy24aXbBzLFTdSUwhInsDERJK4D3/x0If9z01mYl+UMt10KI5i3QI1fkY+ZFpOCvBRpwnMuFTrdBSDNZJZahoIBPCPL1yh80D+cwN9FldMneknUToftBvHfP1+9I823Fy8c4Z7qSOq6rUoHXOQiYHXQrD2C8bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vH5nBWf6+AeWDvvEslhP4AMX2mFzcSJiq4QqFELtuI0=;
 b=kzXlDbrnIkwe19TDMtezYBm6SoPBsAddVfKuvbtS+hxukDKi4t8NN6XV1xPaW9U/gLlBN5DvhNmQ+tcAg14fOBPwplmN6FJ2ptYrDbw6aDQp/pSuoHM4IyCy3XSzuw7WBeHDPsrbXmVfnxg1+4BhBzG7bRgMOpAyQ9UltMKFEwwNloN+OIYgtBfIBvXKdGKh7zd5Ow0NFt+YhBEUtlyHf7QwhFtkTtO5HwUCq8wY++3UpM9VfKZflKJigHdsk5mutNB5OlJ65sbco0X0meiSR0QwthZ8LH0/zOiqFkNiAo42IveQJAjnR9KUa9wjYMw6XRePGeY3A2xQpaU0YTZXLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=peak-system.com;dmarc=pass action=none
 header.from=peak-system.com;dkim=pass header.d=peak-system.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=itpeak.onmicrosoft.com; s=selector1-itpeak-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vH5nBWf6+AeWDvvEslhP4AMX2mFzcSJiq4QqFELtuI0=;
 b=Y6IEtJnibauLx3xBFVZqPunxErzsaIZecOo0eVk3bukv/FrWVzEcoGSuCGJcUt2WDvwYAHb9y/OGyCiBIQY+nxwImRY6VVt4QVHkIM/eAWsAMRYNeCoBqLvUlDkZlg278Vkod2gopRkSwTqVmXEjqaizoRmr70DCcbklGVSMEAg=
Received: from AM6PR03MB4006.eurprd03.prod.outlook.com (20.177.37.97) by
 AM6PR03MB5734.eurprd03.prod.outlook.com (20.179.247.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.17; Wed, 24 Jul 2019 09:24:49 +0000
Received: from AM6PR03MB4006.eurprd03.prod.outlook.com
 ([fe80::d1d:220a:d47:1555]) by AM6PR03MB4006.eurprd03.prod.outlook.com
 ([fe80::d1d:220a:d47:1555%6]) with mapi id 15.20.2115.005; Wed, 24 Jul 2019
 09:24:49 +0000
From:   =?utf-8?B?U3TDqXBoYW5lIEdyb3NqZWFu?= <s.grosjean@peak-system.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
Subject: RE: pull-request: can-next 2019-07-24
Thread-Topic: pull-request: can-next 2019-07-24
Thread-Index: AQHVQf5CJEKJkug1FkaboUDdRoYti6bZfesg
Date:   Wed, 24 Jul 2019 09:24:49 +0000
Message-ID: <AM6PR03MB4006F834B65943E49F485FA6D6C60@AM6PR03MB4006.eurprd03.prod.outlook.com>
References: <93540cba-184a-a9c5-f9d2-b1779a69a36f@pengutronix.de>
In-Reply-To: <93540cba-184a-a9c5-f9d2-b1779a69a36f@pengutronix.de>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=s.grosjean@peak-system.com; 
x-originating-ip: [185.109.201.203]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 063fbd62-0373-430a-bb7f-08d71018c6ac
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600148)(711020)(4605104)(1401327)(2017052603328)(49563074)(7193020);SRVR:AM6PR03MB5734;
x-ms-traffictypediagnostic: AM6PR03MB5734:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <AM6PR03MB57344855206640628DECD58ED6C60@AM6PR03MB5734.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1468;
x-forefront-prvs: 0108A997B2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(136003)(366004)(39850400004)(396003)(346002)(13464003)(189003)(199004)(53386004)(6116002)(55016002)(5660300002)(81156014)(6246003)(71190400001)(66066001)(81166006)(3846002)(15974865002)(52536014)(53546011)(64756008)(6506007)(76176011)(66476007)(6436002)(66946007)(76116006)(486006)(316002)(7736002)(6306002)(2501003)(66556008)(305945005)(71200400001)(9686003)(66446008)(5024004)(2906002)(99936001)(256004)(66616009)(4326008)(74316002)(102836004)(26005)(14444005)(11346002)(8936002)(54906003)(86362001)(229853002)(8676002)(68736007)(110136005)(186003)(14454004)(85182001)(508600001)(25786009)(966005)(33656002)(476003)(99286004)(446003)(53936002)(66574012)(7696005)(85202003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR03MB5734;H:AM6PR03MB4006.eurprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: peak-system.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: /UtFECeT8tD8S2lNHRORUhcStJyQg+Jmbmq/axuw98GcD89/cumM9JQEZz5pY/ILxDbZiCuYbHb8p2P0x5cJkRoT2lVt1uIMlaJfVHK+sv8UIRDqaqrxUXinlTaDWN7FRbPxIjw4D7cebCowjldHBcWhggajDB7EENZaHDLuuaV8tvJU9nPtNKo992v0rDovUXNx2lXIw0JBVlj+bTSRG4NfTd40KdbynxQ4OkerB+M32lmh1XhS9nlpxXwpn5hoVhynlzOuqNz2aze5mCEc0mOhEbn03DtMhUvwL7PHEJXYWpDNOgV3kit7Bvi/bAS8GZIMQL0dR4IBd4+wgdJMhBkw95xMZ6/EFL5M+FLK9AlB75KTbqR/KNef23mJDiE83nDc+4lzr+un0xAZ7wRDgd1J89l7vBnwTdEVxT9YlLM=
Content-Type: multipart/mixed;
        boundary="_002_AM6PR03MB4006F834B65943E49F485FA6D6C60AM6PR03MB4006eurp_"
MIME-Version: 1.0
X-OriginatorOrg: peak-system.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 063fbd62-0373-430a-bb7f-08d71018c6ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2019 09:24:49.3663
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e31dcbd8-3f8b-4c5c-8e73-a066692b30a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s.grosjean@peak-system.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB5734
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--_002_AM6PR03MB4006F834B65943E49F485FA6D6C60AM6PR03MB4006eurp_
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

SGVsbG8gTWFyaywNCg0KSSBob3BlIHlvdSdyZSBmaW5lLiBEaWQgeW91IHNlZSB0aGUgYXR0YWNo
ZWQgcGF0Y2ggSSd2ZSBzZW50IGVhcmxpZXIgdGhpcyBtb250aD8NCg0KUmVnYXJkcywNCg0K4oCU
IFN0w6lwaGFuZQ0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IGxpbnV4
LWNhbi1vd25lckB2Z2VyLmtlcm5lbC5vcmcgPGxpbnV4LWNhbi0NCj4gb3duZXJAdmdlci5rZXJu
ZWwub3JnPiBPbiBCZWhhbGYgT2YgTWFyYyBLbGVpbmUtQnVkZGUNCj4gU2VudDogbWVyY3JlZGkg
MjQganVpbGxldCAyMDE5IDExOjAwDQo+IFRvOiBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+IENj
OiBkYXZlbUBkYXZlbWxvZnQubmV0OyBrZXJuZWxAcGVuZ3V0cm9uaXguZGU7IGxpbnV4LQ0KPiBj
YW5Admdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IHB1bGwtcmVxdWVzdDogY2FuLW5leHQgMjAx
OS0wNy0yNA0KPg0KPiBIZWxsbyBEYXZpZCwNCj4NCj4gdGhpcyBpcyBhIHB1bGwgcmVxdWVzdCBm
b3IgbmV0LW5leHQvbWFzdGVyIGNvbnNpc3Rpbmcgb2YgMjYgcGF0Y2hlcy4NCj4NCj4gVGhlIGZp
cnN0IHR3byBwYXRjaGVzIGFyZSBieSBtZS4gT25lIGFkZHMgbWlzc2luZyBmaWxlcyBvZiB0aGUg
Q0FODQo+IHN1YnN5c3RlbSB0byB0aGUgTUFJTlRBSU5FUlMgZmlsZSwgd2hpbGUgdGhlIG90aGVy
IHNvcnRzIHRoZQ0KPiBNYWtlZmlsZS9LY29uZmlnIG9mIHRoZSBzamExMDAwIGRyaXZlcnMgc3Vi
IGRpcmVjdG9yeS4gSW4gdGhlIG5leHQgcGF0Y2ggSmktWmUNCj4gSG9uZyAoUGV0ZXIgSG9uZykg
cHJvdmlkZXMgYSBkcml2ZXIgZm9yIHRoZSAiRmludGVrIFBDSUUgdG8gMiBDQU4iDQo+IGNvbnRy
b2xsZXIsIGJhc2VkIG9uIHRoZSB0aGUgc2phMTAwMCBJUCBjb3JlLg0KPg0KPiBHdXN0YXZvIEEu
IFIuIFNpbHZhJ3MgcGF0Y2ggZm9yIHRoZSBrdmFzZXJfdXNiIGRyaXZlciBpbnRyb2R1Y2VzIHRo
ZSB1c2Ugb2YNCj4gc3RydWN0X3NpemUoKSBpbnN0ZWFkIG9mIG9wZW4gY29kaW5nIGl0LiBIZW5u
aW5nIENvbGxpYW5kZXIncyBwYXRjaCBhZGRzIGENCj4gZHJpdmVyIGZvciB0aGUgIkt2YXNlciBQ
Q0lFY2FuIiBkZXZpY2VzLg0KPg0KPiBBbm90aGVyIHBhdGNoIGJ5IEd1c3Rhdm8gQS4gUi4gU2ls
dmEgbWFya3MgZXhwZWN0ZWQgc3dpdGNoIGZhbGwtdGhyb3VnaHMNCj4gcHJvcGVybHkuDQo+DQo+
IERhbiBNdXJwaHkgcHJvdmlkZXMgNSBwYXRjaGVzIGZvciB0aGUgbV9jYW4uIEFmdGVyIGNsZWFu
dXBzIGEgZnJhbWV3b3JrDQo+IGlzIGludHJvZHVjZWQgc28gdGhhdCB0aGUgZHJpdmVyIGNhbiBi
ZSB1c2VkIGZyb20gbWVtb3J5IG1hcHBlZCBJTyBhcyB3ZWxsDQo+IGFzIFNQSSBhdHRhY2hlZCBk
ZXZpY2VzLiBGaW5hbGx5IGhlIGFkZHMgYSBkcml2ZXIgZm9yIHRoZSB0Y2FuNHg1eCB3aGljaCB1
c2VzDQo+IHRoaXMgZnJhbWV3b3JrLg0KPg0KPiBBIHNlcmllcyBvZiA1IHBhdGNoZXMgYnkgQXBw
YW5hIER1cmdhIEtlZGFyZXN3YXJhIHJhbyBmb3IgdGhlIHhpbGlueF9jYW4NCj4gZHJpdmVyLCBm
aXJzdCBjbGVhbiB1cCx0aGVuIGFkZCBzdXBwb3J0IGZvciBDQU5GRC4gQ29saW4gSWFuIEtpbmcg
Y29udHJpYnV0ZXMNCj4gYW5vdGhlciBjbGVhbnVwIGZvciB0aGUgeGlsaW54X2NhbiBkcml2ZXIu
DQo+DQo+IFJvYmVydCBQLiBKLiBEYXkncyBwYXRjaCBjb3JyZWN0cyB0aGUgYnJpZWYgaGlzdG9y
eSBvZiB0aGUgQ0FOIHByb3RvY29sIGdpdmVuIGluDQo+IHRoZSBLY29uZmlnIG1lbnUgZW50cnku
DQo+DQo+IDIgcGF0Y2hlcyBieSBEb25nIEFpc2hlbmcgZm9yIHRoZSBmbGV4Y2FuIGRyaXZlciBw
cm92aWRlIFBFIGNsb2NrIHNvdXJjZQ0KPiBzZWxlY3Qgc3VwcG9ydCBhbmQgZHQtYmluZGluZ3Mg
ZGVzY3JpcHRpb24uDQo+IDIgcGF0Y2hlcyBieSBTZWFuIE55ZWtqYWVyIGZvciB0aGUgZmxleGNh
biBkcml2ZXIgcHJvdmlkZSBhZGQgQ0FOIHdha2V1cC0NCj4gc291cmNlIHByb3BlcnR5IGFuZCBk
dC1iaW5kaW5ncyBkZXNjcmlwdGlvbi4NCj4NCj4gSmVyb2VuIEhvZnN0ZWUncyBwYXRjaCBjb252
ZXJ0cyB0aGUgdGlfaGVjYyBkcml2ZXIgdG8gbWFrZSB1c2Ugb2YgdGhlIHJ4LQ0KPiBvZmZsb2Fk
IGhlbHBlciBmaXhpbmcgYSBudW1iZXIgb2Ygb3V0c3RhbmRpbmcgYnVncy4NCj4NCj4gVGhlIGZp
cnN0IHBhdGNoIG9mIE9saXZlciBIYXJ0a29wcCByZW1vdmVzIHRoZSBub3cgb2Jzb2xldGUgZW1w
dHkNCj4gaW9jdGwoKSBoYW5kbGVyIGZvciB0aGUgQ0FOIHByb3RvY29scy4gVGhlIHNlY29uZCBw
YXRjaCBhZGRzIFNQRFggbGljZW5zZQ0KPiBpZGVudGlmaWVycyBmb3IgQ0FOIHN1YnN5c3RlbS4N
Cj4NCj4gcmVnYXJkcywNCj4gTWFyYw0KPg0KPiAtLS0NCj4NCj4gVGhlIGZvbGxvd2luZyBjaGFu
Z2VzIHNpbmNlIGNvbW1pdA0KPiAzZTNiYjY5NTg5ZTQ4MmUwNzgzZjI4ZDRjZDFkOGU1NmZkYTBi
Y2JiOg0KPg0KPiAgIHRjLXRlc3Rpbmc6IGFkZGVkIHRkYyB0ZXN0cyBmb3IgW2J8cF1maWZvIHFk
aXNjICgyMDE5LTA3LTIzIDE0OjA4OjE1IC0wNzAwKQ0KPg0KPiBhcmUgYXZhaWxhYmxlIGluIHRo
ZSBHaXQgcmVwb3NpdG9yeSBhdDoNCj4NCj4gICBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2Nt
L2xpbnV4L2tlcm5lbC9naXQvbWtsL2xpbnV4LWNhbi1uZXh0LmdpdA0KPiB0YWdzL2xpbnV4LWNh
bi1uZXh0LWZvci01LjQtMjAxOTA3MjQNCj4NCj4gZm9yIHlvdSB0byBmZXRjaCBjaGFuZ2VzIHVw
IHRvIGZiYTc2YTU4NDUyNjk0YjliMTNjMDdlNDg4MzlmYTg0Yzc1ZjU3YWY6DQo+DQo+ICAgY2Fu
OiBBZGQgU1BEWCBsaWNlbnNlIGlkZW50aWZpZXJzIGZvciBDQU4gc3Vic3lzdGVtICgyMDE5LTA3
LTI0IDEwOjMxOjU1DQo+ICswMjAwKQ0KPg0KPiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+IGxpbnV4LWNhbi1uZXh0LWZv
ci01LjQtMjAxOTA3MjQNCj4NCj4gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiBBaXNoZW5nIERvbmcgKDEpOg0KPiAgICAg
ICBjYW46IGZsZXhjYW46IGltcGxlbWVudCBjYW4gUnVudGltZSBQTQ0KPg0KPiBBcHBhbmEgRHVy
Z2EgS2VkYXJlc3dhcmEgcmFvICg1KToNCj4gICAgICAgY2FuOiB4aWxpbnhfY2FuOiBGaXggc3R5
bGUgaXNzdWVzDQo+ICAgICAgIGNhbjogeGlsaW54X2NhbjogRml4IGtlcm5lbCBkb2Mgd2Fybmlu
Z3MNCj4gICAgICAgY2FuOiB4aWxpbnhfY2FuOiBGaXggZmxhZ3MgZmllbGQgaW5pdGlhbGl6YXRp
b24gZm9yIGF4aSBjYW4gYW5kIGNhbnBzDQo+ICAgICAgIGNhbjogeGlsaW54X2NhbjogQWRkIGNh
bnR5cGUgcGFyYW1ldGVyIGluIHhjYW5fZGV2dHlwZV9kYXRhIHN0cnVjdA0KPiAgICAgICBjYW46
IHhpbGlueF9jYW46IEFkZCBzdXBwb3J0IGZvciBDQU5GRCBGRCBmcmFtZXMNCj4NCj4gQ29saW4g
SWFuIEtpbmcgKDEpOg0KPiAgICAgICBjYW46IHhpbGlueF9jYW46IGNsZWFuIHVwIGluZGVudGF0
aW9uIGlzc3VlDQo+DQo+IERhbiBNdXJwaHkgKDUpOg0KPiAgICAgICBjYW46IG1fY2FuOiBGaXgg
Y2hlY2twYXRjaCBpc3N1ZXMgb24gZXhpc3RpbmcgY29kZQ0KPiAgICAgICBjYW46IG1fY2FuOiBD
cmVhdGUgYSBtX2NhbiBwbGF0Zm9ybSBmcmFtZXdvcmsNCj4gICAgICAgY2FuOiBtX2NhbjogUmVu
YW1lIG1fY2FuX3ByaXYgdG8gbV9jYW5fY2xhc3NkZXYNCj4gICAgICAgZHQtYmluZGluZ3M6IGNh
bjogdGNhbjR4NXg6IEFkZCBEVCBiaW5kaW5ncyBmb3IgVENBTjR4NVggZHJpdmVyDQo+ICAgICAg
IGNhbjogdGNhbjR4NXg6IEFkZCB0Y2FuNHg1eCBkcml2ZXIgdG8gdGhlIGtlcm5lbA0KPg0KPiBE
b25nIEFpc2hlbmcgKDIpOg0KPiAgICAgICBkdC1iaW5kaW5nczogY2FuOiBmbGV4Y2FuOiBhZGQg
UEUgY2xvY2sgc291cmNlIHByb3BlcnR5IHRvIGRldmljZSB0cmVlDQo+ICAgICAgIGNhbjogZmxl
eGNhbjogYWRkIHN1cHBvcnQgZm9yIFBFIGNsb2NrIHNvdXJjZSBzZWxlY3QNCj4NCj4gR3VzdGF2
byBBLiBSLiBTaWx2YSAoMik6DQo+ICAgICAgIGNhbjoga3Zhc2VyX3VzYjogVXNlIHN0cnVjdF9z
aXplKCkgaW4gYWxsb2NfY2FuZGV2KCkNCj4gICAgICAgY2FuOiBtYXJrIGV4cGVjdGVkIHN3aXRj
aCBmYWxsLXRocm91Z2hzDQo+DQo+IEhlbm5pbmcgQ29sbGlhbmRlciAoMSk6DQo+ICAgICAgIGNh
bjoga3Zhc2VyX3BjaWVmZDogQWRkIGRyaXZlciBmb3IgS3Zhc2VyIFBDSUVjYW4gZGV2aWNlcw0K
Pg0KPiBKZXJvZW4gSG9mc3RlZSAoMSk6DQo+ICAgICAgIGNhbjogdGlfaGVjYzogdXNlIHRpbWVz
dGFtcCBiYXNlZCByeC1vZmZsb2FkaW5nDQo+DQo+IEppLVplIEhvbmcgKFBldGVyIEhvbmcpICgx
KToNCj4gICAgICAgY2FuOiBzamExMDAwOiBmODE2MDE6IGFkZCBGaW50ZWsgRjgxNjAxIHN1cHBv
cnQNCj4NCj4gTWFyYyBLbGVpbmUtQnVkZGUgKDIpOg0KPiAgICAgICBNQUlOVEFJTkVSUzogY2Fu
OiBhZGQgbWlzc2luZyBmaWxlcyB0byBDQU4gTkVUV09SSyBEUklWRVJTIGFuZCBDQU4NCj4gTkVU
V09SSyBMQVlFUg0KPiAgICAgICBjYW46IHNqYTEwMDA6IE1ha2VmaWxlL0tjb25maWc6IHNvcnQg
YWxwaGFiZXRpY2FsbHkNCj4NCj4gT2xpdmVyIEhhcnRrb3BwICgyKToNCj4gICAgICAgY2FuOiBy
ZW1vdmUgb2Jzb2xldGUgZW1wdHkgaW9jdGwoKSBoYW5kbGVyDQo+ICAgICAgIGNhbjogQWRkIFNQ
RFggbGljZW5zZSBpZGVudGlmaWVycyBmb3IgQ0FOIHN1YnN5c3RlbQ0KPg0KPiBSb2JlcnQgUC4g
Si4gRGF5ICgxKToNCj4gICAgICAgY2FuOiBLY29uZmlnOiBjb3JyZWN0IGhpc3Rvcnkgb2YgdGhl
IENBTiBwcm90b2NvbA0KPg0KPiBTZWFuIE55ZWtqYWVyICgyKToNCj4gICAgICAgZHQtYmluZGlu
Z3M6IGNhbjogZmxleGNhbjogYWRkIGNhbiB3YWtldXAgcHJvcGVydHkNCj4gICAgICAgY2FuOiBm
bGV4Y2FuOiBhZGQgc3VwcG9ydCBmb3IgRFQgcHJvcGVydHkgJ3dha2V1cC1zb3VyY2UnDQo+DQo+
ICAuLi4vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvY2FuL2ZzbC1mbGV4Y2FuLnR4dCAgICB8ICAg
MTAgKw0KPiAgLi4uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L2Nhbi90Y2FuNHg1eC50eHQgICAg
ICAgfCAgIDM3ICsNCj4gIE1BSU5UQUlORVJTICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIHwgICAgNSArDQo+ICBkcml2ZXJzL25ldC9jYW4vS2NvbmZpZyAgICAgICAgICAg
ICAgICAgICAgICAgICAgICB8ICAgMTMgKw0KPiAgZHJpdmVycy9uZXQvY2FuL01ha2VmaWxlICAg
ICAgICAgICAgICAgICAgICAgICAgICAgfCAgICAxICsNCj4gIGRyaXZlcnMvbmV0L2Nhbi9hdDkx
X2Nhbi5jICAgICAgICAgICAgICAgICAgICAgICAgIHwgICAgNiArLQ0KPiAgZHJpdmVycy9uZXQv
Y2FuL2ZsZXhjYW4uYyAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgMTM2ICstDQo+ICBkcml2
ZXJzL25ldC9jYW4va3Zhc2VyX3BjaWVmZC5jICAgICAgICAgICAgICAgICAgICB8IDE5MTIgKysr
KysrKysrKysrKysrKysrKysNCj4gIGRyaXZlcnMvbmV0L2Nhbi9tX2Nhbi9LY29uZmlnICAgICAg
ICAgICAgICAgICAgICAgIHwgICAyMiArLQ0KPiAgZHJpdmVycy9uZXQvY2FuL21fY2FuL01ha2Vm
aWxlICAgICAgICAgICAgICAgICAgICAgfCAgICAyICsNCj4gIGRyaXZlcnMvbmV0L2Nhbi9tX2Nh
bi9tX2Nhbi5jICAgICAgICAgICAgICAgICAgICAgIHwgMTA3OSArKysrKy0tLS0tLQ0KPiAgZHJp
dmVycy9uZXQvY2FuL21fY2FuL21fY2FuLmggICAgICAgICAgICAgICAgICAgICAgfCAgMTEwICsr
DQo+ICBkcml2ZXJzL25ldC9jYW4vbV9jYW4vbV9jYW5fcGxhdGZvcm0uYyAgICAgICAgICAgICB8
ICAyMDIgKysrDQo+ICBkcml2ZXJzL25ldC9jYW4vbV9jYW4vdGNhbjR4NXguYyAgICAgICAgICAg
ICAgICAgICB8ICA1MzIgKysrKysrDQo+ICBkcml2ZXJzL25ldC9jYW4vcGVha19jYW5mZC9wZWFr
X3BjaWVmZF9tYWluLmMgICAgICB8ICAgIDIgKy0NCj4gIGRyaXZlcnMvbmV0L2Nhbi9zamExMDAw
L0tjb25maWcgICAgICAgICAgICAgICAgICAgIHwgICA3OSArLQ0KPiAgZHJpdmVycy9uZXQvY2Fu
L3NqYTEwMDAvTWFrZWZpbGUgICAgICAgICAgICAgICAgICAgfCAgIDExICstDQo+ICBkcml2ZXJz
L25ldC9jYW4vc2phMTAwMC9mODE2MDEuYyAgICAgICAgICAgICAgICAgICB8ICAyMTIgKysrDQo+
ICBkcml2ZXJzL25ldC9jYW4vc3BpL21jcDI1MXguYyAgICAgICAgICAgICAgICAgICAgICB8ICAg
IDMgKy0NCj4gIGRyaXZlcnMvbmV0L2Nhbi90aV9oZWNjLmMgICAgICAgICAgICAgICAgICAgICAg
ICAgIHwgIDE5MSArLQ0KPiAgZHJpdmVycy9uZXQvY2FuL3VzYi9rdmFzZXJfdXNiL2t2YXNlcl91
c2JfY29yZS5jICAgfCAgICAzICstDQo+ICBkcml2ZXJzL25ldC9jYW4vdXNiL3BlYWtfdXNiL3Bj
YW5fdXNiLmMgICAgICAgICAgICB8ICAgIDIgKy0NCj4gIGRyaXZlcnMvbmV0L2Nhbi94aWxpbnhf
Y2FuLmMgICAgICAgICAgICAgICAgICAgICAgIHwgIDI5MyArKy0NCj4gIGluY2x1ZGUvbGludXgv
Y2FuL2NvcmUuaCAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgICAgMyArLQ0KPiAgaW5jbHVk
ZS9saW51eC9jYW4vc2tiLmggICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgICAyICstDQo+
ICBuZXQvY2FuL0tjb25maWcgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAg
MTEgKy0NCj4gIG5ldC9jYW4vYWZfY2FuLmMgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIHwgICAxMCArLQ0KPiAgbmV0L2Nhbi9hZl9jYW4uaCAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgfCAgICAxICsNCj4gIG5ldC9jYW4vYmNtLmMgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIHwgICAgMyArLQ0KPiAgbmV0L2Nhbi9ndy5jICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgICAxICsNCj4gIG5ldC9jYW4vcHJvYy5jICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgICAgMSArDQo+ICBuZXQvY2FuL3Jh
dy5jICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgIDMgKy0NCj4gIDMy
IGZpbGVzIGNoYW5nZWQsIDQwOTggaW5zZXJ0aW9ucygrKSwgODAwIGRlbGV0aW9ucygtKSAgY3Jl
YXRlIG1vZGUgMTAwNjQ0DQo+IERvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQv
Y2FuL3RjYW40eDV4LnR4dA0KPiAgY3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvbmV0L2Nhbi9r
dmFzZXJfcGNpZWZkLmMgIGNyZWF0ZSBtb2RlIDEwMDY0NA0KPiBkcml2ZXJzL25ldC9jYW4vbV9j
YW4vbV9jYW4uaCAgY3JlYXRlIG1vZGUgMTAwNjQ0DQo+IGRyaXZlcnMvbmV0L2Nhbi9tX2Nhbi9t
X2Nhbl9wbGF0Zm9ybS5jDQo+ICBjcmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy9uZXQvY2FuL21f
Y2FuL3RjYW40eDV4LmMgIGNyZWF0ZSBtb2RlDQo+IDEwMDY0NCBkcml2ZXJzL25ldC9jYW4vc2ph
MTAwMC9mODE2MDEuYw0KPg0KPiAtLQ0KPiBQZW5ndXRyb25peCBlLksuICAgICAgICAgICAgICAg
ICAgfCBNYXJjIEtsZWluZS1CdWRkZSAgICAgICAgICAgfA0KPiBJbmR1c3RyaWFsIExpbnV4IFNv
bHV0aW9ucyAgICAgICAgfCBQaG9uZTogKzQ5LTIzMS0yODI2LTkyNCAgICAgfA0KPiBWZXJ0cmV0
dW5nIFdlc3QvRG9ydG11bmQgICAgICAgICAgfCBGYXg6ICAgKzQ5LTUxMjEtMjA2OTE3LTU1NTUg
fC0NCj4gQW10c2dlcmljaHQgSGlsZGVzaGVpbSwgSFJBIDI2ODYgIHwgaHR0cDovL3d3dy5wZW5n
dXRyb25peC5kZSAgIHwNCj4NCj4NCj4NCj4NCg0KDQotLQ0KUEVBSy1TeXN0ZW0gVGVjaG5payBH
bWJIDQpTaXR6IGRlciBHZXNlbGxzY2hhZnQgRGFybXN0YWR0IC0gSFJCIDkxODMNCkdlc2NoYWVm
dHNmdWVocnVuZzogQWxleGFuZGVyIEdhY2ggLyBVd2UgV2lsaGVsbQ0KVW5zZXJlIERhdGVuc2No
dXR6ZXJrbGFlcnVuZyBtaXQgd2ljaHRpZ2VuIEhpbndlaXNlbg0KenVyIEJlaGFuZGx1bmcgcGVy
c29uZW5iZXpvZ2VuZXIgRGF0ZW4gZmluZGVuIFNpZSB1bnRlcg0Kd3d3LnBlYWstc3lzdGVtLmNv
bS9EYXRlbnNjaHV0ei40ODMuMC5odG1sDQo=

--_002_AM6PR03MB4006F834B65943E49F485FA6D6C60AM6PR03MB4006eurp_
Content-Type: message/rfc822
Content-Disposition: attachment;
	creation-date="Wed, 24 Jul 2019 09:24:48 GMT";
	modification-date="Wed, 24 Jul 2019 09:24:48 GMT"

Received: from VI1PR03MB4016.eurprd03.prod.outlook.com (2603:10a6:203:a3::15)
 by AM6PR03MB4006.eurprd03.prod.outlook.com with HTTPS via
 AM5PR0602CA0005.EURPRD06.PROD.OUTLOOK.COM; Fri, 5 Jul 2019 13:32:33 +0000
Received: from AM7PR03CA0005.eurprd03.prod.outlook.com (2603:10a6:20b:130::15)
 by VI1PR03MB4016.eurprd03.prod.outlook.com (2603:10a6:803:6b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2052.18; Fri, 5 Jul
 2019 13:32:33 +0000
Received: from VE1EUR03FT027.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e09::206) by AM7PR03CA0005.outlook.office365.com
 (2603:10a6:20b:130::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2052.19 via Frontend
 Transport; Fri, 5 Jul 2019 13:32:32 +0000
Received: from smtp1-g21.free.fr (212.27.42.1) by
 VE1EUR03FT027.mail.protection.outlook.com (10.152.18.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2052.18 via Frontend Transport; Fri, 5 Jul 2019 13:32:32 +0000
Received: from linux-dev.peak.localnet (unknown [185.109.201.203])
	(Authenticated sender: stephane.grosjean)
	by smtp1-g21.free.fr (Postfix) with ESMTPSA id 02262B0056A;
	Fri,  5 Jul 2019 15:32:28 +0200 (CEST)
From: =?iso-8859-1?Q?St=E9phane_Grosjean?= <s.grosjean@peak-system.com>
To: linux-can Mailing List <linux-can@vger.kernel.org>
CC: =?iso-8859-1?Q?St=E9phane_Grosjean?= <s.grosjean@peak-system.com>
Subject: [PATCH] can/peak_usb: fix potential double kfree_skb()
Thread-Topic: [PATCH] can/peak_usb: fix potential double kfree_skb()
Thread-Index: AQHVMzYa2nTdNrDBckeHbYZD2K62vA==
Date: Fri, 5 Jul 2019 13:32:16 +0000
Message-ID: <20190705133217.4204-1-s.grosjean@peak-system.com>
Content-Language: fr-FR
X-MS-Exchange-Organization-AuthSource:
 VE1EUR03FT027.eop-EUR03.prod.protection.outlook.com
X-MS-Has-Attach:
X-MS-Exchange-Organization-Network-Message-Id:
 28a33627-8d40-4715-738f-08d7014d3bd9
X-Message-Flag: Follow up
X-MS-TNEF-Correlator:
X-MS-Exchange-Organization-RecordReviewCfmType: 0
x-ms-publictraffictype: Email
received-spf: PermError (protection.outlook.com: domain of peak-system.com
 used an invalid SPF mechanism)
x-ms-exchange-organization-originalclientipaddress: 212.27.42.1
x-ms-exchange-organization-originalserveripaddress: 10.152.18.154
X-Microsoft-Antispam-Mailbox-Delivery:
 ucf:0;jmr:0;ex:0;auth:0;dest:I;ENG:(750119)(520011016)(944504077)(944702077);
X-Microsoft-Antispam-Message-Info:
 =?iso-8859-1?Q?Fe8uyGpdiTDDhGqiP9Gw7vr2y/tptNzHjxLlprqsebAjZUzdN9al2kDvIk?=
 =?iso-8859-1?Q?VNZ0IPaiO7alQgEI9yhcYHYlYDyviqf6T6dTaUpznyEpWN4AhwCWoXccGv?=
 =?iso-8859-1?Q?9g6PthhLLNpNge3o1gElmHVO08XmprT/+RZiM62OSPwACf/EGbAvYDOg58?=
 =?iso-8859-1?Q?VY5pCyPQEakUjkIFdiAfjkdPdGBT9HlSH1S9X8q+GhheG1c3dq4ldUAIIF?=
 =?iso-8859-1?Q?7HnH+fKvgseGQRMKk509/cUYBI3AtTOmMdTNIkowegQb7SOWnyeOkJoQvE?=
 =?iso-8859-1?Q?IphEME4AUAFfKoilv8QxfyYZSs5j9s7U68crIbk7jEWNb3RLTqt0LlFl6f?=
 =?iso-8859-1?Q?xFKbLXVbZgShRh2NKNXujOTVRM46iu13kfA/eh79sbQzVQL0i0vJVnJr4z?=
 =?iso-8859-1?Q?7F1LxpORNsaIxgb7aFWog5G+rw6WTAtF512KThjiYuhVsYPjPDHburLG1O?=
 =?iso-8859-1?Q?6EO0803a76dZWGhotKG21yPizp35uaBci6QPdgkMmFNer/GgBLHEyCuImL?=
 =?iso-8859-1?Q?RgIHPF/n8MzUyvy/SZyLH5DsmMyMyOmhviaLFVBtXjIXJPC584BgxIxQc0?=
 =?iso-8859-1?Q?I2S3nP6lW2UFj+/qlbo7iYaINWXDpPAvbJ0z7oMIBuoe/ibLXTd9wtk07S?=
 =?iso-8859-1?Q?iL4g/D+UXG+tdGzICPrmHICx7xIS4Smy1L/GCXpPkMNkT3KdsJQ+GRbvbe?=
 =?iso-8859-1?Q?EEdQq+LJi6tZzqrylrbKbuyb3JWLF/kOnwudEt/bjoTncP0mkXuXMT1oKl?=
 =?iso-8859-1?Q?DZDqcpEFyN+vdCQ747pB1ZTNRzYQsPNJfq/yyT4hHuCevClnbLAlyK9Vud?=
 =?iso-8859-1?Q?+X8Om/sW8lZA018IDf7mFH1Yld8JjsR72PKr1eQeoSlM9DilhhpE1xIuDL?=
 =?iso-8859-1?Q?DlHHSn1cfgkvHBDnsFQCpW+DvANrbCPWP3MV9u9EvFLnMVgQlVWCpxXmiF?=
 =?iso-8859-1?Q?eQn/ut1hqlJCyRFzW0y8+RE/ygLloCgYQcdoNWZNaRy61SMUTGqcqdLTfi?=
 =?iso-8859-1?Q?ZEJvmcroxt1jE19T7g5aVpkKb98cZIXGgbaQh4M/Vfa6gyAC57grjAGiK8?=
 =?iso-8859-1?Q?Bwos7reeMECZa2/2jC8V28Gn1gLy6O1KplgLTyf9DVWe+vIl7lsDvd3JFC?=
 =?iso-8859-1?Q?2RcFyt0O3tztHtOyBLcd70oqruhHaoOKakQFyiz9FCXxb/55ovzE3DUTuQ?=
 =?iso-8859-1?Q?aHZn+Wet5SvGcA=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0

When closing the CAN device while tx skbs are inflight, echo skb could be
released twice. By calling close_candev() before unlinking all pending
tx urbs, then the internal echo_skb[] array is fully and correctly cleared
before the USB write callback and, therefore, can_get_echo_skb() are called=
,
for each aborted URB.

Signed-off-by: Stephane Grosjean <s.grosjean@peak-system.com>
---
 drivers/net/can/usb/peak_usb/pcan_usb_core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_core.c b/drivers/net/can=
/usb/peak_usb/pcan_usb_core.c
index 611f9d31be5d..740ef47eab01 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_core.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
@@ -576,16 +576,16 @@ static int peak_usb_ndo_stop(struct net_device *netde=
v)
        dev->state &=3D ~PCAN_USB_STATE_STARTED;
        netif_stop_queue(netdev);

+       close_candev(netdev);
+
+       dev->can.state =3D CAN_STATE_STOPPED;
+
        /* unlink all pending urbs and free used memory */
        peak_usb_unlink_all_urbs(dev);

        if (dev->adapter->dev_stop)
                dev->adapter->dev_stop(dev);

-       close_candev(netdev);
-
-       dev->can.state =3D CAN_STATE_STOPPED;
-
        /* can set bus off now */
        if (dev->adapter->dev_set_bus) {
                int err =3D dev->adapter->dev_set_bus(dev, 0);
--
2.20.1


--
PEAK-System Technik GmbH
Sitz der Gesellschaft Darmstadt - HRB 9183
Geschaeftsfuehrung: Alexander Gach / Uwe Wilhelm
Unsere Datenschutzerklaerung mit wichtigen Hinweisen
zur Behandlung personenbezogener Daten finden Sie unter
www.peak-system.com/Datenschutz.483.0.html

--_002_AM6PR03MB4006F834B65943E49F485FA6D6C60AM6PR03MB4006eurp_--
