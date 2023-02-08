Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F68168EB7D
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 10:33:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbjBHJdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 04:33:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbjBHJde (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 04:33:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1B2634C1C;
        Wed,  8 Feb 2023 01:33:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E12261593;
        Wed,  8 Feb 2023 09:33:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1595C433EF;
        Wed,  8 Feb 2023 09:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675848783;
        bh=mtLAxODoZih5gt61pMFGV9SSfH5hXOAxrX2G4TD7tV8=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=bFcBniOZqVPytRtBzGqthXxYKgChac/vlLk8nKkV4S9ps/uitnOruM83klgnrBVWX
         hlceJQRmodry2wCGOvSB6BnCFYfCo9/qC1sVlXtkGlOhbcF0kWlyJa/7KJWiSoL2SE
         RQh1v49CIUMk6mJ7vf60Nw9hlMote6tmWY/CUa0xeYdwBCqKm0W6f7Urh4vqXXt1IH
         hxxgCgQQm7gnzlexkhh+YRJdf4iTEnSttLRX+SEg6Hi7fjyt/WFZ2Gm14ThP+qN1Mw
         kPW7EOENnOAnc4c2TI2+U4END54wvsHRysVDYYN1ZefZLPfxE9dQVwMChs9DKrHcyw
         r3BFRPx/pBeYg==
Message-ID: <b6d782ef-b375-1e73-a384-1ff37c1548a7@kernel.org>
Date:   Wed, 8 Feb 2023 10:32:53 +0100
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
From:   Krzysztof Kozlowski <krzk@kernel.org>
In-Reply-To: <Y+KR26aepqlfsjYG@makrotopia.org>
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

On 07/02/2023 19:00, Daniel Golle wrote:
> Hi Krzysztof,
> 
> On Tue, Feb 07, 2023 at 06:38:23PM +0100, Krzysztof Kozlowski wrote:
>> On 07/02/2023 15:19, Daniel Golle wrote:
>>> Add documentation for the newly introduced 'mediatek,pn_swap' property
>>> to mediatek,sgmiisys.txt.
>>>
>>
>> Please use scripts/get_maintainers.pl to get a list of necessary people
>> and lists to CC.  It might happen, that command when run on an older
>> kernel, gives you outdated entries.  Therefore please be sure you base
>> your patches on recent Linux kernel.
>>
>>> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
>>> ---
>>>  .../devicetree/bindings/arm/mediatek/mediatek,sgmiisys.txt    | 4 ++++
>>>  1 file changed, 4 insertions(+)
>>>
>>> diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,sgmiisys.txt b/Documentation/devicetree/bindings/arm/mediatek/mediatek,sgmiisys.txt
>>> index d2c24c277514..b38dd0fde21d 100644
>>> --- a/Documentation/devicetree/bindings/arm/mediatek/mediatek,sgmiisys.txt
>>> +++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,sgmiisys.txt
>>> @@ -14,6 +14,10 @@ Required Properties:
>>>  	- "mediatek,mt7986-sgmiisys_1", "syscon"
>>>  - #clock-cells: Must be 1
>>>  
>>> +Optional Properties:
>>> +
>>> +- mediatek,pn_swap: Invert polarity of the SGMII data lanes.
>>
>> No:
>> 1. No new properties for TXT bindings,
> 
> So I'll have to convert the bindings to YAML, right?

Yes, please.

> 
>> 2. Underscore is not allowed.
> 
> Ack, will change the name of the property.
> 
>> 3. Does not look like property of this node. This is a clock controller
>> or system controller, not SGMII/phy etc.
> 
> The register range referred to by this node *does* represent also an
> SGMII phy. These sgmiisys nodes also carry the 'syscon' compatible, and
> are referenced in the node of the Ethernet core, and then used by
> drivers/net/ethernet/mediatek/mtk_sgmii.c using syscon_node_to_regmap.
> (This is the current situation already, and not related to the patchset
> now adding only a new property to support hardware which needs that)

Just because a register is located in syscon block, does not mean that
SGMII configuration is a property of this device.

> 
> So: Should I introduce a new binding for the same compatible strings
> related to the SGMII PHY features? Or is it fine in this case to add
> this property to the existing binding?

The user of syscon should configure it. I don't think you need new
binding. You just have to update the user of this syscon.

Best regards,
Krzysztof

