Return-Path: <netdev+bounces-4610-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7865E70D889
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 11:13:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 33563281330
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 09:13:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EB971E507;
	Tue, 23 May 2023 09:13:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70EAE1DDF7
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 09:13:06 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D13894;
	Tue, 23 May 2023 02:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=D9zz2EfQHvFlqqWXnKU+7M4y1ladVpq1HHbcIMCV3vs=; b=EzCfXQQYj+5+gv8aimO33Wlymt
	0omXim2MltSjSqNf9ewvxI6uVWrvwlLoKZyUWYzxIvK0a0K3Cn1p5QghNKzEhiaVTJPz8wwhaYXyO
	nXPusPy+4LgGTq2TQGOXMp4VW3/juA/sIpZTy5Nbk4/qxGhHrZKCM4Me2h/ONd0sd/Cv59YNUR9yT
	6Bhc61FAfT6rkX2NsQSOR86LgPImxxQvqon8qzkDm0RXtaZI3T4fbcHGLCnnoV14nNhZE5bKjk0rn
	p2p31FXJr5v5aN/ybzrMNkpP0cMsz+TqgyBbZ71dpZx4UuXy2ANNg3/nhNxNbmD8v1FRmHYFN6Qa1
	DPznK8eA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46606)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q1O4b-0008R2-HD; Tue, 23 May 2023 10:12:53 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q1O4Z-0000Ro-90; Tue, 23 May 2023 10:12:51 +0100
Date: Tue, 23 May 2023 10:12:51 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: David Epping <david.epping@missinglinkelectronics.com>
Cc: Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net v2 0/3] net: phy: mscc: support VSC8501
Message-ID: <ZGyDk0Om9Sr3hgLV@shell.armlinux.org.uk>
References: <20230523090405.10655-1-david.epping@missinglinkelectronics.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230523090405.10655-1-david.epping@missinglinkelectronics.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 23, 2023 at 11:04:02AM +0200, David Epping wrote:
> Hello,
> 
> this updated series of patches adds support for the VSC8501 Ethernet
> PHY and fixes support for the VSC8502 PHY in cases where no other
> software (like U-Boot) has initialized the PHY after power up.
> 
> The first patch simply adds the VSC8502 to the MODULE_DEVICE_TABLE,
> where I guess it was unintentionally missing. I have no hardware to
> test my change.
> 
> The second patch adds the VSC8501 PHY with exactly the same driver
> implementation as the existing VSC8502.
> 
> The third patch fixes the initialization for VSC8501 and VSC8502.
> I have tested this patch with VSC8501 on hardware in RGMII mode only.
> https://ww1.microchip.com/downloads/aemDocuments/documents/UNG/ProductDocuments/DataSheets/VSC8501-03_Datasheet_60001741A.PDF
> https://ww1.microchip.com/downloads/aemDocuments/documents/UNG/ProductDocuments/DataSheets/VSC8502-03_Datasheet_60001742B.pdf
> Table 4-42 "RGMII CONTROL, ADDRESS 20E2 (0X14)" Bit 11 for each of
> them.
> By default the RX_CLK is disabled for these PHYs. In cases where no
> other software, like U-Boot, enabled the clock, this results in no
> received packets being handed to the MAC.
> The patch enables this clock output.
> According to Microchip support (case number 01268776) this applies
> to all modes (RGMII, GMII, and MII).
> 
> Other PHYs sharing the same register map and code, like
> VSC8530/31/40/41 have the clock enabled and the relevant bit 11 is
> reserved and read-only for them. As per previous discussion the
> patch still clears the bit on these PHYs, too, possibly more easily
> supporting other future PHYs implementing this functionality.
> 
> For the VSC8572 family of PHYs, having a different register map,
> no such changes are applied.
> 
> Thanks for your feedback,
> David
> 
> --
> 
> Changes in v2:
> - adjust cover letter (U-Boot, PHY families)
> - add reviewed-by tags to patch 1/3 and 2/3
> - patch 3/3: combine vsc85xx_rgmii_set_skews() and
>   vsc85xx_rgmii_enable_rx_clk() into vsc85xx_update_rgmii_cntl()
>   for fewer MDIO accesses
> - patch 3/3: treat all VSC8502 family PHYs the same (regardless of
>   bit 11 reserved status)
> 
> Additional notes for review:
> - If you want to, feel free to add something like
>   Co developed by Vladimir Oltean <olteanv@gmail.com>.
>   I did not do that, because the Kernel documentation requires a
>   signed off by to go with it.
>   Significant parts of the new patch are from your emails.
> - I left the mutex_lock(&phydev->lock) in the
>   vsc85xx_update_rgmii_cntl() function, as I'm not sure whether it
>   is required to repeatedly access phydev->interface and
>   phy_interface_is_rgmii(phydev) in a consistent way.

Nothing should change phydev->interface except:
1. the PHY driver in its ->read_status method when phylib has been
   started (via phy_start()).
2. phylib when the PHY is initially being attached.

The config_init methods are called during initial attachment and also
when the phy is being resumed, for neither of which phylib will be in
the "started" mode so (1) doesn't apply, and (2) doesn't apply because
phy_attach_direct() will have set ->interface prior to calling the
config_init method.

As far as a phy driver should be concerned, phydev->interface is
stable while it's being called.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

