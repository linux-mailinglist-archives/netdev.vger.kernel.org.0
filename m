Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4F3D576A43
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 00:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbiGOW6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 18:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiGOW57 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 18:57:59 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7D194BD1D;
        Fri, 15 Jul 2022 15:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=EvJ3Fe+zZItO1d7nZXO4dYX9eoE5cykrDlSq8lZcwuI=; b=RzhexsrmLV0WzcBsIJEirog/s6
        qd7GO7qXfkMR52c8r+inRuT/oGCYCHoAYAQPLgaSjyoUOT+/cc9OsFJbNA0IODlmZvatOXy0jQ9bE
        XQzUTDrCa9titdKJOTLWHRVT5ic2pWdnGHGwGu1mBxNHbwVWgoczboNXskT3TWQO/vojLSy34y6Qd
        WVV3SzYTpLgUgMsA30M86gQ4KpX43/dr+ZS7CiFRiU2KFc7WTZdzPjjhVvI58Zuj/M5X6TNdNRfbl
        cM5mP3bM2+QunXG1hy0xJ0bAtERSKzHJ/WffF0ty6JX2m9+AyvguH8Lw7O+vz1KTLfRAIOeaozP3C
        Jf10YM1Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33370)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oCUFS-0007j3-8r; Fri, 15 Jul 2022 23:57:26 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oCUFM-0007vh-2Q; Fri, 15 Jul 2022 23:57:20 +0100
Date:   Fri, 15 Jul 2022 23:57:20 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alvin __ipraga <alsi@bang-olufsen.dk>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Daniel Scally <djrscally@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Subject: Re: [PATCH net-next 3/6] net: dsa: add support for retrieving the
 interface mode
Message-ID: <YtHw0O5NB6kGkdwV@shell.armlinux.org.uk>
References: <YtGPO5SkMZfN8b/s@shell.armlinux.org.uk>
 <YtGPO5SkMZfN8b/s@shell.armlinux.org.uk>
 <E1oCNl3-006e3n-PT@rmk-PC.armlinux.org.uk>
 <E1oCNl3-006e3n-PT@rmk-PC.armlinux.org.uk>
 <20220715172444.yins4kb2b6b35aql@skbuf>
 <YtHcpf4otJQS9hTO@shell.armlinux.org.uk>
 <20220715222348.okmeyd55o5u3gkyi@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220715222348.okmeyd55o5u3gkyi@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 16, 2022 at 01:23:48AM +0300, Vladimir Oltean wrote:
> On Fri, Jul 15, 2022 at 10:31:17PM +0100, Russell King (Oracle) wrote:
> > On Fri, Jul 15, 2022 at 08:24:44PM +0300, Vladimir Oltean wrote:
> > > On Fri, Jul 15, 2022 at 05:01:37PM +0100, Russell King (Oracle) wrote:
> > > > DSA port bindings allow for an optional phy interface mode. When an
> > > > interface mode is not specified, DSA uses the NA interface mode type.
> > > > 
> > > > However, phylink needs to know the parameters of the link, and this
> > > > will become especially important when using phylink for ports that
> > > > are devoid of all properties except the required "reg" property, so
> > > > that phylink can select the maximum supported link settings. Without
> > > > knowing the interface mode, phylink can't truely know the maximum
> > > > link speed.
> > > > 
> > > > Update the prototype for the phylink_get_caps method to allow drivers
> > > > to report this information back to DSA, and update all DSA
> > > > implementations function declarations to cater for this change. No
> > > > code is added to the implementations.
> > > > 
> > > > Reviewed-by: Marek Behún <kabel@kernel.org>
> > > > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> > > > ---
> > > (...)
> > > > diff --git a/include/net/dsa.h b/include/net/dsa.h
> > > > index b902b31bebce..7c6870d2c607 100644
> > > > --- a/include/net/dsa.h
> > > > +++ b/include/net/dsa.h
> > > > @@ -852,7 +852,8 @@ struct dsa_switch_ops {
> > > >  	 * PHYLINK integration
> > > >  	 */
> > > >  	void	(*phylink_get_caps)(struct dsa_switch *ds, int port,
> > > > -				    struct phylink_config *config);
> > > > +				    struct phylink_config *config,
> > > > +				    phy_interface_t *default_interface);
> > > 
> > > I would prefer having a dedicated void (*port_max_speed_interface),
> > > because the post-phylink DSA drivers (which are not few) will generally
> > > not need to concern themselves with implementing this, and I don't want
> > > driver writers to think they need to populate every parameter they see
> > > in phylink_get_caps. So the new function needs to be documented
> > > appropriately (specify who needs and who does not need to implement it,
> > > on which ports it will be called, etc).
> > > 
> > > In addition, if we have a dedicated ds->ops->port_max_speed_interface(),
> > > we can do a better job of avoiding breakage with this patch set, since
> > > if DSA cannot find a valid phylink fwnode, AND there is no
> > > port_max_speed_interface() callback for this driver, DSA can still
> > > preserve the current logic of not putting the port down, and not
> > > registering it with phylink. That can be accompanied by a dev_warn() to
> > > state that the CPU/DSA port isn't registered with phylink, please
> > > implement port_max_speed_interface() to address that.
> > 
> > To continue my previous email...
> > 
> > This is a great illustration why posting RFC series is a waste of time.
> > This patch was posted as RFC on:
> > 
> > 24th June
> > 29th June
> > 5th July
> > 13th July
> > 
> > Only when it's been posted today has there been a concern raised about
> > the approach. So, what's the use of asking for comments if comments only
> > come when patches are posted for merging. None what so ever. So, we've
> > lost the last three weeks because I decided to "be kind" and post RFC.
> > Total waste of effort.
> 
> Sorry, but I don't exactly have a reason to respond to this series earlier
> than others more directly affected, even less so when it's an RFC.
> My feedback is strictly from the point of view of the "other" drivers
> who don't care about context-specific interpretations of the CPU port
> OF node. For them it doesn't make sense to have "default_interface" an
> argument of phylink_get_caps.
> 
> Also about the total waste of effort (or at least time), it's not at all
> obvious to me that if I had provided more feedback earlier, this series
> would have been done with even one day earlier, considering you've stated
> at least twice that you're waiting for a reply from Andrew, which didn't come.

I've given up waiting, basically. I think anyone reasonable will also
have decided the same thing. As I've said, Jakub seems to have given up
waiting for people to review my RFC patches to - this is what Jakub
said to me last week on my RFC series:

| IIUC the folks we expect to pay attention/test have already done so,
| all we can do now is apply and deal with the reports. 5.21 is more
| likely to be LTS than 5.20, right? So no point delaying.

And I really am at the point of agreeing with this - people have had
more than sufficient time to comment, and if they haven't by now, either
they don't care or they're just being difficult and intentionally trying
to stall development effort.

> > Now, on your point... the series posted on the 24th June was using
> > the mv88e6xxx port_max_speed_interface() but discussion off the mailing
> > list:
> > 
> > 20:19 < rmk> kabel: hmm, is mv88e6393x_port_max_speed_mode() correct?
> > 20:20 < rmk> it seems to be suggesting to use PHY_INTERFACE_MODE_10GBASER for
> >              port 9
> > 09:50 < kabel> rmk: yes, 10gbase-r is correct for 6393x. But we need to add
> >                exception for 6191x, as is done in chip.c function
> >                mv88e6393x_phylink_get_caps()
> > 09:51 < kabel> rmk: on 6191x only port 10 supports >1g speeds
> > 11:51 < rmk> kabel: moving it into the get_caps function makes it easier to set
> >              the default_interfaces for 6193x
> > 14:20 < kabel> rmk: yes, get_caps doing it would be better
> > 
> > The problem is this - we call get_caps(), and we have to read registers
> > to work out what the port supports. If we have a separate callback, then
> > we need to re-read those registers to get the same information to report
> > what the default interface should be.
> > 
> > Since almost all of the Marvell implementations the values for both the
> > list of supported interfaces and the default interface both require
> > reading a register and translating it to a phy_interface_t, and then
> > setting the support mask, it seems logical to combine these two
> > functioalities into one function.
> 
> In essence that doesn't mean much; DSA isn't Marvell only, but I'll give
> it to you: if only the Marvell driver (and Broadcom later, I expect) is
> going to add support for the context-specific interpretation of CPU port
> OF nodes, then we may consider tailoring the implementation to their
> hardware register layout details. In any case, my concern can be
> addressed even if you insist on keeping the default interface as an
> argument of phylink_get_caps. There just needs to be a lot more
> documentation explaining who needs to populate that argument and why.

I don't get the point you're making here.

> Also, perhaps more importantly, a real effort needs to be put to prevent
> breakage for drivers that work without a phylink instance registered for
> the CPU port, and also don't report the default interface. Practically
> that just means not deleting the current logic, but making it one of 3
> options.
> 
> fwnode is valid from phylink's perspective?
>        /                             \
>  yes  /                               \ no
>      /                                 \
> register with phylink         can we determine the link parameters to create
>                                   a fixed-link software node?
>                                        /                \                     \
>                                  yes  /                  \  no                |
>                                      /                    \                   | this is missing
>                                     /                      \                  |
>              create the software node and       don't put the port down,      |
>              register with phylink              don't register with phylink   /

This is exactly what we have today, and is exactly what I'm trying to
get rid of, so we have _consistency_ in the implementation, to prevent
fuckups like I've created by converting many DSA drivers to use
phylink_pcs. Any DSA driver that used a PCS for the DSA or CPu port and
has been converted to phylink_pcs support has been broken in the last
few kernel cycles. I'm trying to address that breakage before
converting the Marvell DSA driver - which is the driver that highlighted
the problem.

We need to move away from the current model in DSA where we only use
stuff in random situations.

Well, at this point, I'm just going to give up with this kernel cycle.
It seems impossible to get this sorted. It seems impossible to move
forward with the conversion of Marvell DSA to phylink_pcs. In fact,
I might just give up with the idea of further phylink development
because it's just too fucking difficult, and getting feedback is just
impossible.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
