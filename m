Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C86325E8AD
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 17:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726468AbgIEP2N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 11:28:13 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44794 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726261AbgIEP2L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Sep 2020 11:28:11 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kEa6l-00DMep-L5; Sat, 05 Sep 2020 17:28:03 +0200
Date:   Sat, 5 Sep 2020 17:28:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Paul Barker <pbarker@konsulko.com>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH 1/4] net: dsa: microchip: Make switch detection more
 informative
Message-ID: <20200905152803.GC3164319@lunn.ch>
References: <20200905140325.108846-1-pbarker@konsulko.com>
 <20200905140325.108846-2-pbarker@konsulko.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200905140325.108846-2-pbarker@konsulko.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 05, 2020 at 03:03:22PM +0100, Paul Barker wrote:
> To make switch detection more informative print the result of the
> ksz9477/ksz9893 compatibility check. With debug output enabled also
> print the contents of the Chip ID registers as a 40-bit hex string.
> 
> As this detection is the first communication with the switch performed
> by the driver, making it easy to see any errors here will help identify
> issues with SPI data corruption or reset sequencing.
> 
> Signed-off-by: Paul Barker <pbarker@konsulko.com>
> ---
>  drivers/net/dsa/microchip/ksz9477.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
> index 3cb22d149813..a48f5edab561 100644
> --- a/drivers/net/dsa/microchip/ksz9477.c
> +++ b/drivers/net/dsa/microchip/ksz9477.c
> @@ -13,6 +13,7 @@
>  #include <linux/if_bridge.h>
>  #include <net/dsa.h>
>  #include <net/switchdev.h>
> +#include <linux/printk.h>

It is not often you see that include. linux/kernel.h includes it
anyway, and given how few files include printk.h, i doubt it will ever
be removed from kernel.h

   Andrew
