Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9ED4A4930
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 15:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbiAaOTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 09:19:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbiAaOTY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 09:19:24 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DA2FC061714;
        Mon, 31 Jan 2022 06:19:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=a4B0eVZglBvLjhpb8rwc4GlEmI1TVbpYnqFWjhEU7DU=; b=Wg9cEvqdm7D4eyymW981I3b1j1
        vwqm/jIdYTi7e/TCblwzueRXDosurN8PXNc9GHNYNq5+PCbpv07OPFUHaS19LcunOYFKdIDLPpfwX
        C1tQxmFemnMQCpcnPv+jpBWzrJyvsOGCxdO9P0cMxHjMWW8faOxt8UYdOw/BqqWrw9OXk13wy2miU
        yRyU7FV1grmUa6zzv1Rmv0e+ZbkW3o5zw/esZlynI9yLmNl/K2rnwVxlYDn1T9TJScnTHfVDMmwoT
        jO0DWAxcwdjUQho64wFgjdgaEG5IiCq7ZI/2CulFOy/nbl8rUeYtxzlouz9LFlSTwr8FQf9tiFJGz
        uQ4VN94Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56946)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nEXWU-0008Cu-B1; Mon, 31 Jan 2022 14:19:14 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nEXWS-0001BE-G7; Mon, 31 Jan 2022 14:19:12 +0000
Date:   Mon, 31 Jan 2022 14:19:12 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Jonathan McDowell <noodles@earth.li>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Luo Jie <luoj@codeaurora.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Robert Marko <robimarko@gmail.com>
Subject: Re: [PATCH net v2] net: phy: Fix qca8081 with speeds lower than
 2.5Gb/s
Message-ID: <Yffv4IVWc0hKcrsX@shell.armlinux.org.uk>
References: <YfZnmMteVry/A1XR@earth.li>
 <YffqmcR4iC3xKaRm@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YffqmcR4iC3xKaRm@earth.li>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 31, 2022 at 01:56:41PM +0000, Jonathan McDowell wrote:
> A typo in qca808x_read_status means we try to set SMII mode on the port
> rather than SGMII when the link speed is not 2.5Gb/s. This results in no
> traffic due to the mismatch in configuration between the phy and the
> mac.
> 
> v2:
>  Only change interface mode when the link is up
> 
> Fixes: 79c7bc0521545 ("net: phy: add qca8081 read_status")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jonathan McDowell <noodles@earth.li>

Thanks!

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
