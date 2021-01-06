Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 087982EC3E5
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 20:29:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbhAFT2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 14:28:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726876AbhAFT2S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 14:28:18 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B73DC06134C;
        Wed,  6 Jan 2021 11:27:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=+J/c7O1SyUrU73qVewpF1FS2o1J0paydkGTz1FrhByQ=; b=JUIp5+HzYMJZQuQ+gJx5lsPF2Z
        naZH+R5lrtlJ0kJrFZ+hJtRrEWKENbGTZjIkzZDV/oVGSB0dnWbsJpq6364GE1ZRTbGn7Hrwc9ecU
        reTWBr057IuyJ+7RSM1w7ATQqzNYAHegbTeLVP7ddYTrHILwv7eZJyJyVyu4NcV7D0Z4sBCzI7QLh
        qyEtWFcoiZHwTCxaTezNPuYoEI0A+nQn0sjxDyxY40iW/VtwCuGXRlt7D+KXZiM/WS+vXY2JPFPgT
        ISXOktj5YWJpZsS8E5zH1dtVns7U05nf4WKnpXEToSiTMXAAoICALKt38dft/alLAPdbT+lLtajWS
        9LNYjXmg==;
Received: from [2601:1c0:6280:3f0::79df]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kxET0-0007oI-JO; Wed, 06 Jan 2021 19:27:34 +0000
Subject: Re: [PATCH net-next] net: broadcom: Drop OF dependency from
 BGMAC_PLATFORM
To:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20210106191546.1358324-1-f.fainelli@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <90e88bac-9ed3-4a96-605e-b4457b3103d2@infradead.org>
Date:   Wed, 6 Jan 2021 11:27:29 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20210106191546.1358324-1-f.fainelli@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/6/21 11:15 AM, Florian Fainelli wrote:
> All of the OF code that is used has stubbed and will compile and link
> just fine, keeping COMPILE_TEST is enough.

Yes, that matches my understanding.

I wish we had a list of which API families have full stub support...

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  drivers/net/ethernet/broadcom/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/Kconfig b/drivers/net/ethernet/broadcom/Kconfig
> index 7b79528d6eed..4bdf8fbe75a6 100644
> --- a/drivers/net/ethernet/broadcom/Kconfig
> +++ b/drivers/net/ethernet/broadcom/Kconfig
> @@ -174,7 +174,6 @@ config BGMAC_BCMA
>  config BGMAC_PLATFORM
>  	tristate "Broadcom iProc GBit platform support"
>  	depends on ARCH_BCM_IPROC || COMPILE_TEST
> -	depends on OF
>  	select BGMAC
>  	select PHYLIB
>  	select FIXED_PHY
> 


-- 
~Randy
