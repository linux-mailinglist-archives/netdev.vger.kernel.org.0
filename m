Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE0121E765
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 07:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725884AbgGNFTL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 01:19:11 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:35535 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbgGNFTK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 01:19:10 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 88D5B8066C;
        Tue, 14 Jul 2020 17:19:05 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1594703945;
        bh=Mc4G+gnU/cYqXz/xqWChVWJtgbs4Ab9aF2ovZGNcAAI=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=zvJl2Rz2WaDRyAxpSD7ysD2OdUl8FquahV2jb2VFb3uc1n9e2W3nHRnAp1z65Sa8D
         US6dd0yPnCYjR9yIRuhN4pVrFkk/gE6b3EnKxgkDtFb7WKaMtqeaUob6BRPRjSZ0j7
         Du+DXN90GgkrrlK76JBcS/xCdDKV2E60/1+AWI6j0QDGABaYVB1aGANS7FHjNHCAxx
         n0wuKcWcyzlG60TPdYm9qnlMYqCM2QWBjJa038PT3oYi3mSLbxKvSmts54Z+zmsUww
         mBhVeU/Gv6Y6DOL8J82PxIlAhIRTV5jLojQ1bLSEpNGGQIumIDYVffu2Kw8whDbhi4
         TsiKjEyC3wE9Q==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[10.32.16.77]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5f0d40490001>; Tue, 14 Jul 2020 17:19:05 +1200
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8)
 by svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8) with
 Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 14 Jul 2020 17:19:05 +1200
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.006; Tue, 14 Jul 2020 17:19:05 +1200
From:   Matt Bennett <Matt.Bennett@alliedtelesis.co.nz>
To:     "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "cyphar@cyphar.com" <cyphar@cyphar.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "christian.brauner@ubuntu.com" <christian.brauner@ubuntu.com>,
        "zbr@ioremap.net" <zbr@ioremap.net>,
        "containers@lists.linux-foundation.org" 
        <containers@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] RFC: connector: Add network namespace awareness
Thread-Topic: [PATCH 0/5] RFC: connector: Add network namespace awareness
Thread-Index: AQHWWURBQy6j4+2Gyk6f1OnPiziRbakFvJQAgAAETQA=
Date:   Tue, 14 Jul 2020 05:19:04 +0000
Message-ID: <0422c2f707746427a8542888d0058b6487324249.camel@alliedtelesis.co.nz>
References: <20200702002635.8169-1-matt.bennett@alliedtelesis.co.nz>
         <87h7uqukct.fsf@x220.int.ebiederm.org>
         <20200702191025.bqxqwsm6kwnhm2p7@wittgenstein>
         <2ab92386ce5293e423aa3f117572200239a7228b.camel@alliedtelesis.co.nz>
         <87tuyb9scl.fsf@x220.int.ebiederm.org>
         <20200714050340.d7llzo52exvmdubc@yavin.dot.cyphar.com>
In-Reply-To: <20200714050340.d7llzo52exvmdubc@yavin.dot.cyphar.com>
Accept-Language: en-US, en-NZ
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [2001:df5:b000:25:2e4d:54ff:fe4c:9ff0]
Content-Type: text/plain; charset="utf-8"
Content-ID: <6432E2F2AA5728459346A9D25048A582@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIwLTA3LTE0IGF0IDE1OjAzICsxMDAwLCBBbGVrc2EgU2FyYWkgd3JvdGU6DQo+
IE9uIDIwMjAtMDctMTMsIEVyaWMgVy4gQmllZGVybWFuIDxlYmllZGVybUB4bWlzc2lvbi5jb20+
IHdyb3RlOg0KPiA+IE1hdHQgQmVubmV0dCA8TWF0dC5CZW5uZXR0QGFsbGllZHRlbGVzaXMuY28u
bno+IHdyaXRlczoNCj4gPiANCj4gPiA+IE9uIFRodSwgMjAyMC0wNy0wMiBhdCAyMToxMCArMDIw
MCwgQ2hyaXN0aWFuIEJyYXVuZXIgd3JvdGU6DQo+ID4gPiA+IE9uIFRodSwgSnVsIDAyLCAyMDIw
IGF0IDA4OjE3OjM4QU0gLTA1MDAsIEVyaWMgVy4gQmllZGVybWFuIHdyb3RlOg0KPiA+ID4gPiA+
IE1hdHQgQmVubmV0dCA8bWF0dC5iZW5uZXR0QGFsbGllZHRlbGVzaXMuY28ubno+IHdyaXRlczoN
Cj4gPiA+ID4gPiANCj4gPiA+ID4gPiA+IFByZXZpb3VzbHkgdGhlIGNvbm5lY3RvciBmdW5jdGlv
bmFsaXR5IGNvdWxkIG9ubHkgYmUgdXNlZCBieSBwcm9jZXNzZXMgcnVubmluZyBpbiB0aGUNCj4g
PiA+ID4gPiA+IGRlZmF1bHQgbmV0d29yayBuYW1lc3BhY2UuIFRoaXMgbWVhbnQgdGhhdCBhbnkg
cHJvY2VzcyB0aGF0IHVzZXMgdGhlIGNvbm5lY3RvciBmdW5jdGlvbmFsaXR5DQo+ID4gPiA+ID4g
PiBjb3VsZCBub3Qgb3BlcmF0ZSBjb3JyZWN0bHkgd2hlbiBydW4gaW5zaWRlIGEgY29udGFpbmVy
LiBUaGlzIGlzIGEgZHJhZnQgcGF0Y2ggc2VyaWVzIHRoYXQNCj4gPiA+ID4gPiA+IGF0dGVtcHRz
IHRvIG5vdyBhbGxvdyB0aGlzIGZ1bmN0aW9uYWxpdHkgb3V0c2lkZSBvZiB0aGUgZGVmYXVsdCBu
ZXR3b3JrIG5hbWVzcGFjZS4NCj4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gSSBzZWUgdGhpcyBo
YXMgYmVlbiBkaXNjdXNzZWQgcHJldmlvdXNseSBbMV0sIGJ1dCBhbSBub3Qgc3VyZSBob3cgbXkg
Y2hhbmdlcyByZWxhdGUgdG8gYWxsDQo+ID4gPiA+ID4gPiBvZiB0aGUgdG9waWNzIGRpc2N1c3Nl
ZCB0aGVyZSBhbmQvb3IgaWYgdGhlcmUgYXJlIGFueSB1bmludGVuZGVkIHNpZGUgZWZmZWN0cyBm
cm9tIG15IGRyYWZ0DQo+ID4gPiA+ID4gPiBjaGFuZ2VzLg0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+
IElzIHRoZXJlIGEgcGllY2Ugb2Ygc29mdHdhcmUgdGhhdCB1c2VzIGNvbm5lY3RvciB0aGF0IHlv
dSB3YW50IHRvIGdldA0KPiA+ID4gPiA+IHdvcmtpbmcgaW4gY29udGFpbmVycz8NCj4gPiA+IA0K
PiA+ID4gV2UgaGF2ZSBhbiBJUEMgc3lzdGVtIFsxXSB3aGVyZSBwcm9jZXNzZXMgY2FuIHJlZ2lz
dGVyIHRoZWlyIHNvY2tldA0KPiA+ID4gZGV0YWlscyAodW5peCwgdGNwLCB0aXBjLCAuLi4pIHRv
IGEgJ21vbml0b3InIHByb2Nlc3MuIFByb2Nlc3NlcyBjYW4NCj4gPiA+IHRoZW4gZ2V0IG5vdGlm
aWVkIHdoZW4gb3RoZXIgcHJvY2Vzc2VzIHRoZXkgYXJlIGludGVyZXN0ZWQgaW4NCj4gPiA+IHN0
YXJ0L3N0b3AgdGhlaXIgc2VydmVycyBhbmQgdXNlIHRoZSByZWdpc3RlcmVkIGRldGFpbHMgdG8g
Y29ubmVjdCB0bw0KPiA+ID4gdGhlbS4gRXZlcnl0aGluZyB3b3JrcyB1bmxlc3MgYSBwcm9jZXNz
IGNyYXNoZXMsIGluIHdoaWNoIGNhc2UgdGhlDQo+ID4gPiBtb25pdG9yaW5nIHByb2Nlc3MgbmV2
ZXIgcmVtb3ZlcyB0aGVpciBkZXRhaWxzLiBUaGVyZWZvcmUgdGhlDQo+ID4gPiBtb25pdG9yaW5n
IHByb2Nlc3MgdXNlcyB0aGUgY29ubmVjdG9yIGZ1bmN0aW9uYWxpdHkgd2l0aA0KPiA+ID4gUFJP
Q19FVkVOVF9FWElUIHRvIGRldGVjdCB3aGVuIGEgcHJvY2VzcyBjcmFzaGVzIGFuZCByZW1vdmVz
IHRoZQ0KPiA+ID4gZGV0YWlscyBpZiBpdCBpcyBhIHByZXZpb3VzbHkgcmVnaXN0ZXJlZCBQSUQu
DQo+ID4gPiANCj4gPiA+IFRoaXMgd2FzIHdvcmtpbmcgZm9yIHVzIHVudGlsIHdlIHRyaWVkIHRv
IHJ1biBvdXIgc3lzdGVtIGluIGEgY29udGFpbmVyLg0KPiA+ID4gDQo+ID4gPiA+ID4gDQo+ID4g
PiA+ID4gSSBhbSBjdXJpb3VzIHdoYXQgdGhlIG1vdGl2YXRpb24gaXMgYmVjYXVzZSB1cCB1bnRp
bCBub3cgdGhlcmUgaGFzIGJlZW4NCj4gPiA+ID4gPiBub3RoaW5nIHZlcnkgaW50ZXJlc3Rpbmcg
dXNpbmcgdGhpcyBmdW5jdGlvbmFsaXR5LiAgU28gaXQgaGFzbid0IGJlZW4NCj4gPiA+ID4gPiB3
b3J0aCBhbnlvbmUncyB0aW1lIHRvIG1ha2UgdGhlIG5lY2Vzc2FyeSBjaGFuZ2VzIHRvIHRoZSBj
b2RlLg0KPiA+ID4gPiANCj4gPiA+ID4gSW1obywgd2Ugc2hvdWxkIGp1c3Qgc3RhdGUgb25jZSBh
bmQgZm9yIGFsbCB0aGF0IHRoZSBwcm9jIGNvbm5lY3RvciB3aWxsDQo+ID4gPiA+IG5vdCBiZSBu
YW1lc3BhY2VkLiBUaGlzIGlzIHN1Y2ggYSBjb3JuZXItY2FzZSB0aGluZyBhbmQgaGFzIGJlZW4N
Cj4gPiA+ID4gbm9uLW5hbWVzcGFjZWQgZm9yIHN1Y2ggYSBsb25nIHRpbWUgd2l0aG91dCBjb25z
aXN0ZW50IHB1c2ggZm9yIGl0IHRvIGJlDQo+ID4gPiA+IG5hbWVzcGFjZWQgY29tYmluZWQgd2l0
aCB0aGUgZmFjdCB0aGF0IHRoaXMgbmVlZHMgcXVpdGUgc29tZSBjb2RlIHRvDQo+ID4gPiA+IG1h
a2UgaXQgd29yayBjb3JyZWN0bHkgdGhhdCBJIGZlYXIgd2UgZW5kIHVwIGJ1eWluZyBtb3JlIGJ1
Z3MgdGhhbiB3ZSdyZQ0KPiA+ID4gPiBzZWxsaW5nIGZlYXR1cmVzLiBBbmQgcmVhbGlzdGljYWxs
eSwgeW91IGFuZCBJIHdpbGwgZW5kIHVwIG1haW50YWluaW5nDQo+ID4gPiA+IHRoaXMgYW5kIEkg
ZmVlbCB0aGlzIGlzIG5vdCB3b3J0aCB0aGUgdGltZSg/KS4gTWF5YmUgSSdtIGJlaW5nIHRvbw0K
PiA+ID4gPiBwZXNzaW1pc3RpYyB0aG91Z2guDQo+ID4gPiA+IA0KPiA+ID4gDQo+ID4gPiBGYWly
IGVub3VnaC4gSSBjYW4gY2VydGFpbmx5IGxvb2sgZm9yIGFub3RoZXIgd2F5IHRvIGRldGVjdCBw
cm9jZXNzDQo+ID4gPiBjcmFzaGVzLiBJbnRlcmVzdGluZ2x5IEkgZm91bmQgYSBwYXRjaCBzZXQg
WzJdIG9uIHRoZSBtYWlsaW5nIGxpc3QNCj4gPiA+IHRoYXQgYXR0ZW1wdHMgdG8gc29sdmUgdGhl
IHByb2JsZW0gSSB3aXNoIHRvIHNvbHZlLCBidXQgaXQgZG9lc24ndA0KPiA+ID4gbG9vayBsaWtl
IHRoZSBwYXRjaGVzIHdlcmUgZXZlciBkZXZlbG9wZWQgZnVydGhlci4gRnJvbSByZWFkaW5nIHRo
ZQ0KPiA+ID4gZGlzY3Vzc2lvbiB0aHJlYWQgb24gdGhhdCBwYXRjaCBzZXQgaXQgYXBwZWFycyB0
aGF0IEkgc2hvdWxkIGJlIGRvaW5nDQo+ID4gPiBzb21lIGZvcm0gb2YgcG9sbGluZyBvbiB0aGUg
L3Byb2MgZmlsZXMuDQo+ID4gDQo+ID4gUmVjZW50bHkgQ2hyaXN0aWFuIEJyYXVuZXIgaW1wbGVt
ZW50ZWQgcGlkZmQgY29tcGxldGUgd2l0aCBhIHBvbGwNCj4gPiBvcGVyYXRpb24gdGhhdCByZXBv
cnRzIHdoZW4gYSBwcm9jZXNzIHRlcm1pbmF0ZXMuDQo+ID4gDQo+ID4gSWYgeW91IGFyZSB3aWxs
aW5nIHRvIGNoYW5nZSB5b3VyIHVzZXJzcGFjZSBjb2RlIHN3aXRjaGluZyB0byBwaWRmZA0KPiA+
IHNob3VsZCBiZSBhbGwgdGhhdCB5b3UgbmVlZC4NCj4gDQo+IFdoaWxlIHRoaXMgZG9lcyBzb2x2
ZSB0aGUgcHJvYmxlbSBvZiBnZXR0aW5nIGV4aXQgbm90aWZpY2F0aW9ucyBpbg0KPiBnZW5lcmFs
LCB5b3UgY2Fubm90IGdldCB0aGUgZXhpdCBjb2RlLiBCdXQgaWYgdGhleSBkb24ndCBjYXJlIGFi
b3V0IHRoYXQNCj4gdGhlbiB3ZSBjYW4gc29sdmUgdGhhdCBwcm9ibGVtIGFub3RoZXIgdGltZS4g
OkQNCj4gDQoNCkZyb20gZmlyc3QgZ2xhbmNlIHVzaW5nIHBpZGZkIHdpbGwgZG8gZXhhY3RseSB3
aGF0IHdlIG5lZWQuIE5vdCBiZWluZyBhYmxlDQp0byBnZXQgdGhlIGV4aXQgY29kZSB3aWxsIG5v
dCBiZSBhbiBpc3N1ZS4gSW4gZmFjdCBJIHRoaW5rIGl0IHdpbGwgYmUgYW4NCmltcHJvdmVtZW50
IG92ZXIgdGhlIGNvbm5lY3RvciBhcyB0aGUgbGlzdGVuZXIgd2lsbCBub3cgb25seSBiZSB3YWl0
aW5nIGZvcg0KdGhlIFBJRHMgd2UgYWN0dWFsbHkgY2FyZSBhYm91dCAtIHJhdGhlciB0aGFuIGdl
dHRpbmcgd29rZW4gdXAgb24gZXZlcnkgc2luZ2xlDQpwcm9jZXNzIGV4aXQgYW5kIGhhdmluZyB0
byBjaGVjayBpZiBpdCBjYXJlcyBhYm91dCB0aGUgUElELg0KDQpNYW55IHRoYW5rcyBFcmljIGFu
ZCBvdGhlcnMsDQpNYXR0DQoNCg0K
