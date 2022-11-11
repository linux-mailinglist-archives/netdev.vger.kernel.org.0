Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8F76254AD
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 08:54:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbiKKHyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 02:54:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232580AbiKKHyR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 02:54:17 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F06163CD6
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 23:54:15 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id bp15so7150999lfb.13
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 23:54:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Eaz8rHIcSO/5c8M2Ayn4zrNXSNjG7GfZ/jdIg1XwOgA=;
        b=J3AbFJ8cIqRzH2fhR1XrH3MnM1HVU4mcGEoyTcJkXXo4nX9J6jc0pwlWZepPocbUuy
         UM2tC8MXwMnBA0JR/RD5ZXj7HLHqHwo80tloQORIVN03iYbvrpJk24yqRxXK9Pg9V6yR
         p3sOD1acn9xRmpilZIZV0alAoaPptkHizT5krAdXP0NMVIyCc5ced+YT4qtoNuLDDvjV
         q93VbSAENLsyODxJFduf9D35vrjtmTYa8/U0/PctnvB+hviiYadtAUDqx6pmdyvdpgSn
         Wgj709hlNgGWEweaFfTqhkWRCxZt7IU3UZWd0ar3g8fmVHKmRX/YpJxX5aTW+firdsiL
         jmwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Eaz8rHIcSO/5c8M2Ayn4zrNXSNjG7GfZ/jdIg1XwOgA=;
        b=V8xXbPqu1SGGcNTcpWmxqlA/mwo1bzqv0GN2NeTSx0xo0VmHcy6JhujKduY8B5hYh0
         Fne0aCMormcf1lybu3q2ty+Na5zHigIS/eUcbzcj3KHZApEaVceZVsqF54nWRH0rbJxV
         DRF7EdnwlyW7VRhtFEGJvJJ6VVuOMHBL/F9iqe6u20bbYV255VoVsMtuVzdCRMmxyxqe
         Vp20BcaTxupWSH68yMkNMFGTp+2c1fBRporoh4x+Ne85vlZ5FwMdf7rPvaBPogW/ujF3
         fra3+a82S0atThhaV5Cy/ac0womraBN7zIklrZnhrhkUgaEgr0OjBykisvv72HJ60KuN
         tZNg==
X-Gm-Message-State: ANoB5pmc2iHwPyenFBUOgLcRcKiNsVTxs6feUId6IAptrbeeucuQZMdj
        6n6FvBQf+X9I2rngr09UB0RiEw==
X-Google-Smtp-Source: AA0mqf4CfAb0ejuNv/vlB1MbMRuCFDuhOchMg6og3ELLn1Igw/6mDt28eQ9V82iX9RY5EZR3O7fcEA==
X-Received: by 2002:ac2:5461:0:b0:4a2:8cac:96ab with SMTP id e1-20020ac25461000000b004a28cac96abmr342005lfn.415.1668153253439;
        Thu, 10 Nov 2022 23:54:13 -0800 (PST)
Received: from [192.168.0.20] (088156142199.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.199])
        by smtp.gmail.com with ESMTPSA id c8-20020a056512324800b004afc1607130sm209411lfr.8.2022.11.10.23.54.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Nov 2022 23:54:12 -0800 (PST)
Message-ID: <21becc16-c69d-5dd1-09d6-b85ee3e5ce9b@linaro.org>
Date:   Fri, 11 Nov 2022 08:54:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v2 1/6] dt-bindings: Document the SYSREG specific
 compatibles found on FSD SoC
Content-Language: en-US
To:     Vivek Yadav <vivek.2311@samsung.com>, rcsekar@samsung.com,
        krzysztof.kozlowski+dt@linaro.org, wg@grandegger.com,
        mkl@pengutronix.de, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, pankaj.dubey@samsung.com,
        ravi.patel@samsung.com, alim.akhtar@samsung.com,
        linux-fsd@tesla.com, robh+dt@kernel.org
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        aswani.reddy@samsung.com, sriranjani.p@samsung.com
References: <20221109100928.109478-1-vivek.2311@samsung.com>
 <CGME20221109100245epcas5p38a01aed025f491d39a09508ebcdcef84@epcas5p3.samsung.com>
 <20221109100928.109478-2-vivek.2311@samsung.com>
 <709daf8b-a58e-9247-c5d8-f3be3e60fe70@linaro.org>
 <000001d8f4f6$1c7e96e0$557bc4a0$@samsung.com>
 <277004ed-3b6b-4ee5-39e4-beb75a272e60@linaro.org>
 <001601d8f583$06d01250$147036f0$@samsung.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <001601d8f583$06d01250$147036f0$@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/11/2022 05:06, Vivek Yadav wrote:
> 
> 
>> -----Original Message-----
>> From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>> Sent: 10 November 2022 17:42
>> To: Vivek Yadav <vivek.2311@samsung.com>; rcsekar@samsung.com;
>> krzysztof.kozlowski+dt@linaro.org; wg@grandegger.com;
>> mkl@pengutronix.de; davem@davemloft.net; edumazet@google.com;
>> kuba@kernel.org; pabeni@redhat.com; pankaj.dubey@samsung.com;
>> ravi.patel@samsung.com; alim.akhtar@samsung.com; linux-fsd@tesla.com;
>> robh+dt@kernel.org
>> Cc: linux-can@vger.kernel.org; netdev@vger.kernel.org; linux-
>> kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org; linux-
>> samsung-soc@vger.kernel.org; devicetree@vger.kernel.org;
>> aswani.reddy@samsung.com; sriranjani.p@samsung.com
>> Subject: Re: [PATCH v2 1/6] dt-bindings: Document the SYSREG specific
>> compatibles found on FSD SoC
>>
>> On 10/11/2022 12:18, Vivek Yadav wrote:
>>>>> +maintainers:
>>>>> +  - Alim Akhtar <alim.akhtar@samsung.com>
>>>>> +
>>>>> +description: |
>>>>> +  This is a system control registers block, providing multiple low
>>>>> +level
>>>>> +  platform functions like board detection and identification,
>>>>> +software
>>>>> +  interrupt generation.
>>>>> +
>>>>> +properties:
>>>>> +  compatible:
>>>>> +    oneOf:
>>>>
>>>> No need for oneOf.
>>>>
>>> Removing this results into dt_binding_check error, so this is required.
>>
>> No, this is not required. You do not have more than one condition for oneOf.
>>
> Oh, ok I got it. I was not removing "-" before items, which is resulting an error. I will update this in next patch series. Sorry for confusion.
>>>>> +      - items:
>>>>> +          - enum:
>>>>> +              - tesla,sysreg_fsys0
>>>>> +              - tesla,sysreg_peric
>>>>
>>>> From where did you get underscores in compatibles?
>>>>
>>> I have seen in MCAN Driver <drivers/net/can/m_can/m_can_platform.c>
>> and also too many other yaml files.
>>> Do you have any ref standard guideline of compatible which says
>> underscore is not allowed.
>>
>> git grep compatible arch/arm64/boot/dts/exynos/ | grep _ git grep
>> compatible arch/arm/boot/dts/exynos* | grep _
>>
>> Both give 0 results. For few other SoCs there such cases but that's really,
>> really exception. Drop underscores.
>>
> git grep compatible arch/arm64/boot/dts/ | grep _ | wc -l 
> This gives me 456 location, am I missing anything here ?

You mean entries like this:

arch/arm64/boot/dts/qcom/pmm8155au_1.dtsi:		compatible =
"qcom,pmm8155au", "qcom,spmi-pmic";

or this:

arch/arm64/boot/dts/microchip/sparx5_pcb135_board.dtsi:		compatible =
"gpio-leds";

or this:

arch/arm64/boot/dts/intel/socfpga_agilex.dtsi:			compatible = "fixed-clock";

And how many compatibles are with hyphen, not underscore?

Best regards,
Krzysztof

