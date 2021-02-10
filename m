Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF8213167B8
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 14:16:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbhBJNQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 08:16:12 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:60258 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231553AbhBJNP7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 08:15:59 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l9pKn-005Jyp-4D; Wed, 10 Feb 2021 14:15:09 +0100
Date:   Wed, 10 Feb 2021 14:15:09 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: mv88e6xxx: NET_DSA_MV88E6XXX_PTP should depend
 on NET_DSA_MV88E6XXX
Message-ID: <YCPcXc6tO7E1806g@lunn.ch>
References: <20210210081110.1185217-1-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210210081110.1185217-1-geert+renesas@glider.be>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 09:11:10AM +0100, Geert Uytterhoeven wrote:
> Making global2 support mandatory removed the Kconfig symbol
> NET_DSA_MV88E6XXX_GLOBAL2.  This symbol also served as an intermediate
> symbol to make NET_DSA_MV88E6XXX_PTP depend on NET_DSA_MV88E6XXX.  With
> the symbol removed, the user is always asked about PTP support for
> Marvell 88E6xxx switches, even if the latter support is not enabled.
> 
> Fix this by reinstating the dependency.
> 
> Fixes: 63368a7416df144b ("net: dsa: mv88e6xxx: Make global2 support mandatory")
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
