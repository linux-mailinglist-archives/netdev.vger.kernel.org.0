Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80F8B3102CD
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 03:33:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbhBECav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 21:30:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:45214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229788AbhBECas (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 21:30:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id DD5EF64E27;
        Fri,  5 Feb 2021 02:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612492207;
        bh=wfqIdPgsn3NSemVys0jN0dRitrW+MiDaTu7Ise2p/Ig=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jOldxq+PZmpGnqh0evk453lc4cWeQraVez3kLdLbIOiWC08C62h29uQZdMt+bGHTt
         rOhOYX4J2h9+s8xe+rrUu6mel07YDWbioet74hu+TPGokNBfEuDDUrugwgSF/s9KVo
         Ca1yCPu12m64DEEEqqfS0i03rovvdiN4skSz6QlEuMA7ihliP3fgY635ih6BEMyif7
         2WzxldC7JEzCz5nPts4un1tS4orK3UY9HMKiUH6DOgzLE3RwsM8hI4RSpWz5+mqZuM
         dR6IkedftbBu9tZrZVUELCvIH17+MmUcUhL9OAv9E8ERnTPcPNOJbWWVkn1E25O/NW
         XlJJXYclJwGeg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D3EBA609F1;
        Fri,  5 Feb 2021 02:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/2] net: add EXPORT_INDIRECT_CALLABLE wrapper
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161249220786.5682.17535599509541721272.git-patchwork-notify@kernel.org>
Date:   Fri, 05 Feb 2021 02:30:07 +0000
References: <20210204181839.558951-1-brianvv@google.com>
In-Reply-To: <20210204181839.558951-1-brianvv@google.com>
To:     Brian Vazquez <brianvv@google.com>
Cc:     brianvv.kernel@gmail.com, edumazet@google.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        sfr@canb.auug.org.au
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu,  4 Feb 2021 18:18:38 +0000 you wrote:
> When a static function is annotated with INDIRECT_CALLABLE_SCOPE and
> CONFIG_RETPOLINE is set, the static keyword is removed. Sometimes the
> function needs to be exported but EXPORT_SYMBOL can't be used because if
> CONFIG_RETPOLINE is not set, we will attempt to export a static symbol.
> 
> This patch introduces a new indirect call wrapper:
> EXPORT_INDIRECT_CALLABLE. This basically does EXPORT_SYMBOL when
> CONFIG_RETPOLINE is set, but does nothing when it's not.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: add EXPORT_INDIRECT_CALLABLE wrapper
    https://git.kernel.org/netdev/net-next/c/0053859496ba
  - [net-next,2/2] net: fix building errors on powerpc when CONFIG_RETPOLINE is not set
    https://git.kernel.org/netdev/net-next/c/9c97921a51a0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


