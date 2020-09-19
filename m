Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D38227096B
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 02:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbgISAWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 20:22:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbgISAWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 20:22:20 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAF22C0613CE;
        Fri, 18 Sep 2020 17:22:20 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AD65915B1D06B;
        Fri, 18 Sep 2020 17:05:32 -0700 (PDT)
Date:   Fri, 18 Sep 2020 17:22:18 -0700 (PDT)
Message-Id: <20200918.172218.585529915367078350.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, opendmb@gmail.com, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk, kuba@kernel.org,
        bcm-kernel-feedback-list@broadcom.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: phy: bcm7xxx: request and manage GPHY
 clock
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200917020413.2313461-1-f.fainelli@gmail.com>
References: <20200917020413.2313461-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 18 Sep 2020 17:05:33 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Wed, 16 Sep 2020 19:04:13 -0700

> The internal Gigabit PHY on Broadcom STB chips has a digital clock which
> drives its MDIO interface among other things, the driver now requests
> and manage that clock during .probe() and .remove() accordingly.
> 
> Because the PHY driver can be probed with the clocks turned off we need
> to apply the dummy BMSR workaround during the driver probe function to
> ensure subsequent MDIO read or write towards the PHY will succeed.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
> Changes in v2:
> 
> - localize the changes exclusively within the PHY driver and do not
>   involve the MDIO driver at all. Using the ethernet-phyidAAAA.BBBB
>   compatible string we can get straight to the desired driver without
>   requiring clocks to be assumed on.

Applied and queued up for -stable, thanks.
