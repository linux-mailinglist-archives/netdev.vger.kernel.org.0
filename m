Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26A233920EA
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 21:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234194AbhEZTeW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 15:34:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:50482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231449AbhEZTeV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 15:34:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1AD6F613CD;
        Wed, 26 May 2021 19:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622057569;
        bh=/QroVxf25iUsZmhleTWdOV1Mlxy+CftdDWEVZ1/8Hac=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kW6CTZWr/lzfyoHDJU28ofpO2M8u9/beae7uY7NfzdWHRGYR+6PMHi+FHgwACEC7O
         poyNv78TqI6/7Mzo9Ce8bOLh3ijLHz7JkgyrCrxp8CLQ7K2j1zs517zoGIW/ZkkDcf
         o8+75rGTvl/IXqSK/sPU1YZDS7oDzIb0a6FGtAa/TqcjO+OrWL6bJ2sPcyiCn5b8mc
         86dOvr4cVycmxZiXbJp6wcrHYcmjDM3csWxfj+sHIk2p2nUjMkGnNID6LanNtsd5ow
         8ExgMd1nhQnsV597sS8sExEzTNpNvSchB8dkCn8Uw7Zwt6LnIzrzBwwGUPnevym2nX
         XXVtFlURFn5yA==
Date:   Wed, 26 May 2021 12:32:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: Re: [PATCH net-next v3 9/9] net: phy: micrel: ksz886x/ksz8081: add
 cabletest support
Message-ID: <20210526123248.1edf9f94@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210526043037.9830-10-o.rempel@pengutronix.de>
References: <20210526043037.9830-1-o.rempel@pengutronix.de>
        <20210526043037.9830-10-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 May 2021 06:30:37 +0200 Oleksij Rempel wrote:
> +	if (phydev->dev_flags & MICREL_KSZ8_P1_ERRATA)
> +		return -ENOTSUPP;

EOPNOTSUPP
