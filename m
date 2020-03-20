Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02BDB18D5BF
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 18:28:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbgCTR2h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 13:28:37 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:4781 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgCTR2h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 13:28:37 -0400
X-Originating-IP: 86.202.105.35
Received: from localhost (lfbn-lyo-1-9-35.w86-202.abo.wanadoo.fr [86.202.105.35])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id BF196240003;
        Fri, 20 Mar 2020 17:28:31 +0000 (UTC)
Date:   Fri, 20 Mar 2020 18:28:31 +0100
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Yangbo Lu <yangbo.lu@nxp.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH 2/6] MAINTAINERS: add entry for Microsemi Ocelot PTP
 driver
Message-ID: <20200320172831.GS5504@piout.net>
References: <20200320103726.32559-1-yangbo.lu@nxp.com>
 <20200320103726.32559-3-yangbo.lu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200320103726.32559-3-yangbo.lu@nxp.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 20/03/2020 18:37:22+0800, Yangbo Lu wrote:
> Add entry for Microsemi Ocelot PTP driver.
> 
> Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
> ---
>  MAINTAINERS | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 5dbee41..8da6fc1 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -11115,6 +11115,15 @@ S:	Supported
>  F:	drivers/net/ethernet/mscc/
>  F:	include/soc/mscc/ocelot*
>  
> +MICROSEMI OCELOT PTP CLOCK DRIVER
> +M:	Alexandre Belloni <alexandre.belloni@bootlin.com>

I'm open to not be listed here as I'm not the main author of the code
and I'm not actively working on ptp for ocelot...

> +M:	Yangbo Lu <yangbo.lu@nxp.com>
> +M:	Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>

...as long as you keep that address.

> +L:	netdev@vger.kernel.org
> +S:	Supported
> +F:	drivers/ptp/ptp_ocelot.c
> +F:	include/soc/mscc/ptp_ocelot.h
> +
>  MICROSOFT SURFACE PRO 3 BUTTON DRIVER
>  M:	Chen Yu <yu.c.chen@intel.com>
>  L:	platform-driver-x86@vger.kernel.org
> -- 
> 2.7.4
> 

-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
