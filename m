Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C466449ABE
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 18:27:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240312AbhKHRab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 12:30:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240238AbhKHRaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 12:30:30 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2EA7C061714
        for <netdev@vger.kernel.org>; Mon,  8 Nov 2021 09:27:45 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id z19so14940984lfd.8
        for <netdev@vger.kernel.org>; Mon, 08 Nov 2021 09:27:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DYDuAD6QjzlggLpTnY+4NCTz7rwvU+k2pOFw2vnJoQg=;
        b=gZdmtDdET6KJkfr1o9JyaajLjAIxDfUneVgmjMUWVxtccdnR8KOTDCP/QcMfr1rT1c
         KMv0hYzdHhxOcal7sXLxmN7AmvbVEZD/1rXPzxXlyVbgKE9hxbFk2p+l595O3FlnbHBU
         YEUIctDzOvE4EblLCct+hYeQlkbW5JcqcpPDFY5hgy2C7Q3jy3d/o+JW8NgXdufKLWOl
         TMvhoeks3yj+4UpAKs1Eq1znysr2cSBT/UuJdL+rKoJqlh/IqR3vStgf3CqF9R2NodT3
         3B587i81UHEQIDFonvAbwazVHdQm3z9SUk6+c5aToj8bsSeUK9OllMdSDj4ADBKl9ZLX
         wi7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DYDuAD6QjzlggLpTnY+4NCTz7rwvU+k2pOFw2vnJoQg=;
        b=JBmY6cnT3fRZPqyK5mPeLCLko0NiQNTFaLRJJmYwQwDjb1gzg6vfl691gpH8vchgS5
         70gz4V3oT1M9FN/Mu3nU4WW0eWdSZQ+LmSRzOP7c05BpijLDbAU/EdrVJBhSrbgMsVbZ
         jR3kn3zNhdaqbG2B8T2QR2DHXaOQSqAPhhjWiXFCa0OUDYp71ebBWVOI5wZUHpN+OcO/
         ps9T5XO33Yz4leHBHUdkSkdq34JxGBqM7G07CMkAblLwX5o4QPQSPQ8qQoe7Z+FtMvOZ
         xH04VONPhENyK7nL6qc/ePvIL4SZQWvg2S5lSHaEoeeyd+kU2BGtkx7357oKseYVeLwm
         FOBA==
X-Gm-Message-State: AOAM533gETkd1205F0ANbcp+Konq5FioVioW9RA635BrXoTE8OIQljeJ
        7ElLxREiCb/8WUXxKxveUNxY3NUvE5czUXoW5e7lAg==
X-Google-Smtp-Source: ABdhPJwPMBy21RwGfnSKmXaxDEIIDzdw2ubpg3s7yG3XcVkDzKpSnYYGbBLBHwTaZa0XexKAFw9FcGYiz8AyAu8fuKo=
X-Received: by 2002:a19:ad4d:: with SMTP id s13mr813797lfd.373.1636392464046;
 Mon, 08 Nov 2021 09:27:44 -0800 (PST)
MIME-Version: 1.0
References: <20210315132501.441681-1-Jerome.Pouiller@silabs.com>
 <4503971.bAhddQ8uqO@pc-42> <CAPDyKFoXgV3m-rMKfjqRj91PNjOGaWg6odWG-EGdFKkL+dGWoA@mail.gmail.com>
 <5713463.b6Cmjs1FeV@pc-42> <CAPDyKFrONrUvbVVVF9iy4P17jZ_Fq+1pGMmsqM6C1hOXOWQnBw@mail.gmail.com>
 <87pmz6mhim.fsf@codeaurora.org> <CAPDyKFrgrSAz-B7wqNNPKk3kB8UqhGs=+bZ8RRhmqh8HuvhcEQ@mail.gmail.com>
 <87fstlj58q.fsf@codeaurora.org>
In-Reply-To: <87fstlj58q.fsf@codeaurora.org>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Mon, 8 Nov 2021 18:27:06 +0100
Message-ID: <CAPDyKFqnbya3+Pvg4yNzFkHdhO9q-Nnj9n9iDVyBqY5ZL_XmaA@mail.gmail.com>
Subject: Re: [PATCH v5 08/24] wfx: add bus_sdio.c
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     =?UTF-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        driverdevel <devel@driverdev.osuosl.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        DTML <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 1 Oct 2021 at 14:31, Kalle Valo <kvalo@codeaurora.org> wrote:
>
> Hi Ulf,
>
> sorry for the late reply, my Gnus tells me it took me 24 weeks to reply :)
>
> Ulf Hansson <ulf.hansson@linaro.org> writes:
>
> > On Wed, 7 Apr 2021 at 14:00, Kalle Valo <kvalo@codeaurora.org> wrote:
> >>
> >> Ulf Hansson <ulf.hansson@linaro.org> writes:
> >>
> >> >> If I follow what has been done in other drivers I would write something
> >> >> like:
> >> >>
> >> >>   static int wfx_sdio_suspend(struct device *dev)
> >> >>   {
> >> >>           struct sdio_func *func = dev_to_sdio_func(dev);
> >> >>           struct wfx_sdio_priv *bus = sdio_get_drvdata(func);
> >> >>
> >> >>           config_reg_write_bits(bus->core, CFG_IRQ_ENABLE_DATA, 0);
> >> >>           // Necessary to keep device firmware in RAM
> >> >>           return sdio_set_host_pm_flags(func, MMC_PM_KEEP_POWER);
> >> >
> >> > This will tell the mmc/sdio core to keep the SDIO card powered on
> >> > during system suspend. Thus, it doesn't need to re-initialize it at
> >> > system resume - and the firmware should not need to be re-programmed.
> >> >
> >> > On the other hand, if you don't plan to support system wakeups, it
> >> > would probably be better to power off the card, to avoid wasting
> >> > energy while the system is suspended. I assume that means you need to
> >> > re-program the firmware as well. Normally, it's these kinds of things
> >> > that need to be managed from a ->resume() callback.
> >>
> >> Many mac80211 drivers do so that the device is powered off during
> >> interface down (ifconfig wlan0 down), and as mac80211 does interface
> >> down automatically during suspend, suspend then works without extra
> >> handlers.
> >
> > That sounds simple. :-)
>
> Indeed, I was omitting a lot of details :) My comment was more like a
> general remark to all different bus techonologies, not just about SDIO.
> And I'm not saying that all wireless drivers do that, but some of them
> do. Though I don't have any numbers how many.
>
> > Would you mind elaborating on what is actually being powered off at
> > interface down - and thus also I am curious what happens at a typical
> > interface up?
>
> In general in the drivers that do we this the firmware is completely
> turned off and all memory is reset during interface down. And firmware
> is started from the scratch during interface up. Also one benefit from
> this is that firmware state is reset, the wireless firmwares are
> notarious being buggy.
>
> > Even if we don't want to use system wakeups (wake-on-lan), the SDIO
> > core and the SDIO func driver still need to somewhat agree on how to
> > manage the power for the card during system suspend, I think.
> >
> > For example, for a non-removable SDIO card, the SDIO/MMC core may
> > decide to power off the card in system suspend. Then it needs to
> > restore power to the card and re-initialize it at system resume, of
> > course. This doesn't mean that the actual corresponding struct device
> > for it, gets removed/re-added, thus the SDIO func driver isn't being
> > re-probed after the system has resumed. Although, since the SDIO card
> > was re-initialized, it's likely that the FW may need to be
> > re-programmed after the system has been resumed.
> >
> > Are you saying that re-programming the FW is always happening at
> > interface up, when there are none system suspend/resume callbacks
> > assigned for the SDIO func driver?
>
> Yes, that's what I was trying to say. But take all this with grain of
> salt, I'm not very familiar with SDIO! And funnily enough, I checked
> what we do in ath10k_sdio driver during suspend has conflicting code and
> documentation:
>
> /* Empty handlers so that mmc subsystem doesn't remove us entirely during
>  * suspend. We instead follow cfg80211 suspend/resume handlers.
>  */
> static int ath10k_sdio_pm_suspend(struct device *device)
> {
>         struct sdio_func *func = dev_to_sdio_func(device);
>         struct ath10k_sdio *ar_sdio = sdio_get_drvdata(func);
>         struct ath10k *ar = ar_sdio->ar;
>         mmc_pm_flag_t pm_flag, pm_caps;
>         int ret;
>
>         if (!device_may_wakeup(ar->dev))
>                 return 0;
>
>         ath10k_sdio_set_mbox_sleep(ar, true);
>
>         pm_flag = MMC_PM_KEEP_POWER;
>
>         ret = sdio_set_host_pm_flags(func, pm_flag);
>         if (ret) {
>                 pm_caps = sdio_get_host_pm_caps(func);
>                 ath10k_warn(ar, "failed to set sdio host pm flags (0x%x, 0x%x): %d\n",
>                             pm_flag, pm_caps, ret);
>                 return ret;
>         }
>
>         return ret;

Just to confirm, the code looks reasonable to me, even if the comment
above looks a bit odd/outdated. :-)

*) Because the SDIO driver's ->suspend|resume() callbacks have been
assigned, the mmc core will not remove the corresponding SDIO
func/card's struct device.

**) If system wakeup *isn't* going to be enabled, the early return
with 0, will allow the mmc core to power off the SDIO card/func device
during system suspend. Vice versa, it will then restore power to it
and re-initialize it during system resume.

***) If system wakeup *is* going to be enabled, MMC_PM_KEEP_POWER flag
will prevent the mmc core from powering off the SDIO card/func device
during system suspend. Depending on if the wakeup irq is in-band or
out-band, MMC_PM_WAKE_SDIO_IRQ could be set too.

That said, note that ->probe() of the SDIO func driver, will not be
called for a non-removable SDIO func/card to re-program the FW after a
system suspend/resume. That needs to be managed from the SDIO func
driver's system resume callback - or deferring to upper common network
layers (interface up?), which seems to be the case here.

Kind regards
Uffe
