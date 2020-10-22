Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6BA1295BDE
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 11:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895993AbgJVJdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 05:33:11 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:25770 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2895404AbgJVJdL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 05:33:11 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-305-8XvjHwJ8MYOWawC799xGnw-1; Thu, 22 Oct 2020 10:32:05 +0100
X-MC-Unique: 8XvjHwJ8MYOWawC799xGnw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 22 Oct 2020 10:32:04 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 22 Oct 2020 10:32:04 +0100
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
Thread-Index: AQHWqE5GNDfnH4y9nkGWtfqJueR1KKmjTCJQgAAN4UiAAAD2IA==
Date:   Thu, 22 Oct 2020 09:32:04 +0000
Message-ID: <bc0a091865f34700b9df332c6e9dcdfd@AcuMS.aculab.com>
References: <20200925045146.1283714-1-hch@lst.de>
 <20200925045146.1283714-3-hch@lst.de> <20201021161301.GA1196312@kroah.com>
 <20201021233914.GR3576660@ZenIV.linux.org.uk>
 <20201022082654.GA1477657@kroah.com>
 <80a2e5fa-718a-8433-1ab0-dd5b3e3b5416@redhat.com>
 <5d2ecb24db1e415b8ff88261435386ec@AcuMS.aculab.com>
 <df2e0758-b8ed-5aec-6adc-a18f499c0179@redhat.com>
 <20201022090155.GA1483166@kroah.com>
 <e04d0c5d-e834-a15b-7844-44dcc82785cc@redhat.com>
 <a1533569-948a-1d5b-e231-5531aa988047@redhat.com>
In-Reply-To: <a1533569-948a-1d5b-e231-5531aa988047@redhat.com>
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

RnJvbTogRGF2aWQgSGlsZGVuYnJhbmQNCj4gU2VudDogMjIgT2N0b2JlciAyMDIwIDEwOjI1DQou
Li4NCj4gLi4uIGVzcGVjaWFsbHkgYmVjYXVzZSBJIHJlY2FsbCB0aGF0IGNsYW5nIGFuZCBnY2Mg
YmVoYXZlIHNsaWdodGx5DQo+IGRpZmZlcmVudGx5Og0KPiANCj4gaHR0cHM6Ly9naXRodWIuY29t
L2hqbC10b29scy94ODYtcHNBQkkvaXNzdWVzLzINCj4gDQo+ICJGdW5jdGlvbiBhcmdzIGFyZSBk
aWZmZXJlbnQ6IG5hcnJvdyB0eXBlcyBhcmUgc2lnbiBvciB6ZXJvIGV4dGVuZGVkIHRvDQo+IDMy
IGJpdHMsIGRlcGVuZGluZyBvbiB0aGVpciB0eXBlLiBjbGFuZyBkZXBlbmRzIG9uIHRoaXMgZm9y
IGluY29taW5nDQo+IGFyZ3MsIGJ1dCBnY2MgZG9lc24ndCBtYWtlIHRoYXQgYXNzdW1wdGlvbi4g
QnV0IGJvdGggY29tcGlsZXJzIGRvIGl0DQo+IHdoZW4gY2FsbGluZywgc28gZ2NjIGNvZGUgY2Fu
IGNhbGwgY2xhbmcgY29kZS4NCg0KSXQgcmVhbGx5IGlzIGJlc3QgdG8gdXNlICdpbnQnIChvciBl
dmVuICdsb25nJykgZm9yIGFsbCBudW1lcmljDQphcmd1bWVudHMgKGFuZCByZXN1bHRzKSByZWdh
cmRsZXNzIG9mIHRoZSBkb21haW4gb2YgdGhlIHZhbHVlLg0KDQpSZWxhdGVkLCBJJ3ZlIGFsd2F5
cyB3b3JyaWVkIGFib3V0ICdib29sJy4uLi4NCg0KPiBUaGUgdXBwZXIgMzIgYml0cyBvZiByZWdp
c3RlcnMgYXJlIGFsd2F5cyB1bmRlZmluZWQgZ2FyYmFnZSBmb3IgdHlwZXMNCj4gc21hbGxlciB0
aGFuIDY0IGJpdHMuIg0KDQpPbiB4ODYtNjQgdGhlIGhpZ2ggYml0cyBhcmUgemVyb2VkIGJ5IGFs
bCAzMmJpdCBsb2Fkcy4NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lk
ZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0K
UmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

