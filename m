Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF6EE4EE2A8
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 22:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241429AbiCaUcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 16:32:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241432AbiCaUcV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 16:32:21 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89CCD55482
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 13:30:33 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id yy13so1731804ejb.2
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 13:30:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=WnVDLK0fuVXet24goRyLeC09oaPRTS1cEiuOv9qpnzg=;
        b=xz4HmeCzQcf0bKScHWhvla+V2E7vgHeOrWNrab8oEGJzRpkOogwYZLg8l4nYxn7PGI
         DnSi7BcukvWTBLE1pQB9Al6zKPKetCxY1DMQ6jIlZNyQGsZlA+3jLPbZ97e20sb/L6k/
         jru7po9wvWWn2ZtoPjQoAkNlyURKBUV9JRU8R9qubnXxwjbbhkLVg0YUUl3VhKebG4zg
         5WLG1S4pyKhOY9Z/wRIFD0gr/ZGaoLsYa1JAF8LgBG4Xe7folO0xkJoq+BXzt9gX4zd+
         j7HgDQSgbhnStRnEGu26upop8BWlyGxOqyLzZNdKPTqj/un11jX7rsTJM6d2WH1MtZkD
         X7UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=WnVDLK0fuVXet24goRyLeC09oaPRTS1cEiuOv9qpnzg=;
        b=LLZmVwibE49/p0Q0E14cGaELApUklzFi0BstL9EznUW5++3ooxWx5BFFX/Y+12jKz9
         4t4uKvbTvKYW0/AFO2QtsIEzuwTadKO5+Xhz535dB+k+LgHu7xFp8q1XkoGLUuQh+c2C
         bzmdX5A4xf2wMlYrZK3/YSqvcCPNfdxK8o6ndyhgj3whmu7P3o/xF+0fWCnrNsYMWLyV
         A6pcIJdBkjo2QVAHSByZkNPfRLgDhCPSKxvBdWvKrZjZtYC3NMQSqLpUAJRy1FQfOn5u
         o6qmz0fIqBITLFS73kXdDKelDW3ucT+h/4o4rA+OWLt42OBlZ7aYmywUayEgdCJ+2Jza
         aqHg==
X-Gm-Message-State: AOAM531zeGCCsc460ncCm1I28Iu0+NjTAXfUgwCkwnqhFa36wM5x6UrJ
        Q4yjEHgYKFRm270KgfSQCAA6qHPJpGabgthJ
X-Google-Smtp-Source: ABdhPJzk1sADuDWf1mqltBlOA78Rm21xqsC7es/F5+4JjOUvGFm54/gqgEdhlOupkBs1Tk1QLX6phg==
X-Received: by 2002:a17:907:3e82:b0:6e1:3fe3:9b14 with SMTP id hs2-20020a1709073e8200b006e13fe39b14mr6437585ejc.561.1648758632084;
        Thu, 31 Mar 2022 13:30:32 -0700 (PDT)
Received: from [192.168.0.168] (xdsl-188-155-201-27.adslplus.ch. [188.155.201.27])
        by smtp.gmail.com with ESMTPSA id tc19-20020a1709078d1300b006e0649189b0sm169808ejc.68.2022.03.31.13.30.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Mar 2022 13:30:31 -0700 (PDT)
Message-ID: <3d4159d6-112a-7818-8192-7197dcfca894@linaro.org>
Date:   Thu, 31 Mar 2022 22:30:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH RFC net-next 2/3] dt-bindings: net: mscc-miim: add clock
 and clock-frequency
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Michael Walle <michael@walle.cc>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220331151440.3643482-1-michael@walle.cc>
 <20220331151440.3643482-2-michael@walle.cc>
 <dfb10165-1987-84ae-d48a-dfb6b897e0a3@linaro.org> <YkYMIequbfAsELnf@lunn.ch>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <YkYMIequbfAsELnf@lunn.ch>
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

On 31/03/2022 22:16, Andrew Lunn wrote:
> On Thu, Mar 31, 2022 at 10:05:48PM +0200, Krzysztof Kozlowski wrote:
>> On 31/03/2022 17:14, Michael Walle wrote:
>>> Add the (optional) clock input of the MDIO controller and indicate that
>>> the common clock-frequency property is supported. The driver can use it
>>> to set the desired MDIO bus frequency.
>>>
>>> Signed-off-by: Michael Walle <michael@walle.cc>
>>> ---
>>>  Documentation/devicetree/bindings/net/mscc,miim.yaml | 5 +++++
>>>  1 file changed, 5 insertions(+)
>>>
>>> diff --git a/Documentation/devicetree/bindings/net/mscc,miim.yaml b/Documentation/devicetree/bindings/net/mscc,miim.yaml
>>> index b52bf1732755..e9e8ddcdade9 100644
>>> --- a/Documentation/devicetree/bindings/net/mscc,miim.yaml
>>> +++ b/Documentation/devicetree/bindings/net/mscc,miim.yaml
>>> @@ -32,6 +32,11 @@ properties:
>>>  
>>>    interrupts: true
>>>  
>>> +  clocks:
>>> +    maxItems: 1
>>> +
>>> +  clock-frequency: true
>>
>> This looks unusual clock-frequency is usually for clock providers but
>> this is a consumer, so it is not a common frequency here. You mention
>> that "driver can use it", so it's not a hardware description but some
>> feature for the driver. We have this already - use assigned-clock* in
>> your DTS.
> 
> Please see
> 
> Documentation/devicetree/bindings/net/mdio.yaml
> 
>   clock-frequency:
>     description:
>       Desired MDIO bus clock frequency in Hz. Values greater than IEEE 802.3
>       defined 2.5MHz should only be used when all devices on the bus support
>       the given clock speed.
> 
> The MDIO bus master provides the MDIO bus clock, so in a sense, the
> device is a provider. although it does also make use of the clock
> itself. It is a hardware description, because the users of the bus
> make use of the clock, i.e. the PHY devices on the bus.
> 
> It is also identical to i2c bus masters
> Documentation/devicetree/bindings/i2c/i2c.txt says:
> 

Thanks, it's good. Indeed buses also use this property.

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof
