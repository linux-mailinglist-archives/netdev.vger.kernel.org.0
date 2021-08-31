Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAC0A3FCAF7
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 17:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239535AbhHaPio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 11:38:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:57982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232421AbhHaPio (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 11:38:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CFAC60F56;
        Tue, 31 Aug 2021 15:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630424268;
        bh=VDHFOreIvzI+zKNvjOPC35mt06/2Doj19pp6QxlLypw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hY1NRDWjPO9vYlTGLPp3WxAvzAe3I4QokVij31H3tNSEwcHUF6mn1FBM1VjalHY0e
         hvHImetYGb/L/hXh/lT5Wfi3BeLdqav8EYMEGXIf/qKrayaY/EaARO89z9UraTw2dz
         6etDNfkRxrooSimezmdZlVugOS1QugLYPP/J0ab6OhCknJMEIRUjaT14EB01bIkN+Z
         Gud0Nl5aSNtmk1hAh8+FSEDw44NS4VdLi3FilgjX4twTDC4FBlJ8CaibBMbQwSQSmV
         HGWd4/3U1Oy36maDiq6hQlU2VbZIA09ecZ5yqg/qwl2YgH0ScIIoZcKwu3bj+WsZ0U
         xQfhw3e3l8XAA==
Date:   Tue, 31 Aug 2021 08:37:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Slark Xiao <slark_xiao@163.com>
Cc:     davem@davemloft.net, joel@jms.id.au, gsomlo@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: Add depends on OF_NET for LiteX's LiteETH
Message-ID: <20210831083747.4c958890@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210831024025.355748-1-slark_xiao@163.com>
References: <20210831024025.355748-1-slark_xiao@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 31 Aug 2021 10:40:25 +0800 Slark Xiao wrote:
> Current settings may produce a build error when
> CONFIG_OF_NET is disabled. The CONFIG_OF_NET controls
> a headfile <linux/of.h> and some functions
>  in <linux/of_net.h>.
> 
> Signed-off-by: Slark Xiao <slark_xiao@163.com>
> ---
>  drivers/net/ethernet/litex/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/litex/Kconfig b/drivers/net/ethernet/litex/Kconfig
> index 265dba414b41..63bf01d28f0c 100644
> --- a/drivers/net/ethernet/litex/Kconfig
> +++ b/drivers/net/ethernet/litex/Kconfig
> @@ -17,6 +17,7 @@ if NET_VENDOR_LITEX
>  
>  config LITEX_LITEETH
>  	tristate "LiteX Ethernet support"
> +	depends on OF_NET
>  	help
>  	  If you wish to compile a kernel for hardware with a LiteX LiteEth
>  	  device then you should answer Y to this.

Applied, thanks!
