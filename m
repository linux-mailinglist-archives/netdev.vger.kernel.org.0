Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3312C2F34B6
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 16:56:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392178AbhALPxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 10:53:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392159AbhALPxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 10:53:15 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 355DAC061786;
        Tue, 12 Jan 2021 07:52:35 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id x126so1614013pfc.7;
        Tue, 12 Jan 2021 07:52:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gciEYdT5bU0X4z3JG405rhx90B8Cd29rx/iFRAfS3gk=;
        b=Tteos1v/nBr2QR4P8Mww8H/eZO+S5qnMDvL5M3qzz/A7wnSCWfaOG2z7wGn3vRkYJP
         rSmxdZxbm4y833lwaUvszN4o1gYK1RT3/ynFR1mpR29aREKa1mQM8cFjdMmT3iUEI95q
         ehf35GKVLmaRP7vqrLb7emFTbtJcsRz0qIGDLsshs47uHdB6ZgxCYA9lO9iLTgZuWxb/
         rfZxaUgxq0gXtXARunrT/OdXQ+0BDz0ml7a9kQF8GwD0xtkK1/2a0N7KWmLjhEb3jSKT
         ghcq/UUSQiffopaBZNJmbgPDpl8QO3xMYSnUr09Bome92ZZ3bEM/l6ex4WRKbyPswn5b
         t5GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gciEYdT5bU0X4z3JG405rhx90B8Cd29rx/iFRAfS3gk=;
        b=lxz4u1UDOsNc+kSQc61lX4ndiM1PPsbBwsbz33pT+DdCl/psCuRTW1kRJs12+fvbEu
         UtHx1fjPohMzlqy1jXXKrOT2Fja/2JhK9US1VDew0QFgM79LjUgYSpUOrFDoNMDrY+Sh
         Ozd0pMfbCXW9kUCHGhyfco6IZZDyfAm5Ikw/LLK/jq+QOrlpVbe+AOnsJ4m5V4cvobTi
         Uqw0Pi2MF+B2Wgn34J150WYJN4CPQfxGEwxfDTa6bgpNFmDahAaXHhvc6dNXoLweJ8Op
         QbPZqD8kkMRgkj8adFOJh0Bsq833e1PIJQhbWQCiCkitLOc12ZVNzIMsDBprxh0VkfJK
         YNag==
X-Gm-Message-State: AOAM532Kc68YeQbcNj9j5Jg1dmx6vwufK9OhlM+IQpcdcLva8lu1mCXC
        wKEm0RqzHRMzrhFAFoB7uvOHOoZvyFGpPayi7Bs=
X-Google-Smtp-Source: ABdhPJyu8jUiBN9VlIBHicTYwakjm+TJGHd5z9oVSX275+BV7Dci+4Q+zbCS4Y22tA45a4s8y0iIWtRqwRa73m1IYHo=
X-Received: by 2002:a63:4b16:: with SMTP id y22mr5371171pga.203.1610466754738;
 Tue, 12 Jan 2021 07:52:34 -0800 (PST)
MIME-Version: 1.0
References: <20210112134054.342-1-calvin.johnson@oss.nxp.com> <20210112134054.342-13-calvin.johnson@oss.nxp.com>
In-Reply-To: <20210112134054.342-13-calvin.johnson@oss.nxp.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 12 Jan 2021 17:53:23 +0200
Message-ID: <CAHp75VcQos=1aWM_A7xbyHi_Kqbga=1dB17ET+0ezsGMs+GM6A@mail.gmail.com>
Subject: Re: [net-next PATCH v3 12/15] net/fsl: Use fwnode_mdiobus_register()
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux.cj" <linux.cj@gmail.com>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamie Iles <jamie@nuviainc.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 3:43 PM Calvin Johnson
<calvin.johnson@oss.nxp.com> wrote:
>
> fwnode_mdiobus_register() internally takes care of both DT
> and ACPI cases to register mdiobus. Replace existing
> of_mdiobus_register() with fwnode_mdiobus_register().
>
> Note: For both ACPI and DT cases, endianness of MDIO controller
> need to be specified using "little-endian" property.


> +       /* For both ACPI and DT cases, endianness of MDIO controller
> +        *  need to be specified using "little-endian" property.

needs

> +        */

...

>         priv->has_a011043 = device_property_read_bool(&pdev->dev,
>                                                       "fsl,erratum-a011043");
> -

Unrelated change.

-- 
With Best Regards,
Andy Shevchenko
