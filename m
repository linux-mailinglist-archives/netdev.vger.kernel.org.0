Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C236563D36
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 23:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727622AbfGIVU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 17:20:29 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45782 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbfGIVU2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 17:20:28 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2B5BD141FD75F;
        Tue,  9 Jul 2019 14:20:28 -0700 (PDT)
Date:   Tue, 09 Jul 2019 14:20:27 -0700 (PDT)
Message-Id: <20190709.142027.1850904278953075536.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        paweldembicki@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: vsc73xx: Fix Kconfig warning and
 build errors
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190709030224.40292-1-yuehaibing@huawei.com>
References: <20190708172808.GG9027@lunn.ch>
        <20190709030224.40292-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 09 Jul 2019 14:20:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Tue, 9 Jul 2019 11:02:24 +0800

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
> ---
> v2: Use "depends on" instead of "select" NET_DSA_VITESSE_VSC73XX

I ended up applying Arnd's version of this fix which was very similar.

If there is anything you want to change just submit a relative patch
on top of Arnd's change.

Thank you.
