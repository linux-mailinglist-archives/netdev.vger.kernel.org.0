Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEB646DA0EE
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 21:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240335AbjDFTTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 15:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240038AbjDFTTi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 15:19:38 -0400
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0748A213E;
        Thu,  6 Apr 2023 12:19:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1680808741; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=Hp9mo9y/mjafGapyQczZVlad+8CSGNJUpCIF4eDU6EbAyO3uJl0H1GY+a5Yfj9Sjr33xAMV0Xckx9uHojpjgnqqCwVYEvi/njtVlfcXBEiFighZ7Iok6LFW2dz07TTMuUqdwqW/sgq+xb2Dv4OZpizjPKKqdw3itc7wgZ/xjwqE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1680808741; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=lWWci+lrJXVbFfP28Kyr0CNGSZHTByAVqFq1NMWsDvo=; 
        b=TlZ8hv0cdA/lVQcf58skLejVYg8t1qFdBpwHxkDGwpEGuY5PBr3JNWxXQ/wG88n1I5hfDHof/ZisSB7hF/yTSVdsLawdM1MhcLPd7juK5LXum5PRrR6R7PsD07ZxjYV1Hvse6STVG95GVdSuqo293tHZXQjaWNOlfE4c15a6U/M=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1680808741;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=lWWci+lrJXVbFfP28Kyr0CNGSZHTByAVqFq1NMWsDvo=;
        b=KBDx7bi5RulXnw7eT41euWDN5N0tswvitovUr6nXDxScbhiKn9e2U2oLEZKmdgnT
        5O5xmLJPrygN86f0Rgq/0Zn3XjMdzdkEgMCl7NQGe4KV3XPR8wpBizn5a+2CZQ92eX6
        jVgO01ycSRzJ4fppbqB24SghzFe1/HB2gNKOYxM8=
Received: from [10.10.10.3] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
        with SMTPS id 1680808738233794.3345617672512; Thu, 6 Apr 2023 12:18:58 -0700 (PDT)
Message-ID: <5b3a10ff-e960-1c6e-3482-cb25200c83c6@arinc9.com>
Date:   Thu, 6 Apr 2023 22:18:51 +0300
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
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <23c8c4b5-baaa-b72b-4103-b415d970acf2@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6.04.2023 22:07, Krzysztof Kozlowski wrote:
> On 06/04/2023 10:01, arinc9.unal@gmail.com wrote:
>> From: Arınç ÜNAL <arinc.unal@arinc9.com>
>>
>> The switch on MT7988 has got only port 6 as a CPU port. The only phy-mode
>> to be used is internal. Add this.
>>
>> Some bindings are incorrect for this switch now, so move them to more
>> specific places.
>>
>> Address the incorrect information of which ports can be used as a user
>> port. Any port can be used as a user port.
>>
>> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
>> ---
>>   .../bindings/net/dsa/mediatek,mt7530.yaml     | 63 ++++++++++++++-----
>>   1 file changed, 46 insertions(+), 17 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
>> index 7045a98d9593..605888ce2bc6 100644
>> --- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
>> +++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
>> @@ -160,22 +160,6 @@ patternProperties:
>>         "^(ethernet-)?port@[0-9]+$":
>>           type: object
>>   
>> -        properties:
>> -          reg:
>> -            description:
>> -              Port address described must be 5 or 6 for CPU port and from 0 to 5
>> -              for user ports.
>> -
>> -        allOf:
>> -          - if:
>> -              required: [ ethernet ]
>> -            then:
>> -              properties:
>> -                reg:
>> -                  enum:
>> -                    - 5
>> -                    - 6
>> -
> 
> I have doubts that the binding is still maintainable/reviewable. First,
> why do you need all above patterns after removal of entire contents?

The 'type: object' item is still globally used. I'd have to define that 
on each definitions, I suppose?

> 
> Second, amount of if-then-if-then located in existing blocks (not
> top-level) is quite big. I counted if-then-using defs, where defs has
> patternProps-patternProps-if-then-if-then-properties.... OMG. :)

Yup, not much to do if we want to keep the information. I'm still 
maintaining this though. ¯\_(ツ)_/¯

Arınç
