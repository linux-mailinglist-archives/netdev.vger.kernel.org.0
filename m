Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A54D60920B
	for <lists+netdev@lfdr.de>; Sun, 23 Oct 2022 11:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbiJWJnx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Oct 2022 05:43:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiJWJnv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Oct 2022 05:43:51 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DD2F6AA2B;
        Sun, 23 Oct 2022 02:43:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=FNpow4wshL323g1885YAxU2jW1wqMDdj6760eMkbzis=; b=ixBR7SvfliA9jYHN4bpRTZSPxs
        lydVfJ7tk2mDqRfDQgSCbUJTD0v8qDVSoLByidIdNBHuNrUPRw1pNlpACunROOcdVrWkzEImLI2tV
        XwJA2i/c2OHkF0oKF+bwbh9a02Yqv58syxbnKmY3CZaB9yEFgd/NDI/6hK3MTusKPOmXYsz5GhYav
        ZiIpEMNBTvXVZCPwBvani5cPn5DfFe72xUqIXL08klGEw47b+q/MxnidAcFH9Xr6RHZ3iWXjFGD1o
        luvTXWlSZL/wrtiMmBwgxwG4DGVqVKRLxjdyFgRyXdvZ953y03DQ6HuLMSQBRdyUvuEYCSeyj3HfE
        47JW8d3Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34902)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1omXVq-0001u6-Nf; Sun, 23 Oct 2022 10:43:22 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1omXVe-0005yg-LS; Sun, 23 Oct 2022 10:43:10 +0100
Date:   Sun, 23 Oct 2022 10:43:10 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     Frank Wunderlich <linux@fw-web.de>,
        linux-mediatek@lists.infradead.org,
        Alexander Couzens <lynxis@fe80.eu>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: Re: Re: Re: Re: Re: [PATCH v2] net: mtk_sgmii: implement
 mtk_pcs_ops
Message-ID: <Y1UMrvk2A9aAcjo5@shell.armlinux.org.uk>
References: <Y1LlnMdm8pGVXC6d@shell.armlinux.org.uk>
 <trinity-b567c57e-b87f-4fe8-acf7-5c9020f85aed-1666381956560@3c-app-gmx-bap55>
 <Y1MO6cyuVtFxTGuP@shell.armlinux.org.uk>
 <9BC397B2-3E0B-4687-99E5-B15472A1762B@fw-web.de>
 <Y1Ozp2ASm2Y+if3Q@shell.armlinux.org.uk>
 <trinity-4470b00b-771b-466e-9f3a-a3df72758208-1666435920485@3c-app-gmx-bs49>
 <Y1Qi55IwJZulL1X/@shell.armlinux.org.uk>
 <trinity-164dc5a6-98ce-464c-a43d-b00b91ca69e5-1666461195968@3c-app-gmx-bs49>
 <Y1RCA+l2OHkrFfhB@shell.armlinux.org.uk>
 <trinity-ff9bb15b-b10c-46d6-8af2-09a03563c3c8-1666509999435@3c-app-gmx-bap20>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <trinity-ff9bb15b-b10c-46d6-8af2-09a03563c3c8-1666509999435@3c-app-gmx-bap20>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 23, 2022 at 09:26:39AM +0200, Frank Wunderlich wrote:
> > Gesendet: Samstag, 22. Oktober 2022 um 21:18 Uhr
> > Von: "Russell King (Oracle)" <linux@armlinux.org.uk>
> > An: "Frank Wunderlich" <frank-w@public-files.de>
> > Cc: "Frank Wunderlich" <linux@fw-web.de>, linux-mediatek@lists.infradead.org, "Alexander Couzens" <lynxis@fe80.eu>, "Felix Fietkau" <nbd@nbd.name>, "John Crispin" <john@phrozen.org>, "Sean Wang" <sean.wang@mediatek.com>, "Mark Lee" <Mark-MC.Lee@mediatek.com>, "David S. Miller" <davem@davemloft.net>, "Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>, "Paolo Abeni" <pabeni@redhat.com>, "Matthias Brugger" <matthias.bgg@gmail.com>, netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
> > Betreff: Re: Re: Re: Re: Re: [PATCH v2] net: mtk_sgmii: implement mtk_pcs_ops
> >
> > Hi,
> >
> > On Sat, Oct 22, 2022 at 07:53:16PM +0200, Frank Wunderlich wrote:
> > > > Gesendet: Samstag, 22. Oktober 2022 um 19:05 Uhr
> > > > Von: "Russell King (Oracle)" <linux@armlinux.org.uk>
> > > > On Sat, Oct 22, 2022 at 12:52:00PM +0200, Frank Wunderlich wrote:
> > > > > > Gesendet: Samstag, 22. Oktober 2022 um 11:11 Uhr
> > > > > > Von: "Russell King (Oracle)" <linux@armlinux.org.uk>
> > >
> > > > > this patch breaks connectivity at least on the sfp-port (eth1).
> > >
> > > > > pcs_get_state
> > > > > [   65.522936] offset:0 0x2c1140
> > > > > [   65.522950] offset:4 0x4d544950
> > > > > [   65.525914] offset:8 0x40e041a0
> > > > > [  177.346183] offset:0 0x2c1140
> > > > > [  177.346202] offset:4 0x4d544950
> > > > > [  177.349168] offset:8 0x40e041a0
> > > > > [  177.352477] offset:0 0x2c1140
> > > > > [  177.356952] offset:4 0x4d544950
> > > >
> > > > Hi,
> > > >
> > > > Thanks. Well, the results suggest that the register at offset 8 is
> > > > indeed the advertisement and link-partner advertisement register. So
> > > > we have a bit of progress and a little more understanding of this
> > > > hardware.
> > > >
> > > > Do you know if your link partner also thinks the link is up?
> > >
> > > yes link is up on my switch, cannot enable autoneg for fibre-port, so port is fixed to 1000M/full flowcontrol enabled.
> > >
> > > > What I notice is:
> > > >
> > > > mtk_soc_eth 15100000.ethernet eth1: Link is Up - 1Gbps/Unknown - flow control off
> > > >
> > > > The duplex is "unknown" which means you're not filling in the
> > > > state->duplex field in your pcs_get_state() function. Given the
> > > > link parter adverisement is 0x00e0, this means the link partner
> > > > supports PAUSE, 1000base-X/Half and 1000base-X/Full. The resolution
> > > > is therefore full duplex, so can we hack that in to your
> > > > pcs_get_state() so we're getting that right for this testing please?
> > >
> > > 0xe0 is bits 5-7 are set (in lower byte from upper word)..which one is for duplex?
> > >
> > > so i should set state->duplex/pause based on this value (maybe compare with own caps)?
> > >
> > > found a documentation where 5=full,6=half, and bits 7+8 are for pause (symetric/asymetric)
> > >
> > > regmap_read(mpcs->regmap, SGMSYS_PCS_CONTROL_1+8, &val);
> > > partner_advertising = (val & 0x00ff0000) >> 16;
> >
> > Not quite :) When we have the link partner's advertisement and the BMSR,
> > we have a helper function in phylink to do all the gritty work:
> >
> > 	regmap_read(mpcs->regmap, SGMSYS_PCS_CONTROL_1, &bm);
> > 	regmap_read(mpcs->regmap, SGMSYS_PCS_CONTROL_1 + 8, &adv);
> >
> > 	phylink_mii_c22_pcs_decode_state(state, bm >> 16, adv >> 16);
> >
> > will do all the work for you without having to care about whether
> > you're operating at 2500base-X, 1000base-X or SGMII mode.
> >
> > > > Now, I'm wondering what SGMII_IF_MODE_BIT0 and SGMII_IF_MODE_BIT5 do
> > > > in the SGMSYS_SGMII_MODE register. Does one of these bits set the
> > > > format for the 16-bit control word that's used to convey the
> > > > advertisements. I think the next step would be to play around with
> > > > these and see what effect setting or clearing these bits has -
> > > > please can you give that a go?
> > >
> > > these is not clear to me...should i blindly set these and how to
> > > verify what they do?
> >
> > Yes please - I don't think anyone knows what they do.
> 
> i guess BIT0 is the SGMII_EN flag like in other sgmii implementations.
> Bit5 is "reserved" in all docs i've found....maybe it is related to HSGMII
> or for 1G vs. 2G5.

"other sgmii implementations" ?

If this is the SGMII_EN flag, maybe SGMII_IF_MODE_BIT0 should be
renamed to SGMII_IF_SGMII_EN ? Maybe it needs to be set for SGMII
and clear for base-X ?

> but how to check what has changed...i guess only the register itself changed
> and i have to readout another to check whats changed.
> 
> do we really need these 2 bits? reading/setting duplex/pause from/to the register
> makes sense, but digging into undocumented bits is much work and we still only guess.

I don't know - I've no idea about this hardware, or what the PCS is,
and other people over the years I've talked to have said "we're not
using it, we can't help". The mediatek driver has been somewhat of a
pain for phylink as a result.

> so i would first want to get sgmii working again and then strip the pause/duplex from it.

I think I'd need more information on your setup - is this dev 0? Are
you using in-band mode or fixed-link mode?

I don't think you've updated me with register values for this since
the patch. With the link timer adjusted back to 1.6ms, that should
result in it working again, but if not, I think there's some
possibilities.

The addition of SGMII_AN_ENABLE for SGMSYS_PCS_CONTROL_1 could have
broken your setup if there is no actual in-band signalling, which
basically means that your firmware description is wrong - and you've
possibly been led astray by the poor driver implementation.

Can you confirm that the device on the other end for dev 0 does in
actual fact use in-band signalling please?

> > If it's interpreting a link partner advertisement of 0x00e0 using
> > SGMII rules, then it will be looking at bits 11 and 10 for the
> > speed, both of which are zero, which means 10Mbps - and 1000base-X
> > doesn't operate at 10Mbps!
> 
> so maybe this breaks sgmii? have you changed this behaviour with your Patch?

Nope, but not setting the duplex properly is yet another buggy and poor
quality of implementation that afficts this driver. I've said about
setting the duplex value when reviewing your patch to add .pcs_get_state
and I'm disappointed that you seemingly haven't yet corrected it in the
code you're testing despite those review comments.

If duplex remains as "unknown", then the MAC will be programmed to
operate in _half_ _duplex_ mode (read mtk_mac_link_up()) which is not
what you likely want. Many MACs don't support half duplex at 1G speed,
so it's likely that without setting state->duplex, the result is that
the MAC hardware is programmed incorrectly.

> > So my hunch is that one of those two IF_MODE_BIT{0,5} _might_ change
> > the way the PCS interprets the control word, but as we don't have
> > any documentation to go on, only experimentation will answer this
> > question.
> >
> > If these registers are MMIO, you could ensure that you have /dev/mem
> > access enabled, and use devmem2 to poke at this register which would
> > probably be quicker than doing a build-boot-test cycle with the
> > kernel - this is how I do a lot of this kind of discovery when
> > documentation is lacking.
> >
> > > But the timer-change can also break sgmii...
> >
> > SGMII mode should be writing the same value to the link timer, but
> > looking at it now, I see I ended up with one too many zeros on the
> > 16000000! It should be 1.6ms in nanoseconds, so 1600000. Please
> > correct for future testing.
> 
> tried removing 1  zero from the 16000000, but same result.
> tried also setting duplex with ethtool, but  after read it is still unknown.

Honestly this doesn't surprise me given the poor state of the mtk_sgmii
code. There's lots that this implementation gets wrong, but I can't fix
it without either people willing to research and test stuff, or without
the actual hardware in front of me.

This mtk_eth_soc driver has been a right pain for me ever since the
half-hearted switch-over to use phylink.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
