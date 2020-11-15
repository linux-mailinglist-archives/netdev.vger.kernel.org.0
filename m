Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA6C32B35DD
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 16:47:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727175AbgKOPrR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Nov 2020 10:47:17 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:56168 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726749AbgKOPrR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Nov 2020 10:47:17 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1keKFD-007CFB-2d; Sun, 15 Nov 2020 16:47:11 +0100
Date:   Sun, 15 Nov 2020 16:47:11 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH v1 net-next] net: dsa: qca: ar9331: add ethtool stats
 support
Message-ID: <20201115154711.GB1701029@lunn.ch>
References: <20201115073533.1366-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201115073533.1366-1-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 15, 2020 at 08:35:33AM +0100, Oleksij Rempel wrote:
> Add stats support for the ar9331 switch.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
