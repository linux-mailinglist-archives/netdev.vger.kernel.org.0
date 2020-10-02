Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F4C62814C8
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 16:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388019AbgJBOOH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 10:14:07 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:44509 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387984AbgJBOOH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 10:14:07 -0400
Received: by mail-ot1-f66.google.com with SMTP id a2so1454407otr.11;
        Fri, 02 Oct 2020 07:14:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ihMziQ36Im0zrWKhCpCw4BTS3PLugco3lRz9KFCDqE8=;
        b=WP8BVfNG4SzkXq5MiiaMxa10OyAQzCmOqm+b0aj2hD9w9H5B7pla8ZsOiKfkFjhdMO
         CSglfHlTr9Fp2o3YLhi5uBqGcwTBH4SbfFZyS09K0635t6wLTqgkapUl0OYBAetyd8JC
         D4au8D7XaSRXgQE9g4OsGgjp877U0mn6mvAiWTWKuvMrCaVagZ5LKLwgSZHyOcIivBzh
         AEXw3NhsZMhmNiRtN6aGjcLeUUUeQSf4FS4elRVwXL66ANp23AXW60CmoQer2iuD1eY0
         6ZjiRd7sYD5A1W48WADBYFYKYPmoMcMCUcZ7eQZt4366TqqWgLp9UlCEpq1fjuiLdll5
         f6Jw==
X-Gm-Message-State: AOAM532jr+2aAJ8lDVtAZ3YyYSQHzlJ5uy9j2gPkFn/LfbZyvoA+T6Mk
        M0tjm+1GN0ji1SsihWAGeZJo/jNHFBulwe1hlNE=
X-Google-Smtp-Source: ABdhPJyZyRzl3PSCyG+0F3xvXXLMMo72pPpSBbPEGYzFl5a+viQSZv8vrl+z4BcyLgLlDH9lRF5gIuLcbG9Trd8Z6xw=
X-Received: by 2002:a9d:718a:: with SMTP id o10mr1878239otj.262.1601648046490;
 Fri, 02 Oct 2020 07:14:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200930160430.7908-1-calvin.johnson@oss.nxp.com>
 <20200930160430.7908-2-calvin.johnson@oss.nxp.com> <CAJZ5v0jP8L=bBMYTUkYCSwN=fy8dwTdjqu1JurSxTa2bAHRLew@mail.gmail.com>
 <39b9a51d-56f6-75f8-a88e-71a7e01b9f55@arm.com>
In-Reply-To: <39b9a51d-56f6-75f8-a88e-71a7e01b9f55@arm.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Fri, 2 Oct 2020 16:13:54 +0200
Message-ID: <CAJZ5v0i-OK05bkA+sH_jBVgTKVLDKUtHqBduH2SKvYv3_kA4WA@mail.gmail.com>
Subject: Re: [net-next PATCH v1 1/7] Documentation: ACPI: DSD: Document MDIO PHY
To:     Grant Likely <grant.likely@arm.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
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
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux.cj@gmail.com, netdev <netdev@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, nd <nd@arm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 2, 2020 at 1:09 PM Grant Likely <grant.likely@arm.com> wrote:
>
>
>
> On 30/09/2020 17:37, Rafael J. Wysocki wrote:
> > On Wed, Sep 30, 2020 at 6:05 PM Calvin Johnson
> > <calvin.johnson@oss.nxp.com> wrote:
> >>
> >> Introduce ACPI mechanism to get PHYs registered on a MDIO bus and
> >> provide them to be connected to MAC.
> >>
> >> Describe properties "phy-handle" and "phy-mode".
> >>
> >> Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> >> ---
> >>
> >>   Documentation/firmware-guide/acpi/dsd/phy.rst | 78 +++++++++++++++++++
> >>   1 file changed, 78 insertions(+)
> >>   create mode 100644 Documentation/firmware-guide/acpi/dsd/phy.rst
> >>
> >> diff --git a/Documentation/firmware-guide/acpi/dsd/phy.rst b/Documentation/firmware-guide/acpi/dsd/phy.rst
> >> new file mode 100644
> >> index 000000000000..f10feb24ec1c
> >> --- /dev/null
> >> +++ b/Documentation/firmware-guide/acpi/dsd/phy.rst
> >> @@ -0,0 +1,78 @@
> >> +.. SPDX-License-Identifier: GPL-2.0
> >> +
> >> +=========================
> >> +MDIO bus and PHYs in ACPI
> >> +=========================
> >> +
> >> +The PHYs on an mdiobus are probed and registered using
> >> +fwnode_mdiobus_register_phy().
> >> +Later, for connecting these PHYs to MAC, the PHYs registered on the
> >> +mdiobus have to be referenced.
> >> +
> >> +phy-handle
> >> +-----------
> >> +For each MAC node, a property "phy-handle" is used to reference the
> >> +PHY that is registered on an MDIO bus.
> >
> > It is not clear what "a property" means in this context.
> >
> > This should refer to the documents introducing the _DSD-based generic
> > device properties rules, including the GUID used below.
> >
> > You need to say whether or not the property is mandatory and if it
> > isn't mandatory, you need to say what the lack of it means.
> >
> >> +
> >> +phy-mode
> >> +--------
> >> +Property "phy-mode" defines the type of PHY interface.
> >
> > This needs to be more detailed too, IMO.  At the very least, please
> > list all of the possible values of it and document their meaning.
>
> If the goal is to align with DT, it would be appropriate to point to
> where those properties are defined for DT rather than to have a separate
> description here. I suggest something along the lines of:
>
>     The "phy-mode" _DSD property is used to describe the connection to
>     the PHY. The valid values for "phy-mode" are defined in
>     Documentation/devicetree/bindings/ethernet-controller.yaml
>
> >
> >> +
> >> +An example of this is shown below::
> >> +
> >> +DSDT entry for MACs where PHY nodes are referenced
> >> +--------------------------------------------------
> >> +       Scope(\_SB.MCE0.PR17) // 1G
> >> +       {
> >> +         Name (_DSD, Package () {
> >> +            ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> >> +                Package () {
> >> +                    Package (2) {"phy-mode", "rgmii-id"},
> >> +                    Package (2) {"phy-handle", Package (){\_SB.MDI0.PHY1}}
> >
> > What is "phy-handle"?
> >
> > You haven't introduced it above.
>
> Can you elaborate? "phy-handle" has a section to itself in this
> document.

Yes, it does.

I overlooked it, sorry.

> Agree that it needs to be defined more, but it does read to me
> as having been defined.

Yup.

Cheers!
