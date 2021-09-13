Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35429408A6E
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 13:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234635AbhIMLlZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 07:41:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:47672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236170AbhIMLlX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 07:41:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 83FE3610CE;
        Mon, 13 Sep 2021 11:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631533207;
        bh=4eocOMoUFWdGbngjx951r4htgeaDrO59c59Ughby/hY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CaoH7yqi8f+cuHPCjXK1RQZIuEvvt1qqVHtSG1nLsNa1CE4HszhYG71eBl3B634tN
         s/TpWKbl+GAQxch38MTP8Pt2g9keQAxoFiuasW3WFIKH4PxX7SjMfiY3wxcRxajSlE
         XtG+cR3+SD1h5LX9NaYRkJAYUU9W1gl6eclYI0RHT6tcH7yGsgMk0/aJzRQV2ev11d
         65kbSEZg0FoB/Ok8MngLnFT4UIBPXkJeXog75GxWNQclioOb2k8K7qG9Em9SLARj0c
         FLlgYUOgHyCVBVzDL0/xcYfSs4hRnB+vBy464cRx2sH9qBETm1g7d9xeK1fOc4LnwN
         lFQpmPL72gryA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6683C60A6F;
        Mon, 13 Sep 2021 11:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] Revert "ipv4: fix memory leaks in ip_cmsg_send() callers"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163153320741.25807.6251954159474388165.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Sep 2021 11:40:07 +0000
References: <20210913040442.2627-1-yajun.deng@linux.dev>
In-Reply-To: <20210913040442.2627-1-yajun.deng@linux.dev>
To:     Yajun Deng <yajun.deng@linux.dev>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, edumazet@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 13 Sep 2021 12:04:42 +0800 you wrote:
> This reverts commit 919483096bfe75dda338e98d56da91a263746a0a.
> 
> There is only when ip_options_get() return zero need to free.
> It already called kfree() when return error.
> 
> Fixes: 919483096bfe ("ipv4: fix memory leaks in ip_cmsg_send() callers")
> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
> 
> [...]

Here is the summary with links:
  - Revert "ipv4: fix memory leaks in ip_cmsg_send() callers"
    https://git.kernel.org/netdev/net/c/d7807a9adf48

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


