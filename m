Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4FA295AA6
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 10:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2509558AbgJVIki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 04:40:38 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:51771 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2508281AbgJVIkh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 04:40:37 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-193-KyNHXYWSMIqmBJxmOt-l6A-1; Thu, 22 Oct 2020 09:40:33 +0100
X-MC-Unique: KyNHXYWSMIqmBJxmOt-l6A-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 22 Oct 2020 09:40:32 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 22 Oct 2020 09:40:32 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'David Hildenbrand' <david@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Nick Desaulniers" <ndesaulniers@google.com>
CC:     Christoph Hellwig <hch@lst.de>,
        "kernel-team@android.com" <kernel-team@android.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Jens Axboe" <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
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
Thread-Index: AQHWqE5GNDfnH4y9nkGWtfqJueR1KKmjTCJQ
Date:   Thu, 22 Oct 2020 08:40:32 +0000
Message-ID: <5d2ecb24db1e415b8ff88261435386ec@AcuMS.aculab.com>
References: <20200925045146.1283714-1-hch@lst.de>
 <20200925045146.1283714-3-hch@lst.de> <20201021161301.GA1196312@kroah.com>
 <20201021233914.GR3576660@ZenIV.linux.org.uk>
 <20201022082654.GA1477657@kroah.com>
 <80a2e5fa-718a-8433-1ab0-dd5b3e3b5416@redhat.com>
In-Reply-To: <80a2e5fa-718a-8433-1ab0-dd5b3e3b5416@redhat.com>
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

RnJvbTogRGF2aWQgSGlsZGVuYnJhbmQNCj4gU2VudDogMjIgT2N0b2JlciAyMDIwIDA5OjM1DQo+
IA0KPiBPbiAyMi4xMC4yMCAxMDoyNiwgR3JlZyBLSCB3cm90ZToNCj4gPiBPbiBUaHUsIE9jdCAy
MiwgMjAyMCBhdCAxMjozOToxNEFNICswMTAwLCBBbCBWaXJvIHdyb3RlOg0KPiA+PiBPbiBXZWQs
IE9jdCAyMSwgMjAyMCBhdCAwNjoxMzowMVBNICswMjAwLCBHcmVnIEtIIHdyb3RlOg0KPiA+Pj4g
T24gRnJpLCBTZXAgMjUsIDIwMjAgYXQgMDY6NTE6MzlBTSArMDIwMCwgQ2hyaXN0b3BoIEhlbGx3
aWcgd3JvdGU6DQo+ID4+Pj4gRnJvbTogRGF2aWQgTGFpZ2h0IDxEYXZpZC5MYWlnaHRAQUNVTEFC
LkNPTT4NCj4gPj4+Pg0KPiA+Pj4+IFRoaXMgbGV0cyB0aGUgY29tcGlsZXIgaW5saW5lIGl0IGlu
dG8gaW1wb3J0X2lvdmVjKCkgZ2VuZXJhdGluZw0KPiA+Pj4+IG11Y2ggYmV0dGVyIGNvZGUuDQo+
ID4+Pj4NCj4gPj4+PiBTaWduZWQtb2ZmLWJ5OiBEYXZpZCBMYWlnaHQgPGRhdmlkLmxhaWdodEBh
Y3VsYWIuY29tPg0KPiA+Pj4+IFNpZ25lZC1vZmYtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hA
bHN0LmRlPg0KPiA+Pj4+IC0tLQ0KPiA+Pj4+ICBmcy9yZWFkX3dyaXRlLmMgfCAxNzkgLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+ID4+Pj4gIGxpYi9p
b3ZfaXRlci5jICB8IDE3NiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKw0KPiA+Pj4+ICAyIGZpbGVzIGNoYW5nZWQsIDE3NiBpbnNlcnRpb25zKCspLCAxNzkg
ZGVsZXRpb25zKC0pDQo+ID4+Pg0KPiA+Pj4gU3RyYW5nZWx5LCB0aGlzIGNvbW1pdCBjYXVzZXMg
YSByZWdyZXNzaW9uIGluIExpbnVzJ3MgdHJlZSByaWdodCBub3cuDQo+ID4+Pg0KPiA+Pj4gSSBj
YW4ndCByZWFsbHkgZmlndXJlIG91dCB3aGF0IHRoZSByZWdyZXNzaW9uIGlzLCBvbmx5IHRoYXQg
dGhpcyBjb21taXQNCj4gPj4+IHRyaWdnZXJzIGEgImxhcmdlIEFuZHJvaWQgc3lzdGVtIGJpbmFy
eSIgZnJvbSB3b3JraW5nIHByb3Blcmx5LiAgVGhlcmUncw0KPiA+Pj4gbm8ga2VybmVsIGxvZyBt
ZXNzYWdlcyBhbnl3aGVyZSwgYW5kIEkgZG9uJ3QgaGF2ZSBhbnkgd2F5IHRvIHN0cmFjZSB0aGUN
Cj4gPj4+IHRoaW5nIGluIHRoZSB0ZXN0aW5nIGZyYW1ld29yaywgc28gYW55IGhpbnRzIHRoYXQg
cGVvcGxlIGNhbiBwcm92aWRlDQo+ID4+PiB3b3VsZCBiZSBtb3N0IGFwcHJlY2lhdGVkLg0KPiA+
Pg0KPiA+PiBJdCdzIGEgcHVyZSBtb3ZlIC0gbW9kdWxvIGNoYW5nZWQgbGluZSBicmVha3MgaW4g
dGhlIGFyZ3VtZW50IGxpc3RzDQo+ID4+IHRoZSBmdW5jdGlvbnMgaW52b2x2ZWQgYXJlIGlkZW50
aWNhbCBiZWZvcmUgYW5kIGFmdGVyIHRoYXQgKGp1c3QgY2hlY2tlZA0KPiA+PiB0aGF0IGRpcmVj
dGx5LCBieSBjaGVja2luZyBvdXQgdGhlIHRyZWVzIGJlZm9yZSBhbmQgYWZ0ZXIsIGV4dHJhY3Rp
bmcgdHdvDQo+ID4+IGZ1bmN0aW9ucyBpbiBxdWVzdGlvbiBmcm9tIGZzL3JlYWRfd3JpdGUuYyBh
bmQgbGliL2lvdl9pdGVyLmMgKGJlZm9yZSBhbmQNCj4gPj4gYWZ0ZXIsIHJlc3AuKSBhbmQgY2hl
Y2tpbmcgdGhlIGRpZmYgYmV0d2VlbiB0aG9zZS4NCj4gPj4NCj4gPj4gSG93IGNlcnRhaW4gaXMg
eW91ciBiaXNlY3Rpb24/DQo+ID4NCj4gPiBUaGUgYmlzZWN0aW9uIGlzIHZlcnkgcmVwcm9kdWNh
YmxlLg0KPiA+DQo+ID4gQnV0LCB0aGlzIGxvb2tzIG5vdyB0byBiZSBhIGNvbXBpbGVyIGJ1Zy4g
IEknbSB1c2luZyB0aGUgbGF0ZXN0IHZlcnNpb24NCj4gPiBvZiBjbGFuZyBhbmQgaWYgSSBwdXQg
Im5vaW5saW5lIiBhdCB0aGUgZnJvbnQgb2YgdGhlIGZ1bmN0aW9uLA0KPiA+IGV2ZXJ5dGhpbmcg
d29ya3MuDQo+IA0KPiBXZWxsLCB0aGUgY29tcGlsZXIgY2FuIGRvIG1vcmUgaW52YXNpdmUgb3B0
aW1pemF0aW9ucyB3aGVuIGlubGluaW5nLiBJZg0KPiB5b3UgaGF2ZSBidWdneSBjb2RlIHRoYXQg
cmVsaWVzIG9uIHNvbWUgdW5zcGVjaWZpZWQgYmVoYXZpb3IsIGlubGluaW5nDQo+IGNhbiBjaGFu
Z2UgdGhlIGJlaGF2aW9yIC4uLiBidXQgZ29pbmcgb3ZlciB0aGF0IGNvZGUsIHRoZXJlIGlzbid0
IHRvbw0KPiBtdWNoIGFjdGlvbiBnb2luZyBvbi4gQXQgbGVhc3Qgbm90aGluZyBzY3JlYW1lZCBh
dCBtZS4NCg0KQXBhcnQgZnJvbSBhbGwgdGhlIG9wdGltaXNhdGlvbnMgdGhhdCBnZXQgcmlkIG9m
ZiB0aGUgJ3Bhc3MgYmUgcmVmZXJlbmNlJw0KcGFyYW1ldGVycyBhbmQgc3RyYW5nZSBjb25kaXRp
b25hbCB0ZXN0cy4NClBsZW50eSBvZiBzY29wZSBmb3IgdGhlIGNvbXBpbGVyIGdldHRpbmcgaXQg
d3JvbmcuDQpCdXQgbm90aGluZyBldmVuIHZhZ3VlbHkgaWxsZWdhbC4NCg0KCURhdmlkDQoNCi0N
ClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBN
aWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxl
cykNCg==

