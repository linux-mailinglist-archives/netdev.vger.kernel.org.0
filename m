Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0F20698757
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 22:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbjBOV3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 16:29:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbjBOV3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 16:29:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDDDF22A1D;
        Wed, 15 Feb 2023 13:29:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 413EF61DD4;
        Wed, 15 Feb 2023 21:29:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A5D5C433B4;
        Wed, 15 Feb 2023 21:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676496584;
        bh=uqSZ7JhhYwZJmyBtc9GnGBSgXvgF8klnsV6Bi3CE/70=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=HyzeZSYy1IGn0ylyeD9fHMqQtFPBtKi9dSmcfdlDTc2rPkFkVsD+itPzrBZj/iiFm
         tAigRsnpNOOJwNgp35HQgsAsJ8kCasuHvf3Ogu2csYRq1CWtQa/mtOR+fhF/gfclEd
         7n8ZEZ3GjE7EBXRm7sPGT9UrZ72pogYYwaWkirDzdf62Mfx3IRADvZkUialHq4PEt8
         aAIFakiQ9bwEX2xcVx4nRkWEFg+1FvA96drKvkJ9Qf/kjeeG2tHQ1tCcqZ0wti0E0h
         wn0miqLesWq7UEHRq5McoJ0hAUP0/mo81rWkw9SpDNURAWMAnYAKDiSr2iobXq/1Ba
         JFld8y4pUPrRA==
Received: by mail-ua1-f48.google.com with SMTP id v5so272uat.5;
        Wed, 15 Feb 2023 13:29:44 -0800 (PST)
X-Gm-Message-State: AO0yUKUcPdQOWTfbF6/FnFnftrqgR5DBrFwz/mmLXfpaCbJJ/OahJfFW
        9XBWggafB+NB8zZosUhQFaP7Te2u/64rHpXdFQ==
X-Google-Smtp-Source: AK7set+StJDjHRVXGKtdcRc0C4Tb6EItbseWIV1tkuIT46rt0i13kIUZLMEc71oCmoEfVGed3op2pEZ5a9IxG+cz5tg=
X-Received: by 2002:a9f:3112:0:b0:689:cd52:101b with SMTP id
 m18-20020a9f3112000000b00689cd52101bmr576154uab.1.1676496583431; Wed, 15 Feb
 2023 13:29:43 -0800 (PST)
MIME-Version: 1.0
References: <cover.1676323692.git.daniel@makrotopia.org> <f4b378f4b19064df85d529973ed6c73ae7aa9f2d.1676323692.git.daniel@makrotopia.org>
 <20230215204318.GA517744-robh@kernel.org> <Y+1Lm8XZVrtSGTLT@shell.armlinux.org.uk>
In-Reply-To: <Y+1Lm8XZVrtSGTLT@shell.armlinux.org.uk>
From:   Rob Herring <robh@kernel.org>
Date:   Wed, 15 Feb 2023 15:29:32 -0600
X-Gmail-Original-Message-ID: <CAL_JsqLYQo9ZbraiHAnb3z5O86Cv4JoKf5HSnhvrRn95HwGkHQ@mail.gmail.com>
Message-ID: <CAL_JsqLYQo9ZbraiHAnb3z5O86Cv4JoKf5HSnhvrRn95HwGkHQ@mail.gmail.com>
Subject: Re: [PATCH v6 03/12] dt-bindings: arm: mediatek: sgmiisys: Convert to
 DT schema
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
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
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 15, 2023 at 3:16 PM Russell King (Oracle)
<linux@armlinux.org.uk> wrote:
>
> On Wed, Feb 15, 2023 at 02:43:18PM -0600, Rob Herring wrote:
> > On Mon, Feb 13, 2023 at 09:34:43PM +0000, Daniel Golle wrote:
> > > Convert mediatek,sgmiiisys bindings to DT schema format.
> > > Add maintainer Matthias Brugger, no maintainers were listed in the
> > > original documentation.
> > > As this node is also referenced by the Ethernet controller and used
> > > as SGMII PCS add this fact to the description.
> > >
> > > Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> > > ---
> > >  .../arm/mediatek/mediatek,sgmiisys.txt        | 27 ----------
> > >  .../arm/mediatek/mediatek,sgmiisys.yaml       | 49 +++++++++++++++++++
> > >  2 files changed, 49 insertions(+), 27 deletions(-)
> > >  delete mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,sgmiisys.txt
> > >  create mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,sgmiisys.yaml
> >
> > If you respin or as a follow-up, can you move this to bindings/clock/?
>
> I'm not sure that's appropriate. Let's take the MT7622 as an example,
> here is the extract from the device tree for this:
>
>         sgmiisys: sgmiisys@1b128000 {
>                 compatible = "mediatek,mt7622-sgmiisys",
>                              "syscon";
>                 reg = <0 0x1b128000 0 0x3000>;
>                 #clock-cells = <1>;
>         };
>
> This makes it look primarily like a clock controller, but when I look
> at the MT7622 documentation, this region is described as the
> "Serial Gigabit Media Independent Interface".
>
> If we delve a little deeper and look at the code we have in the kernel,
> yes, there is a clock driver, but there is also the SGMII code which is
> wrapped up into the mtk_eth_soc driver - and the only user of the
> clocks provided by the sgmiisys is the ethernet driver.
>
> To me, this looks very much like a case of "lets use the clock API
> because it says we have clocks inside this module" followed by "now
> how can we make it work with DT with a separate clock driver".
>
> In other words, I believe that describing this hardware as something
> that is primarily to do with clocks is wrong. It looks to me more
> like the hardware is primarily a PCS that happens to provide some
> clocks to the ethernet subsystem that is attached to it.
>
> Why do I say this? There are 23 documented PCS registers in the
> 0x1b128000 block, and there is one single register which has a bunch
> of bits that enable the various clocks that is used by its clock
> driver.
>
> Hence, I put forward that:
>
> "The MediaTek SGMIISYS controller provides various clocks to the system."
>
> is quite misleading, and it should be described as:

Indeed I was...

>
> "The MediaTek SGMIISYS controller provides a SGMII PCS and some clocks
> to the ethernet subsystem to which it is attached."

+1

> and a PCS providing clocks to the ethernet subsystem is nothing
> really new - we just don't use the clk API to describe them, and
> thus don't normally need to throw a syscon thing in there to share
> the register space between two drivers.

Humm, yes. Just like phys that provide clocks.

If PCS is the main function, then it should go in the PCS directory:
bindings/net/pcs/

> So, in summary, I don't think moving this to "bindings/clock/" makes
> any sense what so ever, and that is probably being based on a
> misleading description of what this hardware is and the code structure
> adopted in the kernel.
>
> Yes, DT describes the hardware. That's exactly the point I'm making.
> It seems that the decision here to classify it has a clock driver is
> being made based off the kernel implementation, not what the hardware
> actually is.

Right. I'm just trying to get misc blocks out of bindings/arm/.

Rob
