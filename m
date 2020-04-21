Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3872E1B1D60
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 06:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbgDUEYT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 00:24:19 -0400
Received: from mail-eopbgr70078.outbound.protection.outlook.com ([40.107.7.78]:6236
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725904AbgDUEYT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 00:24:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mOnXtCrvP9iPsgEzmm7PeoCitUSACvMKk+AOWdHhudRnDgl1d4tLekM70WRXaD025sZILL6HCXaDR66YVHSub6L+Isqp8RSNrLVL5RJSAT2f4S2uq19I78TUcVVkuDulJh4oJUmJ68v2aqktTJ31r5iis6Utqg1I0iUWWO8acaKEwCIQ0y/mcqMDwOjaqZdxaRCjEdCvbLwLVutInCOUf90mwECFLRQfCajLCfKXT1ttEGSY5Q2A4eKf+nTg2KNoOy1f9onPSvb1ouyBvU4JgPgTDWJ2qnfa7SfNUEd9XJMTW360GWR2y68LHtbpqdD7CSvGbx60I5dg/tfy5uyZjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aYFkmj6RzkiSUylBoP6WGnFjI7pLai8QRajtfwhTIXo=;
 b=WqI+8o9jg1dRy2EnLfoVUsnI0ReOtJf9D6wPOcSxWW1OGx6LJjFtDtDcjr1l7rARuilyHC3UH6g5wQD/dvqSjjPkudh5fjrzbVRBOejgI80wL44CofXyN5vPd0uRPsJEcZKcpTYZQQaNaQHU1XXvJHgj/SQI1GgB4kslRJV6h9qx9m14R4njONL6H3RrpfAlmLptevcbxDVx1eZAfSqK2rKT+G8ZC2/sYWPbeN0rni7V8B8ew/GXq5omlLOtmlfXVk4M84OKM0DaGOv6tYS26GZ4D77Nqg5W7TQJ/fBCG70Wi7Y0hzFQjb8UK+Vzwm4W1qbA5NS97SLwJiRNIn2A6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aYFkmj6RzkiSUylBoP6WGnFjI7pLai8QRajtfwhTIXo=;
 b=Va3SkuISmamMQ14nk6qzy/tpOtVyli88Sf9jHqBdDVQ6dIQ3N422kyFQI1qsdZOLiurwAAjv1lWa3YKbi9JhsvsMrdsgTUG+0XyCePggDo4oZThAXHU2TGj7BEsUGBvmKe0m72ow8yfKf2tj1gp+Ya9CQwyjrci50Q3T6fDRRrA=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6736.eurprd05.prod.outlook.com (2603:10a6:800:13f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Tue, 21 Apr
 2020 04:24:12 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2921.030; Tue, 21 Apr 2020
 04:24:11 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "masahiroy@kernel.org" <masahiroy@kernel.org>,
        "jani.nikula@linux.intel.com" <jani.nikula@linux.intel.com>,
        "nico@fluxnic.net" <nico@fluxnic.net>
CC:     "Laurent.pinchart@ideasonboard.com" 
        <Laurent.pinchart@ideasonboard.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "jernej.skrabec@siol.net" <jernej.skrabec@siol.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jonas@kwiboo.se" <jonas@kwiboo.se>,
        "narmstrong@baylibre.com" <narmstrong@baylibre.com>,
        "kieran.bingham+renesas@ideasonboard.com" 
        <kieran.bingham+renesas@ideasonboard.com>,
        "leon@kernel.org" <leon@kernel.org>
Subject: Re: [RFC PATCH 1/2] Kconfig: Introduce "uses" keyword
Thread-Topic: [RFC PATCH 1/2] Kconfig: Introduce "uses" keyword
Thread-Index: AQHWFFU+GtgmZSAXzkWfdBAfhtrsbqh/PqeAgAAC8YCAAA/HgIACZWqAgAFJ8gA=
Date:   Tue, 21 Apr 2020 04:24:10 +0000
Message-ID: <45b9efec57b2e250e8e39b3b203eb8cee10cb6e8.camel@mellanox.com>
References: <20200417011146.83973-1-saeedm@mellanox.com>
         <CAK7LNAQZd_LUyA2V_pCvMTr_201nSX1Nm0TDw5kOeNV64rOfpA@mail.gmail.com>
         <nycvar.YSQ.7.76.2004181509030.2671@knanqh.ubzr>
         <CAK7LNATmPD1R+Ranis2u3yohx8b0+dGKAvFpjg8Eo9yEHRT6zQ@mail.gmail.com>
         <87v9lu1ra6.fsf@intel.com>
In-Reply-To: <87v9lu1ra6.fsf@intel.com>
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
x-ms-office365-filtering-correlation-id: 9394e42d-8047-456e-4e65-08d7e5abd7c5
x-ms-traffictypediagnostic: VI1PR05MB6736:
x-microsoft-antispam-prvs: <VI1PR05MB6736DD8C8DED96CD32B4649DBED50@VI1PR05MB6736.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 038002787A
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(366004)(346002)(396003)(136003)(376002)(81156014)(2616005)(6486002)(26005)(91956017)(76116006)(66946007)(66446008)(6512007)(4326008)(186003)(66476007)(66556008)(64756008)(478600001)(36756003)(8936002)(86362001)(110136005)(54906003)(8676002)(7416002)(316002)(6506007)(2906002)(53546011)(5660300002)(71200400001);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jZ6Vmxh8rXQ9YJdu7YAN1rNFyPcCVzO8+xEcsNU5M0XRm4kyBpNfNFO+nKNzWb5SZ19bTevhneGSoJmeliDcsEbdyeeROdlqE4SMmet5ezCG9TeM5lpG39+BRdbTUIkJ1QeEWa3hjNoxzs9FA9wkT17KkfPO7a+stDT3T6Kak9t5JAPLhqr1ua/1OkS7P5GdpLV0i5MeUap2I8GXbIthE28KHWDprBvW7j1YxsnT39atbW7l/6KJJTRrpMKiQPcaHIrC3xVKcsAOkXNWnMbsiC3nVKM+1/YT6iX3Xvrxv9vArjyDVnvYFImlipntB7xHLq6BhXfdOV0RcxSPW3YOBZahTaSocfHbWqqGeEdzywidhr4ai9xEJ1Iub6l24myH7lh0qWnV9635W1aKqHnnkDIS+dEF/o8IOKvE4Z8j3mHVo+uJBcwbX5UFXzeT6xrW
x-ms-exchange-antispam-messagedata: OnZwQUBRvngOL50kFO9ueCTTsPjCftBK9r6ccUe2MbhoeSh+VddYGBdXHt93YlzIseTCrP6qY2bM7aNOXxZg5ack182WZMbsaC4gSmBM5XmDaH2QykMcVCMAeUpfEcEVZ8+PJ1t5jdJsB632Fgj73g==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <40FF8F174C3A9548A2417F06D6A6E851@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9394e42d-8047-456e-4e65-08d7e5abd7c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2020 04:24:11.5796
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c3wvqVBbXYBPgFWeAGTJhsqJWemhCU+5VbFATlZO+ugAg8cAZdDQF31s6Ywjr+Ytk5nhvsClBFJQMyAYQG18GQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6736
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIwLTA0LTIwIGF0IDExOjQzICswMzAwLCBKYW5pIE5pa3VsYSB3cm90ZToNCj4g
T24gU3VuLCAxOSBBcHIgMjAyMCwgTWFzYWhpcm8gWWFtYWRhIDxtYXNhaGlyb3lAa2VybmVsLm9y
Zz4gd3JvdGU6DQo+ID4gT24gU3VuLCBBcHIgMTksIDIwMjAgYXQgNDoxMSBBTSBOaWNvbGFzIFBp
dHJlIDxuaWNvQGZsdXhuaWMubmV0Pg0KPiA+IHdyb3RlOg0KPiA+ID4gT24gU3VuLCAxOSBBcHIg
MjAyMCwgTWFzYWhpcm8gWWFtYWRhIHdyb3RlOg0KPiA+ID4gDQo+ID4gPiA+IChGT08gfHwgIUZP
TykgaXMgZGlmZmljdWx0IHRvIHVuZGVyc3RhbmQsIGJ1dA0KPiA+ID4gPiB0aGUgYmVoYXZpb3Ig
b2YgInVzZXMgRk9PIiBpcyBhcyBkaWZmaWN1bHQgdG8gZ3Jhc3AuDQo+ID4gPiANCj4gPiA+IENh
bid0IHRoaXMgYmUgZXhwcmVzc2VkIGFzIHRoZSBmb2xsb3dpbmcgaW5zdGVhZDoNCj4gPiA+IA0K
PiA+ID4gICAgICAgICBkZXBlbmRzIG9uIEZPTyBpZiBGT08NCj4gPiA+IA0KPiA+ID4gVGhhdCB3
b3VsZCBiZSBhIGxpdHRsZSBjbGVhcmVyLg0KPiA+ID4gDQo+ID4gPiANCj4gPiA+IE5pY29sYXMN
Cj4gPiANCj4gPiANCj4gPiAnZGVwZW5kcyBvbicgZG9lcyBub3QgdGFrZSB0aGUgJ2lmIDxleHBy
PicNCj4gPiANCj4gPiAnZGVwZW5kcyBvbiBBIGlmIEInIGlzIHRoZSBzeW50YXggc3VnYXIgb2YN
Cj4gPiAnZGVwZW5kcyBvbiAoQSB8fCAhQiksIHJpZ2h0ID8NCj4gPiANCj4gPiBJIGRvIG5vdCBr
bm93IGhvdyBjbGVhcmVyIGl0IHdvdWxkIG1ha2UgdGhpbmdzLg0KPiA+IA0KPiA+IGRlcGVuZHMg
b24gKG0gfHwgRk9PICE9IG0pDQo+ID4gaXMgYW5vdGhlciBlcXVpdmFsZW50LCBidXQgd2UgYXJl
IGFsd2F5cw0KPiA+IHRhbGtpbmcgYWJvdXQgYSBtYXR0ZXIgb2YgZXhwcmVzc2lvbi4NCj4gPiAN
Cj4gPiANCj4gPiBIb3cgaW1wb3J0YW50IGlzIGl0IHRvIHN0aWNrIHRvDQo+ID4gZGVwZW5kcyBv
biAoRk9PIHx8ICFGT08pDQo+ID4gb3IgaXRzIGVxdWl2YWxlbnRzPw0KPiA+IA0KPiA+IA0KPiA+
IElmIGEgZHJpdmVyIHdhbnRzIHRvIHVzZSB0aGUgZmVhdHVyZSBGT08NCj4gPiBpbiBtb3N0IHVz
ZWNhc2VzLCAnZGVwZW5kcyBvbiBGT08nIGlzIHNlbnNpYmxlLg0KPiA+IA0KPiA+IElmIEZPTyBp
cyBqdXN0IG9wdGlvbmFsLCB5b3UgY2FuIGdldCByaWQgb2YgdGhlIGRlcGVuZGVuY3ksDQo+ID4g
YW5kIElTX1JFQUNIQUJMRSgpIHdpbGwgZG8gbG9naWNhbGx5IGNvcnJlY3QgdGhpbmdzLg0KPiAN
Cj4gSWYgYnkgbG9naWNhbGx5IGNvcnJlY3QgeW91IG1lYW4gdGhlIGtlcm5lbCBidWlsZHMsIHlv
dSdyZQ0KPiByaWdodC4gSG93ZXZlciB0aGUgcHJvbGlmZXJhdGlvbiBvZiBJU19SRUFDSEFCTEUo
KSBpcyBtYWtpbmcgdGhlDQo+IGtlcm5lbA0KPiBjb25maWcgKmhhcmRlciogdG8gdW5kZXJzdGFu
ZC4gVXNlciBlbmFibGVzIEZPTz1tIGFuZCBleHBlY3RzIEJBUiB0bw0KPiB1c2UNCj4gaXQsIGhv
d2V2ZXIgaWYgQkFSPXkgaXQgc2lsZW50bHkgZ2V0cyBpZ25vcmVkLiBJIGhhdmUgYW5kIEkgd2ls
bA0KPiBvcHBvc2UNCj4gYWRkaW5nIElTX1JFQUNIQUJMRSgpIHVzYWdlIHRvIGk5MTUgYmVjYXVz
ZSBpdCdzIGp1c3Qgc2lsZW50bHkNCj4gYWNjZXB0aW5nDQo+IGNvbmZpZ3VyYXRpb25zIHRoYXQg
c2hvdWxkIGJlIGZsYWdnZWQgYW5kIGZvcmJpZGRlbiBhdCBrY29uZmlnIHN0YWdlLg0KPiANCj4g
PiBJIGRvIG5vdCB0aGluayBJU19SRUFDSEFCTEUoKSBpcyB0b28gYmFkLA0KPiA+IGJ1dCBpZiBp
dCBpcyBjb25mdXNpbmcsIHdlIGNhbiBhZGQgb25lIG1vcmUNCj4gPiBvcHRpb24gdG8gbWFrZSBp
dCBleHBsaWNpdC4NCj4gPiANCj4gPiANCj4gPiANCj4gPiBjb25maWcgRFJJVkVSX1gNCj4gPiAg
ICAgICAgdHJpc3RhdGUgImRyaXZlciB4Ig0KPiA+IA0KPiA+IGNvbmZpZyBEUklWRVJfWF9VU0VT
X0ZPTw0KPiA+ICAgICAgICBib29sICJ1c2UgRk9PIGZyb20gZHJpdmVyIFgiDQo+ID4gICAgICAg
IGRlcGVuZHMgb24gRFJJVkVSX1gNCj4gPiAgICAgICAgZGVwZW5kcyBvbiBEUklWRVJfWCA8PSBG
T08NCj4gPiAgICAgICAgaGVscA0KPiA+ICAgICAgICAgIERSSVZFUl9YIHdvcmtzIHdpdGhvdXQg
Rk9PLCBidXQNCj4gPiAgICAgICAgICBVc2luZyBGT08gd2lsbCBwcm92aWRlIGJldHRlciB1c2Fi
aWxpdHkuDQo+ID4gICAgICAgICAgU2F5IFkgaWYgeW91IHdhbnQgdG8gbWFrZSBkcml2ZXIgWCB1
c2UgRk9PLg0KPiA+IA0KPiA+IA0KPiA+IA0KPiA+IE9mIGNvdXJzZSwNCj4gPiANCj4gPiAgICAg
ICBpZiAoSVNfRU5BQkxFRChDT05GSUdfRFJJVkVSX1hfVVNFU19GT08pKQ0KPiA+ICAgICAgICAg
ICAgICAgIGZvb19pbml0KCk7DQo+ID4gDQo+ID4gd29ya3MgbGlrZQ0KPiA+IA0KPiA+ICAgICAg
IGlmIChJU19SRUFDSEFCTEUoQ09ORklHX0ZPTykpDQo+ID4gICAgICAgICAgICAgICAgIGZvb19p
bml0KCk7DQo+ID4gDQo+ID4gDQo+ID4gQXQgbGVhc2UsIGl0IHdpbGwgZWxpbWluYXRlIGEgcXVl
c3Rpb24gbGlrZQ0KPiA+ICJJIGxvYWRlZCB0aGUgbW9kdWxlIEZPTywgSSBzd2Vhci4NCj4gPiBC
dXQgbXkgYnVpbHQtaW4gZHJpdmVyIFggc3RpbGwgd291bGQgbm90IHVzZSBGT08sIHdoeT8iDQo+
IA0KDQphbmQgZHVwbGljYXRlIHRoaXMgYWxsIG92ZXIganVzdCB0byBhdm9pZCBuZXcga2V5d29y
ZC4NCg0KDQo+IFBsZWFzZSBsZXQncyBub3QgbWFrZSB0aGF0IGEgbW9yZSB3aWRlc3ByZWFkIHBy
b2JsZW0gdGhhbiBpdCBhbHJlYWR5DQo+IGlzLiBJIGhhdmUgeWV0IHRvIGhlYXIgKm9uZSogZ29v
ZCByYXRpb25hbGUgZm9yIGFsbG93aW5nIHRoYXQgaW4gdGhlDQo+IGZpcnN0IHBsYWNlLiBBbmQg
aWYgdGhhdCBwb3BzIHVwLCB5b3UgY2FuIG1ha2UgaXQgd29yayBieSB1c2luZw0KPiBJU19SRUFD
SEFCTEUoKSAqd2l0aG91dCogdGhlIGRlcGVuZHMsIHNpbXBseSBieSBjaGVja2luZyBpZiB0aGUN
Cj4gbW9kdWxlDQo+IGlzIHRoZXJlLg0KPiANCj4gTW9zdCB1c2UgY2FzZXMgaW5jcmVhc2luZ2x5
IHNvbHZlZCBieSBJU19SRUFDSEFCTEUoKSBzaG91bGQgdXNlIHRoZQ0KPiAiZGVwZW5kcyBvbiBG
T08gfHwgRk9PPW4iIGNvbnN0cnVjdCwgYnV0IHRoZSBwcm9ibGVtIGlzIHRoYXQncyBub3QNCj4g
d2lkZWx5IHVuZGVyc3Rvb2QuIEknZCBsaWtlIHRvIGhhdmUgYW5vdGhlciBrZXl3b3JkIGZvciBw
ZW9wbGUgdG8NCj4gY29weS1wYXN0ZSBpbnRvIHRoZWlyIEtjb25maWdzLg0KPiANCg0KKzEgDQoN
CmRvIGFsbCBDIGRldmVsb3BlcnMga25vdyBob3cgdGhlIEMgY29tcGlsZXIgd29ya3MgPyBvZiBj
b3Vyc2Ugbm90ICENClNhbWUgZ29lcyBoZXJlLCB0aGVyZSBpcyBhIGRlbWFuZCBmb3IgYSBuZXcg
a2V5d29yZCwgc28gcGVvcGxlIHdpbGwNCmF2b2lkIGNvcHkgYW5kIHBhdGUgYW5kIGNhbiB1c2Ug
dGhlIGtjb25maWcgbGFuZ3VhZ2UgaW4gYSBoaWdoZXINCnNpbXBsaWZpZWQgbGV2ZWwuDQoNCkkg
anVzdCBkaWQgYSBxdWljayBncmVwIHRvIGZpbmQgb3V0IGhvdyByZWFsbHkgcGVvcGxlIHVzZSBk
ZXBlbmQgb246DQoNCiMgQWxsIHVzYWdlIG9mIGRlcGVuZHMgb24gDQokIGdpdCBscy1maWxlcyB8
IGdyZXAgS2NvbmZpZyB8IHhhcmdzIGdyZXAgLUUgImRlcGVuZHNccytvbiIgfCB3YyAtbA0KMTUw
NzENCg0KIyBzaW1wbGUgc2luZ2xlIHN5bWJvbCBleHByZXNzaW9uIHVzYWdlIA0KJCBnaXQgbHMt
ZmlsZXMgfCBncmVwIEtjb25maWcgfCB4YXJncyBncmVwIC1FICJkZXBlbmRzXHMrb25ccytbQS1a
YS16MC0NCjlfXStccyokIiB8IHdjIC1sDQo4ODg5DQoNCmFsbW9zdCA2MCUuLiANCg0KcGVvcGxl
IHJlYWxseSBsaWtlIHNpbXBsZSB0aGluZ3MgZXNwZWNpYWxseSBmb3IgdGhlIHRvb2xzIHRoZXkg
YXJlDQp1c2luZyAibGlrZSBrY29uZmlnIiwgbm8gb25lIHJlYWxseSB3YW50cyB0byB1bmRlcnN0
YW5kIGhvdyBpdCByZWFsbHkNCndvcmsgdW5kZXIgdGhlIGhvb2QgaWYgaXQgaXMgYSBvbmUgdGlt
ZSB0aGluZyB0aGF0IHlvdSBuZWVkIHRvIHNldHVwDQpmb3IgeW91ciBrZXJuZWwgcHJvamVjdCwg
dW5sZXNzIGl0IGlzIHJlYWxseSBuZWNlc3NhcnkgLi4NCg0KSSB3b25kZXIgaG93IG1hbnkgb2Yg
dGhvc2UgODg4OSBjYXNlcyB3YW50ZWQgYSB3ZWFrIGRlcGVuZGVuY3kgYnV0DQpjb3VsZG4ndCBm
aWd1cmUgb3V0IGhvdyB0byBkbyBpdCA/IA0KDQpVc2VycyBvZiBkZXBlbmRzIG9uIEZPTyB8fCAh
Rk9PDQoNCiQgZ2l0IGxzLWZpbGVzIHwgZ3JlcCBLY29uZmlnIHwgeGFyZ3MgZ3JlcCAtRSBcDQog
ICJkZXBlbmRzXHMrb25ccysoW0EtWmEtejAtOV9dKylccypcfFx8XHMqKFwhXHMqXDF8XDFccyo9
XHMqbikiIFwNCiB8IHdjIC1sDQoNCjE1Ng0KDQphIG5ldyBrZXl3b3JkIGlzIHJlcXVpcmVkIDop
IC4uIA0KDQoNCj4gSW4gYW5vdGhlciBtYWlsIEkgc3VnZ2VzdGVkDQo+IA0KPiAJb3B0aW9uYWxs
eSBkZXBlbmRzIG9uIEZPTw0KPiANCj4gbWlnaHQgYmUgYSBiZXR0ZXIgYWx0ZXJuYXRpdmUgdGhh
biAidXNlcyIuDQo+IA0KPiANCg0KaG93IGFib3V0IGp1c3Q6DQogICAgICBvcHRpb25hbCBGT08N
Cg0KSXQgaXMgY2xlYXIgYW5kIGVhc3kgdG8gZG9jdW1lbnQgLi4gDQoNCg0KPiBCUiwNCj4gSmFu
aS4NCj4gDQo=
