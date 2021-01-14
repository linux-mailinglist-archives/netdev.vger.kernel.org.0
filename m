Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5BB12F6406
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 16:19:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729222AbhANPOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 10:14:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726259AbhANPOR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 10:14:17 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DBC5C061574;
        Thu, 14 Jan 2021 07:13:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=baU0kpJtTWVnL2IPMNaB2SRlSi8la0eAKCzpp9qIWxw=; b=OfoBBeDPHsLncJBNT21TUU4Zx
        UX8oOxbsPFlBqyIypgyQTRdgrv1D9MtgAeqxazc8t+QGeSia47g+E+hAei9IU97TPNt8o1RABZTlZ
        h5GlG1X+UUdydRB8Vd1sDxH4cymdf58RmV0Bd7VL2+emfbYyOQsQNOxNxdR36Fe3W6gtJqhZa8AFj
        DiepzbuF5fNnI2O0XKB+nk76ofzr01InJiuLVEv90Az6rpt93xOouVAoveopCqOqTmO6eK93prmA6
        P/omSbKEkDfgALHlnFd59CQyZiSRjGY32FUlR5M0iHGgGubaIsiMhKIiA0NWy7TWF3NbJ5kfbmzsB
        2VY9qN3Zg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:47918)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1l04JZ-0002b1-LG; Thu, 14 Jan 2021 15:13:33 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1l04JY-0008Rg-Tu; Thu, 14 Jan 2021 15:13:32 +0000
Date:   Thu, 14 Jan 2021 15:13:32 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Bjarni Jonasson <bjarni.jonasson@microchip.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        UNGLinuxDriver <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next v2 1/2] net: phy: Add 100 base-x mode
Message-ID: <20210114151332.GT1551@shell.armlinux.org.uk>
References: <20210113115626.17381-1-bjarni.jonasson@microchip.com>
 <20210113115626.17381-2-bjarni.jonasson@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210113115626.17381-2-bjarni.jonasson@microchip.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 12:56:25PM +0100, Bjarni Jonasson wrote:
> Sparx-5 supports this mode and it is missing in the PHY core.
> 
> Signed-off-by: Bjarni Jonasson <bjarni.jonasson@microchip.com>

Reviewed-by: Russell King <rmk+kernel@armlinux.org.uk>
-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
