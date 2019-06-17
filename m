Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9D0495D2
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 01:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727419AbfFQXYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 19:24:40 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40000 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbfFQXYj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 19:24:39 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8BDFB151BE539;
        Mon, 17 Jun 2019 16:24:38 -0700 (PDT)
Date:   Mon, 17 Jun 2019 16:24:38 -0700 (PDT)
Message-Id: <20190617.162438.1788457252346173528.davem@davemloft.net>
To:     arnd@arndb.de
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        jpinto@synopsys.com, linux@armlinux.org.uk, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com,
        aaro.koskinen@nokia.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: stmmac: fix unused-variable warning
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190617131327.2227754-1-arnd@arndb.de>
References: <20190617131327.2227754-1-arnd@arndb.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 17 Jun 2019 16:24:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Mon, 17 Jun 2019 15:13:03 +0200

> When building without CONFIG_OF, we get a harmless build warning:
> 
> drivers/net/ethernet/stmicro/stmmac/stmmac_main.c: In function 'stmmac_phy_setup':
> drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:973:22: error: unused variable 'node' [-Werror=unused-variable]
>   struct device_node *node = priv->plat->phy_node;
> 
> Reword it so we always use the local variable, by making it the
> fwnode pointer instead of the device_node.
> 
> Fixes: 74371272f97f ("net: stmmac: Convert to phylink and remove phylib logic")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Applied.
