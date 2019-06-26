Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5108057281
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 22:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726524AbfFZUX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 16:23:26 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41132 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726320AbfFZUX0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 16:23:26 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3F93214DB846C;
        Wed, 26 Jun 2019 13:23:25 -0700 (PDT)
Date:   Wed, 26 Jun 2019 13:23:24 -0700 (PDT)
Message-Id: <20190626.132324.200411260732636394.davem@davemloft.net>
To:     marex@denx.de
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        linus.walleij@linaro.org, Tristram.Ha@microchip.com,
        Woojung.Huh@microchip.com
Subject: Re: [PATCH V2] net: dsa: microchip: Use gpiod_set_value_cansleep()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190623151257.13660-1-marex@denx.de>
References: <20190623151257.13660-1-marex@denx.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Jun 2019 13:23:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Vasut <marex@denx.de>
Date: Sun, 23 Jun 2019 17:12:57 +0200

> Replace gpiod_set_value() with gpiod_set_value_cansleep(), as the switch
> reset GPIO can be connected to e.g. I2C GPIO expander and it is perfectly
> fine for the kernel to sleep for a bit in ksz_switch_register().
> 
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Tristram Ha <Tristram.Ha@microchip.com>
> Cc: Woojung Huh <Woojung.Huh@microchip.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> ---
> V2: use _cansleep in .remove as well

Applied, thank you.
