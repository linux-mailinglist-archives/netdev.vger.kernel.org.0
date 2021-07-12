Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D85563C6236
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 19:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233621AbhGLRwx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 13:52:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:34858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231592AbhGLRww (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Jul 2021 13:52:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D285A611C1;
        Mon, 12 Jul 2021 17:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626112203;
        bh=m1u+wsv4BJOX3LivCYyJp0GfsFgFqYK+vfWFUwQLN38=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=b+uicz15iiBfEcOLpE4brAL1ii21QEunJ698xJX21eGLJP/q4iRHLmc1vsTEm5TuK
         f/JSlbXiCLwTE2Jm7rOnUbqpzfZie5El9np9MsQkGIgJrWteDWOwE7caZfKFXYyMCX
         SnyPwPoIdG1JWRCvRE4c8LTA193tN9o+eAvl8ZtcZ7s7FHWK08dnBJmFeOTGifvZ8A
         rSkFQWewoy1RU50hmdYg9O+P6NSjG83l9yNYZEGxCDR5VfWrnpZti1kczHa29dO0ba
         T687BCvCPT6AR2DTk06xaFmLzStmWySiPj+tU43pJHJHAANbwnWDiYNkbjLxfaRfu9
         P+Wd/PY5v6NXA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C5C1460A54;
        Mon, 12 Jul 2021 17:50:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] net: bridge: multicast: fix automatic router port
 marking races
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162611220380.1672.9078277385481579129.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Jul 2021 17:50:03 +0000
References: <20210711095629.2986949-1-razor@blackwall.org>
In-Reply-To: <20210711095629.2986949-1-razor@blackwall.org>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, stable@vger.kernel.org, roopa@nvidia.com,
        bridge@lists.linux-foundation.org, nikolay@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Sun, 11 Jul 2021 12:56:27 +0300 you wrote:
> From: Nikolay Aleksandrov <nikolay@nvidia.com>
> 
> Hi,
> While working on per-vlan multicast snooping I found two race conditions
> when multicast snooping is enabled. They're identical and happen when
> the router port list is modified without the multicast lock. One requires
> a PIM hello message to be received on a port and the other an MRD
> advertisement. To fix them we just need to take the multicast_lock when
> adding the ports to the router port list (marking them as router ports).
> Tested on an affected setup by generating the required packets while
> modifying the port list in parallel.
> 
> [...]

Here is the summary with links:
  - [net,1/2] net: bridge: multicast: fix PIM hello router port marking race
    https://git.kernel.org/netdev/net/c/04bef83a3358
  - [net,2/2] net: bridge: multicast: fix MRD advertisement router port marking race
    https://git.kernel.org/netdev/net/c/000b7287b675

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


