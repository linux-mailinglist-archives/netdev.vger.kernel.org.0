Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF0A23A77F
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 15:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgHCNbo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 09:31:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726933AbgHCNbo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 09:31:44 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDE53C061756
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 06:31:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=3felmVMzvtvOJmGSM6ZGwR0sacEuEuz4bqhtuDd3JIA=; b=RNTCmH/XZh5PT1ihBuYrV1e+yS
        xvVyU3DcsiVQGsZRuzAShVSEP0VSP53JAV/8pesNGpkzp/Y6WSkL3L46nAW8P3r+IHG8NoA2tbnpF
        GQBvTOkWarc97C9WvgTtMB9ES+r70Y1FRWcfjCgUig6KKkrD56E5hoXoVgOBAiNgQMQfyT7X1AaQN
        BnMjbl+Jt6+//yQYOJsO4i3MBOrwXn11Be7xNLrTEk6Ifm/2s/3SFFglBjSMmEuNC09dJgDT1cULG
        cU494M49raVsSTkQ/9wOY5VSWpEDYE7Iml1+rdSXfWoaWinWKbYuGsNh0SFZ7j4Bx1uCtsM5wdTAD
        2+z1EhyA==;
Received: from [2601:1c0:6280:3f0::19c2]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k2aYx-00015d-E1; Mon, 03 Aug 2020 13:31:36 +0000
Subject: Re: [PATCH v4 09/11] net: dsa: microchip: Add Microchip KSZ8863 SMI
 based driver support
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>, andrew@lunn.ch
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, davem@davemloft.net,
        kernel@pengutronix.de
References: <20200803054442.20089-1-m.grzeschik@pengutronix.de>
 <20200803054442.20089-10-m.grzeschik@pengutronix.de>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <f853c9ce-4753-b973-6153-5cf97163f74d@infradead.org>
Date:   Mon, 3 Aug 2020 06:31:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200803054442.20089-10-m.grzeschik@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/2/20 10:44 PM, Michael Grzeschik wrote:
> diff --git a/drivers/net/dsa/microchip/Kconfig b/drivers/net/dsa/microchip/Kconfig
> index 4ec6a47b7f7284f..c5819bd4121cc7c 100644
> --- a/drivers/net/dsa/microchip/Kconfig
> +++ b/drivers/net/dsa/microchip/Kconfig
> @@ -40,3 +40,12 @@ config NET_DSA_MICROCHIP_KSZ8795_SPI
>  
>  	  It is required to use the KSZ8795 switch driver as the only access
>  	  is through SPI.
> +
> +config NET_DSA_MICROCHIP_KSZ8863_SMI
> +	tristate "KSZ series SMI connected switch driver"
> +	depends on NET_DSA_MICROCHIP_KSZ8795
> +	select MDIO_BITBANG
> +	default y

huh? why?

> +	help
> +	  Select to enable support for registering switches configured through
> +	  Microchip SMI. It Supports the KSZ8863 and KSZ8873 Switch.

	                    supports                         switch.


-- 
~Randy

