Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA6C53A32B0
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 20:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbhFJSHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 14:07:49 -0400
Received: from mail-oi1-f169.google.com ([209.85.167.169]:37669 "EHLO
        mail-oi1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbhFJSHs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 14:07:48 -0400
Received: by mail-oi1-f169.google.com with SMTP id h9so3050584oih.4;
        Thu, 10 Jun 2021 11:05:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6tFMdKF66GtiGCGuvjiXKRo9ePOn5bxziMQAgLo1RwQ=;
        b=tXifdLjtt7Hj0WOCAAbhwvnB7W4trRIs5WTgpiu7nAEYY2x4q5r+tnEp9a6s9zbcZ5
         2f+npVuIKn+YLGMSjrGjYQ6yWus/T80JEvB05w7XM+SucEIoj83W3NuTlR6HGCyLpK/+
         9XLfKL40uj72VdSnTu7NRnjHuMvQWnRRakj1SB1shWT9kxrF7rpj3gXfOM5ma+0oH6Nf
         OM4Pq1Q3KqxQqkpdNOP5vrfldzgRM+eTMuqHjQhHl4bqOefV61lx2KdNyUGiYQ2AKPj/
         0oN/AXPl3zlkrVOUPzVbN2iU1SFinw8qIxBLdrHxzDaDZx1uKzsU7sGf9mcLUgXDpXjM
         h32A==
X-Gm-Message-State: AOAM5334/7ecQbXz7/MDI97TjHo0oJW5kz0/WkX7Ed9IiTsGHhV00AGQ
        s0i5qDRhIUmnijrzvhzH+KfPkH/0J2+2N6os1OE=
X-Google-Smtp-Source: ABdhPJye8bhCZ3nvbsoG/AWSQExSaZgQ+UgWztP4soqwRMwdfz+Yf6AgchrvP9rp8nrhLcVOg1JZ7oftyXUEbxzdG7w=
X-Received: by 2002:a05:6808:f08:: with SMTP id m8mr1212972oiw.69.1623348342904;
 Thu, 10 Jun 2021 11:05:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210610163917.4138412-1-ciorneiioana@gmail.com> <20210610163917.4138412-2-ciorneiioana@gmail.com>
In-Reply-To: <20210610163917.4138412-2-ciorneiioana@gmail.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Thu, 10 Jun 2021 20:05:31 +0200
Message-ID: <CAJZ5v0jMspgw8tvA3xV5p7sRxTUOq89G5zSgaZa52EAi+9Cfbw@mail.gmail.com>
Subject: Re: [PATCH net-next v8 01/15] Documentation: ACPI: DSD: Document MDIO PHY
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, calvin.johnson@nxp.com,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux.cj" <linux.cj@gmail.com>, netdev <netdev@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Len Brown <lenb@kernel.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 10, 2021 at 6:40 PM Ioana Ciornei <ciorneiioana@gmail.com> wrote:
>
> From: Calvin Johnson <calvin.johnson@oss.nxp.com>
>
> Introduce ACPI mechanism to get PHYs registered on a MDIO bus and
> provide them to be connected to MAC.

This is not an "ACPI mechanism", because it is not part of the ACPI
specification or support documentation thereof.

I would call it "a mechanism based on generic ACPI _DSD device
properties definition []1]".  And provide a reference to the _DSD
properties definition document.

With that changed, you can add

Acked-by: Rafael J. Wysocki <rafael@kernel.org>

to this patch.

Note, however, that within the traditional ACPI framework, the _DSD
properties are consumed by the driver that binds to the device
represented by the ACPI device object containing the _DSD in question
in its scope, while in this case IIUC the properties are expected to
be consumed by the general networking code in the kernel.  That is not
wrong in principle, but it means that operating systems other than
Linux are not likely to be using them.

> Describe properties "phy-handle" and "phy-mode".
>
> Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> ---
>
> Changes in v8: None
> Changes in v7: None
> Changes in v6:
> - Minor cleanup
>
> Changes in v5:
> - More cleanup
>
> Changes in v4:
> - More cleanup
>
> Changes in v3: None
> Changes in v2:
> - Updated with more description in document
>
>  Documentation/firmware-guide/acpi/dsd/phy.rst | 133 ++++++++++++++++++
>  1 file changed, 133 insertions(+)
>  create mode 100644 Documentation/firmware-guide/acpi/dsd/phy.rst
>
> diff --git a/Documentation/firmware-guide/acpi/dsd/phy.rst b/Documentation/firmware-guide/acpi/dsd/phy.rst
> new file mode 100644
> index 000000000000..7d01ae8b3cc6
> --- /dev/null
> +++ b/Documentation/firmware-guide/acpi/dsd/phy.rst
> @@ -0,0 +1,133 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +=========================
> +MDIO bus and PHYs in ACPI
> +=========================
> +
> +The PHYs on an MDIO bus [1] are probed and registered using
> +fwnode_mdiobus_register_phy().
> +
> +Later, for connecting these PHYs to their respective MACs, the PHYs registered
> +on the MDIO bus have to be referenced.
> +
> +This document introduces two _DSD properties that are to be used
> +for connecting PHYs on the MDIO bus [3] to the MAC layer.
> +
> +These properties are defined in accordance with the "Device
> +Properties UUID For _DSD" [2] document and the
> +daffd814-6eba-4d8c-8a91-bc9bbf4aa301 UUID must be used in the Device
> +Data Descriptors containing them.
> +
> +phy-handle
> +----------
> +For each MAC node, a device property "phy-handle" is used to reference
> +the PHY that is registered on an MDIO bus. This is mandatory for
> +network interfaces that have PHYs connected to MAC via MDIO bus.
> +
> +During the MDIO bus driver initialization, PHYs on this bus are probed
> +using the _ADR object as shown below and are registered on the MDIO bus.
> +
> +::
> +      Scope(\_SB.MDI0)
> +      {
> +        Device(PHY1) {
> +          Name (_ADR, 0x1)
> +        } // end of PHY1
> +
> +        Device(PHY2) {
> +          Name (_ADR, 0x2)
> +        } // end of PHY2
> +      }
> +
> +Later, during the MAC driver initialization, the registered PHY devices
> +have to be retrieved from the MDIO bus. For this, the MAC driver needs
> +references to the previously registered PHYs which are provided
> +as device object references (e.g. \_SB.MDI0.PHY1).
> +
> +phy-mode
> +--------
> +The "phy-mode" _DSD property is used to describe the connection to
> +the PHY. The valid values for "phy-mode" are defined in [4].
> +
> +The following ASL example illustrates the usage of these properties.
> +
> +DSDT entry for MDIO node
> +------------------------
> +
> +The MDIO bus has an SoC component (MDIO controller) and a platform
> +component (PHYs on the MDIO bus).
> +
> +a) Silicon Component
> +This node describes the MDIO controller, MDI0
> +---------------------------------------------
> +::
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
> +The PHY1 and PHY2 nodes represent the PHYs connected to MDIO bus MDI0
> +---------------------------------------------------------------------
> +::
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
> +
> +DSDT entries representing MAC nodes
> +-----------------------------------
> +
> +Below are the MAC nodes where PHY nodes are referenced.
> +phy-mode and phy-handle are used as explained earlier.
> +------------------------------------------------------
> +::
> +       Scope(\_SB.MCE0.PR17)
> +       {
> +         Name (_DSD, Package () {
> +            ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> +                Package () {
> +                    Package (2) {"phy-mode", "rgmii-id"},
> +                    Package (2) {"phy-handle", \_SB.MDI0.PHY1}
> +             }
> +          })
> +       }
> +
> +       Scope(\_SB.MCE0.PR18)
> +       {
> +         Name (_DSD, Package () {
> +           ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> +               Package () {
> +                   Package (2) {"phy-mode", "rgmii-id"},
> +                   Package (2) {"phy-handle", \_SB.MDI0.PHY2}}
> +           }
> +         })
> +       }
> +
> +References
> +==========
> +
> +[1] Documentation/networking/phy.rst
> +
> +[2] https://www.uefi.org/sites/default/files/resources/_DSD-device-properties-UUID.pdf
> +
> +[3] Documentation/firmware-guide/acpi/DSD-properties-rules.rst
> +
> +[4] Documentation/devicetree/bindings/net/ethernet-controller.yaml
> --
> 2.31.1
>
