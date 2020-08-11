Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09BC8241CEE
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 17:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728845AbgHKPIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 11:08:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728800AbgHKPIP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 11:08:15 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AC6EC06174A
        for <netdev@vger.kernel.org>; Tue, 11 Aug 2020 08:08:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=5mg9JxYXU7NQfp9lupHaxLc9XTaH2r8k8DY0AxSun2g=; b=OIF1+bgeCquX/B3UXvv5olnq7
        WFoqYNRuloxGsYmMDkL6qohmd8yzKtZn7oQjQa3FeoBzuudxSmWuvyz31QZj3wLarBtBJrqYIkkT9
        pcwooRCrA8MZIzytKijyGHLY8miAwwmtun0LtPp3Xg+bLUK7qxGYnBhqOkn7xrrLmn1Ab2M68G4N2
        fP4cc2tAGxmu3HYtj+5dfAC0MDh+9nThl2Mbe589NzDCz6hlddkFeL4ITmF5qSuuOluOBx9XfnbNf
        AzIq91BiWREHXg4BcJafRd831BajqqUFljak0tZtjdM3eKA6WO7SMkH+zsbHzUTWCpv6yrlCADph6
        I/1WDihHA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:51186)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1k5Vso-0001Yz-SV; Tue, 11 Aug 2020 16:08:10 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1k5Vsn-0002tV-6J; Tue, 11 Aug 2020 16:08:09 +0100
Date:   Tue, 11 Aug 2020 16:08:09 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Baruch Siach <baruch@tkos.co.il>,
        Chris Healy <cphealy@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC russell-king 0/4] Support for RollBall 10G copper SFP
 modules
Message-ID: <20200811150808.GL1551@shell.armlinux.org.uk>
References: <20200810220645.19326-1-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200810220645.19326-1-marek.behun@nic.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 11, 2020 at 12:06:41AM +0200, Marek Behún wrote:
> Hi Russell,
> 
> this series should apply on linux-arm git repository, on branch
> clearfog.
> 
> Some internet providers are already starting to offer 2.5G copper
> connectivity to their users. On Turris Omnia the SFP port is capable
> of 2.5G speed, so we tested some copper SFP modules.
> 
> This adds support to the SFP subsystem for 10G RollBall copper modules
> which contain a Marvell 88X3310 PHY. By default these modules are
> configured in 10GKR only mode on the host interface, and also contain
> some bad information in EEPROM (the extended_cc byte).

Are you sure they are 10GBASE-KR, and not 10GBASE-R ?  Please send me
the contents of MMD 31 register 0xf001.  Also knowing MMD 1 registers
2 and 3 would be useful to confirm exactly which version of the PHY
has been used.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
