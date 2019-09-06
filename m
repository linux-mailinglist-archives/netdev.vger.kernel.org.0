Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E335FAB8D8
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 15:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405045AbfIFNF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 09:05:28 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59858 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387851AbfIFNF2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 09:05:28 -0400
Received: from localhost (unknown [88.214.184.128])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7A4E9152F5C9F;
        Fri,  6 Sep 2019 06:05:26 -0700 (PDT)
Date:   Fri, 06 Sep 2019 15:05:24 +0200 (CEST)
Message-Id: <20190906.150524.1245097015817848153.davem@davemloft.net>
To:     maowenan@huawei.com
Cc:     eric.dumazet@gmail.com, tsbogend@alpha.franken.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2 net] net: sonic: return NETDEV_TX_OK if failed to
 map buffer
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190905015712.107173-1-maowenan@huawei.com>
References: <960c7d1f-6e80-84fb-8d7a-9c5692605500@huawei.com>
        <20190905015712.107173-1-maowenan@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 06 Sep 2019 06:05:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mao Wenan <maowenan@huawei.com>
Date: Thu, 5 Sep 2019 09:57:12 +0800

> NETDEV_TX_BUSY really should only be used by drivers that call
> netif_tx_stop_queue() at the wrong moment. If dma_map_single() is
> failed to map tx DMA buffer, it might trigger an infinite loop.
> This patch use NETDEV_TX_OK instead of NETDEV_TX_BUSY, and change
> printk to pr_err_ratelimited.
> 
> Fixes: d9fb9f384292 ("*sonic/natsemi/ns83829: Move the National Semi-conductor drivers")
> Signed-off-by: Mao Wenan <maowenan@huawei.com>

Applied.
