Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 888F221BED4
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 22:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727810AbgGJU5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 16:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727046AbgGJU5N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 16:57:13 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C1D1C08C5DC;
        Fri, 10 Jul 2020 13:57:12 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id 207so3057637pfu.3;
        Fri, 10 Jul 2020 13:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qS4ZjkwObzTywSG9QLb9zrM+LvK/46w+HqrZ/Gl9rdI=;
        b=oV1X6a2MoMX6ArPbrsWwVMxXgS7sfrtoCdcIbI+HEagsfzesBS2CYjNOpYnq400ViS
         DvGYMe6xQfkGAlgRvQN+qaaRGHpTWCDiIq3iy/XzYGFZiBsN2nUXTD+OZKXI9BJUim2a
         fYCvt+5W2dQ88xqlPjQVyTcGnFIebp+87bQu7NxZfZ47Uf9vUflA2KlsJ5G8LH2LpYv/
         w2bO/2t4N/EX3zN14gYR/cWew9VkxGO6au+isNOfw7qOef/VgbQnTkEIo0+8X8AsLoYm
         WB7ALqltWZZOjFDFtg5Flo6YMuzPX5Qkq68ZxX3huGJm6dyV7/GZohRwaedRkC7A6L8F
         YKYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qS4ZjkwObzTywSG9QLb9zrM+LvK/46w+HqrZ/Gl9rdI=;
        b=KeRkphZTa3LRgYcbcRy/Ot+ixc3vt58s1SsNW1yAPu9B55CAxwSMMmOzsZI5jCuiVZ
         V4uAUrntI0dwf58M6KCY3oCNVkSbJggC8wDFOvbH0Lvk9AD993HxaSqznA2pBgpgS8GL
         mqM1ZcZi8rYFlH9VKVEToRkshJAz9C9HMewYcvGVW6KzFS8xv4MTSrC7VZJFtRWG66V4
         x7PX1QKH3shzqrbISQSsNK4taQ4bOjav5B9bVP4FUPl5k5Tr3ocuWjtBMAW3dRAetAkz
         xblBjxas2s+Rh2rp48MGkF/nu9uDw8pPwBxuitnKidGxn1x6VZMlB0KnM/vowmD0ALev
         RRpA==
X-Gm-Message-State: AOAM5335+g7ta7ZtVcz7G0Hjy99VWqW+d9FWQRJRoF5MXIASJ26mupu2
        Jj+Ygd5kCCXXmh+ij7r1LJGhCWdgPZSS/Jsh2A4=
X-Google-Smtp-Source: ABdhPJx05x8Iik0XjcnmK+i27f9mG3teVSS/Daltpam46AksJlXCzhz+bvMU5LPaXTRDCa9AgLYsAy2CVyyzIc2OQPM=
X-Received: by 2002:a63:924b:: with SMTP id s11mr58131257pgn.74.1594414631944;
 Fri, 10 Jul 2020 13:57:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200710163115.2740-1-calvin.johnson@oss.nxp.com> <20200710163115.2740-3-calvin.johnson@oss.nxp.com>
In-Reply-To: <20200710163115.2740-3-calvin.johnson@oss.nxp.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Fri, 10 Jul 2020 23:56:55 +0300
Message-ID: <CAHp75VdAykaFSSVprwHnVaeE6EcU5dMoS7vDiaHVFDQox-YhcQ@mail.gmail.com>
Subject: Re: [net-next PATCH v5 2/6] net: phy: introduce device_mdiobus_register()
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev <netdev@vger.kernel.org>, linux.cj@gmail.com,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 10, 2020 at 7:31 PM Calvin Johnson
<calvin.johnson@oss.nxp.com> wrote:
>
> Introduce device_mdiobus_register() to register mdiobus
> in cases of either DT or ACPI.

...

> +/**
> + * device_mdiobus_register - bring up all the PHYs on a given bus and
> + * attach them to bus. This handles both DT and ACPI methods.

I guess you can shrink this to fit one line.

> + * @bus: target mii_bus
> + * @dev: given MDIO device
> + *
> + * Description: Given an MDIO device and target mii bus, this function
> + * calls of_mdiobus_register() for DT node and mdiobus_register() in
> + * case of ACPI.
> + *
> + * Returns 0 on success or negative error code on failure.
> + */

> +int device_mdiobus_register(struct mii_bus *bus,
> +                           struct device *dev)

It's a bit strange to have a function in device_* namespace to take a
pointer to the struct device as not the first parameter...

-- 
With Best Regards,
Andy Shevchenko
