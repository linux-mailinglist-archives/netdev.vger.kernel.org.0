Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 029DC80F4F
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 01:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbfHDXEs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 19:04:48 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:49406 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726687AbfHDXEr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 19:04:47 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id DAFD3886BF;
        Mon,  5 Aug 2019 11:04:44 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1564959884;
        bh=LsDz4UtTQVVshnHks6FmDQZ+qTnjZqxGv3umX8yWNn0=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=Y093AWhysqdadbHPE2I8yYti1HEIhMfPCuVWGiKT6eAvQ0CluCpEqe2rHU42BxO3k
         UBCne544DWL/wauXvk/6+R5+xfC8/pr2TCmTO3luWCgOrcyryUGXrsRFrSSwjLBzKP
         cbG2kpj6sc36T4zGZEdPkuNOZIaus6iIVYutyf2/3z0omf3tI6kNqtdK+zeRSCtlui
         NP19bTJD2/jV/rrwiDyt/bFPdPwzzK3YgU1acTIoMqVCG9+2UwQG9frt+XKzrTo/CC
         QmKAnsKhPaye66kDPWypfy5vztibKyrJDc2r5CE7ObHz8WCy3t54Zp61W8tCe28qlE
         o3zcGJcJUTs2Q==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[10.32.16.77]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5d47648d0000>; Mon, 05 Aug 2019 11:04:45 +1200
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) by
 svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) with Microsoft SMTP Server
 (TLS) id 15.0.1156.6; Mon, 5 Aug 2019 11:04:39 +1200
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1156.000; Mon, 5 Aug 2019 11:04:39 +1200
From:   Chris Packham <Chris.Packham@alliedtelesis.co.nz>
To:     "jon.maloy@ericsson.com" <jon.maloy@ericsson.com>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Slowness forming TIPC cluster with explicit node addresses
Thread-Topic: Slowness forming TIPC cluster with explicit node addresses
Thread-Index: AQHVQ0Hkw5M86TmlWkazctTgG4cJIabc5XqAgALa5YCABtFugIAFBHpw//9MBoA=
Date:   Sun, 4 Aug 2019 23:04:39 +0000
Message-ID: <1564959879.27215.18.camel@alliedtelesis.co.nz>
References: <1564097836.11887.16.camel@alliedtelesis.co.nz>
         <CH2PR15MB35754D65AB240A74AE488E719AC00@CH2PR15MB3575.namprd15.prod.outlook.com>
         <1564347861.9737.25.camel@alliedtelesis.co.nz>
         <1564722689.4914.27.camel@alliedtelesis.co.nz>
         <CH2PR15MB3575BF6FC4001C19B8A789559ADB0@CH2PR15MB3575.namprd15.prod.outlook.com>
In-Reply-To: <CH2PR15MB3575BF6FC4001C19B8A789559ADB0@CH2PR15MB3575.namprd15.prod.outlook.com>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.18.5.2-0ubuntu3.2 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [2001:df5:b000:22:3a2c:4aff:fe70:2b02]
Content-Type: text/plain; charset="utf-8"
Content-ID: <6CAFF68F4FB73241A5EA04D9733C4994@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU3VuLCAyMDE5LTA4LTA0IGF0IDIxOjUzICswMDAwLCBKb24gTWFsb3kgd3JvdGU6DQo+IA0K
PiA+IA0KPiA+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4gRnJvbTogbmV0ZGV2LW93
bmVyQHZnZXIua2VybmVsLm9yZyA8bmV0ZGV2LW93bmVyQHZnZXIua2VybmVsLm9yZz4NCj4gPiBP
bg0KPiA+IEJlaGFsZiBPZiBDaHJpcyBQYWNraGFtDQo+ID4gU2VudDogMi1BdWctMTkgMDE6MTEN
Cj4gPiBUbzogSm9uIE1hbG95IDxqb24ubWFsb3lAZXJpY3Nzb24uY29tPjsgdGlwYy0NCj4gPiBk
aXNjdXNzaW9uQGxpc3RzLnNvdXJjZWZvcmdlLm5ldA0KPiA+IENjOiBuZXRkZXZAdmdlci5rZXJu
ZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+ID4gU3ViamVjdDogUmU6IFNs
b3duZXNzIGZvcm1pbmcgVElQQyBjbHVzdGVyIHdpdGggZXhwbGljaXQgbm9kZQ0KPiA+IGFkZHJl
c3Nlcw0KPiA+IA0KPiA+IE9uIE1vbiwgMjAxOS0wNy0yOSBhdCAwOTowNCArMTIwMCwgQ2hyaXMg
UGFja2hhbSB3cm90ZToNCj4gPiA+IA0KPiA+ID4gT24gRnJpLCAyMDE5LTA3LTI2IGF0IDEzOjMx
ICswMDAwLCBKb24gTWFsb3kgd3JvdGU6DQo+ID4gPiA+IA0KPiA+ID4gPiANCj4gPiA+ID4gDQo+
ID4gPiA+ID4gDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gLS0tLS1PcmlnaW5h
bCBNZXNzYWdlLS0tLS0NCj4gPiA+ID4gPiBGcm9tOiBuZXRkZXYtb3duZXJAdmdlci5rZXJuZWwu
b3JnIDxuZXRkZXYtDQo+ID4gb3duZXJAdmdlci5rZXJuZWwub3JnPg0KPiA+ID4gDQo+ID4gPiA+
IA0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IE9uIEJlaGFsZiBPZiBDaHJpcyBQYWNraGFtDQo+ID4g
PiA+ID4gU2VudDogMjUtSnVsLTE5IDE5OjM3DQo+ID4gPiA+ID4gVG86IHRpcGMtZGlzY3Vzc2lv
bkBsaXN0cy5zb3VyY2Vmb3JnZS5uZXQNCj4gPiA+ID4gPiBDYzogbmV0ZGV2QHZnZXIua2VybmVs
Lm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0KPiA+ID4gPiA+IFN1YmplY3Q6IFNs
b3duZXNzIGZvcm1pbmcgVElQQyBjbHVzdGVyIHdpdGggZXhwbGljaXQgbm9kZQ0KPiA+ID4gPiA+
IGFkZHJlc3Nlcw0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IEhpLA0KPiA+ID4gPiA+IA0KPiA+ID4g
PiA+IEknbSBoYXZpbmcgcHJvYmxlbXMgZm9ybWluZyBhIFRJUEMgY2x1c3RlciBiZXR3ZWVuIDIg
bm9kZXMuDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gVGhpcyBpcyB0aGUgYmFzaWMgc3RlcHMgSSdt
IGdvaW5nIHRocm91Z2ggb24gZWFjaCBub2RlLg0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IG1vZHBy
b2JlIHRpcGMNCj4gPiA+ID4gPiBpcCBsaW5rIHNldCBldGgyIHVwDQo+ID4gPiA+ID4gdGlwYyBu
b2RlIHNldCBhZGRyIDEuMS41ICMgb3IgMS4xLjYgdGlwYyBiZWFyZXIgZW5hYmxlIG1lZGlhDQo+
ID4gPiA+ID4gZXRoDQo+ID4gPiA+ID4gZGV2IGV0aDANCj4gPiA+ID4gZXRoMiwgSSBhc3N1bWUu
Li4NCj4gPiA+ID4gDQo+ID4gPiBZZXMgc29ycnkgSSBrZWVwIHN3aXRjaGluZyBiZXR3ZWVuIGJl
dHdlZW4gRXRoZXJuZXQgcG9ydHMgZm9yDQo+ID4gPiB0ZXN0aW5nDQo+ID4gPiBzbyBJIGhhbmQg
ZWRpdGVkIHRoZSBlbWFpbC4NCj4gPiA+IA0KPiA+ID4gPiANCj4gPiA+ID4gDQo+ID4gPiA+ID4g
DQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gVGhlbiB0byBj
b25maXJtIGlmIHRoZSBjbHVzdGVyIGlzIGZvcm1lZCBJIHVzZcKgdGlwYyBsaW5rIGxpc3QNCj4g
PiA+ID4gPiANCj4gPiA+ID4gPiBbcm9vdEBub2RlLTUgfl0jIHRpcGMgbGluayBsaXN0DQo+ID4g
PiA+ID4gYnJvYWRjYXN0LWxpbms6IHVwDQo+ID4gPiA+ID4gLi4uDQo+ID4gPiA+ID4gDQo+ID4g
PiA+ID4gTG9va2luZyBhdCB0Y3BkdW1wIHRoZSB0d28gbm9kZXMgYXJlIHNlbmRpbmcgcGFja2V0
cw0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IDIyOjMwOjA1Ljc4MjMyMCBUSVBDIHYyLjAgMS4xLjUg
PiAwLjAuMCwgaGVhZGVybGVuZ3RoIDYwDQo+ID4gPiA+ID4gYnl0ZXMsDQo+ID4gPiA+ID4gTWVz
c2FnZVNpemUNCj4gPiA+ID4gPiA3NiBieXRlcywgTmVpZ2hib3IgRGV0ZWN0aW9uIFByb3RvY29s
IGludGVybmFsLCBtZXNzYWdlVHlwZQ0KPiA+ID4gPiA+IExpbmsNCj4gPiA+ID4gPiByZXF1ZXN0
DQo+ID4gPiA+ID4gMjI6MzA6MDUuODYzNTU1IFRJUEMgdjIuMCAxLjEuNiA+IDAuMC4wLCBoZWFk
ZXJsZW5ndGggNjANCj4gPiA+ID4gPiBieXRlcywNCj4gPiA+ID4gPiBNZXNzYWdlU2l6ZQ0KPiA+
ID4gPiA+IDc2IGJ5dGVzLCBOZWlnaGJvciBEZXRlY3Rpb24gUHJvdG9jb2wgaW50ZXJuYWwsIG1l
c3NhZ2VUeXBlDQo+ID4gPiA+ID4gTGluaw0KPiA+ID4gPiA+IHJlcXVlc3QNCj4gPiA+ID4gPiAN
Cj4gPiA+ID4gPiBFdmVudHVhbGx5IChhZnRlciBhIGZldyBtaW51dGVzKSB0aGUgbGluayBkb2Vz
IGNvbWUgdXANCj4gPiA+ID4gPiANCj4gPiA+ID4gPiBbcm9vdEBub2RlLTbCoH5dIyB0aXBjIGxp
bmsgbGlzdA0KPiA+ID4gPiA+IGJyb2FkY2FzdC1saW5rOiB1cA0KPiA+ID4gPiA+IDEwMDEwMDY6
ZXRoMi0xMDAxMDA1OmV0aDI6IHVwDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gW3Jvb3RAbm9kZS01
wqB+XSMgdGlwYyBsaW5rIGxpc3QNCj4gPiA+ID4gPiBicm9hZGNhc3QtbGluazogdXANCj4gPiA+
ID4gPiAxMDAxMDA1OmV0aDItMTAwMTAwNjpldGgyOiB1cA0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+
IFdoZW4gSSByZW1vdmUgdGhlICJ0aXBjIG5vZGUgc2V0IGFkZHIiIHRoaW5ncyBzZWVtIHRvIGtp
Y2sNCj4gPiA+ID4gPiBpbnRvDQo+ID4gPiA+ID4gbGlmZSBzdHJhaWdodCBhd2F5DQo+ID4gPiA+
ID4gDQo+ID4gPiA+ID4gW3Jvb3RAbm9kZS01IH5dIyB0aXBjIGxpbmsgbGlzdA0KPiA+ID4gPiA+
IGJyb2FkY2FzdC1saW5rOiB1cA0KPiA+ID4gPiA+IDAwNTBiNjFiZDJhYTpldGgyLTAwNTBiNjFl
NmRmYTpldGgyOiB1cA0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IFNvIHRoZXJlIGFwcGVhcnMgdG8g
YmUgc29tZSBkaWZmZXJlbmNlIGluIGJlaGF2aW91ciBiZXR3ZWVuDQo+ID4gPiA+ID4gaGF2aW5n
DQo+ID4gPiA+ID4gYW4gZXhwbGljaXQgbm9kZSBhZGRyZXNzIGFuZCB1c2luZyB0aGUgZGVmYXVs
dC4gVW5mb3J0dW5hdGVseQ0KPiA+ID4gPiA+IG91cg0KPiA+ID4gPiA+IGFwcGxpY2F0aW9uIHJl
bGllcyBvbiBzZXR0aW5nIHRoZSBub2RlIGFkZHJlc3Nlcy4NCj4gPiA+ID4gSSBkbyB0aGlzIG1h
bnkgdGltZXMgYSBkYXksIHdpdGhvdXQgYW55IHByb2JsZW1zLiBJZiB0aGVyZQ0KPiA+ID4gPiB3
b3VsZCBiZQ0KPiA+ID4gPiBhbnkgdGltZSBkaWZmZXJlbmNlLCBJIHdvdWxkIGV4cGVjdCB0aGUg
J2F1dG8gY29uZmlndXJhYmxlJw0KPiA+ID4gPiB2ZXJzaW9uDQo+ID4gPiA+IHRvIGJlIHNsb3dl
ciwgYmVjYXVzZSBpdCBpbnZvbHZlcyBhIERBRCBzdGVwLg0KPiA+ID4gPiBBcmUgeW91IHN1cmUg
eW91IGRvbid0IGhhdmUgYW55IG90aGVyIG5vZGVzIHJ1bm5pbmcgaW4geW91cg0KPiA+ID4gPiBz
eXN0ZW0/DQo+ID4gPiA+IA0KPiA+ID4gPiAvLy9qb24NCj4gPiA+ID4gDQo+ID4gPiBOb3BlIHRo
ZSB0d28gbm9kZXMgYXJlIGNvbm5lY3RlZCBiYWNrIHRvIGJhY2suIERvZXMgdGhlIG51bWJlciBv
Zg0KPiA+ID4gRXRoZXJuZXQgaW50ZXJmYWNlcyBtYWtlIGEgZGlmZmVyZW5jZT8gQXMgeW91IGNh
biBzZWUgSSd2ZSBnb3QgMw0KPiA+ID4gb24NCj4gPiA+IGVhY2ggbm9kZS4gT25lIGlzIGNvbXBs
ZXRlbHkgZGlzY29ubmVjdGVkLCBvbmUgaXMgZm9yIGJvb3RpbmcNCj4gPiA+IG92ZXINCj4gPiA+
IFRGVFANCj4gPiA+IMKgKG9ubHkgdXNlZCBieSBVLWJvb3QpIGFuZCB0aGUgb3RoZXIgaXMgdGhl
IFVTQiBFdGhlcm5ldCBJJ20NCj4gPiA+IHVzaW5nIGZvcg0KPiA+ID4gdGVzdGluZy4NCj4gPiA+
IA0KPiA+IFNvIEkgY2FuIHN0aWxsIHJlcHJvZHVjZSB0aGlzIG9uIG5vZGVzIHRoYXQgb25seSBo
YXZlIG9uZSBuZXR3b3JrDQo+ID4gaW50ZXJmYWNlIGFuZA0KPiA+IGFyZSB0aGUgb25seSB0aGlu
Z3MgY29ubmVjdGVkLg0KPiA+IA0KPiA+IEkgZGlkIGZpbmQgb25lIHRoaW5nIHRoYXQgaGVscHMN
Cj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvbmV0L3RpcGMvZGlzY292ZXIuYyBiL25ldC90aXBjL2Rp
c2NvdmVyLmMgaW5kZXgNCj4gPiBjMTM4ZDY4ZThhNjkuLjQ5OTIxZGFkNDA0YSAxMDA2NDQNCj4g
PiAtLS0gYS9uZXQvdGlwYy9kaXNjb3Zlci5jDQo+ID4gKysrIGIvbmV0L3RpcGMvZGlzY292ZXIu
Yw0KPiA+IEBAIC0zNTgsMTAgKzM1OCwxMCBAQCBpbnQgdGlwY19kaXNjX2NyZWF0ZShzdHJ1Y3Qg
bmV0ICpuZXQsIHN0cnVjdA0KPiA+IHRpcGNfYmVhcmVyICpiLA0KPiA+IMKgwqDCoMKgwqDCoMKg
wqB0aXBjX2Rpc2NfaW5pdF9tc2cobmV0LCBkLT5za2IsIERTQ19SRVFfTVNHLCBiKTsNCj4gPiAN
Cj4gPiDCoMKgwqDCoMKgwqDCoMKgLyogRG8gd2UgbmVlZCBhbiBhZGRyZXNzIHRyaWFsIHBlcmlv
ZCBmaXJzdCA/ICovDQo+ID4gLcKgwqDCoMKgwqDCoMKgaWYgKCF0aXBjX293bl9hZGRyKG5ldCkp
IHsNCj4gPiArLy/CoMKgwqDCoMKgaWYgKCF0aXBjX293bl9hZGRyKG5ldCkpIHsNCj4gPiDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHRuLT5hZGRyX3RyaWFsX2VuZCA9IGppZmZpZXMg
Kw0KPiA+IG1zZWNzX3RvX2ppZmZpZXMoMTAwMCk7DQo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqBtc2dfc2V0X3R5cGUoYnVmX21zZyhkLT5za2IpLCBEU0NfVFJJQUxfTVNHKTsN
Cj4gPiAtwqDCoMKgwqDCoMKgwqB9DQo+ID4gKy8vwqDCoMKgwqDCoH0NCj4gPiDCoMKgwqDCoMKg
wqDCoMKgbWVtY3B5KCZkLT5kZXN0LCBkZXN0LCBzaXplb2YoKmRlc3QpKTsNCj4gPiDCoMKgwqDC
oMKgwqDCoMKgZC0+bmV0ID0gbmV0Ow0KPiA+IMKgwqDCoMKgwqDCoMKgwqBkLT5iZWFyZXJfaWQg
PSBiLT5pZGVudGl0eTsNCj4gPiANCj4gPiBJIHRoaW5rIGJlY2F1c2Ugd2l0aCBwcmUtY29uZmln
dXJlZCBhZGRyZXNzZXMgdGhlIGR1cGxpY2F0ZSBhZGRyZXNzDQo+ID4gZGV0ZWN0aW9uDQo+ID4g
aXMgc2tpcHBlZCB0aGUgc2hvcnRlciBpbml0IHBoYXNlIGlzIHNraXBwZWQuIFdvdWxkIGlzIG1h
a2Ugc2Vuc2UNCj4gPiB0bw0KPiA+IHVuY29uZGl0aW9uYWxseSBkbyB0aGUgdHJpYWwgc3RlcD8g
T3IgaXMgdGhlcmUgc29tZSBiZXR0ZXIgd2F5IHRvDQo+ID4gZ2V0IHRoaW5ncyB0bw0KPiA+IHRy
YW5zaXRpb24gd2l0aCBwcmUtYXNzaWduZWQgYWRkcmVzc2VzLg0KPg0KPiBJIGFtIG9uIHZhY2F0
aW9uIHVudGlsIHRoZSBlbmQgb2YgbmV4dC13ZWVrLCBzbyBJIGNhbid0IGdpdmUgeW91IGFueQ0K
PiBnb29kIGFuYWx5c2lzIHJpZ2h0IG5vdy4NCg0KVGhhbmtzIGZvciB0YWtpbmcgdGhlIHRpbWUg
dG8gcmVzcG9uZC4NCg0KPiBUbyBkbyB0aGUgdHJpYWwgc3RlcCBkb2VzbuKAmXQgbWFrZSBtdWNo
IHNlbnNlIHRvIG1lLCAtaXQgd291bGQgb25seQ0KPiBkZWxheSB0aGUgc2V0dXAgdW5uZWNlc3Nh
cmlseSAoYnV0IHdpdGggb25seSAxIHNlY29uZCkuDQo+IENhbiB5b3UgY2hlY2sgdGhlIGluaXRp
YWwgdmFsdWUgb2YgYWRkcl90cmlhbF9lbmQgd2hlbiB0aGVyZSBhIHByZS0NCj4gY29uZmlndXJl
ZCBhZGRyZXNzPw0KDQpJIGhhZCB0aGUgc2FtZSB0aG91Z2h0LiBGb3IgYm90aCBteSBkZXZpY2Vz
ICdhZGRyX3RyaWFsX2VuZCA9IDAnIHNvIEkNCnRoaW5rwqB0aXBjX2Rpc2NfYWRkcl90cmlhbF9t
c2cgc2hvdWxkIGVuZCB1cCB3aXRoIHRyaWFsID09IGZhbHNlDQoNCj4gDQo+IC8vL2pvbg0KPiA=
