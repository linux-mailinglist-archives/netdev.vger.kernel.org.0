Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2372E34F59D
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 02:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233112AbhCaAuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 20:50:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:37812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232920AbhCaAuK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 20:50:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DB884619DC;
        Wed, 31 Mar 2021 00:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617151809;
        bh=0iEz96Th9GzkwkA8VlTLN7/OXKF/IzjFFwEfGVGdiUI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Qyuq2aQux71aqY37mAwiVXAUuPVhAE46r6MX0RshSdpmzZtvBCnaJOXrAuooLP1pX
         L5bKkMWMsCqF1kqKNzNiP1TtYJSGbgKF36qpUTl6ao/0BL8Fvtn5oceunBUe7FMHwY
         zvLpvLsEuqQEcHMaf0eQEUBU+zfKlQPiELALOcG4HCGheRWEeOw0FSkfDKohJZeega
         Nalq8+nVjNnbnW7wkrn2nLeSymwz78bZQ67Ol0FEBX27WZxZkLBp0CwBNGIUuNHQfU
         O5nrqow5v0jxH1az9q5eE6b4I3UnohwvKqGR5RWkHJPcq94pqli5uOV+A0AcXsAjma
         a697j+0LK0+Og==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D757960A72;
        Wed, 31 Mar 2021 00:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: fix icmp_echo_enable_probe sysctl
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161715180987.15741.12926380269195963723.git-patchwork-notify@kernel.org>
Date:   Wed, 31 Mar 2021 00:50:09 +0000
References: <20210330210613.2765853-1-eric.dumazet@gmail.com>
In-Reply-To: <20210330210613.2765853-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, andreas.a.roeseler@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 30 Mar 2021 14:06:13 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> sysctl_icmp_echo_enable_probe is an u8.
> 
> ipv4_net_table entry should use
>  .maxlen       = sizeof(u8).
>  .proc_handler = proc_dou8vec_minmax,
> 
> [...]

Here is the summary with links:
  - [net-next] net: fix icmp_echo_enable_probe sysctl
    https://git.kernel.org/netdev/net-next/c/b8128656a5ed

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


