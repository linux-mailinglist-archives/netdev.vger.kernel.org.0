Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48B6D2549D5
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 17:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbgH0PtI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 11:49:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726200AbgH0PtI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 11:49:08 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBF42C061264;
        Thu, 27 Aug 2020 08:49:07 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id j10so2789080qvo.13;
        Thu, 27 Aug 2020 08:49:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bhg41soIay7+587Qkw7LUVijSMFtZApm/WI52siUHqo=;
        b=r+0Z51AzGh3RpvLN7SrOrKt0OzXk1uO3gIBm2Pu/DOuix3nSPCCqDG/qHztIaXh8QN
         HiKQC4O9rhKhDi26XChu3hE3TUHUtKZn9lndImODCUaorVuYIPQjYAx2P4/s4oXPhJLr
         obECsPYChpudqJw0yFiMpzBRHGmzAflQMOaxX+Mr6cGcPSgwMDhh9Maz08NIpbQP5dUs
         rugrILqOCy9Jbs6n3dzYfgVB1IyGk5ikOE4sP+wQO6OFfEhipESsiIELqzOr0tqZst49
         TIaBzpWtk+ssgZKjAMSx4i3jtObVPBTkvz0Kb8kc8IzsXI5Bco2IwBenmb/jelgP4jQg
         eupw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bhg41soIay7+587Qkw7LUVijSMFtZApm/WI52siUHqo=;
        b=mXfyMg2mk5WApq8ampzsMUD6VTECn90wFOD6m3QzWoGmNYT30en8DjZ1ygsKTjIhe3
         xsizKba6d9Eh/GYeJBu2RL7ETJAE0mL54+4gd9+VSi8HhuroxPcnmFQF823uZBhAa10j
         Lcddcpa5z45LOslVBkq/Psrk3ZXOuWvXvQVy+pV2Rdy0K2pGDriXULYHwV1k5+atf8MY
         qTpJadPOKVMdxA/zfrpjI1hFaWzReJaaKMsQo4WuPYIZkSzrtT3DOzkOhRjObhzdI/1j
         2kMGtXiX6q+Ft9GweXaX2v+LsmyGLDCZqZA35tnrgBxhBPEmi/Tjv9kYkR5eaElD+SUo
         juiQ==
X-Gm-Message-State: AOAM531bL0KmGxKJz8LtH0bkQc/6/pik/l7J/BMefdaSJRhl6J7ANVwR
        P0I8bpFvnotcCzdgVbOVA27Qqgr4NR+JZS7aP8jEokGQvhY=
X-Google-Smtp-Source: ABdhPJw1Rl4RnR6X/MbtbB5gxI0GdiLcMsChgSFbr5UNmVwq/YZtYaADIxZ92er5Ilp/EDcy0juMltTIu0VNIpc1uZA=
X-Received: by 2002:ad4:4992:: with SMTP id t18mr18408206qvx.193.1598543346813;
 Thu, 27 Aug 2020 08:49:06 -0700 (PDT)
MIME-Version: 1.0
References: <f0a2cb7ea606f1a284d4c23cbf983da2954ce9b6.1598420968.git.mchehab+huawei@kernel.org>
In-Reply-To: <f0a2cb7ea606f1a284d4c23cbf983da2954ce9b6.1598420968.git.mchehab+huawei@kernel.org>
From:   Steve deRosier <derosier@gmail.com>
Date:   Thu, 27 Aug 2020 08:48:30 -0700
Message-ID: <CALLGbRL+duiHFd3w7hcD=u47k+JM5rLpOkMrRpW0aQm=oTfUnA@mail.gmail.com>
Subject: Re: [PATCH] Revert "wlcore: Adding suppoprt for IGTK key in wlcore driver"
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linuxarm@huawei.com, mauro.chehab@huawei.com,
        John Stultz <john.stultz@linaro.org>,
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

On Tue, Aug 25, 2020 at 10:49 PM Mauro Carvalho Chehab
<mchehab+huawei@kernel.org> wrote:
>
> This patch causes a regression betwen Kernel 5.7 and 5.8 at wlcore:
> with it applied, WiFi stops working, and the Kernel starts printing
> this message every second:
>
>    wlcore: PHY firmware version: Rev 8.2.0.0.242
>    wlcore: firmware booted (Rev 8.9.0.0.79)
>    wlcore: ERROR command execute failure 14

Only if NO firmware for the device in question supports the `KEY_IGTK`
value, then this revert is appropriate. Otherwise, it likely isn't.
 My suspicion is that the feature that `KEY_IGTK` is enabling is
specific to a newer firmware that Mauro hasn't upgraded to. What the
OP should do is find the updated firmware and give it a try.

AND - since there's some firmware the feature doesn't work with, the
driver should be fixed to detect the running firmware version and not
do things that the firmware doesn't support.  AND the firmware writer
should also make it so the firmware doesn't barf on bad input and
instead rejects it politely.

But I will say I'm making an educated guess; while I have played with
the TI devices in the past, it was years ago and I won't claim to be
an expert. I also am unable to fix it myself at this time.

I'd just rather see it fixed properly instead of a knee-jerk reaction
of reverting it simply because the OP doesn't have current firmware.

And let's revisit the discussion of having a kernel splat because an
unrelated piece of code fails yet the driver does exactly what it is
supposed to do. We shouldn't be dumping registers and stack-trace when
the code that crashed has nothing to do with the registers and
stack-trace outputted. It is a false positive.  A simple printk WARN
or ERROR should output notifying us that the chip firmware has crashed
and why.  IMHO.

- Steve
