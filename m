Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFE0A545E71
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 10:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347356AbiFJISH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 04:18:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347268AbiFJIRq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 04:17:46 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0DA5C22C8B4
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 01:17:30 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-187-CJ42ikeuMzOpi7KnFHFl1g-1; Fri, 10 Jun 2022 09:17:28 +0100
X-MC-Unique: CJ42ikeuMzOpi7KnFHFl1g-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.36; Fri, 10 Jun 2022 09:17:25 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.036; Fri, 10 Jun 2022 09:17:25 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Bill Wendling' <morbo@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC:     Bill Wendling <isanbard@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Phillip Potter <phil@philpotter.co.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jan Kara <jack@suse.com>,
        "Pablo Neira Ayuso" <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        "Florian Westphal" <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>,
        Ross Philipson <ross.philipson@oracle.com>,
        Daniel Kiper <daniel.kiper@oracle.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>,
        Networking <netdev@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        clang-built-linux <llvm@lists.linux.dev>
Subject: RE: [PATCH 00/12] Clang -Wformat warning fixes
Thread-Topic: [PATCH 00/12] Clang -Wformat warning fixes
Thread-Index: AQHYfFM1C3rJ7kSMAEGkdVTZFYHL+K1ISrPg
Date:   Fri, 10 Jun 2022 08:17:25 +0000
Message-ID: <01da36bfd13e421aadb2eff661e7a959@AcuMS.aculab.com>
References: <20220609221702.347522-1-morbo@google.com>
 <20220609152527.4ad7862d4126e276e6f76315@linux-foundation.org>
 <CAGG=3QXDt9AeCQOAp1311POFRSByJru4=Q=oFiQn3u2iZYk2_w@mail.gmail.com>
In-Reply-To: <CAGG=3QXDt9AeCQOAp1311POFRSByJru4=Q=oFiQn3u2iZYk2_w@mail.gmail.com>
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
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQmlsbCBXZW5kbGluZw0KPiBTZW50OiAwOSBKdW5lIDIwMjIgMjM6NDkNCj4gDQo+IE9u
IFRodSwgSnVuIDksIDIwMjIgYXQgMzoyNSBQTSBBbmRyZXcgTW9ydG9uIDxha3BtQGxpbnV4LWZv
dW5kYXRpb24ub3JnPiB3cm90ZToNCj4gPg0KPiA+IE9uIFRodSwgIDkgSnVuIDIwMjIgMjI6MTY6
MTkgKzAwMDAgQmlsbCBXZW5kbGluZyA8bW9yYm9AZ29vZ2xlLmNvbT4gd3JvdGU6DQo+ID4NCj4g
PiA+IFRoaXMgcGF0Y2ggc2V0IGZpeGVzIHNvbWUgY2xhbmcgd2FybmluZ3Mgd2hlbiAtV2Zvcm1h
dCBpcyBlbmFibGVkLg0KPiA+ID4NCj4gPg0KPiA+IHRsZHI6DQo+ID4NCj4gPiAtICAgICAgIHBy
aW50ayhtc2cpOw0KPiA+ICsgICAgICAgcHJpbnRrKCIlcyIsIG1zZyk7DQo+ID4NCj4gPiB0aGUg
b25seSByZWFzb24gdG8gbWFrZSB0aGlzIGNoYW5nZSBpcyB3aGVyZSBgbXNnJyBjb3VsZCBjb250
YWluIGEgYCUnLg0KPiA+IEdlbmVyYWxseSwgaXQgY2FtZSBmcm9tIHVzZXJzcGFjZS4NCj4gDQo+
IEl0IGhlbHBzIGtlcm5lbCBkZXZlbG9wZXJzIG5vdCBhY2NpZGVudGFsbHkgdG8gaW5zZXJ0IGFu
IHVuZXNjYXBlZCAnJScNCj4gaW4gdGhlaXIgbWVzc2FnZXMsIHBvdGVudGlhbGx5IGV4cG9zaW5n
IHRoZWlyIGNvZGUgdG8gYW4gYXR0YWNrDQo+IHZlY3Rvci4NCj4gDQo+ID4gT3RoZXJ3aXNlIHRo
ZXNlIGNoYW5nZXMgYXJlIGENCj4gPiB1c2VsZXNzIGNvbnN1bWVyIG9mIHJ1bnRpbWUgcmVzb3Vy
Y2VzLg0KPiANCj4gQ2FsbGluZyBhICJwcmludGYiIHN0eWxlIGZ1bmN0aW9uIGlzIGFscmVhZHkg
aW5zYW5lbHkgZXhwZW5zaXZlLiA6LSkgSQ0KPiB1bmRlcnN0YW5kIHRoYXQgaXQncyBub3Qgb2th
eSBibGl0aGVseSB0byBpbmNyZWFzZSBydW50aW1lIHJlc291cmNlcw0KPiBzaW1wbHkgYmVjYXVz
ZSBpdCdzIGFscmVhZHkgc2xvdywgYnV0IGluIHRoaXMgY2FzZSBpdCdzIHdvcnRod2hpbGUuDQoN
ClllcCwgSU1ITyBkZWZpbml0ZWx5IHNob3VsZCBiZSBmaXhlZC4NCkl0IGlzIGV2ZW4gcG9zc2li
bGUgdGhhdCB1c2luZyAiJXMiIGlzIGZhc3RlciBiZWNhdXNlIHRoZSBwcmludGYNCmNvZGUgZG9l
c24ndCBoYXZlIHRvIHNjYW4gdGhlIHN0cmluZyBmb3IgZm9ybWF0IGVmZmVjdG9ycy4NCg0KPiA+
IEkgdGhpbmsgaXQgd291bGQgYmUgYmV0dGVyIHRvIHF1aWV0ZW4gY2xhbmcgaW4gc29tZSBmYXNo
aW9uLg0KPiANCj4gVGhlICJwcmludGsiIGFuZCBzaW1pbGFyIGZ1bmN0aW9ucyBhbGwgaGF2ZSB0
aGUgIl9fcHJpbnRmIiBhdHRyaWJ1dGUuDQo+IEkgZG9uJ3Qga25vdyBvZiBhIG1vZGlmaWNhdGlv
biB0byB0aGF0IGF0dHJpYnV0ZSB3aGljaCBjYW4gdHVybiBvZmYNCj4gdGhpcyB0eXBlIG9mIGNo
ZWNrLg0KDQpBbmQgeW91IHdvdWxkbid0IHdhbnQgdG8gZm9yIHRoZXNlIGNhc2VzLg0KDQpUaGUg
b25seSBwcm9ibGVtcyBhcmlzZSB3aGVuIHRoZSBmb3JtYXQgaXMgY2FsY3VsYXRlZA0KKG9yIHBh
c3NlZCBpbiBmcm9tIGEgY2FsbGVyKS4NCkJ1dCB0aGF0IGlzIGxpa2VseSB0byBiZSBkYW5nZXJv
dXMgLSByZWFkaW5nIGZvcm1hdHMgZnJvbQ0KZmlsZXMgKGVnIGZvciBsYW5ndWFnZSB0cmFuc2xh
dGlvbikgaXNuJ3QgYSBnb29kIGlkZWEgYXQgYWxsLg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJl
ZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXlu
ZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

