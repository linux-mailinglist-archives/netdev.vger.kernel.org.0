Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF8B68DF88
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 19:01:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232106AbjBGSBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 13:01:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbjBGSBM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 13:01:12 -0500
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16793272A;
        Tue,  7 Feb 2023 10:01:10 -0800 (PST)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pPSH8-0003tU-00;
        Tue, 07 Feb 2023 19:01:02 +0100
Date:   Tue, 7 Feb 2023 18:00:59 +0000
From:   Daniel Golle <daniel@makrotopia.org>
To:     Krzysztof Kozlowski <krzk@kernel.org>
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
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Subject: Re: [PATCH v2 03/11] dt-bindings: arm: mediatek: add
 'mediatek,pn_swap' property
Message-ID: <Y+KR26aepqlfsjYG@makrotopia.org>
References: <cover.1675779094.git.daniel@makrotopia.org>
 <a8c567cf8c3ec6fef426b64fb1ab7f6e63a0cc07.1675779094.git.daniel@makrotopia.org>
 <ad09a065-c10d-3061-adbe-c58724cdfde0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad09a065-c10d-3061-adbe-c58724cdfde0@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Krzysztof,

On Tue, Feb 07, 2023 at 06:38:23PM +0100, Krzysztof Kozlowski wrote:
> On 07/02/2023 15:19, Daniel Golle wrote:
> > Add documentation for the newly introduced 'mediatek,pn_swap' property
> > to mediatek,sgmiisys.txt.
> > 
> 
> Please use scripts/get_maintainers.pl to get a list of necessary people
> and lists to CC.  It might happen, that command when run on an older
> kernel, gives you outdated entries.  Therefore please be sure you base
> your patches on recent Linux kernel.
> 
> > Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> > ---
> >  .../devicetree/bindings/arm/mediatek/mediatek,sgmiisys.txt    | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,sgmiisys.txt b/Documentation/devicetree/bindings/arm/mediatek/mediatek,sgmiisys.txt
> > index d2c24c277514..b38dd0fde21d 100644
> > --- a/Documentation/devicetree/bindings/arm/mediatek/mediatek,sgmiisys.txt
> > +++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,sgmiisys.txt
> > @@ -14,6 +14,10 @@ Required Properties:
> >  	- "mediatek,mt7986-sgmiisys_1", "syscon"
> >  - #clock-cells: Must be 1
> >  
> > +Optional Properties:
> > +
> > +- mediatek,pn_swap: Invert polarity of the SGMII data lanes.
> 
> No:
> 1. No new properties for TXT bindings,

So I'll have to convert the bindings to YAML, right?

> 2. Underscore is not allowed.

Ack, will change the name of the property.

> 3. Does not look like property of this node. This is a clock controller
> or system controller, not SGMII/phy etc.

The register range referred to by this node *does* represent also an
SGMII phy. These sgmiisys nodes also carry the 'syscon' compatible, and
are referenced in the node of the Ethernet core, and then used by
drivers/net/ethernet/mediatek/mtk_sgmii.c using syscon_node_to_regmap.
(This is the current situation already, and not related to the patchset
now adding only a new property to support hardware which needs that)

So: Should I introduce a new binding for the same compatible strings
related to the SGMII PHY features? Or is it fine in this case to add
this property to the existing binding?

Thank you in advance for your advise!


Daniel
