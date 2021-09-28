Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDB4741B215
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 16:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241218AbhI1Obr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 10:31:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:48208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241016AbhI1Obq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 10:31:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2B98F6120C;
        Tue, 28 Sep 2021 14:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632839407;
        bh=7NXSEc9ES5sCm6tsbxKnqk3otJxaNds/6PaHl3wPyfQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bn+pfaIl7havyQ/tFa1c/6MoOFwwxZcvJFr9Nvo+Pdj3RZqVpYNTzdQ2dDqPQUxrh
         DsOWKGFLxkbc1p6bHaj36wpjuCBEvg2IgxttC9e7Z/K/GGogz/iIxyyM+foudFRqxj
         gV16hLgdYOBaTFWE7c06bUVjPcnEpmrmh8ZAVm3Fh5lz9w+UjiRDHIPQU2SlRSpbfH
         Mctf9ufHcfsOxqpIQIYYlIUyC564Xdtz295s2JDOYEOBvAeT2mZ8gLWBJSSpXCnb1l
         NdOCpzlT4jHGMFbLFAH3rtDpDR3rgFKu/0TcJrJR7jaoIXk96i1xermeRlfeihckbm
         myuloXB3i1VQA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 216D860A69;
        Tue, 28 Sep 2021 14:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] [v2] gve: DQO: avoid unused variable warnings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163283940713.31338.8239532640681569713.git-patchwork-notify@kernel.org>
Date:   Tue, 28 Sep 2021 14:30:07 +0000
References: <20210928141530.256433-1-arnd@kernel.org>
In-Reply-To: <20210928141530.256433-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     jeroendb@google.com, davem@davemloft.net, kuba@kernel.org,
        bcf@google.com, willemb@google.com, csully@google.com,
        arnd@arndb.de, awogbemila@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 28 Sep 2021 16:15:13 +0200 you wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The use of dma_unmap_addr()/dma_unmap_len() in the driver causes
> multiple warnings when these macros are defined as empty, e.g.
> in an ARCH=i386 allmodconfig build:
> 
> drivers/net/ethernet/google/gve/gve_tx_dqo.c: In function 'gve_tx_add_skb_no_copy_dqo':
> drivers/net/ethernet/google/gve/gve_tx_dqo.c:494:40: error: unused variable 'buf' [-Werror=unused-variable]
>   494 |                 struct gve_tx_dma_buf *buf =
> 
> [...]

Here is the summary with links:
  - [v2] gve: DQO: avoid unused variable warnings
    https://git.kernel.org/netdev/net-next/c/1e0083bd0777

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


