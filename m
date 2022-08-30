Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE0E5A6CFD
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 21:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbiH3TTU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 15:19:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231414AbiH3TTR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 15:19:17 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2107D785BE
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 12:19:12 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id b26so5503334ljk.12
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 12:19:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=/6LyHTH38BgY0ADcdGBfZVTBqdZgfLuEbTGF5dLunuo=;
        b=hO62t4GV1LIJ8G8QoUwW8V2/xBSvQhASIkjPuucMOlEmS69QhTSItRIwJNp0cvysTH
         QQcWYZ6Ju9ckQiXoigOFbXCNApCr8BpaeCnLmud2OV0Egl6ip9uYJDbfzOIy7g+7x+15
         t+p7GjKmXxt51yTWqHw9GALpa9u2Af+2s25v5YHHu7AmdP0EDcKlv9ovddd0HwehL6iV
         OWCsU4+kaL8xL/t1ADgowuzgU0gtwit9Mcf8dCd9B8qnpW2whzAy1TDg+DezQnD1hGmY
         +pTWB6/kY3T88JUEvjMgr+8HdKCj5kYpbKQSH+NSa7V3hYJhW1qu/oIfeCO15XvOhUuI
         AThQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=/6LyHTH38BgY0ADcdGBfZVTBqdZgfLuEbTGF5dLunuo=;
        b=ZZZ7ze0T8IxIo/4vnlLSM5MLjo+PsAjdQkE7PR8wYW0htwEfWmG2v+ARh3cfaDpwrP
         5Gp/dMrVHp0Gd+NfX8g6ZET4qGYG8z+/PEWGCU4IT8JvspfSpMmEATqPNuuIpxmKOUWo
         9KaGorxndukyLbbrvN+jeBb4mGCvO1Kxn4/2AtAGLyIJS1VQPtZEUnV1BRpLa3SaLKbP
         GBlHsqnIPIQ09oLo4PDeIoKOdaLaqxBJJXhe1LOL158Jo9rl8QVFIRycNN2q9tBIH9TU
         XM/TTZxEQt38kGwtLVdBw9uOi41nRAJJ2VJQ5KPzLHhtFLwwN3cxljYFrY3UtZKVu8we
         n5Dw==
X-Gm-Message-State: ACgBeo1rq60wh1CjIS/j59oblSXzxLyR0GOr4LGtthHh+qsfo7XrQUY8
        l/Tp2NIK9P0hR++9bKoEuO+QPA==
X-Google-Smtp-Source: AA6agR7145igvHGfdZHSgAoxdGPymGfhempqbzQL8ie7cg1cpL7s/xcLE5T2BWNxethJ3rFwI9FUSg==
X-Received: by 2002:a05:651c:154b:b0:261:d6f3:5550 with SMTP id y11-20020a05651c154b00b00261d6f35550mr7607592ljp.528.1661887151106;
        Tue, 30 Aug 2022 12:19:11 -0700 (PDT)
Received: from [192.168.28.124] (balticom-73-99-134.balticom.lv. [109.73.99.134])
        by smtp.gmail.com with ESMTPSA id i23-20020a2e8097000000b00261bfa93f55sm1879969ljg.11.2022.08.30.12.19.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Aug 2022 12:19:10 -0700 (PDT)
Message-ID: <b88512ff-d062-276c-981d-98ec65cb8527@linaro.org>
Date:   Tue, 30 Aug 2022 22:19:09 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH net-next v2 1/5] dt-bindings: net: Convert Altera TSE
 bindings to yaml
Content-Language: en-US
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
References: <20220830095549.120625-1-maxime.chevallier@bootlin.com>
 <20220830095549.120625-2-maxime.chevallier@bootlin.com>
 <4a37d318-8c83-148b-89b3-9729bc7c9761@linaro.org>
 <20220830211617.54d2abc9@pc-10.home>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220830211617.54d2abc9@pc-10.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/08/2022 22:16, Maxime Chevallier wrote:
>>> Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>  
>>
>> Rebase your changes on some decent kernel and use
>> get_maintainers.pl...
> 
> I'm rebased against net-next, so I don't understand how I'm supposed to
> do for this series, should I sent binding patches separately and based
> on another tree ?
> 
> I'll cc you next time, sorry about that.

net-next is correct, I just assumed it is some older tree since you did
not Cc me.

> 
>>> ---
>>> V1->V2:
>>>  - Removed unnedded maxItems
>>>  - Added missing minItems
>>>  - Fixed typos in some properties names
>>>  - Fixed the mdio subnode definition
>>>
>>>  .../devicetree/bindings/net/altera_tse.txt    | 113 -------------
>>>  .../devicetree/bindings/net/altr,tse.yaml     | 156
>>> ++++++++++++++++++ 2 files changed, 156 insertions(+), 113
>>> deletions(-) delete mode 100644
>>> Documentation/devicetree/bindings/net/altera_tse.txt create mode
>>> 100644 Documentation/devicetree/bindings/net/altr,tse.yaml 
>>
>> (...)
>>
>>> diff --git a/Documentation/devicetree/bindings/net/altr,tse.yaml
>>> b/Documentation/devicetree/bindings/net/altr,tse.yaml new file mode
>>> 100644 index 000000000000..1676e13b8c64
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/net/altr,tse.yaml
>>> @@ -0,0 +1,156 @@
>>> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>>> +%YAML 1.2
>>> +---
>>> +$id: http://devicetree.org/schemas/net/altr,tse.yaml#
>>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>>> +
>>> +title: Altera Triple Speed Ethernet MAC driver (TSE)
>>> +
>>> +maintainers:
>>> +  - Maxime Chevallier <maxime.chevallier@bootlin.com>
>>> +
>>> +allOf:  
>>
>> Put allOf below "required".
> 
> Ack
> 
>>> +  - $ref: "ethernet-controller.yaml#"
>>> +  - if:
>>> +      properties:
>>> +        compatible:
>>> +          contains:
>>> +            enum:
>>> +              - altr,tse-1.0
>>> +              - ALTR,tse-1.0
>>> +    then:
>>> +      properties:
>>> +        reg:
>>> +          minItems: 4
>>> +        reg-names:
>>> +          items:
>>> +            - const: control_port
>>> +            - const: rx_csr
>>> +            - const: tx_csr
>>> +            - const: s1
>>> +
>>> +  - if:
>>> +      properties:
>>> +        compatible:
>>> +          contains:
>>> +            enum:
>>> +              - altr,tse-msgdma-1.0
>>> +    then:
>>> +      properties:
>>> +        reg:
>>> +          minItems: 6
>>> +        reg-names:
>>> +          minItems: 6  
>>
>> No need for minItems.
> 
> Ok I'll remove it
> 
>>> +          items:
>>> +            - const: control_port
>>> +            - const: rx_csr
>>> +            - const: rx_desc
>>> +            - const: rx_resp
>>> +            - const: tx_csr
>>> +            - const: tx_desc
>>> +
>>> +properties:
>>> +  compatible:
>>> +    enum:
>>> +      - altr,tse-1.0
>>> +      - ALTR,tse-1.0  
>>
>> This is deprecated compatible. You need oneOf and then deprecated:
>> true.
> 
> Ok thanks for the tip
> 
>>> +      - altr,tse-msgdma-1.0
>>> +
>>> +  reg:
>>> +    minItems: 4
>>> +    maxItems: 6
>>> +
>>> +  reg-names:
>>> +    minItems: 4
>>> +    items:
>>> +      - const: control_port
>>> +      - const: rx_csr
>>> +      - const: rx_desc
>>> +      - const: rx_resp
>>> +      - const: tx_csr
>>> +      - const: tx_desc
>>> +      - const: s1  
>>
>> This is messed up. You allow only 6 items maximum, but list 7. It
>> contradicts your other variants in allOf:if:then.
> 
> I'll remove that part then, apparently it's not needed at all if the
> allOf:if:then cover all cases.

Right. The typical pattern is like clocks/clock-names here:

https://elixir.bootlin.com/linux/v5.19-rc6/source/Documentation/devicetree/bindings/clock/samsung,exynos7-clock.yaml#L57

Best regards,
Krzysztof
