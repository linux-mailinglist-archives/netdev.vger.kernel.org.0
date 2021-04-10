Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3520B35A99F
	for <lists+netdev@lfdr.de>; Sat, 10 Apr 2021 02:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235337AbhDJAk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 20:40:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:45882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235319AbhDJAkX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 20:40:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0D8D9611EF;
        Sat, 10 Apr 2021 00:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618015210;
        bh=t7MVoW4FWPZK8+hOgpWS+G8YnBGbSaJVstZv18dR19w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=O+2KDT59N29gMiG7BxSLRJ5BLVTysYJLbg0yxD3qPRwsqDFY4uL4iTx7plQ+pgJRX
         nBIimZnYWW063pdVPn/ieEffV8sES84ztw/h8Qe4qSIe4VVn7kd9WwDxFkYS/rypn3
         Y6OaPlGeYeycOVqYSGTpbJECWo6oYMKQ+KP9H+rxKg68g49u5apJWj8V9DArTMR1kn
         P0nBzEpEGGbQGpmJgfaJZYxne5aGO0Rnoh9ovX6yix6uMPMeUwdG3H1cOBU/GRxAsH
         i6g4R3Hw6F+Ow5pO5blB07j9olSlO9VnskV6Rso2KOXRhFWSJ3ufs22nfrvA37pI/z
         dCeljZKvQs56A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0287960BFF;
        Sat, 10 Apr 2021 00:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] Revert "tcp: Reset tcp connections in SYN-SENT
 state"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161801521000.30931.7527591845459309993.git-patchwork-notify@kernel.org>
Date:   Sat, 10 Apr 2021 00:40:10 +0000
References: <20210409170237.274904-1-eric.dumazet@gmail.com>
In-Reply-To: <20210409170237.274904-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, syzkaller@googlegroups.com,
        manojbm@codeaurora.org, ssaha@codeaurora.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri,  9 Apr 2021 10:02:37 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> This reverts commit e880f8b3a24a73704731a7227ed5fee14bd90192.
> 
> 1) Patch has not been properly tested, and is wrong [1]
> 2) Patch submission did not include TCP maintainer (this is me)
> 
> [...]

Here is the summary with links:
  - [net-next] Revert "tcp: Reset tcp connections in SYN-SENT state"
    https://git.kernel.org/netdev/net-next/c/a7150e382267

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


