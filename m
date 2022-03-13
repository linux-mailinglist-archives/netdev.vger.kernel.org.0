Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E90874D76A6
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 17:10:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234973AbiCMQLO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Mar 2022 12:11:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiCMQLN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Mar 2022 12:11:13 -0400
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75D7626564;
        Sun, 13 Mar 2022 09:10:05 -0700 (PDT)
Received: by mail-ed1-f47.google.com with SMTP id t1so16498225edc.3;
        Sun, 13 Mar 2022 09:10:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:content-language:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=u8bQocCu7+BWd2wXu/r5WL7YQLXrKPOJ0zyslcPG8rg=;
        b=RBSOCQKoZXiub3rmTcCWiDkoZA7YoOdiCV9DVh1rRwPdSryCJAtIkANZHEDOJS872E
         sHXFRYGpoHS8SLE0rm39QPdOLK5tWG93zCXtxxhITSjHM9x06TLVdyMGxOH3yHX4kCwE
         5vDbHuaZ18MmskpwYx2hIl/NXvmKtLR0DU0RhAy/ZgNrtxN/7jg2B5FYGhk8iMKc55GO
         n8RckuJxhvbLwnQebowE4X94vp3htcyEBoMmZBm5PUzFi0vO+iWSmT64pzhJxwWqJDKe
         5NQBjltufOCSOFkn22tXy1QlwQuSwavUtTjdCkMyBaOAaKgNc45E6xWW8R3jTKARiv6Q
         AHzA==
X-Gm-Message-State: AOAM531PgPvaZ939/7I+eSZSM4bk1scAtEZ0Qm4rVxy5DvIXo+UAEU/Q
        DEQ26smb5VayStnIIa40OP5GnlAEWKM=
X-Google-Smtp-Source: ABdhPJzEWGkwnv6d819epLuSt1JobOIpBGfSTwGt4yj9R+qVneNoFCVpjowCAJIw0oFiC1VR5TKewA==
X-Received: by 2002:a50:d550:0:b0:416:2ac8:b98e with SMTP id f16-20020a50d550000000b004162ac8b98emr17167215edj.236.1647187803964;
        Sun, 13 Mar 2022 09:10:03 -0700 (PDT)
Received: from [192.168.0.152] (xdsl-188-155-174-239.adslplus.ch. [188.155.174.239])
        by smtp.googlemail.com with ESMTPSA id i6-20020a17090685c600b006daecf0b350sm5689279ejy.75.2022.03.13.09.10.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Mar 2022 09:10:03 -0700 (PDT)
Message-ID: <2d35127c-d4ef-6644-289a-5c10bcbbbf84@kernel.org>
Date:   Sun, 13 Mar 2022 17:10:02 +0100
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
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220313002536.13068-1-michael@walle.cc>
 <20220313002536.13068-2-michael@walle.cc>
 <08b89b3f-d0d3-e96f-d1c3-80e8dfd0798f@kernel.org>
 <d18291ff8d81f03a58900935d92115f2@walle.cc>
In-Reply-To: <d18291ff8d81f03a58900935d92115f2@walle.cc>
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

On 13/03/2022 11:47, Michael Walle wrote:
> Hi Krzysztof,
> 
> Am 2022-03-13 10:47, schrieb Krzysztof Kozlowski:
>> On 13/03/2022 01:25, Michael Walle wrote:
>>> The MDIO controller has support to release the internal PHYs from 
>>> reset
>>> by specifying a second memory resource. This is different between the
>>> currently supported SparX-5 and the LAN966x. Add a new compatible to
>>> distiguish between these two.

Typo here, BTW.

>>>
>>> Signed-off-by: Michael Walle <michael@walle.cc>
>>> ---
>>>  Documentation/devicetree/bindings/net/mscc-miim.txt | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/Documentation/devicetree/bindings/net/mscc-miim.txt 
>>> b/Documentation/devicetree/bindings/net/mscc-miim.txt
>>> index 7104679cf59d..a9efff252ca6 100644
>>> --- a/Documentation/devicetree/bindings/net/mscc-miim.txt
>>> +++ b/Documentation/devicetree/bindings/net/mscc-miim.txt
>>> @@ -2,7 +2,7 @@ Microsemi MII Management Controller (MIIM) / MDIO
>>>  =================================================
>>>
>>>  Properties:
>>> -- compatible: must be "mscc,ocelot-miim"
>>> +- compatible: must be "mscc,ocelot-miim" or "mscc,lan966x-miim"
>>
>> No wildcards, use one, specific compatible.
> 
> I'm in a kind of dilemma here, have a look yourself:
> grep -r "lan966[28x]-" Documentation
> 
> Should I deviate from the common "name" now? To make things
> worse, there was a similar request by Arnd [1]. But the
> solution feels like cheating ("lan966x" -> "lan966") ;)

The previous 966x cases were added by one person from Microchip, so he
actually might know something. But do you know whether lan966x will
cover all current and future designs from Microchip? E.g. lan9669 (if
ever made) will be the same? Avoiding wildcard is the easiest, just
choose one implementation, e.g. "lan9662".

Different topic is that all current lan966[28] are from Microchip and
you still add Microsemi, even though it was acquired by Microchip.
That's an inconsistency which should be rather fixed.

> 
> On a side note, I understand that there should be no wildcards,
> because the compatible should target one specific implementation,
> right? But then the codename "ocelot" represents a whole series of
> chips. Therefore, names for whole families shouldn't be used neither,
> right?

You're not adding "ocelot" now, so it is separate topic. However a
compatible like "mscc,ocelot" feels wrong, unless it is used as a
fallback (see: git grep 'apple,').


Best regards,
Krzysztof
