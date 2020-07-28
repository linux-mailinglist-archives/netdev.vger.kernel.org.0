Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E751D230A30
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 14:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729710AbgG1McR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 08:32:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729594AbgG1McR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 08:32:17 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD454C061794
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 05:32:16 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id x9so20928813ljc.5
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 05:32:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O7JFfHA0ol5NEN+riXk5hq0c8kAHEXCDeoK/bGlrHU8=;
        b=lgi/QLefazTpl1H+gzeV/UKWceron/gwx9+t5uZiZJLkFUgNWXq8mMzAnbnkYaad8k
         7IAbqIPtlI9g+qdXFELxDJu+UuNKG/MaPOlfh+JNU3ERh/jIoRbfWEcMXnNFhz6aXOF8
         HzkKzMCzZXajzFEYxBA3rCAOW1qZ4rufy8SwOf8M1InXXQQQgEgVhAow/ei5rWysVzSQ
         fXrnJxuKfyf7yv0aROOG3rOuRYsWHmR62rUFArvxQrdX0oR7sJuvDP8rWfFJsi2dF/jr
         GzKXRoCwLFBZieTyPKp7euKtfu7pRb1Fs4bl0/vwlFA1F4XXYh4G5vzjf4TJZRGjcvm8
         s+ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O7JFfHA0ol5NEN+riXk5hq0c8kAHEXCDeoK/bGlrHU8=;
        b=HIwUnge2tscN1TDJ0sxEcdaxo3IxdHYDsTW1QmGoQQJQjaOrp7vBZh7kO7XrcxwcRO
         hq3AyYgayrTR7ncspOg4pv9ztRhy++t2TLAZQLyV2TWVSrdvqKkLcoX+opVHHDtWeTdw
         8NS0RuHkjps1n4EZBinKU+0KVIzi+H5ZJXF9gGpn3dBtrje4e/fQRdlUA7Jui4kcj5Fy
         CRCf0TkWoYPnvBfEzmODw2hkGhzmNWMdHIybJb7foVjzk1r3ona2DsvadBxixUa/5Dbt
         ZZ+2fyQPm14qpCvwgOJxpvDKBuCzX8mb78v173h+Em46/jKDM1Uro1s1NLHdfTY4pQJ4
         AsIg==
X-Gm-Message-State: AOAM531BChI17ZX0KHAsBR0ssBG2viBvtzQZlO1K31btArUC8qHUDlS/
        zOF5g4JTqm1cA7g3FUfkuN8cRlhm5HNWr+qen6Y=
X-Google-Smtp-Source: ABdhPJxF8H/zpy3v41oSYo7YdeMDkpZyCs3c8/rB5fbKYMvY/UoIbFgv3FIBOBG8OiuchdVSFVu0cHlgVWR9HEpF84E=
X-Received: by 2002:a2e:80d3:: with SMTP id r19mr3988163ljg.310.1595939535269;
 Tue, 28 Jul 2020 05:32:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200728090203.17313-1-bruno.thomsen@gmail.com>
In-Reply-To: <20200728090203.17313-1-bruno.thomsen@gmail.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Tue, 28 Jul 2020 09:32:03 -0300
Message-ID: <CAOMZO5D3Hiybr8dPv2LZFrqp23=N1UGiy9Qea74ZSThoZALMbQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] net: mdiobus: reset deassert delay
To:     Bruno Thomsen <bruno.thomsen@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lars Alex Pedersen <laa@kamstrup.com>,
        Bruno Thomsen <bth@kamstrup.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Bruno,

On Tue, Jul 28, 2020 at 6:02 AM Bruno Thomsen <bruno.thomsen@gmail.com> wrote:
>
> The current reset logic only has a delay during assert.
> This reuses the delay value as deassert delay to ensure
> PHYs are ready for commands. Delays are typically needed
> when external hardware slows down reset release with a
> RC network. This solution does not need any new device
> tree bindings.
> It also improves handling of long delays (>20ms) by using
> the generic fsleep() for selecting appropriate delay
> function.

It seems that this patch should be split in two:

One that changes from udelay() to sleep()
and another one that adds the delay after the reset line is de-asserted.

>
> Signed-off-by: Bruno Thomsen <bruno.thomsen@gmail.com>
> ---
>  drivers/net/phy/mdio_bus.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> index 6ceee82b2839..84d5ab07fe16 100644
> --- a/drivers/net/phy/mdio_bus.c
> +++ b/drivers/net/phy/mdio_bus.c
> @@ -627,8 +627,9 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
>                 bus->reset_gpiod = gpiod;
>
>                 gpiod_set_value_cansleep(gpiod, 1);
> -               udelay(bus->reset_delay_us);
> +               fsleep(bus->reset_delay_us);
>                 gpiod_set_value_cansleep(gpiod, 0);
> +               fsleep(bus->reset_delay_us);

Shouldn't it use the value passed in the reset-deassert-us property instead?
