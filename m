Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A079FFC87A
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 15:11:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbfKNOLu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 09:11:50 -0500
Received: from mail-vk1-f195.google.com ([209.85.221.195]:36991 "EHLO
        mail-vk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726592AbfKNOLt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 09:11:49 -0500
Received: by mail-vk1-f195.google.com with SMTP id l5so1491344vkb.4
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 06:11:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XSmwLWNo5Rh6fe+p8Uu7DFNnAFhXmFiTvhxWz1V+B8w=;
        b=Zxy9Va/g5HeujT0G/Yr81ssNa+Mrn59GATo64imHO5v4yPYwyPPGs095S9yLGHZZct
         1hxeTUWiuBZWvi+O1vf0npeqW5PjS6EDcNVV/BuKq+FHtrEOxZldeFAkfves+9/Zc/nA
         Jfl+7lufr0kMeZAOu4jE2erwkVZzPMxG8lpE6MQdIaqDuXXS5sdJm3+y9FiWm52EK2l3
         WwyGBsnQjzhGRAggZDE4omJqyKpHbyv37Af0YKrpFhQbUSYZTgpsAw3qsoRhd/fdwACE
         5iSUjaPDvT/GCI+c4fijdDcGkjUJFX9Fldn0zizjgcTiajuBoo8z8CbjC/JqAxv7Pnw6
         eStg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XSmwLWNo5Rh6fe+p8Uu7DFNnAFhXmFiTvhxWz1V+B8w=;
        b=SdBl/DdZxOKkgyn/utdlAFnLaTKHr5Eb2slXohpusG3fEMbe23JY8bOtotY2b76tw8
         QGU1IooN//ycevagRGHZffg4VNdrxyFQvP+fJ5dnBusf+XA9Svh+TzIZOZrRXTSKuGok
         tyXqb+s/fw9Ke8JIVpzl80pTxUG+cP+baSO8xi9WRrM3MHrEoXc3biOV5o0as5CO9Fxt
         eceifY37BF71fYTDIzeGkpbXrEv9WPJjWh6pvuNesEIC/z6PK2BHd/Prv6ZoZyT2PzM5
         rw+CqsALAD/WfPELPZY6WPDV8EtQWwfYnORiVvr2T+vGbmm94dsagxFk6/l+K4Ang/dt
         klAA==
X-Gm-Message-State: APjAAAUfmfY9O8uv01ke6efkfPRH+kG0mL3NREje761B1voDphmaNFdN
        JA2/nPRLzbpZQsExcjnaJ+GI8a4zgq3o/0M2swy7Xw==
X-Google-Smtp-Source: APXvYqxNH6tQ6y7J3OfkNA5oBwmBY5VTe296JKBsrF2xLv130hd/N0da6UeuSUpnmtRg4fw9qbywtQvMfesNLW0c7dc=
X-Received: by 2002:a1f:2f51:: with SMTP id v78mr5258686vkv.101.1573740707355;
 Thu, 14 Nov 2019 06:11:47 -0800 (PST)
MIME-Version: 1.0
References: <cover.1573122644.git.hns@goldelico.com> <17b12e91c878dcb74160e3df5f88bc8a9e3f7fce.1573122644.git.hns@goldelico.com>
In-Reply-To: <17b12e91c878dcb74160e3df5f88bc8a9e3f7fce.1573122644.git.hns@goldelico.com>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Thu, 14 Nov 2019 15:11:11 +0100
Message-ID: <CAPDyKFpGU+tXC8thz52BQfKHNerzYSUroSihh6GpZELFm-1gRQ@mail.gmail.com>
Subject: Re: [PATCH v3 01/12] Documentation: dt: wireless: update wl1251 for sdio
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
        DTML <devicetree@vger.kernel.org>,
        Discussions about the Letux Kernel 
        <letux-kernel@openphoenux.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        kernel@pyra-handheld.com,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 7 Nov 2019 at 11:32, H. Nikolaus Schaller <hns@goldelico.com> wrote:
>
> The standard method for sdio devices connected to
> an sdio interface is to define them as a child node
> like we can see with wlcore.
>
> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
> Acked-by: Kalle Valo <kvalo@codeaurora.org>
> ---
>  .../bindings/net/wireless/ti,wl1251.txt       | 26 +++++++++++++++++++
>  1 file changed, 26 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/net/wireless/ti,wl1251.txt b/Documentation/devicetree/bindings/net/wireless/ti,wl1251.txt
> index bb2fcde6f7ff..f38950560982 100644
> --- a/Documentation/devicetree/bindings/net/wireless/ti,wl1251.txt
> +++ b/Documentation/devicetree/bindings/net/wireless/ti,wl1251.txt
> @@ -35,3 +35,29 @@ Examples:
>                 ti,power-gpio = <&gpio3 23 GPIO_ACTIVE_HIGH>; /* 87 */
>         };
>  };
> +
> +&mmc3 {
> +       vmmc-supply = <&wlan_en>;
> +
> +       bus-width = <4>;
> +       non-removable;
> +       ti,non-removable;
> +       cap-power-off-card;
> +
> +       pinctrl-names = "default";
> +       pinctrl-0 = <&mmc3_pins>;
> +
> +       #address-cells = <1>;
> +       #size-cells = <0>;
> +
> +       wlan: wifi@1 {
> +               compatible = "ti,wl1251";
> +
> +               reg = <1>;
> +
> +               interrupt-parent = <&gpio1>;
> +               interrupts = <21 IRQ_TYPE_LEVEL_HIGH>;  /* GPIO_21 */
> +
> +               ti,wl1251-has-eeprom;
> +       };
> +};

One minor thing, the "ti,power-gpio" is not required anymore, as it's
not needed for the SDIO case for pandora.

Please move it to an option section.

Kind regards
Uffe
