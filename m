Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33728474318
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 14:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234230AbhLNNAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 08:00:13 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34558 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234209AbhLNNAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 08:00:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C0A3B819A1
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 13:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 08A73C34601;
        Tue, 14 Dec 2021 13:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639486811;
        bh=rcvXhsTtmUwhkSQo0BUkB0QE59IwN0wRuEEY0LOzgSM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mxdqdGXgzmnjPOg/HLAQ9o0aSQZO/pTRbHbLv4CW1AcFhoqOLiYZNKEZCMozNtFlL
         3u4LDqOwn8u8ODz+Jk1GAJj6OMNKvLJ3qI+a0Zids+DzlK8IPCzdgaEFr61s/fupHj
         Pw7idy/9D19IP5E7Opu+8aPoULYKCtnHPJgCKwR4bf1In2URbpDj/mOOQHdCeaA3P4
         6Nml7mKYgP7UEHlMh5NutpzMVcUijD2e13fmSmafEH0Gn16fvY2jVwV+M223ySV1qQ
         Ut5E/2CsGdjMKmintyUf7veKghkiFzKvIFWrSHh64EZD+d8GYE3H+eMThlXuiv7lmr
         SlnHRnhPNE9wA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E14B4609BA;
        Tue, 14 Dec 2021 13:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] mlxsw: MAC profiles occupancy fix
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163948681091.21223.10785446521938015502.git-patchwork-notify@kernel.org>
Date:   Tue, 14 Dec 2021 13:00:10 +0000
References: <20211214102137.580179-1-idosch@nvidia.com>
In-Reply-To: <20211214102137.580179-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, danieller@nvidia.com, mlxsw@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 14 Dec 2021 12:21:35 +0200 you wrote:
> Patch #1 fixes a router interface (RIF) MAC profiles occupancy bug that
> was merged in the last cycle.
> 
> Patch #2 adds a selftest that fails without the fix.
> 
> Danielle Ratson (2):
>   mlxsw: spectrum_router: Consolidate MAC profiles when possible
>   selftests: mlxsw: Add a test case for MAC profiles consolidation
> 
> [...]

Here is the summary with links:
  - [net,1/2] mlxsw: spectrum_router: Consolidate MAC profiles when possible
    https://git.kernel.org/netdev/net/c/b442f2ea8462
  - [net,2/2] selftests: mlxsw: Add a test case for MAC profiles consolidation
    https://git.kernel.org/netdev/net/c/20617717cd21

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


