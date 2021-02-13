Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5306831AD4B
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 18:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbhBMRAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 12:00:22 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:39262 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229574AbhBMRAV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 13 Feb 2021 12:00:21 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lAyGZ-0064k4-Pb; Sat, 13 Feb 2021 17:59:31 +0100
Date:   Sat, 13 Feb 2021 17:59:31 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Quentin Schulz <quentin.schulz@bootlin.com>,
        netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next 1/2] net: phylink: explicitly configure in-band
 autoneg for PHYs that support it
Message-ID: <YCgFc0sK1BYtAo4d@lunn.ch>
References: <20210212172341.3489046-1-olteanv@gmail.com>
 <20210212172341.3489046-2-olteanv@gmail.com>
 <eb7b911f4fe008e1412058f219623ee2@walle.cc>
 <20210213001808.GN1463@shell.armlinux.org.uk>
 <db9f5988d7d135b3588bf9f6a5b10b08@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <db9f5988d7d135b3588bf9f6a5b10b08@walle.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Thanks, but I'm not sure I understand the difference between "rate
> adaption" and symbol repetition. The SGMII link is always 1.25Gb,
> right? If the media side is 100Mbit it will repeat the symbol 10
> times or 100 times in case of 10Mbit. What is "rate adaption" then?

Hi Michael

Some multiG PHYs fix their host side interface to say 10Gbps,
independent of what the media side is doing. The PHY adapts the 10Gbps
stream it gets from the host down to 10Mbps etc as needed, dropping
frames if its internal buffers overflow.

       Andrew
