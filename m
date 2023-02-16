Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F22F698E63
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 09:13:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbjBPIN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 03:13:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjBPIN0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 03:13:26 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E68E2364B
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 00:13:25 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id 10so2456740ejc.10
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 00:13:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=B6MIr9w0JhLAMdjA5iNWKYrwooq+WRfPQyN5izB+i3U=;
        b=pM5IQ7LP/GCPE4auZwxMqseFV38G3mMxAdbs6vTFEwJjVhIfIsGImLrwsSeHpVXrbu
         /TFZ9CUB0VU3lHMSpNGgs0cVL6xrQT489uLY+s37f/W3rXBDMvYrbUg1rkHC9ZopIku6
         sAvxuqT64Tg7HF8NhlG0JylB6yCUyFGzrYYpnWcAUKjwGLSPsQAfWayFbKV3ezbTPBOT
         eAPPtHp1DApkbBPIbPd3NTOpTEfIieg97i18aor8pSWJ82izcLoObiv4ZHBqIpJeYz77
         Y2/jqAh/Gcdic+qAQVoUhVSrpcJ0dV8kYbl6yxbnxJN7uvDuANeY/dyM5z7emqCj3hNa
         9tSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B6MIr9w0JhLAMdjA5iNWKYrwooq+WRfPQyN5izB+i3U=;
        b=gy/hjtU3Ldcb6xDggj2UUtp0j8OdOwXSivbj2tOR04j9ejpjiTc15UGxWkum9VUhBe
         SkQjOFQIkJE/GFJuBxSr0F4pkJDHIt6vd6Et0HgJS/RVkPPjnflsV0xTe7yU6A5GvdyF
         yOvqewEOqr39ICE2QpicAKBmtlUgWxcHcusHvP/qmp2dWP3WsQ6DBYxOo7Nixe7I47Rz
         CoUdBU9MPJciJ5+vEQ8dMkMXTcUImAjJaUSZciM3rSVvgFQ845CMIiW/DFWsBL4hZB+5
         2SJ77X1j6JigueZHjuUaMKc7vaGMt3wMVztT7GEsHTAHyQZ2pK2aXPGeCzSBjPZduj/J
         qoEw==
X-Gm-Message-State: AO0yUKVjrKOBKxRjrBB/itzCz6YgJXH6B1ZaT7694Lmt+MeHwwDklXYl
        9Q+s3kjS4NOIs0BMEPVeUet/Mw==
X-Google-Smtp-Source: AK7set/Uy+Hmc8Q4dAMmjxdpjZHwIV47rA2IrMvPHIp0cqv896niQ9ZsYsSe1BbZoyLJJfKLOqFwug==
X-Received: by 2002:a17:906:6c87:b0:7d3:c516:6ef4 with SMTP id s7-20020a1709066c8700b007d3c5166ef4mr5921075ejr.20.1676535203797;
        Thu, 16 Feb 2023 00:13:23 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id my10-20020a1709065a4a00b0084d35ffbc20sm483150ejc.68.2023.02.16.00.13.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Feb 2023 00:13:23 -0800 (PST)
Message-ID: <2bc63ab2-2fd6-3fae-33d5-a6096b78cec0@linaro.org>
Date:   Thu, 16 Feb 2023 09:13:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v4 2/7] dt-bindings: net: snps,dwmac: Update the maxitems
 number of resets and reset-names
Content-Language: en-US
To:     yanhong wang <yanhong.wang@starfivetech.com>,
        linux-riscv@lists.infradead.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>
References: <20230118061701.30047-1-yanhong.wang@starfivetech.com>
 <20230118061701.30047-3-yanhong.wang@starfivetech.com>
 <15a87640-d8c7-d7aa-bdfb-608fa2e497cb@linaro.org>
 <c9ab22b5-3ffb-d034-b8b8-b056b82a96ce@starfivetech.com>
 <aa85caa3-6051-46ab-d927-8c552d5a718d@linaro.org>
 <e066920c-26a9-0f0e-3304-2b9940274d57@starfivetech.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <e066920c-26a9-0f0e-3304-2b9940274d57@starfivetech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/02/2023 08:46, yanhong wang wrote:
> 
> 
> On 2023/2/7 15:59, Krzysztof Kozlowski wrote:
>> On 07/02/2023 03:43, yanhong wang wrote:
>>>
>>>
>>> On 2023/1/18 23:47, Krzysztof Kozlowski wrote:
>>>> On 18/01/2023 07:16, Yanhong Wang wrote:
>>>>> Some boards(such as StarFive VisionFive v2) require more than one value
>>>>> which defined by resets property, so the original definition can not
>>>>> meet the requirements. In order to adapt to different requirements,
>>>>> adjust the maxitems number definition.
>>>>>
>>>>> Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>
>>>>> ---
>>>>>  Documentation/devicetree/bindings/net/snps,dwmac.yaml | 9 +++------
>>>>>  1 file changed, 3 insertions(+), 6 deletions(-)
>>>>>
>>>>> diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
>>>>> index e26c3e76ebb7..baf2c5b9e92d 100644
>>>>> --- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
>>>>> +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
>>>>> @@ -133,12 +133,9 @@ properties:
>>>>>          - ptp_ref
>>>>>  
>>>>>    resets:
>>>>> -    maxItems: 1
>>>>
>>>> Also, this does not make sense on its own and messes constraints for all
>>>> other users. So another no for entire patch.
>>>>
>>>
>>> Thanks. Change the properties of 'resets' and reset-names like this:
>>>
>>>   resets:
>>>     minItems: 1
>>>     maxItems: 2
>>>
>>>   reset-names:
>>>     minItems: 1
>>>     maxItems: 2
>>>
>>> Is it right?  Do you have any other better suggestions?
>>
>> Isn't this allowing two reset items for every variant of snps,dwmac?
>>
> 
> Sorry for not getting back to you faster.
> After referring to the above modification, i used the command 'make DT_CHECKER_FLAGS=-m dt_binding_check'
> to check all the bindings(including 'starfive,jh7110-dwmac.yaml'), no errors are reported,
> and the errors reported by Rob Herring are gone.

I don't see how does it answer my question. I claim you loosen the
constraints and allow now two resets for everyone. You say you don't see
errors. I never claimed there will be errors. I claimed what I said -
you allow now to reset everywhere, which might not be correct
description of every hardware.

Best regards,
Krzysztof

