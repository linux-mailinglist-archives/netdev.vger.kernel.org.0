Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCD35621BBB
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 19:19:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234852AbiKHSTk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 13:19:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234851AbiKHSTZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 13:19:25 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C44AA6829C;
        Tue,  8 Nov 2022 10:18:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=/NV/G8kmhD3cnbrD7pOd/P2VxmCy3komDGmfanRTrNU=; b=WRuWJBW4qT8dQ6a/l6dgACTuPR
        Rzv2mQjp7BXfM4QF93HHeV1Hfrgm6tRPREqGBHD0oFRuMLOU5Gr/HGilN28F1aWna01CSTVIPNTbX
        anXvMrGdGfCX/AEEn1QPkKPmy16b8PVFkgOyu5oOBcHeMFhOnjOhQPlwHDP324G1K/qm80A1Earc4
        vT3dSEuj0LIiglQhp7kuQBGiGR7HBiyromRYI1edDX9iIBr/CYzP14pN5Pe5kXtjEnzA5OtECMnmi
        5tPSgRasoFGdH7xpfdmnFa7s5+ZhySv6q+M9hvoNSSDN/iVUx7Cb15Joh/kiI8EQ+ddA4rNmk93Fy
        maKsyy6Q==;
Received: from [2601:1c2:d80:3110::a2e7]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1osTB6-007Pyt-Fl; Tue, 08 Nov 2022 18:18:28 +0000
Message-ID: <d0a8d451-2068-6536-3969-5cdfcd09d595@infradead.org>
Date:   Tue, 8 Nov 2022 10:18:27 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH v4 2/4] soc: ti: Add module build support
Content-Language: en-US
To:     Nicolas Frayer <nfrayer@baylibre.com>, nm@ti.com,
        ssantosh@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, peter.ujfalusi@gmail.com,
        vkoul@kernel.org, dmaengine@vger.kernel.org,
        grygorii.strashko@ti.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     khilman@baylibre.com, glaroque@baylibre.com
References: <20221108181144.433087-1-nfrayer@baylibre.com>
 <20221108181144.433087-3-nfrayer@baylibre.com>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20221108181144.433087-3-nfrayer@baylibre.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi--

On 11/8/22 10:11, Nicolas Frayer wrote:
> Added module build support for the TI K3 SoC info driver.
> 
> Signed-off-by: Nicolas Frayer <nfrayer@baylibre.com>
> ---
>  arch/arm64/Kconfig.platforms |  1 -
>  drivers/soc/ti/Kconfig       |  3 ++-
>  drivers/soc/ti/k3-socinfo.c  | 11 +++++++++++
>  3 files changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/Kconfig.platforms b/arch/arm64/Kconfig.platforms
> index 76580b932e44..4f2f92eb499f 100644
> --- a/arch/arm64/Kconfig.platforms
> +++ b/arch/arm64/Kconfig.platforms
> @@ -130,7 +130,6 @@ config ARCH_K3
>  	select TI_SCI_PROTOCOL
>  	select TI_SCI_INTR_IRQCHIP
>  	select TI_SCI_INTA_IRQCHIP
> -	select TI_K3_SOCINFO
>  	help
>  	  This enables support for Texas Instruments' K3 multicore SoC
>  	  architecture.
> diff --git a/drivers/soc/ti/Kconfig b/drivers/soc/ti/Kconfig
> index 7e2fb1c16af1..1a730c057cce 100644
> --- a/drivers/soc/ti/Kconfig
> +++ b/drivers/soc/ti/Kconfig
> @@ -74,7 +74,8 @@ config TI_K3_RINGACC
>  	  If unsure, say N.
>  
>  config TI_K3_SOCINFO
> -	bool
> +	tristate "TI K3 SoC info driver"
> +	default y

Maybe
	default ARCH_K3
?

>  	depends on ARCH_K3 || COMPILE_TEST
>  	select SOC_BUS
>  	select MFD_SYSCON


-- 
~Randy
