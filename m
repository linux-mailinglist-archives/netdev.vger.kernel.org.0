Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A041DEB5AB
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 17:59:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728881AbfJaQ7p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 12:59:45 -0400
Received: from mail-vs1-f65.google.com ([209.85.217.65]:39955 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728858AbfJaQ7o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 12:59:44 -0400
Received: by mail-vs1-f65.google.com with SMTP id v10so4546959vsc.7
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 09:59:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rBXjy64QhAJngU1bLCgW8NmRIabhTqAJ4rYpSUJH/vA=;
        b=MFPuR6yrPRTAmL9shB7f7ccQmfeaxlzOoX57mPiTDTNTInAdnhDq1qiWaZtEhzbSLI
         aLEv7aV9AfTmYN2RGLov44yiuhk/5h8r4Z03gT3ZXWcaMGCrA2GoczDlv5IVrmoOhv4t
         WcfOOehtYLlEpYEn0voLWT83cdteFabhYfsqZC54x6OQXZwgDcqZkFmA5SMMHwjWTNSG
         sYg9VpHJwIznNow79XZhVdyqPv493SMXP9sXVX7fApFQoibaYXQZ08TdkHafK52H7w9Y
         fikkLMrmkfpckOrp6DlZiXfmWE8rD0t0Bw6Jbyw+t93JF2MRH6PaH9+QYnvO5UucNtMy
         ON5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rBXjy64QhAJngU1bLCgW8NmRIabhTqAJ4rYpSUJH/vA=;
        b=c1FO04ysxfISu4DFf6IpLBd9BF6a6d0/HRNo6dUl3gLU9SUmQdPU7V3oJRo3KXvj+K
         S/I65dEoyqfVhQCc5jI7mXyWfu11H+n8IFmvXxGQebSGPfApYedW1fQM4DatfGueVpQz
         k0XUvBbllpgZmekVEtCQmfD/185udi4ENC0D7ddzvCqgYJHsQTBrQ6pvtmXY2n2eW9m3
         3PXNCvE/wZR3pQ5FX26ZdOyscBlCGqX7VaUU5ySw950TPLvbsKHejlGClkPRqYwf9c91
         jFW2A529TJbNLKIMjE2a0oPTMMAxAAi/AthdImrk7twk+SG/ifVIIfqETb/sCnB6lUxp
         mOWw==
X-Gm-Message-State: APjAAAUIuZRFoMzoG6zyOn4Cu5j5IWSKMg4ULSBam/DYhCrbgr8Jz/dh
        6/6aQEk+JcMJC9TfIaTm904+QtO4iIhMLVkCEWwHBA==
X-Google-Smtp-Source: APXvYqxUDYzIwZUL5FbFN+ofBpA8OFEwiksm7t/nLo1J8VkpA/QJoge6ynXgiOcDbF0m20N6ahz2Rokt9mlDmh48qB4=
X-Received: by 2002:a67:fb5a:: with SMTP id e26mr3354691vsr.200.1572541182099;
 Thu, 31 Oct 2019 09:59:42 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1571510481.git.hns@goldelico.com> <bec9d76e6da03d734649b9bdf76e9d575c57631a.1571510481.git.hns@goldelico.com>
 <CAPDyKFrMQ3fBaeeAYVJfUdL8m=PDRU9Xt_9oGw6D1XOY68qDuQ@mail.gmail.com> <D9A82904-35BE-41F2-A308-9A49606428B1@goldelico.com>
In-Reply-To: <D9A82904-35BE-41F2-A308-9A49606428B1@goldelico.com>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Thu, 31 Oct 2019 17:59:05 +0100
Message-ID: <CAPDyKFrbOH=ROv_JefSQsEnmGqN6oFVfbhpqscOK=KUqJgzarw@mail.gmail.com>
Subject: Re: [PATCH v2 03/11] DTS: ARM: pandora-common: define wl1251 as child
 node of mmc3
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
        <letux-kernel@openphoenux.org>, kernel@pyra-handheld.com,
        "# 4.0+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Oct 2019 at 18:25, H. Nikolaus Schaller <hns@goldelico.com> wrote:
>
>
> > Am 30.10.2019 um 17:44 schrieb Ulf Hansson <ulf.hansson@linaro.org>:
> >
> > On Sat, 19 Oct 2019 at 20:42, H. Nikolaus Schaller <hns@goldelico.com> wrote:
> >>
> >> Since v4.7 the dma initialization requires that there is a
> >> device tree property for "rx" and "tx" channels which is
> >> not provided by the pdata-quirks initialization.
> >>
> >> By conversion of the mmc3 setup to device tree this will
> >> finally allows to remove the OpenPandora wlan specific omap3
> >> data-quirks.
> >>
> >> Fixes: 81eef6ca9201 ("mmc: omap_hsmmc: Use dma_request_chan() for requesting DMA channel")
> >>
> >> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
> >> Cc: <stable@vger.kernel.org> # 4.7.0
> >> ---
> >> arch/arm/boot/dts/omap3-pandora-common.dtsi | 37 +++++++++++++++++++--
> >> 1 file changed, 35 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/arch/arm/boot/dts/omap3-pandora-common.dtsi b/arch/arm/boot/dts/omap3-pandora-common.dtsi
> >> index ec5891718ae6..c595b3eb314d 100644
> >> --- a/arch/arm/boot/dts/omap3-pandora-common.dtsi
> >> +++ b/arch/arm/boot/dts/omap3-pandora-common.dtsi
> >> @@ -226,6 +226,18 @@
> >>                gpio = <&gpio6 4 GPIO_ACTIVE_HIGH>;     /* GPIO_164 */
> >>        };
> >>
> >> +       /* wl1251 wifi+bt module */
> >> +       wlan_en: fixed-regulator-wg7210_en {
> >> +               compatible = "regulator-fixed";
> >> +               regulator-name = "vwlan";
> >> +               regulator-min-microvolt = <1800000>;
> >> +               regulator-max-microvolt = <1800000>;
> >
> > I doubt these are correct.
> >
> > I guess this should be in the range of 2.7V-3.6V.
>
> Well, it is a gpio which enables some LDO inside the
> wifi chip. We do not really know the voltage it produces
> and it does not matter. The gpio voltage is 1.8V.
>
> Basically we use a fixed-regulator to "translate" a
> regulator into a control gpio because the mmc interface
> wants to see a vmmc-supply.

The vmmc supply represent the core power to the SDIO card (or
SD/(e)MMC). Depending on what voltage range the vmmc supply supports,
the so called OCR mask is created by the mmc core. The mask is then
used to let the core negotiate the voltage level with the SDIO card,
during the card initialization. This is not to confuse with the I/O
voltage level, which is a different regulator.

Anyway, according to the TI WiLink series specifications, it looks
like vmmc should be a regulator supporting 3-3.3V (in many schematics
it's called VBAT).

Furthermore I decided to dig into various DTS files that specifies the
vmmc regulator, of course for mmc nodes having a subnode specifying an
SDIO card for a TI WiLink. In most cases a 1.8V fixed GPIO regulator
is used. This looks wrong to me. The fixed GPIO regulator isn't really
the one that should model vmmc.

The proper solution, would rather be to use separate regulator for
vmmc and instead use a so called mmc-pwrseq node to manage the GPIO.

To conclude from my side, as we have lots of DTS that are wrong, I
don't really care if we add another one in the way you suggest above.
But feel free to look into the mmc-pwrseq option.

>
> >
> >> +               startup-delay-us = <50000>;
> >> +               regulator-always-on;
> >
> > Always on?
>
> Oops. Yes, that is something to check!

As it's a GPIO regulator, for sure it's not always on.

>
> >
> >> +               enable-active-high;
> >> +               gpio = <&gpio1 23 GPIO_ACTIVE_HIGH>;
> >> +       };
> >> +
> >>        /* wg7210 (wifi+bt module) 32k clock buffer */
> >>        wg7210_32k: fixed-regulator-wg7210_32k {
> >>                compatible = "regulator-fixed";
> >> @@ -522,9 +534,30 @@
> >>        /*wp-gpios = <&gpio4 31 GPIO_ACTIVE_HIGH>;*/    /* GPIO_127 */
> >> };
> >>
> >> -/* mmc3 is probed using pdata-quirks to pass wl1251 card data */
> >> &mmc3 {
> >> -       status = "disabled";
> >> +       vmmc-supply = <&wlan_en>;
> >> +
> >> +       bus-width = <4>;
> >> +       non-removable;
> >> +       ti,non-removable;
> >> +       cap-power-off-card;
> >> +
> >> +       pinctrl-names = "default";
> >> +       pinctrl-0 = <&mmc3_pins>;
> >> +
> >> +       #address-cells = <1>;
> >> +       #size-cells = <0>;
> >> +
> >> +       wlan: wl1251@1 {
> >> +               compatible = "ti,wl1251";
> >> +
> >> +               reg = <1>;
> >> +
> >> +               interrupt-parent = <&gpio1>;
> >> +               interrupts = <21 IRQ_TYPE_LEVEL_HIGH>;  /* GPIO_21 */
> >> +
> >> +               ti,wl1251-has-eeprom;
> >> +       };
> >> };
> >>
> >> /* bluetooth*/
> >> --
> >> 2.19.1
> >>
>
> BR and thanks,
> Nikolaus
>

Kind regards
Uffe
