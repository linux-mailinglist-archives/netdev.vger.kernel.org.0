Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92A753E9429
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 17:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232867AbhHKPAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 11:00:31 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45304 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232855AbhHKPA3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 11:00:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=7bQV05XnMWhdDuuxH7FMFpb9864KxRDn5zp0OhtPXvw=; b=kH
        zTplGIEv9C7x/ovp/yn1HMn6dH3E1cwlN77Me/7Y3zrALRYHqiqHk3jNxgY99o/p57/VUj47jh0Wq
        LMy8isa1wTtGmuSRh367mEsjqm5h6x4IcoaN7jyIiGcYUdO51ljenhlUUvAi2Mlpc3kPH/tYZs2B7
        ham3wL0W8myUpVg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mDphw-00H8Ni-3h; Wed, 11 Aug 2021 16:59:52 +0200
Date:   Wed, 11 Aug 2021 16:59:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Marek Vasut <marex@denx.de>, David Jander <david@protonic.nl>,
        linux-hwmon@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/1] net: phy: nxp-tja11xx: log critical
 health state
Message-ID: <YRPl6NVyxU9q98AS@lunn.ch>
References: <20210811063712.19695-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210811063712.19695-1-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 11, 2021 at 08:37:12AM +0200, Oleksij Rempel wrote:
> TJA1102 provides interrupt notification for the critical health states
> like overtemperature and undervoltage.
> 
> The overtemperature bit is set if package temperature is beyond 155C°.
> This functionality was tested by heating the package up to 200C°
> 
> The undervoltage bit is set if supply voltage drops beyond some critical
> threshold. Currently not tested.
> 
> In a typical use case, both of this events should be logged and stored
> (or send to some remote system) for further investigations.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
