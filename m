Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B789F991E
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 19:51:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727128AbfKLSv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 13:51:29 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47630 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbfKLSv2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 13:51:28 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BCA45154CC59B;
        Tue, 12 Nov 2019 10:51:27 -0800 (PST)
Date:   Tue, 12 Nov 2019 10:51:24 -0800 (PST)
Message-Id: <20191112.105124.1905938227505046893.davem@davemloft.net>
To:     maowenan@huawei.com
Cc:     andrew@lunn.ch, grygorii.strashko@ti.com, tony@atomide.com,
        brouer@redhat.com, jakub.kicinski@netronome.com,
        ivan.khoronzhuk@linaro.org, tglx@linutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH -next] net: ethernet: ti: Add dependency for
 TI_DAVINCI_EMAC
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191112063358.73800-1-maowenan@huawei.com>
References: <20191112063358.73800-1-maowenan@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 12 Nov 2019 10:51:28 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mao Wenan <maowenan@huawei.com>
Date: Tue, 12 Nov 2019 14:33:58 +0800

> If TI_DAVINCI_EMAC=y and GENERIC_ALLOCATOR is not set,
> below erros can be seen:
> drivers/net/ethernet/ti/davinci_cpdma.o: In function `cpdma_desc_pool_destroy.isra.14':
> davinci_cpdma.c:(.text+0x359): undefined reference to `gen_pool_size'
> davinci_cpdma.c:(.text+0x365): undefined reference to `gen_pool_avail'
> davinci_cpdma.c:(.text+0x373): undefined reference to `gen_pool_avail'
> davinci_cpdma.c:(.text+0x37f): undefined reference to `gen_pool_size'
> drivers/net/ethernet/ti/davinci_cpdma.o: In function `__cpdma_chan_free':
> davinci_cpdma.c:(.text+0x4a2): undefined reference to `gen_pool_free_owner'
> drivers/net/ethernet/ti/davinci_cpdma.o: In function `cpdma_chan_submit_si':
> davinci_cpdma.c:(.text+0x66c): undefined reference to `gen_pool_alloc_algo_owner'
> davinci_cpdma.c:(.text+0x805): undefined reference to `gen_pool_free_owner'
> drivers/net/ethernet/ti/davinci_cpdma.o: In function `cpdma_ctlr_create':
> davinci_cpdma.c:(.text+0xabd): undefined reference to `devm_gen_pool_create'
> davinci_cpdma.c:(.text+0xb79): undefined reference to `gen_pool_add_owner'
> drivers/net/ethernet/ti/davinci_cpdma.o: In function `cpdma_check_free_tx_desc':
> davinci_cpdma.c:(.text+0x16c6): undefined reference to `gen_pool_avail'
> 
> This patch mades TI_DAVINCI_EMAC select GENERIC_ALLOCATOR.
> 
> Fixes: 99f629718272 ("net: ethernet: ti: cpsw: drop TI_DAVINCI_CPDMA config option")
> Signed-off-by: Mao Wenan <maowenan@huawei.com>

Applied.
