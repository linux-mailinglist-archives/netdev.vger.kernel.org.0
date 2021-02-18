Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C287931ED66
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 18:37:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230442AbhBRRhG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 12:37:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231178AbhBRPJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 10:09:24 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 756EBC06178C;
        Thu, 18 Feb 2021 07:08:22 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id z68so1336620pgz.0;
        Thu, 18 Feb 2021 07:08:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=egGZTevWS9XGPb3i0ABiHZIAsAw10Vof+gwW4ybtKxc=;
        b=iyWwNGi8FIEgpgnK1hUDSXo6IG2oL2TsczdBEdFtsBa7jDTG1BlBAK2fVaggR4MaX1
         JniomodCnubVGqED+0E7iEvBfSo7LPr9JgZidAJRdI7kOUJTZCojyYSU6kFBK1XZDugx
         xpAflkmZYkAaTXC9CtgxIUza54Cbl0YbmMAdAsHQ2haIqEg4U4rXjFZXuH8VaXJ1WLpS
         xWVitG1whZ4zqZ/ZOCzN9UoWp8B64a9BKPcREs65kgL6zwvf/Y4avz6c8cXTHkwBRm8u
         EWWJxq8URmFkDr6zu6C+JbsHW2aUJmJ5jHnvb+kxWf20wqoBzbE1AtkG9kH6Kb0puIdv
         PSPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=egGZTevWS9XGPb3i0ABiHZIAsAw10Vof+gwW4ybtKxc=;
        b=OzpauNDZFrjy1BboBg5uwZkZOst3s5dIUjVuJf++8yi9tgJPSpT3tMQxa4IDfOw8Kc
         Y5XtnaI9t8RC1yL9QUsDezR0qrYIXbt0210fikQrc7LqqwXgCcZRgKaCLUxGa2JEbU/l
         7DPvH8NGdallbebFd/qJBpEbrVzvsoeOlbGlrquf+ZiSUcL1szmsFBvArMA4cxqwZ+71
         HdL5zDcvX0Sx71dn6Zgvvx36y5uKFKHdTbd+8XPsCYHc7C5IxlMn+KEPOR4AdqEUInae
         Sj04+VJQScu4MONpi45HKEE6kCPFSfbDNsjSlEpJ7jEwZaDO9ZAy94xPMZwbBGEbYCn6
         DJtg==
X-Gm-Message-State: AOAM531eQRtp6LGonQw7i7rMaL4hUewbHbysHc8lfJ0g9x2XvGYLWYAS
        gW1ILa9wsdOKQ1LNcnd98g/afnP9qb1RqekbPRw=
X-Google-Smtp-Source: ABdhPJwzKmQIscP5gMyNk11NE+OeO6zQZ+P+DxHQqm4nhVMVX9j973HwWzfReya7dq9I/BjChToqhmmtsF+tOC9vqmI=
X-Received: by 2002:a65:4c08:: with SMTP id u8mr4291801pgq.203.1613660901928;
 Thu, 18 Feb 2021 07:08:21 -0800 (PST)
MIME-Version: 1.0
References: <20210218052654.28995-1-calvin.johnson@oss.nxp.com> <20210218052654.28995-11-calvin.johnson@oss.nxp.com>
In-Reply-To: <20210218052654.28995-11-calvin.johnson@oss.nxp.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Thu, 18 Feb 2021 17:08:05 +0200
Message-ID: <CAHp75VdpvTN2R-FTb81GnwvAr_eoprEhsOMx+akukaDNBrptsQ@mail.gmail.com>
Subject: Re: [net-next PATCH v6 10/15] net: mdio: Add ACPI support code for mdio
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
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        "linux.cj" <linux.cj@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 18, 2021 at 7:28 AM Calvin Johnson
<calvin.johnson@oss.nxp.com> wrote:
>
> Define acpi_mdiobus_register() to Register mii_bus and create PHYs for
> each ACPI child node.

> +#include <linux/acpi.h>
> +#include <linux/acpi_mdio.h>

Perhaps it's better to provide the headers that this file is direct
user of, i.e.
 bits.h
 dev_printk.h
 module.h
 types.h

The rest seems fine because they are guaranteed to be included by
acpi.h (IIUC about fwnode API and acpi_mdio includes MDIO PHY APIs).

-- 
With Best Regards,
Andy Shevchenko
