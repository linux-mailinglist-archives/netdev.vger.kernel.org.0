Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D435A313918
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 17:18:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234296AbhBHQRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 11:17:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231283AbhBHQRV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 11:17:21 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0CCDC061786;
        Mon,  8 Feb 2021 08:16:41 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id m6so10033487pfk.1;
        Mon, 08 Feb 2021 08:16:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WsJCNxoOgawUj7Zr3PeZyr3znV20VI9UZXxnXDXzdvs=;
        b=U0OD2796M2UhURPNe4IChEOVyT/iAmYNvaDyk30Rqz9ncMVbwvASefx+TLV/Lqbunw
         1KmGPVpqLXajRiDDHRTcb83gUCO+FNJpH2utz+SZQ99OCaeaSKzVV+k5/Pz/k2IfLhf5
         H19aU9TDyuwDC6TbDu4CnhjufcmNEeSzAC9H24HORJMfbQBGIboVlee0FLAjMLd9Aukp
         vGmMl69XEdRIU5pv8JrxtaOM2nhzLrrDuUtCYtT7P17JcGYG1IDvySaQEvDIsGRujrbg
         wJdw0tPeC89VzCLkD1RB+YMSlwEdeSrmlLJM2jTad4KdtZunXpyl4+il47IFIV3EBLBV
         0qMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WsJCNxoOgawUj7Zr3PeZyr3znV20VI9UZXxnXDXzdvs=;
        b=FLY1JLwbHOWtAsWWT07QQR3mtZMmMCIMaqU0kLB6lTNW57LPni+lAHpxaNTB2/igUB
         lhc793WjaBtYT2XQTRVSYWYAMSrivcSWMzfH37nmLSNg2jaWoTuW/fsB1yb4fhYhAw6n
         gdn5afiXbRCOMc8ArY8nNM4vhSQiKkt+HMcCfLq6OfwoYuNtQ0nxo7n2jnYmf7EN48Wq
         AX1uoGdGkMIocIPOUi5pbvQloZdyheaxHj478pOvrcHh19YqjUgn9JGb8CdGB7PoM3ny
         k65LQZFfKkq1b+kdK5ZcbzwH9cBfsM++1eufmpoKWYIN70MepqG5eUUy0avnitIogbrh
         M+0A==
X-Gm-Message-State: AOAM530yt7gEj+wuvcnFiGwQ4zmai5sYN3QL0/1rzEahhO+LhJMckrc3
        EduzwSecdFpBf02uEcOFthkzp65KAE5K7Q/2Eto=
X-Google-Smtp-Source: ABdhPJw19SlZGykBCKiYzgNJdxkHEeiF9SWOqGXarLbhcReCBD7gKOEt8vefovgT+spNPLLK3TJjhbkGCYx15o14r9Y=
X-Received: by 2002:a62:445:0:b029:19c:162b:bbef with SMTP id
 66-20020a6204450000b029019c162bbbefmr19016500pfe.40.1612801001178; Mon, 08
 Feb 2021 08:16:41 -0800 (PST)
MIME-Version: 1.0
References: <20210208151244.16338-1-calvin.johnson@oss.nxp.com> <20210208151244.16338-11-calvin.johnson@oss.nxp.com>
In-Reply-To: <20210208151244.16338-11-calvin.johnson@oss.nxp.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 8 Feb 2021 18:16:24 +0200
Message-ID: <CAHp75Vf5Tdr=e=fU==EsXv08h7uyAu6Sw8poQgrRUYtvVSM5zQ@mail.gmail.com>
Subject: Re: [net-next PATCH v5 10/15] net: mdio: Add ACPI support code for mdio
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
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux.cj" <linux.cj@gmail.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 8, 2021 at 5:14 PM Calvin Johnson
<calvin.johnson@oss.nxp.com> wrote:
>
> Define acpi_mdiobus_register() to Register mii_bus and create PHYs for
> each ACPI child node.

...

> +/**
> + * acpi_mdiobus_register - Register mii_bus and create PHYs from the ACPI ASL.

> + *

Redundant blank line.

> + * @mdio: pointer to mii_bus structure
> + * @fwnode: pointer to fwnode of MDIO bus.
> + *
> + * This function registers the mii_bus structure and registers a phy_device
> + * for each child node of @fwnode.
> + */
> +int acpi_mdiobus_register(struct mii_bus *mdio, struct fwnode_handle *fwnode)
> +{
> +       struct fwnode_handle *child;
> +       u32 addr;
> +       int ret;
> +
> +       /* Mask out all PHYs from auto probing. */

> +       mdio->phy_mask = ~0;

I would rather see GENMASK(31, 0) here because in case the type of the
variable is changed we will need to amend this anyway.

> +       ret = mdiobus_register(mdio);
> +       if (ret)
> +               return ret;

> +       mdio->dev.fwnode = fwnode;

Shouldn't it be rather ACPI_SET_COMPANION() as other bus / drivers do?

> +/* Loop over the child nodes and register a phy_device for each PHY */

Indentation.

> +       fwnode_for_each_child_node(fwnode, child) {
> +               ret = acpi_get_local_address(ACPI_HANDLE_FWNODE(child), &addr);

> +               if ((ret) || addr >= PHY_MAX_ADDR)

Too many parentheses.

> +                       continue;
> +
> +               ret = fwnode_mdiobus_register_phy(mdio, child, addr);
> +               if (ret == -ENODEV)
> +                       dev_err(&mdio->dev,
> +                               "MDIO device at address %d is missing.\n",
> +                               addr);
> +       }
> +       return 0;
> +}

...

> +/*
> + * ACPI helpers for the MDIO (Ethernet PHY) API
> + *
> + */

It's one line AFAICT!

...

> +#include <linux/device.h>
> +#include <linux/phy.h>

This seems a bit inconsistent with the below.
I see the user of mdiobus_register(). It's the only header should be
included. Everything else would be forward declared like

struct fwnode_handle;

> +#if IS_ENABLED(CONFIG_ACPI_MDIO)
> +int acpi_mdiobus_register(struct mii_bus *mdio, struct fwnode_handle *fwnode);
> +#else /* CONFIG_ACPI_MDIO */
> +static inline int acpi_mdiobus_register(struct mii_bus *mdio, struct fwnode_handle *fwnode)
> +{
> +       /*
> +        * Fall back to mdiobus_register() function to register a bus.
> +        * This way, we don't have to keep compat bits around in drivers.
> +        */
> +
> +       return mdiobus_register(mdio);
> +}
> +#endif


-- 
With Best Regards,
Andy Shevchenko
