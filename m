Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA106164FB5
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 21:20:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727298AbgBSUUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 15:20:12 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:54268 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726645AbgBSUUL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 15:20:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=KAdl9nkfoq9a8f1apc9MyNEY0KMLJnsiy/JC7l/c7WU=; b=mAQK9Gssdh2vlWVYIplASIKeuv
        I020YSQRqJgT3/iqz3rD3dzEjKu5NZJX5IpW44Lwvxh8T3hlitpAGBI/YBLzqyF+JAyO7S1JStgLX
        XcctJxsd9Vr+MyKcPNPHvtBxvstwreQBku7TWUXL2jhmqq19jWD/HEJp+iOEQDIzupCE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j4VpG-0002GX-Q0; Wed, 19 Feb 2020 21:20:06 +0100
Date:   Wed, 19 Feb 2020 21:20:06 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2 2/3] net: phy: broadcom: Have
 bcm54xx_adjust_rxrefclk() check for flags
Message-ID: <20200219202006.GY31084@lunn.ch>
References: <20200219200049.12512-1-f.fainelli@gmail.com>
 <20200219200049.12512-3-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200219200049.12512-3-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 19, 2020 at 12:00:48PM -0800, Florian Fainelli wrote:
> bcm54xx_adjust_rxrefclk() already checks for PHY_BRCM_AUTO_PWRDWN_ENABLE
> and PHY_BRCM_DIS_TXCRXC_NOENRGY in order to set the appropriate bit. The
> situation is a bit more complicated with the flag
> PHY_BRCM_RX_REFCLK_UNUSED but essentially amounts to the same situation.
> 
> The default setting for the 125MHz clock is to be on for all PHYs and
> we still treat BCM50610 and BCM50610M specifically with the polarity of
> the bit reversed.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
