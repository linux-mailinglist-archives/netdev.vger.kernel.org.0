Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF34E3A35A9
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 23:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbhFJVMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 17:12:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:47582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231301AbhFJVMF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 17:12:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CB238613E9;
        Thu, 10 Jun 2021 21:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623359404;
        bh=tVVdvnzs56h4G7xaeqkj3z22aI0XP8c1DM0oUChUlnM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EceDoQF+ajbcv5qh3giEhCKuqimoIOjVzbFKS0ePsAwPb2zAL2AyHnbTo6bHqmssn
         XyoNvePOTveeBf3UCQjKml7kM7nsMCyw1V4VbTCIKbgQgX8vBTXeui8DGD3DcVMCDp
         1Sc4xeDYw9UoAJ8IMAIev9PIZxY4K5GPIWewcEimhbgjpL7THkPXnmIrZfPSSzN5NU
         oLkdJrAnw7VMcxRZEhb6LqWwShDqd/8M6fxXPbhiBsCGNMofO61u9WA0x8g+FCb/Hn
         mfZniZLu0lprHdE7saT4LLcGyuwFof70yh68py5tX9gVBgL5TNAwfd+evGlc+cu0wG
         T7s+zlylHsoYw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BF40860BE2;
        Thu, 10 Jun 2021 21:10:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] atm: Use list_for_each_entry() to simplify code in
 resources.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162335940477.9889.12199816567874980870.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Jun 2021 21:10:04 +0000
References: <20210610130355.3836817-1-wanghai38@huawei.com>
In-Reply-To: <20210610130355.3836817-1-wanghai38@huawei.com>
To:     Wang Hai <wanghai38@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, gustavoars@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 10 Jun 2021 21:03:55 +0800 you wrote:
> Convert list_for_each() to list_for_each_entry() where
> applicable. This simplifies the code.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> ---
>  net/atm/resources.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)

Here is the summary with links:
  - [net-next] atm: Use list_for_each_entry() to simplify code in resources.c
    https://git.kernel.org/netdev/net-next/c/73e42909ef2d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


