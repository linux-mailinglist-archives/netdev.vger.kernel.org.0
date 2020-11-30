Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD4392C8721
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 15:52:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727713AbgK3OvZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 09:51:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbgK3OvY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 09:51:24 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CB92C0613D2;
        Mon, 30 Nov 2020 06:50:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=iq65UZZfrAuCR10kxOZUVTA7ZrBR2wwSWFK6vy3E44c=; b=opOJCoZXVuQa5iCMZit2QnkDz
        XZBVOz5+DkNurx/sxMuTxPx58AjCBt+UTAIobAYM4BrSLhl/uNO3YxCtrfOVlVSx+gt1CNqe+W47w
        h0CeDX+9qohK+BgYAZdTV3Btmu3XARWJs+fQw/owOJ+UZnyrICjyE7Pw2EOtQT6OAke+bVMXcXqv+
        n3PXV/dgldDuniX7tR7kAL5Y7b4dmp1SF1j4GKNk6U/2NTeHr9rzG9Az1RZBjoRu5+k1oZnZvFBTy
        BJTAFVAYVC07z03uOgJUD5tTQdAgQ2szjNPH2dxiDgNhSWHOhOp3ALViELHQ4S3++mTkkXeffthcx
        VP2Bq4mig==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:38022)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kjkVc-0006w3-9C; Mon, 30 Nov 2020 14:50:32 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kjkVb-00055o-2z; Mon, 30 Nov 2020 14:50:31 +0000
Date:   Mon, 30 Nov 2020 14:50:31 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microsemi List <microsemi@lists.bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/3] net: sparx5: Add Sparx5 switchdev driver
Message-ID: <20201130145030.GW1551@shell.armlinux.org.uk>
References: <20201127133307.2969817-1-steen.hegelund@microchip.com>
 <20201127133307.2969817-3-steen.hegelund@microchip.com>
 <20201128190616.GF2191767@lunn.ch>
 <20201128222828.GQ1551@shell.armlinux.org.uk>
 <20201129105245.GG1605@shell.armlinux.org.uk>
 <20201129113018.GI1605@shell.armlinux.org.uk>
 <20201130143023.csjyuhs6uke7dtu6@mchp-dev-shegelun>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201130143023.csjyuhs6uke7dtu6@mchp-dev-shegelun>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 30, 2020 at 03:30:23PM +0100, Steen Hegelund wrote:
> On 29.11.2020 11:30, Russell King - ARM Linux admin wrote:
> > EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> > 
> > On Sun, Nov 29, 2020 at 10:52:45AM +0000, Russell King - ARM Linux admin wrote:
> > > There are other issues too.
> > 
> > This is also wrong:
> > 
> > +               if (port->ndev && port->ndev->phydev)
> > +                       status->link = port->ndev->phydev->link;
> > 
> > phylink already deals with that situation.
> 
> So if I need the link state, what interface should I then use to get it?

The network carrier state reflects the link state. As I've said,
using the ethtool_op_get_link() is entirely suitable for the
ethtool .get_link method - other network drivers use this with
phylink and it works.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
