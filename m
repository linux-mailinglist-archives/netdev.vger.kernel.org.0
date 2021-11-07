Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 269FF447541
	for <lists+netdev@lfdr.de>; Sun,  7 Nov 2021 20:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232976AbhKGTcu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Nov 2021 14:32:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:40918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230411AbhKGTcu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Nov 2021 14:32:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 433396120A;
        Sun,  7 Nov 2021 19:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636313407;
        bh=ZveNJhBpELVnLAm24OxT1ISRFezWnekCQkGcpYZ1JFQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XXFXzpESMdi0DSU9E9OIP/qWoTaVpBqxydRO4WlqYyRpQqPc3wPgTrIfWBvV9XuOq
         ZxSkLaua+ZagBCyvUtu05rD/Kg8UNwaflikEjt2FuOrRzrwn9htH82hTzf66m9H2b5
         82/1jiU3ltETgJ+YVM3NiX8e+4OVkYVeUvu48tig7XsPoefyx7wWXyiFwof9owvH5E
         bLrVY8QwL6Wyiz0GdFWaFd+MkNvcFGnd1tK3+WoKK93qG6Gn/BkWk7Llzcx8ZiJ3hG
         NBT/BetMPIfvQuza1V5JWEONhYhZsHMcwXjCKgTYeKWWdiQFubcDAvzj3z7Ienzz18
         xnUTsF10WFbTg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 34C2060A2E;
        Sun,  7 Nov 2021 19:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] llc: fix out-of-bound array index in llc_sk_dev_hash()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163631340721.13867.2152006259846907112.git-patchwork-notify@kernel.org>
Date:   Sun, 07 Nov 2021 19:30:07 +0000
References: <20211105214214.2259841-1-eric.dumazet@gmail.com>
In-Reply-To: <20211105214214.2259841-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, syzkaller@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  5 Nov 2021 14:42:14 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Both ifindex and LLC_SK_DEV_HASH_ENTRIES are signed.
> 
> This means that (ifindex % LLC_SK_DEV_HASH_ENTRIES) is negative
> if @ifindex is negative.
> 
> [...]

Here is the summary with links:
  - [net] llc: fix out-of-bound array index in llc_sk_dev_hash()
    https://git.kernel.org/netdev/net/c/8ac9dfd58b13

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


