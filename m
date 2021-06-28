Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78B7E3B6B32
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 01:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236769AbhF1XMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 19:12:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:41884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233868AbhF1XMi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Jun 2021 19:12:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id F030261CFC;
        Mon, 28 Jun 2021 23:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624921812;
        bh=KuR2fedHwessyLJGLMs1REPFgMlo/LKyKF4zV0jeyr0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AYCulH4t91lp1K6DiW/HG0rSRwt/mK+hMmjGYaXeoq0slBtSSrYAGnKQj2PGJ++ZJ
         eBf8lSoQmUP6Xe95BMkeib0RzicuHhXFC0OD2bwULwa2UyA3DMXYLPOn76zPR5seAf
         mACAB8s6oguusMteyFKXAlumgvFRVxwpg9FHEUJJ9BsEa+ToB2UZ3hAijJG+UQHJGM
         F9wOiJTJrQNx7fMRNfgMdA1Dy0ef4w6vGCZsbQ+RJp4bDmxuBYGR8FM16XoIvf3n3U
         5DNXeiS4G3HqcwQ1wQmVl9UlXLBgi3WiccyCj5zif0Yh363VwJCz5/H/R2DSJQN4Wu
         GjlYAodsL6L2Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DBF5E60A3A;
        Mon, 28 Jun 2021 23:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/2] net: update netdev_rx_csum_fault() print dump
 only once
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162492181189.29625.7224175103290860557.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Jun 2021 23:10:11 +0000
References: <20210628135007.1358909-1-tannerlove.kernel@gmail.com>
In-Reply-To: <20210628135007.1358909-1-tannerlove.kernel@gmail.com>
To:     Tanner Love <tannerlove.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, maheshb@google.com, djwong@kernel.org,
        arnd@arndb.de, pmladek@suse.com, senozhatsky@chromium.org,
        rostedt@goodmis.org, john.ogness@linutronix.de, mingo@redhat.com,
        kuba@kernel.org, andriin@fb.com, atenart@kernel.org,
        alobakin@pm.me, weiwan@google.com, ap420073@gmail.com,
        linyunsheng@huawei.com, willemb@google.com, tannerlove@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 28 Jun 2021 09:50:05 -0400 you wrote:
> From: Tanner Love <tannerlove@google.com>
> 
> First patch implements DO_ONCE_LITE to abstract uses of the ".data.once"
> trick. It is defined in its own, new header file  -- rather than
> alongside the existing DO_ONCE in include/linux/once.h -- because
> include/linux/once.h includes include/linux/jump_label.h, and this
> causes the build to break for some architectures if
> include/linux/once.h is included in include/linux/printk.h or
> include/asm-generic/bug.h.
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/2] once: implement DO_ONCE_LITE for non-fast-path "do once" functionality
    https://git.kernel.org/netdev/net-next/c/a358f40600b3
  - [net-next,v3,2/2] net: update netdev_rx_csum_fault() print dump only once
    https://git.kernel.org/netdev/net-next/c/127d7355abb3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


