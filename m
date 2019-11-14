Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB922FC8AB
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 15:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbfKNOTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 09:19:06 -0500
Received: from mail-vs1-f68.google.com ([209.85.217.68]:43762 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726598AbfKNOTG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 09:19:06 -0500
Received: by mail-vs1-f68.google.com with SMTP id b16so3936746vso.10
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 06:19:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mF9QJkIN8Qk+EGkxO+jVoBbFR7FMIpRA3CjmA8m3d7Y=;
        b=Ml/cOiBysl9RO47an1PTBHLBV9w/7hUJ5RTzC9SA1Mtzt+/DhPojZxalupt6UqYxdQ
         Z6JVbt31LezzDArBbJjiKL2Y5fmaM9zvJ7unZ4BgDdfgF9mW0AXrx+BoEeZrvPk8v4Na
         vFp/6s+uvZ+tazuT9dOHmkygy3CCIjNpWHbDS4RdoO1Ax+9gtplcOkQGyvu+xkTNpwvf
         BQOZDKA6W1skAgd0wkcQQjy4KYmerLP5JSisRTka6/XXrK6yecbJSVLJ+KeRGxhACdKH
         8qTLgfs22vZ7hOJ8kyH9jH6x5yGzqyYsrJoASTpX+UbbwnAEwMt16yGMLqfSMGWl0VET
         jivg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mF9QJkIN8Qk+EGkxO+jVoBbFR7FMIpRA3CjmA8m3d7Y=;
        b=jbVcvCnkIAAYz39/0e4ZZjMDGz1YmNHtsoQrJzIFZbGDBnwyWugPV4lFPO4/840LqR
         +ZLXVRKXsicL8L+89paFAwkHWKWmxBw1daMslEl0yUVjXRYVtbJ4ev+JRRHY5lf3n3Cb
         OO+H98RbbRpW0wC1N+KOen8pMgQNZiq7wuK+0a1KjgjG/CofA0ec+xmJgCn+E4J4atGH
         7KhfDGltASq8HzCIzkJNBZp0PkqAoUq8Su2wFtNYqee95gIX823VhcFA4Ec0nSmu2ab4
         HOjxe6Pp1LyS04PjGUSmc6dmJkyhpTtdg6C4HA53dYxc6Cn5qcKIBQ7MiIGfGdpF3pVs
         lVoA==
X-Gm-Message-State: APjAAAUb1g9waL+d30r4ATDHKM2OujEoFyskVQvNxr6fetZ0obW6Y1Jt
        aR+9VuXaSrvqTvJu3dAyREPXOHsjAVL0yvriITya8A==
X-Google-Smtp-Source: APXvYqwgCmwHYSDSJ68Em4upupN+YGH3wrjpaM8fSyc24xbueo9viz0GrcVPQXBkKEvWLAXn8LtIFd6tV6myvBaAjVM=
X-Received: by 2002:a05:6102:36d:: with SMTP id f13mr6019578vsa.34.1573741145328;
 Thu, 14 Nov 2019 06:19:05 -0800 (PST)
MIME-Version: 1.0
References: <cover.1573122644.git.hns@goldelico.com>
In-Reply-To: <cover.1573122644.git.hns@goldelico.com>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Thu, 14 Nov 2019 15:18:29 +0100
Message-ID: <CAPDyKFrntf2Kd9Zf7uxRCUk_OrKD8B3xOKmvPaf04X21L5HwWA@mail.gmail.com>
Subject: Re: [PATCH v3 00/12] OpenPandora: make wl1251 connected to mmc3 sdio
 port of OpenPandora work again
To:     "H. Nikolaus Schaller" <hns@goldelico.com>
Cc:     =?UTF-8?Q?Beno=C3=AEt_Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@armlinux.org.uk>,
        Kalle Valo <kvalo@codeaurora.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        David Sterba <dsterba@suse.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Petr Mladek <pmladek@suse.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Yangtao Li <tiny.windzz@gmail.com>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Allison Randal <allison@lohutok.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        DTML <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Discussions about the Letux Kernel 
        <letux-kernel@openphoenux.org>, kernel@pyra-handheld.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 7 Nov 2019 at 11:31, H. Nikolaus Schaller <hns@goldelico.com> wrote:
>
>
> * add a revisit note for special wl1251 handling code because it should
>   be solved more generic in mmc core - suggested by Ulf Hansson <ulf.hansson@linaro.org>
> * remove init_card callback from platform_data/hsmmc-omap.h - suggested by Ulf Hansson <ulf.hansson@linaro.org>
> * remove obstructive always-on for vwlan regulator - suggested by Ulf Hansson <ulf.hansson@linaro.org>
> * rename DT node - suggested by Rob Herring <robh@kernel.org>
> * fix ARM: dts: subject prefix - suggested by Tony Lindgren <tony@atomide.com>
> * also remove omap2_hsmmc_info and obc-y line in Makefile - suggested by Tony Lindgren <tony@atomide.com>

No further comments from my side. Let's just agree on how to deal with
the ti,power-gpio, then I can apply this.

Thanks a lot for fixing all this mess!

Kind regards
Uffe

>
> PATCH V2 2019-10-19 20:41:47:
> * added acked-by for wl1251 patches - Kalle Valo <kvalo@codeaurora.org>
> * really removed old pdata-quirks code (not through #if 0)
> * splited out a partial revert of
>         efdfeb079cc3b ("regulator: fixed: Convert to use GPIO descriptor only")
>   because that was introduced after v4.19 and stops the removal of
>   the pdata-quirks patch from cleanly applying to v4.9, v4.14, v4.19
>   - reported by Sasha Levin <sashal@kernel.org>
> * added a new patch to remove old omap hsmmc since pdata quirks
>   were last user - suggested by Tony Lindgren <tony@atomide.com>
>
> PATCH V1 2019-10-18 22:25:39:
> Here we have a set of scattered patches to make the OpenPandora WiFi work again.
>
> v4.7 did break the pdata-quirks which made the mmc3 interface
> fail completely, because some code now assumes device tree
> based instantiation.
>
> Fixes: 81eef6ca9201 ("mmc: omap_hsmmc: Use dma_request_chan() for requesting DMA channel")
>
> v4.11 did break the sdio qirks for wl1251 which made the driver no longer
> load, although the device was found as an sdio client.
>
> Fixes: 884f38607897 ("mmc: core: move some sdio IDs out of quirks file")
>
> To solve these issues:
> * we convert mmc3 and wl1251 initialization from pdata-quirks
>   to device tree
> * we make the wl1251 driver read properties from device tree
> * we fix the mmc core vendor ids and quirks
> * we fix the wl1251 (and wl1271) driver to use only vendor ids
>   from header file instead of (potentially conflicting) local
>   definitions
>
>
> H. Nikolaus Schaller (12):
>   Documentation: dt: wireless: update wl1251 for sdio
>   net: wireless: ti: wl1251 add device tree support
>   ARM: dts: pandora-common: define wl1251 as child node of mmc3
>   mmc: host: omap_hsmmc: add code for special init of wl1251 to get rid
>     of pandora_wl1251_init_card
>   omap: pdata-quirks: revert pandora specific gpiod additions
>   omap: pdata-quirks: remove openpandora quirks for mmc3 and wl1251
>   omap: remove omap2_hsmmc_info in old hsmmc.[ch] and update Makefile
>   mmc: host: omap-hsmmc: remove init_card pdata callback from pdata
>   mmc: sdio: fix wl1251 vendor id
>   mmc: core: fix wl1251 sdio quirks
>   net: wireless: ti: wl1251 use new SDIO_VENDOR_ID_TI_WL1251 definition
>   net: wireless: ti: remove local VENDOR_ID and DEVICE_ID definitions
>
>  .../bindings/net/wireless/ti,wl1251.txt       |  26 +++
>  arch/arm/boot/dts/omap3-pandora-common.dtsi   |  36 +++-
>  arch/arm/mach-omap2/Makefile                  |   3 -
>  arch/arm/mach-omap2/common.h                  |   1 -
>  arch/arm/mach-omap2/hsmmc.c                   | 171 ------------------
>  arch/arm/mach-omap2/hsmmc.h                   |  32 ----
>  arch/arm/mach-omap2/pdata-quirks.c            | 105 -----------
>  drivers/mmc/core/quirks.h                     |   7 +
>  drivers/mmc/host/omap_hsmmc.c                 |  30 ++-
>  drivers/net/wireless/ti/wl1251/sdio.c         |  23 ++-
>  drivers/net/wireless/ti/wlcore/sdio.c         |   8 -
>  include/linux/mmc/sdio_ids.h                  |   2 +
>  include/linux/platform_data/hsmmc-omap.h      |   3 -
>  13 files changed, 111 insertions(+), 336 deletions(-)
>  delete mode 100644 arch/arm/mach-omap2/hsmmc.c
>  delete mode 100644 arch/arm/mach-omap2/hsmmc.h
>
> --
> 2.23.0
>
