Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 202C62190E9
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 21:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgGHTmV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 15:42:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbgGHTmU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 15:42:20 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC870C061A0B;
        Wed,  8 Jul 2020 12:42:20 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id d194so18785396pga.13;
        Wed, 08 Jul 2020 12:42:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7G6ltnJN94V5vFco4LVG4XJeVPwmY/sgRzhDSq0hmSM=;
        b=CBVChNL8SeoesTmrNwCj1CJczMw9dZnf0WyTEsmUH5uSRSQEA457tGStj7Rqg3vy3C
         Jwu7teDNr9avBPOwVACWgZhAn+/BAqkYHqRCMbHAtoniUr62GkBa3EPSsl4Ot593Vcpi
         QKy1H7MjM6+oPCFgbzFdRvyrCDTZxxy/jUtxlXr/Eats87/l+Eqh/ib3IyiHpMTlkja9
         SP3+ax5cmUocaRXIhFvjiKJN88152AE1tIRu/2rg+0WeIvjlZMIosu3Bwy3GfAqy4GWO
         /r3Nh/AOHzEr2ZchPJj6+f1RE26ttITzTwSQGXWMI61MmxBSLYdsi33YgKtX/MNrxwJO
         FuIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7G6ltnJN94V5vFco4LVG4XJeVPwmY/sgRzhDSq0hmSM=;
        b=Z8GdFljEP6QaS0P27L+QUtHsT8QCe/SKAXRzE06H1lE9kTcWg0d5eKHfbs2RJPtvi9
         55X1BKbkatKXus3sqxyBnoesYYYPQ5A7JcsOj3MZeiL2rGYTRvK4Xh776aS7Hq2IWz7J
         A49WYmk8ISuJOvr91CNdUWDeYC5HcheGq837DQ2WSTYz0YBF7vIe35T+PtGXpsLYcAML
         CQS38PS0+txp34lBfs6mR4sezAzoKaVkyo291ud1Y2OLhztdbumHd5TzNL3jYVNbA+m0
         p5DNji4noodwryagFCEOfda5F+rX5WVUUJWGSNvmUIMzjuNu8e1BgJNL/NfdBdJ+5bY6
         PdcQ==
X-Gm-Message-State: AOAM533L9pSv6/kv4Dzp0f61PMXMn570j+31/kMrtw3R53Ndv5++eHoP
        gNVPp+aTSYmv9MUiXGBZ4+9oI3nFBqrcOYDyKno=
X-Google-Smtp-Source: ABdhPJzbYIQ8iQ2iLlWYW3vwdC1mmBXa82AUFn/616J+D0YWLZFNacN4CnBVDsN9DefXTh16fr5do6OTFq+zb29tihI=
X-Received: by 2002:a05:6a00:790:: with SMTP id g16mr19309617pfu.36.1594237340372;
 Wed, 08 Jul 2020 12:42:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200708173435.16256-1-calvin.johnson@oss.nxp.com> <20200708173435.16256-4-calvin.johnson@oss.nxp.com>
In-Reply-To: <20200708173435.16256-4-calvin.johnson@oss.nxp.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Wed, 8 Jul 2020 22:42:04 +0300
Message-ID: <CAHp75Vd05RCbuVF8rtWjZnaDxSG+X+uQ=wLWYwy_g=jFZfHGSQ@mail.gmail.com>
Subject: Re: [net-next PATCH v3 3/5] net: phy: introduce phy_find_by_fwnode()
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>, linux.cj@gmail.com,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 8, 2020 at 8:35 PM Calvin Johnson
<calvin.johnson@oss.nxp.com> wrote:
>
> The PHYs on an mdiobus are probed and registered using mdiobus_register().
> Later, for connecting these PHYs to MAC, the PHYs registered on the
> mdiobus have to be referenced.
>
> For each MAC node, a property "mdio-handle" is used to reference the
> MDIO bus on which the PHYs are registered. On getting hold of the MDIO
> bus, use phy_find_by_fwnode() to get the PHY connected to the MAC.
>
> Introduce fwnode_mdio_find_bus() to find the mii_bus that corresponds
> to given mii_bus fwnode.

...

> +       err = fwnode_property_read_u32(fwnode, "phy-channel", &addr);
> +       if (err < 0 || addr < 0 || addr >= PHY_MAX_ADDR)
> +               return NULL;

Just wondering if we can return an error pointer here (sorry if it has
been discussed already).

-- 
With Best Regards,
Andy Shevchenko
