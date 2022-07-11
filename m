Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4F156D21E
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 02:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbiGKARr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 20:17:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiGKARq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 20:17:46 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9CFA8120B7;
        Sun, 10 Jul 2022 17:17:45 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9CA9323A;
        Sun, 10 Jul 2022 17:17:45 -0700 (PDT)
Received: from slackpad.lan (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 79EB33F73D;
        Sun, 10 Jul 2022 17:17:42 -0700 (PDT)
Date:   Mon, 11 Jul 2022 01:16:36 +0100
From:   Andre Przywara <andre.przywara@arm.com>
To:     Samuel Holland <samuel@sholland.org>
Cc:     Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@lists.linux.dev, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v12 1/7] dt-bindings: arm: sunxi: Add H616 EMAC
 compatible
Message-ID: <20220711011558.01a586d2@slackpad.lan>
In-Reply-To: <b3149c47-7fbf-53b2-f0d7-a45942bb819c@sholland.org>
References: <20220701112453.2310722-1-andre.przywara@arm.com>
        <20220701112453.2310722-2-andre.przywara@arm.com>
        <b2661412-5fce-a20d-c7c4-6df58efdb930@sholland.org>
        <20220705111906.3c553f23@donnerap.cambridge.arm.com>
        <b3149c47-7fbf-53b2-f0d7-a45942bb819c@sholland.org>
Organization: Arm Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 Jul 2022 22:55:54 -0500
Samuel Holland <samuel@sholland.org> wrote:

Hi Samuel,

thanks for the answer! I think we settled this particular issue, just
for clarification some comments/questions below.

> On 7/5/22 5:19 AM, Andre Przywara wrote:
> > On Mon, 4 Jul 2022 18:53:14 -0500
> > Samuel Holland <samuel@sholland.org> wrote:  
> >> On 7/1/22 6:24 AM, Andre Przywara wrote:  
> >>> The Allwinner H616 contains an "EMAC" Ethernet MAC compatible to the A64
> >>> version.
> >>>
> >>> Add it to the list of compatible strings.
> >>>
> >>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> >>> ---
> >>>  .../devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml       | 1 +
> >>>  1 file changed, 1 insertion(+)
> >>>
> >>> diff --git a/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml b/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
> >>> index 6a4831fd3616c..87f1306831cc9 100644
> >>> --- a/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
> >>> +++ b/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
> >>> @@ -22,6 +22,7 @@ properties:
> >>>            - enum:
> >>>                - allwinner,sun20i-d1-emac
> >>>                - allwinner,sun50i-h6-emac
> >>> +              - allwinner,sun50i-h616-emac    
> >>
> >> The H616 manual has register fields for an internal PHY, like H3. Are these not
> >> hooked up for either EMAC?  
> > 
> > Which register fields do you mean, exactly?  
> 
> I mean bits 15-31 of EMAC_EPHY_CLK_REG0.

Right, so those bits look the same as in the H6, and probably do the
same "nothing" here as well, except for PHY_SELECT[15]?

> > The H616 uses the same internal PHY solution as the H6: an AC200 die
> > co-packaged on the carrier (or whatever integration solution they actually
> > chose). The difference to the H6 is that EMAC0 is hardwired to the external
> > RGMII pins, whereas EMAC1 is hardwired to the internal AC200 RMII pins.
> > From all I could see that does not impact the actual MAC IP: both are the
> > same as in the H6, or A64, for that matter.  
> 
> If those bits in EMAC_EPHY_CLK_REG0 have no effect, then I agree. But if
> switching bit 15 to internal PHY causes Ethernet to stop working, then the mux
> really does exist (even if one side is not connected to anything). In that case,
> we need to make sure the mux is set to the external PHY, using the code from H3.

I guess so, but this is what we do for the H6/A64 already, if I read the
code correctly?

        if (gmac->variant->soc_has_internal_phy) {
		...
        } else {
                /* For SoCs without internal PHY the PHY selection bit should be
                 * set to 0 (external PHY).
                 */
                reg &= ~H3_EPHY_SELECT;
        }

And since we set soc_has_internal_phy to false for the A64 (and H6)
compatible, we should be good?

> > There is one twist, though: the second EMAC uses a separate EMAC clock
> > register in the syscon. I came up with this patch to support that:
> > https://github.com/apritzel/linux/commit/078f591017794a0ec689345b0eeb7150908cf85a
> > That extends the syscon to take an optional(!) index. So EMAC0 works
> > exactly like before (both as "<&syscon>;", or "<&syscon 0>;", but for EMAC1
> > we need the index: "<&syscon 4>;".
> > But in my opinion this should not affect the MAC binding, at least not for
> > MAC0.  
> 
> It definitely affects the MAC binding, because we have to change the definition
> of the syscon property. We should still get that reviewed before doing anything
> that depends on it. (And I think EMAC0 support depends on it.)

Technically I agree that it affects the current binding, at least for
EMAC1. Though this looks like some shortcoming of our binding then, as
the actual EMAC IP looks the same for both instances. It just seems
to be the *connection* to the PHYs that differ, so it's a more PHY
*setup* property than an EMAC configuration issue.
But I guess this ship has sailed, and we have to stick with what we
have right now, so would need a different compatible and some code
additions for EMAC1. But since this relies on the AC200 support
anyway (buggy RFC/WIP code here [1], btw), this doesn't look like a big
problem for now.

[1] https://github.com/apritzel/linux/commits/ac200-WIP)

> > And I think we should get away without a different compatible string
> > for EMAC1, since the MAC IP is technically the same, it's just the
> > connection that is different.  
> 
> If you claim that both EMACs are compatible with allwinner,sun50i-a64-emac, then
> you are saying that any existing driver for allwinner,sun50i-a64-emac will also
> work with both of the H616 EMACs. But this is not true. If I hook up both EMACs
> in the DT per the binding, and use the driver in master, at best only EMAC0 will
> work, and likely neither will work.
> 
> So at minimum you need a new compatible for the second EMAC, so it only binds to
> drivers that know about the syscon offset specifier.
> 
> > In any case I think this does not affect the level of support we promise
> > today: EMAC0 with an external PHY only.  
> 
> This can work if you introduce a second compatible for EMAC1. But at that point
> you don't need the syscon offset specifier; it can be part of the driver data,
> like for R40. (And any future EMAC1 could likely fall back to this compatible.)

Yeah, I agree. For robustness I would prefer having a specifier, so any
future twisted EMAC could be covered without yet another compatible
string. But this is a detail.
Or we use the opportunity to design this differently, so that the PHY
driver enables its PHY using this bit, maybe as part of this AC200 EPHY
"control" driver?

Cheers,
Andre
