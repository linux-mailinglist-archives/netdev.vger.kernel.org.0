Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 731003EDDC9
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 21:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbhHPTVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 15:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbhHPTVR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 15:21:17 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F3B6C0613C1
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 12:20:45 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id i8so12133704ybt.7
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 12:20:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m941o/jFjrWB+9ctuoqyaTbWLdVEpdtxf8KbVW3gbIk=;
        b=HOcq2K66ZKPP31cm6RZHlq56X1yVo3CslldYBgHbHXxxMx7sY6sZ1vLFOOnXHJleKX
         tO/frA17gCW9yPjK7AVdKkSSiP1Iv0L+nZ+n2/RgX3kRbvp0GdXhR5nLkOslpYafc0JQ
         PkpSFzwudTgrqTz7HrQPLEjxSpwXHrxHnygXnrp/cESRvJPu7YQInaR1QVgQiTjVYlb6
         LO1C9EcGr+3h4RXG8tE7aJOXee5qMGNY/lDMu8mvcEzj1PYJgFi/9sfXDlgiVG6X6XBE
         XVPzgzGnPL63UhqQdsSPZU6LF4cksKdPLlFNzzp8AE8zUYtDedL9BrXBwozgwbwQdNLz
         m+UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m941o/jFjrWB+9ctuoqyaTbWLdVEpdtxf8KbVW3gbIk=;
        b=VK6LEIJNuk9LIlGd3crG5C8hw5DPrHbx7An/JyT4ErD0lKtk8/bzWC8+sBi/5f08oZ
         K7oryEd0DpZDBGQ2AbKxud/TvGxBFsfnidCao1C5KG5RMmT1GLnk6sHoWTzYifNt9Ve1
         dWaHFkKLEdQ32hFZ5X6g7xAlhbVljWQKovkWcV/5+uxquWTfVKTDGi+jXUQJep9gB58z
         Io8h0TS84sc5ti+blwzbwRkZcA3JTZ2T6OUKCcA6ZZleZauYsKLPglGVsNh/v18cccdy
         HJBbK9mgHXAElLtlrKDI3pqJfTwQRYDj2RIn9hniycJ99wqL3lANTROuLbcyNY+xwruv
         iAWQ==
X-Gm-Message-State: AOAM530f95nBeNPSDl6OmUlngKk5kkuFyZ/Rj1xoDZxX1IsbIDL6+KWI
        ImjbTg288WHwdy1qzwPZn3okzBJF/Hg9kth1YGydSQ==
X-Google-Smtp-Source: ABdhPJyZubQxyT6jtWns+tJs06g+ZUE+aT6gqe9sdAyanSPoHdmeju9qXBQYZwQYua2zd6rbCJ4Hw7GA9o7bLCNoPSs=
X-Received: by 2002:a25:db89:: with SMTP id g131mr23150445ybf.302.1629141644661;
 Mon, 16 Aug 2021 12:20:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210816115953.72533-1-andriy.shevchenko@linux.intel.com> <20210816115953.72533-3-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20210816115953.72533-3-andriy.shevchenko@linux.intel.com>
From:   Bartosz Golaszewski <bgolaszewski@baylibre.com>
Date:   Mon, 16 Aug 2021 21:20:34 +0200
Message-ID: <CAMpxmJWrCJb6JJtQVurM3UexPwqz1OuydE9NvxyRwBb5hD=7aQ@mail.gmail.com>
Subject: Re: [PATCH v1 2/6] gpio: mlxbf2: Drop wrong use of ACPI_PTR()
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     David Thompson <davthompson@nvidia.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-gpio <linux-gpio@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Asmaa Mnebhi <asmaa@nvidia.com>,
        Liming Sun <limings@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 16, 2021 at 2:00 PM Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
>
> ACPI_PTR() is more harmful than helpful. For example, in this case
> if CONFIG_ACPI=n, the ID table left unused which is not what we want.
>
> Instead of adding ifdeffery here and there, drop ACPI_PTR() and
> replace acpi.h with mod_devicetable.h.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/gpio/gpio-mlxbf2.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/gpio/gpio-mlxbf2.c b/drivers/gpio/gpio-mlxbf2.c
> index 68c471c10fa4..c0aa622fef76 100644
> --- a/drivers/gpio/gpio-mlxbf2.c
> +++ b/drivers/gpio/gpio-mlxbf2.c
> @@ -1,6 +1,5 @@
>  // SPDX-License-Identifier: GPL-2.0
>
> -#include <linux/acpi.h>
>  #include <linux/bitfield.h>
>  #include <linux/bitops.h>
>  #include <linux/device.h>
> @@ -8,6 +7,7 @@
>  #include <linux/io.h>
>  #include <linux/ioport.h>
>  #include <linux/kernel.h>
> +#include <linux/mod_devicetable.h>
>  #include <linux/module.h>
>  #include <linux/platform_device.h>
>  #include <linux/pm.h>
> @@ -307,14 +307,14 @@ static SIMPLE_DEV_PM_OPS(mlxbf2_pm_ops, mlxbf2_gpio_suspend, mlxbf2_gpio_resume)
>
>  static const struct acpi_device_id __maybe_unused mlxbf2_gpio_acpi_match[] = {
>         { "MLNXBF22", 0 },
> -       {},
> +       {}

Ninja change :) I removed it - send a separate patch for this if you want to.

Bart

>  };
>  MODULE_DEVICE_TABLE(acpi, mlxbf2_gpio_acpi_match);
>
>  static struct platform_driver mlxbf2_gpio_driver = {
>         .driver = {
>                 .name = "mlxbf2_gpio",
> -               .acpi_match_table = ACPI_PTR(mlxbf2_gpio_acpi_match),
> +               .acpi_match_table = mlxbf2_gpio_acpi_match,
>                 .pm = &mlxbf2_pm_ops,
>         },
>         .probe    = mlxbf2_gpio_probe,
> --
> 2.30.2
>
