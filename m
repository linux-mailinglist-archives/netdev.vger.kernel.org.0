Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97F59355F85
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 01:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237062AbhDFXgj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 19:36:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:37362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233184AbhDFXgh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 19:36:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1859D61158;
        Tue,  6 Apr 2021 23:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617752188;
        bh=5W2IY2YLOQt6wZ9wCo7y5bv0sMtrr1dB6/9VlLWSfLI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lSJnQtLosZsokRmNC2HdvgauyrsQCK0CjOhOd3Fnj+i3mDZZujTcmc3EAAXX4FiA7
         l/KoTO2GZB0EjVGHvkG2xzjsoBnh7sxq1oaZrFDXG4plZjZQchvZs3SBXihPA9tCfA
         QKi4Ua7SqvAyoI4U9leNGNa44LzFKM1800GUg0X74s0PxAOtit/IXkz79la/Lg18Pu
         Da+R8wFwGxhoAl0WHMGpqyW1jpu2prJ4UiDG2IJ3mk1Pp9aDqzMByAipvo1GbhETly
         oIzWTwa2eTeQwzyFPD8xTDJcU0Ye/QdXsOu9Zw3jDnHYtNp+C7xXKXwbDyhXJE726z
         +rlyn/WOm18fQ==
Date:   Wed, 7 Apr 2021 01:36:24 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kuba@kernel.org
Subject: Re: [PATCH net-next v3 07/18] net: phy: marvell10g: support all
 rate matching modes
Message-ID: <20210407013624.31cb7b0c@thinkpad>
In-Reply-To: <YGzvFI+hLVp96HiP@lunn.ch>
References: <20210406221107.1004-1-kabel@kernel.org>
        <20210406221107.1004-8-kabel@kernel.org>
        <YGzvFI+hLVp96HiP@lunn.ch>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 7 Apr 2021 01:30:28 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> > +static inline const struct mv3310_chip *
> > +to_mv3310_chip(struct phy_device *phydev)
> > +{
> > +	return phydev->drv->driver_data;
> > +}  
> 
> No inline functions in C code please. Let the compiler decide.
> 
>    Andrew

Fixed in my repo. Will send changed for v4.

Marek
