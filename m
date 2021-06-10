Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BAA33A36AA
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 23:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230410AbhFJVwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 17:52:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:56176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230307AbhFJVwC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 17:52:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id F29CC61404;
        Thu, 10 Jun 2021 21:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623361806;
        bh=UTu/0HmODh5FEDn9DaYhRJ2yeLPaf4htTOkU+HRVc+Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EdEGCx/whzQuCQHWPVAKVUHA63MRwWthbRAmMsWWDY942KMP22qMO7ZdYwOHCzrln
         wi8YtTmKenOwUDgZf83cFFHQ0PDVG5nPkn0QxB6JnNPnUhKgmP6brcnp2vtWmy4pGe
         qdUfyRbRnAB8SkSzPK74omaAkUeAOuHWHV4+2vsa6HGtYjzc2OcdeFv7qwPEZx73TP
         q1wc8QdCpSGnw9EmXWXtwFBJAU1Q9MiNC1+WBkBwYZKMzYYrkfn2qQcyTyy4hgw1P4
         +nRTDs+Mclq88wriHeDaGiMLQOjENjrkPUaGfdqyOtC3ONPv+6LoT1vtCLKuAlvSoA
         4uLeHOxI0m44g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EA96560A0C;
        Thu, 10 Jun 2021 21:50:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/packet: annotate data race in packet_sendmsg()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162336180595.29138.2499534275934024070.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Jun 2021 21:50:05 +0000
References: <20210610160012.1452531-1-eric.dumazet@gmail.com>
In-Reply-To: <20210610160012.1452531-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 10 Jun 2021 09:00:12 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> There is a known race in packet_sendmsg(), addressed
> in commit 32d3182cd2cd ("net/packet: fix race in tpacket_snd()")
> 
> Now we have data_race(), we can use it to avoid a future KCSAN warning,
> as syzbot loves stressing af_packet sockets :)
> 
> [...]

Here is the summary with links:
  - [net] net/packet: annotate data race in packet_sendmsg()
    https://git.kernel.org/netdev/net/c/d1b5bee4c8be

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


