Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13D582E812
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 00:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbfE2WWy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 18:22:54 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:33416 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbfE2WWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 18:22:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=HZkZ1cVnPcLkzNiYWfGbX5mM4gVR63gOWkL3a1rEw80=; b=nhU4GOJkfKUw2BbqWI3j1XwIe
        cVGOpllW95KSUFw4/TTJwD2mtQ5q8aoMeA/n60btu26z4RK1x9gC4pP0+jVTr8JAH0raI21/pKlh8
        TpQT7LF91jagxwKRnP0mpp5lx0giCal7HyCN2flC4sgOrJaYXojqc1VCmhFBaCGyc+B77gbPxS9mD
        QODMbeyiM2JelaD2ZBVKPu8ilr2HBsTN+oHkycs5qqEI0euKn2gByg8wtbSuhSvkKHRWjjF5mT+ez
        FulV7wX+utOER7AE7XClauGs6a2khHwUJiCtsJuzfdhcxzOs9U/5XWERjVa7BmSnXWzWj31gV0tfe
        WM1bMm8Fw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52706)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hW6y7-0007OR-Rg; Wed, 29 May 2019 23:22:47 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hW6y4-0004ql-Bv; Wed, 29 May 2019 23:22:44 +0100
Date:   Wed, 29 May 2019 23:22:44 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     David Miller <davem@davemloft.net>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        maxime.chevallier@bootlin.com, netdev@vger.kernel.org
Subject: Re: [PATCH] net: phy: marvell10g: report if the PHY fails to boot
 firmware
Message-ID: <20190529222244.v43rsotxzjspxe4h@shell.armlinux.org.uk>
References: <E1hVYVG-0005D8-8w@rmk-PC.armlinux.org.uk>
 <20190529.142634.185656643572931597.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190529.142634.185656643572931597.davem@davemloft.net>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 29, 2019 at 02:26:34PM -0700, David Miller wrote:
> From: Russell King <rmk+kernel@armlinux.org.uk>
> Date: Tue, 28 May 2019 10:34:42 +0100
> 
> > Some boards do not have the PHY firmware programmed in the 3310's flash,
> > which leads to the PHY not working as expected.  Warn the user when the
> > PHY fails to boot the firmware and refuse to initialise.
> > 
> > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> 
> Applied and queued up for -stable, thanks.
> 
> Longer term in net-next we can do the PHY_HALTED thing so that the PHY
> is accessible to update/fix the broken firmware.

Thanks David.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
