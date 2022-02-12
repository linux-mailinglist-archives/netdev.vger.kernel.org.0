Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 298F14B32E8
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 04:56:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbiBLD4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 22:56:35 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:37966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiBLD4f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 22:56:35 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C6502253D;
        Fri, 11 Feb 2022 19:56:32 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id c5-20020a17090a1d0500b001b904a7046dso12149690pjd.1;
        Fri, 11 Feb 2022 19:56:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=zJj9zgoCucZR8YEACJzfUgDMur+QuTHGQAjV5TFq/H8=;
        b=TDJN6VYeKVHi9LKZinNAUNG2bINXn2HXgbW07h24hHzwqdN8IpC3OXLWhdEKF7NWr4
         P54zzriAX+8X4NUgQ48tC/uQGHNwYAXcYHvy35zjmxdt6vbxIqYgbg5MX5zu7Sd4w/LK
         OWsG07YHIpfcmEo6kXWjSB2rAOKhZDkExirBOc4ybQr+O7NESzTEx+TNcaJAoSom2vVT
         mAGwHpdcpYq/4dIKH8DuRFjWxcNGuFlirp0vcZHLAeaVZ0Hj2eFscEPwE/KCraOs6wOL
         UHskqAfG1qCkNtJjSV1tKnXYyBOB6qi8+2vG8NaXy40R87u+/oZv1Evevao1rmZEJqEj
         lyZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=zJj9zgoCucZR8YEACJzfUgDMur+QuTHGQAjV5TFq/H8=;
        b=wZCNkibxMInLu6VwLOBirYmJQOgNbzQrjcAxVacBH2Yw7Pa0kb9fV+yZAdkqHyC4Ze
         L2bRlCSolOkkyBr7Z6JtiVc+5pIz99BvFMnLrTQcLAD3OEvgUKlJcapNNXccVRUMqlyl
         u90sf0xYOm6UYt6uzqolSXgVUv2NGfZz9i2qRESVse+vrOgEwP6+07Of9F2husfip3nV
         3mfDYlqpB4ECcVXj5CNnHSFqVZ8cmvd0cm2v92ZEPJlhD4GxMYv2Ma5owI+B/a+RGCzz
         WeVxQmB/b91UWCdF26t2pRMB1NmIBehlc9y2t5G0dviSx0TNRk0Me/IX+p/goeJJrEh2
         Fb/A==
X-Gm-Message-State: AOAM531v+Peuk/+foag5lRMYoXmbiyyLOESbjGGUNZE87X0LRLSzkkcp
        GK5JFg+NFpWqZcMaIOn2BVA=
X-Google-Smtp-Source: ABdhPJyOBtK5jnmcoEd3R8Ic6soCfcRdXQL1aQNgdbGhCT5RV9pa3AvqKK6oeNssicxFs+C+YGdyMA==
X-Received: by 2002:a17:902:b941:: with SMTP id h1mr4454207pls.73.1644638191969;
        Fri, 11 Feb 2022 19:56:31 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:4a48:b84a:fcb5:bf5e:eb1b? ([2600:8802:b00:4a48:b84a:fcb5:bf5e:eb1b])
        by smtp.gmail.com with ESMTPSA id k21sm28743800pff.33.2022.02.11.19.56.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Feb 2022 19:56:31 -0800 (PST)
Message-ID: <d8e5f6a8-a7e1-dabd-f4b4-ea8ea21d0a1d@gmail.com>
Date:   Fri, 11 Feb 2022 19:56:28 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH v8 net-next 01/10] dt-bindings: net: dsa: dt bindings for
 microchip lan937x
Content-Language: en-US
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        andrew@lunn.ch, netdev@vger.kernel.org, olteanv@gmail.com,
        robh+dt@kernel.org
Cc:     UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        vivien.didelot@gmail.com, devicetree@vger.kernel.org,
        Rob Herring <robh@kernel.org>
References: <20220207172204.589190-1-prasanna.vengateshan@microchip.com>
 <20220207172204.589190-2-prasanna.vengateshan@microchip.com>
 <88caec5c-c509-124e-5f6b-22b94f968aea@gmail.com>
 <ebf1b233da821e2cd3586f403a1cdc2509671cde.camel@microchip.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <ebf1b233da821e2cd3586f403a1cdc2509671cde.camel@microchip.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/9/2022 3:58 AM, Prasanna Vengateshan wrote:
> On Mon, 2022-02-07 at 18:53 -0800, Florian Fainelli wrote:
>> EXTERNAL EMAIL: Do not click links or open attachments unless you know the
>> content is safe
>>
>> On 2/7/2022 9:21 AM, Prasanna Vengateshan wrote:
>>> Documentation in .yaml format and updates to the MAINTAINERS
>>> Also 'make dt_binding_check' is passed.
>>>
>>> RGMII internal delay values for the mac is retrieved from
>>> rx-internal-delay-ps & tx-internal-delay-ps as per the feedback from
>>> v3 patch series.
>>> https://lore.kernel.org/netdev/20210802121550.gqgbipqdvp5x76ii@skbuf/
>>>
>>> It supports only the delay value of 0ns and 2ns.
>>>
>>> Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
>>> Reviewed-by: Rob Herring <robh@kernel.org>
>>> ---
>>>    .../bindings/net/dsa/microchip,lan937x.yaml   | 179 ++++++++++++++++++
>>>    MAINTAINERS                                   |   1 +
>>>    2 files changed, 180 insertions(+)
>>>    create mode 100644
>>> Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
>>>
>>> +    maxItems: 1
>>> +
>>> +  mdio:
>>> +    $ref: /schemas/net/mdio.yaml#
>>> +    unevaluatedProperties: false
>>
>> This should be moved to dsa.yaml since this is about describing the
>> switch's internal MDIO bus controller. This is applicable to any switch,
>> really.
> 
> Thanks for your review and feedback. Do you mean that 'mdio' to be added in
> dsa.yaml instead adding here?

Yes indeed, since this is a common property of all DSA switches, it can 
be defined or not depending on whether the switch does have an internal 
MDIO bus controller or not.

> 
>>
>>> +
>>> +patternProperties:
>>> +  "^(ethernet-)?ports$":
>>> +    patternProperties:
>>> +      "^(ethernet-)?port@[0-7]+$":
>>> +        allOf:
>>> +          - if:
>>> +              properties:
>>> +                phy-mode:
>>> +                  contains:
>>> +                    enum:
>>> +                      - rgmii
>>> +                      - rgmii-rxid
>>> +                      - rgmii-txid
>>> +                      - rgmii-id
>>> +            then:
>>> +              properties:
>>> +                rx-internal-delay-ps:
>>> +                  $ref: "#/$defs/internal-delay-ps"
>>> +                tx-internal-delay-ps:
>>> +                  $ref: "#/$defs/internal-delay-ps"
>>
>> Likewise, this should actually be changed in ethernet-controller.yaml
> 
> There is *-internal-delay-ps property defined for mac in ethernet-
> controller.yaml. Should that be changed like above?

It seems to me that these properties override whatever 'phy-mode' 
property is defined, but in premise you are right that this is largely 
applicable to RGMII only. I seem to recall that the QCA8K driver had 
some sort of similar delay being applied even in SGMII mode but I am not 
sure if we got to the bottom of this.

Please make sure that this does not create regressions for other DTS in 
the tree before going with that change in ethernet-controller.yaml.

Thanks!
-- 
Florian
