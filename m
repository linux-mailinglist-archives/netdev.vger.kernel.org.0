Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF1B51E32B8
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 00:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404383AbgEZWeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 18:34:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389755AbgEZWeS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 18:34:18 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 984F7C061A0F;
        Tue, 26 May 2020 15:34:18 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C19951210A3FB;
        Tue, 26 May 2020 15:34:17 -0700 (PDT)
Date:   Tue, 26 May 2020 15:34:16 -0700 (PDT)
Message-Id: <20200526.153416.2186947205980163126.davem@davemloft.net>
To:     antoine.tenart@bootlin.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        alexandre.belloni@bootlin.com, thomas.petazzoni@bootlin.com,
        allan.nielsen@microchip.com
Subject: Re: [PATCH net-next 0/4] net: phy: mscc-miim: reduce waiting time
 between MDIO transactions
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200526162256.466885-1-antoine.tenart@bootlin.com>
References: <20200526162256.466885-1-antoine.tenart@bootlin.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 26 May 2020 15:34:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Antoine Tenart <antoine.tenart@bootlin.com>
Date: Tue, 26 May 2020 18:22:52 +0200

> This series aims at reducing the waiting time between MDIO transactions
> when using the MSCC MIIM MDIO controller.
> 
> I'm not sure we need patch 4/4 and we could reasonably drop it from the
> series. I'm including the patch as it could help to ensure the system
> is functional with a non optimal configuration.
> 
> We needed to improve the driver's performances as when using a PHY
> requiring lots of registers accesses (such as the VSC85xx family),
> delays would add up and ended up to be quite large which would cause
> issues such as: a slow initialization of the PHY, and issues when using
> timestamping operations (this feature will be sent quite soon to the
> mailing lists).

Series applied, thank you.
