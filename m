Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCA40296FE6
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 15:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S464266AbgJWNJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 09:09:18 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41504 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S464258AbgJWNJR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Oct 2020 09:09:17 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kVwod-00387i-02; Fri, 23 Oct 2020 15:09:07 +0200
Date:   Fri, 23 Oct 2020 15:09:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>, mkl@pengutronix.de,
        Marek Vasut <marex@denx.de>
Subject: Re: [PATCH v2] net: phy: replace spaces by tabs
Message-ID: <20201023130906.GC745568@lunn.ch>
References: <20201023100030.9461-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201023100030.9461-1-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 23, 2020 at 12:00:30PM +0200, Oleksij Rempel wrote:
> This patch replaces the spaces in the indention of the 56G PHYs by
> proper tabs.

Hi Oleksij

The change itself is O.K.

However, please put in the subject line which tree it is for,

[PATCH net-next v2] ...

Also, net next is closed at the moment, since the merge window is
open. Jakub will send an email once it opens again next week. Please
resend then.

       Andrew
