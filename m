Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5CEE3ABBF5
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 20:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233291AbhFQSmW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 14:42:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:51776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232270AbhFQSmO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 14:42:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id EB6D3613FA;
        Thu, 17 Jun 2021 18:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623955206;
        bh=tu8vo2m2Z5AYvkCpyO8TGhwltuDaX6bzoZO/CTXwI34=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RJx1RYyGdYEk9TLi6Ch0vOs/5KjIF26E8ZinK7fUu5qAMtm3hdHKI7pfkrUvwqj5b
         +/OW8rmeuAJrzZni5HSyWgIBJsCFkeDYvHLrhAFpslnAyKkpyKbew+JYnXPm8ORtWJ
         8e0rNZcQmNOdLjUsKHTPBFaxpNWybIFNt3iOhzzZShWAEiePBe+h2xokbWMEvoxfLt
         Z5+8B5ZQ3BuvN2Sjkd5h4ZCWrWHqv73oiOUBTHAwvzPMf6GqdHPq8Cp/v4pJEQvAsA
         KOKi9/0B8knmNw8ceYmjW3wEoEc8FbrmdOv3sGyRBjC3ht/BXqbIEDL0ciw8OM3F6X
         J+qTKMjujtl0w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E18FF609EA;
        Thu, 17 Jun 2021 18:40:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: sched: fix error return code in
 tcf_del_walker()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162395520591.2276.12208043961160895460.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Jun 2021 18:40:05 +0000
References: <20210617080207.1346017-1-yangyingliang@huawei.com>
In-Reply-To: <20210617080207.1346017-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 17 Jun 2021 16:02:07 +0800 you wrote:
> When nla_put_u32() fails, 'ret' could be 0, it should
> return error code in tcf_del_walker().
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  net/sched/act_api.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] net: sched: fix error return code in tcf_del_walker()
    https://git.kernel.org/netdev/net-next/c/55d96f72e8dd

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


