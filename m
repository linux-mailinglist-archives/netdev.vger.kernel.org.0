Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5020B649B26
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 10:29:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231779AbiLLJ3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 04:29:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231376AbiLLJ3U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 04:29:20 -0500
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A40C7E05;
        Mon, 12 Dec 2022 01:29:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1670837297; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=mBWd13yG1YrtEsMFwDnYexpnES9Qx4y5RO9fYvg04eCPJwMGHXU1sGJoVwVcpGvsWkN/DK4SxtFz61m1yXB8UjeWbPh8UdYwCcmYgRcEZKtUf+/hG6kKVvajsvX3O3cmf6ZQZwmKePP7XXU8fDuE0irYyJNC9FWOgZCj2bUP/t0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1670837297; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=+NiYbpQ61V0IWmDEj33HiUlIc9JpdcOdwbfOwK7rNM8=; 
        b=iBv6mdzXcJaditRxO69venXFwRrLiZLAYo1jta0xq2Wf9Zjhsz8Bd9ZcGaolUbfhV3TLlPN+5EoTia/MM8a+e0ji9o1vVc/r9HxA+7jiYgON5vs9FqyL/UBnVzJ2KffSieN8Zh1nwzsEm+F4xpZiXRmk3i2E3v3fqz5q1OI/dD0=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1670837297;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=+NiYbpQ61V0IWmDEj33HiUlIc9JpdcOdwbfOwK7rNM8=;
        b=iLipqTgNQhtK8mAPaVTfRkGgzQVfg1N8GVKxiy1+XFiTkqNlHCvH1bXMN+SG3+HE
        fYfXeQd3OPD0ODRHljY2HlrmS63d186Sm3h7TaUTISOCEpKYaVq8ZlC90qBDVps0y4t
        KkjMRsuagFvtVu4s+ZBG5fZ/0yxcaxPbJYx/VVRY=
Received: from [10.10.10.3] (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1670837294654318.4242339559728; Mon, 12 Dec 2022 01:28:14 -0800 (PST)
Message-ID: <c1e40b58-4459-2929-64f3-3e20f36f6947@arinc9.com>
Date:   Mon, 12 Dec 2022 12:28:06 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v5 net-next 04/10] dt-bindings: net: dsa: utilize base
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
References: <20221210033033.662553-1-colin.foster@in-advantage.com>
 <20221210033033.662553-5-colin.foster@in-advantage.com>
 <1df417b5-a924-33d4-a302-eb526f7124b4@arinc9.com> <Y5TJw+zcEDf2ItZ5@euler>
Content-Language: en-US
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <Y5TJw+zcEDf2ItZ5@euler>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10.12.2022 21:02, Colin Foster wrote:
> Hi Arınç,
> On Sat, Dec 10, 2022 at 07:24:42PM +0300, Arınç ÜNAL wrote:
>> On 10.12.2022 06:30, Colin Foster wrote:
>>> DSA a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
>>> +++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
>>> @@ -58,4 +58,26 @@ oneOf:
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
>>
>> I've got moderate experience in json-schema but shouldn't you put 'type:
>> object' here like you did for "^(ethernet-)?ports$"?
> 
> I can't say for sure, but adding "type: object" here and removing it
> from mediatek,mt7530.yaml still causes the same issue I mention below.
> 
> Rob's initial suggestion for this patch set (which was basically the
> entire implementation... many thanks again Rob) can be found here:
> https://lore.kernel.org/netdev/20221104200212.GA2315642-robh@kernel.org/
> 
>  From what I can tell, the omission of "type: object" here was
> intentional. At the very least, it doesn't seem to have any effect on
> warnings.
> 
>>
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
>>> index f2e9ff3f580b..20312f5d1944 100644
>>> --- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
>>> +++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
>>> @@ -157,9 +157,6 @@ patternProperties:
>>>        patternProperties:
>>>          "^(ethernet-)?port@[0-9]+$":
>>>            type: object
>>
>> This line was being removed on the previous version. Must be related to
>> above.
> 
> Without the 'object' type here, I get the following warning:
> 
> Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml: patternProperties:^(ethernet-)?ports$:patternProperties:^(ethernet-)?port@[0-9]+$: 'anyOf' conditional failed, one must be fixed:
>          'type' is a required property
>          '$ref' is a required property
>          hint: node schemas must have a type or $ref
>          from schema $id: http://devicetree.org/meta-schemas/core.yaml#
> ./Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml: Error in referenced schema matching $id: http://devicetree.org/schemas/net/dsa/mediatek,mt7530.yaml
>    SCHEMA  Documentation/devicetree/bindings/processed-schema.json
> /home/colin/src/work/linux_vsc/linux-imx/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml: ignoring, error in schema: patternProperties: ^(ethernet-)?ports$: patternProperties: ^(ethernet-)?port@[0-9]+$
> 
> 
> I'm testing this now and I'm noticing something is going on with the
> "ref: dsa-port.yaml"
> 
> 
> Everything seems to work fine (in that I don't see any warnings) when I
> have this diff:
> 
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> index 20312f5d1944..db0122020f98 100644
> --- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yam
> @@ -156,8 +156,7 @@ patternProperties:
> 
>       patternProperties:
>         "^(ethernet-)?port@[0-9]+$":
> -        type: object
> -
> +        $ref: dsa-port.yaml#
>           properties:
>             reg:
>               description:
> @@ -165,7 +164,6 @@ patternProperties:
>                 for user ports.
> 
>           allOf:
> -          - $ref: dsa-port.yaml#
>             - if:
>                 required: [ ethernet ]
>               then:
> 
> 
> 
> This one has me [still] scratching my head...

Right there with you. In addition to this, having or deleting type 
object on/from "^(ethernet-)?ports$" and "^(ethernet-)?port@[0-9]+$" on 
dsa.yaml doesn't cause any warnings (checked with make dt_binding_check 
DT_SCHEMA_FILES=net/dsa) which makes me question why it's there in the 
first place.

Arınç
