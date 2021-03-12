Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2CB338F61
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 15:06:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbhCLOFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 09:05:25 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:53880 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229909AbhCLOFV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 09:05:21 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lKiPi-00AXAn-MH; Fri, 12 Mar 2021 15:05:14 +0100
Date:   Fri, 12 Mar 2021 15:05:14 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 08/10] of: of_net: Demote non-conforming kernel-doc header
Message-ID: <YEt1GlakFcST27F0@lunn.ch>
References: <20210312110758.2220959-1-lee.jones@linaro.org>
 <20210312110758.2220959-9-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210312110758.2220959-9-lee.jones@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 12, 2021 at 11:07:56AM +0000, Lee Jones wrote:
> Fixes the following W=1 kernel build warning(s):
> 
>  drivers/of/of_net.c:104: warning: Function parameter or member 'np' not described in 'of_get_mac_address'
>  drivers/of/of_net.c:104: warning: expecting prototype for mac(). Prototype was for of_get_mac_address() instead
> 
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Frank Rowand <frowand.list@gmail.com>
> Cc: netdev@vger.kernel.org
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/of/of_net.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/of/of_net.c b/drivers/of/of_net.c
> index 6e411821583e4..9b41a343e88ab 100644
> --- a/drivers/of/of_net.c
> +++ b/drivers/of/of_net.c
> @@ -78,7 +78,7 @@ static const void *of_get_mac_addr_nvmem(struct device_node *np)
>  	return mac;
>  }
>  
> -/**
> +/*
>   * Search the device tree for the best MAC address to use.  'mac-address' is
>   * checked first, because that is supposed to contain to "most recent" MAC
>   * address. If that isn't set, then 'local-mac-address' is checked next,

Hi Lee

of_get_mac_address() is a pretty important API function. So it would
be better to add the missing header to make this valid kdoc.

/**
 * of_get_mac_address - Get MAC address from device tree
 * @np: Pointer to the device_node of the interface
 *

 Andrew
