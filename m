Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A20912066D4
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 00:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389496AbgFWWCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 18:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387709AbgFWWCo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 18:02:44 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 664D7C061573;
        Tue, 23 Jun 2020 15:02:44 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CAACA1294A149;
        Tue, 23 Jun 2020 15:02:43 -0700 (PDT)
Date:   Tue, 23 Jun 2020 15:02:43 -0700 (PDT)
Message-Id: <20200623.150243.580522101088235218.davem@davemloft.net>
To:     dmurphy@ti.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        robh@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v10 2/5] net: phy: Add a helper to return the
 index for of the internal delay
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200623134836.21981-3-dmurphy@ti.com>
References: <20200623134836.21981-1-dmurphy@ti.com>
        <20200623134836.21981-3-dmurphy@ti.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 23 Jun 2020 15:02:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Murphy <dmurphy@ti.com>
Date: Tue, 23 Jun 2020 08:48:33 -0500

> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 29ef4456ac25..96f242eed058 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
 ...
> +static inline int phy_get_int_delay_property(struct device *dev,
> +					     const char *name)

Please do not use inline in foo.c files, thank you.
