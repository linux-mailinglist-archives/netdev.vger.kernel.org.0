Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 735E468E9C5
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 09:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230324AbjBHIWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 03:22:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbjBHIWH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 03:22:07 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C78F5B44F
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 00:22:03 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id m8so19326193edd.10
        for <netdev@vger.kernel.org>; Wed, 08 Feb 2023 00:22:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KhVDOtrjgfl3p3xmeZfZNTKzoX1bymO3mmsKmoRlJio=;
        b=WmahEArlGNc6e+SBemlYqrp9e8xwTroRBeySeaKedbWu4MijhmfjVYJUEgErAQnWoc
         Vt0QQCBcvPf80tZmgSS488A+2MDwN20saKS0bNRFi5zll5zOnHpKJHf0mlhZ4jYWmvez
         TKD9Oasj0muKCDFFA6GmsZQEQX6QyAKnHHR/WfKVRrgYCtEu8PtWbXCLgXZnM0FYUg+2
         E4iRXVMGJCYmBdm0YYIZgKuIH0PS675rA0gOKIMXb1eqigGHRJW+xJ+/TmeJNALeZXlX
         ksAA4UzG8Urny0JIXQoqb+i3htcCKOWuMkihlyfc+vYpsaT7YREx+4G8MJn0nDrtFkgU
         48WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KhVDOtrjgfl3p3xmeZfZNTKzoX1bymO3mmsKmoRlJio=;
        b=vZxq8qiPIOLVFlA62Lebjv805Fhz5PjpV/sFFCv0Ra7AYweKnM7qmyOVjCW2JgOxyJ
         pbWqOc93ao7GteB0QFUFwDtBdQFmX0/5XXmA3u+WqGcL4t5zzHFfppiORXB/ZW1PuwiL
         Qw3uGiEUSF6KadXGO3es48IJK34S9nXLRX5ZF3GwvZhxbL/kRzoMqIblJd2VOrbf0xCt
         lOzjhKkaivb2+KU3S+E9B3BNBf7B09y8INeSQWX+YDb1qK34UpQydw4IMPISFZ+Ai5lO
         hPmSY08xVpLNZBNidXwkvn4j9Lo0J4W6BvdxoISiDuHN/kux9zsTs3ra/owK1QATz42x
         3l2g==
X-Gm-Message-State: AO0yUKVlLHS8oaU3uO65WLURvMxPYldAgoDmnozGWRgfwWOgiBWvYonD
        06HHm+iOTfwLNs5q3oTMcLJmFA==
X-Google-Smtp-Source: AK7set97fSbuXgBdSKrixsU3CdVuu2exe5iO5joNKUPY/9E7IjbBhzCdygzGeRrub0jKIcfBG5mtfg==
X-Received: by 2002:a50:cdc8:0:b0:4aa:a4e8:8d5a with SMTP id h8-20020a50cdc8000000b004aaa4e88d5amr6885426edj.33.1675844522341;
        Wed, 08 Feb 2023 00:22:02 -0800 (PST)
Received: from [192.168.1.101] (abxh117.neoplus.adsl.tpnet.pl. [83.9.1.117])
        by smtp.gmail.com with ESMTPSA id p10-20020aa7cc8a000000b004a21c620266sm7513699edt.83.2023.02.08.00.22.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Feb 2023 00:22:02 -0800 (PST)
Message-ID: <6802d77c-f135-ad92-1f28-84a104ca9438@linaro.org>
Date:   Wed, 8 Feb 2023 09:21:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v4 3/4] arm64: dts: qcom: sc8280xp: Define uart2
Content-Language: en-US
To:     Steev Klimaszewski <steev@kali.org>
Cc:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Sven Peter <sven@svenpeter.dev>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Mark Pearson <markpearson@lenovo.com>,
        Brian Masney <bmasney@redhat.com>
References: <20230207052829.3996-1-steev@kali.org>
 <20230207052829.3996-4-steev@kali.org>
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <20230207052829.3996-4-steev@kali.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7.02.2023 06:28, Steev Klimaszewski wrote:
> From: Bjorn Andersson <bjorn.andersson@linaro.org>
> 
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> Signed-off-by: Steev Klimaszewski <steev@kali.org>
> Reviewed-by: Brian Masney <bmasney@redhat.com>
> 
> ---
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>

Konrad
> 
> Changes since v3:
>  * Fix commit message changelog
> 
> Changes since v2:
>  * No changes since v2
> 
> Changes since v1:
>  * change subject line, move node, and add my s-o-b
> ---
>  arch/arm64/boot/dts/qcom/sc8280xp.dtsi | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
> index fa2d0d7d1367..eab54aab3b76 100644
> --- a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
> @@ -1207,6 +1207,20 @@ spi2: spi@988000 {
>  				status = "disabled";
>  			};
>  
> +			uart2: serial@988000 {
> +				compatible = "qcom,geni-uart";
> +				reg = <0 0x00988000 0 0x4000>;
> +				clocks = <&gcc GCC_QUPV3_WRAP0_S2_CLK>;
> +				clock-names = "se";
> +				interrupts = <GIC_SPI 603 IRQ_TYPE_LEVEL_HIGH>;
> +				operating-points-v2 = <&qup_opp_table_100mhz>;
> +				power-domains = <&rpmhpd SC8280XP_CX>;
> +				interconnects = <&clk_virt MASTER_QUP_CORE_0 0 &clk_virt SLAVE_QUP_CORE_0 0>,
> +						<&gem_noc MASTER_APPSS_PROC 0 &config_noc SLAVE_QUP_0 0>;
> +				interconnect-names = "qup-core", "qup-config";
> +				status = "disabled";
> +			};
> +
>  			i2c3: i2c@98c000 {
>  				compatible = "qcom,geni-i2c";
>  				reg = <0 0x0098c000 0 0x4000>;
