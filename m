Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6542C455AC8
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 12:41:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344221AbhKRLoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 06:44:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:60588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344263AbhKRLnN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 06:43:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 922D061B04;
        Thu, 18 Nov 2021 11:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637235610;
        bh=qKmAo3V0HDp38cwkHV4vrgKqEIb5IOhIJTJ/rZB668c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lBVW1jkJnwIwV5rLQTC8a2MwAuXHdQc33OW+Vyx+weW37MIasU8h29BD6+4x4QJRM
         X5DDHUgjoP0Cuaf9praAMXTbT48BfAE8gGwAVHPx1kfWY+3AhFn6JZounfq94tQWr/
         D3MBQJbFVc9RVqo3nWp2NfGEusaEaabAP7BmfJa7XSBaX+CHEGDKM1dlth4bOuh9bs
         6yL6SvDt3Mai0lyxwWQbVac9y/xA/wgU7lCZHjli0Ee4DFxgtS7iVSCkS/DE081JbT
         iQfB/7Brpe5WzEXmwVZiF3rIg0IuvcQvIaXDfTkWWLKawTxYt6eW0eFNyaztwuAVGZ
         OG2djo/4nQJlg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8258B60A94;
        Thu, 18 Nov 2021 11:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] page_pool: Revert "page_pool: disable dma mapping
 support..."
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163723560952.11739.1415863024804247853.git-patchwork-notify@kernel.org>
Date:   Thu, 18 Nov 2021 11:40:09 +0000
References: <20211117075652.58299-1-linyunsheng@huawei.com>
In-Reply-To: <20211117075652.58299-1-linyunsheng@huawei.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@openeuler.org,
        hawk@kernel.org, ilias.apalodimas@linaro.org,
        akpm@linux-foundation.org, peterz@infradead.org, vbabka@suse.cz,
        willy@infradead.org, will@kernel.org, feng.tang@intel.com,
        jgg@ziepe.ca, ebiederm@xmission.com, aarcange@redhat.com,
        guillaume.tucker@collabora.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 17 Nov 2021 15:56:52 +0800 you wrote:
> This reverts commit d00e60ee54b12de945b8493cf18c1ada9e422514.
> 
> As reported by Guillaume in [1]:
> Enabling LPAE always enables CONFIG_ARCH_DMA_ADDR_T_64BIT
> in 32-bit systems, which breaks the bootup proceess when a
> ethernet driver is using page pool with PP_FLAG_DMA_MAP flag.
> As we were hoping we had no active consumers for such system
> when we removed the dma mapping support, and LPAE seems like
> a common feature for 32 bits system, so revert it.
> 
> [...]

Here is the summary with links:
  - [net] page_pool: Revert "page_pool: disable dma mapping support..."
    https://git.kernel.org/netdev/net/c/f915b75bffb7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


