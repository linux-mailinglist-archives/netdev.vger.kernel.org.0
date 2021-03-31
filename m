Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25376350047
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 14:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235609AbhCaM1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 08:27:53 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56070 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235552AbhCaM13 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 08:27:29 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lRZwN-00EAZw-VU; Wed, 31 Mar 2021 14:27:19 +0200
Date:   Wed, 31 Mar 2021 14:27:19 +0200
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
Subject: Re: [PATCH net-next v1 3/3] net: fec: add basic selftest support
Message-ID: <YGRqpxefTxZjqp6w@lunn.ch>
References: <20210330135407.17010-1-o.rempel@pengutronix.de>
 <20210330135407.17010-4-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210330135407.17010-4-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 30, 2021 at 03:54:07PM +0200, Oleksij Rempel wrote:
> Port some parts of the stmmac selftest to the FEC. This patch was tested
> on iMX6DL.
> With this tests it is possible to detect some basic issues like:
> - MAC loopback fail: most probably wrong clock configuration.
> - PHY loopback fail: incorrect RGMII timings, damaged traces, etc

Hi

Oleksij

I've not done a side-by-side diff with stmmac, but i guess a lot of
this code is identical? Rather than make a copy/paste, could you move
it somewhere under net and turn it into a library any driver can use?

   Andrew
