Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE5AF27181F
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 23:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbgITVNo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 17:13:44 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:58554 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726508AbgITVNi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 17:13:38 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-64-HkvgTllpM-iYq_Po-gc7vg-1; Sun, 20 Sep 2020 22:13:25 +0100
X-MC-Unique: HkvgTllpM-iYq_Po-gc7vg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Sun, 20 Sep 2020 22:13:24 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Sun, 20 Sep 2020 22:13:24 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Arnd Bergmann' <arnd@arndb.de>, Andy Lutomirski <luto@kernel.org>
CC:     Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        David Howells <dhowells@redhat.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        Parisc List <linux-parisc@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        sparclinux <sparclinux@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        linux-aio <linux-aio@kvack.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Network Development <netdev@vger.kernel.org>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Subject: RE: [PATCH 1/9] kernel: add a PF_FORCE_COMPAT flag
Thread-Topic: [PATCH 1/9] kernel: add a PF_FORCE_COMPAT flag
Thread-Index: AQHWj495LxbJUITJXkeWJwtHmAdwxKlyBKsQ
Date:   Sun, 20 Sep 2020 21:13:24 +0000
Message-ID: <8363d874e503470f8caa201e85e9fbd4@AcuMS.aculab.com>
References: <20200918124533.3487701-1-hch@lst.de>
 <20200918124533.3487701-2-hch@lst.de>
 <20200920151510.GS32101@casper.infradead.org>
 <20200920180742.GN3421308@ZenIV.linux.org.uk>
 <20200920190159.GT32101@casper.infradead.org>
 <20200920191031.GQ3421308@ZenIV.linux.org.uk>
 <20200920192259.GU32101@casper.infradead.org>
 <CALCETrXVtBkxNJcMxf9myaKT9snHKbCWUenKHGRfp8AOtORBPg@mail.gmail.com>
 <CAK8P3a37BRFj_qg61gP2oVrjJzBrZ58y1vggeTk_5n55Ou5U2Q@mail.gmail.com>
In-Reply-To: <CAK8P3a37BRFj_qg61gP2oVrjJzBrZ58y1vggeTk_5n55Ou5U2Q@mail.gmail.com>
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

RnJvbTogQXJuZCBCZXJnbWFubg0KPiBTZW50OiAyMCBTZXB0ZW1iZXIgMjAyMCAyMTo0OQ0KPiAN
Cj4gT24gU3VuLCBTZXAgMjAsIDIwMjAgYXQgOToyOCBQTSBBbmR5IEx1dG9taXJza2kgPGx1dG9A
a2VybmVsLm9yZz4gd3JvdGU6DQo+ID4gT24gU3VuLCBTZXAgMjAsIDIwMjAgYXQgMTI6MjMgUE0g
TWF0dGhldyBXaWxjb3ggPHdpbGx5QGluZnJhZGVhZC5vcmc+IHdyb3RlOg0KPiA+ID4NCj4gPiA+
IE9uIFN1biwgU2VwIDIwLCAyMDIwIGF0IDA4OjEwOjMxUE0gKzAxMDAsIEFsIFZpcm8gd3JvdGU6
DQo+ID4gPiA+IElNTyBpdCdzIG11Y2ggc2FuZXIgdG8gbWFyayB0aG9zZSBhbmQgcmVmdXNlIHRv
IHRvdWNoIHRoZW0gZnJvbSBpb191cmluZy4uLg0KPiA+ID4NCj4gPiA+IFNpbXBsZXIgc29sdXRp
b24gaXMgdG8gcmVtb3ZlIGlvX3VyaW5nIGZyb20gdGhlIDMyLWJpdCBzeXNjYWxsIGxpc3QuDQo+
ID4gPiBJZiB5b3UncmUgYSAzMi1iaXQgcHJvY2VzcywgeW91IGRvbid0IGdldCB0byB1c2UgaW9f
dXJpbmcuICBXb3VsZA0KPiA+ID4gYW55IHJlYWwgdXNlcnMgYWN0dWFsbHkgY2FyZSBhYm91dCB0
aGF0Pw0KPiA+DQo+ID4gV2UgY291bGQgZ28gb25lIHN0ZXAgZmFydGhlciBhbmQgZGVjbGFyZSB0
aGF0IHdlJ3JlIGRvbmUgYWRkaW5nICphbnkqDQo+ID4gbmV3IGNvbXBhdCBzeXNjYWxscyA6KQ0K
PiANCj4gV291bGQgeW91IGFsc28gc3RvcCBhZGRpbmcgc3lzdGVtIGNhbGxzIHRvIG5hdGl2ZSAz
Mi1iaXQgc3lzdGVtcyB0aGVuPw0KPiANCj4gT24gbWVtb3J5IGNvbnN0cmFpbmVkIHN5c3RlbXMg
KGxlc3MgdGhhbiAyR0IgYS50Lm0uKSwgdGhlcmUgaXMgc3RpbGwgYQ0KPiBzdHJvbmcgZGVtYW5k
IGZvciBydW5uaW5nIDMyLWJpdCB1c2VyIHNwYWNlLCBidXQgYWxsIG9mIHRoZSByZWNlbnQgQXJt
DQo+IGNvcmVzIChhZnRlciBDb3J0ZXgtQTU1KSBkcm9wcGVkIHRoZSBhYmlsaXR5IHRvIHJ1biAz
Mi1iaXQga2VybmVscywgc28NCj4gdGhhdCBjb21wYXQgbW9kZSBtYXkgZXZlbnR1YWxseSBiZWNv
bWUgdGhlIHByaW1hcnkgd2F5IHRvIHJ1bg0KPiBMaW51eCBvbiBjaGVhcCBlbWJlZGRlZCBzeXN0
ZW1zLg0KPiANCj4gSSBkb24ndCB0aGluayB0aGVyZSBpcyBhbnkgY2hhbmNlIHdlIGNhbiByZWFs
aXN0aWNhbGx5IHRha2UgYXdheSBpb191cmluZw0KPiBmcm9tIHRoZSAzMi1iaXQgQUJJIGFueSBt
b3JlIG5vdy4NCg0KQ2FuJ3QgaXQganVzdCBydW4gcmVxdWVzdHMgZnJvbSAzMmJpdCBhcHBzIGlu
IGEga2VybmVsIHRocmVhZCB0aGF0IGhhcw0KdGhlICdpbl9jb21wYXRfc3lzY2FsbCcgZmxhZyBz
ZXQ/DQpOb3QgdGhhdCBpIHJlY2FsbCBzZWVpbmcgdGhlIGNvZGUgd2hlcmUgaXQgc2F2ZXMgdGhl
ICdjb21wYXQnIG5hdHVyZQ0Kb2YgYW55IHJlcXVlc3RzLg0KDQpJdCBpcyBhbHJlYWR5IGNvbXBs
ZXRlbHkgZipja2VkIGlmIHlvdSB0cnkgdG8gcGFzcyB0aGUgY29tbWFuZCByaW5nDQp0byBhIGNo
aWxkIHByb2Nlc3MgLSBpdCB1c2VzIHRoZSB3cm9uZyAnbW0nLg0KSSBzdXNwZWN0IHRoZXJlIGFy
ZSBzb21lIHJlYWxseSBob3JyaWQgc2VjdXJpdHkgaG9sZXMgaW4gdGhhdCBhcmVhLg0KDQoJRGF2
aWQuDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3Vu
dCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3
Mzg2IChXYWxlcykNCg==

