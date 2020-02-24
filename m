Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5842716A6B9
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 14:01:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727464AbgBXNBc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 08:01:32 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:40298 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727357AbgBXNBc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 08:01:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=h+3s0EUrRBksVeRKHsOpEHk0OsUdcbcFmyIf7lBNhVM=; b=wJkVsMngh1Jrz8dcG8Lqs1NAm
        /VgObCegzrsxkD+qitQkA9efPrHot0fZMcl+SbxFIQCYrKYjfTZR5Rn0gma7y1DsWYMavDHPelqXw
        l6tuoIA+Q8/DOvT+bsQQQpz19Zs+hzStgeVtCRiXVtLnwp0M/miaSTGjvBUz2RRzd/KZBeZKBRP1V
        Av9KqPUdPSrdnlKkwIDVqxVXIawhdQMysiYhBTeQnH14fbWTo2YrPA5BmAFhhlTCZH/PeX+2y7I7Z
        hMLHuEEjCYTo08znh2zuNqKYPU8Ya9a9Z2z//D58cSlwZi3X4UwQSRZt0+A2qXVsp91McEXSc2SPI
        9KyNV9iQQ==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:44630)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j6DMQ-0002pF-KV; Mon, 24 Feb 2020 13:01:22 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j6DMM-0006Rj-PS; Mon, 24 Feb 2020 13:01:18 +0000
Date:   Mon, 24 Feb 2020 13:01:18 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [CFT 4/8] net: axienet: use resolved link config in mac_link_up()
Message-ID: <20200224130118.GR25745@shell.armlinux.org.uk>
References: <20200217172242.GZ25745@shell.armlinux.org.uk>
 <E1j3k7t-00072J-RS@rmk-PC.armlinux.org.uk>
 <20200224122421.616c8271@donnerap.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200224122421.616c8271@donnerap.cambridge.arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 24, 2020 at 12:24:21PM +0000, Andre Przywara wrote:
> On Mon, 17 Feb 2020 17:24:09 +0000
> Russell King <rmk+kernel@armlinux.org.uk> wrote:
> 
> Hi Russell,
> 
> > Convert the Xilinx AXI ethernet driver to use the finalised link
> > parameters in mac_link_up() rather than the parameters in mac_config().
> 
> Many thanks for this series, a quite neat solution for the problems I saw!
> 
> I picked 1/8 and 4/8 on top of net-next/master as of today: c3e042f54107376 ("igmp: remove unused macro IGMP_Vx_UNSOLICITED_REPORT_INTERVAL") and it worked great on my FPGA board using SGMII (but no in-band negotiation over that link). I had the 64-bit DMA patches on top, but that doesn't affect this series.
> 
> Tested-by: Andre Przywara <andre.przywara@arm.com>

Great, thanks for testing!

> Is this heading for 5.7?

Yes, that is my hope.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
