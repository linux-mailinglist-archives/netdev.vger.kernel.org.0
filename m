Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE8833F0E4E
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 00:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234724AbhHRWkp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 18:40:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:55344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234624AbhHRWkm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 18:40:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B8532610D2;
        Wed, 18 Aug 2021 22:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629326406;
        bh=ub4117PCBJL9tI8sXJcmEZA5GAcpq4QhJp59K8FOGCg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sZNV5qdbb3+fOs/E8z3dR0c/tCfOvkerE39Fmd5PzQ6ipRUatnOVFkdRNlq/LYiY3
         Jv8EKJ/2Bto1+zxGc1fz8LRZ+STBwdzEIuEf6XDskt6HXGLZgZ4xkYn05XBOF5KfBr
         dNC8sa8Qc6TmpPAx2iJ8zD0nA6+7I3iA4lX/ybBCumbmGnbGW6e0h3Db18sb8Vk2uP
         ckeK29K+oFSHBXsrYdM/vZUQgQMMUMpH0MDpKskSSFzCda3dlHCrpemxDCJLtHklTH
         HJQ7PH95qUxbBrFVYT6PoWDWPf0zG+jYEy6SJkO3jr6OirOqK5vCl8ThH7ZstTHCRE
         4VaMxpHsdPWtQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AEC6660A25;
        Wed, 18 Aug 2021 22:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] net/rds: dma_map_sg is entitled to merge entries
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162932640671.7744.17327639180995052321.git-patchwork-notify@kernel.org>
Date:   Wed, 18 Aug 2021 22:40:06 +0000
References: <60efc69f-1f35-529d-a7ef-da0549cad143@oracle.com>
In-Reply-To: <60efc69f-1f35-529d-a7ef-da0549cad143@oracle.com>
To:     Gerd Rausch <gerd.rausch@oracle.com>
Cc:     santosh.shilimkar@oracle.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 17 Aug 2021 10:04:37 -0700 you wrote:
> Function "dma_map_sg" is entitled to merge adjacent entries
> and return a value smaller than what was passed as "nents".
> 
> Subsequently "ib_map_mr_sg" needs to work with this value ("sg_dma_len")
> rather than the original "nents" parameter ("sg_len").
> 
> This old RDS bug was exposed and reliably causes kernel panics
> (using RDMA operations "rds-stress -D") on x86_64 starting with:
> commit c588072bba6b ("iommu/vt-d: Convert intel iommu driver to the iommu ops")
> 
> [...]

Here is the summary with links:
  - [net,1/1] net/rds: dma_map_sg is entitled to merge entries
    https://git.kernel.org/netdev/net/c/fb4b1373dcab

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


