Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFC3AE28FB
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 05:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392932AbfJXDnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 23:43:13 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41544 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390576AbfJXDnN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 23:43:13 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::b7e])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6796C14B7A921;
        Wed, 23 Oct 2019 20:43:12 -0700 (PDT)
Date:   Wed, 23 Oct 2019 20:43:11 -0700 (PDT)
Message-Id: <20191023.204311.1181447784152558295.davem@davemloft.net>
To:     rentao.bupt@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, olteanv@gmail.com,
        arun.parameswaran@broadcom.com, justinpopo6@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        openbmc@lists.ozlabs.org
Subject: Re: [PATCH net-next v10 0/3] net: phy: support 1000Base-X
 auto-negotiation for BCM54616S
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191022183108.14029-1-rentao.bupt@gmail.com>
References: <20191022183108.14029-1-rentao.bupt@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 23 Oct 2019 20:43:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: rentao.bupt@gmail.com
Date: Tue, 22 Oct 2019 11:31:05 -0700

> From: Tao Ren <rentao.bupt@gmail.com>
> 
> This patch series aims at supporting auto negotiation when BCM54616S is
> running in 1000Base-X mode: without the patch series, BCM54616S PHY driver
> would report incorrect link speed in 1000Base-X mode.
> 
> Patch #1 (of 3) modifies assignment to OR when dealing with dev_flags in
> phy_attach_direct function, so that dev_flags updated in BCM54616S PHY's
> probe callback won't be lost.
> 
> Patch #2 (of 3) adds several genphy_c37_* functions to support clause 37
> 1000Base-X auto-negotiation, and these functions are called in BCM54616S
> PHY driver.
> 
> Patch #3 (of 3) detects BCM54616S PHY's operation mode and calls according
> genphy_c37_* functions to configure auto-negotiation and parse link
> attributes (speed, duplex, and etc.) in 1000Base-X mode.

Series applied to net-next, thank you.
