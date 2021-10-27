Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD9C43D18D
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 21:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243676AbhJ0TWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 15:22:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:41968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239144AbhJ0TWd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 15:22:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4B85F610CB;
        Wed, 27 Oct 2021 19:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635362407;
        bh=rPhTy3K9ZlPVfu2BFxNT2meK9nGhmQf9PbEZXMGvL4M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DGbOfa1JYwkf4QFWDsfHhiDjIcpvR0Txfb03WQK2XzskonXvnwZrfJR1cqDyp4jRl
         W/eFPD7bqF6gwe13N1YrSbPjQq95C8LWGQCNV4gjqPVhPQyM77UqJa+FYD6ISgsX6G
         RgntwVBWYgyGUbb2a3Ie+UiQRKVRCRSwWP76a9lQUK2cSReZs4Odfk3GjBR8h+s5uB
         GJ9y9ngllIbarfpv5Fi3a+1BeyAlb4omMyXL0eBQDYIhRI8rfo78Clqj6AU+GHCKxu
         X4QZ5WBmJvNzeTDbFPQkaPvwLqxclrf7M6Ijk2gw9Ox1ful8B4SyVurnfGkLQhKv7g
         ZdZhSFKqI4Ndg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4490860A17;
        Wed, 27 Oct 2021 19:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3] net: sched: gred: dynamically allocate
 tc_gred_qopt_offload
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163536240727.6049.15129034400633556639.git-patchwork-notify@kernel.org>
Date:   Wed, 27 Oct 2021 19:20:07 +0000
References: <20211026100711.nalhttf6mbe6sudx@linutronix.de>
In-Reply-To: <20211026100711.nalhttf6mbe6sudx@linutronix.de>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     arnd@kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, kuba@kernel.org,
        a.darwish@linutronix.de, arnd@arndb.de, zhengyongjun3@huawei.com,
        edumazet@google.com, rdunlap@infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 26 Oct 2021 12:07:11 +0200 you wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The tc_gred_qopt_offload structure has grown too big to be on the
> stack for 32-bit architectures after recent changes.
> 
> net/sched/sch_gred.c:903:13: error: stack frame size (1180) exceeds limit (1024) in 'gred_destroy' [-Werror,-Wframe-larger-than]
> net/sched/sch_gred.c:310:13: error: stack frame size (1212) exceeds limit (1024) in 'gred_offload' [-Werror,-Wframe-larger-than]
> 
> [...]

Here is the summary with links:
  - [net-next,v3] net: sched: gred: dynamically allocate tc_gred_qopt_offload
    https://git.kernel.org/netdev/net-next/c/f25c0515c521

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


