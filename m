Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC9E21A92F
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 22:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbgGIUkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 16:40:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbgGIUkD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 16:40:03 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC9F2C08C5CE;
        Thu,  9 Jul 2020 13:40:02 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id x8so1288724plm.10;
        Thu, 09 Jul 2020 13:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zsLFybUGGIgPbdLOEHhXPQsq8PVkisgYSob/yyFgUNU=;
        b=OqwbJFcNSClNaXep8pziE1fSmv+7xBYw80lpZWFEyItN7BZffnth3SBXoDASsqx4hi
         R1i6BQMEouhNJoAx7B3nWo0y5CSsYR3/AHPvQUwpHeSMmCMvp2P75fsoBzAhDcGkn6m/
         uwhSH3Ea2n4g0qA50HnVhSKdpK3N08oMg8FUVAoC+2OJQpGdoo7JAcF708LMVE8BwdLJ
         thCdRneS5Xp2dHJJEy20tXaiopHD2tHGN+6TecMsNVPlLqzVcQf8wGITSSD/j5xElrbz
         6wdTe52wmvImJCw8PnU8RtJBlOAvKyt0t080t779cjhZRoxQ1V4t8ThC6DGAkrT4xH7w
         IZ1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zsLFybUGGIgPbdLOEHhXPQsq8PVkisgYSob/yyFgUNU=;
        b=IhFffOvh/fRQVFZCZyJdrQkY9VX5sZDOBgdCPG03+3ifjiXvOvcftKaPjt+XitlScY
         m1y+wWgHKTzyuSNqPYXm1plg4DlHaNWY03nHYfcxCWo/APnU2K/EtJLF6P5jXF5Aq42P
         6/l1IG68mubysYbV3Fm26Bs3y7wUwB3ZS9QOAFOHq7GcHjPBTamwUGbRg15c56bQYS+j
         L5TR1DgPvtCigCE4fW66RP1T75ZqOeMDrvyZQHhQT6CAWdDx/9YksDLtvt1ak9ckSTKF
         hXy1xsiNhQfif2ZYUd6mb4wXep60PdpsYdObXC3aNApTBzmhTp8fnaVrqK/0g8RIrpng
         lCgw==
X-Gm-Message-State: AOAM533ztV1tNXqr/HdRy2MeQoIhGoKlUhGtsW7WZnciJjP2zoR7BlxD
        IpeSnHzGgocuAhpwGl5vYNhvfZhMD3wxu+VJ/vE=
X-Google-Smtp-Source: ABdhPJxTTn5vyPfkfSyKFbput/U6oc2/AYXh4m6oBigKpyYfqmyKgEARUGV7nPdqDCwblHzPbjY85ZbO+1Tmiyoz2ag=
X-Received: by 2002:a17:90a:a393:: with SMTP id x19mr2023623pjp.228.1594327202505;
 Thu, 09 Jul 2020 13:40:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200709175722.5228-1-calvin.johnson@oss.nxp.com> <20200709175722.5228-3-calvin.johnson@oss.nxp.com>
In-Reply-To: <20200709175722.5228-3-calvin.johnson@oss.nxp.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Thu, 9 Jul 2020 23:39:46 +0300
Message-ID: <CAHp75VdF8HjvbD0Nm6T-7m2f2LVPU5yaFzn=1Pjyubuw4UVAOA@mail.gmail.com>
Subject: Re: [net-next PATCH v4 2/6] net: phy: introduce device_mdiobus_register()
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux.cj@gmail.com, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 9, 2020 at 8:57 PM Calvin Johnson
<calvin.johnson@oss.nxp.com> wrote:
>
> Introduce device_mdiobus_register() to register mdiobus
> in cases of either DT or ACPI.

...

> +/**
> + * device_mdiobus_register - bring up all the PHYs on a given bus and
> + * attach them to bus. This handles both DT and ACPI methods.

This is usually one line summary and description goes...

> + * @bus: target mii_bus
> + * @dev: given MDIO device
> + *

...somewhere here.

> + * Returns 0 on success or < 0 on error.

This would be nicer to read as '...or negative error code' or alike.

> + */
> +int device_mdiobus_register(struct mii_bus *bus,
> +                           struct device *dev)
> +{

> +       if (dev->of_node) {
> +               return of_mdiobus_register(bus, dev->of_node);
> +       } else if (dev_fwnode(dev)) {
> +               bus->dev.fwnode = dev_fwnode(dev);
> +               return mdiobus_register(bus);

All these 'else' are redundant, but the main confusion here is the use
of dev_fwnode() vs. dev->of_node.

I would rather see something like

struct fwnode_handle *fwnode = dev_fwnode(dev);
...

if (is_of_node(fwnode))
  return ...(..., to_of_node(fwnode));
if (fwnode) {
  ...
  return ...
}
return -ENODEV;

(Okay, 'else':s may be left if you think it's better to read)

> +       } else {
> +               return -ENODEV;
> +       }
> +}

-- 
With Best Regards,
Andy Shevchenko
