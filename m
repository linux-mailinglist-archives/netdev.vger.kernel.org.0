Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAEBA59E6B0
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 18:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244115AbiHWQND (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 12:13:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244107AbiHWQMe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 12:12:34 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F954101D18;
        Tue, 23 Aug 2022 05:32:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1661257896; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=P6EIK7KjGJkQkFCZc60aNu46Ap8gaxZqPsoF83NG1V5IiP2sn8nEONPow8BNWdW6VfTtTjjSHRRT0gP2Li/W6QgTBN6T0oqW0/sin0BJIKEPiowLPea8n7WxT/zwpcQRxq1wv3FIVXbF/LC7P4/qCWTIfydaCL607U3McivNbsc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1661257896; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=Kg0sfx0WR/crCntEVY1ryFztDVm96fjR6hhnhNvqiVo=; 
        b=CSxlUi4YjDQSlin5fgI/oOYtx9n4qC2ewhNemKRGsgETRPYAcYieMVd3EFxJr8L7AOKHi5cu179YYKx0BHY1G64Jbftb6ZbDvjSHI4hZjcaov8HtTCvRafoRvSn4xXi7zWDS0xZv3YxHqSlXd7Z89GuFFK77LWcravDR2pSSy3I=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1661257896;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=Kg0sfx0WR/crCntEVY1ryFztDVm96fjR6hhnhNvqiVo=;
        b=RsvgFiy43OJmJBpw8P+Usl7X4egqr59jbpgzCeMjq7Jzxff8EmDwXphItkWrb6sf
        ydwDITP8zcO0rMhfefchEWHWsKL/0lHioOfWr9wHtLxJIAdLYAaMz/9W+C46nKI1GRB
        kv8EMVS/c+iOgw51O3kVZ2hMQPCgFhTjRqmY/toY=
Received: from [10.10.10.3] (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1661257894955331.02530845137676; Tue, 23 Aug 2022 05:31:34 -0700 (PDT)
Message-ID: <715237fb-05e6-553b-ace3-7b21eee0a5c9@arinc9.com>
Date:   Tue, 23 Aug 2022 15:31:27 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v4 2/6] dt-bindings: net: dsa: mediatek,mt7530: fix reset
 lines
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Sander Vanheule <sander@svanheule.net>,
        =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>,
        Daniel Golle <daniel@makrotopia.org>, erkin.bozoglu@xeront.com,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20220820080758.9829-1-arinc.unal@arinc9.com>
 <20220820080758.9829-3-arinc.unal@arinc9.com>
 <cf10e888-7fe2-7cf8-091a-40207eeb78b5@linaro.org>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <cf10e888-7fe2-7cf8-091a-40207eeb78b5@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23.08.2022 13:44, Krzysztof Kozlowski wrote:
> On 20/08/2022 11:07, Arınç ÜNAL wrote:
>> - Fix description of mediatek,mcm. mediatek,mcm is not used on MT7623NI.
> 
> Separate commit. You are still doing here few things at a time.

Will split.

> 
>> - Add description for reset-gpios.
>> - Invalidate reset-gpios if mediatek,mcm is used. We cannot use multiple
>> reset lines at the same time.
>> - Invalidate mediatek,mcm if the compatible device is mediatek,mt7531.
>> There is no multi-chip module version of mediatek,mt7531.
>> - Require mediatek,mcm for mediatek,mt7621 as the compatible string is only
>> used for the multi-chip module version of MT7530.
>>
>> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
>> ---
>>   .../bindings/net/dsa/mediatek,mt7530.yaml     | 31 +++++++++++++++++--
>>   1 file changed, 28 insertions(+), 3 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
>> index edf48e917173..4c99266ce82a 100644
>> --- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
>> +++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
>> @@ -110,11 +110,15 @@ properties:
>>     mediatek,mcm:
>>       type: boolean
>>       description:
>> -      if defined, indicates that either MT7530 is the part on multi-chip
>> -      module belong to MT7623A has or the remotely standalone chip as the
>> -      function MT7623N reference board provided for.
>> +      Used for MT7621AT, MT7621DAT, MT7621ST and MT7623AI SoCs which the MT7530
>> +      switch is a part of the multi-chip module.
>>   
>>     reset-gpios:
>> +    description:
>> +      GPIO to reset the switch. Use this if mediatek,mcm is not used.
>> +      This property is optional because some boards share the reset line with
>> +      other components which makes it impossible to probe the switch if the
>> +      reset line is used.
>>       maxItems: 1
>>   
>>     reset-names:
>> @@ -165,6 +169,9 @@ allOf:
>>         required:
>>           - mediatek,mcm
>>       then:
>> +      properties:
>> +        reset-gpios: false
>> +
>>         required:
>>           - resets
>>           - reset-names
>> @@ -182,6 +189,24 @@ allOf:
>>           - core-supply
>>           - io-supply
>>   
>> +  - if:
>> +      properties:
>> +        compatible:
>> +          items:
> 
> Again, not items. This can be just const or enum.

Will do.

> 
>> +            - const: mediatek,mt7531
>> +    then:
>> +      properties:
>> +        mediatek,mcm: false
>> +
>> +  - if:
>> +      properties:
>> +        compatible:
>> +          items:
> 
> Ditto.
Arınç
