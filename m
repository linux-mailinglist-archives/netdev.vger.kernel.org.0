Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF66350A28
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 00:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232981AbhCaWVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 18:21:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:50174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229615AbhCaWUS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 18:20:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7221F6108B;
        Wed, 31 Mar 2021 22:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617229218;
        bh=KnGr7iX3Wn+o/EQEB1ldp5+QTpPSXhkqKZmPgoEEx2U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UjrI5gqBGNhexMEv+1HfBgmuilRN4FZVjqkh1GC2YGwQd30Q16W7M8uLfGWgr11Ph
         pMf9Df8WfnQJwyI3r9asSYxPenc+iaccJgU1C31Qg4fYtQdZQ8p+oWKdBndolJkpmc
         qQI7FHoLXQtzQVhSp3K+S5AjUElvESHVqCXW6JZg1dmotCDMauR5Km0DgGaWZK6Z3R
         eeC4QFUngGQrzhcXKKMhQjSweUkADQsT0hHMyr6zBH7SQy5R8l8ZWtWg8RIYqf3xbG
         Ufi4Ggj/XSifOA/800QaSJrBJPZnVepOy0LVBF47SuJ+wzozB51cT6hAfDswJuh/Ju
         VptHx8ZhgsVaQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6D30B608FA;
        Wed, 31 Mar 2021 22:20:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ipv6: remove extra dev_hold() for fallback tunnels
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161722921844.2890.11000209611383163900.git-patchwork-notify@kernel.org>
Date:   Wed, 31 Mar 2021 22:20:18 +0000
References: <20210331213811.847054-1-eric.dumazet@gmail.com>
In-Reply-To: <20210331213811.847054-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, syzkaller@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 31 Mar 2021 14:38:11 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> My previous commits added a dev_hold() in tunnels ndo_init(),
> but forgot to remove it from special functions setting up fallback tunnels.
> 
> Fallback tunnels do call their respective ndo_init()
> 
> [...]

Here is the summary with links:
  - [net-next] ipv6: remove extra dev_hold() for fallback tunnels
    https://git.kernel.org/netdev/net-next/c/0d7a7b2014b1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


