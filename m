Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49DC52C6D26
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 23:16:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730732AbgK0WOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 17:14:00 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:53602 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732151AbgK0WNJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 17:13:09 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kilQ2-009BQa-HE; Fri, 27 Nov 2020 22:36:42 +0100
Date:   Fri, 27 Nov 2020 22:36:42 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        George McCollister <george.mccollister@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Subject: Re: [PATCH net-next v2 2/3] net: dsa: add Arrow SpeedChips XRS700x
 driver
Message-ID: <20201127213642.GZ2073444@lunn.ch>
References: <20201125174214.0c9dd5a9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAFSKS=OY_-Agd6JPoFgm3MS5HE6soexHnDHfq8g9WVrCc82_sA@mail.gmail.com>
 <20201126132418.zigx6c2iuc4kmlvy@skbuf>
 <20201126175607.bqmpwbdqbsahtjn2@skbuf>
 <CAFSKS=Ok1FZhKqourHh-ikaia6eNWtXh6VBOhOypsEJAhwu06g@mail.gmail.com>
 <20201126220500.av3clcxbbvogvde5@skbuf>
 <20201127103503.5cda7f24@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <20201127204714.GX2073444@lunn.ch>
 <20201127131346.3d594c8e@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <20201127212342.qpyp6bcxd7mwgxf2@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201127212342.qpyp6bcxd7mwgxf2@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Either way, can we conclude that ndo_get_stats64 is not a replacement
> for ethtool -S, since the latter is blocking and, if implemented correctly,
> can return the counters at the time of the call (therefore making sure
> that anything that happened before the syscall has been accounted into
> the retrieved values), and the former isn't?

ethtool -S is the best source of consistent, up to date statistics we
have. It seems silly not to include everything the hardware offers
there.

	Andrew
