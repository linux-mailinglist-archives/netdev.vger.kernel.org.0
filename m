Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51BD66907CF
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 12:52:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbjBILwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 06:52:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbjBILv7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 06:51:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF1C964D8C;
        Thu,  9 Feb 2023 03:38:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D873B81FFE;
        Thu,  9 Feb 2023 11:30:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA8FDC433D2;
        Thu,  9 Feb 2023 11:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675942239;
        bh=n5BKd8V/ZQGgcA9CiHhAacPMcS6Ke8ZhtPgxOCdKjJA=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=BoqaH1iWcJdCR9gkQ/R77lbxXuZwL54BikFx0DaNFTXtCPgUZkWXhHzG/eIPwmCo9
         b0+8V/GxAJVuhelhx6AhC931IIx8OcEh+4/ystJPjcZT2Pj08aslS25Ofy+L8z9s73
         3arZVi/3IlRYNV3I8w6gRywtLI+qjKgTuPzkJi36Zugn/sl9RN0NNB0NDp6N9Q1VW+
         zEwD8jcaY+DfU9rv3VhfZ427S5DOHhNEeYKj80NApzvw7+D/LevO3g9R5sN0/VAV/h
         Q4e1Dvi/KUZJynY6qJ9dpO6go06ODQEywoJzDYXtV35WPUhW6NBDZjgUFpDv0+NjcD
         x0ydgxmcp9h0Q==
Message-ID: <c29a3a22-cc23-35bf-c8e0-ebe1405a4d94@kernel.org>
Date:   Thu, 9 Feb 2023 12:30:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v2 03/11] dt-bindings: arm: mediatek: add
 'mediatek,pn_swap' property
Content-Language: en-US
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Jianhui Zhao <zhaojh329@gmail.com>,
        =?UTF-8?Q?Bj=c3=b8rn_Mork?= <bjorn@mork.no>
References: <cover.1675779094.git.daniel@makrotopia.org>
 <a8c567cf8c3ec6fef426b64fb1ab7f6e63a0cc07.1675779094.git.daniel@makrotopia.org>
 <ad09a065-c10d-3061-adbe-c58724cdfde0@kernel.org>
 <Y+KR26aepqlfsjYG@makrotopia.org>
 <b6d782ef-b375-1e73-a384-1ff37c1548a7@kernel.org>
 <Y+Oo9HaqPeNVUANR@makrotopia.org>
 <514ec4b8-ef78-35c1-2215-22884fca87d4@kernel.org>
 <Y+QinJ9W8hIIF9Ni@makrotopia.org>
From:   Krzysztof Kozlowski <krzk@kernel.org>
In-Reply-To: <Y+QinJ9W8hIIF9Ni@makrotopia.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/02/2023 23:30, Daniel Golle wrote:
> Hi Krzysztof,
> 
> thank you for taking the time to review and explain.
> 
> On Wed, Feb 08, 2023 at 09:08:40PM +0100, Krzysztof Kozlowski wrote:
>> On 08/02/2023 14:51, Daniel Golle wrote:
>>> On Wed, Feb 08, 2023 at 10:32:53AM +0100, Krzysztof Kozlowski wrote:
>>>> On 07/02/2023 19:00, Daniel Golle wrote:
>>>>> ...
>>>>>> 3. Does not look like property of this node. This is a clock controller
>>>>>> or system controller, not SGMII/phy etc.
>>>>>
>>>>> The register range referred to by this node *does* represent also an
>>>>> SGMII phy. These sgmiisys nodes also carry the 'syscon' compatible, and
>>>>> are referenced in the node of the Ethernet core, and then used by
>>>>> drivers/net/ethernet/mediatek/mtk_sgmii.c using syscon_node_to_regmap.
>>>>> (This is the current situation already, and not related to the patchset
>>>>> now adding only a new property to support hardware which needs that)
>>>>
>>>> Just because a register is located in syscon block, does not mean that
>>>> SGMII configuration is a property of this device.
>>>
>>> It's not just one register, the whole SGMII PCS is located in those
>>> mediatek,sgmiisys syscon nodes.
>>
>> Then maybe this should be a PCS PHY device instead of adding properties
>> unrelated to clock/system controller? I don't know, currently this
>> binding says it is a provider of clocks...
> 
> As in reality it is really a clock provider and also SGMII PCS at the
> same time, maybe we should just update the description of the binding
> to match that:
> 
> diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,sgmiisys.txt b/Documentation/devicetree/bindings/arm/mediatek/mediatek,sgmiisys.txt
> index d2c24c2775141..db6f75df200ba 100644
> --- a/Documentation/devicetree/bindings/arm/mediatek/mediatek,sgmiisys.txt
> +++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,sgmiisys.txt
> @@ -2,6 +2,7 @@ MediaTek SGMIISYS controller
>  ============================
>  
>  The MediaTek SGMIISYS controller provides various clocks to the system.
> +It also represents the SGMII PCS used by the Ethernet core.
>  
>  Required Properties:
>  
> 
> See
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/ethernet/mediatek/mtk_sgmii.c#n179
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/arm64/boot/dts/mediatek/mt7986a.dtsi#n409

But it is not used as phy or PCS. It is used as syscon. If it was a phy
or PCS, then the property probably belonged here, but bindings and Linux
implementation were created in different way, so it is not a phy or PCS,
just a syscon.

>>>>> So: Should I introduce a new binding for the same compatible strings
>>>>> related to the SGMII PHY features? Or is it fine in this case to add
>>>>> this property to the existing binding?
>>>>
>>>> The user of syscon should configure it. I don't think you need new
>>>> binding. You just have to update the user of this syscon.
>>>
>>> Excuse my confusion, but it's still not entirely clear to me.
>>> So in this case I should add the description of the added propterty of
>>> the individual SGMII units (there can be more than one) to
>>> Documentation/devicetree/bindings/net/mediatek,net.yaml
>>> eventhough the properties are in the sgmiisys syscon nodes?
>>
>> I guess the property should be in the node representing the SGMII. You
>> add it now to the clock (or system) controller, so it does not look
>> right. It's not a property of a clock controller.
> 
> Well maybe this node needs to be split then into one node representing
> only the clock controller and another node representing the SGMII PCS?
> I'm not sure if this is even possible, some registers in this range
> represent clocks, other registers are accessed using regmap API in
> mtk_sgmii.c.

This can be the same node, but it must be used like PCS. syscon phandle
for getting regmap is something entirely else.

> 
> And (see the rest of this series) the exact same SGMII PCS can also be
> found in MT7531 switch IC which has it's own (a bit odd) way to access
> 32-bit registers over MDIO, also in this case it is simply not easily
> possible to represent the SGMII PCS in device tree.
> 
>>
>> Now which node should have this property depends on your devices - which
>> I have no clue about, I read what is in the bindings.
> 
> There isn't any other node exclusively representing the SGMII PCS.
> I guess the only other option would be to move the property to the
> Ethernet controller node, which imho complicates things as it is
> really a property of an individual SGMII PHY (of which there can be
> more than one).
> 
>>
>>>
>>> If so I will have to figure out how to describe properties of other
>>> nodes in the binding of the node referencing them. Are there any
>>> good examples for that?
>>
>> phys and pcs'es?
> 
> Hm, none of the current PCS (or PHY) drivers are represented by a
> syscon node... (and maybe that's the mistake in first place?)

Yes.


Best regards,
Krzysztof

