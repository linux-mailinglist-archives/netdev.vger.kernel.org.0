Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6800D42808A
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 12:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231741AbhJJKmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 06:42:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:54412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231612AbhJJKmF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Oct 2021 06:42:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0C00860F55;
        Sun, 10 Oct 2021 10:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633862407;
        bh=95c8hvYZ/DE/geYzhsrvQV/bJYdcWDPVETGJnUjS60w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mEJH4eBHjFU/u8NdLjs4fKztOMwZficKC7yIB6u3n32fqhusTqTBJsYBtfvUcsAlu
         08pYafn5qc8VeYFDddCDKcO+wnVtMkjIHCdX+ZKZ8oMmL6dFNy++gCxTdvaC6se6Os
         l/V7J8xVMnMKZ1NagG6DL74kqxrwAuRf7AKkrJcoTTNSfSsaps2d3UqEXhBRSrRufq
         +wSdlfWy/PuNBTO2tB+IIQvt3yLUYEzmbOt1PeHk0qQo5WBvNEVbrs0u0NDwDU1ynn
         MeWduI/HQGDPbb49Pyi9JsMh+hPeIDTn47CDez1EDZI7UAQ/kdIck0VGkmuxKOMdS8
         lw/H/mivE4AXA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EFC2D60BE4;
        Sun, 10 Oct 2021 10:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ethernet: Remove redundant 'flush_workqueue()' calls
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163386240697.21532.13147664390209951167.git-patchwork-notify@kernel.org>
Date:   Sun, 10 Oct 2021 10:40:06 +0000
References: <3dadac919f6f4a991953965ddbb975f2586e6ecf.1633848953.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <3dadac919f6f4a991953965ddbb975f2586e6ecf.1633848953.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     thomas.lendacky@amd.com, davem@davemloft.net, kuba@kernel.org,
        rmody@marvell.com, skalluru@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, dchickles@marvell.com,
        sburla@marvell.com, fmanlunas@marvell.com,
        ajit.khaparde@broadcom.com, sriharsha.basavapatna@broadcom.com,
        somnath.kotur@broadcom.com, sgoutham@marvell.com,
        lcherian@marvell.com, gakula@marvell.com, jerinj@marvell.com,
        hkelam@marvell.com, sbhatta@marvell.com, tariqt@nvidia.com,
        saeedm@nvidia.com, leon@kernel.org, aelior@marvell.com,
        GR-everest-linux-l2@marvell.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 10 Oct 2021 09:01:32 +0200 you wrote:
> 'destroy_workqueue()' already drains the queue before destroying it, so
> there is no need to flush it explicitly.
> 
> Remove the redundant 'flush_workqueue()' calls.
> 
> This was generated with coccinelle:
> 
> [...]

Here is the summary with links:
  - ethernet: Remove redundant 'flush_workqueue()' calls
    https://git.kernel.org/netdev/net-next/c/b9c56ccb436d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


