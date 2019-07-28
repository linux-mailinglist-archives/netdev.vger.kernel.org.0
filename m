Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4278D781A2
	for <lists+netdev@lfdr.de>; Sun, 28 Jul 2019 23:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbfG1VE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jul 2019 17:04:28 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:36747 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726097AbfG1VE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jul 2019 17:04:28 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 7DB9D886BF;
        Mon, 29 Jul 2019 09:04:25 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1564347865;
        bh=pqlM5xL0t3YTnMrVuYj5YL1cUIh0dA6bIksMMy+ZfBo=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=X1cc8ndq20hdx0b8QdZy4b5yAJY5Y1mi5uWqOiaUrNcj5/F/n98uzQuTHhiGcAHuV
         Xhnghh2WJW+Wz5xVWtAUg+dpux+9Zd2EsaMPuad0Y6wQUl0o4sjpjvL4uX2F94GudC
         DJfvFg5BJUFpT/V9Wk3auHATDgiiMHXycuZ+u+WtTeZe2vV+Yk/UpysvuTPqfVpX3A
         t4nM2cW0atUVfVVrru8zM+NKsC5zhMQAYtK0D89yoxgnuFf9YD/B11xNVdI3vcohbB
         pGFvPr5ez00jgsdwSyKeCwqqJhfE0MpmsLhK6LCvgFXS970fMaTDAMgrn6EpuvxaZa
         1FywbbLKai59A==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[10.32.16.77]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5d3e0dd90000>; Mon, 29 Jul 2019 09:04:25 +1200
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8)
 by svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8) with
 Microsoft SMTP Server (TLS) id 15.0.1156.6; Mon, 29 Jul 2019 09:04:21 +1200
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1156.000; Mon, 29 Jul 2019 09:04:21 +1200
From:   Chris Packham <Chris.Packham@alliedtelesis.co.nz>
To:     "jon.maloy@ericsson.com" <jon.maloy@ericsson.com>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Slowness forming TIPC cluster with explicit node addresses
Thread-Topic: Slowness forming TIPC cluster with explicit node addresses
Thread-Index: AQHVQ0Hkw5M86TmlWkazctTgG4cJIabc5XqAgALa5YA=
Date:   Sun, 28 Jul 2019 21:04:21 +0000
Message-ID: <1564347861.9737.25.camel@alliedtelesis.co.nz>
References: <1564097836.11887.16.camel@alliedtelesis.co.nz>
         <CH2PR15MB35754D65AB240A74AE488E719AC00@CH2PR15MB3575.namprd15.prod.outlook.com>
In-Reply-To: <CH2PR15MB35754D65AB240A74AE488E719AC00@CH2PR15MB3575.namprd15.prod.outlook.com>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.18.5.2-0ubuntu3.2 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [2001:df5:b000:22:3a2c:4aff:fe70:2b02]
Content-Type: text/plain; charset="utf-8"
Content-ID: <2917B37366AAF443B617C459089BDC5E@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDE5LTA3LTI2IGF0IDEzOjMxICswMDAwLCBKb24gTWFsb3kgd3JvdGU6DQo+IA0K
PiA+IA0KPiA+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4gRnJvbTogbmV0ZGV2LW93
bmVyQHZnZXIua2VybmVsLm9yZyA8bmV0ZGV2LW93bmVyQHZnZXIua2VybmVsLm9yZz4NCj4gPiBP
bg0KPiA+IEJlaGFsZiBPZiBDaHJpcyBQYWNraGFtDQo+ID4gU2VudDogMjUtSnVsLTE5IDE5OjM3
DQo+ID4gVG86IHRpcGMtZGlzY3Vzc2lvbkBsaXN0cy5zb3VyY2Vmb3JnZS5uZXQNCj4gPiBDYzog
bmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0KPiA+
IFN1YmplY3Q6IFNsb3duZXNzIGZvcm1pbmcgVElQQyBjbHVzdGVyIHdpdGggZXhwbGljaXQgbm9k
ZSBhZGRyZXNzZXMNCj4gPiANCj4gPiBIaSwNCj4gPiANCj4gPiBJJ20gaGF2aW5nIHByb2JsZW1z
IGZvcm1pbmcgYSBUSVBDIGNsdXN0ZXIgYmV0d2VlbiAyIG5vZGVzLg0KPiA+IA0KPiA+IFRoaXMg
aXMgdGhlIGJhc2ljIHN0ZXBzIEknbSBnb2luZyB0aHJvdWdoIG9uIGVhY2ggbm9kZS4NCj4gPiAN
Cj4gPiBtb2Rwcm9iZSB0aXBjDQo+ID4gaXAgbGluayBzZXQgZXRoMiB1cA0KPiA+IHRpcGMgbm9k
ZSBzZXQgYWRkciAxLjEuNSAjIG9yIDEuMS42DQo+ID4gdGlwYyBiZWFyZXIgZW5hYmxlIG1lZGlh
IGV0aCBkZXYgZXRoMA0KPiBldGgyLCBJIGFzc3VtZS4uLg0KPiANCg0KWWVzIHNvcnJ5IEkga2Vl
cCBzd2l0Y2hpbmcgYmV0d2VlbiBiZXR3ZWVuIEV0aGVybmV0IHBvcnRzIGZvciB0ZXN0aW5nDQpz
byBJIGhhbmQgZWRpdGVkIHRoZSBlbWFpbC4NCg0KPiA+IA0KPiA+IA0KPiA+IFRoZW4gdG8gY29u
ZmlybSBpZiB0aGUgY2x1c3RlciBpcyBmb3JtZWQgSSB1c2XCoHRpcGMgbGluayBsaXN0DQo+ID4g
DQo+ID4gW3Jvb3RAbm9kZS01IH5dIyB0aXBjIGxpbmsgbGlzdA0KPiA+IGJyb2FkY2FzdC1saW5r
OiB1cA0KPiA+IC4uLg0KPiA+IA0KPiA+IExvb2tpbmcgYXQgdGNwZHVtcCB0aGUgdHdvIG5vZGVz
IGFyZSBzZW5kaW5nIHBhY2tldHMNCj4gPiANCj4gPiAyMjozMDowNS43ODIzMjAgVElQQyB2Mi4w
IDEuMS41ID4gMC4wLjAsIGhlYWRlcmxlbmd0aCA2MCBieXRlcywNCj4gPiBNZXNzYWdlU2l6ZQ0K
PiA+IDc2IGJ5dGVzLCBOZWlnaGJvciBEZXRlY3Rpb24gUHJvdG9jb2wgaW50ZXJuYWwsIG1lc3Nh
Z2VUeXBlIExpbmsNCj4gPiByZXF1ZXN0DQo+ID4gMjI6MzA6MDUuODYzNTU1IFRJUEMgdjIuMCAx
LjEuNiA+IDAuMC4wLCBoZWFkZXJsZW5ndGggNjAgYnl0ZXMsDQo+ID4gTWVzc2FnZVNpemUNCj4g
PiA3NiBieXRlcywgTmVpZ2hib3IgRGV0ZWN0aW9uIFByb3RvY29sIGludGVybmFsLCBtZXNzYWdl
VHlwZSBMaW5rDQo+ID4gcmVxdWVzdA0KPiA+IA0KPiA+IEV2ZW50dWFsbHkgKGFmdGVyIGEgZmV3
IG1pbnV0ZXMpIHRoZSBsaW5rIGRvZXMgY29tZSB1cA0KPiA+IA0KPiA+IFtyb290QG5vZGUtNsKg
fl0jIHRpcGMgbGluayBsaXN0DQo+ID4gYnJvYWRjYXN0LWxpbms6IHVwDQo+ID4gMTAwMTAwNjpl
dGgyLTEwMDEwMDU6ZXRoMjogdXANCj4gPiANCj4gPiBbcm9vdEBub2RlLTXCoH5dIyB0aXBjIGxp
bmsgbGlzdA0KPiA+IGJyb2FkY2FzdC1saW5rOiB1cA0KPiA+IDEwMDEwMDU6ZXRoMi0xMDAxMDA2
OmV0aDI6IHVwDQo+ID4gDQo+ID4gV2hlbiBJIHJlbW92ZSB0aGUgInRpcGMgbm9kZSBzZXQgYWRk
ciIgdGhpbmdzIHNlZW0gdG8ga2ljayBpbnRvDQo+ID4gbGlmZSBzdHJhaWdodA0KPiA+IGF3YXkN
Cj4gPiANCj4gPiBbcm9vdEBub2RlLTUgfl0jIHRpcGMgbGluayBsaXN0DQo+ID4gYnJvYWRjYXN0
LWxpbms6IHVwDQo+ID4gMDA1MGI2MWJkMmFhOmV0aDItMDA1MGI2MWU2ZGZhOmV0aDI6IHVwDQo+
ID4gDQo+ID4gU28gdGhlcmUgYXBwZWFycyB0byBiZSBzb21lIGRpZmZlcmVuY2UgaW4gYmVoYXZp
b3VyIGJldHdlZW4gaGF2aW5nDQo+ID4gYW4NCj4gPiBleHBsaWNpdCBub2RlIGFkZHJlc3MgYW5k
IHVzaW5nIHRoZSBkZWZhdWx0LiBVbmZvcnR1bmF0ZWx5IG91cg0KPiA+IGFwcGxpY2F0aW9uDQo+
ID4gcmVsaWVzIG9uIHNldHRpbmcgdGhlIG5vZGUgYWRkcmVzc2VzLg0KPiBJIGRvIHRoaXMgbWFu
eSB0aW1lcyBhIGRheSwgd2l0aG91dCBhbnkgcHJvYmxlbXMuIElmIHRoZXJlIHdvdWxkIGJlDQo+
IGFueSB0aW1lIGRpZmZlcmVuY2UsIEkgd291bGQgZXhwZWN0IHRoZSAnYXV0byBjb25maWd1cmFi
bGUnIHZlcnNpb24NCj4gdG8gYmUgc2xvd2VyLCBiZWNhdXNlIGl0IGludm9sdmVzIGEgREFEIHN0
ZXAuDQo+IEFyZSB5b3Ugc3VyZSB5b3UgZG9uJ3QgaGF2ZSBhbnkgb3RoZXIgbm9kZXMgcnVubmlu
ZyBpbiB5b3VyIHN5c3RlbT8NCj4gDQo+IC8vL2pvbg0KPiANCg0KTm9wZSB0aGUgdHdvIG5vZGVz
IGFyZSBjb25uZWN0ZWQgYmFjayB0byBiYWNrLiBEb2VzIHRoZSBudW1iZXIgb2YNCkV0aGVybmV0
IGludGVyZmFjZXMgbWFrZSBhIGRpZmZlcmVuY2U/IEFzIHlvdSBjYW4gc2VlIEkndmUgZ290IDMg
b24NCmVhY2ggbm9kZS4gT25lIGlzIGNvbXBsZXRlbHkgZGlzY29ubmVjdGVkLCBvbmUgaXMgZm9y
IGJvb3Rpbmcgb3ZlciBURlRQDQrCoChvbmx5IHVzZWQgYnkgVS1ib290KSBhbmQgdGhlIG90aGVy
IGlzIHRoZSBVU0IgRXRoZXJuZXQgSSdtIHVzaW5nIGZvcg0KdGVzdGluZy4NCg0KPiANCj4gPiAN
Cj4gPiANCj4gPiBbcm9vdEBub2RlLTUgfl0jIHVuYW1lIC1hDQo+ID4gTGludXggbGludXhib3gg
NS4yLjAtYXQxKyAjOCBTTVAgVGh1IEp1bCAyNSAyMzoyMjo0MSBVVEMgMjAxOSBwcGMNCj4gPiBH
TlUvTGludXgNCj4gPiANCj4gPiBBbnkgdGhvdWdodHMgb24gdGhlIHByb2JsZW0/
