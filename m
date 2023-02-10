Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0DE5691F2F
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 13:35:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231794AbjBJMfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 07:35:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231405AbjBJMfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 07:35:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F01834F64;
        Fri, 10 Feb 2023 04:35:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04A4161DB1;
        Fri, 10 Feb 2023 12:35:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 485F0C433EF;
        Fri, 10 Feb 2023 12:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676032513;
        bh=VE48/BFpY9oqV03SRPNJIzQxVKnk2kNg22dC8+ipOPk=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=m3crUoVr31IK6DkF6r2xv+oUJ9j9szbJiXsY85GnpZZSagUplipp4rCZvRZAqDfD9
         q0DJONooGPfKWdUqeXuRc58ZZE0p4ipgOurvU2N9R7Jau5JUVKSYsCgu6qlUtyUCVY
         yseO1lXnIczQz9Nzv/bDYrfwf49NARJ6OJHTbVLV7hBLVjgRWNrdBGuRmKQj4MndYa
         JW5QBP4mC0tBrFH3Kn7ggKwkDumY4J0RJ4PP7vtAFbcuFukekdMGqS1LyeE9gbcxZz
         td0Ik1rZXQMDl/UljsItTQnHd7NnxqTn88nk3L5bjJJQKJNXHvt2mfROMJ9aXOOim7
         peEq8UEVhjfkA==
Message-ID: <d789c9bd-82a6-5a63-cd98-b9e1e68daa2d@kernel.org>
Date:   Fri, 10 Feb 2023 13:35:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v2 03/11] dt-bindings: arm: mediatek: add
 'mediatek,pn_swap' property
Content-Language: en-US
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
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
 <c29a3a22-cc23-35bf-c8e0-ebe1405a4d94@kernel.org>
 <Y+YdqbJS4bDvTxuD@shell.armlinux.org.uk>
 <Y+Y3Lt4I5LPzlK5x@shell.armlinux.org.uk>
From:   Krzysztof Kozlowski <krzk@kernel.org>
In-Reply-To: <Y+Y3Lt4I5LPzlK5x@shell.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/02/2023 13:23, Russell King (Oracle) wrote:
> On Fri, Feb 10, 2023 at 10:34:17AM +0000, Russell King (Oracle) wrote:
>> On Thu, Feb 09, 2023 at 12:30:27PM +0100, Krzysztof Kozlowski wrote:
>>> On 08/02/2023 23:30, Daniel Golle wrote:
>>>> Hm, none of the current PCS (or PHY) drivers are represented by a
>>>> syscon node... (and maybe that's the mistake in first place?)
>>>
>>> Yes.
>>
>> Nos, it isn't.
> 
> To expand on this - I have no idea why you consider it a mistake that
> apparently all PCS aren't represented by a syscon node.
> 
> PCS is a sub-block in an ethernet system, just the same as a MAC is a
> sub-block. PCS can appear in several locations of an ethernet system,
> but are generally found either side of a serial ethernet link such
> as 1000base-X, SGMII, USXGMII, 10Gbase-R etc.
> 
> So, one can find PCS within an ethernet PHY - and there may be one
> facing the MAC connection, and there will be another facing the media.
> We generally do not need to separate these PCS from the PHY itself
> because we view the PHY as one whole device.
> 
> The optional PCS on the MAC side of the link is something that we
> need to know about, because this has to be configured to talk to the
> PHY, or to configure and obtain negotiation results from in the case of
> fibre links.
> 
> PCS on the MAC side are not a system level device, they are very much a
> specific piece of ethernet hardware in the same way that the MAC is,
> and we don't represent the MAC as a syscon node. There is no reason
> to do so with PCS.
> 
> These PCS on the MAC side tend to be accessed via direct MMIO accesses,
> or over a MDIO bus.
> 
> There's other blocks in the IEEE 802.3 ethernet layering, such as the
> PMA/PMD module (which for the MAC side we tend to model with the
> drivers/phy layer) - but again, these also appear in ethernet PHYs
> in order to produce the electrical signals for e.g. twisted pair
> ethernet.
> 
> So, to effectively state that you consider that PCS should always be
> represented as a syscon node is rather naieve, and really as a DT
> reviewer you should not be making such decisions, but soliciting
> opinions from those who know this subject area in detail _whether_
> they are some kind of system controller before making such a
> decision.

Daniel switched to private emails, so unfortunately our talk is not
visible here, nevertheless thanks for the feedback. Much appreciated!

Best regards,
Krzysztof

