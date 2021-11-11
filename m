Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7FA44CF69
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 03:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233210AbhKKCC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 21:02:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:54528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232723AbhKKCC4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 21:02:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id A934E61260;
        Thu, 11 Nov 2021 02:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636596007;
        bh=DN2pxsQyqaLVqqH7loumH+uqoFq2dQAvlu5pNXkpYvg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Rvz829o/Od/xd2d1SRfvnRjCOVlzcAtd5XG6ubFp1trZrT91IwA9URi3dAVA++yWL
         8YiDHpO0xGg9709PiROzs7kk18rJ8OLIBSvSzRBOoIsZu2iPSd53LpKtd8pJqeyzp+
         7JPk/+IIJH9rk4xOrqkVNXhaW2gcOKbwCpgKTHuGvvz26uOBXLnOHKHXHqnUIO3TAO
         vyTV3f63PeYbMRuCKUO2A9GXu90f0NlWC+xdV70xfNsPpVs1MUWc/7fUnQYxnfgC44
         52BSl6aTpMIdJ7mN4+fFLulQ8Dls4fO8EL+Ne66ZkSwwio81bIos7p98JgYFoEpSVF
         ioYXofehjLSBQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9262A6008E;
        Thu, 11 Nov 2021 02:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] net: fix premature exit from NAPI state polling in
 napi_disable()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163659600759.26095.2844234203024787527.git-patchwork-notify@kernel.org>
Date:   Thu, 11 Nov 2021 02:00:07 +0000
References: <20211110195605.1304-1-alexandr.lobakin@intel.com>
In-Reply-To: <20211110195605.1304-1-alexandr.lobakin@intel.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, jesse.brandeburg@intel.com,
        maciej.fijalkowski@intel.com, michal.swiatkowski@intel.com,
        xuanzhuo@linux.alibaba.com, atenart@kernel.org,
        edumazet@google.com, weiwan@google.com, bjorn@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 10 Nov 2021 20:56:05 +0100 you wrote:
> Commit 719c57197010 ("net: make napi_disable() symmetric with
> enable") accidentally introduced a bug sometimes leading to a kernel
> BUG when bringing an iface up/down under heavy traffic load.
> 
> Prior to this commit, napi_disable() was polling n->state until
> none of (NAPIF_STATE_SCHED | NAPIF_STATE_NPSVC) is set and then
> always flip them. Now there's a possibility to get away with the
> NAPIF_STATE_SCHE unset as 'continue' drops us to the cmpxchg()
> call with an unitialized variable, rather than straight to
> another round of the state check.
> 
> [...]

Here is the summary with links:
  - [v2,net] net: fix premature exit from NAPI state polling in napi_disable()
    https://git.kernel.org/netdev/net/c/0315a075f134

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


