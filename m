Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CACB5E99E4
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 08:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbiIZGuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 02:50:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233743AbiIZGuK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 02:50:10 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAA841F60D
        for <netdev@vger.kernel.org>; Sun, 25 Sep 2022 23:50:07 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id 10so9325224lfy.5
        for <netdev@vger.kernel.org>; Sun, 25 Sep 2022 23:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=rMv/6RaQNfPOzLYbEjVzggzY8CZ+X96gFNKrqQ2B2Ow=;
        b=xg1FMouFc39uYJfpo1TMTLh6Tz1Vheo3Fw4i4l3fcognD2CeckgksJP71bZytbEUqU
         K76jhbCWLj5KC4OqfPlcmMAaQjeje9tY380R0SpZm61Xs6slylUAciPBo1eHhac4y65U
         u1fs3iY+n+FxT7C71rYQiInoZ8ZJZaWkfVp0EqdB7cL3aUd5tKaXSr95zdQEdxFCHLMZ
         Ya3PB+ZHoo4kNnxmt3VfbUS631IaaXvHlmSS1u1FpS3bkEgyvOUdtrC2rKGWwgykomML
         /8ZVhBn4XTzSQ80KUB9HPUPOkIWbu5/o/HSW5Lp9IEn4tAtkwVPjeag/XW8vQFvQDSXP
         INtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=rMv/6RaQNfPOzLYbEjVzggzY8CZ+X96gFNKrqQ2B2Ow=;
        b=uSFQuOjjJpEmGGtjEVHsOW+YY2hCv7Hjg7EwU5H+USX0RsmTBL3RN2uwnGhEwu8vBD
         XZZr36KGK/xMw8dkN8LrutaO/U9HP84LF1lc0eJFgfU+eEHdEjT6xVMvJP3eo2zWTY0z
         evnZMPfv2W9Ra1G5qUuW9b1mupljYp7ef+saq2uKYw22k+FEBa4mv7xUIc1GEr62+rBJ
         aIlyxpQHfxPBgjDIDgJScGHhYSEULLT5lhncYLZbWTpXPqFyDnip4sEytoaAmtGyzdR8
         aOHgKtfOFM3OSMqtppR0V8mBYeDntAiPHCiMHduwzKAVsvjNdg2dtWjzlYI85+9z0J3z
         LLNg==
X-Gm-Message-State: ACrzQf3uwaGggU0nZAL+KzD2oshcjr3YJSiumKOwQtOJrEP/v3w6Zszo
        xbKbWti/mFA7XITWD7cXUliJ7A==
X-Google-Smtp-Source: AMsMyM4A2p2dVHbr2MrZbNkvzA+TDXrYrHq10zKyOpuUy8eKdgqnmSqsTMBymCWb70/WbocMjsZ6jw==
X-Received: by 2002:a19:e01e:0:b0:497:81a9:c2c4 with SMTP id x30-20020a19e01e000000b0049781a9c2c4mr8259528lfg.74.1664175005928;
        Sun, 25 Sep 2022 23:50:05 -0700 (PDT)
Received: from [192.168.0.21] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id e12-20020a05651236cc00b00499b19f23e8sm2440271lfs.279.2022.09.25.23.50.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Sep 2022 23:50:05 -0700 (PDT)
Message-ID: <d31dc406-3ef2-0625-8f5e-ff6731457427@linaro.org>
Date:   Mon, 26 Sep 2022 08:50:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v2 4/8] dt-bindings: net: renesas: Document Renesas
 Ethernet Switch
Content-Language: en-US
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "kishon@ti.com" <kishon@ti.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>
Cc:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "linux-phy@lists.infradead.org" <linux-phy@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
References: <20220921084745.3355107-1-yoshihiro.shimoda.uh@renesas.com>
 <20220921084745.3355107-5-yoshihiro.shimoda.uh@renesas.com>
 <1aebd827-3ff4-8d13-ca85-acf4d3a82592@linaro.org>
 <TYBPR01MB5341514CD57AB080454749F2D8529@TYBPR01MB5341.jpnprd01.prod.outlook.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <TYBPR01MB5341514CD57AB080454749F2D8529@TYBPR01MB5341.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/09/2022 08:10, Yoshihiro Shimoda wrote:

> I'll add a blank line here.
> 
>>> +      '#size-cells':
>>> +        const: 0
>>> +
>>> +    additionalProperties: false
>>
>> Don't put it between properties. For nested object usually this is
>> before properties:
> 
> I'll drop it.

Don't drop, but instead put it before "properties" for this nested object.

> 
>>> +
>>> +    patternProperties:
>>> +      "^port@[0-9a-f]+$":
>>> +        type: object
>>> +
>>
>> Skip blank line.
> 
> I got it.
> 
>>> +        $ref: "/schemas/net/ethernet-controller.yaml#"
>>
>> No need for quotes.
> 
> I'll drop the quotes.
> 
>>> +        unevaluatedProperties: false
>>> +
>>> +        properties:
>>> +          reg:
>>> +            description:
>>> +              Port number of ETHA (TSNA).
>>> +
>>> +          phy-handle:
>>> +            description:
>>> +              Phandle of an Ethernet PHY.
>>
>> Why do you need to mention this property? Isn't it coming from
>> ethernet-controller.yaml?
> 
> Indeed. I'll drop the description.
> 
>>> +
>>> +          phy-mode:
>>> +            description:
>>> +              This specifies the interface used by the Ethernet PHY.
>>> +            enum:
>>> +              - mii
>>> +              - sgmii
>>> +              - usxgmii
>>> +
>>> +          phys:
>>> +            maxItems: 1
>>> +            description:
>>> +              Phandle of an Ethernet SERDES.
>>
>> This is getting confusing. You have now:
>> - phy-handle
>> - phy
>> - phy-device
>> - phys
>> in one schema... although lan966x serdes seems to do the same. :/
> 
> Yes... I found the following documents have "phy" and "phy-handle" by using
> git grep -l -w "phys" `git grep -l phy-handle Documentation/devicetree/bindings/`:
> Documentation/devicetree/bindings/net/cdns,macb.yaml
> Documentation/devicetree/bindings/net/cpsw.txt
> Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
> Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml
> Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
> Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
> Documentation/devicetree/bindings/phy/phy-bindings.txt
> 
> And I'm interesting that the phy-bindings.txt said the following:
> -----
> phys : the phandle for the PHY device (used by the PHY subsystem; not to be
>        confused with the Ethernet specific 'phy' and 'phy-handle' properties,
>        see Documentation/devicetree/bindings/net/ethernet.txt for these)
> -----

Indeed, seems ok.

> 

Best regards,
Krzysztof

