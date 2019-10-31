Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 442E1EADA0
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 11:39:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbfJaKjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 06:39:00 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:47206 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726867AbfJaKjA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 06:39:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=OGJYmZgLEG5Sj7D/8lJ6rdehlwNL4EkUmv4fJlwMvsA=; b=z2/khclncikcsfxm6mqabbA7f
        hPa+/3HjoPs7TCN48BCD39DIQr5lcUSNy5TUCxOYiLHvx5dHSQV4RdN+2Q3EeYyJrWSr8lOqTSjfN
        aLdh2o5TsoCg8ZkQdEwBcQTsyICk2tCngGRAitW9LXEMC0CFMybo8ODPkjNPNpMJT0jZEPT7jGdiF
        Dzacrm+pS6eTe2QOBpn132NY1Py6yQBnXHBUmBFDCTGo3M1mkIAYtmxNSGr9h3gBMKpvWp309qxXx
        QPPTcvQpi0Uva4Cf+DMaZCttS6w9QzEDwRKCe8nASSlcX2bfx4WIjhfqDPeLGRzOXZsE3js2I2M+f
        ALGM2w8QQ==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:57324)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iQ7qp-0005z9-Ci; Thu, 31 Oct 2019 10:38:47 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iQ7qj-0006U9-8M; Thu, 31 Oct 2019 10:38:41 +0000
Date:   Thu, 31 Oct 2019 10:38:41 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     Priit Laes <plaes@plaes.org>,
        "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>,
        "wens@csie.org" <wens@csie.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>
Subject: Re: sun7i-dwmac: link detection failure with 1000Mbit parters
Message-ID: <20191031103841.GI25745@shell.armlinux.org.uk>
References: <20191030202117.GA29022@plaes.org>
 <BN8PR12MB32660687285D2C76E7CF2FF6D3630@BN8PR12MB3266.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN8PR12MB32660687285D2C76E7CF2FF6D3630@BN8PR12MB3266.namprd12.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 31, 2019 at 08:39:06AM +0000, Jose Abreu wrote:
> ++ Florian, Andrew, Heiner, Russell
> 
> Can you please attach your dmesg log ? PHYLINK provides some useful 
> debug logs.
> 
> From: Priit Laes <plaes@plaes.org>
> Date: Oct/30/2019, 20:21:17 (UTC+00:00)
> 
> > Heya!
> > 
> > I have noticed that with sun7i-dwmac driver (OLinuxino Lime2 eMMC), link
> > detection fails consistently with certain 1000Mbit partners (for example Huawei
> > B525s-23a 4g modem ethernet outputs and RTL8153-based USB3.0 ethernet dongle),
> > but the same hardware works properly with certain other link partners (100Mbit GL AR150
> > for example).
> > 
> > (Just need to test with another 1000Mbit switch at the office).
> > 
> > I first thought it could be a regression, but I went from current master to as far back
> > as 5.2.0-rc6 where it was still broken.

The stmmac conversion to phylink was v5.3-rc1, so that's likely not the
issue if v5.2-rc6 also exhibits this behaviour.

My guess is that the problem lies in phylib, especially as the link LEDs
go off when the link is configured.  I notice that it's using the
generic PHY driver rather than a specific driver.

  mii-diag -v eth0

would be useful to see for the case where the link has failed, without
replugging the ethernet cable.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
