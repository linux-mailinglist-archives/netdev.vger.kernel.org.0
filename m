Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 083A55B0EC7
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 23:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbiIGVBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 17:01:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbiIGVBq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 17:01:46 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C64F4B14C9;
        Wed,  7 Sep 2022 14:01:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=MdmDe7HydstAhJGJ2S7jqFkrQUxlBsWX8h+8f/fbtcc=; b=zkJBFfzJq64y/EROvk/D2JZTlK
        jB5fOOL17weaO9YpwzjXixaFxMZbZaJ1/AksSO9TJwiyqNkmcYw5O10rVHJ9vL7Iyob0Q0HWvuMlg
        1yAJCgpDSHaHLr31jIx6DYArt4LwT0NBRRldzXlD/whnBWDUcLMsBaDC24CbUSOfAMI1lIEbfLiFN
        niSm42TlOYO8fTn0BDEIZDx16JKpmFYQoljUQywVyL0wUV9bPT1y0RRKDWz22uDQ28fOcrSMHZKoZ
        CVScNgKcapJmTBxkVZ+qDzHA6TxHl7xqo8DYN5zXIbBTlJYh7P7v1jsAq1R6KbUR04wZzOjIPGZlw
        XkgfKBZA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34194)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oW2B0-0005pY-V4; Wed, 07 Sep 2022 22:01:38 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oW2Ax-0001PC-Gt; Wed, 07 Sep 2022 22:01:35 +0100
Date:   Wed, 7 Sep 2022 22:01:35 +0100
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
Message-ID: <YxkGr611ZA1EF58N@shell.armlinux.org.uk>
References: <20220906161852.1538270-1-sean.anderson@seco.com>
 <20220906161852.1538270-2-sean.anderson@seco.com>
 <YxhmnVIB+qT0W/5v@shell.armlinux.org.uk>
 <8cf0a225-31b7-748d-bb9d-ac4bbddd4b6a@seco.com>
 <YxjdQzEFlJPQMkEl@shell.armlinux.org.uk>
 <745dfe6a-8731-02cc-512a-b46ece9169ed@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <745dfe6a-8731-02cc-512a-b46ece9169ed@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 07, 2022 at 04:11:14PM -0400, Sean Anderson wrote:
> On 9/7/22 2:04 PM, Russell King (Oracle) wrote:
> > MAC_SYM_PAUSE and MAC_ASYM_PAUSE are used when configuring our autonegotiation
> > advertisement. They correspond to the PAUSE and ASM_DIR bits defined by 802.3,
> > respectively.
> 
> My intention here is to clarify the relationship between the terminology. Your
> proposed modification has "our autonegotiation advertisement" apply to PAUSE/ASM_DIR
> instead of MAC_*_PAUSE, which is also confusing, since those bits can apply to either
> party's advertisement.

Please amend to make it clearer.

> > > > > +	 * MAC_SYM_PAUSE MAC_ASYM_PAUSE Valid pause modes
> > > > > +	 * ============= ============== ==============================
> > > > > +	 *             0              0 MLO_PAUSE_NONE
> > > > > +	 *             0              1 MLO_PAUSE_NONE, MLO_PAUSE_TX
> > > > > +	 *             1              0 MLO_PAUSE_NONE, MLO_PAUSE_TXRX
> > > > > +	 *             1              1 MLO_PAUSE_NONE, MLO_PAUSE_TXRX,
> > > > > +	 *                              MLO_PAUSE_RX
> > > > 
> > > > Any of none, tx, txrx and rx can occur with both bits set in the last
> > > > case, the tx-only case will be due to user configuration.
> > > 
> > > What flow did you have in mind? According to the comment on linkmode_set_pause,
> > > if ethtool requests tx-only, we will use MAC_ASYM_PAUSE for the advertising,
> > > which is the second row above.
> > 
> > I think you're missing some points on the ethtool interface. Let me
> > go through it:
> > 
> > First, let's go through the man page:
> > 
> >             autoneg on|off
> >                    Specifies whether pause autonegotiation should be enabled.
> > 
> >             rx on|off
> >                    Specifies whether RX pause should be enabled.
> > 
> >             tx on|off
> >                    Specifies whether TX pause should be enabled.
> > 
> > This is way too vague and doesn't convey very much inforamtion about
> > the function of these options. One can rightfully claim that it is
> > actually wrong and misleading, especially the first option, because
> > there is no way to control whether "pause autonegotiation should be
> > enabled." Either autonegotiation with the link partner is enabled
> > or it isn't.
> > Thankfully, the documentation of the field in struct
> > ethtool_pauseparam documents this more fully:
> > 
> >   * If @autoneg is non-zero, the MAC is configured to send and/or
> >   * receive pause frames according to the result of autonegotiation.
> >   * Otherwise, it is configured directly based on the @rx_pause and
> >   * @tx_pause flags.
> > 
> > So, autoneg controls whether the result of autonegotiation is used, or
> > we override the result of autonegotiation with the specified transmit
> > and receive settings.
> > 
> > The next issue with the man page is that it doesn't specify that tx
> > and rx control the advertisement of pause modes - and it doesn't
> > specify how. Again, the documentation of struct ethtool_pauseparam
> > helps somewhat:
> > 
> >   * If the link is autonegotiated, drivers should use
> >   * mii_advertise_flowctrl() or similar code to set the advertised
> >   * pause frame capabilities based on the @rx_pause and @tx_pause flags,
> >   * even if @autoneg is zero.  They should also allow the advertised
> >   * pause frame capabilities to be controlled directly through the
> >   * advertising field of &struct ethtool_cmd.
> > 
> > So:
> > 
> > 1. in the case of autoneg=0:
> > 1a. local end's enablement of tx and rx pause frames depends solely
> >      on the capabilities of the network adapter and the tx and rx
> >      parameters, ignoring the results of any autonegotiation
> >      resolution.
> > 1b. the behaviour in mii_advertise_flowctrl() or similar code shall
> >      be used to derive the advertisement, which results in the
> >      tx=1 rx=0 case advertising ASYM_DIR only which does not tie up
> >      with what we actually end up configuring on the local end.
> > 
> > 2. in the case of autoneg=1, the tx and rx parameters are used to
> >     derive the advertisement as in 1b and the results of
> >     autonegotiation resolution are used.
> > 
> > The full behaviour of mii_advertise_flowctrl() is:
> > 
> > ethtool  local advertisement	possible autoneg resolutions
> >   rx  tx  Pause AsymDir
> >   0   0   0     0		!tx !rx
> >   1   0   1     1		!tx !rx, !tx rx, tx rx
> >   0   1   0     1		!tx !rx, tx !rx
> >   1   1   1     0		!tx !rx, tx rx
> > 
> > but as I say, the "possible autoneg resolutions" and table 28B-3
> > is utterly meaningless when ethtool specifies "autoneg off" for
> > the pause settings.
> > 
> > So, "ethtool -A autoneg off tx on rx off" will result in an
> > advertisement with PAUSE=0 ASYM_DIR=1 and we force the local side
> > to enable transmit pause and disabel receive pause no matter what
> > the remote side's advertisement is.
> > 
> > I hope this clears the point up.
> 
> My intent here is to provide some help for driver authors when they
> need to fill in their mac capabilities. The driver author probably
> knows things like "My device supports MLO_PAUSE_TX and MLO_PAUSE_TXRX
> but not MLO_PAUSE_RX." They have to translate that into the correct
> values for MAC_*_PAUSE. When the user starts messing with this process,
> it's no longer the driver author's problem whether the result is sane
> or not.

Given that going from tx/rx back to pause/asym_dir bits is not trivial
(because the translation depends on the remote advertisement) it is
highly unlikely that the description would frame the support in terms
of whether the hardware can transmit and/or receive pause frames.

Note from the table above, it is not possible to advertise that you
do not support transmission of pause frames.

> 
> How about
> 
> > The following table lists the values of tx_pause and rx_pause which
> > might be requested in mac_link_up depending on the results of> autonegotiation (when MLO_PAUSE_AN is set):>
> > MAC_SYM_PAUSE MAC_ASYM_PAUSE tx_pause rx_pause
> > ============= ============== ======== ========
> >             0              0        0        0
> >             0              1        0        0>                                     1        0
> >             1              0        0        0
> >                                     1        1>             1              1        0        0
> >                                     0        1
> >                                     1        1
> > 
> > When MLO_PAUSE_AN is not set, any combination of tx_pause and> rx_pause may be requested. This depends on user configuration,
> > without regard to the values of MAC_SYM_PAUSE and MAC_ASYM_PAUSE.

The above is how I'm viewing this, and because of the broken formatting,
it's impossible to make sense of, sorry.

> Perhaps there should be a note either here or in mac_link_up documenting
> what to do if e.g. the user requests just MLO_PAUSE_TX but only symmetric
> pause is supported. In mvneta_mac_link_up we enable symmetric pause if
> either tx_pause or rx_pause is requested.

If the MAC only supports symmetric pause, the logic in phylink ensures
that the MAC will always be called with tx_pause == rx_pause:
- it will fail attempts by ethtool to set autoneg off with different rx
  and tx settings.
- we will only advertise support for symmetric pause, for which there
  are only two autonegotiation outcomes, both of which satisfy the
  requirement that tx_pause == rx_pause.

So, if a MAC only supports symmetric pause, it can key off either of
these two flags as it is guaranteed that they will be identical in
for a MAC that only supports symmetric pause.

Adding in the issue of rate adaption (sorry, I use "adaption" not
"adaptation" which I find rather irksome as in my - and apparently
a subsection of English speakers, the two have slightly different
meanings) brings with it the problem that when using pause frames,
we need RX pause enabled, but on a MAC which only supports symmetric
pause, we can't enable RX pause without also transmitting pause frames.
So I would say such a setup was fundamentally mis-designed, and there's
little we can do to correct such a stupidity. Should we detect such
stupidities? Maybe, but what then? Refuse to function?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
