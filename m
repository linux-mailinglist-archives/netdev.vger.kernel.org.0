Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9681238C9
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 22:42:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727667AbfLQVm3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 16:42:29 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:43216 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726764AbfLQVm3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 16:42:29 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E7051145DC505;
        Tue, 17 Dec 2019 13:42:28 -0800 (PST)
Date:   Tue, 17 Dec 2019 13:42:28 -0800 (PST)
Message-Id: <20191217.134228.92517242104749153.davem@davemloft.net>
To:     xiaojiangfeng@huawei.com
Cc:     yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        leeyou.li@huawei.com, nixiaoming@huawei.com
Subject: Re: [PATCH] net: hisilicon: Fix a BUG trigered by wrong bytes_compl
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1576308182-121147-1-git-send-email-xiaojiangfeng@huawei.com>
References: <1576308182-121147-1-git-send-email-xiaojiangfeng@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 17 Dec 2019 13:42:29 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiangfeng Xiao <xiaojiangfeng@huawei.com>
Date: Sat, 14 Dec 2019 15:23:02 +0800

> In addition, I adjusted the position of "count++;"
> to make the code more readable.

This is an unrelated cleanup and should not be done in the same change
as your bug fix, submit this if you like for net-next after net has next
been merged into net-next.

> 
> Signed-off-by: Jiangfeng Xiao <xiaojiangfeng@huawei.com>

You need to provide an appropriate Fixes: tag.
