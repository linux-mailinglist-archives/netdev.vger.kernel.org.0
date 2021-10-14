Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3D042D08B
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 04:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbhJNCmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 22:42:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:44924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229496AbhJNCmL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 22:42:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0B6E961163;
        Thu, 14 Oct 2021 02:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634179207;
        bh=D4v/WuqUQPyP3XMTAZYiOB3Kiq4gQ+TObMUivr4wW44=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iuf5xofz/XVFxcGvwmh+Cx0348gYmipExiPLWqxo7gCf8YZGqDQavR10X9tLrGa/0
         jNFf+fZiYq/nSjF/hirx4GUSkFa50RV2YdmjHzR2gVL//GyMTQyiIVx3zTzw7ICkJM
         n/ZSuFFcjDOy+D4OztDST7+MV5fZjUGkyEddHGajEk3hrpCe9bBTmxHLeDUasMUy+b
         cC9LiV1tSEzY8B6jWXxlRYYCoe7gxwg2g9HPr3QkTGy1BUWpB/v2vs/4qLnsyLvNNm
         7u8akL32lyGpEDQhrHQzh5D6NPBDa/XzOcaJQVNLXMDzQoNUljmwiiNKcZqRAecp7H
         9g7Z4CTNzzrlg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F18CC609EF;
        Thu, 14 Oct 2021 02:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: delete redundant function declaration
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163417920698.26736.14312403568955020812.git-patchwork-notify@kernel.org>
Date:   Thu, 14 Oct 2021 02:40:06 +0000
References: <20211013094702.3931071-1-chenwandun@huawei.com>
In-Reply-To: <20211013094702.3931071-1-chenwandun@huawei.com>
To:     Chen Wandun <chenwandun@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, dsa@cumulusnetworks.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        wangkefeng.wang@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 13 Oct 2021 17:47:02 +0800 you wrote:
> The implement of function netdev_all_upper_get_next_dev_rcu has been
> removed in:
> 	commit f1170fd462c6 ("net: Remove all_adj_list and its references")
> so delete redundant declaration in header file.
> 
> Fixes: f1170fd462c6 ("net: Remove all_adj_list and its references")
> Signed-off-by: Chen Wandun <chenwandun@huawei.com>
> 
> [...]

Here is the summary with links:
  - net: delete redundant function declaration
    https://git.kernel.org/netdev/net-next/c/9974cb5c8790

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


