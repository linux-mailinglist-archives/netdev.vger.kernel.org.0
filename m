Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8CF355F7A
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 01:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344602AbhDFXal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 19:30:41 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36836 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344627AbhDFXai (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 19:30:38 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lTv9Q-00FD1Q-JF; Wed, 07 Apr 2021 01:30:28 +0200
Date:   Wed, 7 Apr 2021 01:30:28 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kuba@kernel.org
Subject: Re: [PATCH net-next v3 07/18] net: phy: marvell10g: support all rate
 matching modes
Message-ID: <YGzvFI+hLVp96HiP@lunn.ch>
References: <20210406221107.1004-1-kabel@kernel.org>
 <20210406221107.1004-8-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210406221107.1004-8-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static inline const struct mv3310_chip *
> +to_mv3310_chip(struct phy_device *phydev)
> +{
> +	return phydev->drv->driver_data;
> +}

No inline functions in C code please. Let the compiler decide.

   Andrew
