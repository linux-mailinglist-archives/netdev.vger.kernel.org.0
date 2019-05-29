Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E19CD2DA54
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 12:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbfE2KUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 06:20:48 -0400
Received: from mail-eopbgr20080.outbound.protection.outlook.com ([40.107.2.80]:19778
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726097AbfE2KUr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 06:20:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=darbyshire-bryant.me.uk; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZKF4LtufXlVKmy2xW2cd7iB8Zlat3s2z8J2GONzambw=;
 b=ZoLqvcqEiVrCQOAw+AdejkYxPJa3pv1mH79DShR+X3kXN7pW2t86M1mLZ95ofM8v8hB/Cucho11VDvOU9xa/1Q7Sp7YCCOUttLNfejUp7q+P7Rx9kpzLtC2pXobwABuyE4ALLXiWDFOwWwpOz0pZPAqas+CHtG+EzzYHvWYAZ5s=
Received: from VI1PR0302MB2750.eurprd03.prod.outlook.com (10.171.106.21) by
 VI1PR0302MB2592.eurprd03.prod.outlook.com (10.171.108.145) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Wed, 29 May 2019 10:20:42 +0000
Received: from VI1PR0302MB2750.eurprd03.prod.outlook.com
 ([fe80::603a:6eb9:2073:bde4]) by VI1PR0302MB2750.eurprd03.prod.outlook.com
 ([fe80::603a:6eb9:2073:bde4%5]) with mapi id 15.20.1922.021; Wed, 29 May 2019
 10:20:42 +0000
From:   Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
To:     =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v5] net: sched: Introduce act_ctinfo action
Thread-Topic: [PATCH net-next v5] net: sched: Introduce act_ctinfo action
Thread-Index: AQHVFH3Pu3V1wO3o7ki3ThCMKllReaZ/HfQAgABBCACAABVDAIACcxqA
Date:   Wed, 29 May 2019 10:20:42 +0000
Message-ID: <7444E72A-A8D8-429D-98B5-16BC9067B5F4@darbyshire-bryant.me.uk>
References: <87h89kx74q.fsf@toke.dk>
 <20190527111716.94736-1-ldir@darbyshire-bryant.me.uk>
 <8736kzyk53.fsf@toke.dk>
 <4F2278CE-5197-43FF-B3D5-AF443088D73F@darbyshire-bryant.me.uk>
 <87lfyrwr9v.fsf@toke.dk>
In-Reply-To: <87lfyrwr9v.fsf@toke.dk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ldir@darbyshire-bryant.me.uk; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2a02:c7f:1268:6500::dc83]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1ac98740-7e6d-4457-e5df-08d6e41f4e24
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:VI1PR0302MB2592;
x-ms-traffictypediagnostic: VI1PR0302MB2592:
x-microsoft-antispam-prvs: <VI1PR0302MB259241AF9204AD24AA500728C91F0@VI1PR0302MB2592.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1388;
x-forefront-prvs: 0052308DC6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39830400003)(366004)(346002)(376002)(136003)(396003)(189003)(199004)(52314003)(7736002)(33656002)(6246003)(46003)(68736007)(81156014)(81166006)(8676002)(8936002)(5660300002)(486006)(6512007)(86362001)(76176011)(53546011)(316002)(102836004)(6506007)(36756003)(305945005)(99286004)(6916009)(186003)(91956017)(66476007)(71200400001)(71190400001)(6116002)(25786009)(83716004)(73956011)(82746002)(64756008)(66556008)(508600001)(66574012)(14454004)(53936002)(74482002)(6486002)(6436002)(11346002)(4326008)(2906002)(229853002)(14444005)(66946007)(66446008)(2616005)(446003)(476003)(76116006)(256004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0302MB2592;H:VI1PR0302MB2750.eurprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: darbyshire-bryant.me.uk does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: p8ACLV+cuXpTJpWbLIUt60KX5Wo5naK4unDjVz/NIVS7J5kWl0ZIdeR0gHrFd3LXdgxl96ugxNZU+BMtwKkWpjwwUjKbneEuEkVvdmg1Xbislub7CfS89sxjNSkZlTDFbBCn2pmFHVRuG6f/RJWBShc49T/xDC6E0MnwdpeYvKAn9E/4BpFtsH8+Fyj3Jj21S7uM938dZqEyrO4Upn+iqzKvZXFr5jr7q/Nyw7bqCsHMDLvcOjg7if5uDojEOBKsttvBk3OWlf/GN/goxqbn/UOiz0tsnpzaK35hr01bgQ4yoVawZJu9BgsGNR1hSJ87vtvZkA0bdBnFX7shrRDZZzuTsHWO167jD5glYyAddRYydk3t6LffyvCgPyAB7pBZCJH906lP7oNtrFx2vo6c0jMWR69zNW8hf0GFvUTyhNk=
Content-Type: text/plain; charset="utf-8"
Content-ID: <241B80F96FA12446957C203A80EEF7EA@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: darbyshire-bryant.me.uk
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ac98740-7e6d-4457-e5df-08d6e41f4e24
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2019 10:20:42.4563
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9151708b-c553-406f-8e56-694f435154a4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kevin@darbyshire-bryant.me.uk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0302MB2592
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SW4gZmFpcm5lc3MgdG8gZXZlcnlvbmUgdGhlIGJlbG93IGRlc2VydmVzIGEgcHVibGljIGFuc3dl
cjoNCg0KPiBPbiAyNyBNYXkgMjAxOSwgYXQgMjE6NTYsIFRva2UgSMO4aWxhbmQtSsO4cmdlbnNl
biA8dG9rZUByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+IEtldmluICdsZGlyJyBEYXJieXNoaXJl
LUJyeWFudCA8bGRpckBkYXJieXNoaXJlLWJyeWFudC5tZS51az4gd3JpdGVzOg0KPiANCj4+IEkg
aGF2ZSB0byBjYWxsIGl0IGEgZGF5LiBJIGhhdmUgbm8gaWRlYSB3aHkgdGhlIHBhdGNoZXMgYXJl
IGJlY29taW5nDQo+PiBjb3JydXB0IGFuZCBoZW5jZSBob3cgdG8gZml4IGl0LCBpdOKAmXMgcHJv
YmFibHkgc29tZXRoaW5nIEFwcGxlIGhhcw0KPj4gZG9uZSB0byBnaXQsIG9yIG1heWJlIE1TIHRv
IG15IGVtYWlsIHNlcnZlci4NCj4gDQo+IE9yIG1heWJlIGl0J3MganVzdCB0aGF0IHlvdXIgZWRp
dG9yIHNhdmVzIHRoaW5ncyB3aXRoIHRoZSB3cm9uZyB0eXBlIG9mDQo+IGxpbmUgZW5kaW5nIChp
ZiB5b3UncmUgb24gYSBNYWMpPw0KDQpJdCB0dXJucyBvdXQgZXZlcnl0aGluZyBpcyBvayBhdCBt
eSBlbmQuICBUb2tlIGFuZCBJIHdvcmtlZCBvZmYgbGlzdCB0byBlc3RhYmxpc2gNCndoZXJlIHRo
ZSBwcm9ibGVtIHdhcyBsb2NhdGVkLg0KDQo+IA0KPj4gU2FkbHkgSSBhbHNvIHRoaW5rIHRoYXQg
dGhlIG9ubHkgd2F5IHRoaXMgcGF0Y2gvZnVuY3Rpb25hbGl0eSB3aWxsDQo+PiBldmVyIGJlIGFj
Y2VwdGFibGUgaXMgaWYgc29tZW9uZSBlbHNlIHdyaXRlcyBpdCwgd2hlcmUgdGhleSBvciB0aGVp
cg0KPj4gY29tcGFueSBjYW4gdGFrZSB0aGUgY3JlZGl0L2JsYW1lLg0KPiANCj4gTm90IHN1cmUg
d2h5IHlvdSB3b3VsZCB0aGluayBzby4NCj4gDQo+PiBJIHRyaWVkIHZlcnkgaGFyZCB0byBhcHBy
b2FjaCB0aGUgcHJvY2VzcyBvZiB1cHN0cmVhbSBzdWJtaXNzaW9uIGluIGENCj4+IHBvc2l0aXZl
IHdheSwgc2Vla2luZyBhZHZpY2UgJiBndWlkYW5jZSBpbiB0aGUgZm9ybSBvZiBSRkMgcGF0Y2hl
cywNCj4+IG1hbnkgcm91bmRzIGxhdGVyIEkgZmVlbCB0aGV54oCZcmUgZnVydGhlciBhd2F5IGZy
b20gYWNjZXB0YW5jZSB0aGFuDQo+PiBldmVyLg0KPiANCj4gTm90IHN1cmUgd2h5IHlvdSdkIHRo
aW5rIHRoYXQgZWl0aGVyOyBJIHRob3VnaHQgeW91IHdlcmUgcmF0aGVyIGNsb3NlLA0KPiBhY3R1
YWxseS4uLg0KPiANCj4+IENsZWFybHkgaXQgaXMgbm90IGRlc2lyZWQgZnVuY3Rpb25hbGl0eS9j
b2RlIG90aGVyd2lzZSBpdCB3b3VsZCBoYXZlDQo+PiBiZWVuIHdyaXR0ZW4gYnkgbm93IGFuZCBJ
IGNhbm5vdCBmYWNlIGFub3RoZXIgMyByb3VuZHMgb2YgdGhlIHNhbWUNCj4+IHRoaW5nIGZvciBh
Y3RfY3RpbmZvIHVzZXIgc3BhY2UsIHRoZSB4X3RhYmxlcy9uZl90YWJsZXMga2VybmVsIGhlbHBl
cg0KPj4gdG8gc3RvcmUgdGhlIERTQ1AgaW4gdGhlIGZpcnN0IHBsYWNlIGFuZCB0aGUgdXNlciBz
cGFjZSBjb2RlIHRvIGhhbmRsZQ0KPj4gdGhhdC4NCj4+IA0KPj4gQXMgYSByYW5rIG91dHNpZGVy
LCBhbWF0ZXVyIGNvZGVyIEkgc2hhbGwgbGVhdmUgaXQgdGhhdCBJ4oCZdmUgZm91bmQgdGhlDQo+
PiBwcm9jZXNzIGNvbXBsZXRlbHkgZGlzY291cmFnaW5nLiBUaGUgcHJvZmVzc2lvbmFscyBhcmUg
b2YgY291cnNlIHBhaWQNCj4+IHRvIGRlYWwgd2l0aCB0aGlzLg0KPiANCj4gSXQncyB1cCB0byB5
b3UgaWYgeW91IHdhbnQgdG8gY29udGludWUsIG9mIGNvdXJzZTsgYnV0IGhvbmVzdGx5LCBJJ20g
bm90DQo+IGFjdHVhbGx5IHN1cmUgd2hhdCBpdCBpcyB5b3UgYXJlIGZpbmRpbmcgaGFyZCB0byAi
ZGVhbCB3aXRoIj8gTm8gb25lIGhhcw0KPiB0b2xkIHlvdSAiZ28gYXdheSwgdGhpcyBpcyBqdW5r
IjsgeW91J3ZlIGdvdHRlbiBhIGZldyBzdWdnZXN0aW9ucyBmb3INCj4gaW1wcm92ZW1lbnRzLCBt
b3N0IG9mIHdoaWNoIHlvdSBoYXZlIGFscmVhZHkgZml4ZWQuIFNvIHdoYXQsIGV4YWN0bHksIGlz
DQo+IHRoZSBwcm9ibGVtPyA6KQ0KDQpUaGUgYWJvdmUgZGVzZXJ2ZXMgYW4gYW5zd2VyLiAgVGhl
IGJvdHRvbSBsaW5lIGlzIHRoYXQgSSB3YXMgZXh0cmVtZWx5IGZydXN0cmF0ZWQNCmJ5IHdoYXQg
SSBwZXJjZWl2ZWQgYXMgYW4gZW5kbGVzcyBzZXQgb2YgY2hhbmdpbmcgcmVxdWlyZW1lbnRzIGFu
ZCBuaXRwaWNrcy4NCkkgZmluZCBjb2RpbmcgaGFyZC4gIENvZGluZyBmb3IgdXBzdHJlYW0gaXMg
aGFyZGVyLCBpdCAqc2hvdWxkKiBiZS4gIEVhY2gNCml0ZXJhdGlvbiBvZiB0aGlzIG1vZHVsZSBo
YXMgcmVxdWlyZWQgdGVzdGluZywgYmFja3BvcnRpbmcgdG8gNC4xNCAmIDQuMTkgZm9yIG1vcmUN
CnRlc3Rpbmcgb24gc29tZSByZWFsIGRldmljZXMgcnVubmluZyBvcGVud3J0LiAgRWFjaCBpdGVy
YXRpb24gYWZmZWN0aW5nIG5ldGxpbmsNCnBhcmFtZXRlcnMgaGFzIGFsc28gcmVxdWlyZWQgY2hh
bmdpbmcgJiB0ZXN0aW5nIHRoZSAoeWV0IHRvIGJlIHN1Ym1pdHRlZCkgdXNlcg0Kc3BhY2UgY29k
ZSwgc2ltcGx5IHRvIHByb3ZlIEkgaGF2ZW7igJl0IHNjcmV3ZWQgdXAgdGhlIG1vZHVsZSBpbiBz
b21lIHdheS4NCg0KVGhlIGNoYW5nZXMsIHRoZSBiYWNrcG9ydHMsIHRoZSB0ZXN0aW5nLCB0aGUg
Y2hlY2tpbmcgd2l0aCBjaGVja3BhdGNoLCB0aGUgY2hlY2tpbmcNCm9mIHRoaW5ncyBub3QgY2hl
Y2tlZCBieSBjaGVja3BhdGNoIChjaHJpc3RtYXMgdHJlZXMpLCB0aGUgd2hvbGUgZ2l0IGZvcm1h
dC1wYXRjaC8NCnNlbmQtZW1haWwgKGFuZCB0byB3aG9tKSBkYW5jZSwgbGVhZHMgdG8gYSBob3Bl
ZCBmb3IgZXhwZWN0YXRpb24gb24gZXZlcnkgc3VibWlzc2luZw0KdGhhdCDigJhtYXliZSB0aGlz
IGlzIHRoZSBvbmXigJkgLSB0byBoYXZlIGhvcGVzIGRhc2hlZCBieSBhbm90aGVyIHNldCBvZiDi
gJh5b3VyIGVtYWlsDQpkb2VzbuKAmXQgd29ya+KAmSAoZmFsc2UgcG9zaXRpdmUpIGFuZCBhbm90
aGVyIOKAmGFkanVzdG1lbnQgb2YgZ29hbHBvc3Rz4oCZLiAgSXQgZmVsdA0KbGlrZSB0aGVyZSB3
YXMgbm8gZW5kIHRvIGl04oCmYW5kIGl04oCZcyBibCoqZHkgZXhoYXVzdGluZyEgIEnigJltIGJh
Y2sgdG8gY29kaW5nIGlzIGhhcmQgOi0pDQoNCkkgZm91bmQgdGhlIG1vc3QgZW5jb3VyYWdpbmcg
dGhpbmcgd3JpdHRlbiBpbiB0aGUgbGFzdCByZXNwb25zZSB3YXMg4oCcSSB0aG91Z2h0IHlvdQ0K
d2VyZSByYXRoZXIgY2xvc2XigJ0sIGllLiBrZWVwIGdvaW5nLiAgSXQgaXMgaGFyZCBmb3IgbWUs
IGxpa2UgdGhlIGNvZGluZywgdG8gdGFrZSBhbg0KYWJzZW5jZSBvZiDigJx0aGlzIGNvZGUgaXMg
Kioq4oCdIGFzIGEgcG9zaXRpdmUgdGhpbmcgZXNwZWNpYWxseSBpbiB0aGUgY29udGV4dCBvZg0K
4oCcdGhpcyBnb2FscG9zdCBpc27igJl0IHF1aXRlIHRoZSBjb3JyZWN0IHNoYWRlIG9mIGhlbGlv
dHJvcGXigJ0gSSAobWlzPylpbnRlcnByZXQgaXQgYXMNCmFsbCBuZWdhdGl2ZS4gIEFueXdheSwg
SSBibGV3IHVwIGJlY2F1c2Ugb2YgZnJ1c3RyYXRpb24gYW5kIGZlZWxpbmcgZGlzY291cmFnZWQu
DQoNCknigJltIGEgbGl0dGxlIG1vcmUgZW5jb3VyYWdlZCBub3cgYnV0IEkgc3RpbGwgbGl2ZSBp
biBmZWFyIG9mIHRoZSBncmVhdCBtYWludGFpbmVyDQpkZWNyZWVpbmcg4oCcdGhpbmUgY29kZSBp
cyBhIHBpbGUgb2YgcG9vLCB0aGluZSBpZGVhIGlzIGEgc3R1cGlkLCBuZXZlciBkYXJrZW4gdGhp
cw0KbGFuZCBvZiBsaW51eCBhZ2FpbuKApmZvb2wh4oCdICBXZWxsIHlvdSBnZXQgdGhlIGlkZWEg
Oy0pDQoNCg0KS2V2aW4gRC1CDQoNCmdwZzogMDEyQyBBQ0IyIDI4QzYgQzUzRSA5Nzc1ICA5MTIz
IEIzQTIgMzg5QiA5REUyIDMzNEENCg0K
