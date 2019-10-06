Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55963CD390
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 18:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbfJFQfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 12:35:05 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45164 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbfJFQfF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Oct 2019 12:35:05 -0400
Received: from localhost (unknown [8.46.76.29])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 59D98145DC50D;
        Sun,  6 Oct 2019 09:34:55 -0700 (PDT)
Date:   Sun, 06 Oct 2019 18:34:51 +0200 (CEST)
Message-Id: <20191006.183451.484972979524930992.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     santosh.shilimkar@oracle.com, ka-cheong.poon@oracle.com,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net/rds: Add missing include file
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191006070832.55532-1-yuehaibing@huawei.com>
References: <20191006070832.55532-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 06 Oct 2019 09:35:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Sun, 6 Oct 2019 15:08:32 +0800

> Fix build error:
> 
> net/rds/ib_cm.c: In function rds_dma_hdrs_alloc:
> net/rds/ib_cm.c:475:13: error: implicit declaration of function dma_pool_zalloc; did you mean mempool_alloc? [-Werror=implicit-function-declaration]
>    hdrs[i] = dma_pool_zalloc(pool, GFP_KERNEL, &hdr_daddrs[i]);
>              ^~~~~~~~~~~~~~~
>              mempool_alloc
> 
> net/rds/ib.c: In function rds_ib_dev_free:
> net/rds/ib.c:111:3: error: implicit declaration of function dma_pool_destroy; did you mean mempool_destroy? [-Werror=implicit-function-declaration]
>    dma_pool_destroy(rds_ibdev->rid_hdrs_pool);
>    ^~~~~~~~~~~~~~~~
>    mempool_destroy
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Fixes: 9b17f5884be4 ("net/rds: Use DMA memory pool allocation for rds_header")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied.
