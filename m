Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 449EF66D872
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 09:43:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236083AbjAQInp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 03:43:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236201AbjAQIni (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 03:43:38 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1616E2CC61
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 00:43:37 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id d2so9656943wrp.8
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 00:43:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WWm/D5U36CBBZnisDCQc8jy48M3+XXeWpLI/3U6tBZA=;
        b=TupwNN700Dfm2HUutSMwjPlmPKv1qxM6rYQyMm0mpHkjqxUP6/0EINC3oD3RQ0ssr9
         ZzPtSYa/mGq4cHtJcahITvOZmStCZdZWU1jfRSTQRltvQy18nreIqtAjQBDUJ5qUqWPj
         Vmigbtmqu/qh3Crc2SEdV8EfGgnlOdVOyKxP8c2Fl4gjbBFiArELiXSHSbu9YA15LyiR
         YFwyzD8iLVSiyiiQ62RpEg3nb5p1ifgQxrmUkaEAewQmadv8mXnL7W9/QY9FGQsohvEg
         WVZAiCvLCyWsyG2KrU8FpyT04KS1EJ5k+p4CSGwyZJbNMrSOVPp4L6n3+x6r1ynkMaFR
         vzfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WWm/D5U36CBBZnisDCQc8jy48M3+XXeWpLI/3U6tBZA=;
        b=kHcXkJf4zURDc8sNC4VWQwAjqerYY58X3E4uOcMkJuS31eg9+LmU48Q5/Jn83JYE89
         Bk3+xIppLCDxk3rT3cjy1oM0wJ/2WsG1brBvyYpZ3H/VIEi2/4SVce/kX662HvdGT3xi
         yBD51zlfNVN3XEtBqQzBQLOQqp5GcZY318NvTop3Vd1A3CI0nUDrs7TxFXzDwymOahg5
         p630pwkaVhn3m6Td7vb8xS+QWUVVg+37lzxVFuyITxSi0dnKTxrJlbk/zLDsnJgm/atz
         j9FpCsxWkin1gAWuBV4dsCwKlxRsXrSuKaPlQfTnqk2u7Hli0qd4zy4UKu+wiaWcpp6g
         VLnw==
X-Gm-Message-State: AFqh2kpKa68iBb7U95Rz4jbnNW5J+EQOlyON06vm8gdFZ4uQpdGZSaUn
        A7IFfPHq9kFvgUQQ5JQwu1J8Sg==
X-Google-Smtp-Source: AMrXdXtxE8deHQ9xEqdyikgOrukHsDlEQ6sxKfSMn8K6gVKnLxFmtiGijYttJ+TeIIPxhisAU9lAVw==
X-Received: by 2002:adf:e195:0:b0:2bd:d26c:ccc4 with SMTP id az21-20020adfe195000000b002bdd26cccc4mr2366095wrb.42.1673945015641;
        Tue, 17 Jan 2023 00:43:35 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id bu3-20020a056000078300b002bbe7efd88csm23519456wrb.41.2023.01.17.00.43.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jan 2023 00:43:35 -0800 (PST)
Message-ID: <17f910a8-186f-48a3-8817-6a2fa4fe06ec@linaro.org>
Date:   Tue, 17 Jan 2023 09:43:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v3 2/7] dt-bindings: net: snps,dwmac: Update the maxitems
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
References: <20230106030001.1952-1-yanhong.wang@starfivetech.com>
 <20230106030001.1952-3-yanhong.wang@starfivetech.com>
 <2328562d-59a2-f60e-b17b-6cf16392e01f@linaro.org>
 <84e783a6-0aea-a6ba-13a0-fb29c66cc81a@starfivetech.com>
 <8ee5f6ef-80cb-2e0f-6681-598ccc697291@linaro.org>
 <bb1f3c71-e1a7-cd2d-b728-6e9027dae150@starfivetech.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <bb1f3c71-e1a7-cd2d-b728-6e9027dae150@starfivetech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/01/2023 09:14, yanhong wang wrote:
>>> Thanks, refer to the definition of clocks. If it is defined as follows, is it OK?
>>>
>>> properties:
>>>   resets:
>>>     minItems: 1
>>>     maxItems: 3
>>>     additionalItems: true
>>
>> Drop
>>
>>>     items:
>>>       - description: MAC Reset signal.
>>
>> Drop both
>>
>>>
>>>   reset-names:
>>>     minItems: 1
>>>     maxItems: 3
>>>     additionalItems: true
>>
>> Drop
>>
>>>     contains:
>>>       enum:
>>>         - stmmaceth
>>
>> Drop all
>>
>>>
>>>
>>> allOf:
>>>   - if:
>>>       properties:
>>>         compatible:
>>>           contains:
>>>             const: starfive,jh7110-dwmac
>>>     then:
>>>       properties:
>>>         resets:
>>>           minItems: 2
>>>           maxItems: 2
>>>         reset-names:
>>>           items:
>>>             - const: stmmaceth
>>>             - const: ahb
>>>       required:
>>>         - resets
>>>         - reset-names  
>>>     else:
>>>       properties:
>>>         resets:
>>>           maxItems: 1
>>>           description:
>>>             MAC Reset signal.
>>>
>>>         reset-names:
>>>           const: stmmaceth
>>>
>>> Do you have any other better suggestions?
>>
>> More or less like this but the allOf should not be in snps,dwmac schema
>> but in individual schemas. The snps,dwmac is growing unmaintainable...
>>
> 
> Thanks, it is defined as follows, is it right?
> 
> properties:
>   resets:
>     minItems: 1
>     maxItems: 3
>     additionalItems: true
> 

Read my comments above. Drop.

Best regards,
Krzysztof

