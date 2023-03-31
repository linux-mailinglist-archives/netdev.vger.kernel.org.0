Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71BFA6D1E5E
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 12:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231761AbjCaKyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 06:54:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231751AbjCaKyD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 06:54:03 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10F731D84D;
        Fri, 31 Mar 2023 03:54:01 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id n19so12645169wms.0;
        Fri, 31 Mar 2023 03:54:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680260040;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3J+3+QpiG0rZpOXhX+ZLI6+BIv55R5IPb8nvts5K8P4=;
        b=DIb00x/wP2+VNwtse4AjeksMmJYcP/m3kkgofcXigSzJbtsa8dp4dAO21pZFD7qQUU
         15qFAwsU+bZkjUqKIh4QmamsHAqhlpNn8EnTq0aOcnxQO1dC3p5x2P5dIJFuEDxirDrj
         nMVEnclZDcNibiIh1V24XwNVjSIzq6Yifjq2o6lVNaJe4i+UADRgncqdhM2i9ivNJ+/I
         FjujLjbEGo8OMQSOQJBKWbQBTvzLG7tMkh5PsvQFvauSGA4Q3eMQSqDweHbsVM9M6cCW
         93vkolzYF1L0Tdxate2IKdw+vcQiHtO4wQvD85QFVhLTBSwP4OtIs/WJpny77DbsfMFU
         xHzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680260040;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3J+3+QpiG0rZpOXhX+ZLI6+BIv55R5IPb8nvts5K8P4=;
        b=jKP5eAlmLzof6QcLKCTbc1gKusliTqcnS+QnPwmIiCzGORMkqGBkFMuFvL9pHs1iJJ
         ynawUDqvDWlJiNAUYMSrmnLEFM6xBt4Vwavp2+0m1O7YTkyIOLCzZGlu8QSeD8E/UWhO
         ebu65AyVKhtoIy4Y7d0BFH+uv4JQqAKfMX7g3hbfptnkzdXTZq0+3JkfmgLQleoGLEg+
         8axmQ8MIOwHvd3LjFXB5YchK4leXTLDjOHyhX+/5Ogs7zskGj3A12IbrF/Lq1I+89TI2
         XousNlJPWz5ustFEbddqKSXrxMGUhJAVPo97ZaeWwE2S+Aad1hhJ0evz21/fiPVbjWFO
         Y1PA==
X-Gm-Message-State: AO0yUKWNKaqFMP/cqtodD1q7rxcDs4ts0iZMfQ0T7b7Bpwj0U8Mv8O9S
        U0J7gyGu25VzDwazw1iVcTMVIO1K8CgTWQ==
X-Google-Smtp-Source: AK7set/6UKDxNUN/UAOYCRqLFd1+/gfqy+fFYklR/RihAmzcjc7b7iRIySxIy8jSOxMBFSTH9pG8Eg==
X-Received: by 2002:a1c:7911:0:b0:3ee:5754:f14b with SMTP id l17-20020a1c7911000000b003ee5754f14bmr20711685wme.3.1680260040071;
        Fri, 31 Mar 2023 03:54:00 -0700 (PDT)
Received: from [192.168.2.177] ([207.188.167.132])
        by smtp.gmail.com with ESMTPSA id l24-20020a1c7918000000b003e203681b26sm2273068wme.29.2023.03.31.03.53.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Mar 2023 03:53:59 -0700 (PDT)
Message-ID: <5defb636-1f0f-6a6c-3c10-e8960b7d4399@gmail.com>
Date:   Fri, 31 Mar 2023 12:53:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 04/10] arm64: dts: mt7986: move cpuboot in a
 dedicated node
Content-Language: en-US
To:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-mediatek@lists.infradead.org,
        nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, lorenzo.bianconi@redhat.com,
        daniel@makrotopia.org, krzysztof.kozlowski+dt@linaro.org,
        robh+dt@kernel.org, devicetree@vger.kernel.org
References: <cover.1679330630.git.lorenzo@kernel.org>
 <61e2445f79d8642e7749dac409e2b93b96667610.1679330630.git.lorenzo@kernel.org>
From:   Matthias Brugger <matthias.bgg@gmail.com>
In-Reply-To: <61e2445f79d8642e7749dac409e2b93b96667610.1679330630.git.lorenzo@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 20/03/2023 17:57, Lorenzo Bianconi wrote:
> Since the cpuboot memory region is not part of the RAM SoC, move cpuboot
> in a deidicated syscon node.
> This patch helps to keep backward-compatibility with older version of
> uboot codebase where we have a limit of 8 reserved-memory dts child
> nodes.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Acked-by: Matthias Brugger <matthias.bgg@gmail.com>

> ---
>   arch/arm64/boot/dts/mediatek/mt7986a.dtsi | 21 +++++++++++----------
>   1 file changed, 11 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
> index 51944690e790..668b6cfa6a3d 100644
> --- a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
> +++ b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
> @@ -113,12 +113,6 @@ wo_dlm1: wo-dlm@151f8000 {
>   			reg = <0 0x151f8000 0 0x2000>;
>   			no-map;
>   		};
> -
> -		wo_boot: wo-boot@15194000 {
> -			reg = <0 0x15194000 0 0x1000>;
> -			no-map;
> -		};
> -
>   	};
>   
>   	timer {
> @@ -461,10 +455,11 @@ wed0: wed@15010000 {
>   			interrupt-parent = <&gic>;
>   			interrupts = <GIC_SPI 205 IRQ_TYPE_LEVEL_HIGH>;
>   			memory-region = <&wo_emi0>, <&wo_ilm0>, <&wo_dlm0>,
> -					<&wo_data>, <&wo_boot>;
> +					<&wo_data>;
>   			memory-region-names = "wo-emi", "wo-ilm", "wo-dlm",
> -					      "wo-data", "wo-boot";
> +					      "wo-data";
>   			mediatek,wo-ccif = <&wo_ccif0>;
> +			mediatek,wo-cpuboot = <&wo_cpuboot>;
>   		};
>   
>   		wed1: wed@15011000 {
> @@ -474,10 +469,11 @@ wed1: wed@15011000 {
>   			interrupt-parent = <&gic>;
>   			interrupts = <GIC_SPI 206 IRQ_TYPE_LEVEL_HIGH>;
>   			memory-region = <&wo_emi1>, <&wo_ilm1>, <&wo_dlm1>,
> -					<&wo_data>, <&wo_boot>;
> +					<&wo_data>;
>   			memory-region-names = "wo-emi", "wo-ilm", "wo-dlm",
> -					      "wo-data", "wo-boot";
> +					      "wo-data";
>   			mediatek,wo-ccif = <&wo_ccif1>;
> +			mediatek,wo-cpuboot = <&wo_cpuboot>;
>   		};
>   
>   		wo_ccif0: syscon@151a5000 {
> @@ -494,6 +490,11 @@ wo_ccif1: syscon@151ad000 {
>   			interrupts = <GIC_SPI 212 IRQ_TYPE_LEVEL_HIGH>;
>   		};
>   
> +		wo_cpuboot: syscon@15194000 {
> +			compatible = "mediatek,mt7986-wo-cpuboot", "syscon";
> +			reg = <0 0x15194000 0 0x1000>;
> +		};
> +
>   		eth: ethernet@15100000 {
>   			compatible = "mediatek,mt7986-eth";
>   			reg = <0 0x15100000 0 0x80000>;
