Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9ED24986AA
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 18:26:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244545AbiAXR0i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 12:26:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244304AbiAXR0g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 12:26:36 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4314CC061401;
        Mon, 24 Jan 2022 09:26:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=YalnhBnkU6wZ0N4VJgHQSOBIP0tBgxl1/ZtUR64V9oA=; b=fOFHPIrYVgBUmRQ1wEyMQVl1Oj
        J17+8bX+a2m4lyf00SWK0SbxEgp4DFByKGkICOOLjjK5UDLiqO0o5EVQO60/0NmnRCNDgSCJTRL2+
        XlcIantWF1sVzawTxf32wDMyo3ml8qMUfx464lpZ/WeCAVULy2M6DtMrb333/zQzYrzEJeJlrBH6J
        2t5dPHHaevgk7AsspzzLGYVLLoqF4ORiPBfhHCZ/hQFbo110/Rxr3gTd9zg/l621X8XcZ8++f1KH+
        TL6vTH/S0VvymwuILV4s/TRFyIzUyYPzKtW4H7+VwBdgNnM87UoKIhFI4sC9TtHoSQ23YH4dDregg
        qVLdckRA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56842)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nC36d-0000eK-0B; Mon, 24 Jan 2022 17:26:15 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nC36X-0001nW-Kl; Mon, 24 Jan 2022 17:26:09 +0000
Date:   Mon, 24 Jan 2022 17:26:09 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        John Crispin <john@phrozen.org>,
        Siddhant Gupta <siddhantgupta416@gmail.com>,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>, linux-mips@vger.kernel.org,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, openwrt-devel@lists.openwrt.org,
        erkin.bozoglu@xeront.com
Subject: Re: MT7621 SoC Traffic Won't Flow on RGMII2 Bus/2nd GMAC
Message-ID: <Ye7hMWRR4URUnSFp@shell.armlinux.org.uk>
References: <83a35aa3-6cb8-2bc4-2ff4-64278bbcd8c8@arinc9.com>
 <CALW65jZ4N_YRJd8F-uaETWm1Hs3rNcy95csf++rz7vTk8G8oOg@mail.gmail.com>
 <02ecce91-7aad-4392-c9d7-f45ca1b31e0b@arinc9.com>
 <Ye1zwIFUa5LPQbQm@lunn.ch>
 <acf98ec3-1120-bcc0-2a2f-85d97c48febd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <acf98ec3-1120-bcc0-2a2f-85d97c48febd@gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 24, 2022 at 09:13:38AM -0800, Florian Fainelli wrote:
> On 1/23/2022 7:26 AM, Andrew Lunn wrote:
> > On Sun, Jan 23, 2022 at 11:33:04AM +0300, Arınç ÜNAL wrote:
> > > Hey Deng,
> > > 
> > > On 23/01/2022 09:51, DENG Qingfang wrote:
> > > > Hi,
> > > > 
> > > > Do you set the ethernet pinmux correctly?
> > > > 
> > > > &ethernet {
> > > >       pinctrl-names = "default";
> > > >       pinctrl-0 = <&rgmii1_pins &rgmii2_pins &mdio_pins>;
> > > > };
> > > 
> > > This fixed it! We did have &rgmii2_pins on the gmac1 node (it was originally
> > > on external_phy) so we never thought to investigate the pinctrl
> > > configuration further! Turns out &rgmii2_pins needs to be defined on the
> > > ethernet node instead.
> > 
> > PHYs are generally external, so pinmux on them makes no sense. PHYs in
> > DT are not devices in the usual sense, so i don't think the driver
> > core will handle pinmux for them, even if you did list them.
> 
> Not sure I understand your comment here, this is configuring the pinmux on
> the SoC side in order for the second RGMII interface's data path to work.

The pinmux configuration was listed under the external PHY node, which
is qutie unusual. In the case of phylib and external ethernet PHYs,
this can be a problem.

The pinmux configuration is normally handled at device probe time by
the device model, but remember phylib bypasses that when it attaches
the generic PHY driver - meaning you don't get the pinmux configured.

What this means is that pinmux configuration in ethernet PHY nodes is
unreliable. It will only happen if we have a specific driver for the
PHY and the driver model binds that driver.

Of course, if we killed the generic driver, that would get around this
issue by requiring every PHY to have its own specific driver, but there
would be many complaints because likely lots would stop working.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
