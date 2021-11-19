Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56970456E21
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 12:20:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235046AbhKSLXb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 06:23:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:49922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233041AbhKSLXa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 06:23:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 4C11D61AFD;
        Fri, 19 Nov 2021 11:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637320829;
        bh=rP2siSj8/2/EJHdJBXMsMlfCpSrl01T6xJwYutszeyg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Z8uh3d7ryqdO0bnyob3m/J6pJKf4XX3bi+Uw8IHtU2ai1Kr7rG2loypqOBQVZ1ost
         d+cb3ZEpMrl0d5FGxG7JuqA67tILGNyVIXJff6SoTm29X67QbEQu0jsTLaJodDuq5N
         ifPlt5FkCc3MK1gl8scEsBRtV6RgXjYssaUcal9wfpbD+8Vt2aglgUotZpQoSkpfYx
         IKrxWGvq5+3mn1b6XDPKHzzXfWHLOiGgoIKa1aajGYH9CB5KM+LBVH6WoiPKGWqCp7
         yNI6WlahJtxYeMC/U1/wwoeu9lFUPZL6FFMIaRzbwQrZMVmwAZQI/eJygQQ1LLyx43
         MxIiNAs7WkTzQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 425396096E;
        Fri, 19 Nov 2021 11:20:29 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/15] use eth_hw_addr_set() in arch-specific drivers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163732082926.28994.13833011296629116673.git-patchwork-notify@kernel.org>
Date:   Fri, 19 Nov 2021 11:20:29 +0000
References: <20211119071033.3756560-1-kuba@kernel.org>
In-Reply-To: <20211119071033.3756560-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 18 Nov 2021 23:10:18 -0800 you wrote:
> Fixups for more arch-specific drivers.
> 
> With these (and another patch which didn't fit) the build is more or
> less clean with all cross-compilers available on kernel.org. I say
> more or less because around half of the arches fail to build for
> unrelated reasons right now.
> 
> [...]

Here is the summary with links:
  - [net-next,01/15] amd: lance: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/0222ee53c483
  - [net-next,02/15] amd: ni65: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/69ede3097b87
  - [net-next,03/15] amd: a2065/ariadne: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/285e4c664d64
  - [net-next,04/15] amd: hplance: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/21942eef0627
  - [net-next,05/15] amd: atarilance: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/c3dc2f7196ca
  - [net-next,06/15] amd: mvme147: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/cc71b8b9376f
  - [net-next,07/15] 8390: smc-ultra: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/5114ddf8dd88
  - [net-next,08/15] 8390: hydra: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/d7d28e90e229
  - [net-next,09/15] 8390: mac8390: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/973a34c087f4
  - [net-next,10/15] 8390: wd: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/f95f8e890a2a
  - [net-next,11/15] smc9194: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/80db345e7df0
  - [net-next,12/15] lasi_82594: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/5b6d5affd274
  - [net-next,13/15] apple: macmace: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/e217fc4affc8
  - [net-next,14/15] cirrus: mac89x0: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/9a962aedd30f
  - [net-next,15/15] natsemi: macsonic: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/bb52aff3e321

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


