Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE0776D16CC
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 07:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbjCaFao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 01:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCaFam (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 01:30:42 -0400
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84F8911EAD;
        Thu, 30 Mar 2023 22:30:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1680240483; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=RvVlYFb2Zc0ZD6oJndJIpkFaslzjtpFWroTKZjzsPwpHXL/Iz/BJQt3fMn54XG00SsRKmaUJ164I0I5O5/VbeZ+K2YG2xgfTKCSAu4uMFKShv+XUf18cjBOPLnDgMY2V4J2Sehhlra5t5rwPrYUrj2nWeunSxcb3gwRehmfm7/Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1680240483; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=hpTD1E9VRcVfFYExIFfN1WLmbr3kxCe8d45/97E43fA=; 
        b=C/z4frI54y1q3KH4u0ZoZS8Qn7UuLKxUGBMApFmcxnkInVHiOZFSKo2N/WZKlWT6c+4elLz6V+6vTebplMWR0BSSsvcq2WS0uQbJOQDCvd5g2Lxv8QWLf9vrVpE0QJzvh/k5kr2L7tGPVX0mNcRNW+bfL6fATpp8GLIoZ+zp7Y4=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1680240483;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=hpTD1E9VRcVfFYExIFfN1WLmbr3kxCe8d45/97E43fA=;
        b=Eaa8QaJQsJE8DiBURs0KtniURPYINspWvFU9zob4oUgh7Bx8lrOIU4eU4opoBYMc
        XZBKrfT66eY8jB42S6/rb6dmk6taeWYgHVt0h/fE+mbJjU/ixHPFXqzRB0zRqkKZ16o
        nzRUt4CgPyJxV6CiQzpIn0y8gSMI/2elmlUQw9wA=
Received: from [10.10.10.3] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
        with SMTPS id 1680240481481381.87214760805136; Thu, 30 Mar 2023 22:28:01 -0700 (PDT)
Message-ID: <a7ab2828-dc03-4847-c947-c7685841f884@arinc9.com>
Date:   Fri, 31 Mar 2023 08:27:54 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 15/15] dt-bindings: net: dsa: mediatek,mt7530: add
 mediatek,mt7988-switch
Content-Language: en-US
To:     Daniel Golle <daniel@makrotopia.org>, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux@armlinux.org.uk,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     Sam Shih <Sam.Shih@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>
References: <cover.1680180959.git.daniel@makrotopia.org>
 <80a853f182eac24735338f3c1f505e5f580053ca.1680180959.git.daniel@makrotopia.org>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <80a853f182eac24735338f3c1f505e5f580053ca.1680180959.git.daniel@makrotopia.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30.03.2023 18:23, Daniel Golle wrote:
> Add documentation for the built-in switch which can be found in the
> MediaTek MT7988 SoC.
> 
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> ---
>   .../bindings/net/dsa/mediatek,mt7530.yaml     | 26 +++++++++++++++++--
>   1 file changed, 24 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> index 5ae9cd8f99a24..15953f0e9d1a6 100644
> --- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> @@ -11,16 +11,23 @@ maintainers:
>     - Landen Chao <Landen.Chao@mediatek.com>
>     - DENG Qingfang <dqfext@gmail.com>
>     - Sean Wang <sean.wang@mediatek.com>
> +  - Daniel Golle <daniel@makrotopia.org>

Please put it in alphabetical order by the first name.

>   
>   description: |
> -  There are two versions of MT7530, standalone and in a multi-chip module.
> +  There are three versions of MT7530, standalone, in a multi-chip module and
> +  built-into a SoC.

I assume you put this to point out the situation with MT7988?

This brings to light an underlying problem with the description as the 
MT7620 SoCs described below have the MT7530 switch built into the SoC, 
instead of being part of the MCM.

The switch IP on MT7988 is for sure not MT7530 so either fix this and 
the text below as a separate patch or let me handle it.

>   
>     MT7530 is a part of the multi-chip module in MT7620AN, MT7620DA, MT7620DAN,
>     MT7620NN, MT7621AT, MT7621DAT, MT7621ST and MT7623AI SoCs.
>   
> +  The MT7988 SoC comes a built-in switch similar to MT7531 as well as 4 Gigabit

s/comes a/comes with a

> +  Ethernet PHYs and the switch registers are directly mapped into SoC's memory
> +  map rather than using MDIO. It comes with an internally connected 10G CPU port
> +  and 4 user ports connected to the built-in Gigabit Ethernet PHYs.

Are you sure this is not the MT7531 IP built into the SoC, like MT7530 
on the MT7620 SoCs? Maybe DENG Qingfang would like to clarify as they 
did for MT7530.

> +
>     MT7530 in MT7620AN, MT7620DA, MT7620DAN and MT7620NN SoCs has got 10/100 PHYs
>     and the switch registers are directly mapped into SoC's memory map rather than
> -  using MDIO. The DSA driver currently doesn't support this.
> +  using MDIO. The DSA driver currently doesn't support MT7620 variants.
>   
>     There is only the standalone version of MT7531.

Can you put the MT7988 information below here instead.

>   
> @@ -81,6 +88,10 @@ properties:
>             Multi-chip module MT7530 in MT7621AT, MT7621DAT and MT7621ST SoCs
>           const: mediatek,mt7621
>   
> +      - description:
> +          Built-in switch of the MT7988 SoC
> +        const: mediatek,mt7988-switch
> +
>     reg:
>       maxItems: 1
>   
> @@ -268,6 +279,17 @@ allOf:
>         required:
>           - mediatek,mcm
>   
> +  - if:
> +      properties:
> +        compatible:
> +          const: mediatek,mt7988-switch
> +    then:
> +      $ref: "#/$defs/mt7530-dsa-port"

The CPU ports bindings for MT7530 don't match the characteristics of the 
switch on the MT7988 SoC you described above. We need new definitions 
for the CPU ports on the switch on the MT7988 SoC.

What's the CPU port number? Does it accept rgmii or only the 10G phy-mode?

> +      properties:
> +        gpio-controller: false
> +        mediatek,mcm: false
> +        reset-names: false

I'd rather not add reset-names here and do:

   - if:
       required:
         - mediatek,mcm
     then:
       properties:
         reset-gpios: false

       required:
         - resets
         - reset-names
     else:
       properties:
         resets: false
         reset-names: false

I can handle this if you'd like.

Arınç
