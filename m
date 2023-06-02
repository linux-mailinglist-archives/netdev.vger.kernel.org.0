Return-Path: <netdev+bounces-7419-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BA0C7202BD
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 15:11:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 334012818A3
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 13:11:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B34818AFF;
	Fri,  2 Jun 2023 13:11:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D77111B8
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 13:11:51 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8195BE4D;
	Fri,  2 Jun 2023 06:11:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=OTouvSUz3z0SuKPd9GjaAkReu68Py/wYa5z+M99zv4Y=; b=jLaAHwh0koGGv0TijZOPa7Zpjd
	u9HlyFtdBXnU8uDysZ4jP3IzvPkgG3WsEC3+H55cDEbUJ1lqB7hVutURkgmZhs6WOdbs5g+eV0TAx
	j53GumEW7Tkv0M2FpXjRlgSAt5KUo4mREmFsuJxJSBAdhvs9bNN+AeZcljmbmH2Q8t1xXpimSEEqU
	JZEnzOwaSN5bMQ58Z98CTd2sDNTyhDo8eBvjLRa0sJlTy+7T4aOnTRyD9SUQp/hku7KWouFJ5WsQF
	XL6NXHGwqpvsQOI9CsCPHEGDcAnym1YZ/irS/6Kik3yBSX5/hi9Hk4Bt/T0rfVH6+6b8pJHnLKUZb
	CEYj8t0g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:50514)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q54Yn-00081X-GQ; Fri, 02 Jun 2023 14:11:17 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q54Yk-0002yf-QK; Fri, 02 Jun 2023 14:11:14 +0100
Date: Fri, 2 Jun 2023 14:11:14 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Ioana Ciornei <ioana.ciornei@nxp.com>
Cc: msmulski2@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com,
	olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, simon.horman@corigine.com,
	kabel@kernel.org, Michal Smulski <michal.smulski@ooma.com>
Subject: Re: [PATCH net-next v6 1/1] net: dsa: mv88e6xxx: implement USXGMII
 mode for mv88e6393x
Message-ID: <ZHnqcvP8hv19RBr8@shell.armlinux.org.uk>
References: <20230602001705.2747-1-msmulski2@gmail.com>
 <20230602001705.2747-2-msmulski2@gmail.com>
 <ZHnEzPadBBbfwj18@shell.armlinux.org.uk>
 <20230602112804.32ffi7mpk5xfzvq4@LXL00007.wbi.nxp.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230602112804.32ffi7mpk5xfzvq4@LXL00007.wbi.nxp.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 02, 2023 at 02:28:04PM +0300, Ioana Ciornei wrote:
> On Fri, Jun 02, 2023 at 11:30:36AM +0100, Russell King (Oracle) wrote:
> > On Thu, Jun 01, 2023 at 05:17:04PM -0700, msmulski2@gmail.com wrote:
> > > +/* USXGMII registers for Marvell switch 88e639x are undocumented and this function is based
> > > + * on some educated guesses. It appears that there are no status bits related to
> > > + * autonegotiation complete or flow control.
> > > + */
> > > +static int mv88e639x_serdes_pcs_get_state_usxgmii(struct mv88e6xxx_chip *chip,
> > > +						  int port, int lane,
> > > +						  struct phylink_link_state *state)
> > > +{
> > > +	u16 status, lp_status;
> > > +	int err;
> > > +
> > > +	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
> > > +				    MV88E6390_USXGMII_PHY_STATUS, &status);
> > > +	if (err) {
> > > +		dev_err(chip->dev, "can't read Serdes USXGMII PHY status: %d\n", err);
> > > +		return err;
> > > +	}
> > > +	dev_dbg(chip->dev, "USXGMII PHY status: 0x%x\n", status);
> > > +
> > > +	state->link = !!(status & MDIO_USXGMII_LINK);
> > > +
> > > +	if (state->link) {
> > > +		err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
> > > +					    MV88E6390_USXGMII_LP_STATUS, &lp_status);
> > 
> > What's the difference between these two registers? Specifically, what
> > I'm asking is why the USXGMII partner status seems to be split between
> > two separate registers.
> > 
> > Note that I think phylink_decode_usxgmii_word() is probably missing a
> > check for MDIO_USXGMII_LINK, based on how Cisco SGMII works (and
> > USXGMII is pretty similar.)
> > 
> > MDIO_USXGMII_LINK indicates whether the attached PHY has link on the
> > media side or not. It's entirely possible for the USXGMII link to be
> > up (thus allowing us to receive the "LPA" from the PHY) but for the
> > PHY to be reporting to us that it has no media side link.
> > 
> > So, I think phylink_decode_usxgmii_word() at least needs at the
> > beginning this added:
> > 
> > 	if (!(lpa & MDIO_USXGMII_LINK)) {
> > 		state->link = false;
> > 		return;
> > 	}
> > 
> > The only user of this has been the Lynx PCS, so I'll add Ioana to this
> > email as well to see whether there's any objection from Lynx PCS users
> > to adding it.
> >
> 
> I just tested this snippet on a LX2160ARDB that has USXGMII on two of
> its lanes which go to Aquantia AQR113C PHYs.
> 
> The lpa read is 0x5601 and, with the patch, the interface does not link
> up. I am not sure what is happening, if it's this PHY in particular that
> does not properly set MDIO_USXGMII_LINK.

Thanks for testing. I wonder if the USXGMII control word that the PHY
transmits can be read from one of its registers?

If the PHY is correctly setting the link bit, but it's not appearing
in the Lynx PCS registers as set, that would be weird, and suggest the
PCS is handling that itself. Does the Lynx link status bit change
according to the media link status, while the AN complete bit stays
set?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

