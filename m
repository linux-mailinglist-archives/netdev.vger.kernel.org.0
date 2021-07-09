Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C26BD3C2A95
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 23:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbhGIVCt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 17:02:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:42410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229506AbhGIVCr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Jul 2021 17:02:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DB2F3613C8;
        Fri,  9 Jul 2021 21:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625864403;
        bh=qs0YhYc9rD+xSHKpEwOqb4dxqCPwrS1i6dL084z1pMo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YF3Pvg22DXuV0uyyM3yql2cij6xq2bX0RwqR2aSISDRVMTBj0IrBpE/EjQQXMbHIc
         40wbNScmo3ABcKBYb4qLohDKAm0TMCNrapGS3YT2rNKu+zMk61ilmRTeEvoQe44oOK
         YLzwI8dV2EeOOuPop4DbxSuKE+mL61Rsedaz39MNEhwrQORE1myd+cgRV/75v0KDKj
         8bpsDP8QrvUyMocTQUbsM2wKjMRYVGDjiyrHPuebPAta7Q1kiacrhKhOfZSe3t6Chh
         UJ8qQMo/FTjbiRQZDw9YnZ3MUNNmbTf2FbMpj5U8FMUFK6VudQXXsaS1VxWsQqIM5M
         RP2mbno5PDndw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CE920609AD;
        Fri,  9 Jul 2021 21:00:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: ip_tunnel: fix mtu calculation for ETHER tunnel
 devices
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162586440384.29766.2729675914684653511.git-patchwork-notify@kernel.org>
Date:   Fri, 09 Jul 2021 21:00:03 +0000
References: <20210709034502.1227174-1-liuhangbin@gmail.com>
In-Reply-To: <20210709034502.1227174-1-liuhangbin@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, vfedorenko@novek.ru,
        xiyou.wangcong@gmail.com, kuba@kernel.org,
        gregkh@linuxfoundation.org, jishi@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri,  9 Jul 2021 11:45:02 +0800 you wrote:
> Commit 28e104d00281 ("net: ip_tunnel: fix mtu calculation") removed
> dev->hard_header_len subtraction when calculate MTU for tunnel devices
> as there is an overhead for device that has header_ops.
> 
> But there are ETHER tunnel devices, like gre_tap or erspan, which don't
> have header_ops but set dev->hard_header_len during setup. This makes
> pkts greater than (MTU - ETH_HLEN) could not be xmited. Fix it by
> subtracting the ETHER tunnel devices' dev->hard_header_len for MTU
> calculation.
> 
> [...]

Here is the summary with links:
  - [net] net: ip_tunnel: fix mtu calculation for ETHER tunnel devices
    https://git.kernel.org/netdev/net/c/9992a078b177

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


