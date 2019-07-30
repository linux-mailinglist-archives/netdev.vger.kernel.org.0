Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7F4E7AFDE
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 19:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728661AbfG3R2w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 13:28:52 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52494 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbfG3R2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 13:28:52 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B7B571239C4CE;
        Tue, 30 Jul 2019 10:28:51 -0700 (PDT)
Date:   Tue, 30 Jul 2019 10:28:51 -0700 (PDT)
Message-Id: <20190730.102851.1996008524459618236.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     claudiu.manoil@nxp.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] enetc: Fix build error without PHYLIB
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190730142959.50892-1-yuehaibing@huawei.com>
References: <20190730142959.50892-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Jul 2019 10:28:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Tue, 30 Jul 2019 22:29:59 +0800

> If PHYLIB is not set, build enetc will fails:
> 
> drivers/net/ethernet/freescale/enetc/enetc.o: In function `enetc_open':
> enetc.c: undefined reference to `phy_disconnect'
> enetc.c: undefined reference to `phy_start'
> drivers/net/ethernet/freescale/enetc/enetc.o: In function `enetc_close':
> enetc.c: undefined reference to `phy_stop'
> enetc.c: undefined reference to `phy_disconnect'
> drivers/net/ethernet/freescale/enetc/enetc_ethtool.o: undefined reference to `phy_ethtool_get_link_ksettings'
> drivers/net/ethernet/freescale/enetc/enetc_ethtool.o: undefined reference to `phy_ethtool_set_link_ksettings'
> drivers/net/ethernet/freescale/enetc/enetc_mdio.o: In function `enetc_mdio_probe':
> enetc_mdio.c: undefined reference to `mdiobus_alloc_size'
> enetc_mdio.c: undefined reference to `mdiobus_free'
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Fixes: d4fd0404c1c9 ("enetc: Introduce basic PF and VF ENETC ethernet drivers")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied.
