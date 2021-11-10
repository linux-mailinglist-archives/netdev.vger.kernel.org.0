Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFB3B44C35E
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 15:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232286AbhKJOw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 09:52:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:42786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231743AbhKJOw5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 09:52:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 1A8BE61260;
        Wed, 10 Nov 2021 14:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636555809;
        bh=oTlyjQNAHjMz+AYWY1fgWpepM01o3DwdwzAhdgw87/s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WnN/aJgVq3OTU0rZP5brs5n3S8jSPeaJsdlvR0oXST+MEjnIkLFlTl+m2T1Uero8Z
         vOsFj7sbEJmLO5GReA5DMyRp1XZRrwKhfsD61crUiioy4QU+qb0uxfcgAtUTXeoLRu
         +rEbDQYuUVzfG1nB9iF/3aCvVd9xwxRrgFyNkKVOAIoONpIxAxJSITh71hPlymmc8S
         +pCHrfKweWWENs/a9EVg+/WGF3GMwLnBH6+2HKvD7RiregsU8UR0etxAeKQNT8eJlU
         JT3I1LV6ufPWjk3YVv4FauQKLBINpL8qxmyN7Ubyze3aloE32/3cgnmJH2EUChwxDk
         spL1dRsDicB9A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 134E360AA3;
        Wed, 10 Nov 2021 14:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/smc: fix sk_refcnt underflow on linkdown and fallback
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163655580907.25401.1603887156764424326.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Nov 2021 14:50:09 +0000
References: <20211110070234.60527-1-dust.li@linux.alibaba.com>
In-Reply-To: <20211110070234.60527-1-dust.li@linux.alibaba.com>
To:     Dust Li <dust.li@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, ubraun@linux.vnet.ibm.com,
        tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
        xuanzhuo@linux.alibaba.com, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 10 Nov 2021 15:02:34 +0800 you wrote:
> We got the following WARNING when running ab/nginx
> test with RDMA link flapping (up-down-up).
> The reason is when smc_sock fallback and at linkdown
> happens simultaneously, we may got the following situation:
> 
> __smc_lgr_terminate()
>  --> smc_conn_kill()
>     --> smc_close_active_abort()
>            smc_sock->sk_state = SMC_CLOSED
>            sock_put(smc_sock)
> 
> [...]

Here is the summary with links:
  - [net] net/smc: fix sk_refcnt underflow on linkdown and fallback
    https://git.kernel.org/netdev/net/c/e5d5aadcf3cd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


