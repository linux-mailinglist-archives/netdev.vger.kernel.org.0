Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0377F31A6C3
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 22:21:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231532AbhBLVVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 16:21:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:60368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232057AbhBLVUu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 16:20:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 823D064DA1;
        Fri, 12 Feb 2021 21:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613164810;
        bh=RglRVVk5EcX0mXsvQLJYb9c6zEWMKOniLWFRLJewrBw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZtULdh3gwTzKfIGbY4YS7TURochzHYvtUHC82JJ4w6adKx322HMb/ga6dkWO6t9g0
         VNbzExbHXn3jX1vcMPpCMpWxOqeoygIRMryNDNuw/PQ822lk9qSKFlsTepq4/HM2GT
         uNiD7GkwEevzAgbTfseTT6f9b99M7JX80fQ2ewzrBrI3NJfscH+tO8Fuucd3hUNQAG
         ND5QVevKt6vE/z9Nj3ecMKnA2p03yhc18mPv5rflNEOOzvfNd6lb51usJMvqY9Ce0R
         LgGQQa0CJhGGaw4mHWqTrS0cRd15xODgSOADZ/dVU6KblTd0EDkODj1vVPr8PZsfhg
         C53z/VjZuHItQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 761E860A2E;
        Fri, 12 Feb 2021 21:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] Compile-flag for sock RX queue mapping
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161316481047.12385.11189264392187390443.git-patchwork-notify@kernel.org>
Date:   Fri, 12 Feb 2021 21:20:10 +0000
References: <20210211113553.8211-1-tariqt@nvidia.com>
In-Reply-To: <20210211113553.8211-1-tariqt@nvidia.com>
To:     Tariq Toukan <tariqt@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, borisp@nvidia.com,
        netdev@vger.kernel.org, ttoukan.linux@gmail.com, moshe@nvidia.com,
        maximmi@nvidia.com, saeedm@nvidia.com, john.fastabend@gmail.com,
        daniel@iogearbox.net, ast@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 11 Feb 2021 13:35:50 +0200 you wrote:
> Hi,
> 
> Socket's RX queue mapping logic is useful also for non-XPS use cases.
> This series breaks the dependency between the two, introducing a new
> kernel config flag SOCK_RX_QUEUE_MAPPING.
> 
> Here we select this new kernel flag from TLS_DEVICE, as well as XPS.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] net/sock: Add kernel config SOCK_RX_QUEUE_MAPPING
    https://git.kernel.org/netdev/net-next/c/4e1beecc3b58
  - [net-next,2/3] net/tls: Select SOCK_RX_QUEUE_MAPPING from TLS_DEVICE
    https://git.kernel.org/netdev/net-next/c/76f165939ea3
  - [net-next,3/3] net/mlx5: Remove TLS dependencies on XPS
    https://git.kernel.org/netdev/net-next/c/2af3e35c5a04

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


