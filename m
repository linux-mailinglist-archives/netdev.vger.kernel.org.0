Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D05591AE84E
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 00:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728952AbgDQWij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 18:38:39 -0400
Received: from mail-am6eur05on2084.outbound.protection.outlook.com ([40.107.22.84]:6126
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728770AbgDQWii (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 18:38:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GhtB3RIus13+bWP7NXU5U/YjWjYN5N1g3yeN1PSeWCToxIqIFJb+HFC3G+rBqejmli2vj7f2tSN0mY0uILDVG4w9b5f3ciAAPG/A5MjMWdnLOTMkT/EtT6uwqOMhaCn+mmiKKantAHYtecEdoQq0YcBph5UknXqgKHptP6GeEvNvK6Fs2zCWFzRiPpuYDBZuwiwwCFHid7Dsws6pUoHaw6gpryuMmxLPK0tg1qcH6Dr1IW3P4P2x5HeI6Mws0CT4HsJ9WiBr/eVte2LgWUyyQ3iVdGfA3s8cH3L1/i36kjiXsNzdMt0FOmI5I+Alshr/odkm2En/urwQyHxE7U4iuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Pl/QasY02BRJati/jH3Z/SXYts1X1i9GpOVE5I3AO0=;
 b=Z23ewr98c7hl/fra1b4Uv1aYrwflWJ1UxwxMLiCa6HoZCGtEbYcQ3dpA4FbCTR9E2OXMPQVwpAbcpKAGnW94xyWJ+HIb/9nPHQd4cTjYNlQeufghk/ELAvai07dzYoCk0CqV7z/WTHKkRUZMYt+abfdt2t/n9sA4lNQRUSVLsq1kUlMM3wsDfPsjwSEBIztG6gCTLTpkIEqzgdAXOsuMLimegE4npNv1m9AuoENpsVA3XEQ2KnKJKhLkiTnekWNV2UFwmb9vpmouCBn+thlT+Cg7zZt/Qz34wnC65FxgdN5vOEaz9VSaz1NRejMHew2vwg/JKXLJm4uGx02OdhrLqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Pl/QasY02BRJati/jH3Z/SXYts1X1i9GpOVE5I3AO0=;
 b=SP+Itztpec3pv2+COrvITqY4iCdWTcV5im8W4CQUeJelBifycv+ZLKre8prKVhnjq4R4QLBYDSZKiCO2Atqvfm3vyFTWfFWY647/dnhXD3zu9hCuaqR+HID2cVfFPtU0Cc75WkdwB1FXEEdhySg1TSTDq1cDjdgTeb4HMZoSECE=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6350.eurprd05.prod.outlook.com (2603:10a6:803:fb::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.27; Fri, 17 Apr
 2020 22:38:33 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2900.030; Fri, 17 Apr 2020
 22:38:33 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "sashal@kernel.org" <sashal@kernel.org>
CC:     "ecree@solarflare.com" <ecree@solarflare.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gerlitz.or@gmail.com" <gerlitz.or@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>
Subject: Re: [PATCH AUTOSEL 4.9 09/26] net/mlx5e: Init ethtool steering for
 representors
Thread-Topic: [PATCH AUTOSEL 4.9 09/26] net/mlx5e: Init ethtool steering for
 representors
Thread-Index: AQHWEFb6WRVOJO0/j0GE4IB+QkA/0qh1Ei4AgAC1ZICAAheSAIAAjYWAgAAM6ICAADp+AIAAE8gAgABWOICAAURNAIAAgPKAgABFSICAABU+gIAAh8CAgABeMwCAAA56gIAAE00AgAEP8wCAAJuogA==
Date:   Fri, 17 Apr 2020 22:38:33 +0000
Message-ID: <ab1d30c8afec0459994ea9af40ae859ae3767587.camel@mellanox.com>
References: <a89a592a-5a11-5e56-a086-52b1694e00db@solarflare.com>
         <20200414205755.GF1068@sasha-vm>
         <41174e71-00e1-aebf-b67d-1b24731e4ab3@solarflare.com>
         <20200416000009.GL1068@sasha-vm>
         <434329130384e656f712173558f6be88c4c57107.camel@mellanox.com>
         <20200416052409.GC1309273@unreal> <20200416133001.GK1068@sasha-vm>
         <550d615e14258c744cb76dd06c417d08d9e4de16.camel@mellanox.com>
         <20200416195859.GP1068@sasha-vm>
         <3226e1df60666c0c4e3256ec069fee2d814d9a03.camel@mellanox.com>
         <20200417132124.GS1068@sasha-vm>
In-Reply-To: <20200417132124.GS1068@sasha-vm>
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
x-ms-office365-filtering-correlation-id: 2cb98f66-7ee8-4d8e-9e2d-08d7e3200fb6
x-ms-traffictypediagnostic: VI1PR05MB6350:
x-microsoft-antispam-prvs: <VI1PR05MB6350DEF4FD2063693EA44718BED90@VI1PR05MB6350.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0376ECF4DD
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(396003)(136003)(366004)(346002)(376002)(316002)(66476007)(478600001)(66556008)(66446008)(91956017)(66946007)(64756008)(86362001)(76116006)(4326008)(54906003)(6512007)(36756003)(6916009)(2616005)(71200400001)(186003)(81156014)(5660300002)(6506007)(2906002)(6486002)(8676002)(8936002)(26005);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: msfKiVv52Gbl9ovVbgkNCATx8DTGFhSFdxRpIP2+Mzr3oPlepJjtH5q/X2uGNutC+QIQbemzkHwB658zx4mNKyZ8w/I8gXUmvOGZy8lI0TCVHRe85ADFXJvJaQDooixqa/sqj/IHSkwjSDao2rSh00BsM9oDiMKk6BmRsOMwWIir0Y/FwWvGG2JeAcmiTHb43ttosdiu6F2p+L3BDiKQavh/MBMLiRGZvylPdjXrGZcqE26ESx3k4r9KDLOWCUwCVK/G3mpiGWRXIjEBn/W4QUUmHXDcGP3wUJytmSC9DXNTtnrET9mLHT64VSlES+jBqLb3nHwlU0EGUZROxUZs917hSV+7RkwhMhRahpKCzJfRdj2q6QuPrfruYXVv85F8t+hmzvCcvApjcoG8JGus+hYqgDoe8V3dAfVc+Vs1xZLfVxadeHig3hoChQQMeLRY
x-ms-exchange-antispam-messagedata: fQpBSTu15Fk4jX/jP+lvkfH/zlDyqPF0SYTn6Zvqh5pLzs0MFnxTFartCxe8y9NcbBymA23qMSzUkdvZ3G/oSTaD1DSiZEQH60I7pI3GD+b8ZrlWApip1V+qCAVx3d1qmJ8ggC53muVBUCu1EZJ0EQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <76031D7715DCB3489BA5FC0C4A7C7AEE@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cb98f66-7ee8-4d8e-9e2d-08d7e3200fb6
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Apr 2020 22:38:33.7210
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZbTETXeOXj/TmXDaCYto+j/5rhZq6hUVG1gFIGQ1ffMCaBMHRpk1XmeuiUivPRh8egUMptBt3LM9u3cEvAeCmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6350
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTA0LTE3IGF0IDA5OjIxIC0wNDAwLCBTYXNoYSBMZXZpbiB3cm90ZToNCj4g
T24gVGh1LCBBcHIgMTYsIDIwMjAgYXQgMDk6MDg6MDZQTSArMDAwMCwgU2FlZWQgTWFoYW1lZWQg
d3JvdGU6DQo+ID4gT24gVGh1LCAyMDIwLTA0LTE2IGF0IDE1OjU4IC0wNDAwLCBTYXNoYSBMZXZp
biB3cm90ZToNCj4gPiA+IEhybSwgd2h5PyBQcmV0ZW5kIHRoYXQgdGhlIGJvdCBpcyBhIGh1bWFu
IHNpdHRpbmcgc29tZXdoZXJlDQo+ID4gPiBzZW5kaW5nDQo+ID4gPiBtYWlscyBvdXQsIGhvdyBk
b2VzIGl0IGNoYW5nZSBhbnl0aGluZz8NCj4gPiA+IA0KPiA+IA0KPiA+IElmIGkga25vdyBhIGJv
dCBtaWdodCBkbyBzb21ldGhpbmcgd3JvbmcsIGkgRml4IGl0IGFuZCBtYWtlIHN1cmUgaXQNCj4g
PiB3aWxsIG5ldmVyIGRvIGl0IGFnYWluLiBGb3IgaHVtYW5zIGkganVzdCBjYW4ndCBkbyB0aGF0
LCBjYW4gSSA/IDopDQo+ID4gc28gdGhpcyBpcyB0aGUgZGlmZmVyZW5jZSBhbmQgd2h5IHdlIGFs
bCBoYXZlIGpvYnMgLi4NCj4gDQo+IEl0J3MgdHJpY2t5IGJlY2F1c2UgdGhlcmUncyBubyBvbmUg
dHJ1ZSB2YWx1ZSBoZXJlLiBIdW1hbnMgYXJlDQo+IGNvbnN0YW50bHkgd3JvbmcgYWJvdXQgd2hl
dGhlciBhIHBhdGNoIGlzIGEgZml4IG9yIG5vdCwgc28gaG93IGNhbiBJDQo+IHRyYWluIG15IGJv
dCB0byBiZSAxMDAlIHJpZ2h0Pw0KPiANCj4gPiA+ID4gPiBUaGUgc29sdXRpb24gaGVyZSBpcyB0
byBiZWVmIHVwIHlvdXIgdGVzdGluZyBpbmZyYXN0cnVjdHVyZQ0KPiA+ID4gPiA+IHJhdGhlcg0K
PiA+ID4gPiA+IHRoYW4NCj4gPiA+ID4gDQo+ID4gPiA+IFNvIHBsZWFzZSBsZXQgbWUgb3B0LWlu
IHVudGlsIEkgYmVlZiB1cCBteSB0ZXN0aW5nIGluZnJhLg0KPiA+ID4gDQo+ID4gPiBBbHJlYWR5
IGRpZCA6KQ0KPiA+IA0KPiA+IE5vIHlvdSBkaWRuJ3QgOiksIEkgcmVjZWl2ZWQgbW9yZSB0aGFu
IDUgQVVUT1NFTCBlbWFpbHMgb25seSB0b2RheQ0KPiA+IGFuZA0KPiA+IHllc3RlcmRheS4NCj4g
DQo+IEFwcG9sb2dpZXMsIHRoaXMgaXMganVzdCBhIHJlc3VsdCBvZiBob3cgbXkgcHJvY2VzcyBn
b2VzIC0gcGF0Y2gNCj4gc2VsZWN0aW9uIGhhcHBlbmVkIGEgZmV3IGRheXMgYWdvICh3aGljaCBp
cyB3aGVuIGJsYWNrbGlzdHMgYXJlDQo+IGFwcGxpZWQpLCBpdCdzIGJlZW4gcnVubmluZyB0aHJv
dWdoIG15IHRlc3RzIHNpbmNlLCBhbmQgbWFpbHMgZ2V0DQo+IHNlbnQNCj4gb3V0IG9ubHkgYWZ0
ZXIgdGVzdHMuDQo+IA0KDQpObyB3b3JyaWVzLCBhcyB5b3Ugc2VlIGkgYW0gbm90IHJlYWxseSBh
Z2FpbnN0IHRoaXMgQUkgLi4gaSBhbSBqdXN0DQp3b3JyaWVkIGFib3V0IGl0IGJlaW5nIGFuIG9w
dC1vdXQgdGhpbmcgOikNCg0KPiA+IFBsZWFzZSBkb24ndCBvcHQgbWx4NSBvdXQganVzdCB5ZXQg
Oy0pLCBpIG5lZWQgdG8gZG8gc29tZSBtb3JlDQo+ID4gcmVzZWFyY2gNCj4gPiBhbmQgbWFrZSB1
cCBteSBtaW5kLi4NCj4gDQo+IEFscmlnaHR5LiBLZWVwIGluIG1pbmQgeW91IGNhbiBhbHdheXMg
cmVwbHkgd2l0aCBqdXN0IGEgIm5vIiB0bw0KPiBBVVRPU0VMDQo+IG1haWxzLCB5b3UgZG9uJ3Qg
aGF2ZSB0byBleHBsYWluIHdoeSB5b3UgZG9uJ3Qgd2FudCBpdCBpbmNsdWRlZCB0bw0KPiBrZWVw
DQo+IGl0IGVhc3kuDQo+IA0KDQpTdXJlICEgdGhhbmtzIC4NCg0KPiA+ID4gPiA+IHRha2luZyBs
ZXNzIHBhdGNoZXM7IHdlIHN0aWxsIHdhbnQgdG8gaGF2ZSAqYWxsKiB0aGUgZml4ZXMsDQo+ID4g
PiA+ID4gcmlnaHQ/DQo+ID4gPiA+ID4gDQo+ID4gPiA+IA0KPiA+ID4gPiBpZiB5b3UgY2FuIGJl
IHN1cmUgMTAwJSBpdCBpcyB0aGUgcmlnaHQgdGhpbmcgdG8gZG8sIHRoZW4geWVzLA0KPiA+ID4g
PiBwbGVhc2UNCj4gPiA+ID4gZG9uJ3QgaGVzaXRhdGUgdG8gdGFrZSB0aGF0IHBhdGNoLCBldmVu
IHdpdGhvdXQgYXNraW5nIGFueW9uZQ0KPiA+ID4gPiAhIQ0KPiA+ID4gPiANCj4gPiA+ID4gQWdh
aW4sIEh1bWFucyBhcmUgYWxsb3dlZCB0byBtYWtlIG1pc3Rha2VzLi4gQUkgaXMgbm90Lg0KPiA+
ID4gDQo+ID4gPiBBZ2Fpbiwgd2h5Pw0KPiA+ID4gDQo+ID4gDQo+ID4gQmVjYXVzZSBBSSBpcyBu
b3QgdGhlcmUgeWV0Li4gYW5kIHRoaXMgaXMgYSB2ZXJ5IGJpZyBwaGlsb3NvcGhpY2FsDQo+ID4g
cXVlc3Rpb24uDQo+ID4gDQo+ID4gTGV0IG1lIHNpbXBsaWZ5OiB0aGVyZSBpcyBhIGJ1ZyBpbiB0
aGUgQUksIHdoZXJlIGl0IGNhbiBjaG9vc2UgYQ0KPiA+IHdyb25nDQo+ID4gcGF0Y2gsIGxldCdz
IGZpeCBpdC4NCj4gDQo+IEJ1dCB3ZSBkb24ndCBrbm93IGlmIGl0J3Mgd3Jvbmcgb3Igbm90LCBz
byBob3cgY2FuIHdlIHRlYWNoIGl0IHRvIGJlDQo+IDEwMCUgcmlnaHQ/DQo+IA0KPiBJIGtlZXAg
cmV0cmFpbmluZyB0aGUgTk4gYmFzZWQgb24gcHJldmlvdXMgcmVzdWx0cyB3aGljaCBpbXByb3Zl
cw0KPiBpdCdzDQo+IGFjY3VyYWN5LCBidXQgaXQnbGwgbmV2ZXIgYmUgMTAwJS4NCj4gDQo+IFRo
ZSBOTiBjbGFpbXMgd2UncmUgYXQgfjk1JSB3aXRoIHJlZ2FyZHMgdG8gcGFzdCByZXN1bHRzLg0K
PiANCg0KSSBkaWRuJ3QgcmVhbGx5IG1lYW4gZm9yIHlvdSB0byBmaXggaXQuLg0KDQpJIGFtIGp1
c3QgYWdhaW5zdCB1c2luZyB1bi1hdWRpdGVkIEFJLiBiZWNhdXNlIGkga25vdyBpdCBjYW4gbmV2
ZXINCnJlYWNoIDEwMCUuDQoNCkp1c3Qgb3V0IG9mIGN1cmlvc2l0eSA6IA0Kd2hhdCBhcmUgdGhl
c2UgNSUgZmFpbHVyZSByYXRlLCB3aGF0IHR5cGVzIG9mIGZhaWx1cmVzID8gaG93IGFyZSB0aGV5
DQppZGVudGlmaWVkIGFuZCBob3cgYXJlIHRoZXkgZmVlZGJhY2sgaW50byB0aGUgTk4gcmUtdHJh
aW5pbmcgPw0KDQo=
