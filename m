Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBE46697C9E
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 14:02:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234013AbjBONCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 08:02:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233843AbjBONCU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 08:02:20 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 721A01E291;
        Wed, 15 Feb 2023 05:02:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=eRF7KZGWyAp2wUobvfy12AosGt3ryJM8iRWImzBIITg=; b=cS94lxxHZcrUCuuGzYJ4htZ3/i
        LRXjsPFxOuWozRskJ5HLCWJMzSKKOAjWg8iAvoZlC9ErfbMrfsXA5UG2gU5cXJFIL7nnAMSYZR1mq
        /bayB1PBehfeF237Nz6izZaVXSiuxAmvC5rci4ueLCEv9o6iji+GV2N+YbLdwQSBrccY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pSHPz-0053H4-FB; Wed, 15 Feb 2023 14:01:51 +0100
Date:   Wed, 15 Feb 2023 14:01:51 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Cc:     Lee Jones <lee@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Conor Dooley <conor@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Sagar Kadam <sagar.kadam@sifive.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, kernel@collabora.com
Subject: Re: [PATCH 07/12] dt-bindings: net: Add StarFive JH7100 SoC
Message-ID: <Y+zXv90rGfQupjPP@lunn.ch>
References: <20230211031821.976408-1-cristian.ciocaltea@collabora.com>
 <20230211031821.976408-8-cristian.ciocaltea@collabora.com>
 <Y+e74UIV/Td91lKB@lunn.ch>
 <586971af-2d78-456d-a605-6c7b2aefda91@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <586971af-2d78-456d-a605-6c7b2aefda91@collabora.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 15, 2023 at 02:34:23AM +0200, Cristian Ciocaltea wrote:
> On 2/11/23 18:01, Andrew Lunn wrote:
> > > +  starfive,gtxclk-dlychain:
> > > +    $ref: /schemas/types.yaml#/definitions/uint32
> > > +    description: GTX clock delay chain setting
> > 
> > Please could you add more details to this. Is this controlling the
> > RGMII delays? 0ns or 2ns?
> 
> This is what gets written to JH7100_SYSMAIN_REGISTER49 and it's currently
> set to 4 in patch 12/12. As already mentioned, I don't have the register
> information in the datasheet, but I'll update this as soon as we get some
> details.

I have seen what happens to this value, but i have no idea what it
actually means. And without knowing what it means, i cannot say if it
is being used correctly or not. And it could be related to the next
part of my comment...

> 
> > > +    gmac: ethernet@10020000 {
> > > +      compatible = "starfive,jh7100-dwmac", "snps,dwmac";
> > > +      reg = <0x0 0x10020000 0x0 0x10000>;
> > > +      clocks = <&clkgen JH7100_CLK_GMAC_ROOT_DIV>,
> > > +               <&clkgen JH7100_CLK_GMAC_AHB>,
> > > +               <&clkgen JH7100_CLK_GMAC_PTP_REF>,
> > > +               <&clkgen JH7100_CLK_GMAC_GTX>,
> > > +               <&clkgen JH7100_CLK_GMAC_TX_INV>;
> > > +      clock-names = "stmmaceth", "pclk", "ptp_ref", "gtxc", "tx";
> > > +      resets = <&rstgen JH7100_RSTN_GMAC_AHB>;
> > > +      reset-names = "ahb";
> > > +      interrupts = <6>, <7>;
> > > +      interrupt-names = "macirq", "eth_wake_irq";
> > > +      max-frame-size = <9000>;
> > > +      phy-mode = "rgmii-txid";
> > 
> > This is unusual. Does your board have a really long RX clock line to
> > insert the 2ns delay needed on the RX side?
> 
> Just tested with "rgmii" and didn't notice any issues. If I'm not missing
> anything, I'll do the change in the next revision.

rgmii-id is generally the value to be used. That indicates the board
needs 2ns delays adding by something, either the MAC or the PHY. And
then i always recommend the MAC driver does nothing, pass the value to
the PHY and let the PHY add the delays.

So try both rgmii and rgmii-id and do a lot of bi directional
transfers. Then look at the reported ethernet frame check sum error
counts, both local and the link peer. I would expect one setting gives
you lots of errors, and the other works much better.

    Andrew
