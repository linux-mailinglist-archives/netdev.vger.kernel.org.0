Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFA9226E1FB
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 19:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbgIQROk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 13:14:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbgIQROC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 13:14:02 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8651EC06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 10:14:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=Fak2+gosAv7HTsTLdZACvYkJ60Fv7KUhcaO8dkBtFlM=; b=tZaVU24q42Z+g7j3ZGboOdXH4x
        wvZ2G39/Mvly9+FiQWBZ1ZDk0ply1k1vbGJRMiLh57C6c/pLlHx6X+/7D3qvRk9HSTbHpWSmTOdRW
        jsd1frCzdMQWEV2Cfp7LcbIFpimTWXfeK3/GHZvZPKKVfYKKT+d5+HkQD4B6FT5QYEk/Hkv04XhDe
        pu7DYJtCmQXaXDqFFUCrI10Lb8WeNt2x4KRrcBBy6LtjPKURDZlWsEdfG6e/m933nwv6gDqmlEQf5
        AnHkDjar+1XBq+oCEraGtIrxlGhhqQ+4Zq53qDAiAfkFedlLsGYQ+D9qFAqswPp/xyBiJrE3HuAwy
        MgzAajoA==;
Received: from [2601:1c0:6280:3f0::19c2]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIxTp-0001Ow-Ks; Thu, 17 Sep 2020 17:13:57 +0000
Subject: Re: [PATCH net-next] net: mdio: octeon: Select MDIO_DEVRES
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>
References: <20200917161949.3598839-1-andrew@lunn.ch>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <fca10247-1832-e0f3-6b1f-153a86a070c4@infradead.org>
Date:   Thu, 17 Sep 2020 10:13:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200917161949.3598839-1-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/17/20 9:19 AM, Andrew Lunn wrote:
> This driver makes use of devm_mdiobus_alloc_size. To ensure this is
> available select MDIO_DEVRES which provides it.
> 

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested

Thanks.

> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  drivers/net/mdio/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/mdio/Kconfig b/drivers/net/mdio/Kconfig
> index 1299880dfe74..840727cc9499 100644
> --- a/drivers/net/mdio/Kconfig
> +++ b/drivers/net/mdio/Kconfig
> @@ -138,6 +138,7 @@ config MDIO_OCTEON
>  	depends on (64BIT && OF_MDIO) || COMPILE_TEST
>  	depends on HAS_IOMEM
>  	select MDIO_CAVIUM
> +	select MDIO_DEVRES
>  	help
>  	  This module provides a driver for the Octeon and ThunderX MDIO
>  	  buses. It is required by the Octeon and ThunderX ethernet device
> 


-- 
~Randy
