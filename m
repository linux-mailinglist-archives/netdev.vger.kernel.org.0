Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBAA66C95BC
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 16:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbjCZOoW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 10:44:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbjCZOoV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 10:44:21 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 593274232
        for <netdev@vger.kernel.org>; Sun, 26 Mar 2023 07:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=GEKZ+3rq0t0f02Ahyux8VIMBF2mer1/c3GBafURphD4=; b=a8kS+s6RHF3UrSjnKad7pcg0jc
        Nm6aPpycUaJetoPexZ16H6EZuvv3D3TrfDXaHVrFHp8idJw63j8WHECxFdncxLX+exiAR1zXnY/zL
        I+v/7u95zPkk7PVJYo7kASU341J96BGWzYdEFeHe8gbg7+QFTZZNu6tro8Qp/d07Udh9RXSOVboBQ
        l88U4GShVDF001zBle1rytAq4tl0l2aV4d54KW3pmiVCjlhQhMJi+xi1nHbxkL6LJKwpoqkfRyVXy
        NnRSCRd039ttBYb1xDHlIM+NILYvtQKtg7E8F4LU3stjaCSCdTMAJ1BivCPCXtARMCQ2usdAKnEgB
        hjY0bDyA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46666)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pgRbL-00027f-Ea; Sun, 26 Mar 2023 15:44:07 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pgRbF-0004Y4-4y; Sun, 26 Mar 2023 15:44:01 +0100
Date:   Sun, 26 Mar 2023 15:44:01 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     Daniel Golle <daniel@makrotopia.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: Re: [PATCH net-next 2/2] net: sfp: add quirk for 2.5G copper SFP
Message-ID: <ZCBaMSvmNUPNBH6y@shell.armlinux.org.uk>
References: <ZBniMlTDZJQ242DP@shell.armlinux.org.uk>
 <E1pefJz-00Dn4V-Oc@rmk-PC.armlinux.org.uk>
 <ZB5YgPiZYwbf/G2u@makrotopia.org>
 <ZB7/v8oUu3lkO4yC@shell.armlinux.org.uk>
 <ZB8Upcgv8EIovPCl@makrotopia.org>
 <ZB9NKo3iXe7CZSId@shell.armlinux.org.uk>
 <trinity-d65e8e0e-6837-49d9-b5e2-1e1d68c289d3-1679830571282@3c-app-gmx-bap45>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <trinity-d65e8e0e-6837-49d9-b5e2-1e1d68c289d3-1679830571282@3c-app-gmx-bap45>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 26, 2023 at 01:36:11PM +0200, Frank Wunderlich wrote:
> i tried this patch too to get more information about the phy of my sfp (i use gmac1 instead of the mt7531 port5), but see nothing new
> 
> root@bpi-r3:~# dmesg | grep 'sfp\|phy'
> [    0.000000] Booting Linux on physical CPU 0x0000000000 [0x410fd034]
> [    0.000000] arch_timer: cp15 timer(s) running at 13.00MHz (phys).
> [    1.654975] sfp sfp-1: Host maximum power 1.0W
> [    1.659976] sfp sfp-2: Host maximum power 1.0W
> [    2.001284] sfp sfp-1: module OEM              SFP-2.5G-T       rev 1.0  sn SK2301110008     dc 230110  
> [    2.010789] mtk_soc_eth 15100000.ethernet eth1: optical SFP: interfaces=[mac=2-4,21-22, sfp=22]
> [    3.261039] mt7530 mdio-bus:1f: phylink_mac_config: mode=fixed/2500base-x/2.5Gbps/Full/none adv=00,00000000,00008000,00006200 pause=03 link=0 an=1
> [    3.293176] mt7530 mdio-bus:1f wan (uninitialized): phy: gmii setting supported 00,00000000,00000000,000062ef advertising 00,00000000,00000000,000062ef
> [    3.326808] mt7530 mdio-bus:1f lan0 (uninitialized): phy: gmii setting supported 00,00000000,00000000,000062ef advertising 00,00000000,00000000,000062ef
> [    3.360144] mt7530 mdio-bus:1f lan1 (uninitialized): phy: gmii setting supported 00,00000000,00000000,000062ef advertising 00,00000000,00000000,000062ef
> [    3.393490] mt7530 mdio-bus:1f lan2 (uninitialized): phy: gmii setting supported 00,00000000,00000000,000062ef advertising 00,00000000,00000000,000062ef
> [    3.426819] mt7530 mdio-bus:1f lan3 (uninitialized): phy: gmii setting supported 00,00000000,00000000,000062ef advertising 00,00000000,00000000,000062ef
> [   15.156727] mtk_soc_eth 15100000.ethernet eth0: phylink_mac_config: mode=fixed/2500base-x/2.5Gbps/Full/none adv=00,00000000,00008000,00006240 pause=03 link=0 an=1
> [   15.178021] mt7530 mdio-bus:1f lan3: configuring for phy/gmii link mode
> [   15.192190] mt7530 mdio-bus:1f lan3: phylink_mac_config: mode=phy/gmii/Unknown/Unknown/none adv=00,00000000,00000000,00000000 pause=00 link=0 an=0
> [   15.208137] mt7530 mdio-bus:1f lan3: phy link down gmii/Unknown/Unknown/none/off
> [   15.216371] mt7530 mdio-bus:1f lan2: configuring for phy/gmii link mode
> [   15.228163] mt7530 mdio-bus:1f lan2: phylink_mac_config: mode=phy/gmii/Unknown/Unknown/none adv=00,00000000,00000000,00000000 pause=00 link=0 an=0
> [   15.242579] mt7530 mdio-bus:1f lan1: configuring for phy/gmii link mode
> [   15.245731] mt7530 mdio-bus:1f lan2: phy link down gmii/Unknown/Unknown/none/off
> [   15.261771] mt7530 mdio-bus:1f lan1: phylink_mac_config: mode=phy/gmii/Unknown/Unknown/none adv=00,00000000,00000000,00000000 pause=00 link=0 an=0
> [   15.277381] mt7530 mdio-bus:1f lan0: configuring for phy/gmii link mode
> [   15.278665] mt7530 mdio-bus:1f lan1: phy link down gmii/Unknown/Unknown/none/off
> [   15.296641] mt7530 mdio-bus:1f lan0: phylink_mac_config: mode=phy/gmii/Unknown/Unknown/none adv=00,00000000,00000000,00000000 pause=00 link=0 an=0
> [   15.312570] mt7530 mdio-bus:1f lan0: phy link down gmii/Unknown/Unknown/none/off
> [   15.392799] mt7530 mdio-bus:1f wan: configuring for phy/gmii link mode
> [   15.404425] mt7530 mdio-bus:1f wan: phylink_mac_config: mode=phy/gmii/Unknown/Unknown/none adv=00,00000000,00000000,00000000 pause=00 link=0 an=0
> [   15.420491] mt7530 mdio-bus:1f wan: phy link up gmii/1Gbps/Full/none/rx/tx
> [  262.106630] mtk_soc_eth 15100000.ethernet eth1: phylink_mac_config: mode=inband/2500base-x/Unknown/Unknown/none adv=00,00000000,00008000,00006400 pause=00 link=0 an=0

Yours isn't detecting a PHY, and this this patch will have no effect
as the patch only changes things in a path that is used when a PHY
is detected.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
