Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63C556D1E69
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 12:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231781AbjCaK4n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 06:56:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231624AbjCaK4Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 06:56:25 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 237081D86D;
        Fri, 31 Mar 2023 03:56:13 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id h17so21939435wrt.8;
        Fri, 31 Mar 2023 03:56:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680260172;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Pqmnq8xzZa2lyHXyUpObVSAYBy1mnUzOiASQNzSsq1g=;
        b=QDM2PWvm87vJ3RBhg9ErLSog6GEvxd/aECLGrRIkxjjCc47hgT80288j24Dk+6xjVv
         UEUExJ869nFUJgpFweDD9C7mpTALZa142ujLEu+PRqeeX7DvnvNL5K8HoU6GzuUg0RTE
         kIlWUX4DKZla58KFRtz2ixSIPr/w9J9SSbSaqREJK67rZjlFHLqD+DfsCtwxNQklMpBH
         ljMygivHqbQ79QHaVlz4nhKExKTFvOzh9+EIPOOLF8Ep+RZMbDTKYm+B72smb9uAIBb6
         2US56v/Kxj0kA3y82U1V4Tb5fXrqAsh15MLP9lswnx8b3jyMAKqhq4W9ltj2Lo11nN30
         6PKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680260172;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Pqmnq8xzZa2lyHXyUpObVSAYBy1mnUzOiASQNzSsq1g=;
        b=OFJr3HZvTjSOWooRUJHNMhV8YL4SO9P5K+lX4JWlxRjX1Svcp6K5MYv2UczWnecPqb
         ERiVeICudIJN26a7N8fevExi0xDQwSpOjrcsxrN9nSnRuzGdXCVSKCeULg4IvEFB3ahN
         BjcHkVDvQDlH6cq+Pk97MByzvzlUSw68B9BuCpVePDte1dQ9xeqLxblYu92iqs8YvcG3
         uTGFJg4ldB9jHSXtK5ruRq2iR95kTht9vquptqyuZcnkxkytQLCX03Mukxs6Ik9T26Og
         mbd8H6/0tj1Kk6z0ARJkOiP9LI81D+Dy1rQZatRZOHFFrDW2z9MEzAWwU3O5B32b+eI4
         Fk1w==
X-Gm-Message-State: AAQBX9d/vkupaF3bBVFIf+GySPngST5CfXF4xcUq+c7So0LUMABUYL9k
        IlgOxSmBawZIxcB0UJ4nx5I=
X-Google-Smtp-Source: AKy350bjkArNEhmupglrT3ehOhjiY0S0rZcbOJKvYhK/laZUWUToLhEdQrcMcm4Z880g2mEcZsGN0g==
X-Received: by 2002:a5d:49d0:0:b0:2cf:2dcc:3421 with SMTP id t16-20020a5d49d0000000b002cf2dcc3421mr20544873wrs.5.1680260172315;
        Fri, 31 Mar 2023 03:56:12 -0700 (PDT)
Received: from [192.168.2.177] ([207.188.167.132])
        by smtp.gmail.com with ESMTPSA id r16-20020adfdc90000000b002cff06039d7sm1897271wrj.39.2023.03.31.03.56.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Mar 2023 03:56:11 -0700 (PDT)
Message-ID: <82091587-3d4a-eec2-b3d0-7635dc9ef7b0@gmail.com>
Date:   Fri, 31 Mar 2023 12:56:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 07/10] arm64: dts: mt7986: move ilm in a
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
 <5e1168bc8fd29f4871f81d8e4a9fd43a2c3be146.1679330630.git.lorenzo@kernel.org>
From:   Matthias Brugger <matthias.bgg@gmail.com>
In-Reply-To: <5e1168bc8fd29f4871f81d8e4a9fd43a2c3be146.1679330630.git.lorenzo@kernel.org>
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
> Since the ilm memory region is not part of the RAM SoC, move ilm in a
> deidicated syscon node.
> This patch helps to keep backward-compatibility with older version of
> uboot codebase where we have a limit of 8 reserved-memory dts child
> nodes.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Acked-by: Matthias Brugger <matthias.bgg@gmail.com>

> ---
>   arch/arm64/boot/dts/mediatek/mt7986a.dtsi | 34 +++++++++++------------
>   1 file changed, 16 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
> index 668b6cfa6a3d..a0d96d232ee5 100644
> --- a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
> +++ b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
> @@ -89,16 +89,6 @@ wo_emi1: wo-emi@4fd40000 {
>   			no-map;
>   		};
>   
> -		wo_ilm0: wo-ilm@151e0000 {
> -			reg = <0 0x151e0000 0 0x8000>;
> -			no-map;
> -		};
> -
> -		wo_ilm1: wo-ilm@151f0000 {
> -			reg = <0 0x151f0000 0 0x8000>;
> -			no-map;
> -		};
> -
>   		wo_data: wo-data@4fd80000 {
>   			reg = <0 0x4fd80000 0 0x240000>;
>   			no-map;
> @@ -454,11 +444,10 @@ wed0: wed@15010000 {
>   			reg = <0 0x15010000 0 0x1000>;
>   			interrupt-parent = <&gic>;
>   			interrupts = <GIC_SPI 205 IRQ_TYPE_LEVEL_HIGH>;
> -			memory-region = <&wo_emi0>, <&wo_ilm0>, <&wo_dlm0>,
> -					<&wo_data>;
> -			memory-region-names = "wo-emi", "wo-ilm", "wo-dlm",
> -					      "wo-data";
> +			memory-region = <&wo_emi0>, <&wo_dlm0>, <&wo_data>;
> +			memory-region-names = "wo-emi", "wo-dlm", "wo-data";
>   			mediatek,wo-ccif = <&wo_ccif0>;
> +			mediatek,wo-ilm = <&wo_ilm0>;
>   			mediatek,wo-cpuboot = <&wo_cpuboot>;
>   		};
>   
> @@ -468,11 +457,10 @@ wed1: wed@15011000 {
>   			reg = <0 0x15011000 0 0x1000>;
>   			interrupt-parent = <&gic>;
>   			interrupts = <GIC_SPI 206 IRQ_TYPE_LEVEL_HIGH>;
> -			memory-region = <&wo_emi1>, <&wo_ilm1>, <&wo_dlm1>,
> -					<&wo_data>;
> -			memory-region-names = "wo-emi", "wo-ilm", "wo-dlm",
> -					      "wo-data";
> +			memory-region = <&wo_emi1>, <&wo_dlm1>, <&wo_data>;
> +			memory-region-names = "wo-emi", "wo-dlm", "wo-data";
>   			mediatek,wo-ccif = <&wo_ccif1>;
> +			mediatek,wo-ilm = <&wo_ilm1>;
>   			mediatek,wo-cpuboot = <&wo_cpuboot>;
>   		};
>   
> @@ -490,6 +478,16 @@ wo_ccif1: syscon@151ad000 {
>   			interrupts = <GIC_SPI 212 IRQ_TYPE_LEVEL_HIGH>;
>   		};
>   
> +		wo_ilm0: syscon@151e0000 {
> +			compatible = "mediatek,mt7986-wo-ilm", "syscon";
> +			reg = <0 0x151e0000 0 0x8000>;
> +		};
> +
> +		wo_ilm1: syscon@151f0000 {
> +			compatible = "mediatek,mt7986-wo-ilm", "syscon";
> +			reg = <0 0x151f0000 0 0x8000>;
> +		};
> +
>   		wo_cpuboot: syscon@15194000 {
>   			compatible = "mediatek,mt7986-wo-cpuboot", "syscon";
>   			reg = <0 0x15194000 0 0x1000>;
