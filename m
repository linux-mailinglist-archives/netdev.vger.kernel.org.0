Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 350C347619D
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 20:23:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344222AbhLOTXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 14:23:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344200AbhLOTXB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 14:23:01 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B20D8C061574;
        Wed, 15 Dec 2021 11:23:00 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id i12so17397519wmq.4;
        Wed, 15 Dec 2021 11:23:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ZYwgBJaj/unectxNhsPO9gtbst5oHKfm3K6XFRszQRI=;
        b=Q8NaUFUtT9c0f6DWp6vcNspUZhwLnLLSM/MRmWvwOXoaGLFgWTvznHeCK6G6Lv934a
         M64NfrQya2KQIzKh01W+U12Fc7ldmtVW9/QKNPPcJfW98omhxwTAOLoQ1tnf9uozXYFR
         NhqMlEouQ17uLSmCToamGDc9h6NyMYGaKDiYqrTPVJu/H03fyy6Qkf27XcnGnbhzzBnl
         2L+yId8J8VjvBTK3Jdi7/LtTrlpECXazAnNo0EWmPimXS9G6qtvsCBIYC7zN/DXF26LE
         dcIzRF8iQwU8dwLNXKqq2yrKot8R+jQPOyNSsNpSZWudcWz1a4njmkaYgWQJYoR8yS3E
         9mIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZYwgBJaj/unectxNhsPO9gtbst5oHKfm3K6XFRszQRI=;
        b=q8p2AVeMbEGjmPMBb3HZloHrIYrnWcsMLhKx2NmntDpAjp7+tAX4g5vYwKp3w2TX4F
         dJBBEY3eefwhMvgWxREEzOlcrFgoG0dnAYwzCjbiMJZ6lz/lxVhzN3II4haNv1z1Ay8H
         xo2m+m8DCg8UlMWWUd7f+P/sbnuc631/oAmVTm107CcNfkece6fgpLE+3OTpWMa6rJHn
         OrL5CbT83ZauBZgjJMaVchGU+kwWmQh4tzAL/5ntDcNHoMzJF0VDbxGAL+k+mTHc3Xln
         V9428IzKcJG4jmv/NtWwP6du+LrqyJ3kor/0s5i+1vIvPYxE4jwLE30VVuQyL0xs6fVa
         gmgQ==
X-Gm-Message-State: AOAM531Mw61kyU5SJw/bJ6IJk+cwxGbiI1M0ll6gIN1Xv8JeGjXmFToU
        anbzl7HFOp/wIrO+mcIWFp0=
X-Google-Smtp-Source: ABdhPJwNwyh4XxuqT5udvlzXiwRG9boU1Qdrw7Pw7evZ7Hxcwq1PG3znUeUEH0XlTzDd6waANd8aVg==
X-Received: by 2002:a05:600c:3788:: with SMTP id o8mr1574047wmr.82.1639596179243;
        Wed, 15 Dec 2021 11:22:59 -0800 (PST)
Received: from [192.168.0.18] (81.172.62.207.dyn.user.ono.com. [81.172.62.207])
        by smtp.gmail.com with ESMTPSA id m17sm2676457wrw.11.2021.12.15.11.22.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Dec 2021 11:22:58 -0800 (PST)
Message-ID: <c9b3d31a-1c18-32ec-8077-603bb93fe8d0@gmail.com>
Date:   Wed, 15 Dec 2021 20:22:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH net-next v8 3/6] arm64: dts: mt2712: update ethernet
 device node
Content-Language: en-US
To:     Biao Huang <biao.huang@mediatek.com>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        srv_heupstream@mediatek.com, macpaul.lin@mediatek.com,
        angelogioacchino.delregno@collabora.com, dkirjanov@suse.de
References: <20211210013129.811-1-biao.huang@mediatek.com>
 <20211210013129.811-4-biao.huang@mediatek.com>
From:   Matthias Brugger <matthias.bgg@gmail.com>
In-Reply-To: <20211210013129.811-4-biao.huang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/12/2021 02:31, Biao Huang wrote:
> Since there are some changes in ethernet driver,
> update ethernet device node in dts to accommodate to it.
> 

I have a hard time to understand how the first two patches are related to this 
one. Please be more specific in your commit message.

Also please beware that we should make sure that a newer driver version should 
still work properly with an older device tree, which does not have your changes.

Regards,
Matthias

> Signed-off-by: Biao Huang <biao.huang@mediatek.com>
> ---
>   arch/arm64/boot/dts/mediatek/mt2712-evb.dts |  1 +
>   arch/arm64/boot/dts/mediatek/mt2712e.dtsi   | 14 +++++++++-----
>   2 files changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/boot/dts/mediatek/mt2712-evb.dts b/arch/arm64/boot/dts/mediatek/mt2712-evb.dts
> index 7d369fdd3117..11aa135aa0f3 100644
> --- a/arch/arm64/boot/dts/mediatek/mt2712-evb.dts
> +++ b/arch/arm64/boot/dts/mediatek/mt2712-evb.dts
> @@ -110,6 +110,7 @@ &eth {
>   	phy-handle = <&ethernet_phy0>;
>   	mediatek,tx-delay-ps = <1530>;
>   	snps,reset-gpio = <&pio 87 GPIO_ACTIVE_LOW>;
> +	snps,reset-delays-us = <0 10000 10000>;
>   	pinctrl-names = "default", "sleep";
>   	pinctrl-0 = <&eth_default>;
>   	pinctrl-1 = <&eth_sleep>;
> diff --git a/arch/arm64/boot/dts/mediatek/mt2712e.dtsi b/arch/arm64/boot/dts/mediatek/mt2712e.dtsi
> index a9cca9c146fd..9e850e04fffb 100644
> --- a/arch/arm64/boot/dts/mediatek/mt2712e.dtsi
> +++ b/arch/arm64/boot/dts/mediatek/mt2712e.dtsi
> @@ -726,7 +726,7 @@ queue2 {
>   	};
>   
>   	eth: ethernet@1101c000 {
> -		compatible = "mediatek,mt2712-gmac";
> +		compatible = "mediatek,mt2712-gmac", "snps,dwmac-4.20a";
>   		reg = <0 0x1101c000 0 0x1300>;
>   		interrupts = <GIC_SPI 237 IRQ_TYPE_LEVEL_LOW>;
>   		interrupt-names = "macirq";
> @@ -734,15 +734,19 @@ eth: ethernet@1101c000 {
>   		clock-names = "axi",
>   			      "apb",
>   			      "mac_main",
> -			      "ptp_ref";
> +			      "ptp_ref",
> +			      "rmii_internal";
>   		clocks = <&pericfg CLK_PERI_GMAC>,
>   			 <&pericfg CLK_PERI_GMAC_PCLK>,
>   			 <&topckgen CLK_TOP_ETHER_125M_SEL>,
> -			 <&topckgen CLK_TOP_ETHER_50M_SEL>;
> +			 <&topckgen CLK_TOP_ETHER_50M_SEL>,
> +			 <&topckgen CLK_TOP_ETHER_50M_RMII_SEL>;
>   		assigned-clocks = <&topckgen CLK_TOP_ETHER_125M_SEL>,
> -				  <&topckgen CLK_TOP_ETHER_50M_SEL>;
> +				  <&topckgen CLK_TOP_ETHER_50M_SEL>,
> +				  <&topckgen CLK_TOP_ETHER_50M_RMII_SEL>;
>   		assigned-clock-parents = <&topckgen CLK_TOP_ETHERPLL_125M>,
> -					 <&topckgen CLK_TOP_APLL1_D3>;
> +					 <&topckgen CLK_TOP_APLL1_D3>,
> +					 <&topckgen CLK_TOP_ETHERPLL_50M>;
>   		power-domains = <&scpsys MT2712_POWER_DOMAIN_AUDIO>;
>   		mediatek,pericfg = <&pericfg>;
>   		snps,axi-config = <&stmmac_axi_setup>;
> 
