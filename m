Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDC984185B8
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 04:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbhIZClP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 22:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230302AbhIZClO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Sep 2021 22:41:14 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 594B8C061570;
        Sat, 25 Sep 2021 19:39:39 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id d8so13416188qtd.5;
        Sat, 25 Sep 2021 19:39:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=qpqhuiRlIWU7gOBdSvWRqVSRyWTEJI8IwnS1bJ+4B58=;
        b=m7jwiD37LE+twVp3oePct3cQp+xbcH3NXAqiKWVyi72+YrtkJo9GpsxMStpJKs+oAv
         4SoJEEjJkNjehxiKgsKQ6/mygGCswNETt1uQuQtdEKogcC0T2HFgUo3D3kSSRmh5NU/U
         aNg8+WRwXdulsLcDUmc+p0+tyHX7Xonfrikk6RxjENU7Woj80Inlim3+aQi8eAtX1u+E
         J5oHyoRudU6FOydM7UqdA9TF1L+fKhqSlv7GO5UjMZBpq0+5v1S3X9TGazjoe/06nLzq
         MRgdcHXxvoxpDmDKnmApRbkZZdPxr2SDB7qbEQfJZnQfU+F2APxU36h4ZgguXSPtW8ON
         c1Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=qpqhuiRlIWU7gOBdSvWRqVSRyWTEJI8IwnS1bJ+4B58=;
        b=r95e1pglifcE48WPkFSSK2f0qHknD/n6k/giTpdjtOs4NNAfhDBF1vkV73L3Bw1JO3
         bHhnjsQOU+h/JVsJ9lecZhMTvAPpEdNvY6IiQ45oOLp+0ySCCQVlAvKQh75Z+wA7jIAb
         5SCo7zt2UYXNMxBgc8ED1jxB+RJRnv0a1rJrgclr3qaJHnOwLfWuq2TRd2ihQM2ro9P1
         +6uQuskBnjTDDTQDIhEwoIos8BsthansFHKbXxIVeK43wUKfg+UFFyQGr+hXc/PJuY8c
         xAJDSPIbq176SV9Jt4g+QBBraxmb/KpKSnvGuKTpucElfaDaY8W4jNz92dz7v5bRJVwT
         dOKg==
X-Gm-Message-State: AOAM531I0sh6CaxUrUicR798L83snGPRnwvtUGOGBhtQJ7dGF/qelJzQ
        5/DKxxQxGjjHxnaPzt91KKo=
X-Google-Smtp-Source: ABdhPJw6I0fOInUsmRrO0NpifVd1jA4xdaPHBD0BRSmocAJIqwK0Mk/J4KWtqEPF4ONICxkHXn/VSA==
X-Received: by 2002:a05:622a:11d5:: with SMTP id n21mr12755687qtk.112.1632623978448;
        Sat, 25 Sep 2021 19:39:38 -0700 (PDT)
Received: from ?IPV6:2600:1700:dfe0:49f0:a90f:da5:ff6e:aa3e? ([2600:1700:dfe0:49f0:a90f:da5:ff6e:aa3e])
        by smtp.gmail.com with ESMTPSA id r5sm8061936qta.26.2021.09.25.19.39.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Sep 2021 19:39:37 -0700 (PDT)
Message-ID: <c66c8bd1-940a-bf9d-ce33-5a39635e9f5b@gmail.com>
Date:   Sat, 25 Sep 2021 19:39:34 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.1
Subject: Re: [PATCH net-next 3/5] net: bcmasp: Add support for ASP2.0 Ethernet
 controller
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>, Justin Chen <justinpopo6@gmail.com>
Cc:     netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Doug Berger <opendmb@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Michael Chan <michael.chan@broadcom.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK" 
        <linux-media@vger.kernel.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK" 
        <dri-devel@lists.freedesktop.org>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK" 
        <linaro-mm-sig@lists.linaro.org>
References: <1632519891-26510-1-git-send-email-justinpopo6@gmail.com>
 <1632519891-26510-4-git-send-email-justinpopo6@gmail.com>
 <YU9SHpn4ZJrjqNuF@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <YU9SHpn4ZJrjqNuF@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/25/2021 9:45 AM, Andrew Lunn wrote:
[snip]

>> +	priv->clk = devm_clk_get(dev, "sw_asp");
>> +	if (IS_ERR(priv->clk)) {
>> +		if (PTR_ERR(priv->clk) == -EPROBE_DEFER)
>> +			return -EPROBE_DEFER;
>> +		dev_warn(dev, "failed to request clock\n");
>> +		priv->clk = NULL;
>> +	}
> 
> devm_clk_get_optional() makes this simpler/

Indeed, thanks.

[snip]

>> +	ret = devm_request_irq(&pdev->dev, priv->irq, bcmasp_isr, 0,
>> +			       pdev->name, priv);
>> +	if (ret) {
>> +		dev_err(dev, "failed to request ASP interrupt: %d\n", ret);
>> +		return ret;
>> +	}
> 
> Do you need to undo clk_prepare_enable()?

Yes we do need to undo the preceding clk_prepare_enable(), thanks!

[snip]

>> +
>> +static int bcmasp_remove(struct platform_device *pdev)
>> +{
>> +	struct bcmasp_priv *priv = dev_get_drvdata(&pdev->dev);
>> +	struct bcmasp_intf *intf;
>> +	int i;
>> +
>> +	for (i = 0; i < priv->intf_count; i++) {
>> +		intf = priv->intfs[i];
>> +		if (!intf)
>> +			continue;
>> +
>> +		bcmasp_interface_destroy(intf, true);
>> +	}
>> +
>> +	return 0;
>> +}
> 
> Do you need to depopulate the mdio children?

I had not given much thought about it first but we ought to do something 
about it here, I will test it before Justin sends a v2.

> 
>> +static void bcmasp_get_drvinfo(struct net_device *dev,
>> +			       struct ethtool_drvinfo *info)
>> +{
>> +	strlcpy(info->driver, "bcmasp", sizeof(info->driver));
>> +	strlcpy(info->version, "v2.0", sizeof(info->version));
> 
> Please drop version. The core will fill it in with the kernel version,
> which is more useful.
> 
>> +static int bcmasp_nway_reset(struct net_device *dev)
>> +{
>> +	if (!dev->phydev)
>> +		return -ENODEV;
>> +
>> +	return genphy_restart_aneg(dev->phydev);
>> +}
> 
> phy_ethtool_nway_reset().

Yes, thanks!

> 
> 
>> +static void bcmasp_get_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
>> +{
>> +	struct bcmasp_intf *intf = netdev_priv(dev);
>> +
>> +	wol->supported = WAKE_MAGIC | WAKE_MAGICSECURE | WAKE_FILTER;
>> +	wol->wolopts = intf->wolopts;
>> +	memset(wol->sopass, 0, sizeof(wol->sopass));
>> +
>> +	if (wol->wolopts & WAKE_MAGICSECURE)
>> +		memcpy(wol->sopass, intf->sopass, sizeof(intf->sopass));
>> +}
> 
> Maybe consider calling into the PHY to see what it can do? If the PHY
> can do the WoL you want, it will do it with less power.

We could do that, especially since one of the ports will typically 
connect to an external Gigabit PHY, will add for v2.

> 
>> +static int bcmasp_set_priv_flags(struct net_device *dev, u32 flags)
>> +{
>> +	struct bcmasp_intf *intf = netdev_priv(dev);
>> +
>> +	intf->wol_keep_rx_en = flags & BCMASP_WOL_KEEP_RX_EN ? 1 : 0;
>> +
>> +	return 0;
> 
> Please could you explain this some more. How can you disable RX and
> still have WoL working?

Wake-on-LAN using Magic Packets and network filters requires keeping the 
UniMAC's receiver turned on, and then the packets feed into the Magic 
Packet Detector (MPD) block or the network filter block. In that mode 
DRAM is in self refresh and there is local matching of frames into a 
tiny FIFO however in the case of magic packets the packets leading to a 
wake-up are dropped as there is nowhere to store them. In the case of a 
network filter match (e.g.: matching a multicast IP address plus 
protocol, plus source/destination ports) the packets are also discarded 
because the receive DMA was shut down.

When the wol_keep_rx_en flag is set, the above happens but we also allow 
the packets that did match a network filter to reach the small FIFO 
(Justin would know how many entries are there) that is used to push the 
packets to DRAM. The packet contents are held in there until the system 
wakes up which is usually just a few hundreds of micro seconds after we 
received a packet that triggered a wake-up. Once we overflow the receive 
DMA FIFO capacity subsequent packets get dropped which is fine since we 
are usually talking about very low bit rates, and we only try to push to 
DRAM the packets of interest, that is those for which we have a network 
filter.

This is convenient in scenarios where you want to wake-up from multicast 
DNS (e.g.: wake on Googlecast, Bonjour etc.) because then the packet 
that resulted in the system wake-up is not discarded but is then 
delivered to the network stack.

> 
>> +static void bcmasp_adj_link(struct net_device *dev)
>> +{
>> +	struct bcmasp_intf *intf = netdev_priv(dev);
>> +	struct phy_device *phydev = dev->phydev;
>> +	int changed = 0;
>> +	u32 cmd_bits = 0, reg;
>> +
>> +	if (intf->old_link != phydev->link) {
>> +		changed = 1;
>> +		intf->old_link = phydev->link;
>> +	}
>> +
>> +	if (intf->old_duplex != phydev->duplex) {
>> +		changed = 1;
>> +		intf->old_duplex = phydev->duplex;
>> +	}
>> +
>> +	switch (phydev->speed) {
>> +	case SPEED_2500:
>> +		cmd_bits = UMC_CMD_SPEED_2500;
> 
> All i've seen is references to RGMII. Is 2500 possible?

It is not, this has been copied from the GENET driver which also does 
not support 2.5Gbits avec the external interface level, we should drop 
it there, too. Thanks!

> 
>> +		break;
>> +	case SPEED_1000:
>> +		cmd_bits = UMC_CMD_SPEED_1000;
>> +		break;
>> +	case SPEED_100:
>> +		cmd_bits = UMC_CMD_SPEED_100;
>> +		break;
>> +	case SPEED_10:
>> +		cmd_bits = UMC_CMD_SPEED_10;
>> +		break;
>> +	default:
>> +		break;
>> +	}
>> +	cmd_bits <<= UMC_CMD_SPEED_SHIFT;
>> +
>> +	if (phydev->duplex == DUPLEX_HALF)
>> +		cmd_bits |= UMC_CMD_HD_EN;
>> +
>> +	if (intf->old_pause != phydev->pause) {
>> +		changed = 1;
>> +		intf->old_pause = phydev->pause;
>> +	}
>> +
>> +	if (!phydev->pause)
>> +		cmd_bits |= UMC_CMD_RX_PAUSE_IGNORE | UMC_CMD_TX_PAUSE_IGNORE;
>> +
>> +	if (!changed)
>> +		return;
> 
> Shouldn't there be a comparison intd->old_speed != phydev->speed?  You
> are risking the PHY can change speed without doing a link down/up?

We can probably remove these comparisons nowadays since the PHY library 
no longer calls adjust_link whether or not something has changed, it 
does call when something changed.

> 
>> +
>> +	if (phydev->link) {
>> +		reg = umac_rl(intf, UMC_CMD);
>> +		reg &= ~((UMC_CMD_SPEED_MASK << UMC_CMD_SPEED_SHIFT) |
>> +			UMC_CMD_HD_EN | UMC_CMD_RX_PAUSE_IGNORE |
>> +			UMC_CMD_TX_PAUSE_IGNORE);
>> +		reg |= cmd_bits;
>> +		umac_wl(intf, reg, UMC_CMD);
>> +
>> +		/* Enable RGMII pad */
>> +		reg = rgmii_rl(intf, RGMII_OOB_CNTRL);
>> +		reg |= RGMII_MODE_EN;
>> +		rgmii_wl(intf, reg, RGMII_OOB_CNTRL);
>> +
>> +		intf->eee.eee_active = phy_init_eee(phydev, 0) >= 0;
>> +		bcmasp_eee_enable_set(intf, intf->eee.eee_active);
>> +	} else {
>> +		/* Disable RGMII pad */
>> +		reg = rgmii_rl(intf, RGMII_OOB_CNTRL);
>> +		reg &= ~RGMII_MODE_EN;
>> +		rgmii_wl(intf, reg, RGMII_OOB_CNTRL);
>> +	}
>> +
>> +	if (changed)
>> +		phy_print_status(phydev);
> 
> There has already been a return if !changed.

Yes indeed.

> 
>> +static void bcmasp_configure_port(struct bcmasp_intf *intf)
>> +{
>> +	u32 reg, id_mode_dis = 0;
>> +
>> +	reg = rgmii_rl(intf, RGMII_PORT_CNTRL);
>> +	reg &= ~RGMII_PORT_MODE_MASK;
>> +
>> +	switch (intf->phy_interface) {
>> +	case PHY_INTERFACE_MODE_RGMII:
>> +		/* RGMII_NO_ID: TXC transitions at the same time as TXD
>> +		 *		(requires PCB or receiver-side delay)
>> +		 * RGMII:	Add 2ns delay on TXC (90 degree shift)
>> +		 *
>> +		 * ID is implicitly disabled for 100Mbps (RG)MII operation.
>> +		 */
>> +		id_mode_dis = RGMII_ID_MODE_DIS;
>> +		fallthrough;
>> +	case PHY_INTERFACE_MODE_RGMII_TXID:
>> +		reg |= RGMII_PORT_MODE_EXT_GPHY;
>> +		break;
>> +	case PHY_INTERFACE_MODE_MII:
>> +		reg |= RGMII_PORT_MODE_EXT_EPHY;
>> +		break;
>> +	default:
>> +		break;
>> +	}
> 
> Can we skip this and let the PHY do the delays? Ah, "This is an ugly
> quirk..." Maybe add a comment here pointing towards
> bcmasp_netif_init(), which is explains this.

OK.

[snip]

>> +static inline void bcmasp_map_res(struct bcmasp_priv *priv,
>> +				  struct bcmasp_intf *intf)
>> +{
>> +	/* Per port */
>> +	intf->res.umac = priv->base + UMC_OFFSET(intf);
>> +	intf->res.umac2fb = priv->base + UMAC2FB_OFFSET(intf);
>> +	intf->res.rgmii = priv->base + RGMII_OFFSET(intf);
>> +
>> +	/* Per ch */
>> +	intf->tx_spb_dma = priv->base + TX_SPB_DMA_OFFSET(intf);
>> +	intf->res.tx_spb_ctrl = priv->base + TX_SPB_CTRL_OFFSET(intf);
>> +	/*
>> +	 * Stop gap solution. This should be removed when 72165a0 is
>> +	 * deprecated
>> +	 */
> 
> Is that an internal commit?

Yes this is a revision of the silicon that is not meant to see the light 
of day.
-- 
Florian
