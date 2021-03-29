Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9D434DC92
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 01:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbhC2Xkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 19:40:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:42030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230229AbhC2XkM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 19:40:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0FFB2619AE;
        Mon, 29 Mar 2021 23:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617061212;
        bh=CpCwo4WzmPv72l3bgU7WshjoLaYt1jVLcEaKKHncT/U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fTpP4AXLkTrm74jVjkn011y9grlarzXW5gtjfcdNjvWUqLGpd6QnUKt13qj2NtxUe
         Gl4mA+QjVLKmPunhB96ncLm9QCLmd6rd8OIxgvmTY/dEoebOhwXPgp+1aVvzzmNfyP
         VnZ1fJ52b8JM8nyfp5CExPk3MusthzSdTTQVrGCYq9rncQ+lMukoi5VGpw0rlHM6hr
         NlZzh3RQJ29UhYTXp+ludBcGOurADWdviFKKzyhvxQscgWxdjcLSBFnkIFrWnQ2aK/
         TfL2tOoZh1YGOCE8cN8IKWsYlvxj6zL05DjVTNwd/SwaXsIXkEaJYnXjy1isAFkJ0Y
         7NuZ6ABklqkKA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0ACE160A48;
        Mon, 29 Mar 2021 23:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] sit: proper dev_{hold|put} in ndo_[un]init methods
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161706121204.22281.15011779497664235619.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Mar 2021 23:40:12 +0000
References: <20210329192522.155336-1-eric.dumazet@gmail.com>
In-Reply-To: <20210329192522.155336-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, syzkaller@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 29 Mar 2021 12:25:22 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> After adopting CONFIG_PCPU_DEV_REFCNT=n option, syzbot was able to trigger
> a warning [1]
> 
> Issue here is that:
> 
> [...]

Here is the summary with links:
  - [net-next] sit: proper dev_{hold|put} in ndo_[un]init methods
    https://git.kernel.org/netdev/net-next/c/6289a98f0817

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


