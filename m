Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 071FF616D23
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 19:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231678AbiKBStp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 14:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231754AbiKBSt2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 14:49:28 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14D7431220
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 11:49:14 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id s20so5966449qkg.5
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 11:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vJYNZtf6bcoMnKqaGiq/9/aXJ5dsTFIfamsATLeB19E=;
        b=su9C3G8MIg7QWTFg8X40a81l1pos9whecNkXv05SZCVv+Ifq5/Lnwt2vr1Mb3MLuIQ
         jRDedwfIwrB71P37sh22Y4/0wD8UqyzKEZzEh02MJZUwMEQFcO5dOUAFaR9UtAPt36jH
         +NNP2HWHC6hFOsr/iEvUj7AbwFGSyb5wYB88wcSSpZEO6YR7ELmy9c791KfrDJIMxUYI
         ooT60YMIA4kC6fqE9keso+2NvSE2Feil4aQJ8LtpS3yIsbOa+wFRCid3h08+7r2uhoew
         ZtyOTEQ0l+lhc07lbsGCV/lSw+Lt1gs5woqu8nyK9eFwAXAXjC6jh7xz6zZX0hR+um9A
         x4Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vJYNZtf6bcoMnKqaGiq/9/aXJ5dsTFIfamsATLeB19E=;
        b=BSoS5/Y13vel3DCZBa9In4LgLb4z/lK4zNL6je0LYC5uz5iLZ++sRENIA6ciDmcSxF
         +0rKH4R9XaTxCijrBebSFjfm2R4uRhirSUwudDzdliU06+W6CTmOA7sMBsVrd36NTSOy
         uBphDzaiPN20NUQ7msGLIZpzl3+crX+bb3KE4fDNi5+XbEyhFqbwcXbqxpZAkS7DwVev
         XJDSTyvcOmFs99w0UY7DevR49M+JU6l9kQ+jBvR52GwIDh0wFAgjDym/Dur0kgSvpZ7t
         J14SNnNRD9aa8t9BfIQRmuUo/KosI4WFj/KZyZeLKwbZyC9GWlovsfe5p1xg76GVtM/x
         dx4A==
X-Gm-Message-State: ACrzQf1TFb/6brciUSNjz9yB3NhsKNaoIyfxCg6adNcKgTrlyIM+Pqs7
        kCaRKz+X4I5vuMeHEJaQRg8/xA==
X-Google-Smtp-Source: AMsMyM4QrsNd0t8S2FzfTh26X1GqKLWJtIRgo6E0399IOn8EDRnsAkEWhLADnj/2PxhsqfSVcY2Vlg==
X-Received: by 2002:a37:65c9:0:b0:6fa:1ef8:fa10 with SMTP id z192-20020a3765c9000000b006fa1ef8fa10mr15636685qkb.648.1667414953134;
        Wed, 02 Nov 2022 11:49:13 -0700 (PDT)
Received: from ?IPV6:2601:586:5000:570:28d9:4790:bc16:cc93? ([2601:586:5000:570:28d9:4790:bc16:cc93])
        by smtp.gmail.com with ESMTPSA id q4-20020ac87344000000b0039442ee69c5sm6861556qtp.91.2022.11.02.11.49.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Nov 2022 11:49:12 -0700 (PDT)
Message-ID: <f387a864-5683-f4a1-ee9a-3c92b2ca5e1c@linaro.org>
Date:   Wed, 2 Nov 2022 14:49:11 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH] dt-bindings: net: nxp,sja1105: document spi-cpol
Content-Language: en-US
To:     Rob Herring <robh@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-kernel@vger.kernel.org
References: <20221102161211.51139-1-krzysztof.kozlowski@linaro.org>
 <166741398630.127357.13160524174654511434.robh@kernel.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <166741398630.127357.13160524174654511434.robh@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/11/2022 14:35, Rob Herring wrote:
> 
> On Wed, 02 Nov 2022 12:12:11 -0400, Krzysztof Kozlowski wrote:
>> Some boards use SJA1105 Ethernet Switch with SPI CPOL, so document this
>> to fix dtbs_check warnings:
>>
>>   arch/arm64/boot/dts/freescale/fsl-lx2160a-bluebox3.dtb: ethernet-switch@0: Unevaluated properties are not allowed ('spi-cpol' was unexpected)
>>
>> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>> ---
>>  Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml | 2 ++
>>  1 file changed, 2 insertions(+)
>>
> 
> Running 'make dtbs_check' with the schema in this patch gives the
> following warnings. Consider if they are expected or the schema is
> incorrect. These may not be new warnings.
> 
> Note that it is not yet a requirement to have 0 warnings for dtbs_check.
> This will change in the future.
> 
> Full log is available here: https://patchwork.ozlabs.org/patch/
> 
> 
> ethernet-switch@1: Unevaluated properties are not allowed ('#address-cells', '#size-cells', 'fsl,spi-cs-sck-delay', 'fsl,spi-sck-cs-delay', 'spi-cpha' were unexpected)
> 	arch/arm/boot/dts/ls1021a-tsn.dtb

I'll add cpha, but fsl,spi-cs-sck-delay are coming from unconverted
schema - spi-fsl-dspi.txt.

> 
> switch@0: Unevaluated properties are not allowed ('clocks', 'reset-gpios', 'spi-cpha' were unexpected)
> 	arch/arm/boot/dts/imx6qp-prtwd3.dtb
> 	arch/arm/boot/dts/stm32mp151a-prtt1c.dtb
> 

Best regards,
Krzysztof

