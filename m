Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9FC027EF56
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 18:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728076AbgI3QhW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 12:37:22 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:44654 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgI3QhW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 12:37:22 -0400
Received: by mail-ot1-f68.google.com with SMTP id a2so2418472otr.11;
        Wed, 30 Sep 2020 09:37:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OUlkoyLtEVGqiuJFMrya04j2YTL8vOQrHdCRqhIRvYM=;
        b=ESQlnl3z0w2dm5EN5o4ZStT+q1LsTbKh6Nucu9m2v4H/DJTBFvuvPxtp3+qRgtlWA9
         Xz+nmWAiqEGmCP48D/dmpIJlmay5wyFIm6VnaP3YJoB3ZzkjEYRKV/FHO1BHDkP/fooe
         8UL1laE9YI41L2NKL7Db5bYuxYDy9/Tp24/QGOriy6yxOu0Lhp3lEKsQI+IEhpQille5
         kNPWNbFkpn0f0hgH+s6ZP/8Lz/Nbtp7nMvehHBs6hXTwK0Lke4XfckzqfIxJnKnjIIvO
         YvQNK/nhHLEMdlquIJxjKzD4ZmC5sfSSGso1FWt4K0gmxovkCRIkaIZ+ItcWHNxNxDfo
         FBKA==
X-Gm-Message-State: AOAM533o+Lq0mjU1GzuLZyVGEDALCCrDFqMq8AnYhrn9wElDfbXyJ8ud
        fyZRue2QnUQWLL6mqN3QTsWEo9vRr9myfUluuL4=
X-Google-Smtp-Source: ABdhPJxoSipjS3ozLe1NqMaf+FoZd1hAoezCYXKNO3iSyEN5PLcZjJoJ2ESCIRIztwncvkdadoYCdNLp4xBFyzFs8/U=
X-Received: by 2002:a05:6830:1f16:: with SMTP id u22mr2003370otg.118.1601483841231;
 Wed, 30 Sep 2020 09:37:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200930160430.7908-1-calvin.johnson@oss.nxp.com> <20200930160430.7908-2-calvin.johnson@oss.nxp.com>
In-Reply-To: <20200930160430.7908-2-calvin.johnson@oss.nxp.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Wed, 30 Sep 2020 18:37:09 +0200
Message-ID: <CAJZ5v0jP8L=bBMYTUkYCSwN=fy8dwTdjqu1JurSxTa2bAHRLew@mail.gmail.com>
Subject: Re: [net-next PATCH v1 1/7] Documentation: ACPI: DSD: Document MDIO PHY
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
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
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 6:05 PM Calvin Johnson
<calvin.johnson@oss.nxp.com> wrote:
>
> Introduce ACPI mechanism to get PHYs registered on a MDIO bus and
> provide them to be connected to MAC.
>
> Describe properties "phy-handle" and "phy-mode".
>
> Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> ---
>
>  Documentation/firmware-guide/acpi/dsd/phy.rst | 78 +++++++++++++++++++
>  1 file changed, 78 insertions(+)
>  create mode 100644 Documentation/firmware-guide/acpi/dsd/phy.rst
>
> diff --git a/Documentation/firmware-guide/acpi/dsd/phy.rst b/Documentation/firmware-guide/acpi/dsd/phy.rst
> new file mode 100644
> index 000000000000..f10feb24ec1c
> --- /dev/null
> +++ b/Documentation/firmware-guide/acpi/dsd/phy.rst
> @@ -0,0 +1,78 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +=========================
> +MDIO bus and PHYs in ACPI
> +=========================
> +
> +The PHYs on an mdiobus are probed and registered using
> +fwnode_mdiobus_register_phy().
> +Later, for connecting these PHYs to MAC, the PHYs registered on the
> +mdiobus have to be referenced.
> +
> +phy-handle
> +-----------
> +For each MAC node, a property "phy-handle" is used to reference the
> +PHY that is registered on an MDIO bus.

It is not clear what "a property" means in this context.

This should refer to the documents introducing the _DSD-based generic
device properties rules, including the GUID used below.

You need to say whether or not the property is mandatory and if it
isn't mandatory, you need to say what the lack of it means.

> +
> +phy-mode
> +--------
> +Property "phy-mode" defines the type of PHY interface.

This needs to be more detailed too, IMO.  At the very least, please
list all of the possible values of it and document their meaning.

> +
> +An example of this is shown below::
> +
> +DSDT entry for MACs where PHY nodes are referenced
> +--------------------------------------------------
> +       Scope(\_SB.MCE0.PR17) // 1G
> +       {
> +         Name (_DSD, Package () {
> +            ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> +                Package () {
> +                    Package (2) {"phy-mode", "rgmii-id"},
> +                    Package (2) {"phy-handle", Package (){\_SB.MDI0.PHY1}}

What is "phy-handle"?

You haven't introduced it above.

> +             }
> +          })
> +       }
> +
> +       Scope(\_SB.MCE0.PR18) // 1G
> +       {
> +         Name (_DSD, Package () {
> +           ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> +               Package () {
> +                   Package (2) {"phy-mode", "rgmii-id"},
> +                   Package (2) {"phy-handle", Package (){\_SB.MDI0.PHY2}}
> +           }
> +         })
> +       }
> +
> +DSDT entry for MDIO node
> +------------------------
> +a) Silicon Component

What is this device, exactly?

> +--------------------
> +       Scope(_SB)
> +       {
> +         Device(MDI0) {
> +           Name(_HID, "NXP0006")
> +           Name(_CCA, 1)
> +           Name(_UID, 0)
> +           Name(_CRS, ResourceTemplate() {
> +             Memory32Fixed(ReadWrite, MDI0_BASE, MDI_LEN)
> +             Interrupt(ResourceConsumer, Level, ActiveHigh, Shared)
> +              {
> +                MDI0_IT
> +              }
> +           }) // end of _CRS for MDI0
> +         } // end of MDI0
> +       }
> +
> +b) Platform Component
> +---------------------
> +       Scope(\_SB.MDI0)
> +       {
> +         Device(PHY1) {
> +           Name (_ADR, 0x1)
> +         } // end of PHY1
> +
> +         Device(PHY2) {
> +           Name (_ADR, 0x2)
> +         } // end of PHY2
> +       }
> --

What is the connection between the last two pieces of ASL and the _DSD
definitions above?
