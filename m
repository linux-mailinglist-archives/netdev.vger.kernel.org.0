Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94053546183
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 11:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348574AbiFJJPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 05:15:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236849AbiFJJPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 05:15:05 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E76F91D8081
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 02:14:50 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-285-KXkgFt7gOaSUzoJhNxSJvA-1; Fri, 10 Jun 2022 10:14:48 +0100
X-MC-Unique: KXkgFt7gOaSUzoJhNxSJvA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.36; Fri, 10 Jun 2022 10:14:45 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.036; Fri, 10 Jun 2022 10:14:45 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Jan Engelhardt' <jengelh@inai.de>
CC:     'Bill Wendling' <morbo@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bill Wendling <isanbard@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Phillip Potter <phil@philpotter.co.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jan Kara <jack@suse.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
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
Thread-Index: AQHYfFM1C3rJ7kSMAEGkdVTZFYHL+K1ISrPg///1DYCAABtWMA==
Date:   Fri, 10 Jun 2022 09:14:45 +0000
Message-ID: <724889aa6a8d4d41b8557733610c7657@AcuMS.aculab.com>
References: <20220609221702.347522-1-morbo@google.com>
 <20220609152527.4ad7862d4126e276e6f76315@linux-foundation.org>
 <CAGG=3QXDt9AeCQOAp1311POFRSByJru4=Q=oFiQn3u2iZYk2_w@mail.gmail.com>
 <01da36bfd13e421aadb2eff661e7a959@AcuMS.aculab.com>
 <o5496n8r-451p-751-3258-97112opns7s8@vanv.qr>
In-Reply-To: <o5496n8r-451p-751-3258-97112opns7s8@vanv.qr>
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
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSmFuIEVuZ2VsaGFyZHQNCj4gU2VudDogMTAgSnVuZSAyMDIyIDA5OjMyDQo+IA0KPiAN
Cj4gT24gRnJpZGF5IDIwMjItMDYtMTAgMTA6MTcsIERhdmlkIExhaWdodCB3cm90ZToNCj4gPj4N
Cj4gPj4gQ2FsbGluZyBhICJwcmludGYiIHN0eWxlIGZ1bmN0aW9uIGlzIGFscmVhZHkgaW5zYW5l
bHkgZXhwZW5zaXZlLiA6LSkgSQ0KPiA+PiB1bmRlcnN0YW5kIHRoYXQgaXQncyBub3Qgb2theSBi
bGl0aGVseSB0byBpbmNyZWFzZSBydW50aW1lIHJlc291cmNlcw0KPiA+PiBzaW1wbHkgYmVjYXVz
ZSBpdCdzIGFscmVhZHkgc2xvdywgYnV0IGluIHRoaXMgY2FzZSBpdCdzIHdvcnRod2hpbGUuDQo+
ID4NCj4gPlllcCwgSU1ITyBkZWZpbml0ZWx5IHNob3VsZCBiZSBmaXhlZC4NCj4gPkl0IGlzIGV2
ZW4gcG9zc2libGUgdGhhdCB1c2luZyAiJXMiIGlzIGZhc3RlciBiZWNhdXNlIHRoZSBwcmludGYN
Cj4gPmNvZGUgZG9lc24ndCBoYXZlIHRvIHNjYW4gdGhlIHN0cmluZyBmb3IgZm9ybWF0IGVmZmVj
dG9ycy4NCj4gDQo+IEkgc2VlIG5vIHNwZWNpYWwgaGFuZGxpbmc7IHRoZSB2c25wcmludGYgZnVu
Y3Rpb24ganVzdCBsb29wcw0KPiBvdmVyIGZtdCBhcyB1c3VhbCBhbmQgSSBzZWUgbm8gc3BlY2lh
bCBjYXNpbmcgb2YgZm10IGJ5DQo+IGUuZy4gc3RyY21wKGZtdCwgIiVzIinCoD09IDAgdG8gdGFr
ZSBhIHNob3J0Y3V0Lg0KDQpDb25zaWRlciB0aGUgZGlmZmVyZW5jZSBiZXR3ZWVuOg0KCXByaW50
ZigiZnViYXIiKTsNCmFuZA0KCXByaW50ZigiJXMiLCAiZnViYXIiKTsNCkluIHRoZSBmb3JtZXIg
YWxsIG9mICJmdWJhciIgaXMgY2hlY2tlZCBmb3IgJyUnLg0KSW4gdGhlIGxhdHRlciBvbmx5IHRo
ZSBsZW5ndGggb2YgImZ1YmFyIiBoYXMgdG8gYmUgY291bnRlZC4NCg0KRldJVyB0aGUgcGF0Y2gg
ZGVzY3JpcHRpb24gc2hvdWxkIHByb2JhYmx5IGJ5Og0KCXVzZSAiJXMiIHdoZW4gZm9ybWF0dGlu
ZyBhIHNpbmdsZSBzdHJpbmcuDQoob3Igc29tZXRoaW5nIHRvIHRoYXQgZWZmZWN0KS4NCg0KCURh
dmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3Vu
dCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3
Mzg2IChXYWxlcykNCg==

