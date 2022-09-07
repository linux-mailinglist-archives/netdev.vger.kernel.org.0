Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE2D5B0C1C
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 20:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbiIGSF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 14:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiIGSFB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 14:05:01 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99B4CFEC;
        Wed,  7 Sep 2022 11:04:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=+JcXgAIfV9Prl7VvBeRxR642d0OXbZ4yy5iXvxpQeSo=; b=P+wj/JCQAsJB28mRHC6W6aEdQY
        KzgkoNIxPFtkYSOmcJyYF4QDnyWZL1lolCty2vl8dcv650WaRxU5A91loMf9EZC2sxvurXLM+JziP
        OXMAiNF8Poa0fBOWtzDEaM7ykp3R21JkYoaeD3bwjbxI4p1OS2nWgo7Olfo9YfandpDgob10HJ/92
        rw7K0WjzG+IEyUYuOtgb0Je2kRfmJLttAmUyUCD0K9uFSEW36vzdgrVg5/TknwduBw4gIETB76hNo
        Bm3keVTlZ2zfHjG//uF/XclomgaiUyR7s6GQ3FXKk6/MROVgdPI0f2qZTLzDptPVl7ZQquArLsz0c
        gaQZJTDA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34190)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oVzPy-0005i5-5k; Wed, 07 Sep 2022 19:04:54 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oVzPv-0001I1-Md; Wed, 07 Sep 2022 19:04:51 +0100
Date:   Wed, 7 Sep 2022 19:04:51 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next v5 1/8] net: phylink: Document MAC_(A)SYM_PAUSE
Message-ID: <YxjdQzEFlJPQMkEl@shell.armlinux.org.uk>
References: <20220906161852.1538270-1-sean.anderson@seco.com>
 <20220906161852.1538270-2-sean.anderson@seco.com>
 <YxhmnVIB+qT0W/5v@shell.armlinux.org.uk>
 <8cf0a225-31b7-748d-bb9d-ac4bbddd4b6a@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8cf0a225-31b7-748d-bb9d-ac4bbddd4b6a@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 07, 2022 at 12:52:59PM -0400, Sean Anderson wrote:
> On 9/7/22 5:38 AM, Russell King (Oracle) wrote:
> > On Tue, Sep 06, 2022 at 12:18:45PM -0400, Sean Anderson wrote:
> > > This documents the possible MLO_PAUSE_* settings which can result from
> > > different combinations of MLO_(A)SYM_PAUSE. These are more-or-less a
> > > direct consequence of IEEE 802.3 Table 28B-2.
> > > 
> > > Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> > > ---
> > > 
> > > (no changes since v3)
> > > 
> > > Changes in v3:
> > > - New
> > > 
> > >   include/linux/phylink.h | 16 ++++++++++++++++
> > >   1 file changed, 16 insertions(+)
> > > 
> > > diff --git a/include/linux/phylink.h b/include/linux/phylink.h
> > > index 6d06896fc20d..a431a0b0d217 100644
> > > --- a/include/linux/phylink.h
> > > +++ b/include/linux/phylink.h
> > > @@ -21,6 +21,22 @@ enum {
> > >   	MLO_AN_FIXED,	/* Fixed-link mode */
> > >   	MLO_AN_INBAND,	/* In-band protocol */
> > > +	/* MAC_SYM_PAUSE and MAC_ASYM_PAUSE correspond to the PAUSE and
> > > +	 * ASM_DIR bits used in autonegotiation, respectively. See IEEE 802.3
> > 
> > "used in our autonegotiation advertisement" would be more clear.
> 
> What else would it be (besides advertisement)? Regarding "our", these bits are
> also set based on the link partner pause settings (e.g. by phylink_decode_c37_word).

No they aren't - MAC_(SYM|ASYM)_PAUSE are only the local side.
phylink_decode_c37_word() makes no use of these enums - it uses the
advertisement masks and decodes them to booleans, which are then used
to set MLO_PAUSE_TX and MLO_PAUSE_RX.

What I'm getting at is the comment is ambiguous.

MAC_(SYM|ASYM)_PAUSE are used to determine the values of PAUSE and
ASM_DIR bits in our local advertisement to the remote end.

> > > +	 * MAC_SYM_PAUSE MAC_ASYM_PAUSE Valid pause modes
> > > +	 * ============= ============== ==============================
> > > +	 *             0              0 MLO_PAUSE_NONE
> > > +	 *             0              1 MLO_PAUSE_NONE, MLO_PAUSE_TX
> > > +	 *             1              0 MLO_PAUSE_NONE, MLO_PAUSE_TXRX
> > > +	 *             1              1 MLO_PAUSE_NONE, MLO_PAUSE_TXRX,
> > > +	 *                              MLO_PAUSE_RX
> > 
> > Any of none, tx, txrx and rx can occur with both bits set in the last
> > case, the tx-only case will be due to user configuration.
> 
> What flow did you have in mind? According to the comment on linkmode_set_pause,
> if ethtool requests tx-only, we will use MAC_ASYM_PAUSE for the advertising,
> which is the second row above.

I think you're missing some points on the ethtool interface. Let me
go through it:

First, let's go through the man page:

           autoneg on|off
                  Specifies whether pause autonegotiation should be enabled.

           rx on|off
                  Specifies whether RX pause should be enabled.

           tx on|off
                  Specifies whether TX pause should be enabled.

This is way too vague and doesn't convey very much inforamtion about
the function of these options. One can rightfully claim that it is
actually wrong and misleading, especially the first option, because
there is no way to control whether "pause autonegotiation should be
enabled." Either autonegotiation with the link partner is enabled
or it isn't.
 
Thankfully, the documentation of the field in struct
ethtool_pauseparam documents this more fully:

 * If @autoneg is non-zero, the MAC is configured to send and/or
 * receive pause frames according to the result of autonegotiation.
 * Otherwise, it is configured directly based on the @rx_pause and
 * @tx_pause flags.

So, autoneg controls whether the result of autonegotiation is used, or
we override the result of autonegotiation with the specified transmit
and receive settings.

The next issue with the man page is that it doesn't specify that tx
and rx control the advertisement of pause modes - and it doesn't
specify how. Again, the documentation of struct ethtool_pauseparam
helps somewhat:

 * If the link is autonegotiated, drivers should use
 * mii_advertise_flowctrl() or similar code to set the advertised
 * pause frame capabilities based on the @rx_pause and @tx_pause flags,
 * even if @autoneg is zero.  They should also allow the advertised
 * pause frame capabilities to be controlled directly through the
 * advertising field of &struct ethtool_cmd.

So:

1. in the case of autoneg=0:
1a. local end's enablement of tx and rx pause frames depends solely
    on the capabilities of the network adapter and the tx and rx
    parameters, ignoring the results of any autonegotiation
    resolution.
1b. the behaviour in mii_advertise_flowctrl() or similar code shall
    be used to derive the advertisement, which results in the
    tx=1 rx=0 case advertising ASYM_DIR only which does not tie up
    with what we actually end up configuring on the local end.

2. in the case of autoneg=1, the tx and rx parameters are used to
   derive the advertisement as in 1b and the results of
   autonegotiation resolution are used.

The full behaviour of mii_advertise_flowctrl() is:

ethtool  local advertisement	possible autoneg resolutions
 rx  tx  Pause AsymDir
 0   0   0     0		!tx !rx
 1   0   1     1		!tx !rx, !tx rx, tx rx
 0   1   0     1		!tx !rx, tx !rx
 1   1   1     0		!tx !rx, tx rx

but as I say, the "possible autoneg resolutions" and table 28B-3
is utterly meaningless when ethtool specifies "autoneg off" for
the pause settings.

So, "ethtool -A autoneg off tx on rx off" will result in an
advertisement with PAUSE=0 ASYM_DIR=1 and we force the local side
to enable transmit pause and disabel receive pause no matter what
the remote side's advertisement is.

I hope this clears the point up.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
