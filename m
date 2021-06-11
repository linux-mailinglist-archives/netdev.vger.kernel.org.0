Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D43D33A4161
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 13:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231627AbhFKLnY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 07:43:24 -0400
Received: from mail-ot1-f41.google.com ([209.85.210.41]:40646 "EHLO
        mail-ot1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231289AbhFKLnX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 07:43:23 -0400
Received: by mail-ot1-f41.google.com with SMTP id l15-20020a05683016cfb02903fca0eacd15so2834059otr.7;
        Fri, 11 Jun 2021 04:41:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7QOkn9Hd+sQCvI8baU0dpPbaUWUsXvor6j6J5RvuZ0c=;
        b=XuOJ1NY+Iu6o+tGgf7b5E6CYOubH9+OtOw5wqTYIKgLN14CiifwgVwh2KntL9+9g5/
         mbXRoHCCQwFjjDnsNgtJB3sIBayqkFo20aweSMpNYL3aFqEV1HF4wgHNCAo0TyraTaQ8
         U/WbCOISIMfFstT7uCgptnB8Q1zumwP/DJZnf1tqB+2NzD0g6fUXBjBx2ofGlPEsDoud
         47LTUR+WQrxokDv6LSxmyizl1fNG7n+vib+INxj3IaHdfP4U0TyFJi2e/3b1aXU8YlCV
         ZnDqfMe5PELnnu5ZcE8+REaZeUzQ/pE8QtGoZOHZ9UCcg4ZeU1sTzhZU98xl+lLvDV9T
         CgEg==
X-Gm-Message-State: AOAM530EssBrbjwpbOFA9vVuZYbboSyVHjiIH4uCtGSqyf59Lciz1nPS
        VRE3pVENJwLVTuvSFgfwpHU1M1Ww0xco/svjcaQ=
X-Google-Smtp-Source: ABdhPJwQTGdCRMLaGc9mpm/YGrESWdEScX68+bH9kYc33POVxW9M0l5xzZFSm1LsFO7c25vhgsQjPb21ulP9KNGySKA=
X-Received: by 2002:a9d:6c4d:: with SMTP id g13mr2812244otq.321.1623411670173;
 Fri, 11 Jun 2021 04:41:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210611105401.270673-1-ciorneiioana@gmail.com>
 <20210611105401.270673-4-ciorneiioana@gmail.com> <CAHp75VcfEbMecsGprNW33OtiddVw1MhmOVrtb9Gx4tKL5BjvYw@mail.gmail.com>
In-Reply-To: <CAHp75VcfEbMecsGprNW33OtiddVw1MhmOVrtb9Gx4tKL5BjvYw@mail.gmail.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Fri, 11 Jun 2021 13:40:59 +0200
Message-ID: <CAJZ5v0ipvAodoFhU4XK+cL2tf-0jExtMd2QUarMK0QPJQyeJxg@mail.gmail.com>
Subject: Re: [PATCH net-next v9 03/15] net: phy: Introduce phy related fwnode functions
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Ioana Ciornei <ciorneiioana@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux.cj" <linux.cj@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Len Brown <lenb@kernel.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 11, 2021 at 1:26 PM Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
>
> On Fri, Jun 11, 2021 at 1:54 PM Ioana Ciornei <ciorneiioana@gmail.com> wrote:
> >
> > From: Calvin Johnson <calvin.johnson@oss.nxp.com>
> >
> > Define fwnode_phy_find_device() to iterate an mdiobus and find the
> > phy device of the provided phy fwnode. Additionally define
> > device_phy_find_device() to find phy device of provided device.
> >
> > Define fwnode_get_phy_node() to get phy_node using named reference.
>
> using a named
>
> ...
>
> > +struct fwnode_handle *fwnode_get_phy_node(struct fwnode_handle *fwnode)
> > +{
> > +       struct fwnode_handle *phy_node;
> > +
> > +       /* Only phy-handle is used for ACPI */
> > +       phy_node = fwnode_find_reference(fwnode, "phy-handle", 0);
> > +       if (is_acpi_node(fwnode) || !IS_ERR(phy_node))
> > +               return phy_node;
> > +       phy_node = fwnode_find_reference(fwnode, "phy", 0);
> > +       if (IS_ERR(phy_node))
> > +               phy_node = fwnode_find_reference(fwnode, "phy-device", 0);
> > +       return phy_node;
>
> Looking into the patterns in this code I would perhaps refactor it the
> following way:
>
>      /* First try "phy-handle" as most common in use */
>      phy_node = fwnode_find_reference(fwnode, "phy-handle", 0);
>      /* Only phy-handle is used for ACPI */
>      if (is_acpi_node(fwnode))
>               return phy_node;
>      if (!IS_ERR(phy_node))
>               return phy_node;

I'm not sure why you want the above to be two if () statements instead of one?

I would change the ordering anyway, that is

if (!IS_ERR(phy_node) || is_acpi_node(fwnode))
        return phy_node;

And I think that the is_acpi_node() check is there to return the error
code right away so as to avoid returning a "not found" error later.

But I'm not sure if this is really necessary.  Namely, if nothing
depends on the specific error code returned by this function, it would
be somewhat cleaner to let the code below run if phy_node is an error
pointer in the ACPI case, because in that case the code below will
produce an error pointer anyway.

>      /* Try "phy" reference */
>      phy_node = fwnode_find_reference(fwnode, "phy", 0);
>      if (!IS_ERR(phy_node))
>               return phy_node;
>      /* At last try "phy-device" reference */
>      return fwnode_find_reference(fwnode, "phy-device", 0);
>
> > +}
