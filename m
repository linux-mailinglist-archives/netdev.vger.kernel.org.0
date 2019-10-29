Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEB7FE8EF5
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 19:06:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730725AbfJ2SGT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 14:06:19 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57756 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726594AbfJ2SGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 14:06:19 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2C95F14CFC095;
        Tue, 29 Oct 2019 11:06:18 -0700 (PDT)
Date:   Tue, 29 Oct 2019 11:06:17 -0700 (PDT)
Message-Id: <20191029.110617.1405330302630427488.davem@davemloft.net>
To:     xiaojiangfeng@huawei.com
Cc:     yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        leeyou.li@huawei.com, zhanghan23@huawei.com, nixiaoming@huawei.com
Subject: Re: [PATCH] net: hisilicon: Fix "Trying to free already-free IRQ"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1572011302-48605-1-git-send-email-xiaojiangfeng@huawei.com>
References: <1572011302-48605-1-git-send-email-xiaojiangfeng@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 29 Oct 2019 11:06:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiangfeng Xiao <xiaojiangfeng@huawei.com>
Date: Fri, 25 Oct 2019 21:48:22 +0800

> When rmmod hip04_eth.ko, we can get the following warning:
 ...
> Currently "rmmod hip04_eth.ko" call free_irq more than once
> as devres_release_all and hip04_remove both call free_irq.
> This results in a 'Trying to free already-free IRQ' warning.
> To solve the problem free_irq has been moved out of hip04_remove.
> 
> Signed-off-by: Jiangfeng Xiao <xiaojiangfeng@huawei.com>

Applied, thank you.
