Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE3692C6CBA
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 21:50:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731367AbgK0UtA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 15:49:00 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:53466 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731258AbgK0Ur2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 15:47:28 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kikeA-009BAS-5A; Fri, 27 Nov 2020 21:47:14 +0100
Date:   Fri, 27 Nov 2020 21:47:14 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Subject: Re: [PATCH net-next v2 2/3] net: dsa: add Arrow SpeedChips XRS700x
 driver
Message-ID: <20201127204714.GX2073444@lunn.ch>
References: <20201125193740.36825-1-george.mccollister@gmail.com>
 <20201125193740.36825-3-george.mccollister@gmail.com>
 <20201125174214.0c9dd5a9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAFSKS=OY_-Agd6JPoFgm3MS5HE6soexHnDHfq8g9WVrCc82_sA@mail.gmail.com>
 <20201126132418.zigx6c2iuc4kmlvy@skbuf>
 <20201126175607.bqmpwbdqbsahtjn2@skbuf>
 <CAFSKS=Ok1FZhKqourHh-ikaia6eNWtXh6VBOhOypsEJAhwu06g@mail.gmail.com>
 <20201126220500.av3clcxbbvogvde5@skbuf>
 <20201127103503.5cda7f24@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201127103503.5cda7f24@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Is the periodic refresh really that awful? We're mostly talking error
> counters here so every second or every few seconds should be perfectly
> fine.

Humm, i would prefer error counts to be more correct than anything
else. When debugging issues, you generally don't care how many packets
worked. It is how many failed you are interesting, and how that number
of failures increases.

So long as these counters are still in ethtool -S, i guess it does not
matter. That i do trust to be accurate, and probably consistent across
the counters it returns.

	Andrew
