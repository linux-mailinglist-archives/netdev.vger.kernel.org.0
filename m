Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B15136BA5B
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 21:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241712AbhDZTzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 15:55:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:41742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242193AbhDZTy3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Apr 2021 15:54:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1885D61396;
        Mon, 26 Apr 2021 19:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619466827;
        bh=oVk3Y5F3lygGo8zbyIwBiZIqs6TYdRnjB/NaxTXhWBg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kVWV3dpcTi7HY4AB1gkWFSMorpbU+ogS0xWBJRHOBLi1RhEobihH2BPqEmZKdmV2D
         pt68/3yT4yc5ZzGWfHZHke5vp478bGRsXQw0YDAJRB58ZgABCPPKmF6/2xigjJ0/tZ
         VjnOL1ux7PPcWMNs6GyndKvfZTJ01FMU2AecIyn/tPh9VD8TmPb52bujKWUVPLnWjs
         wxfsfXwh9KGx9sFvPvHaNDekyozdScdVDymFhx4SUHUG/vnVrjrAZVdvl+JkboO23R
         cWX93I6AJz0Jh6N5kyOe0KTHrqnEx1mtVJoE1w/YhU0/vVzyY5tJ7QBb6n65qKHDfq
         VUY9vIWfXTV7g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0C86360A09;
        Mon, 26 Apr 2021 19:53:47 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] pcnet32: Remove redundant variable prev_link and curr_link
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161946682704.17823.13920971872017005914.git-patchwork-notify@kernel.org>
Date:   Mon, 26 Apr 2021 19:53:47 +0000
References: <1619346918-49035-1-git-send-email-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <1619346918-49035-1-git-send-email-jiapeng.chong@linux.alibaba.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     pcnet32@frontier.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun, 25 Apr 2021 18:35:18 +0800 you wrote:
> Variable prev_link and curr_link is being assigned a value from a
> calculation however the variable is never read, so this redundant
> variable can be removed.
> 
> Cleans up the following clang-analyzer warning:
> 
> drivers/net/ethernet/amd/pcnet32.c:2857:4: warning: Value stored to
> 'prev_link' is never read [clang-analyzer-deadcode.DeadStores].
> 
> [...]

Here is the summary with links:
  - pcnet32: Remove redundant variable prev_link and curr_link
    https://git.kernel.org/netdev/net-next/c/930d2d619d0a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


