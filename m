Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4A3287A08
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 18:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730570AbgJHQfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 12:35:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:57234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726029AbgJHQfT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 12:35:19 -0400
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0103E221FE;
        Thu,  8 Oct 2020 16:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602174919;
        bh=Qlahj53lYVNiYg7AJ2rpRjvr+jIGD1GKJKKVML4NVdo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=JVjGIr/dcnN1xksiqNbG+5EbegsU/oIDX9jUBqAS8FdCiPm8u2/qWXBDB5A5SPFTI
         BT867zshbo4KKSkX6On8oFk14J9agHw/y0p3/tUCfKwANiGzETo77Iy2nIexDbM5qM
         XppPODIVfAmfdTX/Ba5zWmqqdjewjp/z+lEODdI8=
Received: by mail-ot1-f51.google.com with SMTP id f37so6007514otf.12;
        Thu, 08 Oct 2020 09:35:18 -0700 (PDT)
X-Gm-Message-State: AOAM5308ejA7VVCA00+mx+0sroV9fwEpwbzYWpWLV5uN5ahWHAnVE86b
        dUjU8i1XFHZM0WrdY7mp/KRXwgjhtFWTsRO6Xw==
X-Google-Smtp-Source: ABdhPJzz60BjsjQ+DWcXVfNZRYE1T6Qcp8v32Xy9DdbXcoosuL4xmpiD0xFSdwduI7ZjY+c1MvZxTW+StDleIYmrSl8=
X-Received: by 2002:a9d:1c90:: with SMTP id l16mr5952657ota.192.1602174918204;
 Thu, 08 Oct 2020 09:35:18 -0700 (PDT)
MIME-Version: 1.0
References: <20201008144706.8212-1-calvin.johnson@oss.nxp.com>
In-Reply-To: <20201008144706.8212-1-calvin.johnson@oss.nxp.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Thu, 8 Oct 2020 11:35:07 -0500
X-Gmail-Original-Message-ID: <CAL_JsqLf0UJNmx8OgpDye2zfFNZyJJ8gbr3nbmGyiMg81RoHOg@mail.gmail.com>
Message-ID: <CAL_JsqLf0UJNmx8OgpDye2zfFNZyJJ8gbr3nbmGyiMg81RoHOg@mail.gmail.com>
Subject: Re: [net-next PATCH v1] net: phy: Move of_mdio from drivers/of to drivers/net/mdio
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Grant Likely <grant.likely@arm.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "open list:ACPI FOR ARM64 (ACPI/arm64)" <linux-acpi@vger.kernel.org>,
        linux.cj@gmail.com, "David S. Miller" <davem@davemloft.net>,
        Frank Rowand <frowand.list@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 8, 2020 at 9:47 AM Calvin Johnson
<calvin.johnson@oss.nxp.com> wrote:
>
> Better place for of_mdio.c is drivers/net/mdio.
> Move of_mdio.c from drivers/of to drivers/net/mdio

One thing off my todo list. I'd started this ages ago[1].

>
> Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> ---
>
>  MAINTAINERS                        | 2 +-
>  drivers/net/mdio/Kconfig           | 8 ++++++++
>  drivers/net/mdio/Makefile          | 2 ++
>  drivers/{of => net/mdio}/of_mdio.c | 0
>  drivers/of/Kconfig                 | 7 -------
>  drivers/of/Makefile                | 1 -
>  6 files changed, 11 insertions(+), 9 deletions(-)
>  rename drivers/{of => net/mdio}/of_mdio.c (100%)

of_mdio.c is really a combination of mdio and phylib functions, so it
should be split up IMO. With that, I think you can get rid of
CONFIG_OF_MDIO. See my branch[1] for what I had in mind. But that can
be done after this if the net maintainers prefer.

Acked-by: Rob Herring <robh@kernel.org>

Rob

[1] git.kernel.org/pub/scm/linux/kernel/git/robh/linux.git dt/move-net
