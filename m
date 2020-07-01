Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84AA8210987
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 12:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730017AbgGAKiM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 06:38:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729180AbgGAKiM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 06:38:12 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BF3FC061755;
        Wed,  1 Jul 2020 03:38:12 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id k5so1292816pjg.3;
        Wed, 01 Jul 2020 03:38:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ay25oY07NOmbixOtBMWVYmhszlZHF/YFooJn+9Ipub8=;
        b=E3KJ5G+nJ16g2CKalAuxGYpIOXxRdvvUoZBAYhyZdpv1+IRV/XdKVlrlD/ncMJRTlM
         DQ72k5hr87hRV6RXLAwuL0790w3F/9VpHdyKak8P3gAr4vL0bnnvRfkHCl153pcBlZlT
         b949Mmca2xjQ1NN6hqPGbAhdfzdioAVYoI7N8sWwqjUZKIjBX++yC14jJWEJapL25zIg
         JV+HaXJ6VCDCO46HoGxHHd3AEAaMEQgvQ19V4JAKlCR0Yl2BH0JMq5i3Xp9kRdJQllZz
         0Qa/D+Lit+3fpJeSg7DP9T5mpOAmjziidgetbF6OK0weRP6/2PZ02EEZ9Qn96+dWXfO0
         pY5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ay25oY07NOmbixOtBMWVYmhszlZHF/YFooJn+9Ipub8=;
        b=WajHG/pkmYpDNAsT10bBQ3pI2lNAxKiHh3wWYCiLwcq/FmZ0V1DTGcjK7pdcL+e5zj
         8Fk4N/zfPEtX+eHEt++1sFAQKzOAGlhnmzJzRfcEqRKZjYx7GViCXeiY0V0VnpLHO67K
         4Nv4wuJQzc1XMN7iKCHcMZiShhSRCp5PZvRkYcA0fNMTjXrV9ohIff/E3xCDnWt5HqQM
         BcZyps9ciAnCkC6QYtND83TpTYVwUW8UFlaT6fT2ZmvX+v8FutRpl4PI+NGVVAZymNiD
         /GMk9DV/UMObCJc90dOBTDIzHR/PJC0V56g91P6hxViSdLTG2X7OZbQ6fxqhImR/G6ef
         IYeQ==
X-Gm-Message-State: AOAM531j0eM1EdFDkTqwAqu6ZO2wRpQwX8AzGGOZ3U+2MXTxa1tMC+jT
        j5wsWo4LK9YDqGqQp6Nn7a7ThCZfGG/jgTh3XwqOKJ7Zr9g=
X-Google-Smtp-Source: ABdhPJy7/D67hf5+MecXjYgpK9V7/RtGhKxzUBqStKpQiE9aKsQkiguOqWHY1pYzUUFZFqZ4rfpaxiOcOPlMiEWsdRQ=
X-Received: by 2002:a17:90a:a393:: with SMTP id x19mr490320pjp.228.1593599891781;
 Wed, 01 Jul 2020 03:38:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200701061233.31120-1-calvin.johnson@oss.nxp.com> <20200701061233.31120-4-calvin.johnson@oss.nxp.com>
In-Reply-To: <20200701061233.31120-4-calvin.johnson@oss.nxp.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Wed, 1 Jul 2020 13:37:58 +0300
Message-ID: <CAHp75VdMdefZpRh5hE0pWTAYoA-VJepTCrCHD-MYZa9P_aqk6w@mail.gmail.com>
Subject: Re: [net-next PATCH v2 3/3] net: dpaa2-mac: Add ACPI support for
 DPAA2 MAC driver
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev <netdev@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux.cj@gmail.com, "David S. Miller" <davem@davemloft.net>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 1, 2020 at 9:13 AM Calvin Johnson
<calvin.johnson@oss.nxp.com> wrote:
>
> Modify dpaa2_mac_connect() to support ACPI along with DT.
> Modify dpaa2_mac_get_node() to get the dpmac fwnode from either
> DT or ACPI.
> Replace of_get_phy_mode with fwnode_get_phy_mode to get
> phy-mode for a dpmac_node.
> Define and use helper function find_phy_device() to find phy_dev
> that is later connected to mac->phylink.

...

>  #include "dpaa2-eth.h"
>  #include "dpaa2-mac.h"

> +#include <linux/acpi.h>
> +#include <linux/platform_device.h>

Can we put (more) generic headers atop of (more) private ones?

...

> +       struct fwnode_handle *fsl_mc_fwnode = dev->parent->parent->fwnode;

dev_fwnode() please.

> +       struct fwnode_handle *dpmacs, *dpmac = NULL;
> +       struct device *fsl_mc = dev->parent->parent;

So. something like
       struct device *fsl_mc = dev->parent->parent;
       struct fwnode_handle *fsl_mc_fwnode = dev_fwnode(fsl_mc);

...

> +               dpmacs = device_get_named_child_node(fsl_mc, "dpmacs");

If you have fwnode, why to use device_* API?
               dpmacs = fwnode_get_named_child_node(fsl_mc_fwnode, "dpmacs");

> +               if (!dpmacs)
> +                       return NULL;
> +
> +               while ((dpmac = fwnode_get_next_child_node(dpmacs, dpmac))) {
> +                       err = fwnode_property_read_u32(dpmac, "reg", &id);
> +                       if (err)
> +                               continue;
> +                       if (id == dpmac_id)
> +                               return dpmac;
> +               }

...

> +       } else if (is_acpi_node(fsl_mc_fwnode)) {

is_acpi_device_node() ?

> +               adev = acpi_find_child_device(ACPI_COMPANION(dev->parent),
> +                                             dpmac_id, false);
> +               if (adev)

> +                       return (&adev->fwnode);

No need to have parentheses. Don't we have some special macro to get
fwnode out of ACPI device?

...

> +       err = fwnode_get_phy_mode(dpmac_node);
> +       if (err > 0)
> +               return err;

Positive?! Why? What's going on here?

...

> +       if (is_of_node(dpmac_node))
> +               err = phylink_of_phy_connect(mac->phylink,
> +                                            to_of_node(dpmac_node), 0);
> +       else if (is_acpi_node(dpmac_node)) {
> +               phy_dev = find_phy_device(dpmac_node);
> +               if (IS_ERR(phy_dev))
> +                       goto err_phylink_destroy;
> +               err = phylink_connect_phy(mac->phylink, phy_dev);

Can't you rather provide phylink_fwnode_connect_phy API and drop this
conditional tree entirely?

...

> +       if (is_of_node(dpmac_node))

Redundant.

> +               of_node_put(to_of_node(dpmac_node));

Honestly, looking at this code, I think one needs a bit more time to
get into fwnode paradigm and APIs.

...

> +       if (is_of_node(dpmac_node))

Ditto.

> +               of_node_put(to_of_node(dpmac_node));

-- 
With Best Regards,
Andy Shevchenko
