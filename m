Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 208A430770B
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 14:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbhA1N1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 08:27:55 -0500
Received: from mail-oi1-f178.google.com ([209.85.167.178]:42145 "EHLO
        mail-oi1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbhA1N1x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 08:27:53 -0500
Received: by mail-oi1-f178.google.com with SMTP id x71so5950257oia.9;
        Thu, 28 Jan 2021 05:27:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d+pToT/xuOngAcSKyQ+8hwJjJmM6UNxACT5XfJoc2AE=;
        b=dECB/xTTkJs5fMfQ6zPxlJpms5dXaBUPVK4tGccB+fshy3JBUVLtGjaAUU4Q1FU5Sb
         poZ6j7fsX2VjGmOgz2TbN5Q6toBI3kNvCLLbk4bPu7duG3eeIGY/RjP68eULlUsRGP+J
         KsEUYU7KrodfbvwG3Lt/efl31IJGPn1R8db0S4RdspCfKV7k5jZMXTXvwlGTmhIomzzq
         7eW06ObGO+jaKNOiGttv/SxwHbaT9XR/aqY8Vopo8aJq+DBnoujkM1ErPo3Lv+hB+L7J
         9VgD7pqCyE/X4oGO71ZV2Bq6xOIqt/NCnLu0nWTu2xQkUFcY0uTna8Zg+ef3Idmfu2+K
         sxfQ==
X-Gm-Message-State: AOAM531lX9TirP0XpZW7jCusbhP6ikvZicZsc0CEMUmCAj7H0n8Doc9W
        ix7u8uvhwPuVqGXg3Xd5drUp8QqQ9c9c7bZzrVA=
X-Google-Smtp-Source: ABdhPJzAu7gjzUFdzbLVZ5OnnOmQv0SgGGWAcjqzCLHhlbb+h1mN+nsV4W0iY4Ug1UCmEJEv5Gi3MAUqM92cSLyPbNY=
X-Received: by 2002:aca:308a:: with SMTP id w132mr6238707oiw.69.1611840431466;
 Thu, 28 Jan 2021 05:27:11 -0800 (PST)
MIME-Version: 1.0
References: <20210122154300.7628-1-calvin.johnson@oss.nxp.com>
 <20210122154300.7628-2-calvin.johnson@oss.nxp.com> <CAJZ5v0iX3uU36448ALA20hiVk968VKTsvgwLrp8ur96MQo3Acw@mail.gmail.com>
 <20210128112729.GA28413@lsv03152.swis.in-blr01.nxp.com> <CAJZ5v0id1i57K_=7eiK0cpOE6UtsKNfR7L7UEBcN1=G+WS+1TA@mail.gmail.com>
 <20210128131205.GA7882@lsv03152.swis.in-blr01.nxp.com>
In-Reply-To: <20210128131205.GA7882@lsv03152.swis.in-blr01.nxp.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Thu, 28 Jan 2021 14:27:00 +0100
Message-ID: <CAJZ5v0j1XVSyFa1q4RZ=FnSmfR5VOyX+u1uWBWdvTOVBJJ-JXw@mail.gmail.com>
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

On Thu, Jan 28, 2021 at 2:12 PM Calvin Johnson
<calvin.johnson@oss.nxp.com> wrote:
>
> On Thu, Jan 28, 2021 at 01:00:40PM +0100, Rafael J. Wysocki wrote:
> > On Thu, Jan 28, 2021 at 12:27 PM Calvin Johnson
> > <calvin.johnson@oss.nxp.com> wrote:
> > >
> > > Hi Rafael,
> > >
> > > Thanks for the review. I'll work on all the comments.
> > >
> > > On Fri, Jan 22, 2021 at 08:22:21PM +0100, Rafael J. Wysocki wrote:
> > > > On Fri, Jan 22, 2021 at 4:43 PM Calvin Johnson
> > > > <calvin.johnson@oss.nxp.com> wrote:
> > > > >
> > > > > Introduce ACPI mechanism to get PHYs registered on a MDIO bus and
> > > > > provide them to be connected to MAC.
> > > > >
> > > > > Describe properties "phy-handle" and "phy-mode".
> > > > >
> > > > > Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> > > > > ---
> > > > >
> > > > > Changes in v4:
> > > > > - More cleanup
> > > >
> > > > This looks much better that the previous versions IMV, some nits below.
> > > >
> > > > > Changes in v3: None
> > > > > Changes in v2:
> > > > > - Updated with more description in document
> > > > >
> > > > >  Documentation/firmware-guide/acpi/dsd/phy.rst | 129 ++++++++++++++++++
> > > > >  1 file changed, 129 insertions(+)
> > > > >  create mode 100644 Documentation/firmware-guide/acpi/dsd/phy.rst
> > > > >
> > > > > diff --git a/Documentation/firmware-guide/acpi/dsd/phy.rst b/Documentation/firmware-guide/acpi/dsd/phy.rst
> > > > > new file mode 100644
> > > > > index 000000000000..76fca994bc99
> > > > > --- /dev/null
> > > > > +++ b/Documentation/firmware-guide/acpi/dsd/phy.rst
> > > > > @@ -0,0 +1,129 @@
> > > > > +.. SPDX-License-Identifier: GPL-2.0
> > > > > +
> > > > > +=========================
> > > > > +MDIO bus and PHYs in ACPI
> > > > > +=========================
> > > > > +
> > > > > +The PHYs on an MDIO bus [1] are probed and registered using
> > > > > +fwnode_mdiobus_register_phy().
> > > >
> > > > Empty line here, please.
> > > >
> > > > > +Later, for connecting these PHYs to MAC, the PHYs registered on the
> > > > > +MDIO bus have to be referenced.
> > > > > +
> > > > > +The UUID given below should be used as mentioned in the "Device Properties
> > > > > +UUID For _DSD" [2] document.
> > > > > +   - UUID: daffd814-6eba-4d8c-8a91-bc9bbf4aa301
> > > >
> > > > I would drop the above paragraph.
> > > >
> > > > > +
> > > > > +This document introduces two _DSD properties that are to be used
> > > > > +for PHYs on the MDIO bus.[3]
> > > >
> > > > I'd say "for connecting PHYs on the MDIO bus [3] to the MAC layer."
> > > > above and add the following here:
> > > >
> > > > "These properties are defined in accordance with the "Device
> > > > Properties UUID For _DSD" [2] document and the
> > > > daffd814-6eba-4d8c-8a91-bc9bbf4aa301 UUID must be used in the Device
> > > > Data Descriptors containing them."
> > > >
> > > > > +
> > > > > +phy-handle
> > > > > +----------
> > > > > +For each MAC node, a device property "phy-handle" is used to reference
> > > > > +the PHY that is registered on an MDIO bus. This is mandatory for
> > > > > +network interfaces that have PHYs connected to MAC via MDIO bus.
> > > > > +
> > > > > +During the MDIO bus driver initialization, PHYs on this bus are probed
> > > > > +using the _ADR object as shown below and are registered on the MDIO bus.
> > > >
> > > > Do you want to mention the "reg" property here?  I think it would be
> > > > useful to do that.
> > >
> > > No. I think we should adhere to _ADR in MDIO case. The "reg" property for ACPI
> > > may be useful for other use cases that Andy is aware of.
> >
> > The code should reflect this, then.  I mean it sounds like you want to
> > check the "reg" property only if this is a non-ACPI node.
>
> Right. For MDIO case, that is what is required.
> "reg" for DT and "_ADR" for ACPI.
>
> However, Andy pointed out [1] that ACPI nodes can also hold reg property and
> therefore, fwnode_get_id() need to be capable to handling that situation as
> well.

No, please don't confuse those two things.

Yes, ACPI nodes can also hold a "reg" property, but the meaning of it
depends on the binding which is exactly my point: _ADR is not a
fallback replacement for "reg" in general and it is not so for MDIO
too.  The new function as proposed doesn't match the MDIO requirements
and so it should not be used for MDIO.

For MDIO, the exact flow mentioned above needs to be implemented (and
if someone wants to use it for their use case too, fine).

Otherwise the code wouldn't match the documentation.
