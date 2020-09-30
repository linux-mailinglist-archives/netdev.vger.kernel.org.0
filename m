Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67B9327F4C3
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 00:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730998AbgI3WDw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 18:03:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730090AbgI3WDv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 18:03:51 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0643C061755;
        Wed, 30 Sep 2020 15:03:51 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6689213C732A9;
        Wed, 30 Sep 2020 14:47:02 -0700 (PDT)
Date:   Wed, 30 Sep 2020 15:03:49 -0700 (PDT)
Message-Id: <20200930.150349.1490001851325231827.davem@davemloft.net>
To:     calvin.johnson@oss.nxp.com
Cc:     grant.likely@arm.com, rafael@kernel.org, jeremy.linton@arm.com,
        andrew@lunn.ch, andy.shevchenko@gmail.com, f.fainelli@gmail.com,
        linux@armlinux.org.uk, cristian.sovaiala@nxp.com,
        florinlaurentiu.chiculita@nxp.com, ioana.ciornei@nxp.com,
        madalin.bucur@oss.nxp.com, heikki.krogerus@linux.intel.com,
        linux-kernel@vger.kernel.org, linux.cj@gmail.com,
        netdev@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, diana.craciun@nxp.com,
        laurentiu.tudor@nxp.com, hkallweit1@gmail.com, kuba@kernel.org
Subject: Re: [net-next PATCH v1 2/7] net: phy: Introduce phy related fwnode
 functions
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200930160430.7908-3-calvin.johnson@oss.nxp.com>
References: <20200930160430.7908-1-calvin.johnson@oss.nxp.com>
        <20200930160430.7908-3-calvin.johnson@oss.nxp.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 30 Sep 2020 14:47:03 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Calvin Johnson <calvin.johnson@oss.nxp.com>
Date: Wed, 30 Sep 2020 21:34:25 +0530

> +struct phy_device *fwnode_phy_find_device(struct fwnode_handle *phy_fwnode)
> +{
> +	struct device *d;
> +	struct mdio_device *mdiodev;

Please use reverse christmas tree ordering for local variables.
