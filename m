Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE868445236
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 12:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbhKDLcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 07:32:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:48404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229505AbhKDLcp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Nov 2021 07:32:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DF6AF611EF;
        Thu,  4 Nov 2021 11:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636025407;
        bh=R6APx18Zlaw/VmXloJcDiC1jNmJctzBMHlN/ABTu5tg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YqGQYCrsKSoQ7cDdckm1FF4Bte0vBwtWyHQQvxt5nKv1+Q3fIiujdMzaJU/G1JoPt
         jW0idgdbXdKa+FyWwLpwMPWhpwonA/F7rYaRwbx1UEDwV1teOUkrvJun9yKOSQClLh
         onJtmfaxAS7g6U8gtNiEPXDejrQO/XClgmTH8ipYXgDNIwcJi0lP+vssP0vqPhgF4V
         moprOrFMY+gZp1GlSYimstoszet69ZQ/a1n+Nd3HiaJzHz3QyysLJy6Jr+WtUPbuts
         9YnWRkwHzss0zlaHQbTUAKLtyZz1KeNFaTdNEFUoAAe1WmQXqRI1xUrdG4q9ohG4VY
         LR+O9Uz3SFtEA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CD92B609CF;
        Thu,  4 Nov 2021 11:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: fix possible NULL deref in sock_reserve_memory
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163602540783.19516.1120103082682894255.git-patchwork-notify@kernel.org>
Date:   Thu, 04 Nov 2021 11:30:07 +0000
References: <20211103234911.4073969-1-eric.dumazet@gmail.com>
In-Reply-To: <20211103234911.4073969-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, syzkaller@googlegroups.com, weiwan@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed,  3 Nov 2021 16:49:11 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Sanity check in sock_reserve_memory() was not enough to prevent malicious
> user to trigger a NULL deref.
> 
> In this case, the isse is that sk_prot->memory_allocated is NULL.
> 
> [...]

Here is the summary with links:
  - [net] net: fix possible NULL deref in sock_reserve_memory
    https://git.kernel.org/netdev/net/c/d00c8ee31729

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


