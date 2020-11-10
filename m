Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8551B2AD3AC
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 11:26:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727654AbgKJK0E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 05:26:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726779AbgKJK0D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 05:26:03 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4C05C0613CF;
        Tue, 10 Nov 2020 02:26:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=nCQVGn4tgfLDgNzQCS32tBXcK/X7ubEDqdXouPvVcJQ=; b=SfZRnN4p1ttAS8Ghlm9p0xu6h
        vOansbt/QrOwwa2epSnjVphHCTBz2m2ii+gO4lHwL8icwhH8RjS2rEtcNSjLgsFj1hLwoj9O9EcoN
        E4Q1bU4G26fSx6Qaz//mMWSeP8wwsy32S4ixki0ubfQHm54pu86DKaCL+DqMAglMlv0wcz5U/Incd
        2Q9HvuJjz5Paka+4JIQTK2277apFwyUkPbIbeCkq1ZaGCBeuDuN9RuHJhgxjZJpdPiZEQX462Hwbs
        zzK6AJunlQEl4KpNFWY8Iy2mslIfXXwwrcEmNp0B9J4EXL9lyKMzG4Qx5PBhcIp3heKSjbyzHpkuj
        E60Hv1iMw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57904)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kcQqY-0000uh-SW; Tue, 10 Nov 2020 10:25:54 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kcQqX-0001ND-70; Tue, 10 Nov 2020 10:25:53 +0000
Date:   Tue, 10 Nov 2020 10:25:53 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Bjarni Jonasson <bjarni.jonasson@microchip.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        UNGLinuxDriver <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH] phy: phylink: Fix CuSFP issue in phylink
Message-ID: <20201110102552.GZ1551@shell.armlinux.org.uk>
References: <20201110100642.2153-1-bjarni.jonasson@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201110100642.2153-1-bjarni.jonasson@microchip.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 10, 2020 at 11:06:42AM +0100, Bjarni Jonasson wrote:
> There is an issue with the current phylink driver and CuSFPs which
> results in a callback to the phylink validate function without any
> advertisement capabilities.  The workaround (in this changeset)
> is to assign capabilities if a 1000baseT SFP is identified.

How does this happen?  Which PHY is being used?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
