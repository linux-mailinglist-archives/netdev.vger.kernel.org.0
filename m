Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5B6035FD60
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 23:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233757AbhDNVkl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 17:40:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:38006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232302AbhDNVke (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 17:40:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A95236121E;
        Wed, 14 Apr 2021 21:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618436412;
        bh=ASG1I9eOjU0RnNPZg4cFodDoiHX/LrVpWdMVN3sIq1w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=o8zPA86pk3TNETHaGhZY0rgtNZG/NbKlcS8Nw+xdj2RHa9UxWBSC9lJ0yxUhhrP26
         yufbxbVIHIPvFuZi1L2QRYi2JSgGMSPxloJPVT4kpTCzplq6OcaqWy7Ib9qyoR3YYv
         kWvohjq3oci5+ILamXt86z+O/dYFx64FS9Yd+7sz9KWLK+Vk5eVKQPofdVb3X/5L3+
         ciz1YThwCrHYFHnqpYvJoHxC2SrrJXKpXpkiKqhp+Ps1vFBFFlg8hbb3TSrUolJTLn
         326fF/RBtKgrZ8ysuTmE75/jifBIB6CjYdSROWQZc8QINj4hKemhmSuYi/rJNi33a6
         wJT/t6ijL2hHQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9D1A160CD4;
        Wed, 14 Apr 2021 21:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/packet: remove data races in fanout operations
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161843641263.17301.9405927366608460821.git-patchwork-notify@kernel.org>
Date:   Wed, 14 Apr 2021 21:40:12 +0000
References: <20210414193644.1421615-1-eric.dumazet@gmail.com>
In-Reply-To: <20210414193644.1421615-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, sishuai@purdue.edu, willemb@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 14 Apr 2021 12:36:44 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> af_packet fanout uses RCU rules to ensure f->arr elements
> are not dismantled before RCU grace period.
> 
> However, it lacks rcu accessors to make sure KCSAN and other tools
> wont detect data races. Stupid compilers could also play games.
> 
> [...]

Here is the summary with links:
  - [net] net/packet: remove data races in fanout operations
    https://git.kernel.org/netdev/net-next/c/94f633ea8ade

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


