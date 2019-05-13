Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 181DA1B40E
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 12:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728463AbfEMK3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 06:29:48 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:43601 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728395AbfEMK3s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 06:29:48 -0400
Received: by mail-lf1-f67.google.com with SMTP id u27so8609794lfg.10;
        Mon, 13 May 2019 03:29:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=ev9He8WIP0KFq4NY0aQ6H+a/tWRxRZKB/excb3oOMU4=;
        b=h93ew2GIej/nb5FvDaxvCU81MKw8hVhRlLnq/cdo21uphQzeKDmjsAyFc10JcthoCd
         wti7ndPmFhYhoCdl4R1uq+TYRLsi32+xB5e2Wta2zwj/cHFvNB+rCD+tEMhG9Hb3Pwkg
         QXuZfEzAb5mKOm6d8/tW+U80jTBHyh5RqGXyxpm6JLW+DnpIRl2KjdBVIgNZAS7ZBak6
         l3fNrTW4Z9JRPdRlETQ+wYiICPR6x57TqeopFqQatq87Q9vKzmbgK9ja2Fg8pRA7NnfG
         6P5af69gjE3NvsT8ggpQFdDtu/MyEQ9bOxy2K9FyhD0isU9UO5vE1aNeNNQsEXoBnAg9
         Wkuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=ev9He8WIP0KFq4NY0aQ6H+a/tWRxRZKB/excb3oOMU4=;
        b=az2bqyw0zL8ixQYdfl9ekvf/48EiGaiLjQHEo+FUjofR+gDWZXVPp9OV0O+PSPOd9c
         +3rkEfdsrZ/n9eb+Ayfrb2LEqokk4cve4NhnTM++MYdAeOc3E413U5IlGkgNOGeq9xbk
         CcI7MM8CA/wVBmtC10PW0QT3Dzw0EXsC5dajs/v22Y9nHUj0ZUwIuFxSl1eQ3wG3Kn03
         J9pKeu4P3ARQ9a/7eUz+gBFHhb3iYkt2VkAJDAhzeI5fz+qRF84QvYnjAJFYgXZgu5TV
         DK3YRtyAFRLpT7Anf3IRGCoWVYHiJo/HLllnuc8Wbyx4M/IccCOIJxE+ygg4iVQYHXQD
         OQbw==
X-Gm-Message-State: APjAAAX81WLGQFtZEQRDG+Ywzb77Gd4rcfF1Y1tXvORcHSelUn5TgUMx
        CC/H9qbhuMK453XrqMa5VZk=
X-Google-Smtp-Source: APXvYqxOYS4oX+yFe9eKc8O/cfCoUfwOBWae5+0G6pgMSsuJfH/uASlFKUjsj0yRPQxJFuWS01Q7wA==
X-Received: by 2002:a19:a412:: with SMTP id q18mr12957578lfc.142.1557743385498;
        Mon, 13 May 2019 03:29:45 -0700 (PDT)
Received: from mobilestation ([5.164.217.122])
        by smtp.gmail.com with ESMTPSA id j10sm3646535lfc.45.2019.05.13.03.29.44
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 13 May 2019 03:29:44 -0700 (PDT)
Date:   Mon, 13 May 2019 13:29:42 +0300
From:   Serge Semin <fancer.lancer@gmail.com>
To:     Vicente Bergas <vicencb@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: net: phy: realtek: regression, kernel null pointer dereference
Message-ID: <20190513102941.4ocb3tz3wmh3pj4t@mobilestation>
References: <16f75ff4-e3e3-4d96-b084-e772e3ce1c2b@gmail.com>
 <742a2235-4571-aa7d-af90-14c708205c6f@gmail.com>
 <11446b0b-c8a4-4e5f-bfa0-0892b500f467@gmail.com>
 <61831f43-3b24-47d9-ec6f-15be6a4568c5@gmail.com>
 <0f16b2c5-ef2a-42a1-acdc-08fa9971b347@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0f16b2c5-ef2a-42a1-acdc-08fa9971b347@gmail.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Vincente,

On Sat, May 11, 2019 at 05:06:04PM +0200, Vicente Bergas wrote:
> On Saturday, May 11, 2019 4:56:56 PM CEST, Heiner Kallweit wrote:
> > On 11.05.2019 16:46, Vicente Bergas wrote:
> > > On Friday, May 10, 2019 10:28:06 PM CEST, Heiner Kallweit wrote:
> > > > On 10.05.2019 17:05, Vicente Bergas wrote: ...
> > > 
> > > Hello Heiner,
> > > just tried your patch and indeed the NPE is gone. But still no network...
> > > The MAC <-> PHY link was working before, so, maybe the rgmii delays
> > > are not
> > > correctly configured.
> > 
> > That's a question to the author of the original patch. My patch was just
> > meant to fix the NPE. In which configuration are you using the RTL8211E?
> > As a standalone PHY (with which MAC/driver?) or is it the integrated PHY
> > in a member of the RTL8168 family?
> 
> It is the one on the Sapphire board, so is connected to the MAC on the
> RK3399 SoC. It is on page 8 of the schematics:
> http://dl.vamrs.com/products/sapphire_excavator/RK_SAPPHIRE_SOCBOARD_RK3399_LPDDR3D178P232SD8_V12_20161109HXS.pdf
> 

Thanks for sending this bug report.

As I said in the commit-message. The idea of this patch is to provide a way
to setup the RGMII delays in the PHY drivers (similar to the most of the PHY
drivers). Before this commit phy-mode dts-node hadn't been taked into account
by the PHY driver, so any PHY-delay setups provided via external pins strapping
were accepted as is. But now rtl8211e phy-mode is parsed as follows:
phy-mode="rgmii" - delays aren't set by PHY (current dts setting in rk3399-sapphire.dtsi)
phy-mode="rgmii-id" - both RX and TX delays are setup on the PHY side,
phy-mode="rgmii-rxid" - only RX delay is setup on the PHY side,
phy-mode="rgmii-txid" - only TX delay is setup on the PHY side.

It means, that now matter what the rtl8211e TXDLY/RXDLY pins are grounded or pulled
high, the delays are going to be setup in accordance with the dts phy-mode settings,
which is supposed to reflect the real hardware setup.

So since you get the problem with MAC<->PHY link, it means your dts-file didn't provide a
correct interface mode. Indeed seeing the sheet on page 7 in the sepphire pdf-file your
rtl8211e PHY is setup to have TXDLY/RXDLY being pulled high, which means to add 2ns delays
by the PHY. This setup corresponds to phy-mode="rgmii-id". As soon as you set it this way
in the rk3399 dts-file, the MAC-PHY link shall work correctly as before.

-Sergey

> > Serge: The issue with the NPE gave a hint already that you didn't test your
> > patch. Was your patch based on an actual issue on some board and did you
> > test it? We may have to consider reverting the patch.
> > 
> > > With this change it is back to working:
> > > --- a/drivers/net/phy/realtek.c
> > > +++ b/drivers/net/phy/realtek.c
> > > @@ -300,7 +300,6 @@
> > >     }, {
> > >         PHY_ID_MATCH_EXACT(0x001cc915),
> > >         .name        = "RTL8211E Gigabit Ethernet",
> > > -        .config_init    = &rtl8211e_config_init,
> > >         .ack_interrupt    = &rtl821x_ack_interrupt,
> > >         .config_intr    = &rtl8211e_config_intr,
> > >         .suspend    = genphy_suspend,
> > > That is basically reverting the patch.
> > > 
> > > Regards,
> > >  Vicenç.
> > > 
> > > > Nevertheless your proposed patch looks good to me, just one small change
> > > > would be needed and it should be splitted.
> > > > 
> > > > The change to phy-core I would consider a fix and it should be fine to
> > > > submit it to net (net-next is closed currently).
> > > > 
> > > > Adding the warning to the Realtek driver is fine, but this would be ...
> 
