Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 305FEFC88C
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 15:13:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727361AbfKNONZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 09:13:25 -0500
Received: from mail-ua1-f65.google.com ([209.85.222.65]:33525 "EHLO
        mail-ua1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727217AbfKNONZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 09:13:25 -0500
Received: by mail-ua1-f65.google.com with SMTP id a13so1911652uaq.0
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 06:13:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FJX4pImmW+1dIAMZK03BtkAIeMegqqUoxzHSgtg4Ca4=;
        b=kTe0B79e9Q3wfvE896/JqCWZWDPTHUnKJF3MXGJCz0VulZPNVJNms03VWhWhosu0r5
         65u5iTmqWQfZhZU6bZ43HtCH3t9odmp08GyQa+kXxDCOH1M9z2/nD017md8ls95KA8VP
         ScIOnZqRoEAnVGwumKypo7R1jHWTsqOLnL6eBU/RaI2+hdZynt2GBCuBi/hTtG43ri6w
         rXa5aWAOZxBY1H9M1Y57rS3KQgGaa/rz8QLbkYvZ2P8SjOkhJh96iSXBPr0zCcnFlfWj
         USwGVkvBZ+QWGkRyEY9OPWD6vy6WDksT8kV8rKsKHSBpk+Gwww5b9A0D0ZRiHDza1Lch
         oI1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FJX4pImmW+1dIAMZK03BtkAIeMegqqUoxzHSgtg4Ca4=;
        b=gtITdABka0UmqMURl/qQQXFiV6yzQ/K8J4L4NdacqLhlskhdOuIRLed1ULHgqb7LmC
         JPyFuvNre8n4owwL0MhfGvPrmirgTUmiK2kK1sokHzrsFuittxxwTGpel8FS/zAgg2/1
         x9x8v+1ijWdd2c4QwEa3j1GPG3hZoBfe/TRDzxa2tmJO5roNpgd56JOYWjvlwBkE5chL
         z2vzcIUQliz0DX0+p2rfb0q9OsZvU0ML36cu1jVUuMaO8iX9u1XvcHnr7dUVnSWA9G+F
         0xE2inqpkULEcsMGyL0lawN5Mt4KtJoaAbXL3cvloF1CRu/DgaJEporez7YZKomaRzeM
         qVkQ==
X-Gm-Message-State: APjAAAUqlg3KSCJX52V6ZuNXu27DHeFnCy1fY7xXxTHHVfJlFJ5tKBg+
        BytL3pDqzkOG5nzBz/W6tLCGE62AIkof5phmF06Ydg==
X-Google-Smtp-Source: APXvYqx4RK4gWYtCk+erym1uLlCEMYfvmcIf3PPkVWWUkOMrPhdQcGSzRSUDsyWVm4ZWkUAyeM62b0wXUC2Rr+arkK8=
X-Received: by 2002:ab0:3399:: with SMTP id y25mr5562495uap.100.1573740804146;
 Thu, 14 Nov 2019 06:13:24 -0800 (PST)
MIME-Version: 1.0
References: <cover.1573122644.git.hns@goldelico.com> <c128cf34cf3858538eac8abffa02a2af8ce845b2.1573122644.git.hns@goldelico.com>
In-Reply-To: <c128cf34cf3858538eac8abffa02a2af8ce845b2.1573122644.git.hns@goldelico.com>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Thu, 14 Nov 2019 15:12:48 +0100
Message-ID: <CAPDyKFomoH5U0XevwKcaHRjf1hEyyqZfv4K_DZhCB7kpuXda2g@mail.gmail.com>
Subject: Re: [PATCH v3 02/12] net: wireless: ti: wl1251 add device tree support
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

On Thu, 7 Nov 2019 at 11:31, H. Nikolaus Schaller <hns@goldelico.com> wrote:
>
> We will have the wl1251 defined as a child node of the mmc interface
> and can read setup for gpios, interrupts and the ti,use-eeprom
> property from there instead of pdata to be provided by pdata-quirks.
>
> Fixes: 81eef6ca9201 ("mmc: omap_hsmmc: Use dma_request_chan() for requesting DMA channel")
>
> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
> Acked-by: Kalle Valo <kvalo@codeaurora.org>
> ---
>  drivers/net/wireless/ti/wl1251/sdio.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> diff --git a/drivers/net/wireless/ti/wl1251/sdio.c b/drivers/net/wireless/ti/wl1251/sdio.c
> index 677f1146ccf0..c54a273713ed 100644
> --- a/drivers/net/wireless/ti/wl1251/sdio.c
> +++ b/drivers/net/wireless/ti/wl1251/sdio.c
> @@ -16,6 +16,9 @@
>  #include <linux/irq.h>
>  #include <linux/pm_runtime.h>
>  #include <linux/gpio.h>
> +#include <linux/of.h>
> +#include <linux/of_gpio.h>
> +#include <linux/of_irq.h>
>
>  #include "wl1251.h"
>
> @@ -217,6 +220,7 @@ static int wl1251_sdio_probe(struct sdio_func *func,
>         struct ieee80211_hw *hw;
>         struct wl1251_sdio *wl_sdio;
>         const struct wl1251_platform_data *wl1251_board_data;
> +       struct device_node *np = func->dev.of_node;
>
>         hw = wl1251_alloc_hw();
>         if (IS_ERR(hw))
> @@ -248,6 +252,15 @@ static int wl1251_sdio_probe(struct sdio_func *func,
>                 wl->power_gpio = wl1251_board_data->power_gpio;
>                 wl->irq = wl1251_board_data->irq;
>                 wl->use_eeprom = wl1251_board_data->use_eeprom;
> +       } else if (np) {
> +               wl->use_eeprom =of_property_read_bool(np, "ti,wl1251-has-eeprom");
> +               wl->power_gpio = of_get_named_gpio(np, "ti,power-gpio", 0);

This isn't needed as it seems. Perhaps remove or keep it as optional?

> +               wl->irq = of_irq_get(np, 0);
> +
> +               if (wl->power_gpio == -EPROBE_DEFER || wl->irq == -EPROBE_DEFER) {
> +                       ret = -EPROBE_DEFER;
> +                       goto disable;
> +               }
>         }
>
>         if (gpio_is_valid(wl->power_gpio)) {
> --

Kind regards
Uffe
