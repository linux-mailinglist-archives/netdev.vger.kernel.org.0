Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80B2E476D0F
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 10:12:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232985AbhLPJM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 04:12:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232627AbhLPJM2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 04:12:28 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88F37C061574;
        Thu, 16 Dec 2021 01:12:27 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id s1so8771530wrg.1;
        Thu, 16 Dec 2021 01:12:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=n9WzHIjXvECnFCwuJsTEEf3R6uxYVIhvGrmbBXUvc6I=;
        b=pPmoimLBuzhj3RdD5eDpNgUb/EXfIxpVN2ot8wiwZQvJMXrVjhIlV2Gn26i3evhDKt
         PHvi42hiCiPPp93orhCeKXUQR91o0dPva1BGcOwVoB3JRHt18cRHSRlG+GUb5KMQ8/MB
         qE8A4KDrd8myE7EVTKbZbELqhmjDUdM9Wag7f+uR+FtO+LCN52NUHOeYk9biiPUD9WCP
         fxDVH4m36fFbqIEhRDCkOiPIyJp6fKbiHxfQ3mTnEX8YJDoV1jnnWCw1btq3f3LlprkZ
         Gb7O3q7Y0MkIX+GT8WvqpNxWxG7I5P3wlsKiXRHXAy20H6J+HbJC+/zvq85OpRQLyHMV
         5IOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=n9WzHIjXvECnFCwuJsTEEf3R6uxYVIhvGrmbBXUvc6I=;
        b=lioy/BHYRt4DkOmlk8nb+wAOj20lEodAG5qcISVyim6nvnzAhLzGe9kHym7inqaT+l
         thhXIaDNYePVF66ZkfF1BngpR51sVttc4+9C8nB2YbadhucZrS/EHnRJwTEGaszYs5Ki
         emMRAsBV0SskrlfTFHDFD9LsQHbZJn+5qpI2h+9cPT3Pyfl4yUUun8a1VaQKAckq7jvL
         LH0pz9FarVpjcRCLCGkFwQBHJpGpBeOcuOWPe8ljSk3ZirhyQc09sofa2Dpb2FKIF3Ai
         EVW3dOwWUwmxvjnUqPyAi7ndkyhJrxbCrDePgoHGk2JO0l3/TdIr0do09nk1slILBpOe
         Nn9A==
X-Gm-Message-State: AOAM532pwxduClcJFUWosTTTLgdaCCxrqwEKEmROaB5JZSdTgMRESlXY
        ejSBupGEUfoOp1lvEzCSrfY=
X-Google-Smtp-Source: ABdhPJxs60m/PyxYGTlZEcF8CS/PSulr+ZJjmwMiF44qcLG5o04D93W6wM1dsEv1ky5z3OFeJHpwCw==
X-Received: by 2002:adf:dbcb:: with SMTP id e11mr7978923wrj.575.1639645946081;
        Thu, 16 Dec 2021 01:12:26 -0800 (PST)
Received: from [192.168.0.18] (81.172.62.207.dyn.user.ono.com. [81.172.62.207])
        by smtp.gmail.com with ESMTPSA id j13sm1561830wms.13.2021.12.16.01.12.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Dec 2021 01:12:25 -0800 (PST)
Message-ID: <c3f49e45-ccfe-dc11-52c5-c204d6f7a889@gmail.com>
Date:   Wed, 15 Dec 2021 20:20:04 +0100
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

I have a hard time to understand how the changes in 1/6 and 2/6 are related to 
that.

Please explain better what has changed. Also beware that we shouldn't introduce 
any non-backward compatible DTS changes. That means, the device should work with 
the new driver but an older device tree.

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
