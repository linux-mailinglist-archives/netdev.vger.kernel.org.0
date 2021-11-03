Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8599E4444F4
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 16:52:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231826AbhKCPyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 11:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbhKCPym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 11:54:42 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9E2CC061714;
        Wed,  3 Nov 2021 08:52:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=QtBcDmePoYyEOlHlNKyccMMS2h7KJBCiJJZSMM3TdMk=; b=Ql2c1y3bVmcJUr6BfUuMTWbFrZ
        dLGh2UBFXY1Io0ffarLFjF8KBV5c53d05RIFSwkjRR0YAZnjziyC79CZbiuahnx9Kt68TrEA9s7nd
        zoqlpx+cMmIeK1uqdNkdpw0XDv80scECHhnq05Aqi6a4ABY3RRRhM1R6FqvU7Q5wYUPZWiiq9qdRr
        1vvqzP/LR9TjGj81kl7dmSxyR7L12u00Y6Tdv4iuhQ2s3KbaySrdjGywUStsNc6ZtE0Uu44L5VGUT
        bZv9XCsujkqIqgUxhw+8irMNPdCznMCUSnPxeq4gLIcNRUqYgc9CgagRxQpyfHFoYiOnKhVUY2Oed
        cq4JsXnQ==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1miIYS-005bsf-Uo; Wed, 03 Nov 2021 15:52:01 +0000
Subject: Re: [PATCH 2/2] net: ethernet: Add driver for Sunplus SP7021
To:     Wells Lu <wellslutw@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, robh+dt@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        p.zabel@pengutronix.de
Cc:     Wells Lu <wells.lu@sunplus.com>
References: <cover.1635936610.git.wells.lu@sunplus.com>
 <650ec751dd782071dd56af5e36c0d509b0c66d7f.1635936610.git.wells.lu@sunplus.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <d0217eed-a8b7-8eb9-7d50-4bf69cd38e03@infradead.org>
Date:   Wed, 3 Nov 2021 08:52:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <650ec751dd782071dd56af5e36c0d509b0c66d7f.1635936610.git.wells.lu@sunplus.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi--

On 11/3/21 4:02 AM, Wells Lu wrote:
> diff --git a/drivers/net/ethernet/sunplus/Kconfig b/drivers/net/ethernet/sunplus/Kconfig
> new file mode 100644
> index 0000000..a9e3a4c
> --- /dev/null
> +++ b/drivers/net/ethernet/sunplus/Kconfig
> @@ -0,0 +1,20 @@
> +# SPDX-License-Identifier: GPL-2.0
> +#
> +# Sunplus Ethernet device configuration
> +#
> +
> +config NET_VENDOR_SUNPLUS
> +	tristate "Sunplus Dual 10M/100M Ethernet (with L2 switch) devices"
> +	depends on ETHERNET && SOC_SP7021
> +	select PHYLIB
> +	select PINCTRL_SPPCTL
> +	select COMMON_CLK_SP7021
> +	select RESET_SUNPLUS
> +	select NVMEM_SUNPLUS_OCOTP
> +	help
> +	  If you have Sunplus dual 10M/100M Ethernet (with L2 switch)
> +	  devices, say Y.
> +	  The network device supports dual 10M/100M Ethernet interfaces,
> +	  or one 10/100M Ethernet interface with two LAN ports.
> +	  To compile this driver as a module, choose M here.  The module
> +	  will be called sp_l2sw.

Please use NET_VENDOR_SUNPLUS in the same way that other
NET_VENDOR_wyxz kconfig symbols are used. It should just enable
or disable any specific device drivers under it.


-- 
~Randy
