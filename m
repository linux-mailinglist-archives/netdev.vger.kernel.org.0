Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF3CD6DFCE0
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 19:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbjDLRpz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 13:45:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjDLRpy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 13:45:54 -0400
Received: from sender3-op-o19.zoho.com (sender3-op-o19.zoho.com [136.143.184.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32DED4EEA;
        Wed, 12 Apr 2023 10:45:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1681321506; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=cNGVRv7eKsGOjCKvg2uYtWqlSufHiEoKNQywk8rTaf96M5CzDeCJxf/NUylHApDJLKNuL/TqixqBPpEMTFY6fFSU1sFOtq/mmtbna4viPksXbsKW8nH7le+RU1e0582J7RCmTpXp72lUFoL4h8e9MCVl7g+SoeLqIQLXOlOjMwQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1681321506; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=gBNrHe9ZW+eOs2pOSkknYiLXYHRJR067BuOYoakffbY=; 
        b=jw4hdoKKoSHw75qQr8HDIkHBf8gOxDHvkLSVr1yHA3cD6EOSkSEEqfYZ1GOxUeY9QouVWNyGkf9rLqiBuntpdUzqJ++PBxZK7oISiiesNGJnI88lFrwy0lP0lp/XQ0dOyQh1PBFw+aRRQS5r0NhMUfUbvPUx0XbMJmQwPVAYgdw=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1681321506;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=gBNrHe9ZW+eOs2pOSkknYiLXYHRJR067BuOYoakffbY=;
        b=h1Rl3UUw+HsXoJklhYXycGX0FORTnzR/skaZI5oR/pVl9L5W2KIqwyEMuLP+cp+v
        kqTV99QSOOMrGkDErsRO65t6Rn1tU20pYwk4xUF71NYnEPTgF3Hpz7m5Zoi14z/QCi8
        zyA3K1J9/OLAPj2EMBcA//gsOPS09ZmADByWgNTM=
Received: from [10.10.9.4] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
        with SMTPS id 1681321503790696.0069063619653; Wed, 12 Apr 2023 10:45:03 -0700 (PDT)
Message-ID: <2b23a4bf-cacc-cb6c-f0a4-e71f640729cc@arinc9.com>
Date:   Wed, 12 Apr 2023 20:44:53 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 3/7] dt-bindings: net: dsa: mediatek,mt7530: add port
 bindings for MT7988
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>
Cc:     erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
References: <20230406080141.22924-1-arinc.unal@arinc9.com>
 <20230406080141.22924-3-arinc.unal@arinc9.com>
 <23c8c4b5-baaa-b72b-4103-b415d970acf2@linaro.org>
 <5b3a10ff-e960-1c6e-3482-cb25200c83c6@arinc9.com>
 <951841d3-59a4-fa86-5b45-46afdb2942dd@linaro.org>
 <5a92419c-4d2c-a169-687b-026dc6094cd8@arinc9.com>
 <153a5ed0-5f4f-4879-2677-e5bce5453634@linaro.org>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <153a5ed0-5f4f-4879-2677-e5bce5453634@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12.04.2023 19:39, Krzysztof Kozlowski wrote:
> On 07/04/2023 11:46, Arınç ÜNAL wrote:
>> On 7.04.2023 12:07, Krzysztof Kozlowski wrote:
>>> On 06/04/2023 21:18, Arınç ÜNAL wrote:
>>>> On 6.04.2023 22:07, Krzysztof Kozlowski wrote:
>>>>> On 06/04/2023 10:01, arinc9.unal@gmail.com wrote:
>>>>>> From: Arınç ÜNAL <arinc.unal@arinc9.com>
>>>>>>
>>>>>> The switch on MT7988 has got only port 6 as a CPU port. The only phy-mode
>>>>>> to be used is internal. Add this.
>>>>>>
>>>>>> Some bindings are incorrect for this switch now, so move them to more
>>>>>> specific places.
>>>>>>
>>>>>> Address the incorrect information of which ports can be used as a user
>>>>>> port. Any port can be used as a user port.
>>>>>>
>>>>>> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
>>>>>> ---
>>>>>>     .../bindings/net/dsa/mediatek,mt7530.yaml     | 63 ++++++++++++++-----
>>>>>>     1 file changed, 46 insertions(+), 17 deletions(-)
>>>>>>
>>>>>> diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
>>>>>> index 7045a98d9593..605888ce2bc6 100644
>>>>>> --- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
>>>>>> +++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
>>>>>> @@ -160,22 +160,6 @@ patternProperties:
>>>>>>           "^(ethernet-)?port@[0-9]+$":
>>>>>>             type: object
>>>>>>     
>>>>>> -        properties:
>>>>>> -          reg:
>>>>>> -            description:
>>>>>> -              Port address described must be 5 or 6 for CPU port and from 0 to 5
>>>>>> -              for user ports.
>>>>>> -
>>>>>> -        allOf:
>>>>>> -          - if:
>>>>>> -              required: [ ethernet ]
>>>>>> -            then:
>>>>>> -              properties:
>>>>>> -                reg:
>>>>>> -                  enum:
>>>>>> -                    - 5
>>>>>> -                    - 6
>>>>>> -
>>>>>
>>>>> I have doubts that the binding is still maintainable/reviewable. First,
>>>>> why do you need all above patterns after removal of entire contents?
>>>>
>>>> The 'type: object' item is still globally used. I'd have to define that
>>>> on each definitions, I suppose?
>>>
>>> Doesn't it come from dsa.yaml/dsa-port.yaml schema?
>>
>> It comes from dsa.yaml#/$defs/ethernet-ports which this schema already
>> refers to. I'll remove the patterns above.
>>
>> Though 'type: object' is not there for "^(ethernet-)?port@[0-9]+$". I
>> think I should add it there as the dsa-port.yaml schema defines the
>> properties of the DSA switch port object.
> 
> It has ref, which is enough.
> 
>> So the value matching the
>> "^(ethernet-)?port@[0-9]+$" regular expression is expected to be an
>> object conforming to the structure defined in dsa-port.yaml.
>>
>> Does that make sense?
> 
> Hm, no, sorry, I still do not see what exactly is missing from
> dsa.yaml/port that you need to define here.

Nothing, I forgot defining either ref or type is enough.

Arınç
