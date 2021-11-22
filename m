Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37910458EDD
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 14:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236206AbhKVNDU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 08:03:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:33748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234566AbhKVNDU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 08:03:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id BFF9860FBF;
        Mon, 22 Nov 2021 13:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637586013;
        bh=7u5N0ONYWOlih0kieWXeu+p3acs3g509FMd5uvyC7qQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AhQABZASYV+n9IpEC7GgF0PIzRkltbW5uG/ud38NmRNcBmdhB7G/Vgrf1rTGHDzNl
         HTQCqAYvr6yfdlUHVqnEkU7LsPNVUY9Apg1wlWbTwFC47S+uPnvb3QfK4GCHuw0wcs
         e0AgytikB6ZGcCKz2aujUj3vnBsCDH1arIH4d72Wu83Hgx/C/pwPtZvn2rKinjuF7K
         vjNc1FY4Xv49YgkmMGq3WUUJEj0M1vAFVr8nJCzl16xzDrh97bjkD0i3ZQccSKqEPo
         56UWBW4y7EjsW6MsIvacEnQ37jx0c/rHI/im+Sih2WMZwGrJDaYoZe40XKKYNSrLCT
         R947ALlTjDeXg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B457D60972;
        Mon, 22 Nov 2021 13:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net: annotate accesses to
 dev->gso_max_{size|segs}
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163758601373.20556.2061738034689274771.git-patchwork-notify@kernel.org>
Date:   Mon, 22 Nov 2021 13:00:13 +0000
References: <20211119154332.4110795-1-eric.dumazet@gmail.com>
In-Reply-To: <20211119154332.4110795-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 19 Nov 2021 07:43:30 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Generalize use of netif_set_gso_max_{size|segs} helpers and document
> lockless reads from sk_setup_caps()
> 
> Eric Dumazet (2):
>   net: annotate accesses to dev->gso_max_size
>   net: annotate accesses to dev->gso_max_segs
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: annotate accesses to dev->gso_max_size
    https://git.kernel.org/netdev/net-next/c/4b66d2161b81
  - [net-next,2/2] net: annotate accesses to dev->gso_max_segs
    https://git.kernel.org/netdev/net-next/c/6d872df3e3b9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


