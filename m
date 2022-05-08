Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFE5951ECBC
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 11:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbiEHKBS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 06:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiEHKBR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 06:01:17 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFE3455A5
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 02:57:27 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id e24so15701160wrc.9
        for <netdev@vger.kernel.org>; Sun, 08 May 2022 02:57:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=xjdDA14ZWJVoEoFEVymH3jKuZk4YmCeTZ9pm/X59uF4=;
        b=2KgIvlEl9Pp3kTwP4ubvVTWZDZhLv4bTh4xJxsWW/rb8m94YG4JL04IPIovbd1Rf7M
         sTDdVm1d5THPKEk9OKUaEedtOCySP9pedQOfEn0d6IXyoldef78JqujqEGPrGSzxT4gZ
         E4PmH0t8eIYNQkFHzroxW0x/NJ+bRYTZBRr1ujCS/eUwWlmBSfpCfA3WSpIjufNxT0kp
         K+HQGsq1VIrxfQw8hJJCCyLAMIuzipey+EiGvqXCGOpXf05k1zJspY9Jw3SYQYQKJWl2
         TBo0rDgZ0G447AAhXx/4LJMfmlzjfSIR2PnidLajZPy0sX5Z1nA2451k1+k5XPmpN07M
         d6EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xjdDA14ZWJVoEoFEVymH3jKuZk4YmCeTZ9pm/X59uF4=;
        b=GviDdFU3yA24ie6kr6uw07gulaEwGU7ORY05JFR52yR5pd82umy540tqEZ/mOxPCNS
         7jWYyeV6Io0JHo/R89QkgWfcZ24n3egyuOsf/Jnw9/n4MJbiuTaDCs4e2GaJXtDlBkdm
         LBz5aAYXuq5v+rVLcSqlG//8YFAJch8BEC0J2om/r2YxKyrurn7NYziyjNC+XhTqmzl3
         dMEGa3TNfxNrstxtciktdtCywZDtq7Amukl5CyMEq0ZhINls/CQLYWp4Qgmu2HQnZqyt
         FosccciFZenKVBT2xN63tJ6pXhTszho0HcIwX8HzB4hu/tpLaVXaa6nwkTK+ae4eW+AF
         Gwsw==
X-Gm-Message-State: AOAM530WmMngXOvrETOcbaqkaFV/Mg/3EKZGDlKs4XizW0/8CCByWTgx
        4HIXoNcJTzS5fmatcQVKxpfdgZGRF6+YtBjaxFw=
X-Google-Smtp-Source: ABdhPJws9EtrvlmkH/KV2DQZQ0qNO3mW/SNYPim62ObjvCpXrkYwmFLGKJW7/yRQvEWkXE3hYuQzwQ==
X-Received: by 2002:a5d:5228:0:b0:20c:b986:469d with SMTP id i8-20020a5d5228000000b0020cb986469dmr3885198wra.34.1652003846368;
        Sun, 08 May 2022 02:57:26 -0700 (PDT)
Received: from [192.168.17.225] (bzq-82-81-222-124.cablep.bezeqint.net. [82.81.222.124])
        by smtp.gmail.com with ESMTPSA id bw22-20020a0560001f9600b0020c5253d8d8sm9172958wrb.36.2022.05.08.02.57.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 May 2022 02:57:25 -0700 (PDT)
Message-ID: <e46335cd-7e14-49aa-7d93-e88de0930f66@solid-run.com>
Date:   Sun, 8 May 2022 12:57:24 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v3 1/3] dt-bindings: net: adin: document phy clock output
 properties
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        netdev@vger.kernel.org
Cc:     alvaro.karsz@solid-run.com, Andrew Lunn <andrew@lunn.ch>,
        Michael Hennerich <michael.hennerich@analog.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
References: <20220419102709.26432-1-josua@solid-run.com>
 <20220428082848.12191-1-josua@solid-run.com>
 <20220428082848.12191-2-josua@solid-run.com>
 <22f2a54a-12ac-26a7-4175-1edfed2e74de@linaro.org>
From:   Josua Mayer <josua@solid-run.com>
In-Reply-To: <22f2a54a-12ac-26a7-4175-1edfed2e74de@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

\o/

Am 05.05.22 um 23:24 schrieb Krzysztof Kozlowski:
> On 28/04/2022 10:28, Josua Mayer wrote:
>
> Thank you for your patch. There is something to discuss/improve.
Thank you for taking a look.
>> diff --git a/Documentation/devicetree/bindings/net/adi,adin.yaml b/Documentation/devicetree/bindings/net/adi,adin.yaml
>> index 1129f2b58e98..3e0c6304f190 100644
>> --- a/Documentation/devicetree/bindings/net/adi,adin.yaml
>> +++ b/Documentation/devicetree/bindings/net/adi,adin.yaml
>> @@ -36,6 +36,23 @@ properties:
>>       enum: [ 4, 8, 12, 16, 20, 24 ]
>>       default: 8
>>   
>> +  adi,phy-output-clock:
>> +    description: Select clock output on GP_CLK pin. Three clocks are available:
>> +      A 25MHz reference, a free-running 125MHz and a recovered 125MHz.
>> +      The phy can also automatically switch between the reference and the
>> +      respective 125MHz clocks based on its internal state.
>> +    $ref: /schemas/types.yaml#/definitions/string
>> +    enum:
>> +    - 25mhz-reference
>> +    - 125mhz-free-running
>> +    - 125mhz-recovered
>> +    - adaptive-free-running
>> +    - adaptive-recovered
> Missing two spaces of indentation for all these items.
Will add in v4, thank you.
>
>> +
>> +  adi,phy-output-reference-clock:
>> +    description: Enable 25MHz reference clock output on CLK25_REF pin.
>> +    $ref: /schemas/types.yaml#/definitions/flag
> This could be just "type:boolean".
Yes, it could be boolean, and default to false.
So ... I figured its a flag, but whether to make it a flag or boolean is 
better I do not know.
> Best regards,
> Krzysztof
sincerely
- Josua Mayer
