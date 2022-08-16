Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35127596576
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 00:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237984AbiHPW0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 18:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237741AbiHPW0a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 18:26:30 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B1458FD78;
        Tue, 16 Aug 2022 15:26:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1660688754; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=iPK7Jhd8ypbEHwD/n+VtVEaj5rJAQKANFd4jbZYUJqfyaHpikst0/xxoi9x4uZS49n27Lfcc9NYd/R34Wjsv8KiKpTM//U4ghN7MxqKNRw60srjH9/hl8Ov/6e4W1mmpgKie9yQoo4JejvmbC8by3ugeVTX5uF6vPJGnkm4xZjs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1660688754; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=qZYvwhY+9f843t/9+9YeemY82s4b/y6qSCIkArr4MHo=; 
        b=LX0p2Bqi7yEFJCOKc5jBnZMoCsjDwBkAUDAe9VERP0ll/nwFaGWYNO3F3fIXrgfM+OmjTkm2NUH56R0gDXRDEvqZNOEQDUuXWr26TYBlTPlaEBTfV2gOLeHYbRONxoZZNgkVno2pR4B4rJA2a63Dv2OY/HiCwZ6XZuvTNrxLCTk=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1660688754;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=qZYvwhY+9f843t/9+9YeemY82s4b/y6qSCIkArr4MHo=;
        b=R191Jh7nPNErVKrhNalKb34SdbPW1G6pI6ieMvF9bSLuGQ8Y85GW6iNLP99Eo37x
        AlvySHC3n41V4KyccZ5H8V/61wY8vzze6yzUyNiTUclYS/Kfc1JbsmWs7dQLW7cTSXu
        MM0BG4eDpRyH35h3RUkTbxte2yVojwwvuDQf073M=
Received: from [10.10.10.3] (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1660688751681828.667318330111; Tue, 16 Aug 2022 15:25:51 -0700 (PDT)
Message-ID: <87f7dd90-d6b3-dad6-fe46-0b4ce38d9c29@arinc9.com>
Date:   Wed, 17 Aug 2022 01:25:44 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2 2/7] dt-bindings: net: dsa: mediatek,mt7530: fix reset
 lines
Content-Language: en-US
To:     Rob Herring <robh@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
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
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20220813154415.349091-1-arinc.unal@arinc9.com>
 <20220813154415.349091-3-arinc.unal@arinc9.com>
 <20220816205228.GA2709277-robh@kernel.org>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20220816205228.GA2709277-robh@kernel.org>
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

On 16.08.2022 23:52, Rob Herring wrote:
> On Sat, Aug 13, 2022 at 06:44:10PM +0300, Arınç ÜNAL wrote:
>> - Fix description of mediatek,mcm. mediatek,mcm is not used on MT7623NI.
>> - Add description for reset-gpios.
>> - Invalidate reset-gpios if mediatek,mcm is used.
>> - Invalidate mediatek,mcm if the compatible device is mediatek,mt7531.
>> - Require mediatek,mcm for the described MT7621 SoCs as the compatible
>> string is only used for MT7530 which is a part of the multi-chip module.
> 
> The commit message should answer 'why is this change needed/wanted?' not
> 'what changed'. I can read the diff to see what changed.

I'll explain why to invalidating reset-gpios and mediatek,mcm.

> 
> d>
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
>> +            - const: mediatek,mt7531
>> +    then:
>> +      properties:
>> +        mediatek,mcm: false
>> +
>> +  - if:
>> +      properties:
>> +        compatible:
>> +          items:
>> +            - const: mediatek,mt7621
>> +    then:
>> +      required:
>> +        - mediatek,mcm
>> +
>>   unevaluatedProperties: false
>>   
>>   examples:
>> -- 
>> 2.34.1
>>
>>
