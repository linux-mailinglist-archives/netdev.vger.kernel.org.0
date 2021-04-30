Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18B1936FE6A
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 18:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbhD3QYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 12:24:22 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48142 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229579AbhD3QYV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Apr 2021 12:24:21 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lcVvH-001ptJ-P7; Fri, 30 Apr 2021 18:23:23 +0200
Date:   Fri, 30 Apr 2021 18:23:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com, Fabio Estevam <festevam@gmail.com>,
        David Jander <david@protonic.nl>,
        Russell King <linux@armlinux.org.uk>,
        Philippe Schenker <philippe.schenker@toradex.com>
Subject: Re: [PATCH net-next v1 1/1] net: selftest: provide option to disable
 generic selftests
Message-ID: <YIwu+4ywaTI4+eUq@lunn.ch>
References: <20210430095308.14465-1-o.rempel@pengutronix.de>
 <f0905c84-6bb2-702f-9ae7-614dcd85c458@infradead.org>
 <20210430154153.zhdnxzkm2fhcuogo@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210430154153.zhdnxzkm2fhcuogo@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Thanks for the patch/option. But I think it should just default to n,
> > not PHYLIB.
> 
> It should be enabled by default for every device supporting this kind of
> selftests.

I agree.

I still wonder if there is confusion about self test here. Maybe
putting ethtool into the description will help people understand it
has nothing to do with the kernel self test infrastructure and kernel
self testing.

	Andrew
