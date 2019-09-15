Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48FE3B317B
	for <lists+netdev@lfdr.de>; Sun, 15 Sep 2019 20:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbfIOSvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Sep 2019 14:51:53 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40054 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726595AbfIOSvw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Sep 2019 14:51:52 -0400
Received: from localhost (93-63-141-166.ip28.fastwebnet.it [93.63.141.166])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 99A15153E82EC;
        Sun, 15 Sep 2019 11:51:50 -0700 (PDT)
Date:   Sun, 15 Sep 2019 19:51:49 +0100 (WEST)
Message-Id: <20190915.195149.86866545205816280.davem@davemloft.net>
To:     alexandru.ardelean@analog.com
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com
Subject: Re: [PATCH v2] net: stmmac: socfpga: re-use the `interface`
 parameter from platform data
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190912132850.10585-1-alexandru.ardelean@analog.com>
References: <20190912132850.10585-1-alexandru.ardelean@analog.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 15 Sep 2019 11:51:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexandru Ardelean <alexandru.ardelean@analog.com>
Date: Thu, 12 Sep 2019 16:28:50 +0300

> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
> index c141fe783e87..5b6213207c43 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
 ...
> +static inline int socfpga_get_plat_phymode(struct socfpga_dwmac *dwmac)

Please do not use the inline keyword in foo.c files, let the compiler device.
