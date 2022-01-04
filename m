Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B63C9484319
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 15:11:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234033AbiADOLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 09:11:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232739AbiADOLw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 09:11:52 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4523BC061761;
        Tue,  4 Jan 2022 06:11:52 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id d198-20020a1c1dcf000000b0034569cdd2a2so1505605wmd.5;
        Tue, 04 Jan 2022 06:11:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=tKbvSu3VERuN7Mvus3JoKJojenLn23CI2Hzq+SUDqOY=;
        b=BF3DV9EbIPtv17aplQ+LQxQ5Apbh+O1cohpA3RIJDEjCBGfr424HMWDvVNUOXYGJqS
         4YDPBJR6CcKKHt+bUB6u12oy+mjlS/P6U8ZI96Ukw+391bBRBwtpDjSTD6hdwBrqT14s
         ivKBL682gH0RdBUT+h+1QCkjPAqZWKE1ETHWOLWLwCqnCk7gWSCYp1D74mTtVxyEyIVp
         WvHYJF5q5paBsIF7pYJeHr0Hqmtgl7bC/6SA3vvkUJYtAGzy1H2mhV/pbZR30mydn/TS
         l57h4gah1+OWdsCw/XLzR3t3aCYCD6anGmcBMCfkLkGFNkxFeUCdJwQR1Oj3gh8mq7o0
         47wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=tKbvSu3VERuN7Mvus3JoKJojenLn23CI2Hzq+SUDqOY=;
        b=DPXjW5BUFw1B3+QSPagMuT0MnASWHkzItaStXLZH/pcNzJZqKIGzNezPioXSaKJVJf
         ybYwbG5YQq7zx209WR3rc1NN3GG0296IJbE6JuKcaPAvZiiieJDFBcS01POfSiqLL1kk
         957t6Nw3yB9t3JD+NbcVP6DbswiEX6WnH4nq9MAo5bx6Os2gmr52OKDDUgqG3Dgzfq7D
         WTfYiMaM4bEhOXBMp8HhlyQMqx99skMJv2cW0SUfBeh+8iAF3F0O0DppPE7TZb79G9jS
         7heg+Nrn8LJU1MikZgSHqJyfKqe85UzVi7C1DXru47GyW7rVsqN9c7hJMjzfsx5A7+Fk
         WAgA==
X-Gm-Message-State: AOAM532GHjiyjtn0x2pDC0CY0LeI4SNI3F1NMQu4VavdNd/Eb40WjYA5
        YmqB0VDHE8V55ljeB4bB7Fs=
X-Google-Smtp-Source: ABdhPJwbYdtuqP/NVCjJGtJUmcyh5xxQ+vSka6h/JOGSg3jrjpegz3qSzFFUzPQ2PvycACkyZYAVYA==
X-Received: by 2002:a7b:c087:: with SMTP id r7mr42895428wmh.17.1641305510899;
        Tue, 04 Jan 2022 06:11:50 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id h3sm38549890wrt.94.2022.01.04.06.11.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 06:11:50 -0800 (PST)
Date:   Tue, 4 Jan 2022 15:11:46 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     linus.walleij@linaro.org, ulli.kroll@googlemail.com,
        kuba@kernel.org, davem@davemloft.net, andrew@lunn.ch,
        hkallweit1@gmail.com, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: net: phy: marvell: network working with generic PHY and not with
 marvell PHY
Message-ID: <YdRVovG9mgEWffkn@Red>
References: <YdQoOSXS98+Af1wO@Red>
 <YdQsJnfqjaFrtC0m@shell.armlinux.org.uk>
 <YdQwexJVfrdzEfZK@Red>
 <YdQydK4GhI0P5RYL@shell.armlinux.org.uk>
 <YdQ5i+//UITSbxS/@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YdQ5i+//UITSbxS/@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Tue, Jan 04, 2022 at 12:11:55PM +0000, Russell King (Oracle) a écrit :
> On Tue, Jan 04, 2022 at 11:41:40AM +0000, Russell King (Oracle) wrote:
> > On Tue, Jan 04, 2022 at 12:33:15PM +0100, Corentin Labbe wrote:
> > > Le Tue, Jan 04, 2022 at 11:14:46AM +0000, Russell King (Oracle) a écrit :
> > > > On Tue, Jan 04, 2022 at 11:58:01AM +0100, Corentin Labbe wrote:
> > > > > Hello
> > > > > 
> > > > > I have a gemini SSI 1328 box which has a cortina ethernet MAC with a Marvell 88E1118 as given by:
> > > > > Marvell 88E1118 gpio-0:01: attached PHY driver (mii_bus:phy_addr=gpio-0:01, irq=POLL)
> > > > > So booting with CONFIG_MARVELL_PHY=y lead to a non-working network with link set at 1Gbit
> > > > > Setting 'max-speed = <100>;' (as current state in mainline dtb) lead to a working network.
> > > > > By not working, I mean kernel started with ip=dhcp cannot get an IP.
> > > > 
> > > > How is the PHY connected to the host (which interface mode?) If it's
> > > > RGMII, it could be that the wrong RGMII interface mode is specified in
> > > > DT.
> > > > 
> > > 
> > > The PHY is set as RGMII in DT (arch/arm/boot/dts/gemini-ssi1328.dts)
> > > The only change to the mainline dtb is removing the max-speed.
> > 
> > So, it's using "rgmii" with no delay configured at the PHY with the
> > speed limited to 100Mbps. You then remove the speed limitation and
> > it doesn't work at 1Gbps.
> > 
> > I think I've seen this on other platforms (imx6 + ar8035) when the
> > RGMII delay is not correctly configured - it will work at slower
> > speeds but not 1G.
> > 
> > The RGMII spec specifies that there will be a delay - and the delay can
> > be introduced by either the MAC, PHY or by PCB track routing. It sounds
> > to me like your boot environment configures the PHY to introduce the
> > necessary delay, but then, because the DT "rgmii" mode means "no delay
> > at the PHY" when you use the Marvell driver (which respects that), the
> > Marvell driver configures the PHY for no delay, resulting in a non-
> > working situation at 1G.
> > 
> > I would suggest checking how the boot environment configures the PHY,
> > and change the "rgmii" mode in DT to match. There is a description of
> > the four RGMII modes in Documentation/networking/phy.rst that may help
> > understand what each one means.
> 
> Hmm. Sorry, I'm leading you stray. It looks like the 88E1118 code does
> not program any delays depending on the interface mode, so changing that
> will have no effect.
> 
> I suspect, looking at m88e1118_config_init(), that the write to register
> 0x15 in the MSCR page could be the problem.
> 
> 0x15 is 21, which is MII_88E1121_PHY_MSCR_REG. In other Marvell PHYs,
> bits 4 and 5 are the tx and rx delays, both of which are set. Looking
> at m88e1121_config_aneg_rgmii_delays(), this would seem to indicate
> that the PHY is being placed into rgmii-id mode.
> 
> Can you try changing:
> 
> 	err = phy_write(phydev, 0x15, 0x1070);
> 
> to:
> 
> 	err = phy_write(phydev, 0x15, 0x1040);
> 
> and see what happens? Maybe trying other combinations of bits 4 and 5
> to find a working combination.
> 

Forget my other message, using 0x1040 lead to success.
My problem was that I tried rgmii-id which net/ethernet/cortina does not support on some code path. (everything test PHY_INTERFACE_MODE_RGMII only)
So I retry tests with original phy-mode = "rgmii".

So with the following changes everything is ok:
diff --git a/arch/arm/boot/dts/gemini-ssi1328.dts b/arch/arm/boot/dts/gemini-ssi1328.dts
index 113feb1c4922..7543d117a13a 100644
--- a/arch/arm/boot/dts/gemini-ssi1328.dts
+++ b/arch/arm/boot/dts/gemini-ssi1328.dts
@@ -40,10 +40,6 @@ mdio0: mdio {
                phy0: ethernet-phy@1 {
                        reg = <1>;
                        device_type = "ethernet-phy";
-                       /* We lack the knowledge of necessary GPIO to achieve
-                        * Gigabit
-                        */
-                       max-speed = <100>;
                };
                /* WAN ICPlus IP101A */
                phy1: ethernet-phy@2 {
diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 4fcfca4e1702..af7fc9d8eaa7 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -1233,7 +1233,7 @@ static int m88e1118_config_init(struct phy_device *phydev)
                return err;
 
        /* Enable 1000 Mbit */
-       err = phy_write(phydev, 0x15, 0x1070);
+       err = phy_write(phydev, 0x15, 0x1040);
        if (err < 0)
                return err;
 

