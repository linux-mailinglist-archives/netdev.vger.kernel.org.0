Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D64AB386C05
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 23:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244959AbhEQVLb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 17:11:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:50852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241700AbhEQVL1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 May 2021 17:11:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A828C6134F;
        Mon, 17 May 2021 21:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621285810;
        bh=FQZCQ8XYOKUzXozLZeUjxiPSV1iWKEamSTWEHxC1RmE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MWkAiiiKUHLfBWYK7LU7ehCgq/KmNBdPzJxfJdk48gsqoU55J8fj11r1TR4FLgk5a
         S1BBf1hcGdYEnY8B5NkiJu1dL1pQsuW2Z+m7N+Rnhn4Lz4SQHdqU0DuIb7SldCrw1Z
         Jb8gtqSpWIqPly6XPnJJAeuII3zp+qt02aS1SxCa4SeWn0JgktWi0ZkUht2TanEuDU
         QA8yzFQQHt3xdbr1s+5V1/J40t/pOgNLcyLuBqjXWFQuDms90SnaM53pHhKtMKAKzS
         IlkSQQs7Ve82xsWgzCWy/6mGYIGGNpjKnJqOyHP7XQldp6rzi8W0eSSKNGxUi3yxLQ
         Ya+Qpzk/X5IhQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A17A160C4C;
        Mon, 17 May 2021 21:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/1] net: bnx2: Fix error return code in bnx2_init_board()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162128581065.6429.15681054044548626866.git-patchwork-notify@kernel.org>
Date:   Mon, 17 May 2021 21:10:10 +0000
References: <20210515071605.7098-1-thunder.leizhen@huawei.com>
In-Reply-To: <20210515071605.7098-1-thunder.leizhen@huawei.com>
To:     Zhen Lei <thunder.leizhen@huawei.com>
Cc:     rmody@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        davem@davemloft.net, kuba@kernel.org, mchan@broadcom.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sat, 15 May 2021 15:16:05 +0800 you wrote:
> Fix to return -EPERM from the error handling case instead of 0, as done
> elsewhere in this function.
> 
> Fixes: b6016b767397 ("[BNX2]: New Broadcom gigabit network driver.")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
> 
> [...]

Here is the summary with links:
  - [1/1] net: bnx2: Fix error return code in bnx2_init_board()
    https://git.kernel.org/netdev/net/c/28c66b6da408

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


