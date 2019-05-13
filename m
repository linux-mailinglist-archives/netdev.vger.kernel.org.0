Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E07C1B62F
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 14:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729096AbfEMMmc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 08:42:32 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:40347 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728015AbfEMMmb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 08:42:31 -0400
Received: by mail-lf1-f65.google.com with SMTP id h13so8928169lfc.7;
        Mon, 13 May 2019 05:42:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=H3taMqxBU0K9Z7JWPWErppWk/cQFzli83lP4SPDgixk=;
        b=E1c9mdlnSxylCrM3JzyXAWmecuo6TySh6LfOTE+kKRtHqvlghD+09Emuvmnz5NGz68
         Je2mYftt0k5AispadbzuLDxVyM4kYMVkdc7N25tPhAFONAywIIVvSWV/GeXfL2svm+L3
         Fuypi/3S4ufdAgYnEl0dIWcyhgL9QY1APUcRkTBA8h9yRN3rgcgSJXY3l5GXAulAuPZ7
         18A9QpsxdPjhjGn6KpM+K7xcibCi+LX3QZs2SMCptwSn3eTtg9EcQdAeX2pnR3tVAwQS
         GKqI4bnq7c8mq/rMlto30SdCZgvEYEfVHCkiLVvxRvD3NS2BiaKEMlnzLxmPpuvkegcR
         ozmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=H3taMqxBU0K9Z7JWPWErppWk/cQFzli83lP4SPDgixk=;
        b=WxeeA6OWQfxQYuDUR/z988pjXTaiUtgkrDrmNBKbsqia0/za2vCGogX4q6y8+7HkzB
         iYoFe+dVCe25/eik3CQF/rfbtKzi8LDTri0Y2k6GeJXHCe254po1KU1LZ4kuW31PNsCv
         ryIeDa+/xgQ2rLfsevlj6O2OoAO+lFRAbwGxtedOQm8EGtmNDaOELhYq8ec/m3Ka2q/F
         XdlBeGBSJutMc+qA9oQmoV9E8D3PX/GsMzNd6o3MgjEgTBmlhSW7qLT0uKMsvNMickCv
         NIYr17PLCCy7/Ydg+nUcy9YXjnBQQSDtuHQlwb5dCdUuamFk1c9Ep9eEadZIAagGg1SW
         vCdg==
X-Gm-Message-State: APjAAAX1LVv+fTzWC4W+F/VRiwGWpQca3TCPbLKY8oQabixgHraMIorW
        49tCoYyAJJKaCh0NATTCJq4=
X-Google-Smtp-Source: APXvYqxgc8ZaUcFUJU+/qBd6Wfk6CiV2P6PU4MbqMnEF1AqufzJvSBtvpKByCS/hnWLFT06YdizJlA==
X-Received: by 2002:a19:c746:: with SMTP id x67mr13253246lff.152.1557751349451;
        Mon, 13 May 2019 05:42:29 -0700 (PDT)
Received: from mobilestation ([5.164.217.122])
        by smtp.gmail.com with ESMTPSA id o21sm3044405ljj.19.2019.05.13.05.42.28
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 13 May 2019 05:42:28 -0700 (PDT)
Date:   Mon, 13 May 2019 15:42:26 +0300
From:   Serge Semin <fancer.lancer@gmail.com>
To:     Vicente Bergas <vicencb@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: net: phy: realtek: regression, kernel null pointer dereference
Message-ID: <20190513124225.odm3shcfo3tsq6xk@mobilestation>
References: <16f75ff4-e3e3-4d96-b084-e772e3ce1c2b@gmail.com>
 <742a2235-4571-aa7d-af90-14c708205c6f@gmail.com>
 <11446b0b-c8a4-4e5f-bfa0-0892b500f467@gmail.com>
 <61831f43-3b24-47d9-ec6f-15be6a4568c5@gmail.com>
 <0f16b2c5-ef2a-42a1-acdc-08fa9971b347@gmail.com>
 <20190513102941.4ocb3tz3wmh3pj4t@mobilestation>
 <20190513105104.af7d7n337lxqac63@mobilestation>
 <cf1e81d9-6f91-41fe-a390-b9688e5707f7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cf1e81d9-6f91-41fe-a390-b9688e5707f7@gmail.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Mon, May 13, 2019 at 02:19:17PM +0200, Vicente Bergas wrote:
> On Monday, May 13, 2019 12:51:05 PM CEST, Serge Semin wrote:
> > On Mon, May 13, 2019 at 01:29:42PM +0300, Serge Semin wrote:
> > > Hello Vincente,
> > > 
> > > On Sat, May 11, 2019 at 05:06:04PM +0200, Vicente Bergas wrote: ...
> > 
> > Hmm, just figured out, that in the datasheet RXDLY/TXDLY pins are
> > actually grounded, so
> > phy-mode="rgmii" should work for you. Are you sure that on your actual
> > hardware the
> > resistors aren't placed differently?
> 
> That is correct, the schematic has pull-down resistors and placeholders for
> pull-up resistors. On the board I can confirm the pull-ups are not
> populated and the pull-downs are.
> But the issue seems unrelated to this.
> 
> I have traced it down to a deadlock while trying to acquire a mutex.
> It hangs here:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/phy/realtek.c?id=47782361aca2#n220
> while waiting for this mutex:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/phy/mdio_bus.c?id=47782361aca2#n692
> 
> Regards,
>  Vicenç.
> 

Ahh, I see. Then using lock-less version of the access methods must fix the
problem. You could try something like this:
-------------------------------------------------------------------------------
diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index 761ce3b1e7bd..14b61da1f32a 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -217,12 +217,12 @@ static int rtl8211e_config_init(struct phy_device *phydev)
 	if (oldpage < 0)
 		goto err_restore_page;
 
-	ret = phy_write(phydev, RTL821x_EXT_PAGE_SELECT, 0xa4);
+	ret = __phy_write(phydev, RTL821x_EXT_PAGE_SELECT, 0xa4);
 	if (ret)
 		goto err_restore_page;
 
-	ret = phy_modify(phydev, 0x1c, RTL8211E_TX_DELAY | RTL8211E_RX_DELAY,
-			 val);
+	ret = __phy_modify(phydev, 0x1c, RTL8211E_TX_DELAY | RTL8211E_RX_DELAY,
+			   val);
 
 err_restore_page:
 	return phy_restore_page(phydev, oldpage, ret);
-------------------------------------------------------------------------------

-Sergey

> > The current config register state can be read from the 0x1c extension
> > page. Something
> > like this:
> > --- a/drivers/net/phy/realtek.c
> > +++ b/drivers/net/phy/realtek.c
> > @@ -221,6 +221,9 @@ static int rtl8211e_config_init(struct phy_device
> > *phydev)
> >  	if (ret)
> >  		goto err_restore_page;
> > +	ret = phy_read(phydev, 0x1c);
> > +	dev_info(&phydev->mdio.dev, "PHY config register %08x\n", ret);
> > +
> >  	ret = phy_modify(phydev, 0x1c, RTL8211E_TX_DELAY | RTL8211E_RX_DELAY,
> >  			 val);
> > -Sergey
> 
