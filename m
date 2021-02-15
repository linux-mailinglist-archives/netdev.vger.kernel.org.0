Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C320331BBFF
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 16:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230423AbhBOPNJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 10:13:09 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:42676 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230199AbhBOPM0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Feb 2021 10:12:26 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lBfXF-006S6T-H8; Mon, 15 Feb 2021 16:11:37 +0100
Date:   Mon, 15 Feb 2021 16:11:37 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Marek Behun <marek.behun@nic.cz>,
        Nathan Rossi <nathan@nathanrossi.com>, netdev@vger.kernel.org,
        Nathan Rossi <nathan.rossi@digi.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] net: dsa: mv88e6xxx: prevent 2500BASEX mode override
Message-ID: <YCqPKatln8CTkQhj@lunn.ch>
References: <20210215061559.1187396-1-nathan@nathanrossi.com>
 <20210215144756.76846c9b@nic.cz>
 <20210215145757.GX1463@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210215145757.GX1463@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> If we can't switch between 1000base-X and 2500base-X, then we should
> not be calling phylink_helper_basex_speed() - and only one of those
> two capabilities should be set in the validation callback. I thought
> there were DSA switches where we could program the CMODE to switch
> between these two...

6390 family has a writable CMODE for ports 9 and 10, and you can
select various SERDES modes.

Nathan, what device are you using?

	Andrew
