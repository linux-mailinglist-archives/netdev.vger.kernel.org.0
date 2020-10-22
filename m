Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21048295BC4
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 11:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895407AbgJVJ2U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 05:28:20 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:38634 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2895903AbgJVJ2T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 05:28:19 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-274-znM0PVqyMcS7eXta51waCQ-1; Thu, 22 Oct 2020 10:28:14 +0100
X-MC-Unique: znM0PVqyMcS7eXta51waCQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 22 Oct 2020 10:28:13 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 22 Oct 2020 10:28:13 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'David Hildenbrand' <david@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>
CC:     Al Viro <viro@zeniv.linux.org.uk>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Christoph Hellwig <hch@lst.de>,
        "kernel-team@android.com" <kernel-team@android.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
        David Howells <dhowells@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>
Subject: RE: Buggy commit tracked to: "Re: [PATCH 2/9] iov_iter: move
 rw_copy_check_uvector() into lib/iov_iter.c"
Thread-Topic: Buggy commit tracked to: "Re: [PATCH 2/9] iov_iter: move
 rw_copy_check_uvector() into lib/iov_iter.c"
Thread-Index: AQHWqE5GNDfnH4y9nkGWtfqJueR1KKmjTCJQgAAMKYSAAABcMA==
Date:   Thu, 22 Oct 2020 09:28:13 +0000
Message-ID: <d9fda4834bbf4e708e7d55e7dd09f6c9@AcuMS.aculab.com>
References: <20200925045146.1283714-1-hch@lst.de>
 <20200925045146.1283714-3-hch@lst.de> <20201021161301.GA1196312@kroah.com>
 <20201021233914.GR3576660@ZenIV.linux.org.uk>
 <20201022082654.GA1477657@kroah.com>
 <80a2e5fa-718a-8433-1ab0-dd5b3e3b5416@redhat.com>
 <5d2ecb24db1e415b8ff88261435386ec@AcuMS.aculab.com>
 <df2e0758-b8ed-5aec-6adc-a18f499c0179@redhat.com>
 <20201022090155.GA1483166@kroah.com>
 <e04d0c5d-e834-a15b-7844-44dcc82785cc@redhat.com>
In-Reply-To: <e04d0c5d-e834-a15b-7844-44dcc82785cc@redhat.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRGF2aWQgSGlsZGVuYnJhbmQNCj4gU2VudDogMjIgT2N0b2JlciAyMDIwIDEwOjE5DQo+
IA0KPiBPbiAyMi4xMC4yMCAxMTowMSwgR3JlZyBLSCB3cm90ZToNCj4gPiBPbiBUaHUsIE9jdCAy
MiwgMjAyMCBhdCAxMDo0ODo1OUFNICswMjAwLCBEYXZpZCBIaWxkZW5icmFuZCB3cm90ZToNCj4g
Pj4gT24gMjIuMTAuMjAgMTA6NDAsIERhdmlkIExhaWdodCB3cm90ZToNCj4gPj4+IEZyb206IERh
dmlkIEhpbGRlbmJyYW5kDQo+ID4+Pj4gU2VudDogMjIgT2N0b2JlciAyMDIwIDA5OjM1DQo+ID4+
Pj4NCj4gPj4+PiBPbiAyMi4xMC4yMCAxMDoyNiwgR3JlZyBLSCB3cm90ZToNCj4gPj4+Pj4gT24g
VGh1LCBPY3QgMjIsIDIwMjAgYXQgMTI6Mzk6MTRBTSArMDEwMCwgQWwgVmlybyB3cm90ZToNCj4g
Pj4+Pj4+IE9uIFdlZCwgT2N0IDIxLCAyMDIwIGF0IDA2OjEzOjAxUE0gKzAyMDAsIEdyZWcgS0gg
d3JvdGU6DQo+ID4+Pj4+Pj4gT24gRnJpLCBTZXAgMjUsIDIwMjAgYXQgMDY6NTE6MzlBTSArMDIw
MCwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+ID4+Pj4+Pj4+IEZyb206IERhdmlkIExhaWdo
dCA8RGF2aWQuTGFpZ2h0QEFDVUxBQi5DT00+DQo+ID4+Pj4+Pj4+DQo+ID4+Pj4+Pj4+IFRoaXMg
bGV0cyB0aGUgY29tcGlsZXIgaW5saW5lIGl0IGludG8gaW1wb3J0X2lvdmVjKCkgZ2VuZXJhdGlu
Zw0KPiA+Pj4+Pj4+PiBtdWNoIGJldHRlciBjb2RlLg0KPiA+Pj4+Pj4+Pg0KPiA+Pj4+Pj4+PiBT
aWduZWQtb2ZmLWJ5OiBEYXZpZCBMYWlnaHQgPGRhdmlkLmxhaWdodEBhY3VsYWIuY29tPg0KPiA+
Pj4+Pj4+PiBTaWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5kZT4NCj4g
Pj4+Pj4+Pj4gLS0tDQo+ID4+Pj4+Pj4+ICBmcy9yZWFkX3dyaXRlLmMgfCAxNzkgLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+ID4+Pj4+Pj4+ICBsaWIv
aW92X2l0ZXIuYyAgfCAxNzYgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysNCj4gPj4+Pj4+Pj4gIDIgZmlsZXMgY2hhbmdlZCwgMTc2IGluc2VydGlvbnMoKyks
IDE3OSBkZWxldGlvbnMoLSkNCj4gPj4+Pj4+Pg0KPiA+Pj4+Pj4+IFN0cmFuZ2VseSwgdGhpcyBj
b21taXQgY2F1c2VzIGEgcmVncmVzc2lvbiBpbiBMaW51cydzIHRyZWUgcmlnaHQgbm93Lg0KPiA+
Pj4+Pj4+DQo+ID4+Pj4+Pj4gSSBjYW4ndCByZWFsbHkgZmlndXJlIG91dCB3aGF0IHRoZSByZWdy
ZXNzaW9uIGlzLCBvbmx5IHRoYXQgdGhpcyBjb21taXQNCj4gPj4+Pj4+PiB0cmlnZ2VycyBhICJs
YXJnZSBBbmRyb2lkIHN5c3RlbSBiaW5hcnkiIGZyb20gd29ya2luZyBwcm9wZXJseS4gIFRoZXJl
J3MNCj4gPj4+Pj4+PiBubyBrZXJuZWwgbG9nIG1lc3NhZ2VzIGFueXdoZXJlLCBhbmQgSSBkb24n
dCBoYXZlIGFueSB3YXkgdG8gc3RyYWNlIHRoZQ0KPiA+Pj4+Pj4+IHRoaW5nIGluIHRoZSB0ZXN0
aW5nIGZyYW1ld29yaywgc28gYW55IGhpbnRzIHRoYXQgcGVvcGxlIGNhbiBwcm92aWRlDQo+ID4+
Pj4+Pj4gd291bGQgYmUgbW9zdCBhcHByZWNpYXRlZC4NCj4gPj4+Pj4+DQo+ID4+Pj4+PiBJdCdz
IGEgcHVyZSBtb3ZlIC0gbW9kdWxvIGNoYW5nZWQgbGluZSBicmVha3MgaW4gdGhlIGFyZ3VtZW50
IGxpc3RzDQo+ID4+Pj4+PiB0aGUgZnVuY3Rpb25zIGludm9sdmVkIGFyZSBpZGVudGljYWwgYmVm
b3JlIGFuZCBhZnRlciB0aGF0IChqdXN0IGNoZWNrZWQNCj4gPj4+Pj4+IHRoYXQgZGlyZWN0bHks
IGJ5IGNoZWNraW5nIG91dCB0aGUgdHJlZXMgYmVmb3JlIGFuZCBhZnRlciwgZXh0cmFjdGluZyB0
d28NCj4gPj4+Pj4+IGZ1bmN0aW9ucyBpbiBxdWVzdGlvbiBmcm9tIGZzL3JlYWRfd3JpdGUuYyBh
bmQgbGliL2lvdl9pdGVyLmMgKGJlZm9yZSBhbmQNCj4gPj4+Pj4+IGFmdGVyLCByZXNwLikgYW5k
IGNoZWNraW5nIHRoZSBkaWZmIGJldHdlZW4gdGhvc2UuDQo+ID4+Pj4+Pg0KPiA+Pj4+Pj4gSG93
IGNlcnRhaW4gaXMgeW91ciBiaXNlY3Rpb24/DQo+ID4+Pj4+DQo+ID4+Pj4+IFRoZSBiaXNlY3Rp
b24gaXMgdmVyeSByZXByb2R1Y2FibGUuDQo+ID4+Pj4+DQo+ID4+Pj4+IEJ1dCwgdGhpcyBsb29r
cyBub3cgdG8gYmUgYSBjb21waWxlciBidWcuICBJJ20gdXNpbmcgdGhlIGxhdGVzdCB2ZXJzaW9u
DQo+ID4+Pj4+IG9mIGNsYW5nIGFuZCBpZiBJIHB1dCAibm9pbmxpbmUiIGF0IHRoZSBmcm9udCBv
ZiB0aGUgZnVuY3Rpb24sDQo+ID4+Pj4+IGV2ZXJ5dGhpbmcgd29ya3MuDQo+ID4+Pj4NCj4gPj4+
PiBXZWxsLCB0aGUgY29tcGlsZXIgY2FuIGRvIG1vcmUgaW52YXNpdmUgb3B0aW1pemF0aW9ucyB3
aGVuIGlubGluaW5nLiBJZg0KPiA+Pj4+IHlvdSBoYXZlIGJ1Z2d5IGNvZGUgdGhhdCByZWxpZXMg
b24gc29tZSB1bnNwZWNpZmllZCBiZWhhdmlvciwgaW5saW5pbmcNCj4gPj4+PiBjYW4gY2hhbmdl
IHRoZSBiZWhhdmlvciAuLi4gYnV0IGdvaW5nIG92ZXIgdGhhdCBjb2RlLCB0aGVyZSBpc24ndCB0
b28NCj4gPj4+PiBtdWNoIGFjdGlvbiBnb2luZyBvbi4gQXQgbGVhc3Qgbm90aGluZyBzY3JlYW1l
ZCBhdCBtZS4NCj4gPj4+DQo+ID4+PiBBcGFydCBmcm9tIGFsbCB0aGUgb3B0aW1pc2F0aW9ucyB0
aGF0IGdldCByaWQgb2ZmIHRoZSAncGFzcyBiZSByZWZlcmVuY2UnDQo+ID4+PiBwYXJhbWV0ZXJz
IGFuZCBzdHJhbmdlIGNvbmRpdGlvbmFsIHRlc3RzLg0KPiA+Pj4gUGxlbnR5IG9mIHNjb3BlIGZv
ciB0aGUgY29tcGlsZXIgZ2V0dGluZyBpdCB3cm9uZy4NCj4gPj4+IEJ1dCBub3RoaW5nIGV2ZW4g
dmFndWVseSBpbGxlZ2FsLg0KPiA+Pg0KPiA+PiBOb3QgdGhlIGZpcnN0IHRpbWUgdGhhdCBwZW9w
bGUgYmxhbWUgdGhlIGNvbXBpbGVyIHRvIHRoZW4gZmlndXJlIG91dA0KPiA+PiB0aGF0IHNvbWV0
aGluZyBlbHNlIGlzIHdyb25nIC4uLiBidXQgbWF5YmUgdGhpcyB0aW1lIGlzIGRpZmZlcmVudCA6
KQ0KPiA+DQo+ID4gSSBhZ3JlZSwgSSBoYXRlIHRvIGJsYW1lIHRoZSBjb21waWxlciwgdGhhdCdz
IGFsbW9zdCBuZXZlciB0aGUgcmVhbA0KPiA+IHByb2JsZW0sIGJ1dCB0aGlzIG9uZSBzdXJlICJm
ZWVscyIgbGlrZSBpdC4NCj4gPg0KPiA+IEknbSBydW5uaW5nIHNvbWUgbW9yZSB0ZXN0cywgdHJ5
aW5nIHRvIG5hcnJvdyB0aGluZ3MgZG93biBhcyBqdXN0IGFkZGluZw0KPiA+IGEgIm5vaW5saW5l
IiB0byB0aGUgZnVuY3Rpb24gdGhhdCBnb3QgbW92ZWQgaGVyZSBkb2Vzbid0IHdvcmsgb24gTGlu
dXMncw0KPiA+IHRyZWUgYXQgdGhlIG1vbWVudCBiZWNhdXNlIHRoZSBmdW5jdGlvbiB3YXMgc3Bs
aXQgaW50byBtdWx0aXBsZQ0KPiA+IGZ1bmN0aW9ucy4NCj4gPg0KPiA+IEdpdmUgbWUgYSBmZXcg
aG91cnMuLi4NCj4gDQo+IEkgbWlnaHQgYmUgd3JvbmcgYnV0DQo+IA0KPiBhKSBpbXBvcnRfaW92
ZWMoKSB1c2VzOg0KPiAtIHVuc2lnbmVkIG5yX3NlZ3MgLT4gaW50DQo+IC0gdW5zaWduZWQgZmFz
dF9zZWdzIC0+IGludA0KPiBiKSByd19jb3B5X2NoZWNrX3V2ZWN0b3IoKSB1c2VzOg0KPiAtIHVu
c2lnbmVkIGxvbmcgbnJfc2VncyAtPiBsb25nDQo+IC0gdW5zaWduZWQgbG9uZyBmYXN0X3NlZyAt
PiBsb25nDQo+IA0KPiBTbyB3aGVuIGNhbGxpbmcgcndfY29weV9jaGVja191dmVjdG9yKCksIHdl
IGhhdmUgdG8gemVyby1leHRlbmQgdGhlDQo+IHJlZ2lzdGVycyB1c2VkIGZvciBwYXNzaW5nIHRo
ZSBhcmd1bWVudHMuIFRoYXQncyBkZWZpbml0ZWx5IGRvbmUgd2hlbg0KPiBjYWxsaW5nIHRoZSBm
dW5jdGlvbiBleHBsaWNpdGx5LiBNYXliZSB3aGVuIGlubGluaW5nIHNvbWV0aGluZyBpcyBtZXNz
ZWQgdXA/DQoNClRoYXQncyBhbHNvIG5vdCBuZWVkZWQgb24geDg2LTY0IC0gdGhlIGhpZ2ggYml0
cyBnZXQgY2xlYXJlZCBieSAzMmJpdCB3cml0ZXMuDQpCdXQsIElJUkMsIGFybTY0IGxlYXZlcyB0
aGVtIHVuY2hhbmdlZCBvciB1bmRlZmluZWQuDQoNCkkgZ3Vlc3NpbmcgdGhhdCBldmVyeSBhcnJh
eSBhY2Nlc3MgdXNlcyBhICooUnggKyBSeSkgYWRkcmVzc2luZw0KbW9kZS4gU28gaW5kZXhpbmcg
YW4gYXJyYXkgZXZlbiB3aXRoICd1bnNpZ25lZCBpbnQnIHJlcXVpcmVzDQphbiBleHBsaWNpdCB6
ZXJvLWV4dGVuZCBvbiBhcm02ND8NCih4ODYtNjQgZW5kcyB1cCB3aXRoIGFuIGV4cGxpY2l0IHNp
Z24gZXh0ZW5kIHdoZW4gaW5kZXhpbmcgYW4NCmFycmF5IHdpdGggJ3NpZ25lZCBpbnQnLikNCg0K
CURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBN
b3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAx
Mzk3Mzg2IChXYWxlcykNCg==

