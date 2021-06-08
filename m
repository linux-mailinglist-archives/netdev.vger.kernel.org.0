Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB673A0360
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 21:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234593AbhFHTQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 15:16:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:59084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236109AbhFHTNx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 15:13:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3700D61950;
        Tue,  8 Jun 2021 18:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623178203;
        bh=1z13uPlX2oE0qJF/eEiBKOxWVvsVEeECpOjk56FVsYU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=r+8uDV+p56fEbe9hNGpssDC6Epu2UQp7GN78F5l9KMp51PCAUNKdDggR2zt/wowpS
         vj2vAFjFjQFgEdOEGiagvWuMZvL9i2ggPc01RDWyjyQxRTOcGjaPnQrCZlshNBV71f
         ahcd4LNTtTcJqzOVkNE6Bn9K1MBf1uZtG5O8/9V8qWNGXHI3TzbCtd0w7X1D1ZZEVG
         PbIhFf5cLFSESEKUMbdQE6H7887SW1g24IcqDZvKofOlR8uXdcr5qDbe5WC1oYpSRc
         n7vjdjv2R/wJzctZN/c1eL2zNnssUxbQ4WJYayaP0sNm/rZ8X4KBCe6i2Y3EY3K9qP
         51EP0DMy0uj4A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 20E2F60A22;
        Tue,  8 Jun 2021 18:50:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] vrf: fix maximum MTU
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162317820312.26494.1373764395210865947.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Jun 2021 18:50:03 +0000
References: <20210608145951.24985-1-nicolas.dichtel@6wind.com>
In-Reply-To: <20210608145951.24985-1-nicolas.dichtel@6wind.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        dsahern@gmail.com, linmiaohe@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue,  8 Jun 2021 16:59:51 +0200 you wrote:
> My initial goal was to fix the default MTU, which is set to 65536, ie above
> the maximum defined in the driver: 65535 (ETH_MAX_MTU).
> 
> In fact, it's seems more consistent, wrt min_mtu, to set the max_mtu to
> IP6_MAX_MTU (65535 + sizeof(struct ipv6hdr)) and use it by default.
> 
> Let's also, for consistency, set the mtu in vrf_setup(). This function
> calls ether_setup(), which set the mtu to 1500. Thus, the whole mtu config
> is done in the same function.
> 
> [...]

Here is the summary with links:
  - [net] vrf: fix maximum MTU
    https://git.kernel.org/netdev/net/c/9bb392f62447

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


