Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5064D7765
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 18:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235194AbiCMR5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Mar 2022 13:57:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230184AbiCMR5S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Mar 2022 13:57:18 -0400
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74CB166624;
        Sun, 13 Mar 2022 10:56:10 -0700 (PDT)
Received: by mail-ed1-f52.google.com with SMTP id y8so11836922edl.9;
        Sun, 13 Mar 2022 10:56:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:content-language:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=0aZON1Wq//j7mX04pZuwIDlK5cNFukJvPX8pTmUlkMs=;
        b=WrUUQWv9f8T1/hzd1+pSgF0in7Qtj529hNzZawD6Vrgjn5E4TfwAYm3m6ZW5b/n+2D
         czElJAs5CYpCrTyYu8r6jYlYRnrDthrwg3VAIyqBmPhl/QyIqup0CRSqSw4O9EoWPW/f
         8iHlJKlav56JDELG/oG/4W7qmoapJcR+SQ9rRf9SlFp2N/rVpMGpejMoxfVb4jsyy0N5
         4221tudn2FGxTDG6NzraTCMnexVwtXv8dq892PiWzpHmuNvK9nz2y8ZwoQ91F3GLyzfm
         qTOjSJ82XRxC9nmdDj94fuzm6TCxioAW6Yf5uqPVFmxS8nTU/cWea9lw7ahLD+hIGCLQ
         jEUw==
X-Gm-Message-State: AOAM532HCD9omPVXhoJ2zkV0lm8OliJqIg3KhPiFnsYdt7UfPTf+KWOV
        IosU1L0kJs1V0SkkeeSlvrU=
X-Google-Smtp-Source: ABdhPJxb9BGDPDRF+haUxi7gJn2FiQ8XSIFwcMXuBNSqXSW48rqQE1T0Ysb+hvL66m+GHppi+CtEhQ==
X-Received: by 2002:a05:6402:b87:b0:416:44f5:10d1 with SMTP id cf7-20020a0564020b8700b0041644f510d1mr17058952edb.323.1647194168963;
        Sun, 13 Mar 2022 10:56:08 -0700 (PDT)
Received: from [192.168.0.152] (xdsl-188-155-174-239.adslplus.ch. [188.155.174.239])
        by smtp.googlemail.com with ESMTPSA id w19-20020a05640234d300b00416baf4cdcasm5255287edc.48.2022.03.13.10.56.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Mar 2022 10:56:08 -0700 (PDT)
Message-ID: <58b36464-c679-c01a-2186-90d6380d8ecd@kernel.org>
Date:   Sun, 13 Mar 2022 18:56:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
From:   Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH net-next v2 1/3] dt-bindings: net: mscc-miim: add lan966x
 compatible
Content-Language: en-US
To:     Michael Walle <michael@walle.cc>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Kavyasree Kotagiri <kavyasree.kotagiri@microchip.com>
References: <20220313002536.13068-1-michael@walle.cc>
 <20220313002536.13068-2-michael@walle.cc>
 <08b89b3f-d0d3-e96f-d1c3-80e8dfd0798f@kernel.org>
 <d18291ff8d81f03a58900935d92115f2@walle.cc>
 <2d35127c-d4ef-6644-289a-5c10bcbbbf84@kernel.org>
 <145fc079ce8c266b8c2265aacfd3b077@walle.cc>
In-Reply-To: <145fc079ce8c266b8c2265aacfd3b077@walle.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/03/2022 17:30, Michael Walle wrote:
> [adding Horatiu and Kavyasree from Microchip]
> 
> Am 2022-03-13 17:10, schrieb Krzysztof Kozlowski:
>> On 13/03/2022 11:47, Michael Walle wrote:
>>> Am 2022-03-13 10:47, schrieb Krzysztof Kozlowski:
>>>> On 13/03/2022 01:25, Michael Walle wrote:
>>>>> The MDIO controller has support to release the internal PHYs from
>>>>> reset
>>>>> by specifying a second memory resource. This is different between 
>>>>> the
>>>>> currently supported SparX-5 and the LAN966x. Add a new compatible to
>>>>> distiguish between these two.
>>
>> Typo here, BTW.
>>
>>>>>
>>>>> Signed-off-by: Michael Walle <michael@walle.cc>
>>>>> ---
>>>>>  Documentation/devicetree/bindings/net/mscc-miim.txt | 2 +-
>>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/Documentation/devicetree/bindings/net/mscc-miim.txt
>>>>> b/Documentation/devicetree/bindings/net/mscc-miim.txt
>>>>> index 7104679cf59d..a9efff252ca6 100644
>>>>> --- a/Documentation/devicetree/bindings/net/mscc-miim.txt
>>>>> +++ b/Documentation/devicetree/bindings/net/mscc-miim.txt
>>>>> @@ -2,7 +2,7 @@ Microsemi MII Management Controller (MIIM) / MDIO
>>>>>  =================================================
>>>>>
>>>>>  Properties:
>>>>> -- compatible: must be "mscc,ocelot-miim"
>>>>> +- compatible: must be "mscc,ocelot-miim" or "mscc,lan966x-miim"
>>>>
>>>> No wildcards, use one, specific compatible.
>>>
>>> I'm in a kind of dilemma here, have a look yourself:
>>> grep -r "lan966[28x]-" Documentation
>>>
>>> Should I deviate from the common "name" now? To make things
>>> worse, there was a similar request by Arnd [1]. But the
>>> solution feels like cheating ("lan966x" -> "lan966") ;)
>>
>> The previous 966x cases were added by one person from Microchip, so he
>> actually might know something. But do you know whether lan966x will
>> cover all current and future designs from Microchip? E.g. lan9669 (if
>> ever made) will be the same? Avoiding wildcard is the easiest, just
>> choose one implementation, e.g. "lan9662".
> 
> So if Microchip would review/ack this it would be ok? I don't really
> have a strong opinion, I just want to avoid any inconsistencies. If no
> one from Microchip will answer, I'll use microchip,lan9668-miim.

Sure.

Best regards,
Krzysztof
