Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA1A034C0A2
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 02:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231705AbhC2Aka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 20:40:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:43114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230432AbhC2AkK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Mar 2021 20:40:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BFB546193F;
        Mon, 29 Mar 2021 00:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616978409;
        bh=btippTwvdKB+BCDHCo76yfuX81O5LrJWfyT0WrfksoY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ufb23e2EPNIIBQ40aUvd5+sKsR76upFwRpfDdADS4wZW56F3i6gRZxbolYfa4tArh
         b78xaA3IX65LXBeTDbe4aDahN65w22dushDjKEJltIjeGyK68e5gkfCiXCWFMsNt9T
         NdvLmBcMj8yeXAJWXgoeJj6pWtPzudnWpW3NtQMYKnZ4lwtlmv1fDZmrpLDJEVzoNX
         Qeey97tsN9XorZGQe6wcg+w1clQjwhUZcaNcTvyCv0ZubVxSeGMivCDwF4MMoL7vMU
         Q/n+Ezqudtu3u2MitsV2LnDiRZztP3QGC1DMAKde6KczuhSiDLlwGvbeVQPeNtOIzq
         eKCyaTsEAK39A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B07BF609E8;
        Mon, 29 Mar 2021 00:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ipv6: addrconf.c: Fix a typo
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161697840971.22621.5059172573846136972.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Mar 2021 00:40:09 +0000
References: <20210326231608.24407-5-unixbhaskar@gmail.com>
In-Reply-To: <20210326231608.24407-5-unixbhaskar@gmail.com>
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rdunlap@infradead.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 27 Mar 2021 04:42:40 +0530 you wrote:
> s/Identifers/Identifiers/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
> ---
>  net/ipv6/addrconf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> [...]

Here is the summary with links:
  - ipv6: addrconf.c: Fix a typo
    https://git.kernel.org/netdev/net-next/c/912b519afc8f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


