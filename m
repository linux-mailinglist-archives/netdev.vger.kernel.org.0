Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65602135F88
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 18:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388245AbgAIRn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 12:43:27 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:56416 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728724AbgAIRn1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 12:43:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=6wa6i6mhkY3ce0uMFZmUBWteqlMn4kIMrBvOJQGwKEE=; b=1yCMabnn0U9eSKvrRcvsortgR
        IPCTkngKw7W+EqJsdDS7N70UB+8XDMCgPIwYdgKkqVHE53pIknyiuxYlRI1ZqPCB+87m9rvNYICZ5
        QYRR0kNstYwh8MBmOjbKKOh7yXrPemwc/4VAvKBPXVCoSkuJ2NXH0eirWIcLWOteYiqxTYRIY6CMk
        d9OViz67azJPfSHibL3b2utnwLK+yDZD2XeRan/rfCBexIEHt20dm7bh2A8HW4/JpLoH5ziCF9FQN
        mHg2EvAZVyPY8AcBSBkZwJJqyHiohNHosmm3T/6tKZJnEQT6uDyDTSWW1BCdcUrCnYy5ewvyUAc6E
        Z9wWoux/Q==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:52720)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ipbq7-0006Uf-QF; Thu, 09 Jan 2020 17:43:23 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ipbq6-0000gb-Fr; Thu, 09 Jan 2020 17:43:22 +0000
Date:   Thu, 9 Jan 2020 17:43:22 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     =?utf-8?B?0b3SieG2rOG4s+KEoA==?= <vtol@gmx.net>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: Re: [drivers/net/phy/sfp] intermittent failure in state machine
 checks
Message-ID: <20200109174322.GR25745@shell.armlinux.org.uk>
References: <d8d595ff-ec35-3426-ec43-9afd67c15e3d@gmx.net>
 <20200109144106.GA24459@lunn.ch>
 <513d6fe7-65b2-733b-1d17-b3a40b8161cf@gmx.net>
 <20200109155809.GQ25745@shell.armlinux.org.uk>
 <bb2c2eed-5efa-00f6-0e52-1326669c1b0d@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bb2c2eed-5efa-00f6-0e52-1326669c1b0d@gmx.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 09, 2020 at 05:35:23PM +0000, ѽ҉ᶬḳ℠ wrote:
> Thank you for the extensive feedback and explanation.
> 
> Pardon for having mixed up the semantics on module specifications vs. EEPROM
> dump...
> 
> The module (chipset) been designed by Metanoia, not sure who is the actual
> manufacturer, and probably just been branded Allnet.
> The designer provides some proprietary management software (called EBM) to
> their wholesale buyers only

I have one of their early MT-V5311 modules, but it has no accessible
EEPROM, and even if it did, it would be of no use to me being
unapproved for connection to the BT Openreach network.  (BT SIN 498
specifies non-standard power profile to avoid crosstalk issues with
existing ADSL infrastructure, and I believe they regularly check the
connected modem type and firmware versions against an approved list.)

I haven't noticed the module I have asserting its TX_FAULT signal,
but then its RJ45 has never been connected to anything.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
