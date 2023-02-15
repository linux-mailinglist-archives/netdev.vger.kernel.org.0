Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB4569870A
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 22:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbjBOVKJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 16:10:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbjBOVJs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 16:09:48 -0500
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4131AD31;
        Wed, 15 Feb 2023 13:09:11 -0800 (PST)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pSP1X-0003jS-1N;
        Wed, 15 Feb 2023 22:09:07 +0100
Date:   Wed, 15 Feb 2023 21:09:04 +0000
From:   Daniel Golle <daniel@makrotopia.org>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
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
Subject: Re: [PATCH v6 03/12] dt-bindings: arm: mediatek: sgmiisys: Convert
 to DT schema
Message-ID: <Y+1J8J48H/HXNBuQ@makrotopia.org>
References: <cover.1676323692.git.daniel@makrotopia.org>
 <f4b378f4b19064df85d529973ed6c73ae7aa9f2d.1676323692.git.daniel@makrotopia.org>
 <20230215204318.GA517744-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230215204318.GA517744-robh@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

Just in time, I was about to send v7, now moved the file as requested.

Thank you for reviewing!

> 
> Reviewed-by: Rob Herring <robh@kernel.org>
