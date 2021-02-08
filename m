Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF93313FDB
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 21:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235407AbhBHUDa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 15:03:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236612AbhBHUCw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 15:02:52 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E49DC061786;
        Mon,  8 Feb 2021 12:02:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=KEVihHrH3SS79oWMEH67DVoOPklE1uT1jn0P7NuEG4M=; b=wMhUXlj5RnosMi7s8pVfo6DDyX
        0jkjN6g9frlYUYPUy7en2RfJlG/c1Fv5v/LYqnTXVMT4oeMwOLiOKMcdV3G1KY34QTVloDCJq61CH
        IfuOSPhRBY0aYb8V3DL5Hpt6jARfgXoXuAIJJCEluD1+t1RvxYNHjAo+D85etPuqnW363o6/kyoSd
        lS/fTRHpiM8HrW4TBmZLJoyHE+ISLDcR06pUh1f1CPDeEqr74wQEkrqYJGJ99R2Vp0+LcDRO8yldf
        vzbhNFX2kUs4dsf355PbiFs/5b75pkbHekbWcrEgw1v0X3CVds/M2xBL+SuMqts1dGRmqNWh7DcLO
        a7FLKT5w==;
Received: from [2601:1c0:6280:3f0::cf3b]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l9CjW-0001t4-8B; Mon, 08 Feb 2021 20:02:06 +0000
Subject: Re: [net-next PATCH v5 01/15] Documentation: ACPI: DSD: Document MDIO
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
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>
Cc:     Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        linux-kernel@vger.kernel.org, linux.cj@gmail.com,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
References: <20210208151244.16338-1-calvin.johnson@oss.nxp.com>
 <20210208151244.16338-2-calvin.johnson@oss.nxp.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <0a347d2a-f885-5b26-4477-ff267527d8c4@infradead.org>
Date:   Mon, 8 Feb 2021 12:01:57 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210208151244.16338-2-calvin.johnson@oss.nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
Just a couple of nits below:

On 2/8/21 7:12 AM, Calvin Johnson wrote:
> Introduce ACPI mechanism to get PHYs registered on a MDIO bus and
> provide them to be connected to MAC.
> 
> Describe properties "phy-handle" and "phy-mode".
> 
> Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> ---

>  Documentation/firmware-guide/acpi/dsd/phy.rst | 133 ++++++++++++++++++
>  1 file changed, 133 insertions(+)
>  create mode 100644 Documentation/firmware-guide/acpi/dsd/phy.rst
> 
> diff --git a/Documentation/firmware-guide/acpi/dsd/phy.rst b/Documentation/firmware-guide/acpi/dsd/phy.rst
> new file mode 100644
> index 000000000000..e1e99cae5eb2
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
> +Later, for connecting these PHYs to MAC, the PHYs registered on the

                                    to a MAC,

> +MDIO bus have to be referenced.
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

...

> +
> +Later, during the MAC driver initialization, the registered PHY devices
> +have to be retrieved from the MDIO bus. For this, the MAC driver need

                                                                    needs

> +references to the previously registered PHYs which are provided
> +as device object references (e.g. \_SB.MDI0.PHY1).


thanks.
-- 
~Randy

