Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA4534DC8F
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 01:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbhC2Xka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 19:40:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:41984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230213AbhC2XkM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 19:40:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E7976619A6;
        Mon, 29 Mar 2021 23:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617061211;
        bh=Ic3ZLnkKLyPpUwJFodppcj1u6fyBm7Kc8pMWBWFHhvk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZVoGxqtp9FMoYkjq7YJr6ImML2CWtsDIBS7y1OQD/3nJ5ufE/M+3fr4xH4Q23Rk/G
         UWko+HmkoPsDhq6vCSETHytE3rYqrbiwUaAWmzMXSWwKtFt1w1ObBz5n1k/IlUuak2
         b3c4hj1wfDpjj1pHSk288AM0YYHeDKA5w8OPlpZXavWyXU/OoD9ZGhX4YGv28bSrnn
         72ZXYaPgCZkqcNPY24/NWcT7H29fLQgCmfDtKX+8h0UgwCyCzCLLAo3FGRlRRY51Zt
         5/wtfzKJ4F9itMNCu1Zr2gtZ2u0T0SZGuVlTHtO+XKMIB9+rnQo3fw0cRF+PQgfP7n
         UYm9qxzTnkCQA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E2F8660A1B;
        Mon, 29 Mar 2021 23:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ip6_gre: proper dev_{hold|put} in ndo_[un]init
 methods
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161706121192.22281.3298498020990243990.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Mar 2021 23:40:11 +0000
References: <20210329183951.4109252-1-eric.dumazet@gmail.com>
In-Reply-To: <20210329183951.4109252-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, syzkaller@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 29 Mar 2021 11:39:51 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> After adopting CONFIG_PCPU_DEV_REFCNT=n option, syzbot was able to trigger
> a warning [1]
> 
> Issue here is that:
> 
> [...]

Here is the summary with links:
  - [net-next] ip6_gre: proper dev_{hold|put} in ndo_[un]init methods
    https://git.kernel.org/netdev/net-next/c/7f700334be9a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


