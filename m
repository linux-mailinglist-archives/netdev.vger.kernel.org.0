Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57CBA3CC494
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 18:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231928AbhGQQv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Jul 2021 12:51:59 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59896 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230386AbhGQQv6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Jul 2021 12:51:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=jal8gW8FsbnMzENgWjzFxwPpZrFvxFP4cY0bGpMnFWA=; b=AdYsegpuAw7P3BIBzTkYy6J0rJ
        LelTjYBdzv8mI2xK6rSOGcTz2QcL+LCHpKKP25qUUTQ3kZns8B7ssPFgNy/CsZmu9zU7NiMmL8ZLN
        Y8jOPKPXKYQPTQtfOtv3ZxYr579Z5PyH4tl1sL66/8JLvYCnf63CTH7Hi3ZcmULxDUGE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m4nUp-00DkE8-Iw; Sat, 17 Jul 2021 18:48:59 +0200
Date:   Sat, 17 Jul 2021 18:48:59 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH] net: phy: Fix data type in DP83822 dp8382x_disable_wol()
Message-ID: <YPMJ+9Z0TrDQ7YaN@lunn.ch>
References: <20210717123249.56505-1-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210717123249.56505-1-marex@denx.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 17, 2021 at 02:32:49PM +0200, Marek Vasut wrote:
> The last argument of phy_clear_bits_mmd(..., u16 val); is u16 and not
> int, just inline the value into the function call arguments.
> 
> No functional change.

I don't think there is an overflow issue here, so this can go into
net-next. The subject should reflect this, Subject: [PATCH net-next] ...

Thanks for splitting it into a standalone patch.

> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: David S. Miller <davem@davemloft.net>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
