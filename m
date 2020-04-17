Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD8B21AE183
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 17:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729570AbgDQPsk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 11:48:40 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44422 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728593AbgDQPsj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 11:48:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=0WgM+krneVV5FiQ/q9XM55a4C9NRJKH0x5fOX6q69oU=; b=jlLhDjmiDSgpoOwKEQE8yTYLtR
        3XhYPM7jrjle6Qw/OYssS6aEP2OM/Hwtj+dEEjNMpqz+tDM4CU12QQ+dEYjY3HkpdXMl9GgcV4DSd
        o71/Kq4GuoNmCZ14wBtWsAAyo6kgwpKjBiSErQMUusnZKCh3dg2gYOBP44CkrOYF+sKs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jPTEL-003JGo-07; Fri, 17 Apr 2020 17:48:37 +0200
Date:   Fri, 17 Apr 2020 17:48:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH] net: phy: marvell10g: hwmon support for 2110
Message-ID: <20200417154836.GB785713@lunn.ch>
References: <18fe946c32093f50462e026090a9e32eb568c8c5.1587103852.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18fe946c32093f50462e026090a9e32eb568c8c5.1587103852.git.baruch@tkos.co.il>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 17, 2020 at 09:10:52AM +0300, Baruch Siach wrote:
> Read the temperature sensor register from the correct location for the
> 88E2110 PHY. There is no enable/disable bit, so leave
> mv3310_hwmon_config() for 88X3310 only.

Nice. Thanks for doing this.

> @@ -191,7 +201,8 @@ static int mv3310_hwmon_probe(struct phy_device *phydev)
>  	struct mv3310_priv *priv = dev_get_drvdata(&phydev->mdio.dev);
>  	int i, j, ret;
>  
> -	if (phydev->drv->phy_id != MARVELL_PHY_ID_88X3310)
> +	if (phydev->drv->phy_id != MARVELL_PHY_ID_88X3310 &&
> +			phydev->drv->phy_id != MARVELL_PHY_ID_88E2110)
>  		return 0;

The indentation looks wrong here?

Thanks
	Andrew
