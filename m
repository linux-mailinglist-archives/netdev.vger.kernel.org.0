Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B24046D1E7F
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 12:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231934AbjCaK5v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 06:57:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231811AbjCaK4x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 06:56:53 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C17DF1DFA1;
        Fri, 31 Mar 2023 03:56:36 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id v6-20020a05600c470600b003f034269c96so3343617wmo.4;
        Fri, 31 Mar 2023 03:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680260195;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vZU9pqSmJFWScbRHErpBRLTTVYGZxJgYc6ooM9EOJFo=;
        b=a5YYtQaitITpatbAMwu7SUclPfEBUIKxeJhiA0fQkPl/XebHkXu+q2il+sMxop645y
         kmaXkz15ka80OmpIypiZDmZaRhmt6QgYfRwiSkMjegbxDEjVU9VTl4BUbXtPT4i2CeUb
         PM1BVBi1vjuWl4QezZ+0e6aUa9klF9U2MVlwgIfiqSbXPm7bwCd+7zcsBkkoyxEVkny/
         ocY6y5CLUOq/fK1Jl0b/3bVAJB23LnobybPaEQBgRilZFyd2XqaKpRGFhY76y0Vi7llm
         pqVD5DuWTSsLfPT9tIsCZMkkWelCDqlOy/nSJMAUv6o4l3Hp4g9L97BYFbN36ae+4YfY
         Q5lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680260195;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vZU9pqSmJFWScbRHErpBRLTTVYGZxJgYc6ooM9EOJFo=;
        b=2Fls+FTZq4lb7rqizNuUwOP7p+Fx7NcpqqIiWnkxL7ICHe0SxdOQ18Eh7rVeOy4xQq
         tyw4anDM5BNg85Jk6DVI5s+suw2OCIrmOwoK1MRfKHGKABY3bJbiZNjK4mlqPuN9+Cyq
         DLXKpB6LWaFSl05MGU2AS9CglUp1v9Ikn7QFYqXsoY2flGItjtZ2XOnFqVSJZWN+1Pmw
         T5P2lX26st2TK3FPbQiGQiBFcUrUXM3H7hR7Rc9kEz5yPlwCEUyiVJiKCof19vDsEXZw
         5WBUQvLdm97CSR4egpbV7/9nJvlP5XXH0gAOxANrlsr0h8mCsIskkDf2oiD2P7C4dYOA
         WxVQ==
X-Gm-Message-State: AO0yUKVsZjzyyAIVZoDn5yEWER49ZIi+ZG1dIWnRmDMLLErFWymQnD/T
        noHClhsZYspvtaCJbSkNv8k=
X-Google-Smtp-Source: AK7set8h2IuPF/9IdjhnSRSd7WIlTiiKTDb6jgTDgpp76wEIcv6kA5w6f0BVtbmp63oifX4/aE3nCw==
X-Received: by 2002:a7b:c853:0:b0:3ed:ca62:418e with SMTP id c19-20020a7bc853000000b003edca62418emr19677202wml.9.1680260194637;
        Fri, 31 Mar 2023 03:56:34 -0700 (PDT)
Received: from [192.168.2.177] ([207.188.167.132])
        by smtp.gmail.com with ESMTPSA id q3-20020a05600c46c300b003ebf73acf9asm16683148wmo.3.2023.03.31.03.56.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Mar 2023 03:56:33 -0700 (PDT)
Message-ID: <68a51c57-ba63-94c3-3ca3-f7d4ab4984ae@gmail.com>
Date:   Fri, 31 Mar 2023 12:56:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 10/10] arm64: dts: mt7986: move dlm in a
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
 <d74e38de00ad1b858b59a7ef6cb02321b0faf750.1679330630.git.lorenzo@kernel.org>
From:   Matthias Brugger <matthias.bgg@gmail.com>
In-Reply-To: <d74e38de00ad1b858b59a7ef6cb02321b0faf750.1679330630.git.lorenzo@kernel.org>
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



On 20/03/2023 17:58, Lorenzo Bianconi wrote:
> Since the dlm memory region is not part of the RAM SoC, move dlm in a
> deidicated syscon node.
> This patch helps to keep backward-compatibility with older version of
> uboot codebase where we have a limit of 8 reserved-memory dts child
> nodes.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Acked-by: Matthias Brugger <matthias.bgg@gmail.com>

> ---
>   arch/arm64/boot/dts/mediatek/mt7986a.dtsi | 30 ++++++++++++-----------
>   1 file changed, 16 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
> index a0d96d232ee5..0ae6aa59d3c6 100644
> --- a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
> +++ b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
> @@ -93,16 +93,6 @@ wo_data: wo-data@4fd80000 {
>   			reg = <0 0x4fd80000 0 0x240000>;
>   			no-map;
>   		};
> -
> -		wo_dlm0: wo-dlm@151e8000 {
> -			reg = <0 0x151e8000 0 0x2000>;
> -			no-map;
> -		};
> -
> -		wo_dlm1: wo-dlm@151f8000 {
> -			reg = <0 0x151f8000 0 0x2000>;
> -			no-map;
> -		};
>   	};
>   
>   	timer {
> @@ -444,10 +434,11 @@ wed0: wed@15010000 {
>   			reg = <0 0x15010000 0 0x1000>;
>   			interrupt-parent = <&gic>;
>   			interrupts = <GIC_SPI 205 IRQ_TYPE_LEVEL_HIGH>;
> -			memory-region = <&wo_emi0>, <&wo_dlm0>, <&wo_data>;
> -			memory-region-names = "wo-emi", "wo-dlm", "wo-data";
> +			memory-region = <&wo_emi0>, <&wo_data>;
> +			memory-region-names = "wo-emi", "wo-data";
>   			mediatek,wo-ccif = <&wo_ccif0>;
>   			mediatek,wo-ilm = <&wo_ilm0>;
> +			mediatek,wo-dlm = <&wo_dlm0>;
>   			mediatek,wo-cpuboot = <&wo_cpuboot>;
>   		};
>   
> @@ -457,10 +448,11 @@ wed1: wed@15011000 {
>   			reg = <0 0x15011000 0 0x1000>;
>   			interrupt-parent = <&gic>;
>   			interrupts = <GIC_SPI 206 IRQ_TYPE_LEVEL_HIGH>;
> -			memory-region = <&wo_emi1>, <&wo_dlm1>, <&wo_data>;
> -			memory-region-names = "wo-emi", "wo-dlm", "wo-data";
> +			memory-region = <&wo_emi1>, <&wo_data>;
> +			memory-region-names = "wo-emi", "wo-data";
>   			mediatek,wo-ccif = <&wo_ccif1>;
>   			mediatek,wo-ilm = <&wo_ilm1>;
> +			mediatek,wo-dlm = <&wo_dlm1>;
>   			mediatek,wo-cpuboot = <&wo_cpuboot>;
>   		};
>   
> @@ -488,6 +480,16 @@ wo_ilm1: syscon@151f0000 {
>   			reg = <0 0x151f0000 0 0x8000>;
>   		};
>   
> +		wo_dlm0: syscon@151e8000 {
> +			compatible = "mediatek,mt7986-wo-dlm", "syscon";
> +			reg = <0 0x151e8000 0 0x2000>;
> +		};
> +
> +		wo_dlm1: syscon@151f8000 {
> +			compatible = "mediatek,mt7986-wo-dlm", "syscon";
> +			reg = <0 0x151f8000 0 0x2000>;
> +		};
> +
>   		wo_cpuboot: syscon@15194000 {
>   			compatible = "mediatek,mt7986-wo-cpuboot", "syscon";
>   			reg = <0 0x15194000 0 0x1000>;
