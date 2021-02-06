Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C31E2311FA5
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 20:23:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbhBFTVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 14:21:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:53762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230144AbhBFTUs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Feb 2021 14:20:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id AAE7864E3E;
        Sat,  6 Feb 2021 19:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612639207;
        bh=wW+FbUxwsCVkbco/ORrhUoHJbNW9QzicSGO5LUbEGpA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LhQC5NP0Ju5Sbdan+JwLAsG3G9t7CiVJ4ToT493dehRhq/PKCeuUSpD+K2QzmH0Jr
         +35GS4HRRz3U8PJfVcxP+SyE9WJUUQD+w72tmsaphcXBheob9aRLEhye4hYLs9WmUQ
         b5BprkWciA2FiplholDhE6fBqQmF6U9P7iYDwJGhsx63GOKTXv7yFdwO7pbd7mTM5J
         ww8ihjmmHZJ3yd7E84Ps/lgl/v+N+mwvC0IiCzW83ChLsY0NcyxdTB1WWYMg7kuE35
         BI2+BqB6Vvw22MsqI2nNbxKyoPiZckuqhZ1hryBcLb/iAXgS6KzpAeo1reJqtf+yoR
         fsVi5SLjQvIHg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9D6F0609FF;
        Sat,  6 Feb 2021 19:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: sched: Return the correct errno code
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161263920764.23851.13816087138538552364.git-patchwork-notify@kernel.org>
Date:   Sat, 06 Feb 2021 19:20:07 +0000
References: <20210204073950.18372-1-zhengyongjun3@huawei.com>
In-Reply-To: <20210204073950.18372-1-zhengyongjun3@huawei.com>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 4 Feb 2021 15:39:50 +0800 you wrote:
> When kalloc or kmemdup failed, should return ENOMEM rather than ENOBUF.
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> ---
>  net/sched/em_nbyte.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] net: sched: Return the correct errno code
    https://git.kernel.org/netdev/net-next/c/a64566a22b6a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


