Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29710FD908
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 10:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727344AbfKOJaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 04:30:25 -0500
Received: from mail-ua1-f67.google.com ([209.85.222.67]:40355 "EHLO
        mail-ua1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727316AbfKOJaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 04:30:24 -0500
Received: by mail-ua1-f67.google.com with SMTP id i13so2802053uaq.7
        for <netdev@vger.kernel.org>; Fri, 15 Nov 2019 01:30:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U0K8GRiXqSgIpN48tBNHcV+jI/oiDgvDhl7ShZIVOhE=;
        b=dms2AT6yjYIujdBp5vLXzT3QSWBUJdp+Ja/bHoPGCKS84bKo37q9DYAWmQ+OhvnX47
         wQESQqhFjyBsKxLBW14sJM6Kkxy/Yvicy1Vttr/bmnfFi1qkmbGWwvZC6/I2T2hc0dc4
         E6e4jsZ8R7HPGQj7VhbAeZXMKd4W+mV9z0NBs1wYV93Cw7drye59WzshJHguKEkNXCPt
         fHF0ouNrAUlgmAVwGBwpW7V1N92+w5PRrvnambZTbfMnbWUBMJIPHZCBuMz5iDZ3km48
         QxwxVl+99j/KVNaPgNldx2y1f+snHTdbPP0IYzr0FUgyc31xgzkXkCrLt9Puderh1g1W
         O9fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U0K8GRiXqSgIpN48tBNHcV+jI/oiDgvDhl7ShZIVOhE=;
        b=ch52WTifHSeIDUKRZAC62VKSrAUMfXQ2/8sjuTxau49DHgsMk+RvpiDzkN6tox+STA
         NsD7zs5idla9epRwX2W7A6/jC3490BvDj0NxuwmonW0p1gZIiLxxWMbEuALyv6misHC2
         K1tEGr/dTTISJ4zCSIhsr88CFOtDFBLMhLnHajyTpYmhygNRYSaTKE+zX8NxMY82wKeq
         sHYGIjL8moTN0RzvV3DH7nXiEhNLUPV8mI+xEPkAneJbecjYwFs1s3dSBGQiAjkkli2e
         q+ZRzMFugSqjSdi92yKRXeCjD6IIWQuj2OU2cdQwod5JcOyhLyYuG8GoP/484cofzstJ
         OKkA==
X-Gm-Message-State: APjAAAXDrIZdTtPMlK0mLl9G5ba2J0+Qgozp2YVwgUdLQE9dimhIDBU2
        46RPWqp8OItbF3tHhBT2NTrkIGIP4m7qqnOCI83jfA==
X-Google-Smtp-Source: APXvYqzU6WJnGjb2iLphku/+v8QsaQ8unugsql39hfm0KRqoySp6l08BYKltD9R0v8e99ePYA9xvGwkzshWggfN0FEM=
X-Received: by 2002:ab0:74cd:: with SMTP id f13mr8348393uaq.104.1573810223324;
 Fri, 15 Nov 2019 01:30:23 -0800 (PST)
MIME-Version: 1.0
References: <cover.1573122644.git.hns@goldelico.com> <CAPDyKFrntf2Kd9Zf7uxRCUk_OrKD8B3xOKmvPaf04X21L5HwWA@mail.gmail.com>
 <5F5A5FC0-8F91-4D5B-9EF6-AF36FE38B588@goldelico.com>
In-Reply-To: <5F5A5FC0-8F91-4D5B-9EF6-AF36FE38B588@goldelico.com>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Fri, 15 Nov 2019 10:29:46 +0100
Message-ID: <CAPDyKFr=Uk1i0c=3WvuOYCQ__Skpr-9mjVM2Yqst-hd8zY6OeQ@mail.gmail.com>
Subject: Re: [PATCH v3 00/12] OpenPandora: make wl1251 connected to mmc3 sdio
 port of OpenPandora work again
To:     "H. Nikolaus Schaller" <hns@goldelico.com>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        DTML <devicetree@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Discussions about the Letux Kernel 
        <letux-kernel@openphoenux.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Russell King <linux@armlinux.org.uk>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Yangtao Li <tiny.windzz@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Petr Mladek <pmladek@suse.com>,
        =?UTF-8?Q?Beno=C3=AEt_Cousson?= <bcousson@baylibre.com>,
        kernel@pyra-handheld.com,
        Alexios Zavras <alexios.zavras@intel.com>,
        Rob Herring <robh+dt@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        David Sterba <dsterba@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-omap <linux-omap@vger.kernel.org>,
        Allison Randal <allison@lohutok.net>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Nov 2019 at 16:16, H. Nikolaus Schaller <hns@goldelico.com> wrote:
>
> Hi Ulf,
>
> > Am 14.11.2019 um 15:18 schrieb Ulf Hansson <ulf.hansson@linaro.org>:
> >
> > On Thu, 7 Nov 2019 at 11:31, H. Nikolaus Schaller <hns@goldelico.com> wrote:
> >>
> >>
> >> * add a revisit note for special wl1251 handling code because it should
> >>  be solved more generic in mmc core - suggested by Ulf Hansson <ulf.hansson@linaro.org>
> >> * remove init_card callback from platform_data/hsmmc-omap.h - suggested by Ulf Hansson <ulf.hansson@linaro.org>
> >> * remove obstructive always-on for vwlan regulator - suggested by Ulf Hansson <ulf.hansson@linaro.org>
> >> * rename DT node - suggested by Rob Herring <robh@kernel.org>
> >> * fix ARM: dts: subject prefix - suggested by Tony Lindgren <tony@atomide.com>
> >> * also remove omap2_hsmmc_info and obc-y line in Makefile - suggested by Tony Lindgren <tony@atomide.com>
> >
> > No further comments from my side. Let's just agree on how to deal with
> > the ti,power-gpio, then I can apply this.
>
> I'd say it can be a separate patch since it does not fix the Pandora
> issues, but is a new and independent optimization.
>
> And in case someone complains and uses it for some out-of tree purpose
> it can be discussed or even be reverted easier if it is a separate patch.
>
> I can do it in the next days.

Okay, that sounds reasonable.

In the meantime, I have queued up the series on my next branch (for v5.5).

I fixed up a couple of complaints from checkpatch, and also added
stable tags for the first two patches in the series, as that what
missing.

Kind regards
Uffe


>
> > Thanks a lot for fixing all this mess!
>
> I hope the users also appreciate our work.
>
> Best regards,
> Nikolaus
>
> >
> > Kind regards
> > Uffe
> >
> >>
> >> PATCH V2 2019-10-19 20:41:47:
> >> * added acked-by for wl1251 patches - Kalle Valo <kvalo@codeaurora.org>
> >> * really removed old pdata-quirks code (not through #if 0)
> >> * splited out a partial revert of
> >>        efdfeb079cc3b ("regulator: fixed: Convert to use GPIO descriptor only")
> >>  because that was introduced after v4.19 and stops the removal of
> >>  the pdata-quirks patch from cleanly applying to v4.9, v4.14, v4.19
> >>  - reported by Sasha Levin <sashal@kernel.org>
> >> * added a new patch to remove old omap hsmmc since pdata quirks
> >>  were last user - suggested by Tony Lindgren <tony@atomide.com>
> >>
> >> PATCH V1 2019-10-18 22:25:39:
> >> Here we have a set of scattered patches to make the OpenPandora WiFi work again.
> >>
> >> v4.7 did break the pdata-quirks which made the mmc3 interface
> >> fail completely, because some code now assumes device tree
> >> based instantiation.
> >>
> >> Fixes: 81eef6ca9201 ("mmc: omap_hsmmc: Use dma_request_chan() for requesting DMA channel")
> >>
> >> v4.11 did break the sdio qirks for wl1251 which made the driver no longer
> >> load, although the device was found as an sdio client.
> >>
> >> Fixes: 884f38607897 ("mmc: core: move some sdio IDs out of quirks file")
> >>
> >> To solve these issues:
> >> * we convert mmc3 and wl1251 initialization from pdata-quirks
> >>  to device tree
> >> * we make the wl1251 driver read properties from device tree
> >> * we fix the mmc core vendor ids and quirks
> >> * we fix the wl1251 (and wl1271) driver to use only vendor ids
> >>  from header file instead of (potentially conflicting) local
> >>  definitions
> >>
> >>
> >> H. Nikolaus Schaller (12):
> >>  Documentation: dt: wireless: update wl1251 for sdio
> >>  net: wireless: ti: wl1251 add device tree support
> >>  ARM: dts: pandora-common: define wl1251 as child node of mmc3
> >>  mmc: host: omap_hsmmc: add code for special init of wl1251 to get rid
> >>    of pandora_wl1251_init_card
> >>  omap: pdata-quirks: revert pandora specific gpiod additions
> >>  omap: pdata-quirks: remove openpandora quirks for mmc3 and wl1251
> >>  omap: remove omap2_hsmmc_info in old hsmmc.[ch] and update Makefile
> >>  mmc: host: omap-hsmmc: remove init_card pdata callback from pdata
> >>  mmc: sdio: fix wl1251 vendor id
> >>  mmc: core: fix wl1251 sdio quirks
> >>  net: wireless: ti: wl1251 use new SDIO_VENDOR_ID_TI_WL1251 definition
> >>  net: wireless: ti: remove local VENDOR_ID and DEVICE_ID definitions
> >>
> >> .../bindings/net/wireless/ti,wl1251.txt       |  26 +++
> >> arch/arm/boot/dts/omap3-pandora-common.dtsi   |  36 +++-
> >> arch/arm/mach-omap2/Makefile                  |   3 -
> >> arch/arm/mach-omap2/common.h                  |   1 -
> >> arch/arm/mach-omap2/hsmmc.c                   | 171 ------------------
> >> arch/arm/mach-omap2/hsmmc.h                   |  32 ----
> >> arch/arm/mach-omap2/pdata-quirks.c            | 105 -----------
> >> drivers/mmc/core/quirks.h                     |   7 +
> >> drivers/mmc/host/omap_hsmmc.c                 |  30 ++-
> >> drivers/net/wireless/ti/wl1251/sdio.c         |  23 ++-
> >> drivers/net/wireless/ti/wlcore/sdio.c         |   8 -
> >> include/linux/mmc/sdio_ids.h                  |   2 +
> >> include/linux/platform_data/hsmmc-omap.h      |   3 -
> >> 13 files changed, 111 insertions(+), 336 deletions(-)
> >> delete mode 100644 arch/arm/mach-omap2/hsmmc.c
> >> delete mode 100644 arch/arm/mach-omap2/hsmmc.h
> >>
> >> --
> >> 2.23.0
> >>
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
