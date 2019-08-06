Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B21FD83A1B
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 22:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbfHFUOL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 16:14:11 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:39971 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbfHFUOL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 16:14:11 -0400
Received: by mail-oi1-f194.google.com with SMTP id w196so47160815oie.7;
        Tue, 06 Aug 2019 13:14:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DHPLsakTg1F9PtegMLuUGuWnfD3D92bcDfRxNDjqJI4=;
        b=k8lxIrEwMdAN3Wz6Y91EdQtfNt6sY0pqfBSAdqSvEzioqIOdX2BHS9WAp37OFMe8VC
         3DDmsgXtIP2U5GVRbF6C0SwdLYAY7Q0PtWLJRi72ukPxIDwY93uptRkBPV+R+vw+SxCr
         3ZO6rdzbJbR3aNRIn9OkujG2f/Map30fxD0yQU/QUESsylr+TWLQNrivWc7mfV11RwQd
         62BcPfSxpEsd5Hm0yLW6XFPp4qzAIYQ6qc42vFvr3XINFlv/vvLwLreEcOYBkXEKT5Hz
         A3pR5L0+wLEVOBQF444i1ErkjW/CROHv2Uj5nNJnm1xXPrXgkDpYZcJlzK+GT2CXp97p
         ArdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DHPLsakTg1F9PtegMLuUGuWnfD3D92bcDfRxNDjqJI4=;
        b=chEPfoas9U0xqup49GJTdKNJsEXCj22uwc3pOaTEm8AOkJx1889zAzI1P0Jst0CPAO
         +mB8V0APhBm9Q+xyd84wUCxiuGtiFrhlpjVD6oflcNFVFgWXvLPkBAlCH7VNDw6uAacz
         M07963IRFi/iUplOqkIvWHwVDc6sQghLNElhCCDzalcli22uxBIZxFt/nnUZcr69WQLg
         iKz2oLidfHxiioPf9D2oZGy8zYorFok15A06w37oWTsQDMCjBK+lXnqin4fPxtD/hjvW
         MGhrpneuzjQlep6EkdWoaTd/OZkZ7nTAGbV5nGbhOrfleZwbDvB5a4nkcvYsC+wCDvnT
         r92w==
X-Gm-Message-State: APjAAAUxtBbbhKixiL7n6rzA0Td64oHGkO6jXSHq3oiVPQE/N6CY6RTy
        8nnIAzjU2TZ6MmS9TECE9ENiEpb7IQCzjJ/FUMM=
X-Google-Smtp-Source: APXvYqzpsRU4U1y4gTKmBv9/Rt7TEBY/Ggbjy+Jkbq/7IroTE6LpnfiJJQOcHRvZJijSwJPaBPod6NihIbdweNp8v7s=
X-Received: by 2002:a02:ca19:: with SMTP id i25mr6227780jak.6.1565122449379;
 Tue, 06 Aug 2019 13:14:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190731195713.3150463-1-arnd@arndb.de> <20190731195713.3150463-9-arnd@arndb.de>
In-Reply-To: <20190731195713.3150463-9-arnd@arndb.de>
From:   Sylvain Lemieux <slemieux.tyco@gmail.com>
Date:   Tue, 6 Aug 2019 16:13:58 -0400
Message-ID: <CA+rxa6ovZ+ghiHyGQXepx0pEo465WHEP3TJq+dcnZyx2weE0uw@mail.gmail.com>
Subject: Re: [PATCH 08/14] net: lpc-enet: allow compile testing
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     soc@kernel.org,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Guenter Roeck <linux@roeck-us.net>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        linux-serial@vger.kernel.org, USB list <linux-usb@vger.kernel.org>,
        LINUXWATCHDOG <linux-watchdog@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Acked-by: Sylvain Lemieux <slemieux.tyco@gmail.com>

On Wed, Jul 31, 2019 at 4:01 PM Arnd Bergmann <arnd@arndb.de> wrote:
>
> The lpc-enet driver can now be built on all platforms, so
> allow compile testing as well.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/net/ethernet/nxp/Kconfig   | 2 +-
>  drivers/net/ethernet/nxp/lpc_eth.c | 1 +
>  2 files changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/nxp/Kconfig b/drivers/net/ethernet/nxp/Kconfig
> index 261f107e2be0..418afb84c84b 100644
> --- a/drivers/net/ethernet/nxp/Kconfig
> +++ b/drivers/net/ethernet/nxp/Kconfig
> @@ -1,7 +1,7 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  config LPC_ENET
>          tristate "NXP ethernet MAC on LPC devices"
> -        depends on ARCH_LPC32XX
> +        depends on ARCH_LPC32XX || COMPILE_TEST
>          select PHYLIB
>          help
>           Say Y or M here if you want to use the NXP ethernet MAC included on
> diff --git a/drivers/net/ethernet/nxp/lpc_eth.c b/drivers/net/ethernet/nxp/lpc_eth.c
> index 0893b77c385d..34fdf2100772 100644
> --- a/drivers/net/ethernet/nxp/lpc_eth.c
> +++ b/drivers/net/ethernet/nxp/lpc_eth.c
> @@ -14,6 +14,7 @@
>  #include <linux/crc32.h>
>  #include <linux/etherdevice.h>
>  #include <linux/module.h>
> +#include <linux/of.h>
>  #include <linux/of_net.h>
>  #include <linux/phy.h>
>  #include <linux/platform_device.h>
> --
> 2.20.0
>
