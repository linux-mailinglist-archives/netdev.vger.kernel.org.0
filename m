Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3412C46637A
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 13:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357971AbhLBMX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 07:23:58 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:58680 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357804AbhLBMXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 07:23:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C2D9CCE221B
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 12:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ECFF3C53FD1;
        Thu,  2 Dec 2021 12:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638447611;
        bh=YG7TTWE/Mu9m8MHF99A3nqXliMZS2WtAdGuBxnkSwh0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MrjUgfG/Koy5f8aCgxoozyobfxXtc0VlO+8/DU9DfP81zGzJ5RU49C0/FeKt92N5k
         m+/4sGGXvJyM03gvpq5RNocYNMgTHGSNueflihSu570CCMjJuWwqIB18xCSWx7k/p/
         wbFIFb3VR9AHCqmfYAB1ldezt6S0NW6JgsIiYEwh0mVx70GsxE/w12CuJsHwx8zmIU
         jh964vTEEe4qJW0LZpswDo2wNyNYDe6kg6zdZb+onEzRLz+nlkrNZ0pLeM+0zRWq9L
         CrMbinCBDU9/iMX6uHNaH1ivifRWxOGIeDep7WNGVIuScRA3Hop7sakHDZc7sD3+Cx
         CHe9MXD2ZNOQQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D56AD60A90;
        Thu,  2 Dec 2021 12:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH RESEND net] net/smc: Keep smc_close_final rc during active
 close
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163844761086.9736.14634506790710664041.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Dec 2021 12:20:10 +0000
References: <20211201064214.89075-1-tonylu@linux.alibaba.com>
In-Reply-To: <20211201064214.89075-1-tonylu@linux.alibaba.com>
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed,  1 Dec 2021 14:42:16 +0800 you wrote:
> When smc_close_final() returns error, the return code overwrites by
> kernel_sock_shutdown() in smc_close_active(). The return code of
> smc_close_final() is more important than kernel_sock_shutdown(), and it
> will pass to userspace directly.
> 
> Fix it by keeping both return codes, if smc_close_final() raises an
> error, return it or kernel_sock_shutdown()'s.
> 
> [...]

Here is the summary with links:
  - [RESEND,net] net/smc: Keep smc_close_final rc during active close
    https://git.kernel.org/netdev/net/c/00e158fb91df

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


