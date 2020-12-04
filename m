Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55A852CF4B6
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 20:27:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730324AbgLDTZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 14:25:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:56764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725923AbgLDTZ3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 14:25:29 -0500
Date:   Fri, 4 Dec 2020 11:24:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607109889;
        bh=KYZ4Kb4P9XRgP/y7T+NPB3Sr41W9mMZxQYOFQ824+dw=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=kW4Ixo6z+DQ0Xp7vqrFVbTdTZ9EorIJVg/8gHmLEYTJxHeB9w5eLsnonl70NPV5Z9
         D0K+xvM/1W5wUN/6pzQnvwdb2MI+XOar+AmKkh/dTsjudEAiDkg2kFjZUYwSxJxtR+
         GCYZvobx0cTEnO68slaTG1IwUDT30yehMt5sreRLYbSYApBnA0XcZBXdeYJnEHNppl
         D/DZLxf72X2y3Jzfm21/0GkuYQgGL94ZY+EXlb1gnSsFQTRZSk/MK//cswzkqNZ8WN
         0gttTkytLPI/1XyiAsmQQ0+CFAx73Xcg0iM84VbmvlOCwZIuj7xOt13/LkFVz+U4u5
         Vs1Xbw6Wq6Q0w==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        "Allan W . Nielsen" <allan.nielsen@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Steen Hegelund <steen.hegelund@microchip.com>
Subject: Re: [PATCH v2 net] net: mscc: ocelot: install MAC addresses in
 .ndo_set_rx_mode from process context
Message-ID: <20201204112448.43097275@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201204105516.1237a690@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
References: <20201204175125.1444314-1-vladimir.oltean@nxp.com>
        <20201204100021.0b026725@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <20201204181250.t5d4hc7wis7pzqa2@skbuf>
        <20201204105516.1237a690@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Dec 2020 10:55:16 -0800 Jakub Kicinski wrote:
> > > >  drivers/net/ethernet/mscc/ocelot_net.c | 83 +++++++++++++++++++++++++-
> > > >  1 file changed, 80 insertions(+), 3 deletions(-)    
> > >
> > > This is a little large for a rc7 fix :S    
> > 
> > Fine, net-next it is then.  
> 
> If this really is the fix we want, it's the fix we want, and it should
> go into net. We'll just need to test it very well is all.

And when I said "test very well" I obviously mean test against the tree
it's targeting, 'cause this doesn't apply to net right now..
