Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79C195B28E8
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 00:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbiIHWBD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 18:01:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbiIHWAl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 18:00:41 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9092D1D6;
        Thu,  8 Sep 2022 14:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=rc/8lChZEoqYm7Tb1nELi2ynIgvcFh09x/TFdGHe4gk=; b=YTM2TBRWO2YYACpGstwkFMFVNL
        oPVS93PSxoJ7iTFflAnm5ugXB29e0odJqlB3wkqjz2mNCOx0vcqsXig5Zs2VuMXRf1I4mC0bRjs8U
        ggRQJe0j+nIev9QxxsSxENmQM/GRp/vuI3uKuFoFoNc5lbl7jFTdsSBFPP34ksv4EE21ZuYOvvWBG
        mcBjRo+jkSP5JO8M01W5fE7FXdyzsz4NJ9/LiHefYny35WarZnC2JH/WjO8rHIn0O/6L2e7WJk4zT
        c4cmyFytzukSrDvu5dI7c60lzT4fbKlHSPOFphAGS9sbkjkRdwuY5mb2ieoV3zqbZgtBhzObyQSYj
        wHTnXNqA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34212)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oWPY0-00070W-Jt; Thu, 08 Sep 2022 22:58:56 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oWPXy-0002Q3-2D; Thu, 08 Sep 2022 22:58:54 +0100
Date:   Thu, 8 Sep 2022 22:58:54 +0100
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
Message-ID: <YxplnlI5JatVNr+j@shell.armlinux.org.uk>
References: <20220906161852.1538270-1-sean.anderson@seco.com>
 <20220906161852.1538270-2-sean.anderson@seco.com>
 <YxhmnVIB+qT0W/5v@shell.armlinux.org.uk>
 <8cf0a225-31b7-748d-bb9d-ac4bbddd4b6a@seco.com>
 <YxjdQzEFlJPQMkEl@shell.armlinux.org.uk>
 <745dfe6a-8731-02cc-512a-b46ece9169ed@seco.com>
 <YxkGr611ZA1EF58N@shell.armlinux.org.uk>
 <0186263e-bcb6-d144-5e6d-23400179ca38@seco.com>
 <Yxn6erbqg6AJNoAw@shell.armlinux.org.uk>
 <14dea2bf-91fe-e6db-5031-b7078f0dfe88@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14dea2bf-91fe-e6db-5031-b7078f0dfe88@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 08, 2022 at 05:03:57PM -0400, Sean Anderson wrote:
> On 9/8/22 10:21 AM, Russell King (Oracle) wrote:
> > On Wed, Sep 07, 2022 at 06:39:34PM -0400, Sean Anderson wrote:
> >> On 9/7/22 17:01, Russell King (Oracle) wrote:
> >> > On Wed, Sep 07, 2022 at 04:11:14PM -0400, Sean Anderson wrote:
> >> > > On 9/7/22 2:04 PM, Russell King (Oracle) wrote:
> >> > Given that going from tx/rx back to pause/asym_dir bits is not trivial
> >> > (because the translation depends on the remote advertisement) it is
> >> > highly unlikely that the description would frame the support in terms
> >> > of whether the hardware can transmit and/or receive pause frames.
> >> 
> >> I think it is? Usually if both symmetric and asymmetric pause is
> >> possible then there are two PAUSE_TX and PAUSE_RX fields in a register
> >> somewhere. Similarly, if there is only symmetric pause, then there is a
> >> PAUSE_EN bit in a register. And if only one of TX and RX is possible,
> >> then there will only be one field. There are a few drivers where you
> >> program the advertisement and let the hardware do the rest, but even
> >> then there's usually a manual mode (which should be enabled by the
> >> poorly-documented permit_pause_to_mac parameter).
> > 
> > The problem with "if there is only symmetric pause, then there is a
> > PAUSE_EN bit in a register" is that for a device that only supports
> > the ability to transmit pause, it would have a bit to enable the
> > advertisement of the ASM_DIR bit, and possibly also have a PAUSE_EN
> > bit in a register to enable the transmission of pause frames.
> > 
> > So if you look just at what bits there are to enable, you might
> > mistake a single pause bit to mean symmetric pause when it doesn't
> > actually support that mode.
> 
> Sure, but usually that is noted in the documentation.
> 
> > Let's take this a step further. Let's say that a device only has the
> > capability to receive pause frames. How does that correspond with
> > the SYM (PAUSE) and ASYM (ASM_DIR) bits? The only state that provides
> > for receive-only mode is if both of these bits are set, but wait a
> > moment, for a device that supports independent control of transmit
> > and receive, it's exactly the same encoding!
> > 
> > Fundamentally, a device can not really be "only capable of receiving
> > pause frames" because there is no way to set the local advertisement
> > to indicate to the remote end that the local end can not send pause
> > frames.
> 
> Yup. Only half of the combinations can be expressed.
> 
> > The next issue is... how do you determine that a MAC that supports
> > transmission and reception of pause frames has independent or common
> > control of those two functions? That determines whether ASM_DIR can
> > be set along with PAUSE.
> 
> This is why I suggested down below that we encode exactly that in the
> mac caps.
> 
> > So, trying to work back from whether tx and rx are supported to which
> > of PAUSE and ASM_DIR should be set is quite a non-starter.
> > 
> >> However, it is not obvious (at least it wasn't to me)
> >> 
> >> - That MAC_SYM_PAUSE/MAC_ASYM_PAUSE control to the PAUSE and ASYM_DIR
> >>   bits (when MLO_PAUSE_AN is set).
> > 
> > I'm not sure why, because the linkmodes that the MAC deals with in
> > its validate() callback determine what is supported and what is
> > advertised, and phylink_caps_to_linkmodes() which is used in the
> > implementation of this method does:
> > 
> >         if (caps & MAC_SYM_PAUSE)
> >                 __set_bit(ETHTOOL_LINK_MODE_Pause_BIT, linkmodes);
> > 
> >         if (caps & MAC_ASYM_PAUSE)
> >                 __set_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT, linkmodes);
> > 
> > Were you not aware that these two ethtool link mode bits control
> > the advertisement?
> 
> Yes. I had to dig into the code to determine what these bits were for.
> Since there is no documentation (which what this patch aims to address),
> that really is the only option. Additionally, the terminology is
> different from what IEEE uses (although IMO it better describes the
> function of the bits).
> 
> >> - How MAC_*_PAUSE related to the resolved pause mode in mac_link_up.
> >> 
> >> > Note from the table above, it is not possible to advertise that you
> >> > do not support transmission of pause frames.
> >> 
> >> Just don't set either of MAC_*_PAUSE :)
> >> 
> >> Of course, hardware manufacturers are hopefully aware that only half of
> >> the possible combinations are supported and don't produce hardware with
> >> capabilities that can't be advertised.
> > 
> > Well, having read a few (although limited) number of documents on
> > ethernet MACs, they tend to frame the support in terms of whether
> > symmetric pause being supported or just the whole lot. Given that
> > IEEE 802.3's starting point for pause frames is the advertisement
> > rather than whether the hardware supports transmission or
> > reception, I think it would be rather silly to specify it in terms
> > of the tx/rx support.
> > 
> > If one's reverse engineering, then I think it's reasonable that if
> > you determine what the capabilities of the hardware is, it's then
> > up to the reverse engineer to do the next step and consult 802.3
> > table 28B-3 and work out what the advertisement should be.
> > 
> >> > > > The following table lists the values of tx_pause and rx_pause which
> >> > > > might be requested in mac_link_up depending on the results of> autonegotiation (when MLO_PAUSE_AN is set):>
> >> > > > MAC_SYM_PAUSE MAC_ASYM_PAUSE tx_pause rx_pause
> >> > > > ============= ============== ======== ========
> >> > > >              0              0        0        0
> >> > > >              0              1        0        0>                                     1        0
> >> > > >              1              0        0        0
> >> > > >                                      1        1>             1              1        0        0
> >> > > >                                      0        1
> >> > > >                                      1        1
> >> > > > 
> >> > > > When MLO_PAUSE_AN is not set, any combination of tx_pause and> rx_pause may be requested. This depends on user configuration,
> >> > > > without regard to the values of MAC_SYM_PAUSE and MAC_ASYM_PAUSE.
> >> > 
> >> > The above is how I'm viewing this, and because of the broken formatting,
> >> > it's impossible to make sense of, sorry.
> >> 
> >> Sorry, my mail client mangled it. Second attempt:
> >> 
> >> > MAC_SYM_PAUSE MAC_ASYM_PAUSE tx_pause rx_pause
> >> > ============= ============== ======== ========
> >> >             0              0        0        0
> >> >             0              1        0        0
> >> >                                     1        0
> >> >             1              0        0        0
> >> >                                     1        1
> >> >             1              1        0        0
> >> >                                     0        1
> >> >                                     1        1
> > 
> > That's fine for the autonegotiation resolution, but you originally stated
> > that your table was also for user-settings as well - and that's where I
> > originally took issue and still do.
> >
> > As I've tried to explain, for a MAC that supports the MAC_SYM_PAUSE=1
> > MAC_ASYM_PAUSE=1 case, the full set of four states of tx_pause and
> > rx_pause are possible to configure when autoneg is disabled _even_
> > when there is no way to properly advertise it.
> 
> I assume you wrote this before reading the below.
> 
> > The point of forcing the pause state is to override autonegotiation,
> > because maybe the autonegotiation state is wrong and you explicitly
> > want a particular configuration for the link.
> > 
> >> > So, if a MAC only supports symmetric pause, it can key off either of
> >> > these two flags as it is guaranteed that they will be identical in
> >> > for a MAC that only supports symmetric pause.
> >> 
> >> OK, so taking that into account then perhaps the post-table explanation
> >> should be reworded to
> >> 
> >> > When MLO_PAUSE_AN is not set and MAC_ASYM_PAUSE is set, any
> >> > combination of tx_pause and rx_pause may be requested. This depends on
> >> > user configuration, without regard to the value of MAC_SYM_PAUSE. When
> >> > When MLO_PAUSE_AN is not set and MAC_ASYM_PAUSE is also unset, then
> >> > tx_pause and rx_pause will still depend on user configuration, but
> >> > will always equal each other.
> >> 
> >> Or maybe the above table should be extended to be
> >> 
> >> > MLO_PAUSE_AN MAC_SYM_PAUSE MAC_ASYM_PAUSE  tx_pause rx_pause
> >> > ============ ============= ==============  ======== ========
> >> >            0             0              0         0        0
> >> >            0             0              1         0        0
> >> >                                                   1        0
> >> >            0             1              0         0        0
> >> >                                                   1        1
> >> >            0             1              1         0        0
> >> >                                                   0        1
> >> >                                                   1        1
> >> >            1             0              0         0        0
> >> >            1             X              1         X        X
> >> >            1             1              0         0        0
> >> >                                                   1        1
> >> 
> >> With a note like
> >> 
> >> > When MLO_PAUSE_AN is not set, the values of tx_pause and rx_pause
> >> > depend on user configuration. When MAC_ASYM_PAUSE is not set, tx_pause
> >> > and rx_pause will be restricted to be either both enabled or both
> >> > disabled. Otherwise, no restrictions are placed on their values,
> >> > allowing configurations which would not be attainable as a result of
> >> > autonegotiation.
> >> 
> 
> These options are what I propose to do with the table. I think these address
> your concern that user-specified behavior was not documented properly. Upon
> review, I think using the first table with the second note would be best.
> 
> >> IMO we should really switch to something like MAX_RX_PAUSE,
> >> MAC_TX_PAUSE, MAC_RXTX_PAUSE and let phylink handle all the details of
> >> turning that into sane advertisement.
> > 
> > I completely disagree for the technical example I gave above, where it
> > is impossible to advertise "hey, I support *only* receive pause". Also
> > it brings with it the issue that - does "MAC_RXTX_PAUSE" mean that the
> > MAC has independent control of transmit and receive pause frames, or
> > is it common.
> > 
> > I'm really sorry, but I think there are fundamental issues with trying
> > to frame the support in terms of "do we support transmission of pause
> > frames" and "do we support reception of pause frames" and working from
> > that back to an advertisement. The translation function from
> > capabilities to tx/rx enablement is a one-way translation - there is
> > no "good" reverse translation that doesn't involve ambiguity.
> 
> Of course. But this reflects what the hardware actually can do.
> 
> >> This would also let us return
> >> -EINVAL in phylink_ethtool_set_pauseparam when the user requests e.g.
> >> TX-only pause when the MAC only supports RX and RXTX.
> > 
> > As I've said, there is no way to advertise to the link partner that
> > RX-only is the only pause setting allowed, so it would be pretty
> > darn stupid for a manufacturer to design hardware with just that
> > capability..
> 
> Well, when the user specifies things we ignore the results of
> autonegotiation. So a user could specify tx only on one end of a link
> and rx only on the other end and have a working result which couldn't
> be the result of autonegotiation. By specifying what the hardware
> actually supports, phylink can determine whether what the user requests
> is supported, without regard to whether it could be autonegotiated. At
> the moment we allow the user to specify configurations which might not
> be supported at all. There is no error message when this happens, so a
> user can only discover this issue by reading the driver/datasheet or by
> sniffing the link traffic.
> 
> >> > Adding in the issue of rate adaption (sorry, I use "adaption" not
> >> > "adaptation" which I find rather irksome as in my - and apparently
> >> > a subsection of English speakers, the two have slightly different
> >> > meanings)
> >> 
> >> 802.3 calls it "rate adaptation" in clause 49 (10GBASE-R) and "rate
> >> matching" in clause 61 (10PASS-TL and 2BASE-TS). If you are opposed to
> >> the former, then I think the latter could also work. It's also shorter,
> >> which is definitely a plus.
> >> 
> >> Interestingly, wiktionary (with which I attempted to determine what that
> >> slightly-different meaning was) labels "adaption" as "rare" :)
> > 
> > I'm aware of that, but to me (and others) adaption is something that is
> > on-going. Adaptation is what animals _have_ done to cope with a changing
> > environment.
> > 
> > For this feature, I much prefer "rate matching" which avoids this whole
> > issue of "adaption" vs "adaptation" - you may notice that when we were
> > originally discussing this, I was using "rate matching" terminology!
> 
> OK, I'll rename this in the next spin.
> 
> >> > brings with it the problem that when using pause frames,
> >> > we need RX pause enabled, but on a MAC which only supports symmetric
> >> > pause, we can't enable RX pause without also transmitting pause frames.
> >> > So I would say such a setup was fundamentally mis-designed, and there's
> >> > little we can do to correct such a stupidity. Should we detect such
> >> > stupidities? Maybe, but what then? Refuse to function?
> >> 
> >> Previous discussion [1]. Right now we refuse to turn on rate adaptation
> >> if the MAC only supports symmetric pause. The maximally-robust solution
> >> would be to first try and autonegotiate with rate adaptation enabled and
> >> using symmetric pause, and then renegotiate without either enabled. I
> >> think that's significantly more complex, so I propose deferring such an
> >> implementation to whoever first complains about their link not being
> >> rate-adapted.
> > 
> > We can not get away from the fact that the only capabilities that a
> > MAC could advertise to say that it supports Rx-only pause mode is
> > one where it has both the PAUSE and ASM_DIR bits set. If it doesn't,
> > then, if you look at table 28B-3, there are no possible resolutions
> > to any other local advertisement state that result in Rx pause only
> > being enabled.
> 
> Well, what we really want to advertise is MLO_PAUSE_TXRX *without*
> MLO_PAUSE_NONE. This is of course not possible to advertise, hence
> the retry approach I suggested above.
> 
> > Therefore, a MAC that only supports Rx pause would be incapable
> > of properly advertising that fact to the remote link partner and
> > is probably not conformant with 802.3.
> 
> Autonegotiation is optional for pause support. I agree that such an
> implementation would be unusual.
> 
> > I'll also point you to table 28B-2 "Pause encoding":
> > 
> > |   PAUSE (A5)   ASM_DIR (A6)                   Capability
> > |   0            0            No PAUSE
> > |   0            1            Asymmetric PAUSE toward link partner
> > |   1            0            Symmetric PAUSE
> > |   1            1            Both Symmetric PAUSE and Asymmetric PAUSE toward
> > |                             local device
> > |
> > | The PAUSE bit indicates that the device is capable of providing the
> > | symmetric PAUSE functions as defined# in Annex 31B. The ASM_DIR bit
> > | indicates that asymmetric PAUSE is supported. The value of the PAUSE
> > | bit when the ASM_DIR bit is set indicates the direction the PAUSE
> > | frames are supported for flow across the link. Asymmetric PAUSE
> > | configuration results in independent enabling of the PAUSE receive
> > | and PAUSE transmit functions as defined by Annex 31B. See 28B.3
> > | regarding PAUSE configuration resolution.
> > 
> > So here, the capabilities of the local device are couched in terms of
> > support for "symmetric pause" and "asymmetric pause" and not whether
> > they support transmission of pause frames and reception of pause frames.
> > 
> > I put it that the use of "is symmetric pause supported" and "is
> > asymmetric pause supported" by phylink is the right set of capabilities
> > that the MAC should be supplying, and not whether transmission and or
> > reception of pause frames is supported.
> 
> Well the funky bit is that one can say "I support *only* asymmetric pause"
> which is pretty strange. By the above logic, devices supporting asymmetric
> pause should be a strict subset of those supporting symmetric pause. And
> yet it is not the case. IEEE has decided that this means tx-only devices.
> We have some devices like this in Linux already (ksz8795, macb). IMO this
> hijacking of meaning is precisely what needs to be documented, and also
> makes the symmetric/asymmetric pause distinction less useful.
> 
> > As I've pointed out, one can not go from tx and rx pause support to an
> > advertisement without ambiguity. That is why we can't advertise a
> > correct setting of PAUSE and ASM_DIR bits when using ethtool to
> > force a particular state of enables at the local end. To move to
> > using "is transmit pause supported" and "is receive pause supported"
> > will only _add_ ambiguity, and then we really do need documentation
> > to describe the behaviour we implement - because we then fall outside
> > of 802.3.
> 
> It removes ambiguity from the driver author's perspective. The ambiguity
> then shifts to phylink_caps_to_linkmodes, which can handle the translation.
> 
> In any case, since you prefer the underspecified representation then go
> ahead and keep using it.

tl;dr (sorry, I don't have time, I've had one hell of a day what with
needing to visit the eye hospital, and the passing of our Monarch
which needs me to organise stuff.)

As I've pointed out, I regard specifying whether something supports
tx pause, rx pause, or both to be an underspecification on the
grounds that there is no way to do the translation to the advertisement
in a way that is unambiguous. Moreover, I've pointed out that IEEE
802.3 talks about the capabilities in terms of symmetric and asymmetric
pause.

The fact is, IEEE 802.3 makes no provision for a MAC that only supports
RX pause. It's pretty obvious to me that the implementation choices are:

1) No pause capability (PAUSE=0 ASM_DIR=0)
2) TX pause capability (PAUSE=0 ASM_DIR=1)
3) TX and RX pause capability with a single control (PAUSE=1 ASM_DIR=0)
4) TX and RX pause capability with independent control (PAUSE=1 ASM_DIR=1)

Anything that goes outside of that is just trash, because the result of
autonegotiation can result in something that the MAC doesn't support
and there's sweet f.a. that the local side can do about it.

Anyway, I'm probably not going to respond on this anymore before next
week, I'm way too busy given today's events. Sorry.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
