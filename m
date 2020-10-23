Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4960297072
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 15:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S464790AbgJWN3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 09:29:02 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:59628 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S368914AbgJWN3B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 09:29:01 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mtapsc-1-v1vYoM8jOeGMKLhWfd8r_g-1; Fri, 23 Oct 2020 14:28:58 +0100
X-MC-Unique: v1vYoM8jOeGMKLhWfd8r_g-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 23 Oct 2020 14:28:57 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 23 Oct 2020 14:28:57 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Arnd Bergmann' <arnd@arndb.de>
CC:     Greg KH <gregkh@linuxfoundation.org>,
        David Hildenbrand <david@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Christoph Hellwig <hch@lst.de>,
        "kernel-team@android.com" <kernel-team@android.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
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
Thread-Index: AQHWqE5GNDfnH4y9nkGWtfqJueR1KKmjTCJQgAAN4UiAAAD2IIAASOeCgAF+12D///tDgIAAEbpg
Date:   Fri, 23 Oct 2020 13:28:57 +0000
Message-ID: <8e758668cffa4713969df33299180c64@AcuMS.aculab.com>
References: <df2e0758-b8ed-5aec-6adc-a18f499c0179@redhat.com>
 <20201022090155.GA1483166@kroah.com>
 <e04d0c5d-e834-a15b-7844-44dcc82785cc@redhat.com>
 <a1533569-948a-1d5b-e231-5531aa988047@redhat.com>
 <bc0a091865f34700b9df332c6e9dcdfd@AcuMS.aculab.com>
 <5fd6003b-55a6-2c3c-9a28-8fd3a575ca78@redhat.com>
 <20201022104805.GA1503673@kroah.com> <20201022121849.GA1664412@kroah.com>
 <98d9df88-b7ef-fdfb-7d90-2fa7a9d7bab5@redhat.com>
 <20201022125759.GA1685526@kroah.com> <20201022135036.GA1787470@kroah.com>
 <134f162d711d466ebbd88906fae35b33@AcuMS.aculab.com>
 <CAK8P3a1n+b8hOMhNQSDzgic03dyXbmpccfTJ3C1bGKvzsgMXbg@mail.gmail.com>
In-Reply-To: <CAK8P3a1n+b8hOMhNQSDzgic03dyXbmpccfTJ3C1bGKvzsgMXbg@mail.gmail.com>
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

RnJvbTogQXJuZCBCZXJnbWFubg0KPiBTZW50OiAyMyBPY3RvYmVyIDIwMjAgMTQ6MjMNCj4gDQo+
IE9uIEZyaSwgT2N0IDIzLCAyMDIwIGF0IDI6NDYgUE0gRGF2aWQgTGFpZ2h0IDxEYXZpZC5MYWln
aHRAYWN1bGFiLmNvbT4gd3JvdGU6DQo+ID4NCj4gPiBGcm9tOiBHcmVnIEtIIDxncmVna2hAbGlu
dXhmb3VuZGF0aW9uLm9yZz4NCj4gPiA+IFNlbnQ6IDIyIE9jdG9iZXIgMjAyMCAxNDo1MQ0KPiA+
DQo+ID4gSSd2ZSByYW1tZWQgdGhlIGNvZGUgaW50byBnb2Rib2x0Lg0KPiA+DQo+ID4gaHR0cHM6
Ly9nb2Rib2x0Lm9yZy96Lzl2NVBQVw0KPiA+DQo+ID4gRGVmaW5pdGVseSBhIGNsYW5nIGJ1Zy4N
Cj4gPg0KPiA+IFNlYXJjaCBmb3IgW3d4XTI0IGluIHRoZSBjbGFuZyBvdXRwdXQuDQo+ID4gbnJf
c2VncyBjb21lcyBpbiBhcyB3MiBhbmQgdGhlIGluaXRpYWwgYm91bmQgY2hlY2tzIGFyZSBkb25l
IG9uIHcyLg0KPiA+IHcyNCBpcyBsb2FkZWQgZnJvbSB3MiAtIEkgZG9uJ3QgYmVsaWV2ZSB0aGlz
IGNoYW5nZXMgdGhlIGhpZ2ggYml0cy4NCj4gDQo+IFlvdSBiZWxpZXZlIHdyb25nLCAibW92IHcy
NCwgdzIiIGlzIGEgemVyby1leHRlbmRpbmcgb3BlcmF0aW9uLg0KDQpBaCBvaywgYnV0IGdjYyB1
c2VzIHV0eHcgZm9yIHRoZSBzYW1lIHRhc2suDQpJIGd1ZXNzIHRoZXkgY291bGQgYmUgdGhlIHNh
bWUgb3Bjb2RlLg0KDQpMYXN0IHRpbWUgSSB3cm90ZSBBUk0gdGh1bWIgZGlkbid0IHJlYWxseSBl
eGlzdCAtIG5ldmVyIG1pbmQgNjRiaXQNCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVz
cyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEg
MVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

