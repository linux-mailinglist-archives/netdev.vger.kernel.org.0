Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E560E93C2
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 00:35:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbfJ2XfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 19:35:02 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:32958 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725974AbfJ2XfC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 19:35:02 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8B4F414EBDEA6;
        Tue, 29 Oct 2019 16:35:01 -0700 (PDT)
Date:   Tue, 29 Oct 2019 16:35:00 -0700 (PDT)
Message-Id: <20191029.163500.1140263160760085187.davem@davemloft.net>
To:     xiaojiangfeng@huawei.com
Cc:     yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        leeyou.li@huawei.com, zhanghan23@huawei.com, nixiaoming@huawei.com,
        zhangqiang.cn@hisilicon.com, dingjingcheng@hisilicon.com,
        joe@perches.com
Subject: Re: [PATCH v2] net: hisilicon: Fix ping latency when deal with
 high throughput
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1572239386-67767-1-git-send-email-xiaojiangfeng@huawei.com>
References: <1572239386-67767-1-git-send-email-xiaojiangfeng@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 29 Oct 2019 16:35:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiangfeng Xiao <xiaojiangfeng@huawei.com>
Date: Mon, 28 Oct 2019 13:09:46 +0800

> This is due to error in over budget processing.
> When dealing with high throughput, the used buffers
> that exceeds the budget is not cleaned up. In addition,
> it takes a lot of cycles to clean up the used buffer,
> and then the buffer where the valid data is located can take effect.
> 
> Signed-off-by: Jiangfeng Xiao <xiaojiangfeng@huawei.com>

Applied and queued up for -stable, thanks.
