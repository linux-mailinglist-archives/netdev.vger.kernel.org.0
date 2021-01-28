Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1586C30756E
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 13:05:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbhA1MCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 07:02:16 -0500
Received: from mail-ot1-f47.google.com ([209.85.210.47]:34380 "EHLO
        mail-ot1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231467AbhA1MBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 07:01:33 -0500
Received: by mail-ot1-f47.google.com with SMTP id a109so4921098otc.1;
        Thu, 28 Jan 2021 04:01:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YFd+ePX8uVw6q9k4sjKVG2onbgLoQUdjhM3fDLy+Btw=;
        b=LKAWVBS4m/h6/48Dn7N3w/0wd/2/YrXf3YGyPnTCTcha00mJP7Bcd7j0kSVCxIlT1a
         nRFIRNFxyLbsSFE1bIT9E6R9RfRE7Ix+IkidxlxQidzV63n//jEn7JK2dOYUPYXuVNrx
         4346xc/BYZWanIKx34Gua+023jjAl8+GnV2eGbNp45x4NIPODrXb+SlG+mQ1VBNe10q3
         9JeQJ0cI0kiuFN5ygg7dL5JMWfNVcCCVhqJ8FL9HtpoZ04zafFjdCpS2DxHeY0YYC3zR
         UYAKxHRuBfPUsJ3BjyAQSHy3UchLkW4+UDe5YZLud5VJV7vgoDk5RqgIbSozJUiK4v99
         KO8w==
X-Gm-Message-State: AOAM531WQHwOAHnXHH+l80TuECAHVajGLwz9Dy6O7jQ2nLfXvqSiOsUq
        EIoTjc1NkZoADqscNK7YHWNL92mg1xZLgmgNTe0=
X-Google-Smtp-Source: ABdhPJzw7uAHH10wT+hfkmC7l6BXx19Gtl05Ag3LL5T55Scni979vNQ+rXgR5Evx5NIc8UxTLZi8I+qmU3q2QMTkMfc=
X-Received: by 2002:a9d:7a4a:: with SMTP id z10mr11396877otm.206.1611835251636;
 Thu, 28 Jan 2021 04:00:51 -0800 (PST)
MIME-Version: 1.0
References: <20210122154300.7628-1-calvin.johnson@oss.nxp.com>
 <20210122154300.7628-2-calvin.johnson@oss.nxp.com> <CAJZ5v0iX3uU36448ALA20hiVk968VKTsvgwLrp8ur96MQo3Acw@mail.gmail.com>
 <20210128112729.GA28413@lsv03152.swis.in-blr01.nxp.com>
In-Reply-To: <20210128112729.GA28413@lsv03152.swis.in-blr01.nxp.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Thu, 28 Jan 2021 13:00:40 +0100
Message-ID: <CAJZ5v0id1i57K_=7eiK0cpOE6UtsKNfR7L7UEBcN1=G+WS+1TA@mail.gmail.com>
Subject: Re: [net-next PATCH v4 01/15] Documentation: ACPI: DSD: Document MDIO PHY
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Grant Likely <grant.likely@arm.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
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
        "linux.cj" <linux.cj@gmail.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 28, 2021 at 12:27 PM Calvin Johnson
<calvin.johnson@oss.nxp.com> wrote:
>
> Hi Rafael,
>
> Thanks for the review. I'll work on all the comments.
>
> On Fri, Jan 22, 2021 at 08:22:21PM +0100, Rafael J. Wysocki wrote:
> > On Fri, Jan 22, 2021 at 4:43 PM Calvin Johnson
> > <calvin.johnson@oss.nxp.com> wrote:
> > >
> > > Introduce ACPI mechanism to get PHYs registered on a MDIO bus and
> > > provide them to be connected to MAC.
> > >
> > > Describe properties "phy-handle" and "phy-mode".
> > >
> > > Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> > > ---
> > >
> > > Changes in v4:
> > > - More cleanup
> >
> > This looks much better that the previous versions IMV, some nits below.
> >
> > > Changes in v3: None
> > > Changes in v2:
> > > - Updated with more description in document
> > >
> > >  Documentation/firmware-guide/acpi/dsd/phy.rst | 129 ++++++++++++++++++
> > >  1 file changed, 129 insertions(+)
> > >  create mode 100644 Documentation/firmware-guide/acpi/dsd/phy.rst
> > >
> > > diff --git a/Documentation/firmware-guide/acpi/dsd/phy.rst b/Documentation/firmware-guide/acpi/dsd/phy.rst
> > > new file mode 100644
> > > index 000000000000..76fca994bc99
> > > --- /dev/null
> > > +++ b/Documentation/firmware-guide/acpi/dsd/phy.rst
> > > @@ -0,0 +1,129 @@
> > > +.. SPDX-License-Identifier: GPL-2.0
> > > +
> > > +=========================
> > > +MDIO bus and PHYs in ACPI
> > > +=========================
> > > +
> > > +The PHYs on an MDIO bus [1] are probed and registered using
> > > +fwnode_mdiobus_register_phy().
> >
> > Empty line here, please.
> >
> > > +Later, for connecting these PHYs to MAC, the PHYs registered on the
> > > +MDIO bus have to be referenced.
> > > +
> > > +The UUID given below should be used as mentioned in the "Device Properties
> > > +UUID For _DSD" [2] document.
> > > +   - UUID: daffd814-6eba-4d8c-8a91-bc9bbf4aa301
> >
> > I would drop the above paragraph.
> >
> > > +
> > > +This document introduces two _DSD properties that are to be used
> > > +for PHYs on the MDIO bus.[3]
> >
> > I'd say "for connecting PHYs on the MDIO bus [3] to the MAC layer."
> > above and add the following here:
> >
> > "These properties are defined in accordance with the "Device
> > Properties UUID For _DSD" [2] document and the
> > daffd814-6eba-4d8c-8a91-bc9bbf4aa301 UUID must be used in the Device
> > Data Descriptors containing them."
> >
> > > +
> > > +phy-handle
> > > +----------
> > > +For each MAC node, a device property "phy-handle" is used to reference
> > > +the PHY that is registered on an MDIO bus. This is mandatory for
> > > +network interfaces that have PHYs connected to MAC via MDIO bus.
> > > +
> > > +During the MDIO bus driver initialization, PHYs on this bus are probed
> > > +using the _ADR object as shown below and are registered on the MDIO bus.
> >
> > Do you want to mention the "reg" property here?  I think it would be
> > useful to do that.
>
> No. I think we should adhere to _ADR in MDIO case. The "reg" property for ACPI
> may be useful for other use cases that Andy is aware of.

The code should reflect this, then.  I mean it sounds like you want to
check the "reg" property only if this is a non-ACPI node.
