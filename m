Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B08809978A
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 16:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389188AbfHVO7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 10:59:03 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:33180 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732133AbfHVO7D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 10:59:03 -0400
Received: by mail-ed1-f67.google.com with SMTP id s15so8443680edx.0;
        Thu, 22 Aug 2019 07:59:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0EDOAiJ2sQvkV1bWTPzSAn6c4tNAM7gVRqgo0jG7tMk=;
        b=WXMAQwvg/aq4783doBQASaVE7XFWImaq2MKjIHwett1eD1p63AKs8917lrJxBmNZWC
         /4p9FPI1/8E1NKxvuWHG+68hsRCHDQFtsi8dAi11G5NtAAJA/EnEeziWMPC/qgvUzj9O
         iu8OiS40itMJAn9d+YmCFJokI+2RB9yDHxn8aLe7g2+QR4tL2x7cgvdDWBaEMVhsJ5f+
         ftajrVN2IBKUlejlcTOsIG7BEBvMLXM4EHzp0u0KDcncjU8Y7nibpfuIBL66frMoF+1u
         m/2zEi84yc0+LfxwuE5iIe8jZ6HJ7Iov7WdraTLZ0x2H8980B5x4S4em1PWM0D+yUquV
         uO0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0EDOAiJ2sQvkV1bWTPzSAn6c4tNAM7gVRqgo0jG7tMk=;
        b=L+pItU56XMQzVszgVGylojMBSG0UK+tffi8FIEEPCMXowu6R1r7SkTepV2AD020v8f
         ONjaclz8p/azbYH0ieZI6r8QTYoa/bcvlHmjaAIvxQ2Xr56ae/pOY6fThP23esXCw06Y
         EORVQJ9uutACEEqlIxg23hDDfZnkFhVt0J+h71pcDnueM1mN32Ig6IFyecS9ODDQt7vm
         feMSBSIpynL4DPTgXQEz6y/P7JfEUWBbRoYGzXcRKqs7DeosiP/LedLlPX65qGjCNuDi
         c6qp4IlJtGh8x32xM0gtkzTj5aUGCrkmgLsdJpcMNBYyRIlunoWbQ+SAQH5oRZf7nC/W
         H7fg==
X-Gm-Message-State: APjAAAWOlWP5I70DJ6J16XPWME6oo5G8lsVxHnUezCESdgHvOh0IixUv
        p85sLaKOnfxiDb5iGY4RpC8DMKn8stHn3NCtLCpRGnYL
X-Google-Smtp-Source: APXvYqwQ4KKmKBqRRkGh72YlmA/4RmiXM6B5RJmVe0CiAgThOigahg8e/jdI5x3WW+hoVnbc0O8niXnZP6/y9SQA7mE=
X-Received: by 2002:a17:907:2069:: with SMTP id qp9mr35727253ejb.90.1566485940775;
 Thu, 22 Aug 2019 07:59:00 -0700 (PDT)
MIME-Version: 1.0
References: <20190818182600.3047-1-olteanv@gmail.com> <CA+h21hr4UcoJK7upNJjG0ibtX7CkF=akxVdrb--1AJn6-z=sUQ@mail.gmail.com>
 <20190821043845.GB1332@localhost> <20190821140815.GA1447@localhost>
 <CA+h21hrtzU1XL-0m+BG5TYZvVh8WN6hgcM7CV5taHyq2MsR5dw@mail.gmail.com> <20190822141641.GB1437@localhost>
In-Reply-To: <20190822141641.GB1437@localhost>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 22 Aug 2019 17:58:49 +0300
Message-ID: <CA+h21hpJm-3svfV93pYYrpoiV12jDjuROHCgvCjPivAjXTB_VA@mail.gmail.com>
Subject: Re: [PATCH spi for-5.4 0/5] Deterministic SPI latency with NXP DSPI driver
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Mark Brown <broonie@kernel.org>,
        Hubert Feurstein <h.feurstein@gmail.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-spi@vger.kernel.org, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Aug 2019 at 17:16, Richard Cochran <richardcochran@gmail.com> wrote:
>
> On Wed, Aug 21, 2019 at 11:17:23PM +0300, Vladimir Oltean wrote:
> > Of course PPS with a dedicated hardware receiver that can take input
> > compare timestamps is always preferable. However non-Ethernet
> > synchronization in the field looks to me like "make do with whatever
> > you can". I'm not sure a plain GPIO that raises an interrupt is better
> > than an interrupt-driven serial protocol controller - it's (mostly)
> > the interrupts that throw off the precision of the software timestamp.
> > And use Miroslav's pps-gpio-poll module and you're back from where you
> > started (try to make a sw timestamp as precise as possible).
>
> Right, it might be better, might not.  You can consider hacking a
> local time stamp into the ISR.  Also, if one of your MACs has a input
> event pin, you can feed the switch's PPS output in there.
>
> > wouldn't be my first choice. But DSA could have that built-in, and
> > with the added latency benefit of a MAC-to-MAC connection.
> > Too bad the mv88e6xxx driver can't do loopback timestamping, that's
> > already 50% of the DSA drivers that support PTP at all. An embedded
> > solution for this is less compelling now.
>
> Let me back track on my statement about mv88e6xxx.  At the time, I
> didn't see any practical way to use the CPU port for synchronization,
> but I forget exactly the details.  Maybe it is indeed possible,
> somehow.  If you can find a way that will work on your switch and on
> the Marvell, then I'd like to hear about it.
>
> Thinking back...
>
> One problem is this.  PTP requires a delay measurement.  You can send
> a delay request from the host, but there will never be a reply.
>

I don't think I understand the problem here.
You need to think about this as a sort of degenerate PTP where the
master and the slave are under the same device's management, not the
full stack. I never actually said I want to make ptp4l work over the
CPU port.
So instead of the typical:

Master (device A)                Slave (device B)

    |                            |         Tstamps known
 t1 |------\      Sync           |         to slave
    |       \-----\              |
    |              \-----\       |
    |                     \----->| t2      t2
    |------\    Follow_up        |
    |       \-----\              |
    |              \-----\       |
    |                     \----->| t1      t1, t2
    |                            |
    |          Delay_req  /------| t3      t1, t2, t3
    |              /-----/       |
    |       /-----/              |
 t4 |<-----/                     |
    |                            |
    |------\    Follow_up        |
    |       \-----\              |
    |              \-----\       |
    |                     \----->|         t1, t2, t3, t4
    |                            |
    |                            |
    |                            |
    |                            |
    v           time             v

You'd have something like this:

Master (DSA master port)         Slave (switch CPU port)

    |                            |         Tstamps known
    |                            |         to slave
    |       Local_sync_req       |
 t1 |------\                     |         t1
    |       \-----\              |
    |              \-----\       |
    |                     \----->| t2      t1, t2
    |                            |
    |     Local_sync_resp /------| t3      t1, t2, t3
    |              /-----/       |
    |       /-----/              |
 t4 |<-----/                     |         t1, t2, t3, t4
    |                            |
    |                            |
    v           time             v

As far as I understand PTP, the other messages are just protocol
blah-blah because the slave doesn't know what the master knows, which
is clearly not applicable here.
t1, t2, t3, t4 still keep the same definitions though (master TX
timestamp, slave RX timestamp, slave TX timestamp, master RX
timestamp).
I'm 90% certain the sja1105 can take an RX timestamp for a management
frame (e.g. one for which a TX timestamp was requested) sent in
loopback.

> Another problem is this.  A Sync message arriving on an external port
> is time stamped there, but then it is encapsulated as a tagged DSA
> management message and delivered out the CPU port.  At this point, it
> is no longer a PTP frame and will not be time stamped at the CPU port
> on egress.
>

But you don't mean a TX timestamp at the egress of swp4 here, do you?

 +---------------------------------+
 |  Management CPU                 |
 |                                 |
 |           DSA master            |
 |             +-----+             |
 |             |     |             |
 |             |     |             |
 +-------------+-----+-------------+
           eth0   ^ RX tstamp
                  |
                  | TX tstamp
        (swp4) CPU port
 +-------------+-----+-------------+
 |  Switch     |     |             |
 |             |     |             |
 |             +-----+             |
 |                ^ T              |
 |                |                |
 |    +-----------+                |
 |    |                            |
 |    |                            |
 | +-----+ +-----+ +-----+ +-----+ |
 | |     | |     | |     | |     | |
 | |     | |     | |     | |     | |
 +-+-----+-+-----+-+-----+-+-----+-+
   swp0    swp1    swp2    swp3
      ^
      | RX tstamp

Why would that matter?
Or just the RX timestamp at eth0?
If you mean the latter, then yes, having HWTSTAMP_FILTER_ALL in the
rx_filter of the DSA master is a hard requirement.

> Thanks,
> Richard
