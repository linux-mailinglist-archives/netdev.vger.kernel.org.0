Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D015BFBB7
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 01:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728076AbfIZXN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 19:13:59 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:34530 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726593AbfIZXN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 19:13:59 -0400
Received: by mail-io1-f67.google.com with SMTP id q1so11170635ion.1;
        Thu, 26 Sep 2019 16:13:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=n7FGhqIXnaRnXtBhKpNAJjT2/xTf5YMUgnc1ITgZ08w=;
        b=Ww/9yr+//HxUbXcr8HtotbL9MNnpbX/ifROgXqz9al72rvoLMUEbRmO7e3MCPDHmls
         3kbyLEGQNHse3JHNhEeDi3Uv4iza5LkGIj5TwqTmKGNWfplEGpb6zKaDbvJNMb8H3iwf
         s7ZsJjwe2p1QBzUMPhwrfQLk3L2YuM9NMfTGDSLD6qK/ZxgeDodZLNZMT/BvG+dnjJau
         +TeqamGnz7WK/GK1GbFoqwVIWJG28IjTCO7wqKnCG7ce7Hq3H1xGefSqB8S8bjd/jAHK
         iTNLQdu8sBRZpNkMe10ly6PudwUr/TEoMg6T0bQwQsbrUSffMSQBjd02kZx0U/v5JF3N
         8Qjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=n7FGhqIXnaRnXtBhKpNAJjT2/xTf5YMUgnc1ITgZ08w=;
        b=dymffyU1jOnI2L/ic4ix5NP9CUq1RitwpLz8vtAh5zbAoj7hoHZYQ2Y84Fu6sf3vI6
         VfoX0SlrF6wxcLmMtBevJpoXhap42XTLNCXBEtnb02V0XZC1mrY+j/S8BfwOMp4AYW7W
         UcHGNeLS1k2zdaqFstyDr8ZvH/AhohV7MlLVJAYizLT47dOxqV2uSyM3xBo65JX70AGF
         lz+jwxn/g0UzVmLptoy6JgUKqEMrLbRmuLM/aaawat47N6FUfKXcqFHl2y0Ok3cGWC5b
         M2SNewuJqBkluuaL4pntonUHAZKVF2cMf3qH6jUbVZTwCPRU39FUQhOQajnOIaY0b34o
         229A==
X-Gm-Message-State: APjAAAXOGaKr1QmOEyHGLccWUWfwiAoFWOTsPBEAJikIUQdyOXNpLkLQ
        NnH5we4eS/sYAGFt0emzHAunmDhgKHjFZluC3cA=
X-Google-Smtp-Source: APXvYqyFzNq8hVq+xsKJZZIJRnMe076aIFJdTpQUUt8bsTXAs/+I5NfVgzlp99rl6jeV7dWyKWIhyIssxYbjjdWrUWM=
X-Received: by 2002:a6b:5814:: with SMTP id m20mr5617613iob.249.1569539636446;
 Thu, 26 Sep 2019 16:13:56 -0700 (PDT)
MIME-Version: 1.0
References: <20190925161255.1871-1-ard.biesheuvel@linaro.org>
 <CAHmME9oDhnv7aX77oEERof0TGihk4mDe9B_A3AntaTTVsg9aoA@mail.gmail.com>
 <MN2PR20MB29733663686FB38153BAE7EACA860@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAHmME9r5m7D-oMU6Lv_ZhEyWmrNscMr5HokzdK0wg2Ayzzbeow@mail.gmail.com> <MN2PR20MB29733A5E504126B6F4098136CA860@MN2PR20MB2973.namprd20.prod.outlook.com>
In-Reply-To: <MN2PR20MB29733A5E504126B6F4098136CA860@MN2PR20MB2973.namprd20.prod.outlook.com>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Thu, 26 Sep 2019 16:13:45 -0700
Message-ID: <CAA93jw5__kXT-WAPBjseZP1kkkftH5nfVOiFA6BZrNS9sLGdoQ@mail.gmail.com>
Subject: Re: chapoly acceleration hardware [Was: Re: [RFC PATCH 00/18] crypto:
 wireguard using the existing crypto API]
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Willy Tarreau <w@1wt.eu>, Netdev <netdev@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 26, 2019 at 6:52 AM Pascal Van Leeuwen
<pvanleeuwen@verimatrix.com> wrote:
>
> > -----Original Message-----
> > From: Jason A. Donenfeld <Jason@zx2c4.com>
> > Sent: Thursday, September 26, 2019 1:07 PM
> > To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> > Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>; Linux Crypto Mailing Li=
st <linux-
> > crypto@vger.kernel.org>; linux-arm-kernel <linux-arm-kernel@lists.infra=
dead.org>;
> > Herbert Xu <herbert@gondor.apana.org.au>; David Miller <davem@davemloft=
.net>; Greg KH
> > <gregkh@linuxfoundation.org>; Linus Torvalds <torvalds@linux-foundation=
.org>; Samuel
> > Neves <sneves@dei.uc.pt>; Dan Carpenter <dan.carpenter@oracle.com>; Arn=
d Bergmann
> > <arnd@arndb.de>; Eric Biggers <ebiggers@google.com>; Andy Lutomirski <l=
uto@kernel.org>;
> > Will Deacon <will@kernel.org>; Marc Zyngier <maz@kernel.org>; Catalin M=
arinas
> > <catalin.marinas@arm.com>; Willy Tarreau <w@1wt.eu>; Netdev <netdev@vge=
r.kernel.org>;
> > Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>; Dave Taht <dave.taht@g=
mail.com>
> > Subject: chapoly acceleration hardware [Was: Re: [RFC PATCH 00/18] cryp=
to: wireguard
> > using the existing crypto API]
> >
> > [CC +willy, toke, dave, netdev]
> >
> > Hi Pascal
> >
> > On Thu, Sep 26, 2019 at 12:19 PM Pascal Van Leeuwen
> > <pvanleeuwen@verimatrix.com> wrote:
> > > Actually, that assumption is factually wrong. I don't know if anythin=
g
> > > is *publicly* available, but I can assure you the silicon is running =
in
> > > labs already. And something will be publicly available early next yea=
r
> > > at the latest. Which could nicely coincide with having Wireguard supp=
ort
> > > in the kernel (which I would also like to see happen BTW) ...
> > >
> > > Not "at some point". It will. Very soon. Maybe not in consumer or ser=
ver
> > > CPUs, but definitely in the embedded (networking) space.
> > > And it *will* be much faster than the embedded CPU next to it, so it =
will
> > > be worth using it for something like bulk packet encryption.
> >
> > Super! I was wondering if you could speak a bit more about the
> > interface. My biggest questions surround latency. Will it be
> > synchronous or asynchronous?
> >
> The hardware being external to the CPU and running in parallel with it,
> obviously asynchronous.
>
> > If the latter, why?
> >
> Because, as you probably already guessed, the round-trip latency is way
> longer than the actual processing time, at least for small packets.
>
> Partly because the only way to communicate between the CPU and the HW
> accelerator (whether that is crypto, a GPU, a NIC, etc.) that doesn't
> keep the CPU busy moving data is through memory, with the HW doing DMA.
> And, as any programmer should now, round trip times to memory are huge
> relative to the processing speed.
>
> And partly because these accelerators are very similar to CPU's in
> terms of architecture, doing pipelined processing and having multiple
> of such pipelines in parallel. Except that these pipelines are not
> working on low-level instructions but on full packets/blocks. So they
> need to have many packets in flight to keep those pipelines fully
> occupied. And packets need to move through the various pipeline stages,
> so they incur the time needed to process them multiple times. (just
> like e.g. a multiply instruction with a throughput of 1 per cycle
> actually may need 4 or more cycles to actually provide its result)
>
> Could you do that from a synchronous interface? In theory, probably,
> if you would spawn a new thread for every new packet arriving and
> rely on the scheduler to preempt the waiting threads. But you'd need
> as many threads as the HW  accelerator can have packets in flight,
> while an async would need only 2 threads: one to handle the input to
> the accelerator and one to handle the output (or at most one thread
> per CPU, if you want to divide the workload)
>
> Such a many-thread approach seems very inefficient to me.
>
> > What will its latencies be?
> >
> Depends very much on the specific integration scenario (i.e. bus
> speed, bus hierarchy, cache hierarchy, memory speed, etc.) but on
> the order of a few thousand CPU clocks is not unheard of.
> Which is an eternity for the CPU, but still only a few uSec in
> human time. Not a problem unless you're a high-frequency trader and
> every ns counts ...
> It's not like the CPU would process those packets in zero time.
>
> > How deep will its buffers be?
> >
> That of course depends on the specific accelerator implementation,
> but possibly dozens of small packets in our case, as you'd need
> at least width x depth packets in there to keep the pipes busy.
> Just like a modern CPU needs hundreds of instructions in flight
> to keep all its resources busy.
>
> > The reason I ask is that a
> > lot of crypto acceleration hardware of the past has been fast and
> > having very deep buffers, but at great expense of latency.
> >
> Define "great expense". Everything is relative. The latency is very
> high compared to per-packet processing time but at the same time it's
> only on the order of a few uSec. Which may not even be significant on
> the total time it takes for the packet to travel from input MAC to
> output MAC, considering the CPU will still need to parse and classify
> it and do pre- and postprocessing on it.
>
> > In the networking context, keeping latency low is pretty important.
> >
> I've been doing this for IPsec for nearly 20 years now and I've never
> heard anyone complain about our latency, so it must be OK.

Well, it depends on where your bottlenecks are. On low-end hardware
you can and do tend to bottleneck on the crypto step, and with
uncontrolled, non-fq'd non-aqm'd buffering you get results like this:

http://blog.cerowrt.org/post/wireguard/

so in terms of "threads" I would prefer to think of flows entering
the tunnel and attempting to multiplex them as best as possible
across the crypto hard/software so that minimal in-hw latencies are experie=
nced
for most packets and that the coupled queue length does not grow out of con=
trol,

Adding fq_codel's hashing algo and queuing to ipsec as was done in
commit: 264b87fa617e758966108db48db220571ff3d60e to leverage
the inner hash...

Had some nice results:

before: http://www.taht.net/~d/ipsec_fq_codel/oldqos.png (100ms spikes)
After: http://www.taht.net/~d/ipsec_fq_codel/newqos.png (2ms spikes)

I'd love to see more vpn vendors using the rrul test or something even
nastier to evaluate their results, rather than dragstrip bulk throughput te=
sts,
steering multiple flows over multiple cores.

> We're also doing (fully inline, no CPU involved) MACsec cores, which
> operate at layer 2 and I know it's a concern there for very specific
> use cases (high frequency trading, precision time protocol, ...).
> For "normal" VPN's though, a few uSec more or less should be a non-issue.

Measured buffering is typically 1000 packets in userspace vpns. If you
can put data in, faster than you can get it out, well....

> > Already
> > WireGuard is multi-threaded which isn't super great all the time for
> > latency (improvements are a work in progress). If you're involved with
> > the design of the hardware, perhaps this is something you can help
> > ensure winds up working well? For example, AES-NI is straightforward
> > and good, but Intel can do that because they are the CPU. It sounds
> > like your silicon will be adjacent. How do you envision this working
> > in a low latency environment?
> >
> Depends on how low low-latency is. If you really need minimal latency,
> you need an inline implementation. Which we can also provide, BTW :-)
>
> Regards,
> Pascal van Leeuwen
> Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
> www.insidesecure.com



--=20

Dave T=C3=A4ht
CTO, TekLibre, LLC
http://www.teklibre.com
Tel: 1-831-205-9740
