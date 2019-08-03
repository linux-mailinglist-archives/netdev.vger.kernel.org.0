Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17514803AB
	for <lists+netdev@lfdr.de>; Sat,  3 Aug 2019 03:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388906AbfHCBPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 21:15:39 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53096 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387606AbfHCBPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 21:15:39 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 02B6E12B88C0D;
        Fri,  2 Aug 2019 18:15:38 -0700 (PDT)
Date:   Fri, 02 Aug 2019 18:15:38 -0700 (PDT)
Message-Id: <20190802.181538.1597809800435251162.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     claudiu.manoil@nxp.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] enetc: Select PHYLIB while CONFIG_FSL_ENETC_VF is set
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190801012419.9728-1-yuehaibing@huawei.com>
References: <20190801012419.9728-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 02 Aug 2019 18:15:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Thu, 1 Aug 2019 09:24:19 +0800

> Like FSL_ENETC, when CONFIG_FSL_ENETC_VF is set,
> we should select PHYLIB, otherwise building still fails:
> 
> drivers/net/ethernet/freescale/enetc/enetc.o: In function `enetc_open':
> enetc.c:(.text+0x2744): undefined reference to `phy_start'
> enetc.c:(.text+0x282c): undefined reference to `phy_disconnect'
> drivers/net/ethernet/freescale/enetc/enetc.o: In function `enetc_close':
> enetc.c:(.text+0x28f8): undefined reference to `phy_stop'
> enetc.c:(.text+0x2904): undefined reference to `phy_disconnect'
> drivers/net/ethernet/freescale/enetc/enetc_ethtool.o:(.rodata+0x3f8): undefined reference to `phy_ethtool_get_link_ksettings'
> drivers/net/ethernet/freescale/enetc/enetc_ethtool.o:(.rodata+0x400): undefined reference to `phy_ethtool_set_link_ksettings'
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Fixes: d4fd0404c1c9 ("enetc: Introduce basic PF and VF ENETC ethernet drivers")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied.
