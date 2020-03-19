Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E96C18BDD5
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 18:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728268AbgCSRUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 13:20:19 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:47528 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727009AbgCSRUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 13:20:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=wXL1IoWcgbMNHgU3/+g8Lnw7mX1eZhaBPLA/GLJFrVc=; b=L/NYMIogGBuWTqrrBV6LHLz5x
        c4Br0p/PZ7nM3lZI7Gnm7xWRmPdRPzs39TzuxIe5ANE6TpAkP62hKzVokurFi6Z2CTG6b0NVbL1Wj
        vmkvcIg6V1BhfWARGyP36wVIUXc6We1bnkfgwvphR1HvgPegca+N8G9C+yFfvVeLTGFAH/iBUwby0
        2I+tr3/IQiZlWSJopfA/RiIMEe5OnuUCSMZ8Bz2A7qCqC+W8ssvoyv+YeIERzYazESW7ku6twBpNG
        aWU8EDBpS8xGdqQt2xDnOyNO785yStKSIVqo+JacncgmJnfQzCTOf1gkuoJJp9nEUo9KCdwWlSnUP
        KL+KaT7CQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:38628)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jEyq5-0003TF-Fb; Thu, 19 Mar 2020 17:20:13 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jEyq4-0004wz-Kp; Thu, 19 Mar 2020 17:20:12 +0000
Date:   Thu, 19 Mar 2020 17:20:12 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [RFC net-next 2/5] net: phylink: add separate pcs operations
 structure
Message-ID: <20200319172012.GG25745@shell.armlinux.org.uk>
References: <20200317144944.GP25745@shell.armlinux.org.uk>
 <E1jEDaN-0008JH-MY@rmk-PC.armlinux.org.uk>
 <20200317163802.GZ24270@lunn.ch>
 <20200317165422.GU25745@shell.armlinux.org.uk>
 <20200319121418.GJ5827@shell.armlinux.org.uk>
 <20200319150652.GA27807@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200319150652.GA27807@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 19, 2020 at 04:06:52PM +0100, Andrew Lunn wrote:
> Hi Russell
> 
> The 6390X family of switches has two PCSs, one for 1000BaseX/SGMII and
> a second one for 10GBaseR. So at some point there is going to be a
> mux, but maybe it will be internal to mv88e6xxx and not shareable. Or
> internal to DSA, and shareable between DSA drivers. We will see.

I'll dig into the 6390X datasheet to see how that works, thanks for
the info.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
