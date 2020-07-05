Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF0D215032
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 00:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727991AbgGEWcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 18:32:10 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:51390 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727884AbgGEWcJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 18:32:09 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 42B2D891B2;
        Mon,  6 Jul 2020 10:32:07 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1593988327;
        bh=dDSXJT8ZmkfwL4nN3FCTagh8+FFsShlaCKuf7R566MM=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=PLoJucDikFcKtTBiAjSYlwDRs2cYkHP9nKtBQfZJ4dMzOxaKIqB3YImIr9G0sjMwg
         WfdA19dEnQYiBAJmAep0b14XzJvGDYYflq178wOvKI0CW1z/MaeqRwfI2OwI/Yy0I4
         i8+neexCOjLnfM4cfG78EE+EpLdiT0GCxEI5mjWSRb9lDD/+m/Mbo6NvBBHm8QeAB1
         XbUHAyVLuZjMllCsx/JdXo4WCiA4jleDKzVS6GPH6vyPEPaHlXdnViRDr32oNXsuME
         haRJ4FvOPlH7Rqd222Eo007Gm+EnRCZM3YekKDnyHYLCrk4yQYzIG1RrOaZ8ZIjoU1
         kmvLq1gO61pSw==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[10.32.16.77]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5f0254e60001>; Mon, 06 Jul 2020 10:32:06 +1200
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) by
 svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Mon, 6 Jul 2020 10:32:06 +1200
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.006; Mon, 6 Jul 2020 10:32:06 +1200
From:   Matt Bennett <Matt.Bennett@alliedtelesis.co.nz>
To:     "christian.brauner@ubuntu.com" <christian.brauner@ubuntu.com>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "containers@lists.linux-foundation.org" 
        <containers@lists.linux-foundation.org>,
        "zbr@ioremap.net" <zbr@ioremap.net>
Subject: Re: [PATCH 0/5] RFC: connector: Add network namespace awareness
Thread-Topic: [PATCH 0/5] RFC: connector: Add network namespace awareness
Thread-Index: AQHWUAeZm1sYS5RHpkWGl2iqUbu926j0R5li//+YDoCABO9YAA==
Date:   Sun, 5 Jul 2020 22:32:06 +0000
Message-ID: <2ab92386ce5293e423aa3f117572200239a7228b.camel@alliedtelesis.co.nz>
References: <20200702002635.8169-1-matt.bennett@alliedtelesis.co.nz>
         <87h7uqukct.fsf@x220.int.ebiederm.org>
         <20200702191025.bqxqwsm6kwnhm2p7@wittgenstein>
In-Reply-To: <20200702191025.bqxqwsm6kwnhm2p7@wittgenstein>
Accept-Language: en-US, en-NZ
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [2001:df5:b000:25:2e4d:54ff:fe4c:9ff0]
Content-Type: text/plain; charset="utf-8"
Content-ID: <CCAFF0781A4AFE4190B84AFFE179D819@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIwLTA3LTAyIGF0IDIxOjEwICswMjAwLCBDaHJpc3RpYW4gQnJhdW5lciB3cm90
ZToNCj4gT24gVGh1LCBKdWwgMDIsIDIwMjAgYXQgMDg6MTc6MzhBTSAtMDUwMCwgRXJpYyBXLiBC
aWVkZXJtYW4gd3JvdGU6DQo+ID4gTWF0dCBCZW5uZXR0IDxtYXR0LmJlbm5ldHRAYWxsaWVkdGVs
ZXNpcy5jby5uej4gd3JpdGVzOg0KPiA+IA0KPiA+ID4gUHJldmlvdXNseSB0aGUgY29ubmVjdG9y
IGZ1bmN0aW9uYWxpdHkgY291bGQgb25seSBiZSB1c2VkIGJ5IHByb2Nlc3NlcyBydW5uaW5nIGlu
IHRoZQ0KPiA+ID4gZGVmYXVsdCBuZXR3b3JrIG5hbWVzcGFjZS4gVGhpcyBtZWFudCB0aGF0IGFu
eSBwcm9jZXNzIHRoYXQgdXNlcyB0aGUgY29ubmVjdG9yIGZ1bmN0aW9uYWxpdHkNCj4gPiA+IGNv
dWxkIG5vdCBvcGVyYXRlIGNvcnJlY3RseSB3aGVuIHJ1biBpbnNpZGUgYSBjb250YWluZXIuIFRo
aXMgaXMgYSBkcmFmdCBwYXRjaCBzZXJpZXMgdGhhdA0KPiA+ID4gYXR0ZW1wdHMgdG8gbm93IGFs
bG93IHRoaXMgZnVuY3Rpb25hbGl0eSBvdXRzaWRlIG9mIHRoZSBkZWZhdWx0IG5ldHdvcmsgbmFt
ZXNwYWNlLg0KPiA+ID4gDQo+ID4gPiBJIHNlZSB0aGlzIGhhcyBiZWVuIGRpc2N1c3NlZCBwcmV2
aW91c2x5IFsxXSwgYnV0IGFtIG5vdCBzdXJlIGhvdyBteSBjaGFuZ2VzIHJlbGF0ZSB0byBhbGwN
Cj4gPiA+IG9mIHRoZSB0b3BpY3MgZGlzY3Vzc2VkIHRoZXJlIGFuZC9vciBpZiB0aGVyZSBhcmUg
YW55IHVuaW50ZW5kZWQgc2lkZSBlZmZlY3RzIGZyb20gbXkgZHJhZnQNCj4gPiA+IGNoYW5nZXMu
DQo+ID4gDQo+ID4gSXMgdGhlcmUgYSBwaWVjZSBvZiBzb2Z0d2FyZSB0aGF0IHVzZXMgY29ubmVj
dG9yIHRoYXQgeW91IHdhbnQgdG8gZ2V0DQo+ID4gd29ya2luZyBpbiBjb250YWluZXJzPw0KDQpX
ZSBoYXZlIGFuIElQQyBzeXN0ZW0gWzFdIHdoZXJlIHByb2Nlc3NlcyBjYW4gcmVnaXN0ZXIgdGhl
aXIgc29ja2V0IGRldGFpbHMgKHVuaXgsIHRjcCwgdGlwYywgLi4uKSB0byBhICdtb25pdG9yJyBw
cm9jZXNzLiBQcm9jZXNzZXMgY2FuIHRoZW4gZ2V0DQpub3RpZmllZCAgd2hlbiBvdGhlciBwcm9j
ZXNzZXMgdGhleSBhcmUgaW50ZXJlc3RlZCBpbiBzdGFydC9zdG9wIHRoZWlyIHNlcnZlcnMgYW5k
IHVzZSB0aGUgcmVnaXN0ZXJlZCBkZXRhaWxzIHRvIGNvbm5lY3QgdG8gdGhlbS4gRXZlcnl0aGlu
ZyB3b3Jrcw0KdW5sZXNzIGEgcHJvY2VzcyBjcmFzaGVzLCBpbiB3aGljaCBjYXNlIHRoZSBtb25p
dG9yaW5nIHByb2Nlc3MgbmV2ZXIgcmVtb3ZlcyB0aGVpciBkZXRhaWxzLiBUaGVyZWZvcmUgdGhl
IG1vbml0b3JpbmcgcHJvY2VzcyB1c2VzIHRoZSBjb25uZWN0b3INCmZ1bmN0aW9uYWxpdHkgd2l0
aCBQUk9DX0VWRU5UX0VYSVQgdG8gZGV0ZWN0IHdoZW4gYSBwcm9jZXNzIGNyYXNoZXMgYW5kIHJl
bW92ZXMgdGhlIGRldGFpbHMgaWYgaXQgaXMgYSBwcmV2aW91c2x5IHJlZ2lzdGVyZWQgUElELg0K
DQpUaGlzIHdhcyB3b3JraW5nIGZvciB1cyB1bnRpbCB3ZSB0cmllZCB0byBydW4gb3VyIHN5c3Rl
bSBpbiBhIGNvbnRhaW5lci4NCg0KPiA+IA0KPiA+IEkgYW0gY3VyaW91cyB3aGF0IHRoZSBtb3Rp
dmF0aW9uIGlzIGJlY2F1c2UgdXAgdW50aWwgbm93IHRoZXJlIGhhcyBiZWVuDQo+ID4gbm90aGlu
ZyB2ZXJ5IGludGVyZXN0aW5nIHVzaW5nIHRoaXMgZnVuY3Rpb25hbGl0eS4gIFNvIGl0IGhhc24n
dCBiZWVuDQo+ID4gd29ydGggYW55b25lJ3MgdGltZSB0byBtYWtlIHRoZSBuZWNlc3NhcnkgY2hh
bmdlcyB0byB0aGUgY29kZS4NCj4gDQo+IEltaG8sIHdlIHNob3VsZCBqdXN0IHN0YXRlIG9uY2Ug
YW5kIGZvciBhbGwgdGhhdCB0aGUgcHJvYyBjb25uZWN0b3Igd2lsbA0KPiBub3QgYmUgbmFtZXNw
YWNlZC4gVGhpcyBpcyBzdWNoIGEgY29ybmVyLWNhc2UgdGhpbmcgYW5kIGhhcyBiZWVuDQo+IG5v
bi1uYW1lc3BhY2VkIGZvciBzdWNoIGEgbG9uZyB0aW1lIHdpdGhvdXQgY29uc2lzdGVudCBwdXNo
IGZvciBpdCB0byBiZQ0KPiBuYW1lc3BhY2VkIGNvbWJpbmVkIHdpdGggdGhlIGZhY3QgdGhhdCB0
aGlzIG5lZWRzIHF1aXRlIHNvbWUgY29kZSB0bw0KPiBtYWtlIGl0IHdvcmsgY29ycmVjdGx5IHRo
YXQgSSBmZWFyIHdlIGVuZCB1cCBidXlpbmcgbW9yZSBidWdzIHRoYW4gd2UncmUNCj4gc2VsbGlu
ZyBmZWF0dXJlcy4gQW5kIHJlYWxpc3RpY2FsbHksIHlvdSBhbmQgSSB3aWxsIGVuZCB1cCBtYWlu
dGFpbmluZw0KPiB0aGlzIGFuZCBJIGZlZWwgdGhpcyBpcyBub3Qgd29ydGggdGhlIHRpbWUoPyku
IE1heWJlIEknbSBiZWluZyB0b28NCj4gcGVzc2ltaXN0aWMgdGhvdWdoLg0KPiANCg0KRmFpciBl
bm91Z2guIEkgY2FuIGNlcnRhaW5seSBsb29rIGZvciBhbm90aGVyIHdheSB0byBkZXRlY3QgcHJv
Y2VzcyBjcmFzaGVzLiBJbnRlcmVzdGluZ2x5IEkgZm91bmQgYSBwYXRjaCBzZXQgWzJdIG9uIHRo
ZSBtYWlsaW5nIGxpc3QgdGhhdCBhdHRlbXB0cw0KdG8gc29sdmUgdGhlIHByb2JsZW0gSSB3aXNo
IHRvIHNvbHZlLCBidXQgaXQgZG9lc24ndCBsb29rIGxpa2UgdGhlIHBhdGNoZXMgd2VyZSBldmVy
IGRldmVsb3BlZCBmdXJ0aGVyLiBGcm9tIHJlYWRpbmcgdGhlIGRpc2N1c3Npb24gdGhyZWFkIG9u
IHRoYXQNCnBhdGNoIHNldCBpdCBhcHBlYXJzIHRoYXQgSSBzaG91bGQgYmUgZG9pbmcgc29tZSBm
b3JtIG9mIHBvbGxpbmcgb24gdGhlIC9wcm9jIGZpbGVzLg0KDQpCZXN0IHJlZ2FyZHMsDQpNYXR0
DQoNClsxXSBodHRwczovL2dpdGh1Yi5jb20vYWxsaWVkdGVsZXNpcy9jbXNnL2Jsb2IvbWFzdGVy
L2Ntc2cvc3JjL3NlcnZpY2VfbGlzdGVuZXIvbmV0bGluay5jI0w2MQ0KWzJdIGh0dHBzOi8vbGtt
bC5vcmcvbGttbC8yMDE4LzEwLzI5LzYzOA0KDQo=
