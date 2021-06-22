Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B317B3B0AA3
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 18:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231436AbhFVQwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 12:52:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:32774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229751AbhFVQwT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 12:52:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1885A6134F;
        Tue, 22 Jun 2021 16:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624380603;
        bh=j4QSlJq8SIb0FOX9WpRy+a+KfZ+pGRhdAnmoESPUwcs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=p2Cl4l6vi1obHBC9V3vk0LMVKNe6rIWxfENSxJigCd/YIGinRlhFkvfEK8BvsEBzG
         G8eFoIzYs+1U4Eht+QfHN42Kail1rx9/heaqkf/1tSoRRbBOJHYQKMWOeHQqbZ8CbK
         Zp+FO12HRhV8qRADGL9m9oZwdMtE4imK5OceF61YXnQ/MtWGV8zuAePVqacbECulql
         l5rIOUAVOYPoK4kQek5/ptzfGPewAojcFECU8lwenaGErsTemvaZy+P7wk83zJEO+s
         e0VnykZ2N8PPjRhpjFhwXyy+7icmXl+54pNfKL5VHwy6reOCztWvS7/9olZESd6Pkb
         PVQPRmIyjH7hw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0C59660A02;
        Tue, 22 Jun 2021 16:50:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] vxlan: add missing rcu_read_lock() in neigh_reduce()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162438060304.900.11078969526519930466.git-patchwork-notify@kernel.org>
Date:   Tue, 22 Jun 2021 16:50:03 +0000
References: <20210621144417.694367-1-eric.dumazet@gmail.com>
In-Reply-To: <20210621144417.694367-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, syzkaller@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 21 Jun 2021 07:44:17 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> syzbot complained in neigh_reduce(), because rcu_read_lock_bh()
> is treated differently than rcu_read_lock()
> 
> WARNING: suspicious RCU usage
> 5.13.0-rc6-syzkaller #0 Not tainted
> 
> [...]

Here is the summary with links:
  - [net] vxlan: add missing rcu_read_lock() in neigh_reduce()
    https://git.kernel.org/netdev/net/c/85e8b032d6eb

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


