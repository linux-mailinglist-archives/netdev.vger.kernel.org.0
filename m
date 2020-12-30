Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AFA62E7C23
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 20:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726323AbgL3Tbk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 14:31:40 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:44912 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726185AbgL3Tbj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Dec 2020 14:31:39 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kuhBM-00F5z5-Ki; Wed, 30 Dec 2020 20:30:52 +0100
Date:   Wed, 30 Dec 2020 20:30:52 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] net: sfp: add workaround for Realtek RTL8672 and
 RTL9601C chips
Message-ID: <X+zVbM2vetCpiIFG@lunn.ch>
References: <20201230154755.14746-1-pali@kernel.org>
 <20201230154755.14746-2-pali@kernel.org>
 <20201230161036.GR1551@shell.armlinux.org.uk>
 <20201230165634.c4ty3mw6djezuyq6@pali>
 <20201230170546.GU1551@shell.armlinux.org.uk>
 <X+y1K21tp01GpvMy@lunn.ch>
 <20201230174307.lvehswvj5q6c6vk3@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201230174307.lvehswvj5q6c6vk3@pali>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Ok!
> 
> So should we completely skip hwmon_device_register_with_info() call
> if (i2c_block_size < 2) ?

Yep. That would be a nice simple test.

But does ethtool -m still export the second page? That is also
unreliable.

	Andrew
