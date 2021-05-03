Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 965F2371568
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 14:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233786AbhECMuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 08:50:32 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50860 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233757AbhECMuc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 May 2021 08:50:32 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1ldY10-002I5N-GK; Mon, 03 May 2021 14:49:34 +0200
Date:   Mon, 3 May 2021 14:49:34 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next v2 02/17] net: mdio: ipq8064: switch to
 write/readl function
Message-ID: <YI/xXuWbq7npocCS@lunn.ch>
References: <20210502230710.30676-1-ansuelsmth@gmail.com>
 <20210502230710.30676-2-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210502230710.30676-2-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 03, 2021 at 01:06:54AM +0200, Ansuel Smith wrote:
> Use readl/writel function instead of regmap function to make sure no
> value is cached and align to other similar mdio driver.

regmap is O.K. to use, so long as you tell it not to cache. Look at
how to use volatile in regmap.

You might be able to follow what lan9303_mdio.c is doing.

    Andrew
