Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE282247DE
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 03:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728535AbgGRBoB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 21:44:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbgGRBoA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 21:44:00 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE765C0619D2;
        Fri, 17 Jul 2020 18:44:00 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6B10911E45914;
        Fri, 17 Jul 2020 18:44:00 -0700 (PDT)
Date:   Fri, 17 Jul 2020 18:43:59 -0700 (PDT)
Message-Id: <20200717.184359.1727120553942218221.davem@davemloft.net>
To:     zhangchangzhong@huawei.com
Cc:     mark.einon@gmail.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: ethernet: et131x: Remove unused variable
 'pm_csr'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1594982010-30679-1-git-send-email-zhangchangzhong@huawei.com>
References: <1594982010-30679-1-git-send-email-zhangchangzhong@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 17 Jul 2020 18:44:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com>
Date: Fri, 17 Jul 2020 18:33:30 +0800

> Gcc report warning as follows:
> 
> drivers/net/ethernet/agere/et131x.c:953:6: warning:
>  variable 'pm_csr' set but not used [-Wunused-but-set-variable]
>   953 |  u32 pm_csr;
>       |      ^~~~~~
> drivers/net/ethernet/agere/et131x.c:1002:6:warning:
>  variable 'pm_csr' set but not used [-Wunused-but-set-variable]
>  1002 |  u32 pm_csr;
>       |      ^~~~~~
> drivers/net/ethernet/agere/et131x.c:3446:8: warning:
>  variable 'pm_csr' set but not used [-Wunused-but-set-variable]
>  3446 |    u32 pm_csr;
>       |        ^~~~~~
> 
> After commit 38df6492eb51 ("et131x: Add PCIe gigabit ethernet driver
> et131x to drivers/net"), 'pm_csr' is never used in these functions,
> so removing it to avoid build warning.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>

Applied.
