Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B39662EA9
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 05:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727229AbfGIDR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 23:17:28 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34096 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726133AbfGIDR2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jul 2019 23:17:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=0IeQiCsgznKInsLdgZEa+OjM4PnZxoN0re7tAB4Yxtk=; b=2HsF3vYqwqBYi1hrblG0UyH3vh
        dK6Wpn1El1WpP1pUNeDn15qSFcXLWYl9FSjy2yNaEAA58pBdGIMib8Ptiq2vtsLgp5jHJ5n2WUziO
        j0WeUKDbsUNxMXXhITYyJDPLt0xM8ZP5VowQpQXiEfiIMwndp25K3uPRXXn6FxAqJflc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hkgd7-00071s-54; Tue, 09 Jul 2019 05:17:21 +0200
Date:   Tue, 9 Jul 2019 05:17:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, paweldembicki@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: vsc73xx: Fix Kconfig warning and
 build errors
Message-ID: <20190709031721.GE5835@lunn.ch>
References: <20190708172808.GG9027@lunn.ch>
 <20190709030224.40292-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190709030224.40292-1-yuehaibing@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 09, 2019 at 11:02:24AM +0800, YueHaibing wrote:
> Fix Kconfig dependency warning and subsequent build errors
> caused by OF is not set:
> 
> WARNING: unmet direct dependencies detected for NET_DSA_VITESSE_VSC73XX
>   Depends on [n]: NETDEVICES [=y] && HAVE_NET_DSA [=y] && OF [=n] && NET_DSA [=m]
>   Selected by [m]:
>   - NET_DSA_VITESSE_VSC73XX_PLATFORM [=m] && NETDEVICES [=y] && HAVE_NET_DSA [=y] && HAS_IOMEM [=y]
> 
> Make NET_DSA_VITESSE_VSC73XX_SPI and NET_DSA_VITESSE_VSC73XX_PLATFORM
> depends on NET_DSA_VITESSE_VSC73XX to fix this.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Suggested-by: Andrew Lunn <andrew@lunn.ch>
> Fixes: 95711cd5f0b4 ("net: dsa: vsc73xx: Split vsc73xx driver")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
