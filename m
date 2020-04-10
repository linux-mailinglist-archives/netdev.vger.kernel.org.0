Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1949C1A4BB6
	for <lists+netdev@lfdr.de>; Sat, 11 Apr 2020 00:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbgDJWCh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 18:02:37 -0400
Received: from mail-eopbgr130055.outbound.protection.outlook.com ([40.107.13.55]:44835
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726594AbgDJWCg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Apr 2020 18:02:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YmGK0qWTsAdvYqqCfWCNiCEeLOsTgjRBi44vjbnAVbEnxCFPVFTtI40aVjSvf8E1RQjFbOQBYHT10/2pc/UqcovKX6syYey1cduELeTSmr1vHN+BTVZHV1wTPUr1P5BB/PFYlMCw7W0AR3lw0qyNsxy8HRbU1G/lEeEbDFAwNoIL7vwYhcc2fHwsdK+N/LskMsaHS3tNvk/B1Vv5nXklSpOWsFClOjIPqbfZZQQdYJptLJ4JZeQmhYS6mizwDC1mVUloCnCoaWnBScXjlqAuYmw623AmwpEhDFNCmpVMKtrLABffqYVtdgqKNpnXGyv29ASBGSY7N0/1JiNngZwZPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VQvOtFyh9t3pNwEwVmYmOvHUaikLpQ7butJtTSS6ktI=;
 b=QimEsvTvqs0Bq/cRHWG2Ajyoi9qOwP2ue4zupz5TUoiwHYNVhkFAzaeWWyJ0Jgk46uIy8vL/WP6psXFHNK972N0z6tKY1lmhRFLQqzuyJAjD01LqXYNocu2ZTdCV30N7/m3hgASn0UsDOdVTMyj258hOI22/uHj3uTiS4xb8+go/+kTXgvSJF0oxFFBqUaeOTwhGnuDRb/kPKuE4KT/zwNrV+4e2mgTEecVNWrpiSECZkBj7Juv5FsHgYMFtH8V+0bqUTGsXySZRCV2PiIJg9Dv1hEnDe3/f44VWg/ymLpXAlBWWzZgrnzxr8RCWRM016xVlP9r8Uffhi40Hwu2WQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VQvOtFyh9t3pNwEwVmYmOvHUaikLpQ7butJtTSS6ktI=;
 b=U/N0WisWERqzYfP9E7elCg7sQ1hUfYaxpHZJx33noLSLhZK2MHOvOp0ewNI1jaZIHhtwfEwMYfaxpR4Nmt//ofYM1N9pToYh1Qv5EM+k4M//fZLdTBbUcaNZgD/nBM49AUes1NQkWo2RgpyPCKa6tw0qeC2pBiXg2f26P3VcFv0=
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com (2603:10a6:20b:9::29)
 by AM6PR05MB5409.eurprd05.prod.outlook.com (2603:10a6:20b:37::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.20; Fri, 10 Apr
 2020 21:59:57 +0000
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::dc17:894c:778d:fd1]) by AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::dc17:894c:778d:fd1%7]) with mapi id 15.20.2900.015; Fri, 10 Apr 2020
 21:59:56 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "jacob.e.keller@intel.com" <jacob.e.keller@intel.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tal Gilboa <talgi@mellanox.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>
Subject: Re: [PATCH net v2 1/2] docs: networking: convert DIM to RST
Thread-Topic: [PATCH net v2 1/2] docs: networking: convert DIM to RST
Thread-Index: AQHWDrTu2RZCFwSAxECQoixyMh5xtKhxZAeAgAAFsgCAAX+XgA==
Date:   Fri, 10 Apr 2020 21:59:56 +0000
Message-ID: <4569455bbdd44f08e31d2206031f8fcc39702c9f.camel@mellanox.com>
References: <20200409212159.322775-1-kuba@kernel.org>
         <1210a28bfe1a67818f3f814e38f52923cbd201c0.camel@mellanox.com>
         <20200409160658.1b940fcf@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200409160658.1b940fcf@kicinski-fedora-PC1C0HJN>
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
x-ms-office365-filtering-correlation-id: 260d21ae-06a7-4d41-83c4-08d7dd9a81d4
x-ms-traffictypediagnostic: AM6PR05MB5409:|AM6PR05MB5409:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR05MB540987238B0C303C942124E0BEDE0@AM6PR05MB5409.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0369E8196C
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB5094.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(376002)(136003)(366004)(39860400002)(346002)(396003)(36756003)(2906002)(316002)(5660300002)(54906003)(6486002)(4326008)(966005)(8676002)(71200400001)(76116006)(91956017)(6916009)(66946007)(66556008)(26005)(6506007)(8936002)(81156014)(478600001)(186003)(86362001)(66446008)(64756008)(6512007)(66476007)(2616005)(6606295002);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nDyY9fvCgs/P8BZwW8SQqG2md0igaabCMfZmxpEeRq8h2TmPPuUNFpNhMqjunu5CBQx3cUq/VrTyL36MxALWcd0h2oJD/Xo2uAlTnCdgBOH8QDpcVvWiRLfkJJa8NAbF9P4fGXiWbWftsQHWJukvZayzY3qlhqG2jb60f9sgwf/+xwcNsR+BPTEMnsYgCMy4ydCsMHWkzF2wPVIQFXaoGjAVHXkU+7uXri3rQziFtpM4fB/pe+wDYmoS/PwdgSapdF8B9cGE2h8CPAbl4rKG0BmY4g43aFFfZ2xtMgRMggyoMJHs9bMGc+IaL/AnxL8nQcFVvwLh8Iumo5uR39rsyCblBdVXPjjDozDIgkDxb9m6QQbzPMPyi4RFlz2N3pQy+0EoEcAEi79FOd6XQeiD5Bp1pMhiWrFYAmTSpgLiQ9Nbhyeav9fMc8OEq3jkZUMDtP12FWD9JK2zduUsuRsA6gyChVppkiVGJzcY95Ax0dx2BoI1Eh1dgWZIZAp25ts+lMPtXTGxn5z/1EkarMCvkFVAfV+BYDE5jEbskC5Oop5BPdrJ6a2DenOdazWNfSAZ
x-ms-exchange-antispam-messagedata: glWR/IEafYd18jIbiRr7xsteot3lCDPa4zKKIqHbHahKJoWVE95HY9DlaRTKUe35/y++/mex43ewKNriUIslzaADiQSWZu9UvrEoILFzU9ygqN5rTjCdxbo9/eHiEDbQr2TzOwP+DSOzCiSdSkdZbg==
Content-Type: text/plain; charset="utf-8"
Content-ID: <AE54754A3A95FD41ABD60E25C7F1A504@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 260d21ae-06a7-4d41-83c4-08d7dd9a81d4
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Apr 2020 21:59:56.7855
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vso1S+m9Z87lEr3+Avma2FzhnYd0KDHFtUziy8Oyj9RDNN4QLMkqvrGGZeHccGUQAw+GdDYEyjWtrMYM/neltQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5409
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIwLTA0LTA5IGF0IDE2OjA2IC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gVGh1LCA5IEFwciAyMDIwIDIyOjQ2OjU1ICswMDAwIFNhZWVkIE1haGFtZWVkIHdyb3Rl
Og0KPiA+IE9uIFRodSwgMjAyMC0wNC0wOSBhdCAxNDoyMSAtMDcwMCwgSmFrdWIgS2ljaW5za2kg
d3JvdGU6DQo+ID4gPiBDb252ZXJ0IHRoZSBEeW5hbWljIEludGVycnVwdCBNb2RlcmF0aW9uIGRv
YyB0byBSU1QgYW5kDQo+ID4gPiB1c2UgdGhlIFJTVCBmZWF0dXJlcyBsaWtlIHN5bnRheCBoaWdo
bGlnaHQsIGZ1bmN0aW9uIGFuZA0KPiA+ID4gc3RydWN0dXJlIGRvY3VtZW50YXRpb24sIGVudW1l
cmF0aW9ucywgdGFibGUgb2YgY29udGVudHMuDQo+ID4gPiANCj4gPiA+IFNpZ25lZC1vZmYtYnk6
IEpha3ViIEtpY2luc2tpIDxrdWJhQGtlcm5lbC5vcmc+DQo+ID4gPiBSZXZpZXdlZC1ieTogUmFu
ZHkgRHVubGFwIDxyZHVubGFwQGluZnJhZGVhZC5vcmc+DQo+ID4gPiAtLS0NCj4gPiA+IHYyOg0K
PiA+ID4gIC0gcmVtb3ZlIHRoZSBmdW5jdGlvbnMvdHlwZSBkZWZpbml0aW9uIG1hcmt1cA0KPiA+
ID4gIC0gY2hhbmdlIHRoZSBjb250ZW50cyBkZWZpbml0aW9uICh0aGUgOmxvY2FsOiBzZWVtIHRv
DQo+ID4gPiAgICBub3Qgd29yayB0b28gd2VsbCB3aXRoIGtkb2MpDQo+ID4gPiAtLS0NCj4gPiA+
ICBEb2N1bWVudGF0aW9uL25ldHdvcmtpbmcvaW5kZXgucnN0ICAgICAgICAgICAgfCAgMSArDQo+
ID4gPiAgLi4uL25ldHdvcmtpbmcve25ldF9kaW0udHh0ID0+IG5ldF9kaW0ucnN0fSAgIHwgOTAg
KysrKysrKysrLS0NCj4gPiA+IC0tLS0NCj4gPiA+IC0tLS0NCj4gPiA+ICBNQUlOVEFJTkVSUyAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgMSArDQo+ID4gPiAgMyBmaWxlcyBj
aGFuZ2VkLCA0NSBpbnNlcnRpb25zKCspLCA0NyBkZWxldGlvbnMoLSkNCj4gPiA+ICByZW5hbWUg
RG9jdW1lbnRhdGlvbi9uZXR3b3JraW5nL3tuZXRfZGltLnR4dCA9PiBuZXRfZGltLnJzdH0NCj4g
PiA+ICg3OSUpDQo+ID4gPiANCj4gPiA+IGRpZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9uL25ldHdv
cmtpbmcvaW5kZXgucnN0DQo+ID4gPiBiL0RvY3VtZW50YXRpb24vbmV0d29ya2luZy9pbmRleC5y
c3QNCj4gPiA+IGluZGV4IDUwMTMzZDk3NjFjOS4uNjUzOGVkZTI5NjYxIDEwMDY0NA0KPiA+ID4g
LS0tIGEvRG9jdW1lbnRhdGlvbi9uZXR3b3JraW5nL2luZGV4LnJzdA0KPiA+ID4gKysrIGIvRG9j
dW1lbnRhdGlvbi9uZXR3b3JraW5nL2luZGV4LnJzdA0KPiA+ID4gQEAgLTIyLDYgKzIyLDcgQEAg
TGludXggTmV0d29ya2luZyBEb2N1bWVudGF0aW9uDQo+ID4gPiAgICAgejg1MzBib29rDQo+ID4g
PiAgICAgbXNnX3plcm9jb3B5DQo+ID4gPiAgICAgZmFpbG92ZXINCj4gPiA+ICsgICBuZXRfZGlt
ICANCj4gPiANCj4gPiBuZXRfZGltIGlzIGEgcGVyZm9ybWFuY2UgZmVhdHVyZSwgaSB3b3VsZCBt
b3ZlIGZ1cnRoZXIgZG93biB0aGUNCj4gPiBsaXN0DQo+ID4gd2hlcmUgdGhlIHBlcmYgZmVhdHVy
ZXMgc3VjaCBhcyBzY2FsaW5nIGFuZCBvZmZsb2FkcyBhcmUgLi4gDQo+IA0KPiBJIG1lYW4uLiBz
byBpcyBtc2dfemVyb2NvcHkganVzdCBhYm92ZSA7LSkgIEkgc3BvdHRlZCBzbGlnaHQNCj4gYWxw
aGFiZXRpY2FsIG9yZGVyaW5nIHRoZXJlLCB3aGljaCBtYXkgaGF2ZSBub3QgYmVlbiBpbnRlbnRp
b25hbCwNCj4gdGhhdCdzIHdoeSBJIHB1dCBpdCBoZXJlLiBNYXJraW5nIHdpdGggIyB0aGluZ3Mg
b3V0IG9mIG9yZGVyLCBidXQgDQo+IGJhc2VkIG9uIGp1c3QgdGhlIGZpcnN0IGxldHRlcjoNCj4g
DQoNCk9oIGkgZGlkbid0IHNlZSB0aGUgYWxwaGFiZXRpY2FsIG9yZGVyIDopLCB0aGVuIGkgZ3Vl
c3MgeW91ciBwYXRjaCBpcw0Kb2suDQoNCj4gIyAgbmV0ZGV2LUZBUQ0KPiAgICBhZl94ZHANCj4g
ICAgYmFyZXVkcA0KPiAgICBiYXRtYW4tYWR2DQo+ICAgIGNhbg0KPiAgICBjYW5fdWNhbl9wcm90
b2NvbA0KPiAgICBkZXZpY2VfZHJpdmVycy9pbmRleA0KPiAgICBkc2EvaW5kZXgNCj4gICAgZGV2
bGluay9pbmRleA0KPiAgICBldGh0b29sLW5ldGxpbmsNCj4gICAgaWVlZTgwMjE1NA0KPiAgICBq
MTkzOQ0KPiAgICBrYXBpDQo+ICMgIHo4NTMwYm9vaw0KPiAgICBtc2dfemVyb2NvcHkNCj4gIyAg
ZmFpbG92ZXINCj4gICAgbmV0X2RpbQ0KPiAgICBuZXRfZmFpbG92ZXINCj4gICAgcGh5DQo+ICAg
IHNmcC1waHlsaW5rDQo+ICMgIGFsaWFzDQo+ICMgIGJyaWRnZQ0KPiAgICBzbm1wX2NvdW50ZXIN
Cj4gIyAgY2hlY2tzdW0tb2ZmbG9hZHMNCj4gICAgc2VnbWVudGF0aW9uLW9mZmxvYWRzDQo+ICAg
IHNjYWxpbmcNCj4gICAgdGxzDQo+ICAgIHRscy1vZmZsb2FkDQo+ICMgIG5mYw0KPiAgICA2bG93
cGFuDQo+IA0KPiBNeSBmZWVsaW5nIGlzIHRoYXQgd2Ugc2hvdWxkIHN0YXJ0IGNvbnNpZGVyaW5n
IHNwbGl0dGluZyBrZXJuZWwtb25seQ0KPiBkb2NzIGFuZCBhZG1pbi1vbmx5IGRvY3MgZm9yIG5l
dHdvcmtpbmcsIHdoaWNoIEkgYmVsaWV2ZSBpcyB0aGUNCj4gZGlyZWN0aW9uIEpvbiBhbmQgZm9s
a3Mgd2FudCBEb2N1bWVudGF0aW9uLyB0byBnby4gQnV0IEkgd2Fzbid0IGJyYXZlDQo+IGVub3Vn
aCB0byBiZSB0aGUgZmlyc3Qgb25lLiBUaGVuIHdlIGNhbiBpbXBvc2Ugc29tZSBtb3JlIHN0cnVj
dHVyZSwNCj4gbGlrZSBwdXR0aW5nIGFsbCAicGVyZm9ybWFuY2UiIGRvY3MgaW4gb25lIHN1YmRp
ci4uPw0KPiANCj4gV0RZVD8NCg0KVGhhdCB3YXMgbXkgaW5pdGlhbCB0aG91Z2h0LCBidXQgaXQg
c2VlbWVkIGxpa2UgYSBsb3Qgb2Ygd29yayBhbmQNCnJlYWxseSBub3QgcmVsYXRlZCB0byB5b3Vy
IHBhdGNoLg0KDQpCdXQgeWVzLCBjYXRlZ29yaXppbmcgaXMgdGhlIHdheSB0byBnby4uIGFscGhh
YmV0aWNhbCBvcmRlciBkb2Vzbid0DQpyZWFsbHkgbWFrZSBhbnkgc2Vuc2UgdW5sZXNzIHlvdSBr
bm93IGV4YWN0bHkgd2hhdCB5b3UgYXJlIGxvb2tpbmcgZm9yLA0Kd2hpY2ggaXMgbmV2ZXIgdGhl
IGNhc2UgOiksDQpGb3Igc29tZW9uZSB3aG8gd2FudCB0byBsZWFybiBhYm91dCBwZXJmb3JtYW5j
ZSB0dW5pbmcgb3Igc29tZXRoaW5nDQpzcGVjaWZpYyBsaWtlIGNvYWxlc2NpbmcsIHdoYXQgc2hv
dWxkIHRoZXkgbG9vayBmb3IgPyBESU0sIE5FVCBESU0sDQptb2RlcmF0aW9uIG9yIGNvYWxlc2Np
bmcgPyBzbyBpZiB3ZSBjYXRlZ29yaXplIGFuZCBrZWVwIHRoZSBzdWJkaXJzDQpsaXN0cyBzaG9y
dCBhbmQgZm9jdXNlZCwgaXQgd2lsbCBiZSB2ZXJ5IGVhc3kgZm9yIHBlb3BsZSB0byBicm93c2Ug
dGhlDQpuZXR3b3JraW5nIGRvY3MuLg0KDQpUaGluZ3MgY2FuIGdyb3cgbGFyZ2UgdmVyeSBmYXN0
IGJleW9uZCBvdXIgY29udHJvbC4uIFdlIHNob3VsZCByZWFsbHkNCmVtYnJhY2UgdGhlICJNYWdp
YyBudW1iZXIgNyIgYXBwcm9hY2ggWzFdIDopDQoNCkhlbHBzIGtlZXAgdGhpbmdzIHNob3J0LCBv
cmdhbml6ZWQgYW5kIGZvY3VzZWQuDQoNClsxXSANCmh0dHBzOi8vd3d3LmktcHJvZ3JhbW1lci5p
bmZvL2JhYmJhZ2VzLWJhZy82MjEtdGhlLW1hZ2ljLW51bWJlci1zZXZlbi5odG1sDQoNClRoYW5r
cywNClNhZWVkLg0KDQo=
