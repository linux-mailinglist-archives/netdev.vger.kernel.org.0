Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 971372FF9E2
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 02:22:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbhAVBV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 20:21:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:46734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726073AbhAVBVN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 20:21:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 8D66723A03;
        Fri, 22 Jan 2021 01:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611278431;
        bh=fbecSmYeHxHCroeCOGgFNYem1DKPQIkrO8ARATspZx0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lB8KBK5Gn10Z7X5rroEs9T1iiWqUaKXqI5pqROH5zqUbUymLuDrOkzfdCgetz4QEd
         tRqm4hJCwoj3ZdKB0S0XI74QGV1/KmnQklZAf5yb+Ds5YYMyJlSqgrBtNsRGQMvnuD
         cz6WuuaITM73bVp0dd6fxzra+y7OWNTNWQbXw9b2iq27Xy2BT3bS7Gm0gIWuV5SBdX
         jyJUqeD+1L0y87dSZNGrYspzogVsqWaA3rIGHP54zaQgP4KnB88a44R6CbsKf2bdvZ
         947VeoK2OFUcv92bwfZ77Rus1r1h3A04kSqBogdalw5dmgvvXqLVnrG32Gddr528M7
         BJ57UDp3JrKEA==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 801A860671;
        Fri, 22 Jan 2021 01:20:31 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] cxgb4: Assign boolean values to a bool variable
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161127843152.8998.1245179361067012074.git-patchwork-notify@kernel.org>
Date:   Fri, 22 Jan 2021 01:20:31 +0000
References: <1611126111-22079-1-git-send-email-abaci-bugfix@linux.alibaba.com>
In-Reply-To: <1611126111-22079-1-git-send-email-abaci-bugfix@linux.alibaba.com>
To:     Yang Li <abaci-bugfix@linux.alibaba.com>
Cc:     rajur@chelsio.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 20 Jan 2021 15:01:51 +0800 you wrote:
> Fix the following coccicheck warnings:
> 
> ./drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c:5142:2-33:
> WARNING: Assignment of 0/1 to bool variable.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
> 
> [...]

Here is the summary with links:
  - cxgb4: Assign boolean values to a bool variable
    https://git.kernel.org/netdev/net-next/c/fdb6b338d2e5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


