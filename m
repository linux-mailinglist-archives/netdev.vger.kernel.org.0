Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C7AD1DB70C
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 16:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbgETO3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 10:29:50 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41342 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726452AbgETO3u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 10:29:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4Rf+E83X+3ouSmt8Afj1Zv7cNRIqjzlGJwzJN2iMVeg=; b=xptJWxKV3GVUzLm3AuKB3jtnD1
        OnrGft8/0hWbqzpqWCpduy3WLfhWBYKXbVUGdjWZQD57wHQZLaNe7DPmOvxk9c4TJvpseqKuwQ2Ni
        /pGx5ZChrLDfMSxxmkHREJ+7AYDKm1ttY44KuNmk2Qck8mn7yAS0m03XAvPmwqN/xkAc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jbPj6-002oR5-Qo; Wed, 20 May 2020 16:29:44 +0200
Date:   Wed, 20 May 2020 16:29:44 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>, mkl@pengutronix.de,
        Marek Vasut <marex@denx.de>,
        Christian Herber <christian.herber@nxp.com>
Subject: Re: [PATCH net-next v3 2/2] net: phy: tja11xx: add SQI support
Message-ID: <20200520142944.GF652285@lunn.ch>
References: <20200520062915.29493-1-o.rempel@pengutronix.de>
 <20200520062915.29493-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520062915.29493-3-o.rempel@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 20, 2020 at 08:29:15AM +0200, Oleksij Rempel wrote:
> This patch implements reading of the Signal Quality Index for better
> cable/link troubleshooting.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
