Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 967B316884F
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 21:25:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgBUUZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 15:25:13 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:54012 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726483AbgBUUZM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 15:25:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=L2/1vYGfe6y5FLnFY/U5MY2rdK0QdNmDD6XBbPhBS4Y=; b=CDgZgVo2MY5y4tGB2J1mz/sF8
        3agZYLrkJYUg2/6firMi+rOhWkBhgWIO09dpwOVOv9x/UoIZIVqhcTAkuzCyBnxutmT/58wuyQ2Ln
        dyDYjXvj2VrwgPkWoSMRkCjIUa1xH+YqHXLzi9WYVFqOICwrXUBQU3PipoFdoiSaERFNwQnZNpFNl
        h9y9qTlGSgBHtXc+hRRJk+lsmkjStRwlX7Y6ZjKTSN9EN6UT2DEifhzVCUwMOZ7yhDvoN+vHrKsXA
        YxfKvBCuSWZT+1HHZsZ5wnOm1VAWk853cAuim07zYIHrXZ/W7ko2bk88FhpQDbyn7rISWqYmJ1uFh
        YHtRh/iow==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:43454)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j5Er9-0003cV-43; Fri, 21 Feb 2020 20:25:03 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j5Er6-0003mW-KJ; Fri, 21 Feb 2020 20:25:00 +0000
Date:   Fri, 21 Feb 2020 20:25:00 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: Re: [CFT 6/8] net: macb: use resolved link config in mac_link_up()
Message-ID: <20200221202500.GL25745@shell.armlinux.org.uk>
References: <20200217172242.GZ25745@shell.armlinux.org.uk>
 <E1j3k85-00072l-RK@rmk-PC.armlinux.org.uk>
 <20200219143036.GB3390@piout.net>
 <20200220101828.GV25745@shell.armlinux.org.uk>
 <20200220123853.GH3281@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200220123853.GH3281@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 20, 2020 at 01:38:53PM +0100, Andrew Lunn wrote:
> > Thanks, that looks reasonable to me. I'll replace my patch with this
> > one if it's appropriate for net-next when I send this series for
> > merging.  However, I see most affected network driver maintainers
> > haven't responded yet, which is rather disappointing.  So, thanks
> > for taking the time to look at this.
> 
> Hi Russell
> 
> I suspect most maintainers are lazy. Give them a branch to pull, and
> they might be more likely to test.

git://git.armlinux.org.uk/~rmk/linux-net-next.git

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
