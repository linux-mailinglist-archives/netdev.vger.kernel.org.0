Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8761A3A36A5
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 23:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230353AbhFJVwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 17:52:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:56164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230236AbhFJVwC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 17:52:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DD414611CD;
        Thu, 10 Jun 2021 21:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623361805;
        bh=kCzItAmTLsiHdFwEFKm5Ppo3StfgizN4eZjE3m2lYGw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NIjniqn/uPeNV2AcWuLpn1J3CpyfquEgz4SwL+pH0IKErFS9iFjtbYZndi9Vr+iD9
         w/PdVkFVqLU0pMUd3wAMro1wo9M2rsh7d7ySf7sIxB8zLo3aZ8uhGseBGdoSQbi7ZW
         tPziyVbcATeZw9J3IbWjLZ4vtMbdj79zL3ZNlvWhDPpbG8haKNE4wdumypDowNuRZS
         Fp+cv/QdZJtflfVbk7XH6L/D7ffhl8A0CFxHDQ9DBVp1OJV+ZlPZbukx9POMjc5PNn
         sSf1Pm1zfXxbkChHXgtcv9gpG7qu4e7JQ1S9xFuGDCMUfbVKpHmbqk2N3ZbRuSnS5e
         zvljplWCsacFA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CA0B560CE4;
        Thu, 10 Jun 2021 21:50:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2 v2] net: bridge: vlan tunnel egress path fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162336180582.29138.17882840843997204380.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Jun 2021 21:50:05 +0000
References: <20210610120411.128339-1-razor@blackwall.org>
In-Reply-To: <20210610120411.128339-1-razor@blackwall.org>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, roopa@nvidia.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org, nikolay@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Thu, 10 Jun 2021 15:04:09 +0300 you wrote:
> From: Nikolay Aleksandrov <nikolay@nvidia.com>
> 
> Hi,
> These two fixes take care of tunnel_dst problems in the vlan tunnel egress
> path. Patch 01 fixes a null ptr deref due to the lockless use of tunnel_dst
> pointer without checking it first, and patch 02 fixes a use-after-free
> issue due to wrong dst refcounting (dst_clone() -> dst_hold_safe()).
> 
> [...]

Here is the summary with links:
  - [net,1/2,v2] net: bridge: fix vlan tunnel dst null pointer dereference
    https://git.kernel.org/netdev/net/c/58e2071742e3
  - [net,2/2,v2] net: bridge: fix vlan tunnel dst refcnt when egressing
    https://git.kernel.org/netdev/net/c/cfc579f9d89a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


