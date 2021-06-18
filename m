Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B35953AD385
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 22:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233111AbhFRUWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 16:22:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:47212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230136AbhFRUWO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 16:22:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B0BB06124C;
        Fri, 18 Jun 2021 20:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624047604;
        bh=y8Wb3ODTfwKQN26jd5Z65I/+5QFKTRNmTyB30C49akw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=msgQPFKSFUjqyDzCpM2ds9kGTb0Bwv+InPcKBxRU5sKqxN8CZvAjy5vgDuz4pBwg/
         KmxX9Ufx1UlMveNtNJPcv9bkiPmfu98EwWYpilR2DKgUInsanRo5DrnnPjbpVkpe+U
         uoCnOcQFiN3q7ZBmHFaSelj5eOf/KNr36LHNd97GHxwGvibvCXeKQj2+Btw9uYO7B/
         7SDNIs/Zdv0MyNyzpHLa46yFYjzbT+SKjXnCsv08UG9azcUF2aEWN1uY3aRqzhHNV1
         dfTjoE+i6fOjJtCldvK5kQlcuhFYaJgxuzpPAC3EysHpWi9LYdgaFrS+GTXYqjCuut
         wGBeAUdtrOJSw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A2BF660C29;
        Fri, 18 Jun 2021 20:20:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3][pull request] 100GbE Intel Wired LAN Driver
 Updates 2021-06-18
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162404760466.11552.1483547432976975900.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Jun 2021 20:20:04 +0000
References: <20210618162932.859071-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210618162932.859071-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com, jesse.brandeburg@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 18 Jun 2021 09:29:29 -0700 you wrote:
> Jesse Brandeburg says:
> 
> Update three of the Intel Ethernet drivers with similar (but not the
> same) improvements to simplify the packet type table init, while removing
> an unused structure entry. For the ice driver, the table is extended
> to 10 bits, which is the hardware limit, and for now is initialized
> to zero.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] ice: report hash type such as L2/L3/L4
    https://git.kernel.org/netdev/net-next/c/dda90cb90a5c
  - [net-next,2/3] i40e: clean up packet type lookup table
    https://git.kernel.org/netdev/net-next/c/c6e088bf30dc
  - [net-next,3/3] iavf: clean up packet type lookup table
    https://git.kernel.org/netdev/net-next/c/37dc8fea8656

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


