Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4FD435F3D2
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 14:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350929AbhDNMbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 08:31:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:60612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229765AbhDNMay (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 08:30:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B510261131;
        Wed, 14 Apr 2021 12:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618403432;
        bh=CuUlOHnt62aetlu/ugyRa4kRlJfSU28qljkRlpQ4vgg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MgYRAmuPZdKKpHOqNOEhjds735UTptD9WGe08x/aoY0PjbFyu4KIUI2a+yDEweU9o
         Xgw2xY8bFtZ52hH0DWaT5yuyKIR0XC7x9cK7ugFE9hHbeDtYMKlL06nBqYj3jyajlX
         Zc4v05I98ZYeLXisCz86May4XTiQX0PJZDS7QpLhzXoZo/4X4fIZiE53YkTgZHxSIX
         7Sxbw1Ke6g1dYePjhvW1Gaoq45pVuVy6Sr5m4J/cehx/8y+wfyseaxOQj4U6fK+w2w
         edB765kFeOydnUr+iifdeWcZpWkagjLYl/K2FyEC9FbZ66d/q/biw/SEvIu1ks1OK3
         IXeyBZT6kan6Q==
Date:   Wed, 14 Apr 2021 08:30:31 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:BROADCOM ETHERNET PHY DRIVERS" 
        <bcm-kernel-feedback-list@broadcom.com>,
        "open list:BROADCOM ETHERNET PHY DRIVERS" <netdev@vger.kernel.org>
Subject: Re: [PATCh stable 4.19] net: phy: broadcom: Only advertise EEE for
 supported modes
Message-ID: <YHbgZ1OnJHKSLv1c@sashalap>
References: <20210412022312.283964-1-sashal@kernel.org>
 <20210412233014.3301686-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210412233014.3301686-1-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 12, 2021 at 04:30:14PM -0700, Florian Fainelli wrote:
>commit c056d480b40a68f2520ccc156c7fae672d69d57d upstream
>
>We should not be advertising EEE for modes that we do not support,
>correct that oversight by looking at the PHY device supported linkmodes.
>
>Fixes: 99cec8a4dda2 ("net: phy: broadcom: Allow enabling or disabling of EEE")
>Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>Signed-off-by: David S. Miller <davem@davemloft.net>
>Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Queued up this and the 4.14 backport, thanks!

-- 
Thanks,
Sasha
