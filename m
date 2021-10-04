Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 365A9420A87
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 14:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233075AbhJDMCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 08:02:43 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47320 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229778AbhJDMCm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 08:02:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=v9QT16+4O6MS/9X0bKpNA5WPvS8hLUk/+Zj7x4x/UrQ=; b=dS2TV4l0IjXiFHMG0RtEA+tH+3
        7eCGBG8uV+yWo70d0AchceRKrD3GMQiUAxeHzkAwyyl/HsIaSFN1fpAD/f+QktqBEl0XjKF/FyCYp
        0laFb2n/jH+45w7ktwTmSBi/vcTIjkbR8ax1gZcJZ3kwuTkzcs2u14RyZzJyqBMrsYS4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mXMeK-009X7x-H9; Mon, 04 Oct 2021 14:00:52 +0200
Date:   Mon, 4 Oct 2021 14:00:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH RFT v2 net-next] net: mdio: ensure the type of mdio
 devices match mdio drivers
Message-ID: <YVrs9PXicszhOfDB@lunn.ch>
References: <E1mWFLN-000fYQ-Cl@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1mWFLN-000fYQ-Cl@rmk-PC.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 01, 2021 at 11:00:41AM +0100, Russell King (Oracle) wrote:
> On the MDIO bus, we have PHYLIB devices and drivers, and we have non-
> PHYLIB devices and drivers. PHYLIB devices are MDIO devices that are
> wrapped with a struct phy_device.
> 
> Trying to bind a MDIO device with a PHYLIB driver results in out-of-
> bounds accesses as we attempt to access struct phy_device members. So,
> let's prevent this by ensuring that the type of the MDIO device
> (indicated by the MDIO_DEVICE_FLAG_PHY flag) matches the type of the
> MDIO driver (indicated by the MDIO_DEVICE_IS_PHY flag.)
> 
> Link: https://lore.kernel.org/r/2b1dc053-8c9a-e3e4-b450-eecdfca3fe16@gmail.com
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Tested-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
