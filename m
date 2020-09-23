Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B345276315
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 23:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbgIWVab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 17:30:31 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:39148 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726684AbgIWVaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 17:30:30 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-222-k0JZSzTkPJOZPjS-rTcoJw-1; Wed, 23 Sep 2020 22:30:26 +0100
X-MC-Unique: k0JZSzTkPJOZPjS-rTcoJw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 23 Sep 2020 22:30:25 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 23 Sep 2020 22:30:25 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Arnd Bergmann' <arnd@arndb.de>, Al Viro <viro@zeniv.linux.org.uk>
CC:     Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        David Howells <dhowells@redhat.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>,
        Parisc List <linux-parisc@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        sparclinux <sparclinux@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        linux-aio <linux-aio@kvack.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Networking <netdev@vger.kernel.org>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Subject: RE: [PATCH 5/9] fs: remove various compat readv/writev helpers
Thread-Topic: [PATCH 5/9] fs: remove various compat readv/writev helpers
Thread-Index: AQHWkdnPrERbulCBlEyrFz5+sRsKWql2urog
Date:   Wed, 23 Sep 2020 21:30:25 +0000
Message-ID: <2e11ea867c644c5d96f8e4930e5c730d@AcuMS.aculab.com>
References: <20200923060547.16903-1-hch@lst.de>
 <20200923060547.16903-6-hch@lst.de>
 <20200923142549.GK3421308@ZenIV.linux.org.uk> <20200923143251.GA14062@lst.de>
 <20200923145901.GN3421308@ZenIV.linux.org.uk>
 <20200923163831.GO3421308@ZenIV.linux.org.uk>
 <CAK8P3a3nkLUOkR+jwz2_2LcYTUTqdVf8JOtZqKWbtEDotNhFZA@mail.gmail.com>
In-Reply-To: <CAK8P3a3nkLUOkR+jwz2_2LcYTUTqdVf8JOtZqKWbtEDotNhFZA@mail.gmail.com>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQXJuZCBCZXJnbWFubg0KPiBTZW50OiAyMyBTZXB0ZW1iZXIgMjAyMCAxOTo0Ng0KLi4u
DQo+IFJlZ2FyZGxlc3Mgb2YgdGhhdCwgYW5vdGhlciBhZHZhbnRhZ2Ugb2YgaGF2aW5nIHRoZSBT
WVNDQUxMX0RFQ0xBUkV4KCkNCj4gd291bGQgYmUgdGhlIGFiaWxpdHkgdG8gaW5jbHVkZSB0aGF0
IGhlYWRlciBmaWxlIGZyb20gZWxzZXdoZXJlIHdpdGggYSBkaWZmZXJlbnQNCj4gbWFjcm8gZGVm
aW5pdGlvbiB0byBjcmVhdGUgYSBtYWNoaW5lLXJlYWRhYmxlIHZlcnNpb24gb2YgdGhlIGludGVy
ZmFjZSB3aGVuDQo+IGNvbWJpbmVkIHdpdGggdGhlIHN5c2NhbGwudGJsIGZpbGVzLiBUaGlzIGNv
dWxkIGJlIHVzZWQgdG8gY3JlYXRlIGEgdXNlcg0KPiBzcGFjZSBzdHViIGZvciBjYWxsaW5nIGlu
dG8gdGhlIGxvdy1sZXZlbCBzeXNjYWxsIHJlZ2FyZGxlc3Mgb2YgdGhlDQo+IGxpYmMgaW50ZXJm
YWNlcywNCj4gb3IgZm9yIHN5bmNocm9uaXppbmcgdGhlIGludGVyZmFjZXMgd2l0aCBzdHJhY2Us
IHFlbXUtdXNlciwgb3IgYW55dGhpbmcgdGhhdA0KPiBuZWVkcyB0byBkZWFsIHdpdGggdGhlIGxv
dy1sZXZlbCBpbnRlcmZhY2UuDQoNCkEgc2ltaWxhciAndHJpY2snICh0aGF0IHByb2JhYmx5IHdv
bid0IHdvcmsgaGVyZSkgaXMgdG8gcGFzcw0KdGhlIG5hbWUgb2YgYSAjZGVmaW5lIGZ1bmN0aW9u
IGFzIGEgcGFyYW1ldGVyIHRvIGFub3RoZXIgZGVmaW5lLg0KVXNlZnVsIGZvciBkZWZpbmluZyBj
b25zdGFudHMgYW5kIGVycm9yIHN0cmluZ3MgdG9nZXRoZXIuIGVnOg0KI2RlZmluZSBUUkFGRklD
X0xJR0hUUyh4KSBcDQoJeChSRUQsIDAsICJSZWQiKSBcDQoJeChZRUxMT1csIDEsICJZZWxsb3cp
IFwNCgl4KEdSRUVOLCAyLCAiR1JFRU4pDQoNCllvdSBjYW4gdGhlbiBkbyB0aGluZyBsaWtlOg0K
I2RlZmluZSB4KHRva2VuLCB2YWx1ZSwgc3RyaW5nKSB0b2tlbiA9IHZhbHVlLA0KZW51bSB7VFJB
RkZJQ19MSUdIVFMoeCkgTlVNX0xJR0hUU307DQojdW5kZWYgeA0KI2RlZmluZSB4KHRva2VuLCB2
YWx1ZSwgc3RyaW5nKSBbdmFsdWVdID0gc3RyaW5nLA0KY29uc3QgY2hhciAqY29sb3Vyc1tdID0g
e1RSQUZGSUNfTElHSFRTKHgpfTsNCiN1bmRlZiB4DQp0byBpbml0aWFsaXNlIGNvbnN0YW50cyBh
bmQgYSBuYW1lIHRhYmxlIHRoYXQgYXJlIGFsd2F5cyBpbiBzeW5jLg0KDQpJdCBpcyBhbHNvIGEg
Z29vZCB3YXkgdG8gZ2VuZXJhdGUgc291cmNlIGxpbmVzIHRoYXQgYXJlIG92ZXIgMU1CLg0KDQoJ
RGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1v
dW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEz
OTczODYgKFdhbGVzKQ0K

