Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41DBA3D3C9D
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 17:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235620AbhGWPAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 11:00:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:47466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235774AbhGWO7a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Jul 2021 10:59:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 37D1560EE2;
        Fri, 23 Jul 2021 15:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627054804;
        bh=kENZX6ldexEr5QXVqtEDdJMka0c6IWQm1TmYsdLhYY8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qr/d1iZ+6OTS/y6+j5pmmcxMFA+Xeo202qx+v1RaE2CmEPdwqDJdph4g/KQ7F9ycG
         XjaZJQNciZ+xtOY89T6KFgE/CBkpMPSo5dq9qH0Etn6/4ZoMaYnJz4u3rl33SpAu6d
         Dzkc+JquqYHvR38fXq6P1hkFisHrDqbta5RUl4DguraNoGnUMnB3eRScO+oo1GQm+t
         rxPc4gZ/HeA+NhnXu7AJmAWNXBFqaDU6z88q1yxFtyJGSw5s/3HuTuLkLPvxjoYVG0
         qY+dfMmbmiludsnmd/n3Mfth50p5wX3/sM1xTWb/DUI0jJtgp5eCkfqR8P2VsEdpwO
         LrERaeU/nvpbg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 288A5608AF;
        Fri, 23 Jul 2021 15:40:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net] tipc: fix sleeping in tipc accept routine
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162705480416.17668.10408580954160867036.git-patchwork-notify@kernel.org>
Date:   Fri, 23 Jul 2021 15:40:04 +0000
References: <20210723022534.5112-1-hoang.h.le@dektech.com.au>
In-Reply-To: <20210723022534.5112-1-hoang.h.le@dektech.com.au>
To:     Hoang Le <hoang.h.le@dektech.com.au>
Cc:     jmaloy@redhat.com, maloy@donjonn.com, ying.xue@windriver.com,
        kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 23 Jul 2021 09:25:34 +0700 you wrote:
> The release_sock() is blocking function, it would change the state
> after sleeping. In order to evaluate the stated condition outside
> the socket lock context, switch to use wait_woken() instead.
> 
> Fixes: 6398e23cdb1d8 ("tipc: standardize accept routine")
> Acked-by: Jon Maloy <jmaloy@redhat.com>
> Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
> 
> [...]

Here is the summary with links:
  - [net] tipc: fix sleeping in tipc accept routine
    https://git.kernel.org/netdev/net/c/d237a7f11719

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


