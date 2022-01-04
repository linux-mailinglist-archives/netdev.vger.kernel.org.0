Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5729F484422
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 16:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234597AbiADPES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 10:04:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233062AbiADPER (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 10:04:17 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 628CBC061761;
        Tue,  4 Jan 2022 07:04:17 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id j18so76763263wrd.2;
        Tue, 04 Jan 2022 07:04:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=qRDKTEDCb+MtYyyGwc1k5PY8jOwrPWtqs0o9RjpMHjM=;
        b=lCyBImadHLQVC2wMSk1XUH13tJ+y/6Olw09TQRGrp8LES8TDps4ciSvchR3B00Mv6Z
         mFUDBwMjmdUZMVRfYsQxXHGg2rCtTTxkgcbieZVdFBYUyUMsnbwwIVeQFHG7iH8yNMGm
         81I0CFn/rqnJ5693ryieXCloJi3bUu7pnzwDXqvjimCuyPINHTVL6G6AJ8m/zbm8Za+Z
         uRxx0Y5Tbm2vMbGlFQijHPfnSFrhe0xB1Yvu8olcm3qKOTtwGID0cOmL7oVTOksXuF/w
         GfyQekNrWWMsYaXy3HkqcXdDZoTieRRuOjZ1AVwU6d/d+AuhzXdnv7O9Ei3+HTKeepWK
         0bZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=qRDKTEDCb+MtYyyGwc1k5PY8jOwrPWtqs0o9RjpMHjM=;
        b=rYF7QvsFG1ZR+f0M9QNwb6vu2n2fr0ANB/HBjIzkukCwwN7tP98rY2+yNq3sU/9557
         f3CVIqTkIXQkpXqkq+Y9GqxSo9Vs/ohoMyns+1nt5Bfv279+wvALYds/PQoYaHRSjmGV
         7vP+SNNADlcxnoVsIuqxj1CgoFu8+jvKY8iSfF3xESn5/MPOW6tq/4NXJo8b/b3CGAcc
         EjHD8EGpkAclOIYQltcj0kh8Zz6P4OeSzks/faPoE++XOyb8ofEdzHYjLBDi/LwcvX5t
         4uDrxQeuU8/VuvQBwrRuVIOHJguasUjKsawv3Bw5pik1NgxvbvANzzA9G8gtdNYm57ri
         qu/g==
X-Gm-Message-State: AOAM530Zdyjh2maJUs0kkSDKxiO+t/gocS9dsqyX2sl0V2AmmUBG2MCA
        J8pbOX5aqnG73rhLFjzLJaY=
X-Google-Smtp-Source: ABdhPJzgvWabhG1M3rSzr5zbHOX2T2DeLBa7A6ro8AOInSmnFxZfWPC4ZnS5YSMVf1dDSoMCf2p/rw==
X-Received: by 2002:a5d:6502:: with SMTP id x2mr31087112wru.90.1641308655801;
        Tue, 04 Jan 2022 07:04:15 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id h3sm38681784wrt.94.2022.01.04.07.04.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 07:04:15 -0800 (PST)
Date:   Tue, 4 Jan 2022 16:04:12 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     linus.walleij@linaro.org, ulli.kroll@googlemail.com,
        kuba@kernel.org, davem@davemloft.net, andrew@lunn.ch,
        hkallweit1@gmail.com, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: net: phy: marvell: network working with generic PHY and not with
 marvell PHY
Message-ID: <YdRh7Jq3WxkiJMbs@Red>
References: <YdQoOSXS98+Af1wO@Red>
 <YdQsJnfqjaFrtC0m@shell.armlinux.org.uk>
 <YdQwexJVfrdzEfZK@Red>
 <YdQydK4GhI0P5RYL@shell.armlinux.org.uk>
 <YdQ5i+//UITSbxS/@shell.armlinux.org.uk>
 <YdRVovG9mgEWffkn@Red>
 <YdRZQl6U0y19P/0+@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YdRZQl6U0y19P/0+@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Tue, Jan 04, 2022 at 02:27:14PM +0000, Russell King (Oracle) a écrit :
> On Tue, Jan 04, 2022 at 03:11:46PM +0100, Corentin Labbe wrote:
> > Le Tue, Jan 04, 2022 at 12:11:55PM +0000, Russell King (Oracle) a écrit :
> > > On Tue, Jan 04, 2022 at 11:41:40AM +0000, Russell King (Oracle) wrote:
> > > > On Tue, Jan 04, 2022 at 12:33:15PM +0100, Corentin Labbe wrote:
> > > > > Le Tue, Jan 04, 2022 at 11:14:46AM +0000, Russell King (Oracle) a écrit :
> > > > > > On Tue, Jan 04, 2022 at 11:58:01AM +0100, Corentin Labbe wrote:
> > > > > > > Hello
> > > > > > > 
> > > > > > > I have a gemini SSI 1328 box which has a cortina ethernet MAC with a Marvell 88E1118 as given by:
> > > > > > > Marvell 88E1118 gpio-0:01: attached PHY driver (mii_bus:phy_addr=gpio-0:01, irq=POLL)
> > > > > > > So booting with CONFIG_MARVELL_PHY=y lead to a non-working network with link set at 1Gbit
> > > > > > > Setting 'max-speed = <100>;' (as current state in mainline dtb) lead to a working network.
> > > > > > > By not working, I mean kernel started with ip=dhcp cannot get an IP.
> > > > > > 
> > > > > > How is the PHY connected to the host (which interface mode?) If it's
> > > > > > RGMII, it could be that the wrong RGMII interface mode is specified in
> > > > > > DT.
> > > > > > 
> > > > > 
> > > > > The PHY is set as RGMII in DT (arch/arm/boot/dts/gemini-ssi1328.dts)
> > > > > The only change to the mainline dtb is removing the max-speed.
> > > > 
> > > > So, it's using "rgmii" with no delay configured at the PHY with the
> > > > speed limited to 100Mbps. You then remove the speed limitation and
> > > > it doesn't work at 1Gbps.
> > > > 
> > > > I think I've seen this on other platforms (imx6 + ar8035) when the
> > > > RGMII delay is not correctly configured - it will work at slower
> > > > speeds but not 1G.
> > > > 
> > > > The RGMII spec specifies that there will be a delay - and the delay can
> > > > be introduced by either the MAC, PHY or by PCB track routing. It sounds
> > > > to me like your boot environment configures the PHY to introduce the
> > > > necessary delay, but then, because the DT "rgmii" mode means "no delay
> > > > at the PHY" when you use the Marvell driver (which respects that), the
> > > > Marvell driver configures the PHY for no delay, resulting in a non-
> > > > working situation at 1G.
> > > > 
> > > > I would suggest checking how the boot environment configures the PHY,
> > > > and change the "rgmii" mode in DT to match. There is a description of
> > > > the four RGMII modes in Documentation/networking/phy.rst that may help
> > > > understand what each one means.
> > > 
> > > Hmm. Sorry, I'm leading you stray. It looks like the 88E1118 code does
> > > not program any delays depending on the interface mode, so changing that
> > > will have no effect.
> > > 
> > > I suspect, looking at m88e1118_config_init(), that the write to register
> > > 0x15 in the MSCR page could be the problem.
> > > 
> > > 0x15 is 21, which is MII_88E1121_PHY_MSCR_REG. In other Marvell PHYs,
> > > bits 4 and 5 are the tx and rx delays, both of which are set. Looking
> > > at m88e1121_config_aneg_rgmii_delays(), this would seem to indicate
> > > that the PHY is being placed into rgmii-id mode.
> > > 
> > > Can you try changing:
> > > 
> > > 	err = phy_write(phydev, 0x15, 0x1070);
> > > 
> > > to:
> > > 
> > > 	err = phy_write(phydev, 0x15, 0x1040);
> > > 
> > > and see what happens? Maybe trying other combinations of bits 4 and 5
> > > to find a working combination.
> > > 
> > 
> > Forget my other message, using 0x1040 lead to success.
> > My problem was that I tried rgmii-id which net/ethernet/cortina does not support on some code path. (everything test PHY_INTERFACE_MODE_RGMII only)
> > So I retry tests with original phy-mode = "rgmii".
> > 
> > So with the following changes everything is ok:
> > diff --git a/arch/arm/boot/dts/gemini-ssi1328.dts b/arch/arm/boot/dts/gemini-ssi1328.dts
> > index 113feb1c4922..7543d117a13a 100644
> > --- a/arch/arm/boot/dts/gemini-ssi1328.dts
> > +++ b/arch/arm/boot/dts/gemini-ssi1328.dts
> > @@ -40,10 +40,6 @@ mdio0: mdio {
> >                 phy0: ethernet-phy@1 {
> >                         reg = <1>;
> >                         device_type = "ethernet-phy";
> > -                       /* We lack the knowledge of necessary GPIO to achieve
> > -                        * Gigabit
> > -                        */
> > -                       max-speed = <100>;
> >                 };
> >                 /* WAN ICPlus IP101A */
> >                 phy1: ethernet-phy@2 {
> > diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
> > index 4fcfca4e1702..af7fc9d8eaa7 100644
> > --- a/drivers/net/phy/marvell.c
> > +++ b/drivers/net/phy/marvell.c
> > @@ -1233,7 +1233,7 @@ static int m88e1118_config_init(struct phy_device *phydev)
> >                 return err;
> >  
> >         /* Enable 1000 Mbit */
> > -       err = phy_write(phydev, 0x15, 0x1070);
> > +       err = phy_write(phydev, 0x15, 0x1040);
> >         if (err < 0)
> >                 return err;
> >  
> 
> Okay, so we have two things that need fixing:
> 
> 1) We need m88e1118_config_init() to take note of the interface mode
> if it's RGMII, and program MSCR appropriately.
> 
> 2) We need drivers/net/ethernet/cortina/gemini.c to accept any RGMII
> interface mode.
> 
> Here's an untested patch for both - I've also converted the MSCR write
> to be more modern. Please let me know if this resolves your issue.
> We then need to consider whether it breaks any existing platform.

Patch works for me.
Furthermore, I have an other board with the same issue (but with a Realtek PHY).
But in that case, it was just a missing rgmii-id (and your ethernet/cortina/gemini change).

Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Tested-on: gemini-ssi1328
Tested-on: gemini-ns2502

I wait for patch to be sent before sending DTB changes on my side.

Thanks for your help

> 
> diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
> index 07add311f65d..c78b99a497df 100644
> --- a/drivers/net/ethernet/cortina/gemini.c
> +++ b/drivers/net/ethernet/cortina/gemini.c
> @@ -305,21 +305,21 @@ static void gmac_speed_set(struct net_device *netdev)
>  	switch (phydev->speed) {
>  	case 1000:
>  		status.bits.speed = GMAC_SPEED_1000;
> -		if (phydev->interface == PHY_INTERFACE_MODE_RGMII)
> +		if (phy_interface_mode_is_rgmii(phydev->interface))
>  			status.bits.mii_rmii = GMAC_PHY_RGMII_1000;
>  		netdev_dbg(netdev, "connect %s to RGMII @ 1Gbit\n",
>  			   phydev_name(phydev));
>  		break;
>  	case 100:
>  		status.bits.speed = GMAC_SPEED_100;
> -		if (phydev->interface == PHY_INTERFACE_MODE_RGMII)
> +		if (phy_interface_mode_is_rgmii(phydev->interface))
>  			status.bits.mii_rmii = GMAC_PHY_RGMII_100_10;
>  		netdev_dbg(netdev, "connect %s to RGMII @ 100 Mbit\n",
>  			   phydev_name(phydev));
>  		break;
>  	case 10:
>  		status.bits.speed = GMAC_SPEED_10;
> -		if (phydev->interface == PHY_INTERFACE_MODE_RGMII)
> +		if (phy_interface_mode_is_rgmii(phydev->interface))
>  			status.bits.mii_rmii = GMAC_PHY_RGMII_100_10;
>  		netdev_dbg(netdev, "connect %s to RGMII @ 10 Mbit\n",
>  			   phydev_name(phydev));
> @@ -389,6 +389,9 @@ static int gmac_setup_phy(struct net_device *netdev)
>  		status.bits.mii_rmii = GMAC_PHY_GMII;
>  		break;
>  	case PHY_INTERFACE_MODE_RGMII:
> +	case PHY_INTERFACE_MODE_RGMII_ID:
> +	case PHY_INTERFACE_MODE_RGMII_TXID:
> +	case PHY_INTERFACE_MODE_RGMII_RXID:
>  		netdev_dbg(netdev,
>  			   "RGMII: set GMAC0 and GMAC1 to MII/RGMII mode\n");
>  		status.bits.mii_rmii = GMAC_PHY_RGMII_100_10;
> diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
> index 4fcfca4e1702..ccf142ce55d8 100644
> --- a/drivers/net/phy/marvell.c
> +++ b/drivers/net/phy/marvell.c
> @@ -1227,16 +1227,18 @@ static int m88e1118_config_init(struct phy_device *phydev)
>  {
>  	int err;
>  
> -	/* Change address */
> -	err = marvell_set_page(phydev, MII_MARVELL_MSCR_PAGE);
> -	if (err < 0)
> -		return err;
> -
>  	/* Enable 1000 Mbit */
> -	err = phy_write(phydev, 0x15, 0x1070);
> +	err = phy_write_paged(phydev, MII_MARVELL_MSCR_PAGE,
> +			      MII_88E1121_PHY_MSCR_REG, 0x1070);
>  	if (err < 0)
>  		return err;
>  
> +	if (phy_interface_is_rgmii(phydev)) {
> +		err = m88e1121_config_aneg_rgmii_delays(phydev);
> +		if (err < 0)
> +			return err;
> +	}
> +
>  	/* Change address */
>  	err = marvell_set_page(phydev, MII_MARVELL_LED_PAGE);
>  	if (err < 0)
> 
> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
