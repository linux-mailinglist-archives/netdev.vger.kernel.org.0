Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0B661AD05F
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 21:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731063AbgDPTbc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 15:31:32 -0400
Received: from mail-eopbgr70082.outbound.protection.outlook.com ([40.107.7.82]:24034
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728664AbgDPTbb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Apr 2020 15:31:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JA9R+T44hHcsgml4vode/GwLwcUUU7+jUjSwoPLRTCB7i3Lk6C+8JI5TB2SYculc3q6x9IudT2xj3nxG05jGK/K+W3DHEaT5+aF/TzKm9KTPP0FSUG1sOGi698IIPoR+9wOciKY0mv0KqLTSMPfGC6BoZRogjBg2Ef/KH8O3h5KP5vCxnioqHvuAPZT+i+wX+/xPAFlQhfs6t1P/fY7l2oX+BrHQzh3+J7SQCl9aWTNXgmAJ/jeFsMuntEErNbePXqYyRRYflnDasF4OwF5xYry0Meh5GNMqbPtUIOLl/ogguhymjyB61BT9k1bKMlXWCrAcAmQgT89ER+uuUiFqmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7+owjINVbVrNNZG99t3IzNtCSJQxfJubE2moQGrdDDA=;
 b=RRuJmfHcSs4oJgW9jkLKsMdq+ylGXHr01ZDYe2OMvConzrAX12Tz0RKtsrqkTe5Hq6gM6reiRQlV4NJGEaAhsR363Za7U3fJw7wYOO41CwNIh1msshZN3oMBeSy1c4zizKxszaVMAUdjmAO3MEFx6prMoMEtnwryIp8x1ryXp28rTjiCvI33yM2c9lC0wuDX+6iw5tQ1Q5ep3lb3sUcCBB8H15j9SvEVBn821h+ZVS35ccU7qTzoUmF96fMRFeH9kb4lvQUYTixECWhy4O7JPyNFIPL837vYwVB3WNPMIHgdOIbqm4AjAFxetdJDEdmZcypdmiQOjJsT5JZqdkLv6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7+owjINVbVrNNZG99t3IzNtCSJQxfJubE2moQGrdDDA=;
 b=DBOXaFVGdhAK5pz632MFoO20xkRRvM9Yxw2ku7/FzEQZsxYdEYsXwz+wq1/jzwfJd5blenJb3uu1C17PVmsBcvi4YsTIkHAFYSwEuBnmDrd0+4mN6A02BmTZUtNnArdr4H+BLYUXfoatk/gnwucoaPsPRdgWlkAB1lHuyUZSvHQ=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5358.eurprd05.prod.outlook.com (2603:10a6:803:a8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.17; Thu, 16 Apr
 2020 19:31:26 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2900.028; Thu, 16 Apr 2020
 19:31:25 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "gerlitz.or@gmail.com" <gerlitz.or@gmail.com>
CC:     "sashal@kernel.org" <sashal@kernel.org>,
        "ecree@solarflare.com" <ecree@solarflare.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH AUTOSEL 4.9 09/26] net/mlx5e: Init ethtool steering for
 representors
Thread-Topic: [PATCH AUTOSEL 4.9 09/26] net/mlx5e: Init ethtool steering for
 representors
Thread-Index: AQHWEFb6WRVOJO0/j0GE4IB+QkA/0qh1Ei4AgAC1ZICAAheSAIAAjYWAgAAM6ICAADp+AIAAE8gAgABWOICAAURNAIAAgPKAgADlNYCAAD1UgIAAJLSA
Date:   Thu, 16 Apr 2020 19:31:25 +0000
Message-ID: <b8651ce6d7d6c6dcb8b2d66f07148413892b48d0.camel@mellanox.com>
References: <20200412105935.49dacbf7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <20200414015627.GA1068@sasha-vm>
         <CAJ3xEMh=PGVSddBWOX7U6uAuazJLFkCpWQNxhg7dDRgnSdQ=xA@mail.gmail.com>
         <20200414110911.GA341846@kroah.com>
         <CAJ3xEMhnXZB-HU7aL3m9A1N_GPxgOC3U4skF_qWL8z3wnvSKPw@mail.gmail.com>
         <a89a592a-5a11-5e56-a086-52b1694e00db@solarflare.com>
         <20200414205755.GF1068@sasha-vm>
         <41174e71-00e1-aebf-b67d-1b24731e4ab3@solarflare.com>
         <20200416000009.GL1068@sasha-vm>
         <CAJ3xEMjfWL=c=voGqV4pUCzWXmiTn-R6mrRi82UAVHMVysKU1g@mail.gmail.com>
         <20200416172001.GC1388618@kroah.com>
In-Reply-To: <20200416172001.GC1388618@kroah.com>
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
x-ms-office365-filtering-correlation-id: d231c265-7af3-49f9-2be6-08d7e23cc0c8
x-ms-traffictypediagnostic: VI1PR05MB5358:
x-microsoft-antispam-prvs: <VI1PR05MB5358D3661ACE6D4E49554A7BBED80@VI1PR05MB5358.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0375972289
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(396003)(366004)(346002)(376002)(136003)(36756003)(54906003)(53546011)(6486002)(2616005)(86362001)(6506007)(8676002)(45080400002)(71200400001)(81156014)(8936002)(186003)(110136005)(478600001)(66446008)(316002)(64756008)(6512007)(66476007)(26005)(4326008)(91956017)(66946007)(76116006)(2906002)(66556008)(5660300002);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hGMaGhv9V7ZGDoByC5WvfcSqB2W7ukE+X9Emz13z0E0aromaXGEOfis9gHdJx1vbHpEPphC1soXXAZDgvukE698Pa3V4OsWF0NleKmtwVIuc7Gi984cJWeFS0nfd4F4dZ3S3z8KKUWpfT7edLkCcdT8fwR+AT8RprVGGhd4xTmFGuXDarIvJbgIvgJ5Ybm7Tid9WzdI1akeqL/iWY/rfjMYnU8F1cKPMOI8NeJHHV19nuq9Ryca72J00TSxfArFGlPLnbzAI6hak9wJrWDSafoxMgRSuBzNe0PnAeni7w/ufsjPgFQfvNvlNaf3KWVkpztQ9EHHw+mi/yJ6OGsb03aGZLV3Xp6DhSpDof4QWcHdjDnccwchhtsfjRj1183rzOvudUQ08lugRk/Xdqa/AxrCV83TvleXBJURXvMZ1kdTGTzKLZuFiT+5x0acOKDr/
x-ms-exchange-antispam-messagedata: UlS+6mzpW+uyRdgP7Q9LuctXONCcwT5JVj2RCl0P0Y/brG7fcakRd2VNfVSsFVRO6lKB7FCdwofADRaWk1mXBB8SU88PH85WS+R1XvLmn/o2Nj+REqyyK0SD4iSK+UhfTAhrR7xgCHbhBbNfTrER8g==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <C361CA9BEFA3E64A93F09BB9C87473D9@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d231c265-7af3-49f9-2be6-08d7e23cc0c8
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2020 19:31:25.5733
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ImD1N1mgh1kJ+xq+20ssNvRIgm++mG1TjXPuJhlzSewYJogIugmG0p9F1sPs+kM2tPgrb0vL9MvS6zCv/zfXJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5358
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIwLTA0LTE2IGF0IDE5OjIwICswMjAwLCBHcmVnIEtIIHdyb3RlOg0KPiBPbiBU
aHUsIEFwciAxNiwgMjAyMCBhdCAwNDo0MDozMVBNICswMzAwLCBPciBHZXJsaXR6IHdyb3RlOg0K
PiA+IE9uIFRodSwgQXByIDE2LCAyMDIwIGF0IDM6MDAgQU0gU2FzaGEgTGV2aW4gPHNhc2hhbEBr
ZXJuZWwub3JnPg0KPiA+IHdyb3RlOg0KPiA+ID4gSSdkIG1heWJlIHBvaW50IG91dCB0aGF0IHRo
ZSBzZWxlY3Rpb24gcHJvY2VzcyBpcyBiYXNlZCBvbiBhDQo+ID4gPiBuZXVyYWwNCj4gPiA+IG5l
dHdvcmsgd2hpY2gga25vd3MgYWJvdXQgdGhlIGV4aXN0ZW5jZSBvZiBhIEZpeGVzIHRhZyBpbiBh
DQo+ID4gPiBjb21taXQuDQo+ID4gPiANCj4gPiA+IEl0IGRvZXMgZXhhY3RseSB3aGF0IHlvdSdy
ZSBkZXNjcmliaW5nLCBidXQgYWxzbyB0YWtpbmcgYSBidW5jaA0KPiA+ID4gbW9yZQ0KPiA+ID4g
ZmFjdG9ycyBpbnRvIGl0J3MgZGVzaWNpb24gcHJvY2VzcyAoInBhbmljIj8gIm9vcHMiPyAib3Zl
cmZsb3ciPw0KPiA+ID4gZXRjKS4NCj4gPiANCj4gPiBBcyBTYWVlZCBjb21tZW50ZWQsIGV2ZXJ5
IGV4dHJhIGxpbmUgaW4gc3RhYmxlIC8gcHJvZHVjdGlvbiBrZXJuZWwNCj4gPiBpcyB3cm9uZy4N
Cj4gDQo+IFdoYXQ/ICBPbiB3aGF0IGRvIHlvdSBiYXNlIHRoYXQgY3Jhenkgc3RhdGVtZW50IG9u
PyAgSSBoYXZlIDE4KyB5ZWFycw0KPiBvZg0KPiBkaXJlY3QgZXhwZXJpZW5jZSBvZiB0aGF0IGJl
aW5nIHRoZSBleGFjdCBvcHBvc2l0ZS4NCj4gDQoNCk9oLCBJIG5ldmVyIHNhaWQgc3VjaCBhIHRo
aW5nIC4uIDooIA0KDQpJIHRoaW5rIE9yIG1lYW50IHRvIHNheTogZXZlcnkgZXh0cmEgbGluZSB0
aGF0IG5vIG9uZSBhc2tlZCBmb3IuDQoNCkFuZCBhbGwgaSB3YW50ZWQgdG8gc2F5IGlzIHRoYXQg
aXQgY2FuIGhhdmUgYSBjYXRhc3Ryb3BoaWMgcmVzdWx0Li4NCkkga25vdyBpbiBtYW55IGNhc2Vz
IGl0IGlzIHdvcmtpbmcgd2VsbCwgYW5kIGkgZGlkbid0IHNheSBpdCBpcyB3cm9uZywNCkkgYW0g
anVzdCB3b3JyaWVkIGFib3V0IGl0IGFuZCB3YW50ZWQgdG8gc2hvdyBhbiBleGFtcGxlIG9mIGhv
dyBpdCBjYW4NCnNjcmV3IHVwIHVuZGVyIHRoZSByYWRhciB3aXRoIGEgc2ltcGxlIHNpbmdsZSBs
aW5lciBwYXRjaC4uIA0KDQo+ID4gSU1ITyBpdCBkb2Vzbid0IG1ha2UgYW55IHNlbnNlIHRvIHRh
a2UgaW50byBzdGFibGUgYXV0b21hdGljYWxseQ0KPiA+IGFueSBwYXRjaCB0aGF0IGRvZXNuJ3Qg
aGF2ZSBmaXhlcyBsaW5lLiBEbyB5b3UgaGF2ZSAxLzIvMy80LzUNCj4gPiBjb25jcmV0ZQ0KPiA+
IGV4YW1wbGVzIGZyb20geW91ciAocmVmZXJyaW5nIHRvIHlvdXIgTWljcm9zb2Z0IGVtcGxveWVl
IGhhdA0KPiA+IGNvbW1lbnQNCj4gPiBiZWxvdykgb3Igb3RoZXIncyBwZW9wbGUgcHJvZHVjdGlv
biBlbnZpcm9ubWVudCB3aGVyZSBwYXRjaGVzDQo+ID4gcHJvdmVkIHRvDQo+ID4gYmUgbmVjZXNz
YXJ5IGJ1dCB0aGV5IGxhY2tlZCB0aGUgZml4ZXMgdGFnIC0gd291bGQgbG92ZSB0byBzZWUNCj4g
PiB0aGVtLg0KPiANCj4gT2ggd293LCB3aGVyZSBkbyB5b3Ugd2FudCBtZSB0byBzdGFydC4gIEkg
aGF2ZSB6aWxsaW9ucyBvZiB0aGVzZS4NCj4gDQo+IEJ1dCB3YWl0LCBkb24ndCB0cnVzdCBtZSwg
dHJ1c3QgYSAzcmQgcGFydHkuICBIZXJlJ3Mgd2hhdCBHb29nbGUncw0KPiBzZWN1cml0eSB0ZWFt
IHNhaWQgYWJvdXQgdGhlIGxhc3QgOSBtb250aHMgb2YgMjAxOToNCj4gCS0gMjA5IGtub3duIHZ1
bG5lcmFiaWxpdGllcyBwYXRjaGVkIGluIExUUyBrZXJuZWxzLCBtb3N0DQo+IHdpdGhvdXQNCj4g
CSAgQ1ZFcw0KPiAJLSA5NTArIGNyaXRpY2lhbCBub24tc2VjdXJpdHkgYnVncyBmaXhlcyBmb3Ig
ZGV2aWNlIFhYWFggYWxvbmUNCj4gCSAgd2l0aCBMVFMgcmVsZWFzZXMNCj4gDQoNClNvIG9wdC1p
biBmb3IgdGhlc2UgY3JpdGljYWwgb3IgX2Fsd2F5c18gaW4gdXNlIGJhc2ljIGtlcm5lbCBzZWN0
aW9ucy4NCmJ1dCBtYWtlIHRoZSBkZWZhdWx0IG9wdC1vdXQuLiANCg0KPiA+IFdlJ3ZlIGJlZW4g
Y29hY2hpbmcgbmV3IGNvbWVycyBmb3IgeWVhcnMgZHVyaW5nIGludGVybmFsIGFuZCBvbi0NCj4g
PiBsaXN0DQo+ID4gY29kZSByZXZpZXdzIHRvIHB1dCBwcm9wZXIgZml4ZXMgdGFnLiBUaGlzIHNl
cnZlcyAoQSkgZm9yIHRoZQ0KPiA+IHVwc3RyZWFtDQo+ID4gaHVtYW4gcmV2aWV3IG9mIHRoZSBw
YXRjaCBhbmQgKEIpIHJlYXNvbmFibGUgaHVtYW4gc3RhYmxlDQo+ID4gY29uc2lkZXJhdGlvbnMu
DQo+IA0KPiBJZiB5b3VyIGRyaXZlci9zdWJzeXN0ZW0gaXMgZG9pbmcgdGhpcywgd29uZGVyZnVs
LCBqdXN0IG9wdC1vdXQgb2YNCj4gdGhlDQo+IGF1dG9zZWwgcHJvY2VzcyBhbmQgeW91IHdpbGwg
bmV2ZXIgYmUgYm90aGVyZWQgYWdhaW4uDQo+IA0KDQpUaGVyZSBhcmUgbWFueSBsZWdhY3kgZGV2
aWNlcyBpbiB0aGUga2VybmVsIHRoYXQgYXJlIG5vdCB3ZWxsDQptYWludGFpbmVkIGFuZCBiZWlu
ZyByYXJlbHkgZml4ZWQgZnJvbSByYW5kb20gdXNlcnMuLiBpZiBhIGZpeCB3aWxsIGJlDQpwaWNr
ZWQgdXAgdG8gdGhlIHdyb25nIGtlcm5lbCwgaXQgY2FuIGdvIHVubm90aWNlZCBmb3IgeWVhcnMu
LiANCg0KPiBCdXQsIHRydXN0IG1lLCBJIHRoaW5rIEkga25vdyBhIGJpdCBhYm91dCB0YWdnaW5n
IHN0dWZmIGZvciBzdGFibGUNCj4ga2VybmVscywgYW5kIHlldCB0aGUgQVVUT1NFTCB0b29sIGtl
ZXBzIGZpbmRpbmcgcGF0Y2hlcyB0aGF0IF9JXw0KPiBmb3Jnb3QNCj4gdG8gdGFnIGFzIHN1Y2gu
ICBTbywgZG9uJ3QgYmUgc28gc3VyZSBvZiB5b3Vyc2VsZiwgaXQncyBodW1ibGluZyA6KQ0KPiAN
Cj4gTGV0IHRoZSBBVVRPU0VMIHRvb2wgcnVuLCBhbmQgaWYgaXQgZmluZHMgdGhpbmdzIHlvdSBk
b24ndCBhZ3JlZQ0KPiB3aXRoLCBhDQo+IHNpbXBsZSAiTm8sIHBsZWFzZSBkbyBub3QgaW5jbHVk
ZSB0aGlzIiBlbWFpbCBpcyBhbGwgeW91IG5lZWQgdG8gZG8NCj4gdG8NCj4ga2VlcCBpdCBvdXQg
b2YgYSBzdGFibGUga2VybmVsLg0KPiANCj4gU28gZmFyIHRoZSBBVVRPU0VMIHRvb2wgaGFzIGZv
dW5kIHNvIG1hbnkgcmVhbCBidWdmaXhlcyB0aGF0IGl0IGlzbid0DQo+IGZ1bm55LiAgSWYgeW91
IGRvbid0IGxpa2UgaXQsIGZpbmUsIGJ1dCBpdCBoYXMgcHJvdmVuIGl0c2VsZiBfd2F5Xw0KPiBi
ZXlvbmQgbXkgd2lsZGVzdCBob3BlcyBhbHJlYWR5LCBhbmQgaXQganVzdCBrZWVwcyBnZXR0aW5n
IGJldHRlci4NCj4gDQoNCk5vdyBpIHJlYWxseSBkb24ndCBrbm93IHdoYXQgdGhlIHJpZ2h0IGJh
bGFuY2UgaGVyZSwgaW4gb24gb25lIGhhbmQsDQphdXRvc2VsIGlzIGRvaW5nIGEgZ3JlYXQgam9i
LCBvbiB0aGUgb3RoZXIgaGFuZCB3ZSBrbm93IGl0IGNhbiBzY3JldyB1cA0KaW4gc29tZSBjYXNl
cywgYW5kIHdlIGtub3cgaXQgd2lsbC4gDQoNClNvIHdlIGRlY2lkZWQgdG8gbWFrZSBzYWNyaWZp
Y2VzIGZvciB0aGUgZ3JlYXRlciBnb29kID8gOikgDQoNCj4gZ3JlZyBrLWgNCg==
