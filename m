Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8883C3792AE
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 17:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232389AbhEJPaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 11:30:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234913AbhEJP1n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 11:27:43 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D02C8C04BF0F
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 08:09:57 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id r5so14360705ilb.2
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 08:09:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8kTuByNgyMtrEkhRj3rWSQu3NsuZi1QL5Z6zDTh5OHQ=;
        b=A+/BJpDmXlX7Zxf9C3GmO/6Cff8NswFavsQVfyVKuYdl/c3epGlRJqVEHYXh2728dB
         I3F4fguiCdD4w208QrJxXFvxvHPxITJ0L4vx7avNu92Jgrj0n1AeUwsJos1pSij9T2Cz
         uodfrNc17m/O/J/sZCi/TXyC3/tpAQkiTbnt5CIOeR98A47W53ijsQ3eTV60uwHbGhUJ
         g/0DhRFO5JA/lDBX5zvmDi2x8lANnXjNRRnKtTAmQu8lrNu194BI9Ez3UKFPxbppXPue
         fCS1l0Mr/2tmkk77Pg6CMobzHlNDK3FHCypRlyisOANU3VmdAlE1Rw2o8lR4pEJdOx1S
         785w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8kTuByNgyMtrEkhRj3rWSQu3NsuZi1QL5Z6zDTh5OHQ=;
        b=e9xEQTN+YA/wWZS/5awkDVCboNO1X7uJpuDw13qUxm2NCFusEVzfpk2lEb17rY3Z3V
         B3CnBjwTpCmt5rH5GkeIqx40MliOAebH9I4N+IqW8mM/etUceZ4TngwPWSV70uMSRhVl
         yPzbXjALQkBHDM00UsGeiiYveZG+FyxI3xNbcjra86lPa22/ewhYYRi9D8XaYpP/nkAs
         7Dydg4yuQ3Y0ulYHHLHnrS46owH6NIq+Fa6uzw7LL0YtpWd1g9CrneyPfE6WmahyvvxY
         Wc6FXuqTetP+MbCsNFZ0YNKMc8r2moSkzKw/w2YloG3qg29PumUA4JxkzNlZ1IaSIKfR
         47QA==
X-Gm-Message-State: AOAM532rLxnioeJoCihri59QZn/D9lFa8szMyWKAHdMCebOyuSeHcffv
        Z1pLSvSoy6+CC8H1iPei89uclBdAqr5ekCb0GF+PP/M6cm4AYQ==
X-Google-Smtp-Source: ABdhPJxmjBRNQzngOUFhRaQFafW2Gd1wm/nXW90UrrVlwLGgZK2EPWe9H03kGpYlnmL/HIYbtQdH7qLrywY0W01L3dU=
X-Received: by 2002:a05:6e02:d41:: with SMTP id h1mr21424821ilj.0.1620659397232;
 Mon, 10 May 2021 08:09:57 -0700 (PDT)
MIME-Version: 1.0
References: <421cc86c-b66f-b372-32f7-21e59f9a98bc@kontron.de>
 <CAA93jw6bWOU3wX5tubkTzOFxDMWXdgmBqnGPAnzZKVVFQTEUDQ@mail.gmail.com> <c9f26a11-bb53-e3aa-606c-a592365a9a1e@kontron.de>
In-Reply-To: <c9f26a11-bb53-e3aa-606c-a592365a9a1e@kontron.de>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Mon, 10 May 2021 08:09:46 -0700
Message-ID: <CAA93jw5Ab+ZVq48JAcA0s_=fLBJ4OCmVfsuK6=K3A24_k0tyYg@mail.gmail.com>
Subject: Re: i.MX8MM Ethernet TX Bandwidth Fluctuations
To:     Frieder Schrempf <frieder.schrempf@kontron.de>
Cc:     NXP Linux Team <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 10, 2021 at 5:49 AM Frieder Schrempf
<frieder.schrempf@kontron.de> wrote:
>
> Hi Dave,
>
> thanks for the input. I really don't know much about the networking stack=
, so at the moment I can only provide the values requested below, without k=
nowing what it really means.
>
> What's so strange is, that the performance is actually good in general an=
d only "snaps" to the "bad" state and back after some time or after repeate=
d test runs.
>
> And by the way, the ethernet driver in use is the FEC driver at drivers/n=
et/ethernet/freescale/fec_main.c.

It doesn't look (from a quick grep) that that driver ever got BQL support.

davet@Georges-MacBook-Pro freescale % grep sent_queue *.c
gianfar.c:    netdev_tx_sent_queue(txq, bytes_sent);
ucc_geth.c:    netdev_sent_queue(dev, skb->len);

If you really care about bidirectional throughput, having enormous
fifo buffers buried deep in the driver has a tendency to hurt that a
lot and has the symptoms you describe, however not as persistent, so I
would suspect another bug involving gso or gro to start with...

BUT: I note that the effort in implementing bql and testing the packet
size accounting usually shows up other problems in the tx/rx ring, GRO
or NAPI code, and thus is worthwhile exercise that might find where
things are getting stuck.

It doesn't appear your kernel has fq_codel qdisc support, either,
which means big dumb fifos at that layer, drastically affecting bidir
throughput. also.

Since the nxp team is cc'd this is a preso I'd given broadcom back in 2018:

http://www.taht.net/~d/broadcom_aug9_2018.pdf

And the relevant lwn articles from, like, 2011:

https://lwn.net/Articles/454390/

https://lwn.net/Articles/469652/


If someone wants to send me a board to play with...

> On 06.05.21 16:53, Dave Taht wrote:
> > I am a big fan of bql - is that implemented on this driver?
> >
> > cd /sys/class/net/your_device_name/queues/tx-0/byte_queue_limits/
> > cat limit
>
> ~# cat /sys/class/net/eth0/queues/tx-0/byte_queue_limits/limit
> 0
>
> >
> > see also bqlmon from github
> >
> > is fq_codel running on the ethernet interface? the iperf bidir test
> > does much better with that in place rather than a fifo. tc -s qdisc
> > show dev your_device
>
> ~# tc -s qdisc show dev eth0
> RTNETLINK answers: Operation not supported
> Dump terminated
>
> Best regards
> Frieder
>
> >
> > Also I tend to run tests using the flent tool, which will yield more
> > data. Install netperf and irtt on the target, flent, netperf, irtt on
> > the test driver box...
> >
> > flent -H the-target-ip -x --socket-stats -t whateveryouaretesting rrul
> > # the meanest bidir test there
> >
> > flent-gui *.gz
> >
> > On Thu, May 6, 2021 at 7:47 AM Frieder Schrempf
> > <frieder.schrempf@kontron.de> wrote:
> >>
> >> Hi,
> >>
> >> we observed some weird phenomenon with the Ethernet on our i.MX8M-Mini=
 boards. It happens quite often that the measured bandwidth in TX direction=
 drops from its expected/nominal value to something like 50% (for 100M) or =
~67% (for 1G) connections.
> >>
> >> So far we reproduced this with two different hardware designs using tw=
o different PHYs (RGMII VSC8531 and RMII KSZ8081), two different kernel ver=
sions (v5.4 and v5.10) and link speeds of 100M and 1G.
> >>
> >> To measure the throughput we simply run iperf3 on the target (with a s=
hort p2p connection to the host PC) like this:
> >>
> >>         iperf3 -c 192.168.1.10 --bidir
> >>
> >> But even something more simple like this can be used to get the info (=
with 'nc -l -p 1122 > /dev/null' running on the host):
> >>
> >>         dd if=3D/dev/zero bs=3D10M count=3D1 | nc 192.168.1.10 1122
> >>
> >> The results fluctuate between each test run and are sometimes 'good' (=
e.g. ~90 MBit/s for 100M link) and sometimes 'bad' (e.g. ~45 MBit/s for 100=
M link).
> >> There is nothing else running on the system in parallel. Some more inf=
o is also available in this post: [1].
> >>
> >> If there's anyone around who has an idea on what might be the reason f=
or this, please let me know!
> >> Or maybe someone would be willing to do a quick test on his own hardwa=
re. That would also be highly appreciated!
> >>
> >> Thanks and best regards
> >> Frieder
> >>
> >> [1]: https://eur04.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F=
%2Fcommunity.nxp.com%2Ft5%2Fi-MX-Processors%2Fi-MX8MM-Ethernet-TX-Bandwidth=
-Fluctuations%2Fm-p%2F1242467%23M170563&amp;data=3D04%7C01%7Cfrieder.schrem=
pf%40kontron.de%7C157b00b2686447fd9a7108d9109ecbc6%7C8c9d3c973fd941c8a2b164=
6f3942daf1%7C0%7C0%7C637559096478620665%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4=
wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=3D=
SFT%2Boic9C1sirw%2BT1o1qRNNUe4H9bk2FHkLQpdy489I%3D&amp;reserved=3D0
> >
> >
> >



--=20
Latest Podcast:
https://www.linkedin.com/feed/update/urn:li:activity:6791014284936785920/

Dave T=C3=A4ht CTO, TekLibre, LLC
