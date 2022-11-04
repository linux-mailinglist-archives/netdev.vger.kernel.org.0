Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52F41618DBA
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 02:44:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231226AbiKDBom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 21:44:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231180AbiKDBol (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 21:44:41 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A3CA23E8D
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 18:44:39 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id e15so2361096qts.1
        for <netdev@vger.kernel.org>; Thu, 03 Nov 2022 18:44:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hT/SdExSBeWqGOeMZwtQU19dNytAw9YzFepcl5M2oEk=;
        b=neFQ5rRku0m2X/CoRDbttH0T1FU8Ki1HUIm33wwuxFuMgcmYJ0Bq8v55tKfyGcoCK2
         gx7JSZVX9JqB814QYB2IIcSj8e8cXoSkrywiz0UlrceD49+buzK4hRPxNZqUx9jZwtHU
         EiiiUo3rOAOZjgikzCH6d5GW4z2rs4EwQTihUZu5fKuSVvkhYjnsZVfouV1WSbiwnJKK
         xT2rjoVTPQe/rRyhs8Jrj3mQmvMhybHt8/BqkuA6rXFs9UL4lVmKu4b9Ha0xGW551ZSG
         6mwfbRStcXBeC6dNx+teMZTJ201vBD93uuASMWN/FHy/5/Ju6POZ9HZkvt6fxRcQD72X
         ABig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hT/SdExSBeWqGOeMZwtQU19dNytAw9YzFepcl5M2oEk=;
        b=viEiKBPRo7Y86U4f5U1sxIICDnaEtlKjxfad/9bewK9r2a+SuahPV+U0NHvjs1UalI
         YpD49vnQ2Nwvf15ws0YqboWBUUcV/mGMdHuE7Njo/aXY09GCcc4gfF6BlzuTg3T+59Vd
         WFGaEorl1Y39jCfRU14a+PiYd2Flm+e00svF/WFgLwEDbmvsKCc6XrPA2N9YcjwsIJLY
         /wAlgw81F7K7ay2klbguJQnwCPn1HbaAfvyHyQdDfUJCP8a960E8mKuRN4P63lvuo8p4
         sUt3cymvuv/QgcpQz1nfA/uC5bkV878PF5lo4Ji2wsGfM/S48PRk1x1T4Ei7bVTQZYWR
         mGCg==
X-Gm-Message-State: ACrzQf2sn2kZ2UlXGldFC9dDE9nUf2VJImoL6Rhs4qAiYQQShfpFNOTz
        /ezaEsolKP9DoocXl9Okwmshqw==
X-Google-Smtp-Source: AMsMyM7xuhq1LGXH/kQemlpHlPzDAD7owpPUuxiWYLVIH0ajBJJssFMA1FgIs507/84qI4l8IJrIOA==
X-Received: by 2002:a05:622a:1cc9:b0:3a5:1f48:5048 with SMTP id bc9-20020a05622a1cc900b003a51f485048mr22591599qtb.552.1667526278181;
        Thu, 03 Nov 2022 18:44:38 -0700 (PDT)
Received: from ?IPV6:2601:586:5000:570:da2a:9e7e:ddb5:dfa1? ([2601:586:5000:570:da2a:9e7e:ddb5:dfa1])
        by smtp.gmail.com with ESMTPSA id u32-20020a05622a19a000b00398a7c860c2sm1629113qtc.4.2022.11.03.18.44.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Nov 2022 18:44:37 -0700 (PDT)
Message-ID: <698c3a72-f694-01ac-80ba-13bd40bb6534@linaro.org>
Date:   Thu, 3 Nov 2022 21:44:36 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH v2] dt-bindings: net: nxp,sja1105: document spi-cpol/cpha
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221102185232.131168-1-krzysztof.kozlowski@linaro.org>
 <20221103233319.m2wq5o2w3ccvw5cu@skbuf>
Content-Language: en-US
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221103233319.m2wq5o2w3ccvw5cu@skbuf>
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

On 03/11/2022 19:33, Vladimir Oltean wrote:
> Hi Krzysztof,
> 
> On Wed, Nov 02, 2022 at 02:52:32PM -0400, Krzysztof Kozlowski wrote:
>> Some boards use SJA1105 Ethernet Switch with SPI CPOL and CPHA, so
>> document this to fix dtbs_check warnings:
>>
>>   arch/arm64/boot/dts/freescale/fsl-lx2160a-bluebox3.dtb: ethernet-switch@0: Unevaluated properties are not allowed ('spi-cpol' was unexpected)
>>
>> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>>
>> ---
>>
>> Changes since v1:
>> 1. Add also cpha
>> ---
>>  Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
>> index 1e26d876d146..3debbf0f3789 100644
>> --- a/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
>> +++ b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
>> @@ -36,6 +36,9 @@ properties:
>>    reg:
>>      maxItems: 1
>>  
>> +  spi-cpha: true
>> +  spi-cpol: true
>> +
>>    # Optional container node for the 2 internal MDIO buses of the SJA1110
>>    # (one for the internal 100base-T1 PHYs and the other for the single
>>    # 100base-TX PHY). The "reg" property does not have physical significance.
>> -- 
>> 2.34.1
>>
> 
> Don't these belong to spi-peripheral-props.yaml?

No, they are device specific, not controller specific. Every device
requiring them must explicitly include them.

See:
https://lore.kernel.org/all/20220816124321.67817-1-krzysztof.kozlowski@linaro.org/

Best regards,
Krzysztof

