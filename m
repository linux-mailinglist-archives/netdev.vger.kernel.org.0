Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC1A42CC04D
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 16:05:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730404AbgLBPEO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 10:04:14 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34218 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730304AbgLBPEO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 10:04:14 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kkTfA-009spj-ES; Wed, 02 Dec 2020 16:03:24 +0100
Date:   Wed, 2 Dec 2020 16:03:24 +0100
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
Subject: Re: [PATCH v2 1/2] net: dsa: add optional stats64 support
Message-ID: <20201202150324.GD2324545@lunn.ch>
References: <20201202120712.6212-1-o.rempel@pengutronix.de>
 <20201202120712.6212-2-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201202120712.6212-2-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 02, 2020 at 01:07:11PM +0100, Oleksij Rempel wrote:
> Allow DSA drivers to export stats64
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
