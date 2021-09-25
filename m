Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D480B417F87
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 05:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343920AbhIYDlo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 23:41:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:37224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233807AbhIYDln (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 23:41:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0774B61041;
        Sat, 25 Sep 2021 03:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632541209;
        bh=3s2CAxHVRvbiQ5q7YXrroZfyTP+CYK5vnpPEgoegsaE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KkMhc8rR/VcQT/2ZnOtCbLJN+3WXg63AmWQjdKf+Hl8uUPLSaqeZhqv41DwMFBD9I
         6RjR2j4dkD04jlS05aW5q3XVGsmbRls+dMomU/oKVbjlav4Cy85emcHe/DFwWC5YwD
         E8A/nTp1NdBW9zDQWeG/8LzQ3hxZpecvRg94X4uvOq/gauzVOZ3T4iAzB2iePjb4P2
         UU5ccj0yCtdW2MEM+UCyqxpuFg4bsrhL1xlR0/hK2QZDRWwNHD5XvGZ67slRhbqZqp
         kc6gFZyybUAPFrS5g2HWfxBJHFBdwxdum0FYbSDiF8gI5q77F0ZHpuF4hYB2P5wBc0
         HckTABHMH277w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F04A06097B;
        Sat, 25 Sep 2021 03:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 01/15] netfilter: ipset: Fix oversized kvmalloc() calls
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163254120897.2561.14612937907977922241.git-patchwork-notify@kernel.org>
Date:   Sat, 25 Sep 2021 03:40:08 +0000
References: <20210924221113.348767-2-pablo@netfilter.org>
In-Reply-To: <20210924221113.348767-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Sat, 25 Sep 2021 00:10:59 +0200 you wrote:
> From: Jozsef Kadlecsik <kadlec@netfilter.org>
> 
> The commit
> 
> commit 7661809d493b426e979f39ab512e3adf41fbcc69
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Wed Jul 14 09:45:49 2021 -0700
> 
> [...]

Here is the summary with links:
  - [net,01/15] netfilter: ipset: Fix oversized kvmalloc() calls
    https://git.kernel.org/netdev/net/c/7bbc3d385bd8
  - [net,02/15] ipvs: check that ip_vs_conn_tab_bits is between 8 and 20
    https://git.kernel.org/netdev/net/c/69e73dbfda14
  - [net,03/15] netfilter: ip6_tables: zero-initialize fragment offset
    https://git.kernel.org/netdev/net/c/310e2d43c3ad
  - [net,04/15] netfilter: conntrack: make max chain length random
    https://git.kernel.org/netdev/net/c/c9c3b6811f74
  - [net,05/15] netfilter: conntrack: include zone id in tuple hash again
    https://git.kernel.org/netdev/net/c/b16ac3c4c886
  - [net,06/15] netfilter: nat: include zone id in nat table hash again
    https://git.kernel.org/netdev/net/c/d2966dc77ba7
  - [net,07/15] selftests: netfilter: add selftest for directional zone support
    https://git.kernel.org/netdev/net/c/0f1148abb226
  - [net,08/15] selftests: netfilter: add zone stress test with colliding tuples
    https://git.kernel.org/netdev/net/c/cb89f63ba662
  - [net,09/15] netfilter: nf_tables: unlink table before deleting it
    https://git.kernel.org/netdev/net/c/a499b03bf36b
  - [net,10/15] netfilter: nf_tables: Fix oversized kvmalloc() calls
    https://git.kernel.org/netdev/net/c/45928afe94a0
  - [net,11/15] netfilter: nf_nat_masquerade: make async masq_inet6_event handling generic
    https://git.kernel.org/netdev/net/c/30db406923b9
  - [net,12/15] netfilter: nf_nat_masquerade: defer conntrack walk to work queue
    https://git.kernel.org/netdev/net/c/7970a19b7104
  - [net,13/15] netfilter: iptable_raw: drop bogus net_init annotation
    https://git.kernel.org/netdev/net/c/cc8072153aaf
  - [net,14/15] netfilter: log: work around missing softdep backend module
    https://git.kernel.org/netdev/net/c/b53deef054e5
  - [net,15/15] netfilter: conntrack: serialize hash resizes and cleanups
    https://git.kernel.org/netdev/net/c/e9edc188fc76

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


