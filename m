Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E693722FBFF
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 00:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbgG0WUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 18:20:07 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58262 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726171AbgG0WUH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 18:20:07 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k0BTY-007ARg-Du; Tue, 28 Jul 2020 00:20:04 +0200
Date:   Tue, 28 Jul 2020 00:20:04 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH RFC net-next 0/3] Restructure drivers/net/phy
Message-ID: <20200727222004.GE1705504@lunn.ch>
References: <20200727204731.1705418-1-andrew@lunn.ch>
 <20200727150534.749dac4a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727150534.749dac4a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 03:05:34PM -0700, Jakub Kicinski wrote:
> On Mon, 27 Jul 2020 22:47:28 +0200 Andrew Lunn wrote:
> > RFC Because it needs 0-day build testing
> 
> Looks like allmodconfig falls over on patches 2 and 3.
> 
> make[6]: *** No rule to make target 'drivers/net/phy/phy/mscc/mscc_ptp.o', needed by 'drivers/net/phy/phy/mscc/mscc.o'.  Stop.

Thanks Jakub. My desktop machine takes its time with allmodconfig
builds.

mscc_ptp.c & mscc_ptp.h got added after my first implementation. When
i rebased they got left in there old location.

I fixed it, and pushed my branch out. 0-day should run some tests on
it. Lets see if it finds anything else.

    Andrew
