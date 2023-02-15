Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BFD4698736
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 22:16:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbjBOVQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 16:16:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjBOVQ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 16:16:26 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AB7F119;
        Wed, 15 Feb 2023 13:16:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=KTC5DH0M+FnWN1wBfrds1kCpF1LuzwfMQP3NHMnS3eU=; b=z1HkbK6nn9hiJSv3SObZsqJNc9
        gW1SoZZzMNBIlNGov/HfdFuUWJreChoGD76Ny89nPcNzspP525Hpcnkj6oLoc/tfvRSQAhv28TvKT
        Mnq6Sfld1kZbUXm9/Ayd2XzQ2uuRSe7FwN3mhkBWmYL4A+pgJnUMYJ7dHX9qVdS+g2DR7I+ta51ru
        YvP34u5Cf0zug1a6Tg8TfD+IS1etVxgnABA1W5RyTCOzxeuwy5plWGc3UTEOf8wIcSMxpUfphV1C8
        k1Koo3FKL02L0t3gPLfPGWFA2ojmNje8g/xF3hE9va5gOeJjmJLooS07JALiNIA0GGiYDWTQJnVON
        Qa/4bagA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57210)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pSP8T-0007G7-8u; Wed, 15 Feb 2023 21:16:17 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pSP8N-0005Ct-2U; Wed, 15 Feb 2023 21:16:11 +0000
Date:   Wed, 15 Feb 2023 21:16:11 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Rob Herring <robh@kernel.org>
Cc:     Daniel Golle <daniel@makrotopia.org>, devicetree@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
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
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Subject: Re: [PATCH v6 03/12] dt-bindings: arm: mediatek: sgmiisys: Convert
 to DT schema
Message-ID: <Y+1Lm8XZVrtSGTLT@shell.armlinux.org.uk>
References: <cover.1676323692.git.daniel@makrotopia.org>
 <f4b378f4b19064df85d529973ed6c73ae7aa9f2d.1676323692.git.daniel@makrotopia.org>
 <20230215204318.GA517744-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230215204318.GA517744-robh@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 15, 2023 at 02:43:18PM -0600, Rob Herring wrote:
> On Mon, Feb 13, 2023 at 09:34:43PM +0000, Daniel Golle wrote:
> > Convert mediatek,sgmiiisys bindings to DT schema format.
> > Add maintainer Matthias Brugger, no maintainers were listed in the
> > original documentation.
> > As this node is also referenced by the Ethernet controller and used
> > as SGMII PCS add this fact to the description.
> > 
> > Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> > ---
> >  .../arm/mediatek/mediatek,sgmiisys.txt        | 27 ----------
> >  .../arm/mediatek/mediatek,sgmiisys.yaml       | 49 +++++++++++++++++++
> >  2 files changed, 49 insertions(+), 27 deletions(-)
> >  delete mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,sgmiisys.txt
> >  create mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,sgmiisys.yaml
> 
> If you respin or as a follow-up, can you move this to bindings/clock/?

I'm not sure that's appropriate. Let's take the MT7622 as an example,
here is the extract from the device tree for this:

        sgmiisys: sgmiisys@1b128000 {
                compatible = "mediatek,mt7622-sgmiisys",
                             "syscon";
                reg = <0 0x1b128000 0 0x3000>;
                #clock-cells = <1>;
        };

This makes it look primarily like a clock controller, but when I look
at the MT7622 documentation, this region is described as the
"Serial Gigabit Media Independent Interface".

If we delve a little deeper and look at the code we have in the kernel,
yes, there is a clock driver, but there is also the SGMII code which is
wrapped up into the mtk_eth_soc driver - and the only user of the
clocks provided by the sgmiisys is the ethernet driver.

To me, this looks very much like a case of "lets use the clock API
because it says we have clocks inside this module" followed by "now
how can we make it work with DT with a separate clock driver".

In other words, I believe that describing this hardware as something
that is primarily to do with clocks is wrong. It looks to me more
like the hardware is primarily a PCS that happens to provide some
clocks to the ethernet subsystem that is attached to it.

Why do I say this? There are 23 documented PCS registers in the
0x1b128000 block, and there is one single register which has a bunch
of bits that enable the various clocks that is used by its clock
driver.

Hence, I put forward that:

"The MediaTek SGMIISYS controller provides various clocks to the system."

is quite misleading, and it should be described as:

"The MediaTek SGMIISYS controller provides a SGMII PCS and some clocks
to the ethernet subsystem to which it is attached."

and a PCS providing clocks to the ethernet subsystem is nothing
really new - we just don't use the clk API to describe them, and
thus don't normally need to throw a syscon thing in there to share
the register space between two drivers.

So, in summary, I don't think moving this to "bindings/clock/" makes
any sense what so ever, and that is probably being based on a
misleading description of what this hardware is and the code structure
adopted in the kernel.

Yes, DT describes the hardware. That's exactly the point I'm making.
It seems that the decision here to classify it has a clock driver is
being made based off the kernel implementation, not what the hardware
actually is.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
