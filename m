Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36CB24A70FF
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 13:47:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344197AbiBBMqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 07:46:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232457AbiBBMqY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 07:46:24 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC154C061714;
        Wed,  2 Feb 2022 04:46:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=CJoixGrdUfzo89tGyrCYH8LDrTl3PpFUUUVFOmxRJs8=; b=xrwx6V9NbV324ljCKU+U0MjR0n
        OWjSfqypUeNWKD3Dl8bovQbkdpvN/TKXdm/L/mstHB5lXPRcRAUUSTIxDjO/qh1gV/zX/GD2EUaYG
        ZLZfT2LvOyiOmnxn4OYCXiRdXmoopfvYOFlpHi5fjgc7eubRpVKe8jFWH4iLFmkdlm+uXBQ0qlSIy
        BC0wlSmPAPf0FfVX4Zf4ZSUk+E53hXLaSTUyUK+hglZm2bLv963O40odoLIMkQ6VS3MuL6UeLyiY9
        x0V2lMz35bR3pp2T4oRm+Pp2PUgfshnC9MIjpXuizXUD7QSPGA3jdZejD7Lg2P0yonynw/Bu7Q3Gp
        V0VYgZTQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56998)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nFF1i-0001Zw-Dp; Wed, 02 Feb 2022 12:46:22 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nFF1h-00033R-2A; Wed, 02 Feb 2022 12:46:21 +0000
Date:   Wed, 2 Feb 2022 12:46:21 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, davem@davemloft.net, kuba@kernel.org
Subject: Re: [PATCH net-next] net: lan966x: use .mac_select_pcs() interface
Message-ID: <Yfp9HfKhqYb9o95G@shell.armlinux.org.uk>
References: <20220202114949.833075-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20220202114949.833075-1-horatiu.vultur@microchip.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 02, 2022 at 12:49:49PM +0100, Horatiu Vultur wrote:
> Convert lan966x to use the mac_select_interface instead of
> phylink_set_pcs.
>=20
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>

Thanks!

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

--=20
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
