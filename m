Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 179A42FAD2F
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 23:14:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388283AbhARWNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 17:13:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388051AbhARWNf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 17:13:35 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D94FAC061757;
        Mon, 18 Jan 2021 14:12:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=5B9g+MMdkfjDrWyHguWhdW+L/wC5SN7nNmsF2xSXNSM=; b=CnWX9AJYZ5WVkbueQhdSbY538L
        zd6XPx+rOvh0UH4xB/JwYgcpc/fG9we3B9Oos+K7jQkeChYJ32PtVQllfyE5N4500UinIBbAcnQh+
        V84mdUhG6IgKhl2V9GB8fRoJgPPgpzYq9aRSt8MZA17iPEh5kRtS/4rTEIlOyhBYnT0+vnz6y57AQ
        HaExpRbotZ4XugQbQZ6DGqw4/1eJZOWtWAWUo/bwbiyQgmWcCcSEc4V9glTzanggnU/cFGW6XTmhN
        iBLEzva7KvHwxRspf0u8PDYOqGucRpUHdjXbSNbf57iCkZhJuZi0MyDwkB+WroXPj+otOdzd4674j
        xOH13W5Q==;
Received: from [2601:1c0:6280:3f0::9abc]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l1clS-0002tt-Ta; Mon, 18 Jan 2021 22:12:47 +0000
Subject: Re: [net-next PATCH v3 01/15] Documentation: ACPI: DSD: Document MDIO
 PHY
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Grant Likely <grant.likely@arm.com>,
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
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>
Cc:     Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        linux-acpi@vger.kernel.org, linux.cj@gmail.com,
        linux-arm-kernel@lists.infradead.org, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
References: <20210112134054.342-1-calvin.johnson@oss.nxp.com>
 <20210112134054.342-2-calvin.johnson@oss.nxp.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <414bb8d0-df20-25f2-07a4-408fe22b0093@infradead.org>
Date:   Mon, 18 Jan 2021 14:12:36 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20210112134054.342-2-calvin.johnson@oss.nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 1/12/21 5:40 AM, Calvin Johnson wrote:
> Introduce ACPI mechanism to get PHYs registered on a MDIO bus and
> provide them to be connected to MAC.
> 
> Describe properties "phy-handle" and "phy-mode".
> 
> Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> ---
> 
> Changes in v3: None
> Changes in v2:
> - Updated with more description in document
> 
>  Documentation/firmware-guide/acpi/dsd/phy.rst | 129 ++++++++++++++++++
>  1 file changed, 129 insertions(+)
>  create mode 100644 Documentation/firmware-guide/acpi/dsd/phy.rst
> 
> diff --git a/Documentation/firmware-guide/acpi/dsd/phy.rst b/Documentation/firmware-guide/acpi/dsd/phy.rst
> new file mode 100644
> index 000000000000..a2e4fdcdbf53
> --- /dev/null
> +++ b/Documentation/firmware-guide/acpi/dsd/phy.rst
> @@ -0,0 +1,129 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +=========================
> +MDIO bus and PHYs in ACPI
> +=========================
> +
> +The PHYs on an MDIO bus [1] are probed and registered using
> +fwnode_mdiobus_register_phy().
> +Later, for connecting these PHYs to MAC, the PHYs registered on the
> +mdiobus have to be referenced.
> +
> +UUID given below should be used as mentioned in the "Device Properties

   The UUID given below

> +UUID For _DSD" [2] document.
> +   - UUID: daffd814-6eba-4d8c-8a91-bc9bbf4aa301
> +
> +This document introduces two _DSD properties that are to be used
> +for PHYs on the MDIO bus.[3]
> +
> +phy-handle
> +----------
> +For each MAC node, a device property "phy-handle" is used to reference
> +the PHY that is registered on an MDIO bus. This is mandatory for
> +network interfaces that have PHYs connected to MAC via MDIO bus.
> +
> +During the MDIO bus driver initialization, PHYs on this bus are probed
> +using the _ADR object as shown below and are registered on the mdio bus.

s/mdio/MDIO/  (please be consistent, as 3 lines above)
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
> +have to be retrieved from the mdio bus. For this, MAC driver needs

ditto.

> +reference to the previously registered PHYs which are provided
> +using reference to the device as {\_SB.MDI0.PHY1}.
> +
> +phy-mode
> +--------
> +The "phy-mode" _DSD property is used to describe the connection to
> +the PHY. The valid values for "phy-mode" are defined in [4].
> +
> +
> +An ASL example of this is shown below.
> +
> +DSDT entry for MDIO node
> +------------------------
> +The MDIO bus has an SoC component(mdio controller) and a platform

                           component (MDIO controller)

> +component(PHYs on the mdiobus).

   component (PHYs

> +
> +a) Silicon Component
> +This node describes the MDIO controller,MDI0

                                controller, MDI0

> +--------------------------------------------

and then one more '-', please.

> +::
> +	Scope(_SB)
> +	{
> +	  Device(MDI0) {
> +	    Name(_HID, "NXP0006")
> +	    Name(_CCA, 1)
> +	    Name(_UID, 0)
> +	    Name(_CRS, ResourceTemplate() {
> +	      Memory32Fixed(ReadWrite, MDI0_BASE, MDI_LEN)
> +	      Interrupt(ResourceConsumer, Level, ActiveHigh, Shared)
> +	       {
> +		 MDI0_IT
> +	       }
> +	    }) // end of _CRS for MDI0
> +	  } // end of MDI0
> +	}
> +
> +b) Platform Component
> +This node defines the PHYs that are connected to the MDIO bus, MDI0
> +-------------------------------------------------------------------

[deletia]


thanks.
-- 
~Randy
You can't do anything without having to do something else first.
-- Belefant's Law
