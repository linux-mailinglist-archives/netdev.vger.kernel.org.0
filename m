Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56E0F3A354D
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 23:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbhFJVCJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 17:02:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:44286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230280AbhFJVCD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 17:02:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 41DB261407;
        Thu, 10 Jun 2021 21:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623358807;
        bh=j3Fg/2KkrA3YJIojxPi8cc0hvXTKXJx5IHHfvyYfnlc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hI5xJYMWPvUFvOj1JFmYWiSCIxpVKrYxfE51YTYNUH++n9PED1Sb/u+UOgICRGR+v
         Iv+itttNdJrJzi4zSms9DDFrhHQTRwMeOP0ppu1d08B5rhUf1F4fmbZcp5ZvIPgZT9
         h6CJnzIuq+NQQIRn6fHfuF6uX1GNwS6Dmsy4scyKM/dXTKq4+OthrLRWHM2M2ubxsg
         QCxr6CovY6B8UO9YTKhxbDvRAeUaVYH9CLDrUZtWIfWCZr7+jhdmLH3Qd0Grz1ioJy
         eShQLLjm3LJvq8Qii9TXBY5bo3nAT0w4vVrPPiIcSMBAr1hRpDCQb8BxVlUi4qqyeB
         N7BFqlpkQUdYA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 33D0560D02;
        Thu, 10 Jun 2021 21:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] fjes: check return value after calling
 platform_get_resource()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162335880720.5408.916608200329009216.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Jun 2021 21:00:07 +0000
References: <20210610080243.4097179-1-yangyingliang@huawei.com>
In-Reply-To: <20210610080243.4097179-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 10 Jun 2021 16:02:43 +0800 you wrote:
> It will cause null-ptr-deref if platform_get_resource() returns NULL,
> we need check the return value.
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/net/fjes/fjes_main.c | 4 ++++
>  1 file changed, 4 insertions(+)

Here is the summary with links:
  - [net-next] fjes: check return value after calling platform_get_resource()
    https://git.kernel.org/netdev/net-next/c/f18c11812c94

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


