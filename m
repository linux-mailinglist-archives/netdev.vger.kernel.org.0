Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3823834EA97
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 16:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232249AbhC3Oj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 10:39:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54944 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232038AbhC3Ojm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 10:39:42 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lRFWr-00E295-8S; Tue, 30 Mar 2021 16:39:37 +0200
Date:   Tue, 30 Mar 2021 16:39:37 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com,
        Fabio Estevam <festevam@gmail.com>,
        David Jander <david@protonic.nl>,
        Russell King <linux@armlinux.org.uk>,
        Philippe Schenker <philippe.schenker@toradex.com>
Subject: Re: [PATCH net-next v1 1/3] net: phy: micrel: KSZ8081: add loopback
 support
Message-ID: <YGM4KXONEyp/xfsJ@lunn.ch>
References: <20210330135407.17010-1-o.rempel@pengutronix.de>
 <20210330135407.17010-2-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210330135407.17010-2-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 30, 2021 at 03:54:05PM +0200, Oleksij Rempel wrote:
> PHY loopback is needed for the ethernet controller self test support.
> This PHY was tested with the FEC sefltest.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Apart from the typo

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
