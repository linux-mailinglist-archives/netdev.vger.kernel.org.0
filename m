Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55B5B26E988
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 01:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726007AbgIQXkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 19:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbgIQXkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 19:40:13 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D133C061756
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 16:40:13 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BED3213662498;
        Thu, 17 Sep 2020 16:23:25 -0700 (PDT)
Date:   Thu, 17 Sep 2020 16:40:11 -0700 (PDT)
Message-Id: <20200917.164011.166801140665121114.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        kuba@kernel.org
Subject: Re: [PATCH net-next 1/2] net: mdio: mdio-bcm-unimac: Turn on PHY
 clock before dummy read
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200916204415.1831417-2-f.fainelli@gmail.com>
References: <20200916204415.1831417-1-f.fainelli@gmail.com>
        <20200916204415.1831417-2-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 17 Sep 2020 16:23:26 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Wed, 16 Sep 2020 13:44:14 -0700

> @@ -160,6 +160,7 @@ static int unimac_mdio_reset(struct mii_bus *bus)
>  {
>  	struct device_node *np = bus->dev.of_node;
>  	struct device_node *child;
> +	struct clk *clk;
>  	u32 read_mask = 0;
>  	int addr;

Please preserve the reverse christmas tree ordering of these local
variables, thank you.
