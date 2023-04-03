Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DDD46D5036
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 20:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233065AbjDCSYT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 14:24:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232743AbjDCSYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 14:24:11 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A78682711;
        Mon,  3 Apr 2023 11:24:09 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pjOqY-0001mn-0U;
        Mon, 03 Apr 2023 20:24:02 +0200
Date:   Mon, 3 Apr 2023 19:23:59 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
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
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sam Shih <Sam.Shih@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH 15/15] dt-bindings: net: dsa: mediatek,mt7530: add
 mediatek,mt7988-switch
Message-ID: <ZCsZv65vDjb8MePG@makrotopia.org>
References: <cover.1680180959.git.daniel@makrotopia.org>
 <80a853f182eac24735338f3c1f505e5f580053ca.1680180959.git.daniel@makrotopia.org>
 <a7ab2828-dc03-4847-c947-c7685841f884@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a7ab2828-dc03-4847-c947-c7685841f884@arinc9.com>
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

Now that I see the email, see my reply below.

On Fri, Mar 31, 2023 at 08:27:54AM +0300, Arınç ÜNAL wrote:
> On 30.03.2023 18:23, Daniel Golle wrote:
> > Add documentation for the built-in switch which can be found in the
> > MediaTek MT7988 SoC.
> > 
> > Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> > ---
> >   .../bindings/net/dsa/mediatek,mt7530.yaml     | 26 +++++++++++++++++--
> >   1 file changed, 24 insertions(+), 2 deletions(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> > index 5ae9cd8f99a24..15953f0e9d1a6 100644
> > --- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> > +++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> > @@ -11,16 +11,23 @@ maintainers:
> >     - Landen Chao <Landen.Chao@mediatek.com>
> >     - DENG Qingfang <dqfext@gmail.com>
> >     - Sean Wang <sean.wang@mediatek.com>
> > +  - Daniel Golle <daniel@makrotopia.org>
> 
> Please put it in alphabetical order by the first name.
> 
> >   description: |
> > -  There are two versions of MT7530, standalone and in a multi-chip module.
> > +  There are three versions of MT7530, standalone, in a multi-chip module and
> > +  built-into a SoC.
> 
> I assume you put this to point out the situation with MT7988?
> 
> This brings to light an underlying problem with the description as the
> MT7620 SoCs described below have the MT7530 switch built into the SoC,
> instead of being part of the MCM.

That's true, also MT7620A/N are not MCM but rather a single die which
includes the MT7530 switch afaik.

> 
> The switch IP on MT7988 is for sure not MT7530 so either fix this and the
> text below as a separate patch or let me handle it.
> 
> >     MT7530 is a part of the multi-chip module in MT7620AN, MT7620DA, MT7620DAN,
> >     MT7620NN, MT7621AT, MT7621DAT, MT7621ST and MT7623AI SoCs.
> > +  The MT7988 SoC comes a built-in switch similar to MT7531 as well as 4 Gigabit
> 
> s/comes a/comes with a
> 
> > +  Ethernet PHYs and the switch registers are directly mapped into SoC's memory
> > +  map rather than using MDIO. It comes with an internally connected 10G CPU port
> > +  and 4 user ports connected to the built-in Gigabit Ethernet PHYs.
> 
> Are you sure this is not the MT7531 IP built into the SoC, like MT7530 on
> the MT7620 SoCs? Maybe DENG Qingfang would like to clarify as they did for
> MT7530.

It's basically MT7531 without port 5, without the SGMII units and with
different built-in PHYs for port 0~3 (driver for those will follow in
the next days, I'm still cleaning it).

Similar to other in-SoC switches also the reset routine works a bit
differently, ie. instead of using a GPIO we use a bit of the reset
controller, similar to how it works also for MCM.

> 
> > +
> >     MT7530 in MT7620AN, MT7620DA, MT7620DAN and MT7620NN SoCs has got 10/100 PHYs
> >     and the switch registers are directly mapped into SoC's memory map rather than
> > -  using MDIO. The DSA driver currently doesn't support this.
> > +  using MDIO. The DSA driver currently doesn't support MT7620 variants.
> >     There is only the standalone version of MT7531.
> 
> Can you put the MT7988 information below here instead.
> 
> > @@ -81,6 +88,10 @@ properties:
> >             Multi-chip module MT7530 in MT7621AT, MT7621DAT and MT7621ST SoCs
> >           const: mediatek,mt7621
> > +      - description:
> > +          Built-in switch of the MT7988 SoC
> > +        const: mediatek,mt7988-switch
> > +
> >     reg:
> >       maxItems: 1
> > @@ -268,6 +279,17 @@ allOf:
> >         required:
> >           - mediatek,mcm
> > +  - if:
> > +      properties:
> > +        compatible:
> > +          const: mediatek,mt7988-switch
> > +    then:
> > +      $ref: "#/$defs/mt7530-dsa-port"
> 
> The CPU ports bindings for MT7530 don't match the characteristics of the
> switch on the MT7988 SoC you described above. We need new definitions for
> the CPU ports on the switch on the MT7988 SoC.
> 
> What's the CPU port number? Does it accept rgmii or only the 10G phy-mode?

CPU port is port 6. Port 5 is unused in MT7988 design.
It uses an internal 10G link, so I've decided to use 'internal' as phy
mode which best describes that situation.

> 
> > +      properties:
> > +        gpio-controller: false
> > +        mediatek,mcm: false
> > +        reset-names: false
> 
> I'd rather not add reset-names here and do:
> 
>   - if:
>       required:
>         - mediatek,mcm
>     then:
>       properties:
>         reset-gpios: false
> 
>       required:
>         - resets
>         - reset-names
>     else:
>       properties:
>         resets: false
>         reset-names: false
> 
> I can handle this if you'd like.

Oh yes, that would be very nice. I'm definitely not an expert on
dt-bindings and will probably need several attempts to correctly
address all of that.

Thank you!


Daniel
