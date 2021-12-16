Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 237E0477B05
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 18:49:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240487AbhLPRth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 12:49:37 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:29203 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240483AbhLPRtb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 12:49:31 -0500
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-82-kIcKgVwCMVG34NOJowHCJQ-1; Thu, 16 Dec 2021 17:49:29 +0000
X-MC-Unique: kIcKgVwCMVG34NOJowHCJQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.26; Thu, 16 Dec 2021 17:49:27 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.026; Thu, 16 Dec 2021 17:49:27 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Ard Biesheuvel' <ardb@kernel.org>,
        Arnd Bergmann <arnd@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        Kees Cook <keescook@chromium.org>,
        "Nick Desaulniers" <ndesaulniers@google.com>
CC:     Rich Felker <dalias@libc.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        "Russell King" <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        "Paul Mackerras" <paulus@samba.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:SPARC + UltraSPARC (sparc/sparc64)" 
        <sparclinux@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        linux-arch <linux-arch@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        X86 ML <x86@kernel.org>, "James Morris" <jmorris@namei.org>,
        Ingo Molnar <mingo@redhat.com>,
        "Geert Uytterhoeven" <geert@linux-m68k.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "Richard Russon (FlatCap)" <ldm@flatcap.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Jonas Bonn <jonas@southpole.se>, Arnd Bergmann <arnd@arndb.de>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        "open list:LINUX FOR POWERPC (32-BIT AND 64-BIT)" 
        <linuxppc-dev@lists.ozlabs.org>,
        "Stefan Kristiansson" <stefan.kristiansson@saunalahti.fi>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        linux-m68k <linux-m68k@lists.linux-m68k.org>,
        "openrisc@lists.librecores.org" <openrisc@lists.librecores.org>,
        Borislav Petkov <bp@alien8.de>,
        "Stafford Horne" <shorne@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Jens Axboe <axboe@kernel.dk>,
        John Johansen <john.johansen@canonical.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "linux-ntfs-dev@lists.sourceforge.net" 
        <linux-ntfs-dev@lists.sourceforge.net>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <netdev@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>
Subject: RE: [PATCH v2 00/13] Unify asm/unaligned.h around struct helper
Thread-Topic: [PATCH v2 00/13] Unify asm/unaligned.h around struct helper
Thread-Index: AQHX8qKmJnIWdY3H8E+V3sMdrqJgg6w1YkAg
Date:   Thu, 16 Dec 2021 17:49:27 +0000
Message-ID: <5a46959bfe654ae9a8a4e1b1adf0db95@AcuMS.aculab.com>
References: <20210514100106.3404011-1-arnd@kernel.org>
 <CAMj1kXG0CNomZ0aXxh_4094fT+g4bVWFCkrd7QwgTQgiqoxMWA@mail.gmail.com>
In-Reply-To: <CAMj1kXG0CNomZ0aXxh_4094fT+g4bVWFCkrd7QwgTQgiqoxMWA@mail.gmail.com>
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

RnJvbTogQXJkIEJpZXNoZXV2ZWwNCj4gU2VudDogMTYgRGVjZW1iZXIgMjAyMSAxNzozMA0KPiAN
Cj4gSGkgQXJuZCwNCj4gDQo+IChyZXBseWluZyB0byBhbiBvbGQgdGhyZWFkIGFzIHRoaXMgY2Ft
ZSB1cCBpbiB0aGUgZGlzY3Vzc2lvbiByZWdhcmRpbmcNCj4gbWlzYWxpZ25lZCBsb2FkcyBhbmQg
c3RvcmVkIGluIHNpcGhhc2goKSB3aGVuIGNvbXBpbGVkIGZvciBBUk0NCj4gW2Y3ZTViOWJmYTZj
ODgyMDQwN2I2NGVhYmMxZjI5YzlhODdlODk5M2RdKQ0KPiANCj4gT24gRnJpLCAxNCBNYXkgMjAy
MSBhdCAxMjowMiwgQXJuZCBCZXJnbWFubiA8YXJuZEBrZXJuZWwub3JnPiB3cm90ZToNCj4gPg0K
PiA+IEZyb206IEFybmQgQmVyZ21hbm4gPGFybmRAYXJuZGIuZGU+DQo+ID4NCj4gPiBUaGUgZ2V0
X3VuYWxpZ25lZCgpL3B1dF91bmFsaWduZWQoKSBoZWxwZXJzIGFyZSB0cmFkaXRpb25hbGx5IGFy
Y2hpdGVjdHVyZQ0KPiA+IHNwZWNpZmljLCB3aXRoIHRoZSB0d28gbWFpbiB2YXJpYW50cyBiZWlu
ZyB0aGUgImFjY2Vzcy1vay5oIiB2ZXJzaW9uDQo+ID4gdGhhdCBhc3N1bWVzIHVuYWxpZ25lZCBw
b2ludGVyIGFjY2Vzc2VzIGFsd2F5cyB3b3JrIG9uIGEgcGFydGljdWxhcg0KPiA+IGFyY2hpdGVj
dHVyZSwgYW5kIHRoZSAibGUtc3RydWN0LmgiIHZlcnNpb24gdGhhdCBjYXN0cyB0aGUgZGF0YSB0
byBhDQo+ID4gYnl0ZSBhbGlnbmVkIHR5cGUgYmVmb3JlIGRlcmVmZXJlbmNpbmcsIGZvciBhcmNo
aXRlY3R1cmVzIHRoYXQgY2Fubm90DQo+ID4gYWx3YXlzIGRvIHVuYWxpZ25lZCBhY2Nlc3NlcyBp
biBoYXJkd2FyZS4NCg0KSSdtIHByZXR0eSBzdXJlIHRoZSBjb21waWxlciBpcyBhbGxvd2VkIHRv
ICdyZWFkIHRocm91Z2gnIHRoYXQgY2FzdA0KYW5kIHN0aWxsIGRvIGFuIGFsaWduZWQgYWNjZXNz
Lg0KSXQgaGFzIGFsd2F5cyBiZWVuIGhhcmQgdG8gZ2V0IHRoZSBjb21waWxlciB0byAnZm9yZ2V0
JyBhYm91dCBrbm93bi9leHBlY3RlZA0KYWxpZ25tZW50IC0gdHlwaWNhbGx5IHRyeWluZyB0byBz
dG9wIG1lbWNweSgpIGZhdWx0aW5nIG9uIHNwYXJjLg0KUmVhbCBmdW5jdGlvbiBjYWxscyBhcmUg
dXN1YWxseSByZXF1aXJlZCAtIGJ1dCBMVE8gbWF5IHNjdXBwZXIgdGhhdC4NCg0KPiA+DQo+ID4g
QmFzZWQgb24gdGhlIGRpc2N1c3Npb24gbGlua2VkIGJlbG93LCBpdCBhcHBlYXJzIHRoYXQgdGhl
IGFjY2Vzcy1vaw0KPiA+IHZlcnNpb24gaXMgbm90IHJlYWxpYWJsZSBvbiBhbnkgYXJjaGl0ZWN0
dXJlLCBidXQgdGhlIHN0cnVjdCB2ZXJzaW9uDQo+ID4gcHJvYmFibHkgaGFzIG5vIGRvd25zaWRl
cy4gVGhpcyBzZXJpZXMgY2hhbmdlcyB0aGUgY29kZSB0byB1c2UgdGhlDQo+ID4gc2FtZSBpbXBs
ZW1lbnRhdGlvbiBvbiBhbGwgYXJjaGl0ZWN0dXJlcywgYWRkcmVzc2luZyB0aGUgZmV3IGV4Y2Vw
dGlvbnMNCj4gPiBzZXBhcmF0ZWx5Lg0KPiA+DQo+ID4gSSd2ZSBpbmNsdWRlZCB0aGlzIHZlcnNp
b24gaW4gdGhlIGFzbS1nZW5lcmljIHRyZWUgZm9yIDUuMTQgYWxyZWFkeSwNCj4gPiBhZGRyZXNz
aW5nIHRoZSBmZXcgaXNzdWVzIHRoYXQgd2VyZSBwb2ludGVkIG91dCBpbiB0aGUgUkZDLiBJZiB0
aGVyZQ0KPiA+IGFyZSBhbnkgcmVtYWluaW5nIHByb2JsZW1zLCBJIGhvcGUgdGhvc2UgY2FuIGJl
IGFkZHJlc3NlZCBhcyBmb2xsb3ctdXANCj4gPiBwYXRjaGVzLg0KPiA+DQo+IA0KPiBJIHRoaW5r
IHRoaXMgc2VyaWVzIGlzIGEgaHVnZSBpbXByb3ZlbWVudCwgYnV0IGl0IGRvZXMgbm90IHNvbHZl
IHRoZQ0KPiBVQiBwcm9ibGVtIGNvbXBsZXRlbHkuIEFzIHdlIGZvdW5kLCB0aGVyZSBhcmUgb3Bl
biBpc3N1ZXMgaW4gdGhlIEdDQw0KPiBidWd6aWxsYSByZWdhcmRpbmcgYXNzdW1wdGlvbnMgaW4g
dGhlIGNvbXBpbGVyIHRoYXQgYWxpZ25lZCBxdWFudGl0aWVzDQo+IGVpdGhlciBvdmVybGFwIGVu
dGlyZWx5IG9yIG5vdCBhdCBhbGwuIChlLmcuLA0KPiBodHRwczovL2djYy5nbnUub3JnL2J1Z3pp
bGxhL3Nob3dfYnVnLmNnaT9pZD0xMDAzNjMpDQoNCkkgdGhpbmsgd2UgY2FuIHN0b3AgdGhlIGNv
bXBpbGVyIG1lcmdpbmcgdW5hbGlnbmVkIHJlcXVlc3RzIGJ5IGFkZGluZyBhIGJ5dGUtc2l6ZWQN
Cm1lbW9yeSBiYXJyaWVyIGZvciB0aGUgYmFzZSBhZGRyZXNzIGJlZm9yZSBhbmQgYWZ0ZXIgdGhl
IGFjY2Vzcy4NClRoYXQgc2hvdWxkIHN0aWxsIHN1cHBvcnQgY29tcGxleCBhZGRyZXNzaW5nIG1v
ZGVzIChlc3Agb24geDg2KS4NCg0KQW5vdGhlciBvcHRpb24gaXMgdG8gZG8gdGhlIG1pc2FsaWdu
ZWQgYWNjZXNzIGZyb20gd2l0aGluIGFuIGFzbSBzdGF0ZW1lbnQuDQpXaGlsZSBhcmNoaXRlY3R1
cmUgZGVwZW5kYW50LCBpdCBvbmx5IHJlYWxseSBkZXBlbmRzIG9uIHRoZSBzeW50YXggb2YgdGhl
IGxkL3N0DQppbnN0cnVjdGlvbi4NClRoZSBjb21waWxlciBjYW4ndCBtZXJnZSB0aG9zZSBiZWNh
dXNlIGl0IGRvZXNuJ3Qga25vdyB3aGV0aGVyIHRoZSBkYXRhIGlzDQonZnJvYmJlZCcgYmVmb3Jl
L2FmdGVyIHRoZSBtZW1vcnkgYWNjZXNzLg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRy
ZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1L
MSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

