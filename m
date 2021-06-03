Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A16E39ABD2
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 22:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbhFCUbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 16:31:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:42724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229828AbhFCUbt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 16:31:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B615B613F3;
        Thu,  3 Jun 2021 20:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622752204;
        bh=hSPYbZF5vLaJJISjOqyG/CcW5im4LRXpAZcRtkqGCSM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZATuo47RHFf2nMi5VvXkfcSiP7RM+J+tJ63N3vgVl1/Buo+J81KPDM2nALUXKssqo
         SwP71vfV79+o8FyNunRwxKGkfhd2oxRUZTdEnEBI/IgOGpU49eWa8/WdvMWIHd2ihS
         6ZWBi6yTTWAQ2GSk1h05bkmYiSWhKt604Iuu8a16SkoXGGQOii+/JvgX8RqagSDLGB
         wRVrpBthUes57bkHbZ5fEZ2P8HPdUcQxGp9dkrdcKlGFyS/SfOHVOb6XcJcMAHj72e
         whjsetzJO0zpOcFLWids2myF9LCzu+YkpB2YXeheSxk+9LEij+ezYUsVHjKCIooqCs
         RxWK1sgP2cjiQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A7E2660CD2;
        Thu,  3 Jun 2021 20:30:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] rtnetlink: Fix spelling mistakes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162275220468.19203.9416454262822271830.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Jun 2021 20:30:04 +0000
References: <20210602065623.106341-1-zhengyongjun3@huawei.com>
In-Reply-To: <20210602065623.106341-1-zhengyongjun3@huawei.com>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 2 Jun 2021 14:56:23 +0800 you wrote:
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> ---
>  net/core/rtnetlink.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Here is the summary with links:
  - [net-next] rtnetlink: Fix spelling mistakes
    https://git.kernel.org/netdev/net-next/c/d467d0bc7ab8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


