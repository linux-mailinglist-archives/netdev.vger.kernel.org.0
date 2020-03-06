Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0359417B396
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 02:13:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbgCFBNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 20:13:16 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48534 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726162AbgCFBNQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 20:13:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=cN9LtKYxEh7WVRunE+8Cr07ags8PwJAtocJ057ecJ/w=; b=OIGbt0pjDm1M5Uqrh3ngroHmsM
        RTKqrBOwgRiKlOpkXT4zUxjRkqnelOCmT5fPkVb1T86CFHPAfBqIUIYciJW+EZAsQRAhUH+hOPhmL
        fYRRifTlYGJdTJnR3V+s7+h16PnQ4xT1N52P9lBxFr3SM8tzYZBhQurP4MmYPfnbtugg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jA1Y6-0001BK-F7; Fri, 06 Mar 2020 02:13:10 +0100
Date:   Fri, 6 Mar 2020 02:13:10 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next 0/10] net: dsa: improve serdes integration
Message-ID: <20200306011310.GC2450@lunn.ch>
References: <20200305124139.GB25745@shell.armlinux.org.uk>
 <20200305225407.GD25183@lunn.ch>
 <20200305234557.GE25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200305234557.GE25745@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> FYI, the port status and control register for the CPU port on the
> ZII rev C should be:
> 
> 0 = 0xd04
> 1 = 0x203d

Hi Russell

I've been testing Devel C, port lan1. So port 1 on the first switch.

net-next/master from a few hours ago ping's out that interface.  So
the CPU/DSA phylink breakage is not part of this problem.

net-next/master + this patchset no longer pings.

Register dump for the CPU port shows:

0: 0e04
1: 203d

The e indicates 1000Mbs, where as it should be 100Mbs. However, as i
said, the datasheet suggests this might not be a problem?

I will try to figure out which patch broke it.

  Andrew
