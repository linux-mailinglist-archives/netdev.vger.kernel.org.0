Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 505D859E5B4
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 17:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235049AbiHWPHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 11:07:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243824AbiHWPFe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 11:05:34 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E281CB0B2C;
        Tue, 23 Aug 2022 05:30:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1661257780; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=BHewm+fuQ2Jf8TbBMMRrHkgSf/h9nL8rxUYMqJDedMX48rIwap7RN+nwf8/cNAC0oaECy2kWWsFo/0pmGOeJQlcHCTkJZyw/IY07hfcXGwejLajOsvh8YOr5x3OQR9s9hBl63K83rEpzkqGxGnmZmMtKyNzr1IAhpr88Jea/OZ0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1661257780; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=bI65T5U8WH6MLxwESf8Rca3+EFGUoI0wB+6IEaK+vu4=; 
        b=ELe8V/Ak74tD+q3G3PkU15CL4JUbrOcB9vzt8z2zpmeHYOijt1UAkbxVHSX0JfHXNII1rskrVaHV8mJFZP6U9DZ8EBz12V3j1lETe9BgS832qLKULacUwamJirI17W7+VSJbKAZ19Tp6VdPgIrlPEu4FG+In4QeM0sme/BAjFT0=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1661257780;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=bI65T5U8WH6MLxwESf8Rca3+EFGUoI0wB+6IEaK+vu4=;
        b=d7qh/3Wo7S+Hw9J27o+zWgrWr/yDw1rjCO9ug3viaq2SJBRSFt3PPDNw/xlKMjls
        yOIBHuTdAGH0SsrygsW669k93CzeIAN/Smh6336qBBuTkBoa61AtwSR4WdIv7FZoXz9
        f6kidcMsKHx1C0SzlKRmYaFjgK2xkhNqBLJgSAxA=
Received: from [10.10.10.3] (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1661257778178567.9273906517832; Tue, 23 Aug 2022 05:29:38 -0700 (PDT)
Message-ID: <ea3ceeab-d92b-6ce5-8ea9-aebb3eaa0a91@arinc9.com>
Date:   Tue, 23 Aug 2022 15:29:27 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v4 4/6] dt-bindings: net: dsa: mediatek,mt7530: define
 port binding per switch
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
 <20220820080758.9829-5-arinc.unal@arinc9.com>
 <c24da513-e015-8bc6-8874-ba63c22be5d6@linaro.org>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <c24da513-e015-8bc6-8874-ba63c22be5d6@linaro.org>
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



On 23.08.2022 13:47, Krzysztof Kozlowski wrote:
> On 20/08/2022 11:07, Arınç ÜNAL wrote:
>> Define DSA port binding per switch model as each switch model requires
>> different values for certain properties.
>>
>> Define reg property on $defs as it's the same for all switch models.
>>
>> Remove unnecessary lines as they are already included from the referred
>> dsa.yaml.
>>
>> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
>> ---
>>   .../bindings/net/dsa/mediatek,mt7530.yaml     | 56 +++++++++++--------
>>   1 file changed, 34 insertions(+), 22 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
>> index 657e162a1c01..7c4374e16f96 100644
>> --- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
>> +++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
>> @@ -130,38 +130,47 @@ properties:
>>         ethsys.
>>       maxItems: 1
>>   
>> -patternProperties:
>> -  "^(ethernet-)?ports$":
>> -    type: object
>> -
>> -    patternProperties:
>> -      "^(ethernet-)?port@[0-9]+$":
>> -        type: object
>> -        description: Ethernet switch ports
> 
> Again, I don't understand why do you remove definitions of these nodes
> from top-level properties. I explained what I expect in previous
> discussion and I am confused to hear "this cannot be done".

I agree it can be done, but the binding is done with less lines the 
current way.

I would need to add more lines than just for creating the node structure 
since dsa.yaml is not referred.

Then, I would have to create the node structure again for the dsa-port 
checks.

Arınç
