Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBB65B74F4
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 10:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731259AbfISISh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 04:18:37 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:46117 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728879AbfISISh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 04:18:37 -0400
Received: by mail-ed1-f66.google.com with SMTP id t3so2315863edw.13
        for <netdev@vger.kernel.org>; Thu, 19 Sep 2019 01:18:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lb4isSJ9swSEwMr0ORO9sLPJF9v0a3ozkaiOYGCDe+E=;
        b=H+nHZiNT2emLqCBkAznOh9dTnY043w0FbcxvN142w5U/nKTgRjgV80tbn7cMosIBST
         YPPsOOErkwK9H1vKM+wIeJH9fPjqVGninAnnWDQccbH2Id4kq4/V9yP2KBW9D78z5jAC
         bn1R67+nUS6hdv3NURASCFdqaRbZuuQrpN71iggG0XUaO21mXLQEW6AG723illjLYueI
         eESrpV1Jvg6K5KTQFOcsXGLSgMBKAvZNHIN9tkcv9Gx13xDm7qgbjQUH3AQvrDxmRsCz
         lEwQaQmG9wwk516Jww2gHx0W+obJtI5Z+XVJ4sqdGUD11cPPrF5T0JF3l7/hJ456p4Ps
         DSpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lb4isSJ9swSEwMr0ORO9sLPJF9v0a3ozkaiOYGCDe+E=;
        b=lJFsy2C3ZADdSzRqL1zaIzZnVKSC7uuAaEktbVdS7Y6Nb9YsyL2wC6FAO2ETGX+4Hj
         tR2bHNhUmOY0Gm9+3JcY5jnf1CN3vp1wurKFSEMiNZkEIkzVuuHnIshilJ18tyvNRuOt
         62QkUNSyPaznYf886lDILx2vx4zqQBZ1zp0h1GXQmUWAzfR76QEatbrukKr1OxbCKeJk
         c/e4jjBw4+5RVRwFNuxhoAATs8orz6RXAENcWEjQUDHtpUYu8LlPNcKMxw2wMPiJz9x0
         vmpv1uKXsidQJNTTjtNka4ptnqliWgHBCRiK2CGi+peIrpKTzZLGzi44P5hx5Efl3RcV
         /uqw==
X-Gm-Message-State: APjAAAVmR/oXuaJ9c2UUO0Ixwxcp90lnD/M1CBgjEtqiqlcnqVZxgoEf
        clpLQWmYscy7ZteE2nTCRey5/7PwzutblG0LqFDtlQ==
X-Google-Smtp-Source: APXvYqyaaVUmc6sgTrKbAEY2ofcyoQ+bJpUr9z7WY6mZgC0XuxcH6QykDjxrPL4Gzjwr2nnNjV16YrUCEjIwS11TEXk=
X-Received: by 2002:a17:906:e297:: with SMTP id gg23mr210633ejb.47.1568881115287;
 Thu, 19 Sep 2019 01:18:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190918140225.imqchybuf3cnknob@pengutronix.de>
 <CA+h21hpG52R6ScGpGX86Q7MuRHCgGNY-TxzaQGu2wZR8EtPtbA@mail.gmail.com> <20190919080051.mr3cszpyypwqjwu4@pengutronix.de>
In-Reply-To: <20190919080051.mr3cszpyypwqjwu4@pengutronix.de>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 19 Sep 2019 11:18:24 +0300
Message-ID: <CA+h21hqibrGksG=k7TkjiToDFZ-putaonO+tCb_=nxs1ig0djA@mail.gmail.com>
Subject: Re: dsa traffic priorization
To:     Sascha Hauer <s.hauer@pengutronix.de>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Florian Fainelli <f.fainelli@gmail.com>, kernel@pengutronix.de
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Sep 2019 at 11:00, Sascha Hauer <s.hauer@pengutronix.de> wrote:
>
> Hi Vladimir,
>
> On Wed, Sep 18, 2019 at 05:36:08PM +0300, Vladimir Oltean wrote:
> > Hi Sascha,
> >
> > On Wed, 18 Sep 2019 at 17:03, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> > >
> > > Hi All,
> > >
> > > We have a customer using a Marvell 88e6240 switch with Ethercat on one port and
> > > regular network traffic on another port. The customer wants to configure two things
> > > on the switch: First Ethercat traffic shall be priorized over other network traffic
> > > (effectively prioritizing traffic based on port). Second the ethernet controller
> > > in the CPU is not able to handle full bandwidth traffic, so the traffic to the CPU
> > > port shall be rate limited.
> > >
> >
> > You probably already know this, but egress shaping will not drop
> > frames, just let them accumulate in the egress queue until something
> > else happens (e.g. queue occupancy threshold triggers pause frames, or
> > tail dropping is enabled, etc). Is this what you want?
>
> If I understand correctly then the switch has multiple output queues per
> port. The Ethercat traffic will go to a higher priority queue and on
> congestion on other queues, frames designated for that queue will be
> dropped. I just talked to our customer and he verified that their
> Ethercat traffic still goes through even when the ports with the general
> traffic are jammed with packets. So yes, I think this is what I want.
>

Yes, but I mean the egress shaper is per port, so when it goes out of
credits it goes out of credits, right? Meaning that even if EtherCAT
has higher strict priority, it will still experience latency caused by
the best-effort traffic consuming the port's global token bucket
credits. Sure, it may not be so bad as to actually cause tail drop,
but did you measure this?

> > It sounds a bit
> > strange to me to configure egress shaping on the CPU port of a DSA
> > switch. That literally means you are buffering frames inside the
> > system. What about ingress policing?
>
> The bottleneck here is in the CPU interface. The SoC simply can't handle
> all frames coming into a fully occupied link, so we indeed have to limit
> the number of packets coming into the SoC which speaks for egress rate
> limiting. We could of course limit the ingress packets on the other
> ports, but that would mean we have to rate limit each port to the total
> desired rate divided by the number of ports to be safe, not very
> optimal.
>

Not very optimal, but may offer better guarantees for the
high-priority traffic, and there is already a model for doing that,
unlike for egress shaping on the CPU port.
What about a software tc-police action on the DSA net device's ingress
qdisc? Is that still too high-pressure for the CPU?
Is there any flow steering rule on the CPU for processing EtherCAT
with higher priority (or affining it to a separate core)? I'm trying
to understand where the bottleneck really is.

> Sascha
>
> --
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

Thanks,
-Vladimir
