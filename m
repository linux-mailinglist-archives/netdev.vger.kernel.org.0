Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90407210045
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 00:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbgF3W6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 18:58:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbgF3W6E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 18:58:04 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 809CDC061755;
        Tue, 30 Jun 2020 15:58:04 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0DA8E127BE238;
        Tue, 30 Jun 2020 15:58:02 -0700 (PDT)
Date:   Tue, 30 Jun 2020 15:58:02 -0700 (PDT)
Message-Id: <20200630.155802.2190042564289803175.davem@davemloft.net>
To:     brgl@bgdev.pl
Cc:     jeffrey.t.kirsher@intel.com, kuba@kernel.org, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        matthias.bgg@gmail.com, hkallweit1@gmail.com, andrew@lunn.ch,
        f.fainelli@gmail.com, linux@armlinux.org.uk, robh+dt@kernel.org,
        frowand.list@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, devicetree@vger.kernel.org,
        bgolaszewski@baylibre.com
Subject: Re: [PATCH v2 00/10] net: improve devres helpers
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200629120346.4382-1-brgl@bgdev.pl>
References: <20200629120346.4382-1-brgl@bgdev.pl>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Jun 2020 15:58:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Mon, 29 Jun 2020 14:03:36 +0200

> From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> 
> So it seems like there's no support for relaxing certain networking devres
> helpers to not require previously allocated structures to also be managed.
> However the way mdio devres variants are implemented is still wrong and I
> modified my series to address it while keeping the functions strict.
> 
> First two patches modify the ixgbe driver to get rid of the last user of
> devm_mdiobus_free().
> 
> Patches 3, 4, 5 and 6 are mostly cosmetic.
> 
> Patch 7 fixes the way devm_mdiobus_register() is implemented.
> 
> Patches 8 & 9 provide a managed variant of of_mdiobus_register() and
> last patch uses it in mtk-star-emac driver.
> 
> v1 -> v2:
> - drop the patch relaxing devm_register_netdev()
> - require struct mii_bus to be managed in devm_mdiobus_register() and
>   devm_of_mdiobus_register() but don't store that information in the
>   structure itself: use devres_find() instead

Series applied, thank you.
