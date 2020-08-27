Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC20325501A
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 22:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727013AbgH0UhG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 16:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbgH0UhF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 16:37:05 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2241C061264;
        Thu, 27 Aug 2020 13:37:05 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id b14so7377402qkn.4;
        Thu, 27 Aug 2020 13:37:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lLI7KZEcm6pK/DDnWR2PxemX1EjkQ7OUHds3UQLACGM=;
        b=stowNP4s4FnAKpm3wilVDwZ2UBtbYh7M9bYohbaviVrLBO95Vh6XN9u2R0G+63fI7K
         hSZvrXvBMAkyyfql/9f091cLTBZhyQxaO7MnxyRnZEow4QKjXL+fEjxXXRi/AVTxEaSB
         UpRr2zVU3BGr98hRdGVLHMx+hz6Nfv8/P9FwuwDbdk3kEw73ehEF4MXpkVhE1RiBZx4J
         tsr2G0hNVhxT9MJbkrNYf28MnGxpqd8FYI6HdJAkfnQmheB3aNec6sF8mgOte3Pl/Lrt
         /T1gBgEng2HPz1vp6p0Yl7WE4znbptOkS0dMGeppvpUus0oArYvNPxs8PeW9RUVgVFZj
         5YSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lLI7KZEcm6pK/DDnWR2PxemX1EjkQ7OUHds3UQLACGM=;
        b=mRIlK84ANlDZZDcaHYBOj+OyD7X5gyfnB5unCRDm+WkCMwsVw7P9mbgpw+xjK5SjdX
         vmYg62ZZbqRtQq98bBwa87E3x+skAlZ9wYs5Sg2nXkdu1+xM+pE9njfrQ+wG+M2CtkXU
         lGT/TZXR8KqQp9KV3jpAoeEQxEK1a5uNocKhKzFh2BTxI/npQIZBhaowQl/3mzxcoR6O
         d3BNkMjDSliRiJKQad/5WtYasB0iuZrnTWrHPzAYa/l17kyyOChicihpAfEf7r773p3d
         Zk4vW0sRy3E+F6lJe412FAlzdFYXhX6BCj8LjnngYGEysE3sK2KGDFJfPAIB5zRmI3uu
         q5aQ==
X-Gm-Message-State: AOAM530mCHx1KLsoQ64+92obJUc1dPgEGRe8v5h1DV8OvM/2zir8+OBV
        6iaq4c0/s/BaiaE+q1BbPtQOj27NKQnTx9YWBWo=
X-Google-Smtp-Source: ABdhPJxIn16IqGO8iLFDL2GZqRySE9w8V54DO09ZfQFmMUoz0Flmvo7kWsRkwpQwHHMjGWlL01CnLFuD/at08gSXSKM=
X-Received: by 2002:a37:9d4f:: with SMTP id g76mr19685247qke.395.1598560624726;
 Thu, 27 Aug 2020 13:37:04 -0700 (PDT)
MIME-Version: 1.0
References: <f0a2cb7ea606f1a284d4c23cbf983da2954ce9b6.1598420968.git.mchehab+huawei@kernel.org>
 <CALLGbRL+duiHFd3w7hcD=u47k+JM5rLpOkMrRpW0aQm=oTfUnA@mail.gmail.com> <20200827194225.281eb7dc@coco.lan>
In-Reply-To: <20200827194225.281eb7dc@coco.lan>
From:   Steve deRosier <derosier@gmail.com>
Date:   Thu, 27 Aug 2020 13:36:28 -0700
Message-ID: <CALLGbRLsQpdtrcV9ydz4KJ4A9uaj4P1EhbF0_yMxcdLvOmnY9Q@mail.gmail.com>
Subject: Re: [PATCH] Revert "wlcore: Adding suppoprt for IGTK key in wlcore driver"
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>, linuxarm@huawei.com,
        mauro.chehab@huawei.com, John Stultz <john.stultz@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Maital Hahn <maitalm@ti.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Raz Bouganim <r-bouganim@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Johannes Berg <johannes.berg@intel.com>,
        Fuqian Huang <huangfq.daxian@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mauro,

On Thu, Aug 27, 2020 at 10:42 AM Mauro Carvalho Chehab
<mchehab+huawei@kernel.org> wrote:
>
> Em Thu, 27 Aug 2020 08:48:30 -0700
> Steve deRosier <derosier@gmail.com> escreveu:
>
> > On Tue, Aug 25, 2020 at 10:49 PM Mauro Carvalho Chehab
> > <mchehab+huawei@kernel.org> wrote:
> > >
> > > This patch causes a regression betwen Kernel 5.7 and 5.8 at wlcore:
> > > with it applied, WiFi stops working, and the Kernel starts printing
> > > this message every second:
> > >
> > >    wlcore: PHY firmware version: Rev 8.2.0.0.242
> > >    wlcore: firmware booted (Rev 8.9.0.0.79)
> > >    wlcore: ERROR command execute failure 14
> >
> > Only if NO firmware for the device in question supports the `KEY_IGTK`
> > value, then this revert is appropriate. Otherwise, it likely isn't.
>
> Yeah, that's what I suspect too: some specific firmware is required
> for KEY_IGTK to work.
>
> >  My suspicion is that the feature that `KEY_IGTK` is enabling is
> > specific to a newer firmware that Mauro hasn't upgraded to. What the
> > OP should do is find the updated firmware and give it a try.
>
> I didn't try checking if linux-firmware tree has a newer version on
> it. I'm using Debian Bullseye on this device. So, I suspect that
> it may have a relatively new firmware.
>
> Btw, that's also the version that came together with Fedora 32:
>
>         $ strings /lib/firmware/ti-connectivity/wl18xx-fw-4.bin |grep FRev
>         FRev 8.9.0.0.79
>         FRev 8.2.0.0.242
>
> Looking at:
>         https://git.ti.com/cgit/wilink8-wlan/wl18xx_fw/
>
> It sounds that there's a newer version released this year:
>
>         2020-05-28      Updated to FW 8.9.0.0.81
>         2018-07-29      Updated to FW 8.9.0.0.79
>
> However, it doesn't reached linux-firmware upstream yet:
>
>         $ git log --pretty=oneline ti-connectivity/wl18xx-fw-4.bin
>         3a5103fc3c29 wl18xx: update firmware file 8.9.0.0.79
>         65b1c68c63f9 wl18xx: update firmware file 8.9.0.0.76
>         dbb85a5154a5 wl18xx: update firmware file
>         69a250dd556b wl18xx: update firmware file
>         dbe3f134bb69 wl18xx: update firmware file, remove conf file
>         dab4b79b3fbc wl18xx: add version 4 of the wl18xx firmware
>
> > AND - since there's some firmware the feature doesn't work with, the
> > driver should be fixed to detect the running firmware version and not
> > do things that the firmware doesn't support.  AND the firmware writer
> > should also make it so the firmware doesn't barf on bad input and
> > instead rejects it politely.
>
> Agreed. The main issue here seems to be that the current patch
> assumes that this feature is available. A proper approach would
> be to check if this feature is available before trying to use it.
>
> Now, I dunno if version 8.9.0.0.81 has what's required for it to
> work - or if KEY_IGTK require some custom firmware version.
>
> If it works with such version, one way would be to add a check
> for this specific version, disabling KEY_IGTK otherwise.
>
> Also, someone from TI should be sending the newer version to
> be added at linux-firmware.
>
> I'll try to do a test maybe tomorrow.
>

I think we're totally agreed on all of the above points.
Fundamentally: the orig patch should've been coded defensively and
tested properly since clearly it causes certain firmwares to break.
Be nice if TI would both update the firmware and also update the
driver to detect the relevant version for features.  I don't know
about this one, but I do know the QCA firmwares (and others) have a
set of feature flags that are detected by the drivers to determine
what is supported.

I look forward to hearing the results of your test.  This whole thing
has gotten me interested. I'd be tempted to pull out the relevant dev
boards and play with them myself, but IIRC they got sent back to a
previous employer and I don't have access to them anymore.


> > But I will say I'm making an educated guess; while I have played with
> > the TI devices in the past, it was years ago and I won't claim to be
> > an expert. I also am unable to fix it myself at this time.
> >
> > I'd just rather see it fixed properly instead of a knee-jerk reaction
> > of reverting it simply because the OP doesn't have current firmware.
>
> > And let's revisit the discussion of having a kernel splat because an
> > unrelated piece of code fails yet the driver does exactly what it is
> > supposed to do. We shouldn't be dumping registers and stack-trace when
> > the code that crashed has nothing to do with the registers and
> > stack-trace outputted. It is a false positive.  A simple printk WARN
> > or ERROR should output notifying us that the chip firmware has crashed
> > and why.  IMHO.
>
> Thanks,
> Mauro

Thanks,
- Steve
