Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 694A42696D8
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 22:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726093AbgINUmi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 16:42:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725951AbgINUm3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 16:42:29 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E4FEC06174A;
        Mon, 14 Sep 2020 13:42:29 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 02F6E12793BE2;
        Mon, 14 Sep 2020 13:25:39 -0700 (PDT)
Date:   Mon, 14 Sep 2020 13:42:26 -0700 (PDT)
Message-Id: <20200914.134226.1104841002281941355.davem@davemloft.net>
To:     zhangchangzhong@huawei.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: dnet: remove unused variable 'tx_status
 'in dnet_start_xmit()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1600088917-21372-1-git-send-email-zhangchangzhong@huawei.com>
References: <1600088917-21372-1-git-send-email-zhangchangzhong@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 14 Sep 2020 13:25:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com>
Date: Mon, 14 Sep 2020 21:08:37 +0800

> Fixes the following W=1 kernel build warning(s):
> 
> drivers/net/ethernet/dnet.c:510:6: warning:
>  variable 'tx_status' set but not used [-Wunused-but-set-variable]
>   u32 tx_status, irq_enable;
>       ^~~~~~~~~
> 
> After commit 4796417417a6 ("dnet: Dave DNET ethernet controller driver
> (updated)"), variable 'tx_status' is never used in dnet_start_xmit(),
> so removing it to avoid build warning.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>

Applied.
