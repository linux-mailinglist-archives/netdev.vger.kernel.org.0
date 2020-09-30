Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91A6E27F4C8
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 00:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731120AbgI3WEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 18:04:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729912AbgI3WEq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 18:04:46 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B139C061755;
        Wed, 30 Sep 2020 15:04:46 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7BA2813C732B2;
        Wed, 30 Sep 2020 14:47:57 -0700 (PDT)
Date:   Wed, 30 Sep 2020 15:04:44 -0700 (PDT)
Message-Id: <20200930.150444.873057805906589762.davem@davemloft.net>
To:     calvin.johnson@oss.nxp.com
Cc:     grant.likely@arm.com, rafael@kernel.org, jeremy.linton@arm.com,
        andrew@lunn.ch, andy.shevchenko@gmail.com, f.fainelli@gmail.com,
        linux@armlinux.org.uk, cristian.sovaiala@nxp.com,
        florinlaurentiu.chiculita@nxp.com, ioana.ciornei@nxp.com,
        madalin.bucur@oss.nxp.com, heikki.krogerus@linux.intel.com,
        linux-kernel@vger.kernel.org, linux.cj@gmail.com,
        netdev@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, diana.craciun@nxp.com,
        laurentiu.tudor@nxp.com, kuba@kernel.org
Subject: Re: [net-next PATCH v1 7/7] net/fsl: Use _ADR ACPI object to
 register PHYs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200930160430.7908-8-calvin.johnson@oss.nxp.com>
References: <20200930160430.7908-1-calvin.johnson@oss.nxp.com>
        <20200930160430.7908-8-calvin.johnson@oss.nxp.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 30 Sep 2020 14:47:58 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Calvin Johnson <calvin.johnson@oss.nxp.com>
Date: Wed, 30 Sep 2020 21:34:30 +0530

> @@ -248,6 +250,10 @@ static int xgmac_mdio_probe(struct platform_device *pdev)
>  	struct resource *res;
>  	struct mdio_fsl_priv *priv;
>  	int ret;
> +	struct fwnode_handle *fwnode;
> +	struct fwnode_handle *child;
> +	unsigned long long addr;
> +	acpi_status status;
>  

Reverse chrstimas tree here too, please.
