Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFC496DAB0D
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 11:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235839AbjDGJrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 05:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjDGJrD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 05:47:03 -0400
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36EC51721;
        Fri,  7 Apr 2023 02:47:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1680860782; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=eBTYQ58vhgLgJ4yHfjiHgtJlGFjyAESluw6BNI9VBH5VQR6zqkymV5P4XN8VfnotRf6TJJPBDn5CONQlz8VkMRCcgJ4R9l1InItL8Ud0HBvexc8+uyLa8OSgmL+CfMrlP2EJiW4GOFrSWUd1XViYS5gKsZUrl1vVnFj0vM1W+bw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1680860782; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=mmgW4edYlUnyxLuwyv+RhMeMNoN0f2U2QoMCWe0iOyU=; 
        b=eVom5K6RyjeM2xe4T2tXSDGQ03nQ9gtC8ejvyc/iCvWWf7I4lO5dc6SGFe1yVTCc2vLYELVid26V2R28/bXOnD7502mNaBidHISMBo8GEyyfdMyVf8uCGbPB5Kj4a/YanAncljYw608MewcFj9uzRooLn3ZwdY11/jHz86Cuhps=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1680860782;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=mmgW4edYlUnyxLuwyv+RhMeMNoN0f2U2QoMCWe0iOyU=;
        b=VP1bH1Sbx6pTq9Kefa1rc9NVAak3gRAr6CeVg1qZoECgJA8CIW0I78wk41fXtDoZ
        yNUs4exZsnDYl+2zE5zMrAAyvIOIUUMS9NII3Hz5Vjdzj29txsbpploTVhgKOCM0odx
        413Pz23s8WrQ/Avqhcn/T4IX7KuKrx6gLmDV43nw=
Received: from [10.10.10.3] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
        with SMTPS id 168086078067680.0988150323908; Fri, 7 Apr 2023 02:46:20 -0700 (PDT)
Message-ID: <5a92419c-4d2c-a169-687b-026dc6094cd8@arinc9.com>
Date:   Fri, 7 Apr 2023 12:46:14 +0300
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
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <951841d3-59a4-fa86-5b45-46afdb2942dd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7.04.2023 12:07, Krzysztof Kozlowski wrote:
> On 06/04/2023 21:18, Arınç ÜNAL wrote:
>> On 6.04.2023 22:07, Krzysztof Kozlowski wrote:
>>> On 06/04/2023 10:01, arinc9.unal@gmail.com wrote:
>>>> From: Arınç ÜNAL <arinc.unal@arinc9.com>
>>>>
>>>> The switch on MT7988 has got only port 6 as a CPU port. The only phy-mode
>>>> to be used is internal. Add this.
>>>>
>>>> Some bindings are incorrect for this switch now, so move them to more
>>>> specific places.
>>>>
>>>> Address the incorrect information of which ports can be used as a user
>>>> port. Any port can be used as a user port.
>>>>
>>>> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
>>>> ---
>>>>    .../bindings/net/dsa/mediatek,mt7530.yaml     | 63 ++++++++++++++-----
>>>>    1 file changed, 46 insertions(+), 17 deletions(-)
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
>>>> index 7045a98d9593..605888ce2bc6 100644
>>>> --- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
>>>> +++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
>>>> @@ -160,22 +160,6 @@ patternProperties:
>>>>          "^(ethernet-)?port@[0-9]+$":
>>>>            type: object
>>>>    
>>>> -        properties:
>>>> -          reg:
>>>> -            description:
>>>> -              Port address described must be 5 or 6 for CPU port and from 0 to 5
>>>> -              for user ports.
>>>> -
>>>> -        allOf:
>>>> -          - if:
>>>> -              required: [ ethernet ]
>>>> -            then:
>>>> -              properties:
>>>> -                reg:
>>>> -                  enum:
>>>> -                    - 5
>>>> -                    - 6
>>>> -
>>>
>>> I have doubts that the binding is still maintainable/reviewable. First,
>>> why do you need all above patterns after removal of entire contents?
>>
>> The 'type: object' item is still globally used. I'd have to define that
>> on each definitions, I suppose?
> 
> Doesn't it come from dsa.yaml/dsa-port.yaml schema?

It comes from dsa.yaml#/$defs/ethernet-ports which this schema already 
refers to. I'll remove the patterns above.

Though 'type: object' is not there for "^(ethernet-)?port@[0-9]+$". I 
think I should add it there as the dsa-port.yaml schema defines the 
properties of the DSA switch port object. So the value matching the 
"^(ethernet-)?port@[0-9]+$" regular expression is expected to be an 
object conforming to the structure defined in dsa-port.yaml.

Does that make sense?

> 
>>
>>>
>>> Second, amount of if-then-if-then located in existing blocks (not
>>> top-level) is quite big. I counted if-then-using defs, where defs has
>>> patternProps-patternProps-if-then-if-then-properties.... OMG. :)
>>
>> Yup, not much to do if we want to keep the information. I'm still
>> maintaining this though. ¯\_(ツ)_/¯
> 
> Maybe it should be split into few bindings sharing common part.

Agreed, I think it makes sense to split this to MT7530, MT7531, and 
MT7988. I will do this after this series.

Arınç
