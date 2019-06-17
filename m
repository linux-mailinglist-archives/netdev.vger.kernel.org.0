Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2284748C91
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 20:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728918AbfFQSmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 14:42:16 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:9534 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbfFQSmP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 14:42:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1560796935; x=1592332935;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=WdrIn3el4HI8u0Tts7xTjVlebQ0t8O0LN3dUT0Vd4rA=;
  b=UBGWcZs/lq1bWYn8++PPmoa8CxResKa8LuhVfGKjvfWt+1zeT7CMgbZf
   auHCBwaI4qF5F8VUeGuDITJ1J7PXzHSInA2B+MF3YgqyqpMVfnMNKRxtQ
   5y2M0n5kGUXCa2+exF2N55QEV39lrbBoECJShSIz4URcyqKzl1xztf/Mu
   tut3cV23abzUYk7DdWb6F/1bPbghrUUbyWhfDCOAHTQz4UK+/raYDEghV
   cgaGCH2c5Z/NQRf4/guvE95kH9fPknBuUJwMw8nCF35AHcKMsmmWV1Xko
   3gcBvpDGA+Kwutigo55JQzDj0zAS5+eznNb95+5mdcd5MyiU0H+YHpTKR
   Q==;
X-IronPort-AV: E=Sophos;i="5.63,386,1557158400"; 
   d="scan'208";a="112433996"
Received: from mail-co1nam04lp2055.outbound.protection.outlook.com (HELO NAM04-CO1-obe.outbound.protection.outlook.com) ([104.47.45.55])
  by ob1.hgst.iphmx.com with ESMTP; 18 Jun 2019 02:42:13 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WdrIn3el4HI8u0Tts7xTjVlebQ0t8O0LN3dUT0Vd4rA=;
 b=X9jgjmbCswzAqMam5q4dU291RW2R7Az1jcIhfDA1Ahmp6kxh/TCqPCRBvicAciH3joVi1Zq38B5fuyg3t/XA74euU5DsaR1OT/4Uq3WRFGDfVpYIN/PelZUizwzTmdCRco9PioPMRpJppSsdbaTBru8edVIWiDN4ieRCNMQaxC4=
Received: from BYAPR04MB4901.namprd04.prod.outlook.com (52.135.232.206) by
 BYAPR04MB5046.namprd04.prod.outlook.com (52.135.235.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Mon, 17 Jun 2019 18:42:11 +0000
Received: from BYAPR04MB4901.namprd04.prod.outlook.com
 ([fe80::40b0:3c4b:b778:664d]) by BYAPR04MB4901.namprd04.prod.outlook.com
 ([fe80::40b0:3c4b:b778:664d%7]) with mapi id 15.20.1987.012; Mon, 17 Jun 2019
 18:42:11 +0000
From:   Alistair Francis <Alistair.Francis@wdc.com>
To:     "paul.walmsley@sifive.com" <paul.walmsley@sifive.com>,
        "troy.benjegerdes@sifive.com" <troy.benjegerdes@sifive.com>
CC:     "jamez@wit.com" <jamez@wit.com>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "schwab@suse.de" <schwab@suse.de>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
        "sachin.ghadi@sifive.com" <sachin.ghadi@sifive.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ynezz@true.cz" <ynezz@true.cz>,
        "palmer@sifive.com" <palmer@sifive.com>,
        "yash.shah@sifive.com" <yash.shah@sifive.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>
Subject: Re: [PATCH v2 0/2] Add macb support for SiFive FU540-C000
Thread-Topic: [PATCH v2 0/2] Add macb support for SiFive FU540-C000
Thread-Index: AQHVJMPxUGJ6CrWTfEOSlZ7T+RNJNKafgw4CgAAZzACAAAECfoAAAOIAgAAC1UKAABYjAIAALLGAgABKKYA=
Date:   Mon, 17 Jun 2019 18:42:11 +0000
Message-ID: <d2836a90b92f3522a398d57ab8555d08956a0d1f.camel@wdc.com>
References: <1560745167-9866-1-git-send-email-yash.shah@sifive.com>
         <mvmtvco62k9.fsf@suse.de>
         <alpine.DEB.2.21.9999.1906170252410.19994@viisi.sifive.com>
         <mvmpnnc5y49.fsf@suse.de>
         <alpine.DEB.2.21.9999.1906170305020.19994@viisi.sifive.com>
         <mvmh88o5xi5.fsf@suse.de>
         <alpine.DEB.2.21.9999.1906170419010.19994@viisi.sifive.com>
         <F48A4F7F-0B0D-4191-91AD-DC51686D1E78@sifive.com>
In-Reply-To: <F48A4F7F-0B0D-4191-91AD-DC51686D1E78@sifive.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Alistair.Francis@wdc.com; 
x-originating-ip: [199.255.44.250]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1eb723f1-7a9c-4416-b5e7-08d6f353828d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:BYAPR04MB5046;
x-ms-traffictypediagnostic: BYAPR04MB5046:
x-ms-exchange-purlcount: 3
wdcipoutbound: EOP-TRUE
x-microsoft-antispam-prvs: <BYAPR04MB50465A5BA8390459F0B765D390EB0@BYAPR04MB5046.namprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 0071BFA85B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6029001)(39860400002)(346002)(376002)(366004)(396003)(136003)(189003)(199004)(25786009)(486006)(86362001)(7416002)(966005)(478600001)(6306002)(53936002)(6512007)(7736002)(256004)(6116002)(14444005)(73956011)(72206003)(14454004)(229853002)(110136005)(54906003)(316002)(2906002)(66066001)(2501003)(3846002)(66446008)(4326008)(5660300002)(68736007)(71200400001)(446003)(11346002)(36756003)(81156014)(26005)(76116006)(2616005)(64756008)(99286004)(6486002)(53546011)(71190400001)(476003)(76176011)(6506007)(81166006)(102836004)(66946007)(66476007)(6246003)(66556008)(8936002)(6436002)(305945005)(8676002)(186003)(118296001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB5046;H:BYAPR04MB4901.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: aUpCGCubp5Fbgb1fqk4XqgRVQyUGU13uv4L9JpEOGpJrLgcDTgyxhPxp4mGlL0BDwojp/dbwPPYFn2+Rzpl1OiRAhTXQ/IbYWx4pqd9Tfz8i5e+RjAPCM1G8QfjXSmV+sQR7tIfdtl7oCky4l6TeDmLaC00NdGCndUHm496pE1VKM+Jd67fG0gPNGut7k09D4TTo/zuL7g81B8WRCGBEjxqu0VvOE5RWdFWt0cWOf0B//JNr3G+0bZpzX/ekTBktsnyLpneOavWdt+f1EI3qodpAhKIw9byRbz23HYRnaxd0buJo0egWSFtYmf7y8qAgG4HGPrfohTYn7H8dLXUId/tVAwO7x618//MtNVQjqTz1eB2NoxMT/0FMlq0toSgnHw9J7zPPNw3EG4VyN3LVUqM9uQD6pELDesXlHNvQwjc=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FDADB0944AF2D049A719E1E1B9A030E4@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1eb723f1-7a9c-4416-b5e7-08d6f353828d
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2019 18:42:11.5415
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Alistair.Francis@wdc.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5046
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDE5LTA2LTE3IGF0IDA5OjE0IC0wNTAwLCBUcm95IEJlbmplZ2VyZGVzIHdyb3Rl
Og0KPiA+IE9uIEp1biAxNywgMjAxOSwgYXQgNjozNCBBTSwgUGF1bCBXYWxtc2xleSA8DQo+ID4g
cGF1bC53YWxtc2xleUBzaWZpdmUuY29tPiB3cm90ZToNCj4gPiANCj4gPiBPbiBNb24sIDE3IEp1
biAyMDE5LCBBbmRyZWFzIFNjaHdhYiB3cm90ZToNCj4gPiANCj4gPiA+IE9uIEp1biAxNyAyMDE5
LCBQYXVsIFdhbG1zbGV5IDxwYXVsLndhbG1zbGV5QHNpZml2ZS5jb20+IHdyb3RlOg0KPiA+ID4g
DQo+ID4gPiA+IE9uIE1vbiwgMTcgSnVuIDIwMTksIEFuZHJlYXMgU2Nod2FiIHdyb3RlOg0KPiA+
ID4gPiANCj4gPiA+ID4gPiBPbiBKdW4gMTcgMjAxOSwgUGF1bCBXYWxtc2xleSA8cGF1bC53YWxt
c2xleUBzaWZpdmUuY29tPg0KPiA+ID4gPiA+IHdyb3RlOg0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+
ID4gTG9va3MgdG8gbWUgdGhhdCBpdCBzaG91bGRuJ3QgaGF2ZSBhbiBpbXBhY3QgdW5sZXNzIHRo
ZSBEVA0KPiA+ID4gPiA+ID4gc3RyaW5nIGlzIA0KPiA+ID4gPiA+ID4gcHJlc2VudCwgYW5kIGV2
ZW4gdGhlbiwgdGhlIGltcGFjdCBtaWdodCBzaW1wbHkgYmUgdGhhdCB0aGUNCj4gPiA+ID4gPiA+
IE1BQ0IgZHJpdmVyIA0KPiA+ID4gPiA+ID4gbWF5IG5vdCB3b3JrPw0KPiA+ID4gPiA+IA0KPiA+
ID4gPiA+IElmIHRoZSBtYWNiIGRyaXZlciBkb2Vzbid0IHdvcmsgeW91IGhhdmUgYW4gdW51c2Fi
bGUgc3lzdGVtLA0KPiA+ID4gPiA+IG9mIGNvdXJzZS4NCj4gPiA+ID4gDQo+ID4gPiA+IFdoeT8N
Cj4gPiA+IA0KPiA+ID4gQmVjYXVzZSBhIHN5c3RlbSBpcyB1c2VsZXNzIHdpdGhvdXQgbmV0d29y
ay4NCj4gPiANCj4gPiBGcm9tIGFuIHVwc3RyZWFtIExpbnV4IHBvaW50IG9mIHZpZXcsIFlhc2gn
cyBwYXRjaGVzIHNob3VsZCBiZSBhbiANCj4gPiBpbXByb3ZlbWVudCBvdmVyIHRoZSBjdXJyZW50
IG1haW5saW5lIGtlcm5lbCBzaXR1YXRpb24sIHNpbmNlDQo+ID4gdGhlcmUncyANCj4gPiBjdXJy
ZW50bHkgbm8gdXBzdHJlYW0gc3VwcG9ydCBmb3IgdGhlIChTaUZpdmUtc3BlY2lmaWMpIFRYIGNs
b2NrDQo+ID4gc3dpdGNoIA0KPiA+IHJlZ2lzdGVyLiAgV2l0aCB0aGUgcmlnaHQgRFQgZGF0YSwg
YW5kIGEgYm9vdGxvYWRlciB0aGF0IGhhbmRsZXMNCj4gPiB0aGUgUEhZIA0KPiA+IHJlc2V0LCBJ
IHRoaW5rIG5ldHdvcmtpbmcgc2hvdWxkIHdvcmsgYWZ0ZXIgaGlzIHBhdGNoZXMgYXJlDQo+ID4g
dXBzdHJlYW0gLS0gDQo+ID4gYWx0aG91Z2ggSSBteXNlbGYgaGF2ZW4ndCB0cmllZCB0aGlzIHll
dC4NCj4gPiANCj4gDQo+IEhhdmUgd2UgZG9jdW1lbnRlZCB0aGlzIHR4IGNsb2NrIHN3aXRjaCBy
ZWdpc3RlciBpbiBzb21ldGhpbmcgd2l0aCBhDQo+IGRpcmVjdCBVUkwgbGluayAocmF0aGVyIHRo
YW4gYSBQREYpPw0KPiANCj4gSeKAmWQgbGlrZSB0byB1cGRhdGUgZnJlZWRvbS11LXNkayAob3Ig
eW9jdG8pIHRvIGNyZWF0ZSBib290YWJsZSBpbWFnZXMNCj4gd2l0aCBhIHdvcmtpbmcgVS1ib290
ICh1cHN0cmVhbSBvciBub3QsIEkgZG9u4oCZdCBjYXJlLCBhcyBsb25nIGFzIGl0DQo+IHdvcmtz
KSwNCj4gYW5kIHdoYXQgSSBoYXZlIHJpZ2h0IG5vdyBpcyB0aGUgb2xkIGxlZ2FjeSBIaUZpdmUg
VS1ib290WzFdIGFuZCBhDQo+IDQuMTkNCj4ga2VybmVsIHdpdGggYSBidW5jaCBvZiBleHRyYSBw
YXRjaGVzLg0KDQpZb2N0by9PcGVuRW1iZWRkZWQgZG9lcyB0aGlzIHRvZGF5LiBURlRQIGJvb3Qg
d29ya3Mgd2l0aCB0aGUgMjAxOS4wNCBVLQ0KQm9vdCAoKyBzb21lIHBhdGNoZXMgb250b3AgZm9y
IFNNUCBzdXBwb3J0KS4gV2UgdXNlIHRoZSBsYXRlc3QgNS4xDQpzdGFibGUga2VybmVsIHBsdXMg
NSBvciBzbyBwYXRjaGVzIHRvIGJvb3Qgb24gdGhlIFVubGVhc2VkLiBOZXR3b3JraW5nLA0KZGlz
cGxheSBhbmQgYXVkaW8gYXJlIGFsbCB3b3JraW5nIHdpdGggdGhlIE1pY3Jvc2VtaSBleHBhbnNp
b24gYm9hcmQgYXMNCndlbGwuIExldCBtZSBrbm93IGlmIHRoZXJlIGlzIHNvbWV0aGluZyBlbHNl
IG1pc3NpbmcgYW5kIEknbGwgYWRkIGl0DQppbi4gVGhlcmUgYXJlIHByb2JhYmx5IGRvY3VtZW50
YXRpb24gZml4ZXMgdGhhdCBhcmUgbmVlZGVkIGFzIHdlbGwuDQoNCkkgd2FzIHRoaW5raW5nIG9m
IHNraXBwaW5nIHRoZSA1LjIgcmVsZWFzZSB0aG91Z2ggYXMgSSB0aG91Z2h0IHRoZSBEVA0Kc3R1
ZmYgd2Fzbid0IGdvaW5nIHRvIG1ha2UgaXQgWzFdLiBJIHdpbGwgcHJvYmFibHkgcmUtZXZhbHVh
dGUgdGhhdA0KZGVjaXNpb24gdGhvdWdoIHdoZW4gNS4yIGNvbWVzIG91dCBhcyBpdCBsb29rcyBs
aWtlIGl0J3MgYWxsIGdvaW5nIHRvDQp3b3JrIDopDQoNCldpdGggVS1ib290IDIwMTcuMDkgYW5k
IExpbnV4IDUuMi81LjMgd2Ugc2hvdWxkIGZpbmFsbHkgYmUgdXBzdHJlYW0NCm9ubHkhDQoNCj4g
DQo+IFRoZSBsZWdhY3kgTS1tb2RlIFUtYm9vdCBoYW5kbGVzIHRoZSBwaHkgcmVzZXQgYWxyZWFk
eSwgYW5kIEnigJl2ZSBiZWVuDQo+IGFibGUgdG8gbG9hZCB1cHN0cmVhbSBTLW1vZGUgdWJvb3Qg
YXMgYSBwYXlsb2FkIHZpYSBURlRQLCBhbmQgdGhlbiANCj4gbG9hZCBhbmQgYm9vdCBhIDQuMTkg
a2VybmVsLiANCj4gDQo+IEl0IHdvdWxkIGJlIG5pY2UgdG8gZ2V0IHRoaXMgYWxsIHdvcmtpbmcg
d2l0aCA1LngsIGhvd2V2ZXIgdGhlcmUgYXJlDQo+IHN0aWxsDQo+IHNldmVyYWwgbWlzc2luZyBw
aWVjZXMgdG8gcmVhbGx5IGhhdmUgaXQgd29yayB3ZWxsLg0KDQpMZXQgbWUga25vdyB3aGF0IGlz
IHN0aWxsIG1pc3NpbmcvZG9lc24ndCB3b3JrIGFuZCBJIGNhbiBhZGQgaXQuIEF0IHRoZQ0KbW9t
ZW50IHRoZSBvbmx5IGtub3duIGlzc3VlIEkga25vdyBvZiBpcyBhIG1pc3NpbmcgU0QgY2FyZCBk
cml2ZXIgaW4gVS0NCkJvb3QuDQoNCjE6IGh0dHBzOi8vZ2l0aHViLmNvbS9yaXNjdi9tZXRhLXJp
c2N2L2lzc3Vlcy8xNDMNCg0KQWxpc3RhaXINCg0KPiANCj4gDQo+IFsxXSBodHRwczovL2dpdGh1
Yi5jb20vc2lmaXZlL0hpRml2ZV9VLUJvb3QNCj4gX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX18NCj4gbGludXgtcmlzY3YgbWFpbGluZyBsaXN0DQo+IGxpbnV4
LXJpc2N2QGxpc3RzLmluZnJhZGVhZC5vcmcNCj4gaHR0cDovL2xpc3RzLmluZnJhZGVhZC5vcmcv
bWFpbG1hbi9saXN0aW5mby9saW51eC1yaXNjdg0K
