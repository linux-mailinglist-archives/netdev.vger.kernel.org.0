Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA0D206AAC
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 05:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388609AbgFXDfe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 23:35:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388187AbgFXDfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 23:35:34 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55C0EC061573
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 20:35:34 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1772E1298633D;
        Tue, 23 Jun 2020 20:35:33 -0700 (PDT)
Date:   Tue, 23 Jun 2020 20:35:32 -0700 (PDT)
Message-Id: <20200623.203532.1200313050837222995.davem@davemloft.net>
To:     calvin.johnson@oss.nxp.com
Cc:     jeremy.linton@arm.com, linux@armlinux.org.uk, jon@solid-run.com,
        cristian.sovaiala@nxp.com, ioana.ciornei@nxp.com, andrew@lunn.ch,
        andy.shevchenko@gmail.com, f.fainelli@gmail.com,
        madalin.bucur@oss.nxp.com, netdev@vger.kernel.org,
        linux.cj@gmail.com
Subject: Re: [net-next PATCH v3 0/3] ACPI support for xgmac_mdio drivers.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200622150534.27482-1-calvin.johnson@oss.nxp.com>
References: <20200622150534.27482-1-calvin.johnson@oss.nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 23 Jun 2020 20:35:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Calvin Johnson <calvin.johnson@oss.nxp.com>
Date: Mon, 22 Jun 2020 20:35:31 +0530

> This patch series provides ACPI support for xgmac_mdio driver.
> 
> Changes in v3:
> - handle case MDIOBUS_NO_CAP
> 
> Changes in v2:
> - Reserve "0" to mean that no mdiobus capabilities have been declared.
> - bus->id: change to appropriate printk format specifier
> - clean up xgmac_acpi_match
> - clariy platform_get_resource() usage with comments

Series applied to net-next, thanks.
