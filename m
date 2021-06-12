Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0A33A5011
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 20:15:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231309AbhFLSQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Jun 2021 14:16:57 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:32806 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229753AbhFLSQ4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Jun 2021 14:16:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=J4tqSbV+EfhoCZXf1ONCPzFm/H7DG6xlxPjLFDAN3N0=; b=TkevZGtaCtwWlfT7/KRZ5COPwb
        xk+x9LtuAssDpo/voQ8E5rm3kVOacDeM+6ANqCkQS2oae4xSh1juYSy4WzlshpNtgMX9N3KcE5Wac
        i/mde02gGvV8f4Pn1QCE4auycBGxCElLr6WEyMj9+29KunJ4AOJRITV5Pk/ggASSbJl0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ls89k-0091NO-EY; Sat, 12 Jun 2021 20:14:52 +0200
Date:   Sat, 12 Jun 2021 20:14:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: Re: [PATCH net-next v4 6/9] net: phy: micrel: ksz8081 add MDI-X
 support
Message-ID: <YMT5nIE6hb1xEySQ@lunn.ch>
References: <20210611071527.9333-1-o.rempel@pengutronix.de>
 <20210611071527.9333-7-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210611071527.9333-7-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 11, 2021 at 09:15:24AM +0200, Oleksij Rempel wrote:
> Add support for MDI-X status and configuration
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
