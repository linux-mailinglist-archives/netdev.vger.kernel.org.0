Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2C03BA4BF
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 22:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231567AbhGBUmk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 16:42:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:45342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231190AbhGBUmh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Jul 2021 16:42:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CC13A6141D;
        Fri,  2 Jul 2021 20:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625258404;
        bh=pDpPd+RekMhCwOKJtmGzM3Sf+c+QKLCBOJExP5EL/rg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=t914qp6MhoB6v8c3yVXQE/njOjYxx71hUFfUP58+3kryrSpcPEIeR697GuBAiGBuX
         S5V2HZszY5JmhYNOfuau1dPm5mhimMT+z8dXEx+aQXQKqjK6ukuGVFnAnVNpPbx2jk
         KheraalcMek02qvxzGuW5F88KLvD/5R5scLOhGSBdcD6EWgwcp7ekOMI2U+eqRPS7u
         C1K/wxmlq6B5Wth9aU7RKwLsWiRJx1UBeutMGtiMtNEEHFxnSxSbuiiYprERIsmtpP
         n1diQQ1SHPRVruDloYlZ5pcXC6jnHm+4497NhE65NzpdDZZp9b7KgQ27GX3haBMUXy
         YUHju6jbzClMw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B8B0560CD0;
        Fri,  2 Jul 2021 20:40:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sock: fix error in sock_setsockopt()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162525840474.26489.15474659299777118005.git-patchwork-notify@kernel.org>
Date:   Fri, 02 Jul 2021 20:40:04 +0000
References: <20210702144101.3815601-1-eric.dumazet@gmail.com>
In-Reply-To: <20210702144101.3815601-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, jsperbeck@google.com, pabeni@redhat.com,
        fw@strlen.de, mathew.j.martineau@linux.intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri,  2 Jul 2021 07:41:01 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Some tests are failing, John bisected the issue to a recent commit.
> 
> sock_set_timestamp() parameters should be :
> 
> 1) sk
> 2) optname
> 3) valbool
> 
> [...]

Here is the summary with links:
  - [net] sock: fix error in sock_setsockopt()
    https://git.kernel.org/netdev/net/c/81b4a0cc7565

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


