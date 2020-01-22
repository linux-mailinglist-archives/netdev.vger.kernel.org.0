Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35EF7145BC0
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 19:51:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728779AbgAVSvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 13:51:45 -0500
Received: from mail-eopbgr40084.outbound.protection.outlook.com ([40.107.4.84]:15397
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725884AbgAVSvo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jan 2020 13:51:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kgut+XBuURevnriS/j645wvFwOluwsPD+GLCz1BB3cmUvSTioD5lth2w6ypO2CeD5axo0j/1PVY/ZorKHA36JWArqmou6WaugGjqvT3x7oCm7b0A4J94gq80jjSGiRpB7CbQN1jdFHj2xvJMU5kX+HHG44yCCouGyOYx56/nlX/VoLvu+UokNEDNPx6LrSj4mMoNtdZGImoNIBE5QCCBx/SZ/a26uqnTOTmS2Mmtg3hrPxpUJiVbOGxMZjxijLCrR1P0CYvifmUVkFg9h9SSZPa/WJ5C6q0oTZT5leZ/gy7KohCDyycI0lzRWxTQJa36WjWqd8b0fJwFsftrMblfsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DxK7GlyxyciRBZcKhFf2kFvRoH0ZQk5Km05jyS0D6kU=;
 b=Ay2UApdwPC+vl7VOM5ecT5gU2uZI82gWzoBOZ7mWt7T9MgIgHoLHCPhLXNoVZxRjJiGooPOo2y/ELEknU6Q8A4b6iFEOuOqufUx4FLiayEHncWAwuXuG2+6vDJgYnYVbpDo6BigQR/Pp9FahGabIVqvGvhvGga0AK3+sly3aD7WyD75osUVQlxl85oP2WTEajOQSJBNDaapA+fMDYOLGJofqXrTlS1fMpgbyR+Lr2u8mz91xlnd/JQhux7wcSTNxzP+aSCuvy/Vzzt+OLkyZMurpjqyGHS9JQIw2DRm7YqKrNBnwZS13nSA/6rn1goCg2x/zOXtiInIHDqn8jkAJNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DxK7GlyxyciRBZcKhFf2kFvRoH0ZQk5Km05jyS0D6kU=;
 b=ExsoFF0+qw1Wxm97P1rCsN7l4PBFWGCZKP+0/29kGQpUaQBt4O9uTpB+tSqpDJofi2mtKILel6eKVF5T6W6PGJkMDm57iIv9pFe/9PTdhZ0HIlkSdcq6LWzjLcg/scPWIn3ENFUExiyruKJizkA44XrHWHj9qyzLqjIwaBPTiSE=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5918.eurprd05.prod.outlook.com (20.178.126.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Wed, 22 Jan 2020 18:51:40 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Wed, 22 Jan 2020
 18:51:40 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "olof@lixom.net" <olof@lixom.net>
CC:     "joe@perches.com" <joe@perches.com>,
        "saeedm@dev.mellanox.co.il" <saeedm@dev.mellanox.co.il>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net/mlx5e: Fix printk format warning
Thread-Topic: [PATCH] net/mlx5e: Fix printk format warning
Thread-Index: AQHVtsqd/1iQZ7q6aE6djst+rs1pTafCRruAgALUZQCADp69gIAg7A4AgAEjTwCAAU1kgIAAJcAA
Date:   Wed, 22 Jan 2020 18:51:40 +0000
Message-ID: <8f96a47605c6e07a254e21fc70230911692ed773.camel@mellanox.com>
References: <20191220001517.105297-1-olof@lixom.net>
         <ff6dc8997083c5d8968df48cc191e5b9e8797618.camel@perches.com>
         <CAOesGMgxHGBdkdVOoWYpqSF-13iP3itJksCRL8QSiS0diL26dA@mail.gmail.com>
         <CALzJLG-L+0dgW=5AXAB8eMjAa3jaSHVaDLuDsSBf9ahqM0Ti-A@mail.gmail.com>
         <CAOesGMhXHCz+ahs6whKsS32uECVry9Lk6BQxcvczPXgcoh6b6w@mail.gmail.com>
         <028a4905eaf02dce476e8cfc517b49760f57f577.camel@mellanox.com>
         <CAOesGMjLXRO4epU0CFymYWdGYNWB4BNOaVxmnst-On3QzHLRNw@mail.gmail.com>
In-Reply-To: <CAOesGMjLXRO4epU0CFymYWdGYNWB4BNOaVxmnst-On3QzHLRNw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.3 (3.34.3-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 64f11f4b-87c1-4d1a-3252-08d79f6c1e31
x-ms-traffictypediagnostic: VI1PR05MB5918:|VI1PR05MB5918:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5918339036D10594B0EA8280BE0C0@VI1PR05MB5918.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 029097202E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(346002)(376002)(39860400002)(366004)(199004)(189003)(2616005)(5660300002)(6486002)(8676002)(316002)(71200400001)(8936002)(81156014)(6506007)(53546011)(81166006)(6512007)(54906003)(4001150100001)(4326008)(186003)(2906002)(36756003)(64756008)(66446008)(66476007)(76116006)(91956017)(66946007)(66556008)(478600001)(6916009)(26005)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5918;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sE7TLkoXtG0DcQrnVhixwcGAJ/G0KqRnaeqbiy9SVXcs81Nqz4zfRv+4X0NkMSK/jBNA5I0jh7+HlcYnWOMXoO4aWefRG8JzqlbhyZ67G7RWvEiZngZ4sHY/qh9NdMhX2rg6nCP34Eq0x8m2Ncbp8s1J4xFcSHlERZ0cvQZ7ceH555GRMOe/iAYklKZlxwQsmqHrViCRSiyo+K2GfArRnHQib+Hy+dddVwCQuY5EcrSwxJSp8m41EINvFSEQADsppJJX5McHX+f6Hv4LvgU/lCwFCguP1ql69+ZruoyO0WUTV+LXeftir2wl2ocelqsKO0rah+B0FMejwfMIUzhEO4ndyi/kSdseDbM02Iq06K3tAO5EbosHqdx0a0b/JxLL32c9Lb1koYmkd5ciwv3XqP08SigW997zU1ILZBM5sUP1OHmm5ZG1jPnWyCSbuaGK
Content-Type: text/plain; charset="utf-8"
Content-ID: <79CD6A964088644A9D415E1F2426A6EA@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64f11f4b-87c1-4d1a-3252-08d79f6c1e31
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2020 18:51:40.7719
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nFyFygNdX7pBsRMfR+BcOpGqqIUqFK0Ni0Zv4a0UT6e/LKUUXMLB0hetVk5sFiB8lSiXgPbVyHXkkTSetYKjXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5918
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIwLTAxLTIyIGF0IDA4OjM2IC0wODAwLCBPbG9mIEpvaGFuc3NvbiB3cm90ZToN
Cj4gT24gVHVlLCBKYW4gMjEsIDIwMjAgYXQgMTI6NDMgUE0gU2FlZWQgTWFoYW1lZWQgPHNhZWVk
bUBtZWxsYW5veC5jb20+DQo+IHdyb3RlOg0KPiA+IE9uIE1vbiwgMjAyMC0wMS0yMCBhdCAxOToy
MCAtMDgwMCwgT2xvZiBKb2hhbnNzb24gd3JvdGU6DQo+ID4gPiBIaSwNCj4gPiA+IA0KPiA+ID4g
T24gTW9uLCBEZWMgMzAsIDIwMTkgYXQgODozNSBQTSBTYWVlZCBNYWhhbWVlZA0KPiA+ID4gPHNh
ZWVkbUBkZXYubWVsbGFub3guY28uaWw+IHdyb3RlOg0KPiA+ID4gPiBPbiBTYXQsIERlYyAyMSwg
MjAxOSBhdCAxOjE5IFBNIE9sb2YgSm9oYW5zc29uIDxvbG9mQGxpeG9tLm5ldD4NCj4gPiA+ID4g
d3JvdGU6DQo+ID4gPiA+ID4gT24gVGh1LCBEZWMgMTksIDIwMTkgYXQgNjowNyBQTSBKb2UgUGVy
Y2hlcyA8am9lQHBlcmNoZXMuY29tPg0KPiA+ID4gPiA+IHdyb3RlOg0KPiA+ID4gPiA+ID4gT24g
VGh1LCAyMDE5LTEyLTE5IGF0IDE2OjE1IC0wODAwLCBPbG9mIEpvaGFuc3NvbiB3cm90ZToNCj4g
PiA+ID4gPiA+ID4gVXNlICIlenUiIGZvciBzaXplX3QuIFNlZW4gb24gQVJNIGFsbG1vZGNvbmZp
ZzoNCj4gPiA+ID4gPiA+IFtdDQo+ID4gPiA+ID4gPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25l
dC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvd3EuYw0KPiA+ID4gPiA+ID4gPiBiL2RyaXZl
cnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS93cS5jDQo+ID4gPiA+ID4gPiBbXQ0K
PiA+ID4gPiA+ID4gPiBAQCAtODksNyArODksNyBAQCB2b2lkIG1seDVfd3FfY3ljX3dxZV9kdW1w
KHN0cnVjdA0KPiA+ID4gPiA+ID4gPiBtbHg1X3dxX2N5YyAqd3EsIHUxNiBpeCwgdTggbnN0cmlk
ZXMpDQo+ID4gPiA+ID4gPiA+ICAgICAgIGxlbiA9IG5zdHJpZGVzIDw8IHdxLT5mYmMubG9nX3N0
cmlkZTsNCj4gPiA+ID4gPiA+ID4gICAgICAgd3FlID0gbWx4NV93cV9jeWNfZ2V0X3dxZSh3cSwg
aXgpOw0KPiA+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+ID4gLSAgICAgcHJfaW5mbygiV1FFIERV
TVA6IFdRIHNpemUgJWQgV1EgY3VyIHNpemUgJWQsIFdRRQ0KPiA+ID4gPiA+ID4gPiBpbmRleA0K
PiA+ID4gPiA+ID4gPiAweCV4LCBsZW46ICVsZFxuIiwNCj4gPiA+ID4gPiA+ID4gKyAgICAgcHJf
aW5mbygiV1FFIERVTVA6IFdRIHNpemUgJWQgV1EgY3VyIHNpemUgJWQsIFdRRQ0KPiA+ID4gPiA+
ID4gPiBpbmRleA0KPiA+ID4gPiA+ID4gPiAweCV4LCBsZW46ICV6dVxuIiwNCj4gPiA+ID4gPiA+
ID4gICAgICAgICAgICAgICBtbHg1X3dxX2N5Y19nZXRfc2l6ZSh3cSksIHdxLT5jdXJfc3osIGl4
LA0KPiA+ID4gPiA+ID4gPiBsZW4pOw0KPiA+ID4gPiA+ID4gPiAgICAgICBwcmludF9oZXhfZHVt
cChLRVJOX1dBUk5JTkcsICIiLA0KPiA+ID4gPiA+ID4gPiBEVU1QX1BSRUZJWF9PRkZTRVQsDQo+
ID4gPiA+ID4gPiA+IDE2LCAxLCB3cWUsIGxlbiwgZmFsc2UpOw0KPiA+ID4gPiA+ID4gPiAgfQ0K
PiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiBPbmUgbWlnaHQgZXhwZWN0IHRoZXNlIDIgb3V0cHV0
cyB0byBiZSBhdCB0aGUgc2FtZQ0KPiA+ID4gPiA+ID4gS0VSTl88TEVWRUw+DQo+ID4gPiA+ID4g
PiB0b28uDQo+ID4gPiA+ID4gPiBPbmUgaXMgS0VSTl9JTkZPIHRoZSBvdGhlciBLRVJOX1dBUk5J
TkcNCj4gPiA+ID4gPiANCj4gPiA+ID4gPiBTdXJlLCBidXQgSSdsbCBsZWF2ZSB0aGF0IHVwIHRv
IHRoZSBkcml2ZXIgbWFpbnRhaW5lcnMgdG8NCj4gPiA+ID4gPiBkZWNpZGUvZml4DQo+ID4gPiA+
ID4gLS0gSSdtIGp1c3QgYWRkcmVzc2luZyB0aGUgdHlwZSB3YXJuaW5nIGhlcmUuDQo+ID4gPiA+
IA0KPiA+ID4gPiBIaSBPbG9mLCBzb3JyeSBmb3IgdGhlIGRlbGF5LCBhbmQgdGhhbmtzIGZvciB0
aGUgcGF0Y2gsDQo+ID4gPiA+IA0KPiA+ID4gPiBJIHdpbGwgYXBwbHkgdGhpcyB0byBuZXQtbmV4
dC1tbHg1IGFuZCB3aWxsIHN1Ym1pdCB0byBuZXQtbmV4dA0KPiA+ID4gPiBteXNlbGYuDQo+ID4g
PiA+IHdlIHdpbGwgZml4dXAgYW5kIGFkZHJlc3MgdGhlIHdhcm5pbmcgbGV2ZWwgY29tbWVudCBi
eSBKb2UuDQo+ID4gPiANCj4gPiA+IFRoaXMgc2VlbXMgdG8gc3RpbGwgYmUgcGVuZGluZywgYW5k
IHRoZSBtZXJnZSB3aW5kb3cgaXMgc29vbg0KPiA+ID4gaGVyZS4NCj4gPiA+IEFueQ0KPiA+ID4g
Y2hhbmNlIHdlIGNhbiBzZWUgaXQgc2hvdyB1cCBpbiBsaW51eC1uZXh0IHNvb24/DQo+ID4gPiAN
Cj4gPiA+IA0KPiA+IA0KPiA+IEhpIE9sb2YsDQo+ID4gDQo+ID4gSSBhbSBzdGlsbCBwcmVwYXJp
bmcgbXkgbmV4dCBwdWxsIHJlcXVlc3Qgd2hpY2ggd2lsbCBpbmNsdWRlIHRoaXMNCj4gPiBwYXRj
aA0KPiA+IEkgd2lsbCBzZW5kIGl0IHNvb24gdG8gbmV0LW5leHQgYnJhbmNoLCBidXQgc3RpbGwg
dGhlIHBhdGNoIHdpbGwNCj4gPiBub3QNCj4gPiBoaXQgbGludXgtbmV4dCB1bnRpbCB0aGUgbWVy
Z2Ugd2luZG93IHdoZW4gbmV0ZGV2IHN1YnN5c3RlbSBpcw0KPiA+IHB1bGxlZA0KPiA+IGludG8g
bGludXgtbmV4dC4uDQo+IA0KPiBIaSBTYWVlZCwNCj4gDQo+IGxpbnV4LW5leHQgY29udGFpbnMg
YWxsIHRoZSBtYXRlcmlhbCB0aGF0IG1haW50YWluZXJzIGFyZSBxdWV1aW5nIHVwDQo+IGZvciB0
aGUgbmV4dCBtZXJnZSB3aW5kb3csIGR1cmluZyB0aGUgLXJjIGN5Y2xlcyBvZiB0aGUgcHJldmlv
dXMNCj4gcmVsZWFzZSwgaW5jbHVkaW5nIHRoZSBuZXQtbmV4dCBicmFuY2guDQo+IA0KDQpJIGtu
b3csIHRoaXMgaXMgdGhlIHJlYXNvbiB3aHkgeW91ciBwYXRjaCBpcyBub3QgaW4gbGludXgtbmV4
dCB5ZXQsDQpzaW5jZSBpIGRpZG4ndCBzZW5kIG15IHB1bGwgcmVxdWVzdCB0byBuZXQtbmV4dCB5
ZXQsIGkgYW0gcGxhbmluZyB0byBkbw0KaXQgdG9kYXkgOiksIHNvcnJ5IGZvciB0aGUgZGVsYXlz
Lg0KDQo+IEluIGdlbmVyYWwsIHRoZSBndWlkZWxpbmUgaXMgdG8gbWFrZSBzdXJlIHRoYXQgbW9z
dCBwYXRjaGVzIGFyZSBpbg0KPiAtbmV4dCBhcm91bmQgLXJjNi9yYzcgdGltZWZyYW1lLCB0byBn
aXZlIHRoZW0gc29tZSB0aW1lIGZvciB0ZXN0DQo+IGJlZm9yZSBtZXJnZSB3aW5kb3cgb3BlbnMu
DQo+IA0KPiBTbyB0aGUgZmFjdCB0aGF0IHRoaXMgaGFzbid0IGJlZW4gcGlja2VkIHVwIGFuZCBz
aG93ZWQgdXAgdGhlcmUgeWV0LA0KPiBzZWVtcyBjb25jZXJuaW5nIC0tIGJ1dCBJIGRvbid0IGtu
b3cgd2hlbiBEYXZlIGNsb3NlcyBuZXQgZm9yIG5ldw0KPiBtYXRlcmlhbCBsaWtlIHdoYXQgeW91
J3JlIHN0YWdpbmcuDQo+IA0KDQpNYXliZSBpdCBpcyBhIGdvb2QgaWRlYSB0byBtYXJrIG15IGJy
YW5jaCB0byBiZSBtZXJnZWQgaW50byBsaW51eC1uZXh0Lg0KSSB3aWxsIHRha2UgY2FyZSBvZiB0
aGlzLCB0aGFua3MgZm9yIHBvaW50aW5nIG91dC4uIA0KDQo+IA0KPiAtT2xvZg0K
