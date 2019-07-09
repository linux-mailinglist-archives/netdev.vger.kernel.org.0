Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEAD063CAA
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 22:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729695AbfGIUUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 16:20:21 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44982 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727241AbfGIUUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 16:20:20 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0769E140F881F;
        Tue,  9 Jul 2019 13:20:19 -0700 (PDT)
Date:   Tue, 09 Jul 2019 13:20:19 -0700 (PDT)
Message-Id: <20190709.132019.1388902487563801440.davem@davemloft.net>
To:     arnd@arndb.de
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        paweldembicki@gmail.com, linus.walleij@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [net-next] net: dsa: vsc73xx: fix NET_DSA and OF
 dependencies
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190709185626.3275510-1-arnd@arndb.de>
References: <20190709185626.3275510-1-arnd@arndb.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 09 Jul 2019 13:20:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Tue,  9 Jul 2019 20:55:55 +0200

> The restructuring of the driver got the dependencies wrong: without
> CONFIG_NET_DSA we get this build failure:
> 
> WARNING: unmet direct dependencies detected for NET_DSA_VITESSE_VSC73XX
>   Depends on [n]: NETDEVICES [=y] && HAVE_NET_DSA [=y] && OF [=y] && NET_DSA [=n]
>   Selected by [m]:
>   - NET_DSA_VITESSE_VSC73XX_PLATFORM [=m] && NETDEVICES [=y] && HAVE_NET_DSA [=y] && HAS_IOMEM [=y]
> 
> ERROR: "dsa_unregister_switch" [drivers/net/dsa/vitesse-vsc73xx-core.ko] undefined!
> ERROR: "dsa_switch_alloc" [drivers/net/dsa/vitesse-vsc73xx-core.ko] undefined!
> ERROR: "dsa_register_switch" [drivers/net/dsa/vitesse-vsc73xx-core.ko] undefined!
> 
> Add the appropriate dependencies.
> 
> Fixes: 95711cd5f0b4 ("net: dsa: vsc73xx: Split vsc73xx driver")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Applied, thanks Arnd.
