Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C354403D41
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 18:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235639AbhIHQG0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 8 Sep 2021 12:06:26 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:36093 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229795AbhIHQGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 12:06:25 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-193-6kt6kR_2ONqOOT2qFdPoMg-1; Wed, 08 Sep 2021 17:05:15 +0100
X-MC-Unique: 6kt6kR_2ONqOOT2qFdPoMg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.23; Wed, 8 Sep 2021 17:05:12 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.023; Wed, 8 Sep 2021 17:05:12 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Wei Liu' <wei.liu@kernel.org>
CC:     Linus Torvalds <torvalds@linux-foundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Brendan Higgins <brendanhiggins@google.com>,
        Ariel Elior <aelior@marvell.com>,
        "GR-everest-linux-l2@marvell.com" <GR-everest-linux-l2@marvell.com>,
        "Linux ARM" <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: RE: ipv4/tcp.c:4234:1: error: the frame size of 1152 bytes is larger
 than 1024 bytes [-Werror=frame-larger-than=]
Thread-Topic: ipv4/tcp.c:4234:1: error: the frame size of 1152 bytes is larger
 than 1024 bytes [-Werror=frame-larger-than=]
Thread-Index: AQHXpJjLHdBfxh/omUuYsxLT8U4Q1auaODzA///43ICAABV5QA==
Date:   Wed, 8 Sep 2021 16:05:12 +0000
Message-ID: <e8d16a01fd3144f1b57faae59f991579@AcuMS.aculab.com>
References: <CA+G9fYtFvJdtBknaDKR54HHMf4XsXKD4UD3qXkQ1KhgY19n3tw@mail.gmail.com>
 <CAHk-=wisUqoX5Njrnnpp0pDx+bxSAJdPxfgEUv82tZkvUqoN1w@mail.gmail.com>
 <CAHk-=whF9F89vsfH8E9TGc0tZA-yhzi2Di8wOtquNB5vRkFX5w@mail.gmail.com>
 <20210908100304.oknxj4v436sbg3nb@liuwe-devbox-debian-v2>
 <46be667d057f413aac7871ebe784e274@AcuMS.aculab.com>
 <20210908152351.asln63jxk43xffib@liuwe-devbox-debian-v2>
In-Reply-To: <20210908152351.asln63jxk43xffib@liuwe-devbox-debian-v2>
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
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Liu
> Sent: 08 September 2021 16:24
> 
> On Wed, Sep 08, 2021 at 02:51:21PM +0000, David Laight wrote:
> > From: Wei Liu
> > > Sent: 08 September 2021 11:03
> > ...
> > > However calling into the allocator from that IPI path seems very heavy
> > > weight. I will discuss with fellow engineers on how to fix it properly.
> >
> > Isn't the IPI code something that is likely to get called
> > when a lot of stack has already been used?
> >
> > So you really shouldn't be using much stack at all??
> 
> I don't follow your questions. I don't dispute there is a problem. I
> just think calling into the allocator is not a good idea in that
> particular piece of code we need to fix.
> 
> Hopefully we can come up with a solution to remove need for a cpumask in
> that code -- discussion is on-going.

I'm pretty sure the IPI interrupt is high priority so can
nest with another interrupt.
(You certainly want it to be that way.)

So the kernel may already be running on the interrupt stack.
If the interrupted ISR code has used a lot of stack then
there may not be as much left as you might expect.

Many years ago (nearly 40!) I wrote something that did static
stack depth analysis for an embedded system.
Since there were no (interesting) indirect calls an no recursion
it wasn't completely impossible.
What it showed was that the deepest stack use was in error
trace paths that probably never happened.
I suspect the same is true for Linux - the deepest points
will be inside printk() in obscure error paths.
Get an IPI while in a printk() from deep inside an ISR
and you may not have the amount of stack you expect.

It might be possible to use the clang 'control flow integrity'
information to determine the actual maximum stack use even
for indirectly called functions.
I suspect that would be an eye-opener....

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

