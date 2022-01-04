Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBAF64842E2
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 14:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233909AbiADN6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 08:58:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbiADN57 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 08:57:59 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B864C061761;
        Tue,  4 Jan 2022 05:57:59 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id i22so76337544wrb.13;
        Tue, 04 Jan 2022 05:57:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=59Ui4pp6p+B2nOc6YIpTXZ1z31kKMahzP0uMH6D38aY=;
        b=TQ7PiJhnTdkSwgadAr1WdaIR5NgxeFDWv1UsLO/+OoRruU2ROi3bJKmULSHxns20ky
         bzodtNTc+jeeAFee1eCl3fAleUolVIcp7xpfSN/qcx+QouFRVCucJC2+TXOCLyNaLRyd
         UQlwzLMalnCiJE0p6j0k5+9X/ivG/WpZ5gR74JcT8oQ4rfFsodykv3fits9aWxLIy0je
         GrWCbhA3yQ6GDSTlU1SFS6sfF3UC1CpJoxN9HB5SRYB45mEch8OodyVzXOZF6c3S1API
         2liWqSxnCRgae+v/BHDk8oshyqsLSyX0YOimj9G768JJWmuwehhzBoT9ccASacWM/8Uw
         kEkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=59Ui4pp6p+B2nOc6YIpTXZ1z31kKMahzP0uMH6D38aY=;
        b=g4zck0zy/HrhsrgV6EcZZCRBSfv1zFh2NPT1Ebab5T78iDyW/9Xux5a/O76qe3IcFn
         GSfdAPUzPact09oT1CWP1g0GUjo+WFAr8GH0S1ouR8NcuPxro0AkEuIXNOmg9ktHk28u
         wUZhLahxsq0b71yVHSXAPGQTs7BdhRi7jN5KJKGhPxm0cMgZWmjuBRulpIJ26ukivtQ5
         Qgoa7oVw1ld+j3oyHUMPXlmsP4ZYVR1h+VaMbQRsRiienUiU1jueroWOiH4x8LOcQ0sw
         eYhRZ2dehwsoPPFsV0jca7X1a+ESDh+9bMSojEEKqL2v3TvrOHaOMGGEt+bS2a/XBni9
         yT6Q==
X-Gm-Message-State: AOAM531qX/15H8rWjHgVIgIvON0bgcpJj2iqinInG9inSl4tbzgfUpor
        GG6VcxuOsNfW/2LlsZlCuw9OPv8KQnQ=
X-Google-Smtp-Source: ABdhPJx9Py9a5una5CMiAiQndYcFv41ilNpSEIX8LCYsrAjyRBjI1DZCM9F1XPo0eCbdtbVF8CP5Pw==
X-Received: by 2002:a5d:4ccb:: with SMTP id c11mr40824831wrt.689.1641304677840;
        Tue, 04 Jan 2022 05:57:57 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id a20sm32550780wmb.27.2022.01.04.05.57.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 05:57:57 -0800 (PST)
Date:   Tue, 4 Jan 2022 14:57:55 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     linus.walleij@linaro.org, ulli.kroll@googlemail.com,
        kuba@kernel.org, davem@davemloft.net, andrew@lunn.ch,
        hkallweit1@gmail.com, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: net: phy: marvell: network working with generic PHY and not with
 marvell PHY
Message-ID: <YdRSY50wyF7u8KCA@Red>
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

I tried more than all combinaisons (0x1010, 0x1020, 0x1030, 0x1040, 0x1050, 0x1060) without success.
A phy_read() just before the phy_write() give 0x1040.
I have also removed the phy_write() without success.
