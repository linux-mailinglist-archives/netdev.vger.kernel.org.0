Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65042ACC55
	for <lists+netdev@lfdr.de>; Sun,  8 Sep 2019 13:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728775AbfIHLHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Sep 2019 07:07:30 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:36726 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728727AbfIHLHa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Sep 2019 07:07:30 -0400
Received: by mail-ed1-f66.google.com with SMTP id f2so4125504edw.3
        for <netdev@vger.kernel.org>; Sun, 08 Sep 2019 04:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=omP7nETAjfzTclexGMoPX3GroZQHgIB9AEsr1Oe+bDE=;
        b=Um7t2Bq51KXcPHbcj5vzFD033ljidqeagbss8kwqOZMcwzHDXhYQFpVMdwYLOvozGF
         YefoIleuRsUdzaJpb04ve+PxLcOQkiV+As0Sx61bKSjfH27ySCItMDgqAYISezpNrvTv
         VSxyVtOjIBtkSv8fYX2Pjj+wuvP47dXayhl3cncSvAEbvuDncn0tn1vvpUXAMhiWMGdT
         X+Y3Un7kBkqLTnc2e4SMEL63fIigiHECOP9L8abgMi12KhO/Wv9IfJgoUr+ycpzpYohc
         p5jkj0zd2fQSf978PGYW0gElFa1YP7I7aUXyOZPe94cfcde/R3n07lwRn+PbzgEsk92J
         rTtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=omP7nETAjfzTclexGMoPX3GroZQHgIB9AEsr1Oe+bDE=;
        b=OYDYIZWpUbGMEmXavWqoyPQDMLH0Q9k/aU86bJ3lpz+npTNKNUMkjlMdwtXtVxQ+/G
         BUOXcyiEFmV/94XML1a7YhB1J5Rkk0ao325S3S9sS5oAwutPn6NrJ3CHl+KrXalkHCV4
         ZRyBBCaAmkhY7WRRAb0GhAdDbPXmgR/IcoxsZBW+lKEF5xQlKlM+upSvOG7BG0zPzv5C
         WoLp9iEGCtd3R9nSpXEGX7opc3zl3pZrktUuw2WUAv22Uv32hwNbk7SKK6mBZar1CAHO
         ZbccssZce26GTskuKFYz22VQ6F33P+x+IyPno6gc8bmzz9y4Y0kA/SoXohstblAtqiCb
         Frsg==
X-Gm-Message-State: APjAAAVCuBJVM7TGc+dn0THz5LvtST8bL1URVQ56VH+d8w6OswoVTMy8
        taASrRn6CwCypkc6eDAONvcDSS6GN2KruwFnVl0=
X-Google-Smtp-Source: APXvYqzgkD5dOgDKNKkBijM1EqdqNF2hyq4lGNUxQlVfTvBymzC1Sb7RYKylr2rSgGI1EEg0ZZK8vUAqfOtuOPEdutE=
X-Received: by 2002:a17:906:4056:: with SMTP id y22mr15277799ejj.230.1567940847573;
 Sun, 08 Sep 2019 04:07:27 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:906:e258:0:0:0:0 with HTTP; Sun, 8 Sep 2019 04:07:27
 -0700 (PDT)
In-Reply-To: <20190907144548.GA21922@lunn.ch>
References: <20190902162544.24613-1-olteanv@gmail.com> <20190906.145403.657322945046640538.davem@davemloft.net>
 <20190907144548.GA21922@lunn.ch>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sun, 8 Sep 2019 12:07:27 +0100
Message-ID: <CA+h21hqLF1gE+aDH9xQPadCuo6ih=xWY73JZvg7c58C1tC+0Jg@mail.gmail.com>
Subject: Re: [PATCH v1 net-next 00/15] tc-taprio offload for SJA1105 DSA
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com,
        vinicius.gomes@intel.com, vedang.patel@intel.com,
        richardcochran@gmail.com, weifeng.voon@intel.com,
        jiri@mellanox.com, m-karicheri2@ti.com, Jose.Abreu@synopsys.com,
        ilias.apalodimas@linaro.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, kurt.kanzenbach@linutronix.de,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew, David,

On Sep 7, 2019, at 3:46 PM, Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Fri, Sep 06, 2019 at 02:54:03PM +0200, David Miller wrote:
>>
>>  From: Vladimir Oltean <olteanv@gmail.com>
>>  Date: Mon,  2 Sep 2019 19:25:29 +0300
>>
>>>
>>>  This is the first attempt to submit the tc-taprio offload model for
>>>  inclusion in the net tree.
>>
>>
>>  Someone really needs to review this.
>
> Hi Vladimir
>
> You might have more chance getting this reviewed if you split it up
> into a number of smaller series. Richard could probably review the
> plain PTP changes. Who else has worked on tc-taprio recently? A series
> purely about tc-taprio might be more likely reviewed by a tc-taprio
> person, if it does not contain PTP changes.
>
>     Andrew

I think Richard has been there when the taprio, etf qdiscs, SO_TXTIME
were first defined and developed:
https://patchwork.ozlabs.org/cover/808504/
I expect he is capable of delivering a competent review of the entire
series, possibly way more competent than my patch set itself.

The reason why I'm not splitting it up is because I lose around 10 ns
of synchronization offset when using the hardware-corrected PTPCLKVAL
clock for timestamping rather than the PTPTSCLK free-running counter.
This is mostly due to the fact that SPI interaction is reduced to a
minimum when correcting the switch's PHC in software - OTOH when that
correction translates into SPI writes to PTPCLKADD/PTPCLKVAL and
PTPCLKRATE, that's when things go a bit downhill with the precision.
Now the compromise is fully acceptable if the PTP clock is to be used
as the trigger source for the time-aware scheduler, but the conversion
would be quite pointless with no user to really require the hardware
clock.

Additionally, the 802.1AS PTP profile even calls for switches and
end-stations to use timestamping counters that are free-running, and
scale&rate-correct those in software - due to a perceived "double
feedback loop", or "changing the ruler while measuring with it". Now
I'm no expert at all, but it would be interesting if we went on with
the discussion in the direction of what Linux is currently
understanding by a "free-running" PTP counter. On one hand there's the
timecounter/cyclecounter in the kernel which makes for a
software-corrected PHC, and on the other there's the free_running
option in linuxptp which makes for a "nowhere-corrected" PHC that is
only being used in the E2E_TC and P2P_TC profiles. But user space
otherwise has no insight into the PHC implementation from the kernel,
and "free_running" from ptp4l can't really be used to implement the
synchronization mechanism required by 802.1AS.

To me, the most striking aspect is that this particular recommendation
from 802.1AS is at direct odds with 802.1Qbv (time-based egress) /
802.1Qci (time-based ingress policing) which clearly require a PTP
counter in the NIC that ticks to the wall clock, and not to a random
free-running time since boot up. I simply can't seem to reconcile the
two.
What this particular switch does is that it permits RX and TX
timestamps to be taken in either corrected or uncorrected timebases
(but unfortunately not both at the same time). I think the hardware
designers' idea was to take timestamps off the uncorrected clock
(PTPTSCLK) and then do a sort of phc2sys-to-itself: write the
software-corrected value of the timecounter/cyclecounter into the
PTPCLKVAL hardware registers which get used for Qbv/Qci.
Actually I hate to use those terms when talking about SJA1105 hardware
support, since it's more "in the style of" IEEE rather than strict
compliance (timing of the design vs the standard might have played a
role as well).

But let's leave 802.1AS aside for a second - that's not what the patch
set is about, but rather a bit of background on why there are 2 PTP
clocks in this switch, and why I'm switching from one to the other.
Richard didn't really warm up to the phc2sys-to-itself idea in the
past, and opted for simplicity: just use the hardware-corrected
PTPCLKVAL for everything, which is exactly what I'm doing as of now.

The only people whom I know are working on TSN stuff are mostly
entrenched in papers, standards and generally in the hardware-only
mentality. There is obviously a lot to be done for Linux to be a
proper TSN endpoint, and RT is a big one. For a switch in particular,
things are a bit easier due to the fact that it just needs to ensure
the real-time guarantees of a frame that was supposedly already
delivered in-band with the schedule. And there's no other way to do
that rather than through a hardware offload - otherwise the software
tc-taprio would only shape the frames egressed by the management CPU
of the switch. The tc-taprio offload for a switch only makes sense
when taken together with the bridging offload, if you will.

I "dared" to submit this for merging maybe because I don't see the
subtleties that prevent it from going in, at least for a switch - it
just works and does the job. I would have loved to see this in 5.4
just so I would have to lug around a bit less patches when finally
starting to evaluate the endpoint side of things with the 5.4-rt
patch. But nonetheless, there's no hurry and getting a healthy
discussion going is surely more important than the patches themselves
are. On the other hand there needs to be a balance, and just talking
with no code is no good either - fixes, improvements, rework can
always come later once we commit to the basic offload model.

I happen to be around at Plumbers during the following days to learn
what else is going on in the Linux community, and develop a more
complete mental model for myself for how TSN fits in with all of that.
If anybody happens to also be around, I'd be more than happy to talk.

Regards,
-Vladimir
