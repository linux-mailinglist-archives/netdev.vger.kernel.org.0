Return-Path: <netdev+bounces-2377-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1040870197D
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 21:24:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2F7C9281567
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 19:24:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B278E79F6;
	Sat, 13 May 2023 19:24:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02B92261D
	for <netdev@vger.kernel.org>; Sat, 13 May 2023 19:24:12 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F10D92D6B;
	Sat, 13 May 2023 12:24:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=ejigYKA2jW9v8wdqyVODWavPs1M2rhGZLjYt+IUBdkU=; b=Q2aAOG8cB1cKwgaJCvbqI0hhSQ
	hBbQIgjTyJdKMN3ySyY/mGAuxkrYrCIWd1awdXXDoAywVYcvgPcDC2ug6l758XL9RFYDQHw2ADlfG
	qL8LzhQim+7mXm6RqEBoIXu816RbJ029ZPux6uqt4P1vvS96bxWpNtfkeOjboWHlG0zOgTKIN9ugO
	cgNLu3UbQYaKhaHDQ1KMgeNZTh4JK0z7ITo0Dq/ivmeKHT/1giF37OpBsD4C6rySAatoAOq16SYaJ
	NFSjpiR9dJ5DT6AK7IPcPDNVQLeUYj070emQbC+nLIbxiZCg8+Y1U7EzFl86m/9u3oILr8Ox/td1m
	uAeNgNCg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:48866)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1pxuqa-0001hN-LP; Sat, 13 May 2023 20:24:04 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1pxuqX-0006MP-87; Sat, 13 May 2023 20:24:01 +0100
Date: Sat, 13 May 2023 20:24:01 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Daniel Golle <daniel@makrotopia.org>
Cc: Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Heiner Kallweit <hkallweit1@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: Re: [PATCH net-next 0/8] Improvements for RealTek 2.5G Ethernet PHYs
Message-ID: <ZF/j0WL2Cee+oCIr@shell.armlinux.org.uk>
References: <cover.1683756691.git.daniel@makrotopia.org>
 <55c11fd9-54cf-4460-a10c-52ff62b46a4c@lunn.ch>
 <ZF0iiDIZQzR8vMvm@pidgin.makrotopia.org>
 <ZF0mUeKjdvZNG44q@shell.armlinux.org.uk>
 <ZF0vXAzWg44GT+fA@shell.armlinux.org.uk>
 <ZF_Oato0B3d-apVv@pidgin.makrotopia.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZF_Oato0B3d-apVv@pidgin.makrotopia.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, May 13, 2023 at 07:52:42PM +0200, Daniel Golle wrote:
> Hi Russell,
> 
> thank you for valuable your input and suggestions.
> 
> On Thu, May 11, 2023 at 07:09:32PM +0100, Russell King (Oracle) wrote:
> > On Thu, May 11, 2023 at 06:30:57PM +0100, Russell King (Oracle) wrote:
> > > On Thu, May 11, 2023 at 07:14:48PM +0200, Daniel Golle wrote:
> > > > On Thu, May 11, 2023 at 02:28:15AM +0200, Andrew Lunn wrote:
> > > > > On Thu, May 11, 2023 at 12:53:22AM +0200, Daniel Golle wrote:
> > > > > > Improve support for RealTek 2.5G Ethernet PHYs (RTL822x series).
> > > > > > The PHYs can operate with Clause-22 and Clause-45 MDIO.
> > > > > > 
> > > > > > When using Clause-45 it is desireable to avoid rate-adapter mode and
> > > > > > rather have the MAC interface mode follow the PHY speed. The PHYs
> > > > > > support 2500Base-X for 2500M, and Cisco SGMII for 1000M/100M/10M.
> > > > > 
> > > > > I don't see what clause-45 has to do with this. The driver knows that
> > > > > both C22 and C45 addresses spaces exists in the hardware. It can do
> > > > > reads/writes on both. If the bus master does not support C45, C45 over
> > > > > C22 will be performed by the core.
> > > > 
> > > > My understanding is/was that switching the SerDes interface mode is only
> > > > intended with Clause-45 PHYs, derived from this comment and code:
> > > > 
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/phy/phylink.c#n1661
> > > 
> > > It's only because:
> > > 
> > > 1) Clause 22 PHYs haven't done this.
> > > 2) There is currently no way to know what set of interfaces a PHY would
> > >    make use of - and that affects what ethtool linkmodes are possible.
> > > 
> > > What you point to is nothing more than a hack to make Clause 45 PHYs
> > > work with the code that we currently have.
> 
> As this status-quo has been unchanged for several years now, we could
> as well consider it having evolved into a convention...?

No. It's documented as a hack in the source tree, and if hacks become
conventions, then that leads us into ever more complex code. No thanks.

> > > To sort this properly, we need PHY drivers to tell phylink what
> > > interfaces they are going to switch between once they have been
> > > attached to the network interface. This is what these patches in my
> > > net-queue branch are doing:
> > > 
> > > net: phy: add possible interfaces
> > > net: phy: marvell10g: fill in possible_interfaces
> > > net: phy: bcm84881: fill in possible_interfaces
> > > net: phylink: split out PHY validation from phylink_bringup_phy()
> > > net: phylink: validate only used interfaces for c45 PHYs
> > > 
> > > Why only C45 PHYs again? Because the two PHY drivers that I've added
> > > support for "possible_interfaces" to are both C45. There's no reason
> > > we can't make that work for C22 PHYs as well.
> 
> Are you planning to re-submit or merge those changes any time in the
> near future?

It depends what you mean by "near future". In any case, as a result of
this new use case for them, I did put in a bit more effort with these,
and they've now changed in my tree so that the "possible_interfaces"
thing can be used for _any_ PHY what so ever - no longer limited to
just clause 45 PHYs. That actually makes the patch changing phylink
quite a bit simpler.

> Regarding .get_rate_matching I understand that Linux currently just
> reads from the PHY whether rate matching is going to be performed.
> I assume the PHY should enable rate matching in case the MAC doesn't
> support lower-speed interface modes?

The whole rate-matching thing is a first generation attempt (not by
me!) to add generic support. It's not something that historically
I've cared about, because I haven't had the hardware that supports
it. So, when someone proposed something that looks reasonable, that's
what got merged.

However, now knowing what the Aquantia driver is doing - where its
entirely possible to have rate matching with some negotiation results
but not others, I would say that the current implementation is barely
up to the job - because it assumes that rate matching will be used
for all speeds or no speeds and not a mixture.

> In the marvell10g and aquantia PHY drivers I see that the bootloader (?)
> is probably supposed to have already done that, as there is no code to
> enable or disable rate adapter mode depending on the MACs
> capabilities.

Firstly, you have to understand the historical situation:

  phylib only operated with a single interface type, and mainly clause
  22 PHYs which had none of this interface switching or rate matching
  malarkey to contend with. So there has been no negotiation between
  phylib drivers and MACs. We have relied upon firmware descriptions
  (such as device tree) to tell us what interface mode should be used.

  Some PHY drivers configure the hardware to operate in the requested
  mode, others don't. Some configure only a subset of modes and just
  ignore other modes.

That is how most PHY drivers today operate.

Now that we have a growing number of Clause 45 drivers, the first fully
fleged one was 88x3310 on the Macchiatobin platform. This platform uses
interface-mode switching depending on the speed negotiated on the media
side. The MAC could be switched, so after a bit of discussion, phylib
permitted PHY drivers to switch phydev->interface when reading the PHY
status. There was no need for any negotiation - the hardware was already
setup by pinstrapping, and no need to consider the rate matching modes
on that PHY for two reasons:

1. the PHY is not MACSEC enabled, which means it is incapable of sending
   pause frames to the host. It is stated in the data sheet that in this
   case, the host MAC _must_ increase the IPG. We have no support in the
   MAC driver (mvpp2) to do this.

2. The mvpp2 hardware also does not support flow control, so even if we
   did have a PHY that produced pause frames.

So, overall, with this hardware combination, rate matching was utterly
pointless to consider.

In order to allow the PHY to advertise anything except the highest
speed, it needed a workaround/hack in phylink so that the validation
function allowed the slower speeds. This is how the Clause 45 hack
that's now present came about. If we had this "possible_interfaces"
thing, then that wouldn't have been needed.

Then, the Methode DM7052 SFP module came along, which did exactly the
same kind of host-interface switching that 88x3310 does, but without
_any_ inband words, not even in SGMII. So phylink ended up with a
workaround for the lack of inband (by being currently the only SFP
that phylink switches from inband to PHY mode.)

Then came Marek's 88x3310 on a SFP+ module, which did need some form
of negotiation of the interface modes between the MAC and PHY, so
Marek picked up some patches from my tree, worked on them and they're
now submitted. I wasn't entirely happy with them but had nothing
better, so I didn't object. I'm still not entirely happy with them.
This is where the marvell10g driver gained support for trying to work
out whether the PHY should be reconfigured to use rate-matching or not.

The reason I don't like this is for a few reasons:

1) filling in phydev->host_interfaces makes the PHY driver configure
   the MAC type overriding whatever device-tree said to use as the
   primary interface. Consequently, we can end up with the PHY and
   host MAC using different modes (e.g. a MAC supports USXGMII and
   10GBASE-R. DT says to use 10GBASE-R. MAC configures for 10GBASE-R.
   PHY configures itself for USXGMII.) Provided the MAC pays attention
   to phydev->interface, it shouldn't be a problem, but many MACs do
   not.

2) we have a chicken-and-egg problem in phylink. We don't know
   whether the PHY driver will behave in this way, so we need to
   compute what interface mode should be used before calling
   phy_attach_direct(). If a PHY driver does support host_interfaces,
   then it'll end up choosing some other interface mode, meanwhile
   we've set ourselves up to configure for the mode we've chosen -
   but we've already restricted the linkmodes that the PHY can
   support to the original interface mode we decided upon.

3) they can end up enabling rate-matching mode when in fact we don't
   want rate-matching (e.g. the MAC doesn't support it) but also
   doesn't support e.g. switching to SGMII from 10GBASE-R.

As such, this just doesn't feel like the correct solution to me, and
I think it ends up creating more problems for the future. I had
actually dropped the patches from my tree before they were submitted
because I'd decided they weren't a reasonable way forward.

Then the rate-matching stuff was bolted in, and we get to where we are
today.

As of yesterday, I have now received some SFP+ modules that contain a
*Marvell* AQrate AQR113C PHY - which is driven by the aquantia PHY
driver. These modules do rate-matching with pause frames, and its setup
at power-up so that everything goes to 10GBASE-R on the host side. That
means it'll only work in a SFP cage which is 10G capable.

What I have noticed is that our rate-matching negotiation in the kernel
is broken: as I say above, mvpp2 doesn't support pause-mode rate
matching, yet we end up with this being forced on the mvpp2 driver (and
for some reason, we get the "rx pause" in the link-up kernel
notification message, which I thought I said should *not* be the case
as that message is supposed to report what happened with the *media*
part of the link.)

The point that I'm making is that this code has evolved according to
people's needs, and where we are today with it, it's far from being
fully satisfactory. While it satisfies our currentl use cases, the
way we configure the MAC <-> PHY interface is creaking at the seams
and needs a total redesign, and while it's easy to say that, it's
much harder to find something that does work, and that doesn't
require massive changes in the kernel.

This is exactly what I had been doing with the patches in my tree,
first with the "host_interfaces" thing, then deciding that wasn't
such a good idea, then deciding it would be better (at least for
phylink) if we knew what interfaces the PHY was actually going to
switch between (aka the "possible_interfaces" thing.) Even that
isn't quite sufficient.

Here's what I think we might need to solve this properly.

- We need firmware to describe the capabilities of the board wiring
  between the MAC and the PHY - how many lanes, maximum supported
  speed (maybe minimum as well?) Firmware can also specify what the
  preferred operating mode is.

  (We've had discussion about this in the past... it didn't come to
  a resolution.)

- We need MAC driver to publish based on the above what interface
  modes its prepared to support, and for each interface mode, whether
  rate matching can be supported, and what *sort* of rate matching.
  There's pause-based, extended-IPG-based, and half-duplex back-
  pressure based.)

- We need to know what the PHY supports in exactly the same way.

- We then need a way to resolve those two which allows us to select
  either a single interface mode with or without rate matching, or
  a group of interface modes that the PHY would be prepared to switch
  between based on the media side resolution.

However, to get there, you're probably looking at years of work,
sending patches, getting lots of review comments, and probably getting
push-back against the idea from firmware people.

... and at that point one gets back to what is the simplest thing we
can do to patch the existing code to make our use cases work, rather
than having something designed that caters nicely for the problems
we have today, but also can be sensibly extended as this area is
clearly gaining more "features".

> So this problem (having to decides whether or not it is
> feasable to use rate-adapter mode of the PHY; I've 'abused' is_c45 to
> decide that...) is not being adressed by your patchset either, or did I
> miss something?

See the above!

> Anyway. In case you are submitting or merging that set of changes I can
> re-submit my series on top of it.

Well:

> > which comes before the above patches. I think that's a reasonable
> > expectation today but needs testing and review of all users (esp.
> > the DSA drivers.)
> 
> I can see that it should work fine with mt7530 which is the only DSA
> driver I have been dealing with and have hardware to test.

Yes, and that's one that I've updated myself to populate phylink's
supported_interfaces, which is a pre-requisit for this. Any phylink-
using driver that has not yet populated supported_interfaces will
break with the proposal I've made... because:

> > +	/* If the PHY provides a bitmap of the interfaces it will be using,
> > +	 * use this to validate the PHY. This can be used for both clause 22
> > +	 * and clause 45 PHYs.
> > +	 */
> > +	if (!phy_interface_empty(phy->possible_interfaces)) {
> > +		/* Calculate the union of the interfaces the PHY supports in
> > +		 * its configured state, and the host's supported interfaces.
> > +		 * We never want an interface that isn't supported by the host.
> > +		 */
> > +		phy_interface_and(interfaces, phy->possible_interfaces,
> > +				  pl->config->supported_interfaces);

As soon as we come across a PHY that populates possible_interfaces
without a MAC driver that populates supported_interfaces, this
will result in "interfaces" being empty and...

> > +
> > +		return phylink_validate_mask(pl, mode, supported, state,
> > +					     interfaces);

this will fail, and use the driver to fail.

The problem here is that each time we change stuff in phylink, we have
to maintain compatibility with all those drivers that already use
phylink - which means keeping the legacy methods. These legacy methods
are just building up and up over time, and unless a stop is put to
this, the code is going to become unmaintainable (not only because
of its complexity, but also because it becomes impossible to properly
test. I already don't have any way to test the legacy code paths
that exist today.)

So, I'm against making any further radical changes that involve
obsoleting anything further until we remove some of the legacy code
that has already accumulated.

One of those involves converting the mv88e6xxx DSA driver to use the
phylink_pcs stuff - that's blocked on DT changes that Andrew submitted
back in the first week of April which have only _just_ been picked up
by the Freescale iMX maintainer in the last couple of days (so we're
going to have to wait another kernel cycle before this can progress.)

Another is phylink requiring supported_interfaces to be filled in by
the MAC - I think that's already the case, but having phylink confirm
that would be really useful. I know it's already the case in the
kernels I run on my hardware, because I've had a patch in my tree
for almost the last eleven months checking for this and causing
phylink_create() to fail if it's not filled in. I tend to now code
my phylink changes on the assumption that everyone is filling this
in... which isn't particularly good (as can be seen in the example
for this possible_interfaces thing.)

Anyway, this is probably not the email you were hoping for. :D Sorry.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

