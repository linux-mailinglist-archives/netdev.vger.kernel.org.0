Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 814CC1B450
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 12:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729166AbfEMKvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 06:51:11 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:41844 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728727AbfEMKvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 06:51:11 -0400
Received: by mail-lj1-f195.google.com with SMTP id k8so10468729lja.8;
        Mon, 13 May 2019 03:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=q1+r57G70j+ol1byo+a9ySh8n3xms1i0UMzqL6AmLfk=;
        b=YKORk/V1Has+1GHwTG1L3HSfdjcgroom4dcbKiWC5Zm3NcDsKBDAytn+246dzZsnEz
         JY1DVKR/2DHzVK6NPp7EyjCRomQl759SYvv6wyvBIXlR/yptexwWjkk7WxhopAF/XktH
         xNgPiYOHQWOWrboGbIwyZh4OJYMH5/O/yZ9Cnq3t1OXhmJkkypoa76uaEyqEeL+jzvJj
         lbcfzIx/BN4/nYRkxxo6p3eHksq+WTLisnLQzvkT6E3p2y2VN7NEwKr4q5jF6QxGriJB
         k7abT1812HYmuGWx82O9qCBCXUqlmey5PvkQBcz3f1eAgPuJ6bottuvyYSvQfBhRjrBE
         O8bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=q1+r57G70j+ol1byo+a9ySh8n3xms1i0UMzqL6AmLfk=;
        b=uCj1VXeid+aPGLCEGELm29YeBXlduKZZU7G0t5WGosSIHx0tVXtW1VqrVsPvFuq+Ur
         AYt7S3kYu/dZQ7M/oYcGrncSy8jVCNVhzkD/6tYJSfCjLlethfvVsPSt7HSeiDoa0Igk
         NEYEAVIkdlIQaiH+saK4lmrLfEs724AhkqaoFrD+xz/HD/cIgM1WLQDzgw4M52f4gzfW
         l1+ffamj5CKyqyMT+IBJC530PsQoe3I2jrtVT+m8fAcltwFSgKAgg86xuGvi56ot0p+f
         F76xn+C87+6rYQ1NvIfaZ97NZapBv1MtMqRwBZtqyVbpfXbs6KHdeq1TQk1RBhEFxZII
         rLMA==
X-Gm-Message-State: APjAAAVhFLYvK4fvLPfcpRzVqmhyxhn1G0e7Q5fI5fwSSU61hm3iR1W5
        19gM0lzy+4xYigrjknJJrEM=
X-Google-Smtp-Source: APXvYqzDFYidv17d2n6L+EYi8AtPv1dz814yOSwzFcnGvoKAu5vB5DGDXDaMb9Vh9tnMPji89PWZew==
X-Received: by 2002:a2e:a294:: with SMTP id k20mr8150939lja.118.1557744668334;
        Mon, 13 May 2019 03:51:08 -0700 (PDT)
Received: from mobilestation ([5.164.217.122])
        by smtp.gmail.com with ESMTPSA id k4sm3277931lja.18.2019.05.13.03.51.06
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 13 May 2019 03:51:07 -0700 (PDT)
Date:   Mon, 13 May 2019 13:51:05 +0300
From:   Serge Semin <fancer.lancer@gmail.com>
To:     Vicente Bergas <vicencb@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: net: phy: realtek: regression, kernel null pointer dereference
Message-ID: <20190513105104.af7d7n337lxqac63@mobilestation>
References: <16f75ff4-e3e3-4d96-b084-e772e3ce1c2b@gmail.com>
 <742a2235-4571-aa7d-af90-14c708205c6f@gmail.com>
 <11446b0b-c8a4-4e5f-bfa0-0892b500f467@gmail.com>
 <61831f43-3b24-47d9-ec6f-15be6a4568c5@gmail.com>
 <0f16b2c5-ef2a-42a1-acdc-08fa9971b347@gmail.com>
 <20190513102941.4ocb3tz3wmh3pj4t@mobilestation>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190513102941.4ocb3tz3wmh3pj4t@mobilestation>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 13, 2019 at 01:29:42PM +0300, Serge Semin wrote:
> Hello Vincente,
> 
> On Sat, May 11, 2019 at 05:06:04PM +0200, Vicente Bergas wrote:
> > On Saturday, May 11, 2019 4:56:56 PM CEST, Heiner Kallweit wrote:
> > > On 11.05.2019 16:46, Vicente Bergas wrote:
> > > > On Friday, May 10, 2019 10:28:06 PM CEST, Heiner Kallweit wrote:
> > > > > On 10.05.2019 17:05, Vicente Bergas wrote: ...
> > > > 
> > > > Hello Heiner,
> > > > just tried your patch and indeed the NPE is gone. But still no network...
> > > > The MAC <-> PHY link was working before, so, maybe the rgmii delays
> > > > are not
> > > > correctly configured.
> > > 
> > > That's a question to the author of the original patch. My patch was just
> > > meant to fix the NPE. In which configuration are you using the RTL8211E?
> > > As a standalone PHY (with which MAC/driver?) or is it the integrated PHY
> > > in a member of the RTL8168 family?
> > 
> > It is the one on the Sapphire board, so is connected to the MAC on the
> > RK3399 SoC. It is on page 8 of the schematics:
> > http://dl.vamrs.com/products/sapphire_excavator/RK_SAPPHIRE_SOCBOARD_RK3399_LPDDR3D178P232SD8_V12_20161109HXS.pdf
> > 
> 
> Thanks for sending this bug report.
> 
> As I said in the commit-message. The idea of this patch is to provide a way
> to setup the RGMII delays in the PHY drivers (similar to the most of the PHY
> drivers). Before this commit phy-mode dts-node hadn't been taked into account
> by the PHY driver, so any PHY-delay setups provided via external pins strapping
> were accepted as is. But now rtl8211e phy-mode is parsed as follows:
> phy-mode="rgmii" - delays aren't set by PHY (current dts setting in rk3399-sapphire.dtsi)
> phy-mode="rgmii-id" - both RX and TX delays are setup on the PHY side,
> phy-mode="rgmii-rxid" - only RX delay is setup on the PHY side,
> phy-mode="rgmii-txid" - only TX delay is setup on the PHY side.
> 
> It means, that now matter what the rtl8211e TXDLY/RXDLY pins are grounded or pulled
> high, the delays are going to be setup in accordance with the dts phy-mode settings,
> which is supposed to reflect the real hardware setup.
> 
> So since you get the problem with MAC<->PHY link, it means your dts-file didn't provide a
> correct interface mode. Indeed seeing the sheet on page 7 in the sepphire pdf-file your
> rtl8211e PHY is setup to have TXDLY/RXDLY being pulled high, which means to add 2ns delays
> by the PHY. This setup corresponds to phy-mode="rgmii-id". As soon as you set it this way
> in the rk3399 dts-file, the MAC-PHY link shall work correctly as before.
> 
> -Sergey

Hmm, just figured out, that in the datasheet RXDLY/TXDLY pins are actually grounded, so
phy-mode="rgmii" should work for you. Are you sure that on your actual hardware the
resistors aren't placed differently?

The current config register state can be read from the 0x1c extension page. Something
like this:
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -221,6 +221,9 @@ static int rtl8211e_config_init(struct phy_device *phydev)
 	if (ret)
 		goto err_restore_page;
 
+	ret = phy_read(phydev, 0x1c);
+	dev_info(&phydev->mdio.dev, "PHY config register %08x\n", ret);
+
 	ret = phy_modify(phydev, 0x1c, RTL8211E_TX_DELAY | RTL8211E_RX_DELAY,
 			 val);
 
-Sergey

> 
> > > Serge: The issue with the NPE gave a hint already that you didn't test your
> > > patch. Was your patch based on an actual issue on some board and did you
> > > test it? We may have to consider reverting the patch.
> > > 
> > > > With this change it is back to working:
> > > > --- a/drivers/net/phy/realtek.c
> > > > +++ b/drivers/net/phy/realtek.c
> > > > @@ -300,7 +300,6 @@
> > > >     }, {
> > > >         PHY_ID_MATCH_EXACT(0x001cc915),
> > > >         .name        = "RTL8211E Gigabit Ethernet",
> > > > -        .config_init    = &rtl8211e_config_init,
> > > >         .ack_interrupt    = &rtl821x_ack_interrupt,
> > > >         .config_intr    = &rtl8211e_config_intr,
> > > >         .suspend    = genphy_suspend,
> > > > That is basically reverting the patch.
> > > > 
> > > > Regards,
> > > >  Vicenç.
> > > > 
> > > > > Nevertheless your proposed patch looks good to me, just one small change
> > > > > would be needed and it should be splitted.
> > > > > 
> > > > > The change to phy-core I would consider a fix and it should be fine to
> > > > > submit it to net (net-next is closed currently).
> > > > > 
> > > > > Adding the warning to the Realtek driver is fine, but this would be ...
> > 
