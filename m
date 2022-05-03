Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D73E5186F7
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 16:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237235AbiECOoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 10:44:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236325AbiECOoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 10:44:02 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 356AEE0A3
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 07:40:28 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id gh6so33953152ejb.0
        for <netdev@vger.kernel.org>; Tue, 03 May 2022 07:40:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=T7KD58LLGLoFWa1xXxvp0DQeF4I0gKOPKSSTJE1ESIQ=;
        b=r2joUbDnOfo04iaxwxKpn34xLPcue03BKA2xcR5i6N7cXrYk8Rp+cHm+ylEj63RZ7g
         YpFFjyP8UeUmqalv1YTMVlSARi5ZFXr9TbF8X8oeR0NBj4Hhs7smfuO81RHuPMnIXYRf
         zKzq7mrmCVczsefNa6APBEA52mivnPWENS3N5kqDum5p4JCY0nXPDiIUyRzJmYBZXmz6
         LgCZg2m2o2Gg0SRfSigRTbB2pz5oIU3B5PJ/Tu7u7xq1VjIuTRsSjz6VN4cfe3n6X4lg
         n9DQ1KzazDTcWYkcmCGvMi0FDb1ckLs3KarUQu2Mo0tpSTajVmZuZtMF8kPXPulH/cXC
         aTkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=T7KD58LLGLoFWa1xXxvp0DQeF4I0gKOPKSSTJE1ESIQ=;
        b=Ax7KBOKTe1SYt3UoK/K0JOMfR/ZT8xNqkDNR7TgQM2y1wB/sg058xDvVRF6yYvEvFl
         A9FNeWHDXuwXsWn9yY/uQUVAQGQISuwVU0r1OR1Ju0kE12OdV9IGdOpxZKX52i18Jv9A
         8xP502qozqGBMsfP/fyIaSDOpRLcxTDmEpVYSAStvs+LDEXhqy2UIIjAJVvjIOvFK7Dk
         k8cRhoJQEDfwB6Wp5ejKxLMgkithEmjySQT0YA4gvWRFIdZ9nK32dW0MU7e+wq6kWOuE
         0EkAjZRzvpEIjHMtjkBSWTnr3hECbEqdsscT+oQHOBVfuoDJmtav28tRF+UYgn1Yc12E
         kTdA==
X-Gm-Message-State: AOAM531hxC6Tqq88lQU9uohm4aAT+85lp0NnXj/EREudN3jaE7hJwJcE
        aLgJisISjZHhTf3wk5r5waio0A==
X-Google-Smtp-Source: ABdhPJzUyOBnA5pwtFQm/3gpADNDDdDrjOagJfn2AvJ5rgaqlRv3q7PRI9wdbo+5IzmEMk/kzkE2Rg==
X-Received: by 2002:a17:907:1c0f:b0:6f3:edd8:85d5 with SMTP id nc15-20020a1709071c0f00b006f3edd885d5mr15468515ejc.397.1651588826696;
        Tue, 03 May 2022 07:40:26 -0700 (PDT)
Received: from [192.168.0.203] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id gz19-20020a170907a05300b006f3ef214ddasm4612992ejc.64.2022.05.03.07.40.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 May 2022 07:40:26 -0700 (PDT)
Message-ID: <10770ff5-c9b1-7364-4276-05fa0c393d3b@linaro.org>
Date:   Tue, 3 May 2022 16:40:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: Aw: Re: [RFC v1] dt-bindings: net: dsa: convert binding for
 mediatek switches
Content-Language: en-US
To:     Frank Wunderlich <frank-w@public-files.de>,
        Greg Ungerer <gerg@kernel.org>,
        =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Frank Wunderlich <linux@fw-web.de>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
References: <20220502153238.85090-1-linux@fw-web.de>
 <d29637f8-87ff-b5f0-9604-89b51a2ba7c1@linaro.org>
 <trinity-cda3b94f-8556-4b83-bc34-d2c215f93bcd-1651587032669@3c-app-gmx-bap25>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <trinity-cda3b94f-8556-4b83-bc34-d2c215f93bcd-1651587032669@3c-app-gmx-bap25>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/05/2022 16:10, Frank Wunderlich wrote:
> Hi,
> 
> thank you for first review.
> 
>> Gesendet: Dienstag, 03. Mai 2022 um 14:05 Uhr
>> Von: "Krzysztof Kozlowski" <krzysztof.kozlowski@linaro.org>
>> Betreff: Re: [RFC v1] dt-bindings: net: dsa: convert binding for mediatek switches
>>
>> On 02/05/2022 17:32, Frank Wunderlich wrote:
>>> From: Frank Wunderlich <frank-w@public-files.de>
>>>
>>> Convert txt binding to yaml binding for Mediatek switches.
>>>
>>> Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
>>> ---
>>>  .../devicetree/bindings/net/dsa/mediatek.yaml | 435 ++++++++++++++++++
>>>  .../devicetree/bindings/net/dsa/mt7530.txt    | 327 -------------
>>>  2 files changed, 435 insertions(+), 327 deletions(-)
>>>  create mode 100644 Documentation/devicetree/bindings/net/dsa/mediatek.yaml
>>>  delete mode 100644 Documentation/devicetree/bindings/net/dsa/mt7530.txt
>>>
>>> diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek.yaml
>>> new file mode 100644
>>> index 000000000000..c1724809d34e
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/net/dsa/mediatek.yaml
>>
>> Specific name please, so previous (with vendor prefix) was better:
>> mediatek,mt7530.yaml
> 
> ok, named it mediatek only because mt7530 is only one possible chip and driver handles 3 different "variants".
> 
>>> @@ -0,0 +1,435 @@
>>> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>>
>> You should CC previous contributors and get their acks on this. You
>> copied here a lot of description.
> 
> added 3 Persons that made commits to txt before to let them know about this change
> 
> and yes, i tried to define at least the phy-mode requirement as yaml-depency, but failed because i cannot match
> compatible in subnode.

I don't remember such syntax.

(...)

> 
>>> if defined, indicates that either MT7530 is the part
>>> +      on multi-chip module belong to MT7623A has or the remotely standalone
>>> +      chip as the function MT7623N reference board provided for.
>>> +
>>> +  reset-gpios:
>>> +    description: |
>>> +      Should be a gpio specifier for a reset line.
>>> +    maxItems: 1
>>> +
>>> +  reset-names:
>>> +    description: |
>>> +      Should be set to "mcm".
>>> +    const: mcm
>>> +
>>> +  resets:
>>> +    description: |
>>> +      Phandle pointing to the system reset controller with
>>> +      line index for the ethsys.
>>> +    maxItems: 1
>>> +
>>> +required:
>>> +  - compatible
>>> +  - reg
>>
>> What about address/size cells?
> 
> you're right even if they are const to a value they need to be set
> 
>>> +
>>> +allOf:
>>> +  - $ref: "dsa.yaml#"
>>> +  - if:
>>> +      required:
>>> +        - mediatek,mcm
>>
>> Original bindings had this reversed.
> 
> i know, but i think it is better readable and i will drop the else-part later.
> Driver supports optional reset ("mediatek,mcm" unset and without reset-gpios)
> as this is needed if there is a shared reset-line for gmac and switch like on R2 Pro.
> 
> i left this as separate commit to be posted later to have a nearly 1:1 conversion here.

Ah, I missed that actually your syntax is better. No need to
reverse/negate and the changes do not have to be strict 1:1.

> 
>>> +    then:
>>> +      required:
>>> +        - resets
>>> +        - reset-names
>>> +    else:
>>> +      required:
>>> +        - reset-gpios
>>> +
>>> +  - if:
>>> +      required:
>>> +        - interrupt-controller
>>> +    then:
>>> +      required:
>>> +        - "#interrupt-cells"
>>
>> This should come from dt schema already...
> 
> so i should drop (complete block for interrupt controller)?

The interrupts you need. What I mean, you can skip requirement of cells.

> 
>>> +        - interrupts
>>> +
>>> +  - if:
>>> +      properties:
>>> +        compatible:
>>> +          items:
>>> +            - const: mediatek,mt7530
>>> +    then:
>>> +      required:
>>> +        - core-supply
>>> +        - io-supply
>>> +
>>> +
>>> +patternProperties:
>>> +  "^ports$":
>>
>> It''s not a pattern, so put it under properties, like regular property.
> 
> can i then make the subnodes match? so the full block will move above required between "mediatek,mcm" and "reset-gpios"

Yes, subnodes stay with patternProperties.

> 
>   ports:
>     type: object
> 
>     patternProperties:
>       "^port@[0-9]+$":
>         type: object
>         description: Ethernet switch ports
> 
>         properties:
>           reg:
>             description: |
>               Port address described must be 5 or 6 for CPU port and from 0 to 5 for user ports.
> 
>         unevaluatedProperties: false
> 
>         allOf:
>           - $ref: dsa-port.yaml#
>           - if:
> ....
> 
> basicly this "ports"-property should be required too, right?

Previous binding did not enforce it, I think, but it is reasonable to
require ports.

> 
> 
>>> +    type: object
>>> +
>>> +    patternProperties:
>>> +      "^port@[0-9]+$":
>>> +        type: object
>>> +        description: Ethernet switch ports
>>> +
>>> +        $ref: dsa-port.yaml#
>>
>> This should go to allOf below.
> 
> see above
> 
>>> +
>>> +        properties:
>>> +          reg:
>>> +            description: |
>>> +              Port address described must be 6 for CPU port and from 0 to 5 for user ports.
>>> +
>>> +        unevaluatedProperties: false
>>> +
>>> +        allOf:
>>> +          - if:
>>> +              properties:
>>> +                label:
>>> +                  items:
>>> +                    - const: cpu
>>> +            then:
>>> +              required:
>>> +                - reg
>>> +                - phy-mode
>>> +
>>> +unevaluatedProperties: false
>>> +
>>> +examples:
>>> +  - |
>>> +    mdio0 {
>>
>> Just mdio
> 
> ok
> 
>>> +        #address-cells = <1>;
>>> +        #size-cells = <0>;
>>> +        switch@0 {
>>> +            compatible = "mediatek,mt7530";
>>> +            #address-cells = <1>;
>>> +            #size-cells = <0>;
>>> +            reg = <0>;
>>> +
>>> +            core-supply = <&mt6323_vpa_reg>;
>>> +            io-supply = <&mt6323_vemc3v3_reg>;
>>> +            reset-gpios = <&pio 33 0>;
>>
>> Use GPIO flag define/constant.
> 
> this example seems to be taken from bpi-r2 (i had taken it from the txt). In dts for this board there are no
> constants too.
> 
> i guess
> include/dt-bindings/gpio/gpio.h:14:#define GPIO_ACTIVE_HIGH 0
> 
> for 33 there seem no constant..all other references to pio node are with numbers too and there seem no binding
> header defining the gpio pins (only functions in include/dt-bindings/pinctrl/mt7623-pinfunc.h)

ok, then my comment


Best regards,
Krzysztof
