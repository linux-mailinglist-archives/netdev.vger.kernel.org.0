Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21FC2590FFF
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 13:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236899AbiHLLZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 07:25:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233977AbiHLLZv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 07:25:51 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1A372CE10
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 04:25:49 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id z25so957434lfr.2
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 04:25:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=CicaxzhBFo0KPREhpr4TXcueTsn2K/vZuDdXuzYsKWU=;
        b=ZSjkS3G57jOr2ZUgBUg647LpswyGyUyOyxiv0qFWeuWeUxKsfjmjUXDseiTfsQeItA
         C7ge0PECV1KDT/YzTpu722jyDhSyTkdFC9Tz1gGtysf3KxHqSztEfFLFt2lBu7DmBQo4
         is0MZePlBzlABtDsifedY/+Z3wAkjtKPZ+7kvVg62lftbaHeyB2zFH0GKgXkK/osYma0
         KMRoFx5V+/YgxcE2CHqMv/q1MXffwjHDhg7RRANtqkqntp+ZcsYIkO2B6lSFUrO0jcxl
         nUp2kC2MVEEazP4SXMIreFRMBeyz+1HSNrbsCona9am1KL+dpyWbCzXSVezdHj/fIpqp
         rNCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=CicaxzhBFo0KPREhpr4TXcueTsn2K/vZuDdXuzYsKWU=;
        b=U71BWddKfRqEWBg+Vwj91IgBWqOXY9bb0xO7lIu+XJ/GssfbTHc1gfGxkHCVSnX8PL
         gUnjScagBpOUIbdgiY+UrWCxa4YO7chJ9eNsUzt4iZXpuB6i92icrTfMlaAO78RXOT3Z
         KLosEed0iavT5oj3dH95qldGZ83ee4PmF36cW5Fb1U49/XK0OyrChsC1Cgx3A0qOzEk+
         lMrMAzID6TB/0kCVZqVGfvXo3abq63zJRvC5wh8tiA+d5I3UyvUIxLQ7AtXj8m/kCeT+
         Qaf+WPIbJyPD+mbVSwdVwieX150dnIZnlzIznnzZI8soNcrfIcUf7S0CQKHIsS6qshEr
         fqFg==
X-Gm-Message-State: ACgBeo1wSxJTWtVpWbU0eo3xkQqB7xQHQwzzccBBEWje/pRVHoDq2dc1
        4svhnOomOOkIejGMqo2kfrupTw==
X-Google-Smtp-Source: AA6agR7nbIA1W9kvuTBrsjatx+y+trLViCt2NS014KwbWMIhl7WPsCOj2Q0c6fDtZvYCVRpwve0F1w==
X-Received: by 2002:ac2:4f03:0:b0:48a:6061:bd8e with SMTP id k3-20020ac24f03000000b0048a6061bd8emr1247397lfr.647.1660303548058;
        Fri, 12 Aug 2022 04:25:48 -0700 (PDT)
Received: from [192.168.1.39] ([83.146.140.105])
        by smtp.gmail.com with ESMTPSA id b20-20020a196714000000b0048a9a756763sm188699lfc.19.2022.08.12.04.25.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Aug 2022 04:25:47 -0700 (PDT)
Message-ID: <14cf568e-d7ee-886e-5122-69b2e58b8717@linaro.org>
Date:   Fri, 12 Aug 2022 14:25:42 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH net 1/2] dt: ar803x: Document disable-hibernation property
Content-Language: en-US
To:     Wei Fang <wei.fang@nxp.com>, "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20220812145009.1229094-1-wei.fang@nxp.com>
 <20220812145009.1229094-2-wei.fang@nxp.com>
 <0cd22a17-3171-b572-65fb-e9d3def60133@linaro.org>
 <DB9PR04MB81060AF4890DEA9E2378940288679@DB9PR04MB8106.eurprd04.prod.outlook.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <DB9PR04MB81060AF4890DEA9E2378940288679@DB9PR04MB8106.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/08/2022 12:02, Wei Fang wrote:
> 
> 
>> -----Original Message-----
>> From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>> Sent: 2022年8月12日 15:28
>> To: Wei Fang <wei.fang@nxp.com>; andrew@lunn.ch; hkallweit1@gmail.com;
>> linux@armlinux.org.uk; davem@davemloft.net; edumazet@google.com;
>> kuba@kernel.org; pabeni@redhat.com; robh+dt@kernel.org;
>> krzysztof.kozlowski+dt@linaro.org; f.fainelli@gmail.com;
>> netdev@vger.kernel.org; devicetree@vger.kernel.org;
>> linux-kernel@vger.kernel.org
>> Subject: Re: [PATCH net 1/2] dt: ar803x: Document disable-hibernation
>> property
>>
>> On 12/08/2022 17:50, wei.fang@nxp.com wrote:
>>> From: Wei Fang <wei.fang@nxp.com>
>>>
>>
>> Please use subject prefix matching subsystem.
>>
> Ok, I'll add the subject prefix.
> 
>>> The hibernation mode of Atheros AR803x PHYs is default enabled.
>>> When the cable is unplugged, the PHY will enter hibernation mode and
>>> the PHY clock does down. For some MACs, it needs the clock to support
>>> it's logic. For instance, stmmac needs the PHY inputs clock is present
>>> for software reset completion. Therefore, It is reasonable to add a DT
>>> property to disable hibernation mode.
>>>
>>> Signed-off-by: Wei Fang <wei.fang@nxp.com>
>>> ---
>>>  Documentation/devicetree/bindings/net/qca,ar803x.yaml | 6 ++++++
>>>  1 file changed, 6 insertions(+)
>>>
>>> diff --git a/Documentation/devicetree/bindings/net/qca,ar803x.yaml
>>> b/Documentation/devicetree/bindings/net/qca,ar803x.yaml
>>> index b3d4013b7ca6..d08431d79b83 100644
>>> --- a/Documentation/devicetree/bindings/net/qca,ar803x.yaml
>>> +++ b/Documentation/devicetree/bindings/net/qca,ar803x.yaml
>>> @@ -40,6 +40,12 @@ properties:
>>>        Only supported on the AR8031.
>>>      type: boolean
>>>
>>> +  qca,disable-hibernation:
>>> +    description: |
>>> +    If set, the PHY will not enter hibernation mode when the cable is
>>> +    unplugged.
>>
>> Wrong indentation. Did you test the bindings?
>>
> Sorry, I just checked the patch and forgot to check the dt-bindings.
> 
>> Unfortunately the property describes driver behavior not hardware, so it is not
>> suitable for DT. Instead describe the hardware
>> characteristics/features/bugs/constraints. Not driver behavior. Both in property
>> name and property description.
>>
> Thanks for your review and feedback. Actually, the hibernation mode is a feature of hardware, I will modify the property name and description to be more in line with the requirements of the DT property. 

hibernation is a feature, but 'disable-hibernation' is not. DTS
describes the hardware, not policy or driver bejhvior. Why disabling
hibernation is a property of hardware? How you described, it's not,
therefore either property is not for DT or it has to be phrased
correctly to describe the hardware.

Best regards,
Krzysztof
