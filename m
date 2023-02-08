Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC9C968F86D
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 20:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231975AbjBHTyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 14:54:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231845AbjBHTyf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 14:54:35 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4600225BBD
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 11:54:34 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id r18so594304wmq.5
        for <netdev@vger.kernel.org>; Wed, 08 Feb 2023 11:54:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EBwPASl/5edIqKvU/JIFgLagE7/Ou6YlCS5upqg7x2Y=;
        b=ElaRHWbT/7/TFkvjy6RGL2e17EyHx++x8piD9HhzxfjPN7C6IjJr8KHQqMeSg3iRzn
         JGpO17rXoVb9C0s9qHFsCF+F1dXEfBZveWiAGHPo/FywF3QkBYc7IexMRDmAGf/yx8mm
         62bShvlBrZk/CP6VFbg2i2694PW2cGgn5Dpj4Aqza7z/CQemko/LeJmh7Wl+ZzeyCkJc
         txZM7BLVhLvjW4seK/N+hzNUnLLIcxm7PB3fNWjYU1aleGOUXkUP3VIjiUHcHMDjUf3r
         OKwaTESXnDBfnbQlzDQdqhyJHt4oLjsCUe2T3hW9PRIrn/gnopCojYZCNqLs0mj7k5P7
         7Tmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EBwPASl/5edIqKvU/JIFgLagE7/Ou6YlCS5upqg7x2Y=;
        b=PKm3K2AQTJNeRaeFTJm3AcJoNjalyFGf1IHarKURzqxavRZ2vl/IN1y+tTMEXndq17
         +gdXic9/kBr6ilPh/PjK/YODSJ0CiSFrmBATLDr9R9AA0fDnkuFHvqPSdHKG40dSoZYi
         WuArk2GYAiAIenJT5ohLnOB07N5+E2i8/RQhR/cOjo8mK4+gQFHI3EPAuUkwkeJxXdtV
         Ek7W2k8idg5TzaRxJmZb04f3q7qxzoDcLLQ9egL7LWr1Hp+hI5xn7r+TANYwBMH+jgTo
         bLBKSM6djBB9TqaHx1b2Sn6b6z074L574ugEMWIEKehScBizOj9yS2adwRMJkczDEErU
         Unww==
X-Gm-Message-State: AO0yUKWRMjhzGiDf8VNj6EIHzMs4QbuiMyC9HrQuwx7Hxh8ioLDAuVyw
        UMHV7CuT2pqEPWU/VW+e4ped9Q==
X-Google-Smtp-Source: AK7set+AS16QvAEzA43WSGcYuIpVX6rFu8GnlDVRV5HqJSp5kzSyNf3stjXk01gH7tABGuOR8dPMlA==
X-Received: by 2002:a05:600c:358b:b0:3df:9858:c02e with SMTP id p11-20020a05600c358b00b003df9858c02emr3319270wmq.3.1675886072898;
        Wed, 08 Feb 2023 11:54:32 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id c12-20020a05600c0a4c00b003dc34edacf8sm3260834wmq.31.2023.02.08.11.54.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Feb 2023 11:54:32 -0800 (PST)
Message-ID: <74240c25-cbbe-1e72-b56b-13124111b390@linaro.org>
Date:   Wed, 8 Feb 2023 20:54:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next v2 6/6] ARM: dts: r9a06g032: describe GMAC1
Content-Language: en-US
To:     =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Wong Vee Khee <veekhee@apple.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Revanth Kumar Uppala <ruppala@nvidia.com>,
        Tan Tee Min <tee.min.tan@linux.intel.com>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?Q?Miqu=c3=a8l_Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Jon Hunter <jonathanh@nvidia.com>, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
References: <20230208164203.378153-1-clement.leger@bootlin.com>
 <20230208164203.378153-7-clement.leger@bootlin.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230208164203.378153-7-clement.leger@bootlin.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/02/2023 17:42, Clément Léger wrote:
> RZ/N1 SoC includes two MAC named GMACx that are compatible with the
> "snps,dwmac" driver. GMAC1 is connected directly to the MII converter
> port 1. Since this MII converter is represented using a PCS driver, it
> uses the renesas specific compatible driver which uses this PCS.
> 
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> ---
>  arch/arm/boot/dts/r9a06g032.dtsi | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/r9a06g032.dtsi b/arch/arm/boot/dts/r9a06g032.dtsi
> index 41e19c0986ce..ba32e4429b01 100644
> --- a/arch/arm/boot/dts/r9a06g032.dtsi
> +++ b/arch/arm/boot/dts/r9a06g032.dtsi
> @@ -304,6 +304,24 @@ dma1: dma-controller@40105000 {
>  			data-width = <8>;
>  		};
>  
> +		gmac1: ethernet@44000000 {
> +			compatible = "renesas,r9a06g032-gmac", "renesas,rzn1-gmac", "snps,dwmac";

Please test your DTS against the binding you send. If you did it, you
would see here that the binding does not work and needs fixes... The
difference between your DTS and your example should also warn you that
it's not correct.

Best regards,
Krzysztof

