Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF532C6D50
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 23:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732587AbgK0WnZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 17:43:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732426AbgK0Wmp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 17:42:45 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BE45C0613D1;
        Fri, 27 Nov 2020 14:42:45 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id mc24so9601600ejb.6;
        Fri, 27 Nov 2020 14:42:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=y1Dc6vQYSydHR+KUHvVDvdmlse1262+8fj/KcfjDBqg=;
        b=HfjlV270mLh0mwt9+sVDrUfDfCMegRjp5wmjKbIi/jRLzk78MXVyRPprraWA+bgmkq
         7zJ6PlXCHdcfIKHsZLqxcF1k8chzKFpouYIxd5n3NEeeAI3bU2NV4n0VYgfyKz5NqZnt
         hH2x5/JBHmkAvF7a92U11ys06rirV/yGgXfcYOsckmRQouAcQKue6nKK/7sOG6N2WjGl
         U+pBTkGSd6iuNgEq8LnF1KBY5pyzhdXhjmrAux0sv2CDZgnJY38V6SdTyBRWqTNtWdTO
         wJIeaPF2GVLlOp/IG3W6bmtXfkm5xOBVWgwzpzcS7ha5ozb4rJ1TsVyk+NEnpwx/0R/j
         r2ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=y1Dc6vQYSydHR+KUHvVDvdmlse1262+8fj/KcfjDBqg=;
        b=o8yZStUMRsR30MTphu0AThXZGORWxcejbXqZuAvwhvrLmvTNT6sZJ/NZQtOKbrWsIW
         NvUZJI2TriGTJIibfDyiNQ8qxWnAN/N1k0qYi2qqBgqNIZujThm1gToT4uDGIzYfWwkW
         UxmOkdzrMaJSdSd4T7Qf1PPh4kDsLMChtZxaUVjhAseQrNgdg4pAIcVydDzX6Dkk0fed
         g8yfGLFPoSOVC0Swqpytr2jLiuI8fPyqsxyOY6tDKnjaPdySaRFX9bu3bymsJXO0WH+K
         yNxAS4j6lyNymiLJzfWXvTAqsrV6Xv0ZRv6CjoVstRQ0KYItjOkXn2OeNFN1xw24o1hf
         aDIA==
X-Gm-Message-State: AOAM5303hWuf6FZXlnOzhTRiYtapTgSUk1ttMOSeXM+/r6TuFq2z+Uz/
        twWmbdZBHz8okKGmbpIEzhA=
X-Google-Smtp-Source: ABdhPJyLkCY5X6r3jMHEywa+Qp9k/km2aNbstLoZVAwMorA2whIupMI+5J5jOwIjiRQetfyyKXsusw==
X-Received: by 2002:a17:906:c345:: with SMTP id ci5mr2497314ejb.492.1606516964082;
        Fri, 27 Nov 2020 14:42:44 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id lj14sm1483475ejb.16.2020.11.27.14.42.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 14:42:43 -0800 (PST)
Date:   Sat, 28 Nov 2020 00:42:42 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     George McCollister <george.mccollister@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Subject: Re: [PATCH net-next v2 2/3] net: dsa: add Arrow SpeedChips XRS700x
 driver
Message-ID: <20201127224242.vpu4puvzmikpmnyx@skbuf>
References: <CAFSKS=OY_-Agd6JPoFgm3MS5HE6soexHnDHfq8g9WVrCc82_sA@mail.gmail.com>
 <20201126132418.zigx6c2iuc4kmlvy@skbuf>
 <20201126175607.bqmpwbdqbsahtjn2@skbuf>
 <CAFSKS=Ok1FZhKqourHh-ikaia6eNWtXh6VBOhOypsEJAhwu06g@mail.gmail.com>
 <20201126220500.av3clcxbbvogvde5@skbuf>
 <20201127103503.5cda7f24@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <CAFSKS=MAdnR2jzmkQfTnSQZ7GY5x5KJE=oeqPCQdbZdf5n=4ZQ@mail.gmail.com>
 <20201127195057.ac56bimc6z3kpygs@skbuf>
 <CAFSKS=Pf6zqQbNhaY=A_Da9iz9hcyxQ8E1FBp2o7a_KLBbopYw@mail.gmail.com>
 <20201127133753.4cf108cb@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201127133753.4cf108cb@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 27, 2020 at 01:37:53PM -0800, Jakub Kicinski wrote:
> Replying to George's email 'cause I didn't get Vladimir's email from
> the ML.
>
> On Fri, 27 Nov 2020 14:58:29 -0600 George McCollister wrote:
> > > 100 Kbps = 12.5KB/s.
> > > sja1105 has 93 64-bit counters, and during every counter refresh cycle I
>
> Are these 93 for one port? That sounds like a lot.. There're usually
> ~10 stats (per port) that are relevant to the standard netdev stats.

I would like to report the rx_errors as an aggregate of a few other
discrete counters that are far in between. Hence the idea of reading the
entire region delegated to port counters using a single SPI transaction.

> > Yeah, that's quite big. The xrs700x counters are only 16 bit. They
> > need to be polled on an interval anyway or they will roll.
>
> Yup! That's pretty common.
>
> > > would need to get some counters from the beginning of that range, some
> > > from the middle and some from the end. With all the back-and-forth
> > > between the sja1105 driver and the SPI controller driver, and the
> > > protocol overhead associated with creating a "SPI read" message, it is
> > > all in all more efficient to just issue a burst read operation for all
> > > the counters, even ones that I'm not going to use. So let's go with
> > > that, 93x8 bytes (and ignore protocol overhead) = 744 bytes of SPI I/O
> > > per second. At a throughput of 12.5KB/s, that takes 59 ms to complete,
> > > and that's just for the raw I/O, that thing which keeps the SPI mutex
> > > locked. You know what else I could do during that time? Anything else!
> > > Like for example perform PTP timestamp reconstruction, which has a hard
> > > deadline at 135 ms after the packet was received, and would appreciate
> > > if the SPI mutex was not locked for 59 ms every second.
> >
> > Indeed, however if you need to acquire this data at all it's going to
> > burden the system at that time so unless you're able to stretch out
> > the reads over a length of time whether or not you're polling every
> > second or once a day may not matter if you're never able to miss a
> > deadline.
>
> Exactly, either way you gotta prepare for users polling those stats.
> A design where stats are read synchronously and user (an unprivileged
> user, BTW) has the ability to disturb the operation of the system
> sounds really flaky.

So I was probably overreacting with the previous estimate, since
- nobody in their right mind is going to use sja1105 at a SPI clock of
  100 KHz, but at least 100 times that value.
- other buses, like I2C/MDIO, don't really have the notion of variable
  buffer sizes and burst transactions. So the wait time has a smaller
  upper bound there, because of the implicit "cond_resched" given by the
  need to read word by word. In retrospect it would be wiser to not make
  use of burst reads for getting stats over SPI either.

But to your point. The worst case is worse than periodic readouts, and
the system needs to be resilient against them. Well, some things are
finicky no matter what you do and how well you protect, like phc2sys.
So for those, you need to be more radical, and you need to do cross
timestamping as close to the actual I/O as possible:
https://lwn.net/Articles/798467/
But nonetheless, point taken. As long as the system withstands the worst
case, then the impact it has on latency is not catastrophic, although it
is still there. But who would not like a system which achieves the same
thing by doing less? I feel that not sorting this out now will deter
many DSA driver writers from using ndo_get_stats64, if they don't have
otherwise a reason to schedule a periodic stats workqueue anyway.

> > > And all of that, for what benefit? Honestly any periodic I/O over the
> > > management interface is too much I/O, unless there is any strong reason
> > > to have it.
> >
> > True enough.
> >
> > > Also, even the simple idea of providing out-of-date counters to user
> > > space running in syscall context has me scratching my head. I can only
> > > think of all the drivers in selftests that are checking statistics
> > > counters before, then they send a packet, then they check the counters
> > > after. What do those need to do, put a sleep to make sure the counters
> > > were updated?
>
> Frankly life sounds simpler on the embedded networking planet than it is
> on the one I'm living on ;) High speed systems are often eventually
> consistent. Either because stats are gathered from HW periodically by
> the FW, or RCU grace period has to expire, or workqueue has to run,
> etc. etc. I know it's annoying for writing tests but it's manageable.

Yes, but all of these are problems which I do not have, so I don't see
why I would want to suffer from others' challenges.

> If there is a better alternative I'm all ears but having /proc and
> ifconfig return zeros for error counts while ip link doesn't will lead
> to too much confusion IMO. While delayed update of stats is a fact of
> life for _years_ now (hence it was backed into the ethtool -C API).

I don't know the net/core folder well enough to say anything definitive
about it. To me nothing looked obviously possible.
Although in my mind of somebody who doesn't understand how other pieces
of code seem to get away by exposing the same object through two
different types of locking (like br_vlan_get_pvid and
br_vlan_get_pvid_rcu), maybe this could be an approach to try to obtain
the RTNL in net-procfs.c instead of RCU. But this is just, you know,
speculating things I don't understand.
