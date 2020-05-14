Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5030A1D2C0E
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 12:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726084AbgENKBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 06:01:51 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:57595 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726066AbgENKBv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 06:01:51 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-179-I2TpioJnO02MgCgI8UoE-Q-1; Thu, 14 May 2020 11:01:46 +0100
X-MC-Unique: I2TpioJnO02MgCgI8UoE-Q-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 14 May 2020 11:01:45 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 14 May 2020 11:01:45 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Daniel Borkmann' <daniel@iogearbox.net>,
        Al Viro <viro@zeniv.linux.org.uk>
CC:     Christoph Hellwig <hch@lst.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        linux-um <linux-um@lists.infradead.org>,
        Netdev <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "bgregg@netflix.com" <bgregg@netflix.com>
Subject: RE: [PATCH 11/18] maccess: remove strncpy_from_unsafe
Thread-Topic: [PATCH 11/18] maccess: remove strncpy_from_unsafe
Thread-Index: AQHWKYLaQq1MCiy4bEiOMK61mlvZyainWQNA
Date:   Thu, 14 May 2020 10:01:45 +0000
Message-ID: <6ca8d8499bf644aba0b242d194df5a60@AcuMS.aculab.com>
References: <20200513160038.2482415-1-hch@lst.de>
 <20200513160038.2482415-12-hch@lst.de>
 <CAHk-=wj=u+nttmd1huNES2U=9nePtmk7WgR8cMLCYS8wc=rhdA@mail.gmail.com>
 <20200513192804.GA30751@lst.de>
 <0c1a7066-b269-9695-b94a-bb5f4f20ebd8@iogearbox.net>
 <20200513232816.GZ23230@ZenIV.linux.org.uk>
 <866cbe54-a027-04eb-65db-c6423d16b924@iogearbox.net>
In-Reply-To: <866cbe54-a027-04eb-65db-c6423d16b924@iogearbox.net>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRGFuaWVsIEJvcmttYW5uDQo+IFNlbnQ6IDE0IE1heSAyMDIwIDAwOjU5DQo+IE9uIDUv
MTQvMjAgMToyOCBBTSwgQWwgVmlybyB3cm90ZToNCj4gPiBPbiBUaHUsIE1heSAxNCwgMjAyMCBh
dCAxMjozNjoyOEFNICswMjAwLCBEYW5pZWwgQm9ya21hbm4gd3JvdGU6DQo+ID4NCj4gPj4+IFNv
IG9uIHNheSBzMzkwIFRBU0tfU0laRV9VU1VBTEx5IGlzICgtUEFHRV9TSVpFKSwgd2hpY2ggbWVh
bnMgd2UnZCBhbHdheQ0KPiA+Pj4gdHJ5IHRoZSB1c2VyIGNvcHkgZmlyc3QsIHdoaWNoIHNlZW1z
IG9kZC4NCj4gPj4+DQo+ID4+PiBJJ2QgcmVhbGx5IGxpa2UgdG8gaGVyZSBmcm9tIHRoZSBicGYg
Zm9sa3Mgd2hhdCB0aGUgZXhwZWN0ZWQgdXNlIGNhc2UNCj4gPj4+IGlzIGhlcmUsIGFuZCBpZiB0
aGUgdHlwaWNhbCBhcmd1bWVudCBpcyBrZXJuZWwgb3IgdXNlciBtZW1vcnkuDQo+ID4+DQo+ID4+
IEl0J3MgdXNlZCBmb3IgYm90aC4gR2l2ZW4gdGhpcyBpcyBlbmFibGVkIG9uIHByZXR0eSBtdWNo
IGFsbCBwcm9ncmFtIHR5cGVzLCBteQ0KPiA+PiBhc3N1bXB0aW9uIHdvdWxkIGJlIHRoYXQgdXNh
Z2UgaXMgc3RpbGwgbW9yZSBvZnRlbiBvbiBrZXJuZWwgbWVtb3J5IHRoYW4gdXNlciBvbmUuDQo+
ID4NCj4gPiBUaGVuIGl0IG5lZWRzIGFuIGFyZ3VtZW50IHRlbGxpbmcgaXQgd2hpY2ggb25lIHRv
IHVzZS4gIExvb2sgYXQgc3BhcmM2NC4NCj4gPiBPciBzMzkwLiAgT3IgcGFyaXNjLiAgRXQgc29k
ZGluZyBjZXRlcmEuDQo+ID4NCj4gPiBUaGUgdW5kZXJseWluZyBtb2RlbCBpcyB0aGF0IHRoZSBr
ZXJuZWwgbGl2ZXMgaW4gYSBzZXBhcmF0ZSBhZGRyZXNzIHNwYWNlLg0KPiA+IFllcywgb24geDg2
IGl0J3MgYWN0dWFsbHkgc2hhcmluZyB0aGUgcGFnZSB0YWJsZXMgd2l0aCB1c2VybGFuZCwgYnV0
IHRoYXQncw0KPiA+IG5vdCB1bml2ZXJzYWwuICBUaGUgc2FtZSBhZGRyZXNzIGNhbiBiZSBib3Ro
IGEgdmFsaWQgdXNlcmxhbmQgb25lIF9hbmRfDQo+ID4gYSB2YWxpZCBrZXJuZWwgb25lLiAgWW91
IG5lZWQgdG8gdGVsbCB3aGljaCBvbmUgZG8geW91IHdhbnQuDQo+IA0KPiBZZXMsIHNlZSBhbHNv
IDZhZTA4YWUzZGVhMiAoImJwZjogQWRkIHByb2JlX3JlYWRfe3VzZXIsIGtlcm5lbH0gYW5kIHBy
b2JlX3JlYWRfe3VzZXIsDQo+IGtlcm5lbH1fc3RyIGhlbHBlcnMiKSwgYW5kIG15IG90aGVyIHJl
cGx5IHdydCBicGZfdHJhY2VfcHJpbnRrKCkgb24gaG93IHRvIGFkZHJlc3MNCj4gdGhpcy4gQWxs
IEknbSB0cnlpbmcgdG8gc2F5IGlzIHRoYXQgYm90aCBicGZfcHJvYmVfcmVhZCgpIGFuZCBicGZf
dHJhY2VfcHJpbnRrKCkgZG8NCj4gZXhpc3QgaW4gdGhpcyBmb3JtIHNpbmNlIGVhcmx5IFtlXWJw
ZiBkYXlzIGZvciB+NXlycyBub3cgYW5kIHdoaWxlIGJyb2tlbiBvbiBub24teDg2DQo+IHRoZXJl
IGFyZSBhIGxvdCBvZiB1c2VycyBvbiB4ODYgZm9yIHRoaXMgaW4gdGhlIHdpbGQsIHNvIHRoZXkg
bmVlZCB0byBoYXZlIGEgY2hhbmNlDQo+IHRvIG1pZ3JhdGUgb3ZlciB0byB0aGUgbmV3IGZhY2ls
aXRpZXMgYmVmb3JlIHRoZXkgYXJlIGZ1bGx5IHJlbW92ZWQuDQoNCklmIGl0J3Mgbm90IGEgc3R1
cGlkIHF1ZXN0aW9uIHdoeSBpcyBhIEJQRiBwcm9ncmFtIGFsbG93ZWQgdG8gZ2V0DQppbnRvIGEg
c2l0dWF0aW9uIHdoZXJlIGl0IG1pZ2h0IGhhdmUgYW4gaW52YWxpZCBrZXJuZWwgYWRkcmVzcy4N
Cg0KSXQgYWxsIHN0aW5rcyBvZiBhIGhvbGUgdGhhdCBhbGxvd3MgYWxsIG9mIGtlcm5lbCBtZW1v
cnkgdG8gYmUgcmVhZA0KYW5kIGNvcGllZCB0byB1c2Vyc3BhY2UuDQoNCk5vdyB5b3UgbWlnaHQg
d2FudCB0byBzb21ldGhpbmcgc3BlY2lhbCBzbyB0aGF0IEJQRiBwcm9ncmFtcyBqdXN0DQphYm9y
dCBvbiBPT1BTIGluc3RlYWQgb2YgcG9zc2libHkgcGFuaWtpbmcgdGhlIGtlcm5lbC4NCkJ1dCB0
aGF0IGlzIGRpZmZlcmVudCBmcm9tIGEgY29weSB0aGF0IGV4cGVjdHMgdG8gYmUgcGFzc2VkIGdh
cmJhZ2UuDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1s
ZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJh
dGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

