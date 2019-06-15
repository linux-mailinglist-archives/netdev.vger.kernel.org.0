Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA6F47258
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 00:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbfFOWNl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 18:13:41 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:59734 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbfFOWNl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 18:13:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=vxkjm2BCE1Ly7O/qwqmFJEdvuCrQrJAXD+4SCcSm1cY=; b=EMxNY1rmVoCM+z+9dwZt9jOFF
        2iGbLEp/yvtnNoVhC6ndJk2lUzqicPQRfbrGwkrHuxbgVdTDpsorrgQB/12yYhNR6q0ESmKjH2ibb
        M3X4oK6t4m3W/p0/hpi2/2mudrQvMRaNDzFhLaRcczu7Rki5U7LIGz++zIt1JfaPniv/eSmDvwu3r
        4+RPWcXQqNdGt5vGwdHclvo4xd7wyat5HT6aKJ3FB76zGCZIloA5jqSVQq4VwbmGKHh8PjZ3NV9q9
        CqFD6hAkS3RklrTzW31MTlP1sA8LICmJP8+A6CiOMehBgI6RgytcZTr4xpoooSuEWLjtxhAzFYNcq
        /jdbtyNxw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:53068)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hcGvT-0001tD-Ps; Sat, 15 Jun 2019 23:13:35 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hcGvR-0003RT-1J; Sat, 15 Jun 2019 23:13:29 +0100
Date:   Sat, 15 Jun 2019 23:13:28 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     David Miller <davem@davemloft.net>
Cc:     ioana.ciornei@nxp.com, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH] net: phylink: set the autoneg state in phylink_phy_change
Message-ID: <20190615221328.4diebpopfzyfi4og@shell.armlinux.org.uk>
References: <1560407871-5642-1-git-send-email-ioana.ciornei@nxp.com>
 <20190615.133021.572699563162351841.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190615.133021.572699563162351841.davem@davemloft.net>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 15, 2019 at 01:30:21PM -0700, David Miller wrote:
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> Date: Thu, 13 Jun 2019 09:37:51 +0300
> 
> > The phy_state field of phylink should carry only valid information
> > especially when this can be passed to the .mac_config callback.
> > Update the an_enabled field with the autoneg state in the
> > phylink_phy_change function.
> > 
> > Fixes: 9525ae83959b ("phylink: add phylink infrastructure")
> > Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> 
> Applied and queued up for -stable, thanks.

This is not a fix; it is an attempt to make phylink work differently
from how it's been designed for the dpaa2 driver.  I've already stated
that this field is completely meaningless, so I'm surprised you
applied it.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
