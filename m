Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF95C2DB27A
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 18:26:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730696AbgLORYR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 12:24:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730108AbgLORXX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 12:23:23 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49C2DC06179C;
        Tue, 15 Dec 2020 09:22:38 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id x126so6085557pfc.7;
        Tue, 15 Dec 2020 09:22:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XeL1JU3AOBCtCTm27JOBPqHW8xm0HoyApoO+BoICFoU=;
        b=hCYCkhMNCb5c3Qi3sKAbtkY2DbxHCykfyTbKzsCqY5VYCDSmlW+kTMmwb878sI9X97
         rMZ9VPVySFSYLuA6YFIcpva7mc2MFXvfhugMjJ6u3dQ5S20eSaKHz+APO6Z3RNT4yNP1
         I1iidbRLw+YB6yz3uBa2VBYmJXraUtSsXrYpl18x2XZooy+qoKHjw4tAbm8RmfOyRXzQ
         mqOjjH//0w393EOzIrpysg0fKc42k2znubj7LmaTaAuAaILFoC1vjtpZXYfCR57AlGbr
         CkxP9+jYvDwYK1dP2VYrZob51LKwF/jWxD5+muO4AhKWmFnfgL2d3y9yjyt2WReMRCLY
         lCcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XeL1JU3AOBCtCTm27JOBPqHW8xm0HoyApoO+BoICFoU=;
        b=ENZVn2wMRZ8xNaWzzU0k4vLBz0Y+mJsjbbscV0ixmoqkwoAGLKMLJdA8fEJiATsy7u
         TZYLacJ4oWcbCJiaP+pKQzjbQK4LbkYqBhtfa0mphNCOU7/OH9iuk3YF6oZauApohbZC
         vslcYQVPvhsZooUIfdCnv/Lqh6ndHi3M3nXo8BdRiNyqC7l5Law/NrORhrIRTY9ByaRQ
         /07AMTDmnnhcx+l1aT708cTAXYCePZMdoDbwsvQlVj4q7ucy4fyHTtApTWNuzfU3VzSE
         ij4yRTef8hTFMRpg1lNETmyIIiTCgnhUEzUp9/fGZficCDEaCk9Y60bHdtXq+GUA5hD1
         QFOg==
X-Gm-Message-State: AOAM532mpWm8a0Ds85haQ4l/cXQWPdzTqrqOozkTQwJ0m3vY94t/O3j6
        Whqv+5HR0G35UYCdltPOHYZ/EPIeMNI3c0kJHfM=
X-Google-Smtp-Source: ABdhPJzAWxA90vOEnW9Jvu3V713OGXuisuahkkplOJRTeWCZgFKbHKGm9p5UyRsIqwDva3Ofpyg//nIwK1PiM+hdpuo=
X-Received: by 2002:a63:74b:: with SMTP id 72mr2438639pgh.4.1608052957796;
 Tue, 15 Dec 2020 09:22:37 -0800 (PST)
MIME-Version: 1.0
References: <20201215164315.3666-1-calvin.johnson@oss.nxp.com> <20201215164315.3666-3-calvin.johnson@oss.nxp.com>
In-Reply-To: <20201215164315.3666-3-calvin.johnson@oss.nxp.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 15 Dec 2020 19:23:26 +0200
Message-ID: <CAHp75VeJc6jXAi9LV84+-paH+8Xx7+-6vtfSe+G5eoFn2VRErg@mail.gmail.com>
Subject: Re: [net-next PATCH v2 02/14] net: phy: Introduce phy related fwnode functions
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
        Jon <jon@solid-run.com>, "linux.cj" <linux.cj@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 15, 2020 at 6:44 PM Calvin Johnson
<calvin.johnson@oss.nxp.com> wrote:
>
> Define fwnode_phy_find_device() to iterate an mdiobus and find the
> phy device of the provided phy fwnode. Additionally define
> device_phy_find_device() to find phy device of provided device.
>
> Define fwnode_get_phy_node() to get phy_node using named reference.

...

> +#include <linux/acpi.h>

Not sure we need this. See below.

...

> +/**
> + * fwnode_phy_find_device - Find phy_device on the mdiobus for the provided
> + * phy_fwnode.

Can we keep a summary on one line?

> + * @phy_fwnode: Pointer to the phy's fwnode.
> + *
> + * If successful, returns a pointer to the phy_device with the embedded
> + * struct device refcount incremented by one, or NULL on failure.
> + */
> +struct phy_device *fwnode_phy_find_device(struct fwnode_handle *phy_fwnode)
> +{
> +       struct mdio_device *mdiodev;
> +       struct device *d;

> +       if (!phy_fwnode)
> +               return NULL;

Why is this needed?
Perhaps a comment to the function description explains a case when
@phy_fwnode == NULL.

> +       d = bus_find_device_by_fwnode(&mdio_bus_type, phy_fwnode);
> +       if (d) {
> +               mdiodev = to_mdio_device(d);
> +               if (mdiodev->flags & MDIO_DEVICE_FLAG_PHY)
> +                       return to_phy_device(d);
> +               put_device(d);
> +       }
> +
> +       return NULL;
> +}

...

> + * For ACPI, only "phy-handle" is supported. DT supports all the three
> + * named references to the phy node.

...

> +       /* Only phy-handle is used for ACPI */
> +       phy_node = fwnode_find_reference(fwnode, "phy-handle", 0);
> +       if (is_acpi_node(fwnode) || !IS_ERR(phy_node))
> +               return phy_node;

So, what is the problem with going through the rest on ACPI?
Usually we describe the restrictions in the documentation.

-- 
With Best Regards,
Andy Shevchenko
