Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C46245B32C
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 05:30:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239225AbhKXEdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 23:33:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:35292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233767AbhKXEdR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 23:33:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id C95FD60FC1;
        Wed, 24 Nov 2021 04:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637728208;
        bh=rzAyqTEUj+cqKC8foQFbMePXfZUOXQ+8nwzqDxEAwaM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ifWem9QE0Ly9Q2hqh49su/ItBHL4HpLaMVvkJvtQD1UJW076d1x1LPfTUte9VxW55
         B+2pQ6VGS8YaAgVEflssOcNt8QDGFvg8f3Zi9klcQla0LTHMvEvx1ztC9lF2lH46oE
         nmX197VKaCR+UC2TJ6x94d/o1YpANss9RKZ+ideFU0Cjmgr2e4k+uRkDqoODg8rI3Z
         df2UOsyfq8zzwaMtnsfFsf+MuEW1R8xZ6ij39VNMmvJiy52ggN3XG12B796yMaOOSI
         6o5KAwd1PiOepGU5IO1+S+Xyoik5vjEyA0urQowetN5P2BLSOKFiByNqak61yjfBiK
         0kpdMt6O0tteg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BCCF060A94;
        Wed, 24 Nov 2021 04:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] dccp/tcp: Minor fixes for
 inet_csk_listen_start().
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163772820876.18836.15309450997633192155.git-patchwork-notify@kernel.org>
Date:   Wed, 24 Nov 2021 04:30:08 +0000
References: <20211122101622.50572-1-kuniyu@amazon.co.jp>
In-Reply-To: <20211122101622.50572-1-kuniyu@amazon.co.jp>
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        laoar.shao@gmail.com, benh@amazon.com, kuni1840@gmail.com,
        netdev@vger.kernel.org, dccp@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 22 Nov 2021 19:16:20 +0900 you wrote:
> The first patch removes an unused argument, and the second removes a stale
> comment.
> 
> 
> Kuniyuki Iwashima (2):
>   dccp/tcp: Remove an unused argument in inet_csk_listen_start().
>   dccp: Inline dccp_listen_start().
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] dccp/tcp: Remove an unused argument in inet_csk_listen_start().
    https://git.kernel.org/netdev/net-next/c/e7049395b1c3
  - [net-next,2/2] dccp: Inline dccp_listen_start().
    https://git.kernel.org/netdev/net-next/c/b4a8e7493d74

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


