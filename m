Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B208643083
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 19:38:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233351AbiLESif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 13:38:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232720AbiLESiT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 13:38:19 -0500
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5E5E2CDD1;
        Mon,  5 Dec 2022 10:31:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1670265002; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=d39PER/uA0WU7GJHb00ysvyLArJZ6UUUuKcmZ84WE9VEHbhHR2Q4D9NcZ6+x5W6zfAXtxaVtNmYTNH7ZFDAtIQJOi6bS/u0crLgjLNK6RPBRr3IQMUT6rtnKRVSjtqJtxaPLJ1ol0baxxOFSzKAaQSe6O54UswOlJug2jrWrjjI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1670265002; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=9HVdrBThZ7f9kI3x9rrZ++0Pvhvtd65Mi6XXfbUOn9c=; 
        b=AL2nQEsnMcKMtUOYykXfMvmcbkQLcpedDcvrdxyjy5fiMTZjK9pMeg2rBO0+1j3NHRi63c57ikBPN3sRl+oOZeAJ972EMH22w9j6SOReZFHsmkKwGE66XzMS4AYafqoRXU53e/pbMsaZPJ9SDvnh5G6oqVQ6kmUllHPfzuJylmI=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1670265002;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=9HVdrBThZ7f9kI3x9rrZ++0Pvhvtd65Mi6XXfbUOn9c=;
        b=XhdGy4YeG9Falqel0Qndo43n2Mp+f7bOMMrpz6rL/JRYMsWSXTxLZRYkakSfPPhG
        CICCMMpu3VUk1yS49eAIOUYLP0i2pGDGwB+m34k7Zg0pVoCgUzqvBCilnadCSLJb/UA
        N6hPXawTLamOoRrjmsBVoQmHwVI7JHubtr63QQoQ=
Received: from [192.168.100.172] (86.121.172.71 [86.121.172.71]) by mx.zohomail.com
        with SMTPS id 1670264999977312.89271187774307; Mon, 5 Dec 2022 10:29:59 -0800 (PST)
Message-ID: <25804819-f767-6272-4ef1-9b9e92d825cb@arinc9.com>
Date:   Mon, 5 Dec 2022 21:29:50 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v4 net-next 3/9] dt-bindings: net: dsa: utilize base
 definitions for standard dsa switches
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-renesas-soc@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        John Crispin <john@phrozen.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Marek Vasut <marex@denx.de>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        George McCollister <george.mccollister@gmail.com>,
        Rob Herring <robh@kernel.org>
References: <20221202204559.162619-1-colin.foster@in-advantage.com>
 <20221202204559.162619-4-colin.foster@in-advantage.com>
 <bfc6810b-3c21-201b-3c4f-a0def3928597@arinc9.com>
 <Y46m3/oqtoqJWFlv@COLIN-DESKTOP1.localdomain>
Content-Language: en-US
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <Y46m3/oqtoqJWFlv@COLIN-DESKTOP1.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6.12.2022 05:20, Colin Foster wrote:
> On Sat, Dec 03, 2022 at 12:45:34AM +0300, Arınç ÜNAL wrote:
>> On 2.12.2022 23:45, Colin Foster wrote:
>>> DSA switches can fall into one of two categories: switches where all ports
>>> follow standard '(ethernet-)?port' properties, and switches that have
>>> additional properties for the ports.
>>>
>>> The scenario where DSA ports are all standardized can be handled by
>>> swtiches with a reference to the new 'dsa.yaml#/$defs/ethernet-ports'.
>>>
>>> The scenario where DSA ports require additional properties can reference
>>> '$dsa.yaml#' directly. This will allow switches to reference these standard
>>> defitions of the DSA switch, but add additional properties under the port
>>> nodes.
>>>
>>> Suggested-by: Rob Herring <robh@kernel.org>
>>> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
>>> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
>>> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
>>> Acked-by: Alvin Šipraga <alsi@bang-olufsen.dk> # realtek
>>> ---
>>>
>>> v3 -> v4
>>>     * Rename "$defs/base" to "$defs/ethernet-ports" to avoid implication of a
>>>       "base class" and fix commit message accordingly
>>>     * Add the following to the common etherent-ports node:
>>>         "additionalProperties: false"
>>>         "#address-cells" property
>>>         "#size-cells" property
>>>     * Fix "etherenet-ports@[0-9]+" to correctly be "ethernet-port@[0-9]+"
>>>     * Remove unnecessary newline
>>>     * Apply changes to mediatek,mt7530.yaml that were previously in a separate patch
>>>     * Add Reviewed and Acked tags
>>>
>>> v3
>>>     * New patch
>>>
>>> ---
>>>    .../bindings/net/dsa/arrow,xrs700x.yaml       |  2 +-
>>>    .../devicetree/bindings/net/dsa/brcm,b53.yaml |  2 +-
>>>    .../devicetree/bindings/net/dsa/dsa.yaml      | 25 ++++++++++++++++---
>>>    .../net/dsa/hirschmann,hellcreek.yaml         |  2 +-
>>>    .../bindings/net/dsa/mediatek,mt7530.yaml     | 16 +++---------
>>>    .../bindings/net/dsa/microchip,ksz.yaml       |  2 +-
>>>    .../bindings/net/dsa/microchip,lan937x.yaml   |  2 +-
>>>    .../bindings/net/dsa/mscc,ocelot.yaml         |  2 +-
>>>    .../bindings/net/dsa/nxp,sja1105.yaml         |  2 +-
>>>    .../devicetree/bindings/net/dsa/realtek.yaml  |  2 +-
>>>    .../bindings/net/dsa/renesas,rzn1-a5psw.yaml  |  2 +-
>>>    11 files changed, 35 insertions(+), 24 deletions(-)
>>>
>>> diff --git a/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml b/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml
>>> index 259a0c6547f3..5888e3a0169a 100644
>>> --- a/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml
>>> +++ b/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml
>>> @@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
>>>    title: Arrow SpeedChips XRS7000 Series Switch Device Tree Bindings
>>>    allOf:
>>> -  - $ref: dsa.yaml#
>>> +  - $ref: dsa.yaml#/$defs/ethernet-ports
>>>    maintainers:
>>>      - George McCollister <george.mccollister@gmail.com>
>>> diff --git a/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml b/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
>>> index 1219b830b1a4..5bef4128d175 100644
>>> --- a/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
>>> +++ b/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
>>> @@ -66,7 +66,7 @@ required:
>>>      - reg
>>>    allOf:
>>> -  - $ref: dsa.yaml#
>>> +  - $ref: dsa.yaml#/$defs/ethernet-ports
>>>      - if:
>>>          properties:
>>>            compatible:
>>> diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
>>> index b9d48e357e77..b9e366e46aed 100644
>>> --- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
>>> +++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
>>> @@ -19,9 +19,6 @@ description:
>>>    select: false
>>>    properties:
>>> -  $nodename:
>>> -    pattern: "^(ethernet-)?switch(@.*)?$"
>>> -
>>>      dsa,member:
>>>        minItems: 2
>>>        maxItems: 2
>>> @@ -58,4 +55,26 @@ oneOf:
>>>    additionalProperties: true
>>> +$defs:
>>> +  ethernet-ports:
>>> +    description: A DSA switch without any extra port properties
>>> +    $ref: '#/'
>>> +
>>> +    patternProperties:
>>> +      "^(ethernet-)?ports$":
>>> +        type: object
>>> +        additionalProperties: false
>>> +
>>> +        properties:
>>> +          '#address-cells':
>>> +            const: 1
>>> +          '#size-cells':
>>> +            const: 0
>>> +
>>> +        patternProperties:
>>> +          "^(ethernet-)?port@[0-9]+$":
>>> +            description: Ethernet switch ports
>>> +            $ref: dsa-port.yaml#
>>> +            unevaluatedProperties: false
>>> +
>>>    ...
>>> diff --git a/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml b/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml
>>> index 73b774eadd0b..748ef9983ce2 100644
>>> --- a/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml
>>> +++ b/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml
>>> @@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
>>>    title: Hirschmann Hellcreek TSN Switch Device Tree Bindings
>>>    allOf:
>>> -  - $ref: dsa.yaml#
>>> +  - $ref: dsa.yaml#/$defs/ethernet-ports
>>>    maintainers:
>>>      - Andrew Lunn <andrew@lunn.ch>
>>> diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
>>> index f2e9ff3f580b..b815272531fa 100644
>>> --- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
>>> +++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
>>> @@ -156,17 +156,6 @@ patternProperties:
>>>        patternProperties:
>>>          "^(ethernet-)?port@[0-9]+$":
>>> -        type: object
>>> -        description: Ethernet switch ports
>>> -
>>> -        unevaluatedProperties: false
>>> -
>>> -        properties:
>>> -          reg:
>>> -            description:
>>> -              Port address described must be 5 or 6 for CPU port and from 0 to 5
>>> -              for user ports.
>>
>> This shouldn't be moved. Please reread our conversation on the previous
>> version.
> 
> I see - I missed your point. My apologies. This binding should keep the
> reg properties where they were. I'll wait a few more days for any
> additional feedback.

Feel free to add my acked-by with the next version.

Acked-by: Arınç ÜNAL <arinc.unal@arinc9.com>

Arınç
