Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 024573AF82B
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 00:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231997AbhFUWCX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 18:02:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:48296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230263AbhFUWCS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 18:02:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 74EFF611CE;
        Mon, 21 Jun 2021 22:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624312803;
        bh=hOCR3PNdO8TAP90k/KrJlS5Ri/KkIdbZ5jgBKTbcxO8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tmM4/An6X2oHBikeVE7g2JENYximonRXyWpYiY9zRy5M42q3bh/qCzEmat9JoMl4X
         9z+FIUtxRUsNp96TaSMMExrNhcglifwBJmvxV8TDTrF8JwswSZyIbD/iRxD0TOjY6o
         9DlpviAbfYvZ/ULVcKD7L/gHmFF1OFE6gpiLsQp5k2Tgle0WKG8UimBzBoXkRU60ix
         oz1WMhkzNCCZZRmkBUIvnnVPdYiy9pdlcJ4o/1RGgB/UpHMlSP7Drw1UF6ZRupMJ9t
         odF6oLhr/fwNyaNRAh8jCGowHCrfa0NfMs/u7GjTQoHXH7catXEAfyg8+Yfu/XfdNk
         BbAF0UZE8JBtQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 662C060952;
        Mon, 21 Jun 2021 22:00:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] pkt_sched: sch_qfq: fix qfq_change_class() error path
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162431280341.22265.14036847560558041930.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Jun 2021 22:00:03 +0000
References: <20210621175449.880248-1-eric.dumazet@gmail.com>
In-Reply-To: <20210621175449.880248-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, xiyou.wangcong@gmail.com,
        syzkaller@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 21 Jun 2021 10:54:49 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> If qfq_change_class() is unable to allocate memory for qfq_aggregate,
> it frees the class that has been inserted in the class hash table,
> but does not unhash it.
> 
> Defer the insertion after the problematic allocation.
> 
> [...]

Here is the summary with links:
  - [net] pkt_sched: sch_qfq: fix qfq_change_class() error path
    https://git.kernel.org/netdev/net/c/0cd58e5c53ba

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


