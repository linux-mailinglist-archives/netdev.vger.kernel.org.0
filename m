Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8D9742CFC3
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 03:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbhJNBCM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 21:02:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:35828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229660AbhJNBCL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 21:02:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E9FE861181;
        Thu, 14 Oct 2021 01:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634173208;
        bh=CLoSyWVS6ts1sfaswnKU4RS/yzUMw8brR1Qd4YGCHyw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VXGRUrwMOVsQWADBj9+T0nRy+UIO6FDXiyHF6DAZNKaE54oWGng7YiIrV4Z2jJ2aF
         +pxVQ37U2x3+Lp71eXwDtZBxZSQbeIE23PHgbOdczsrk/QEqB7DGK7LvG6O4pD1vZC
         u8euXYI8qAq2v7Y+cD8O3j0MzBE9O3sQl6lbKbHDlcPjx2oD3XIUipwxtma7lE078N
         kbWysHLI0WFtyRiLDVJCiP1Y/f2p8BBvVuv9FiNp/ivdt57AnXpIDHeShgG8ikmxOY
         19KfcY1q/Ij90fDshAnuLYaO1X2hvOau0wj6PW/i+eQHylNwq+Rz+LD+WUMOoxGtWn
         j+7o9J/KqjU5A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DD31B609CF;
        Thu, 14 Oct 2021 01:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5] mlxsw: Show per-band ECN-marked counter on qdisc
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163417320790.18513.14257429887955313854.git-patchwork-notify@kernel.org>
Date:   Thu, 14 Oct 2021 01:00:07 +0000
References: <20211013103748.492531-1-idosch@idosch.org>
In-Reply-To: <20211013103748.492531-1-idosch@idosch.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com, petrm@nvidia.com, mlxsw@nvidia.com,
        idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 13 Oct 2021 13:37:43 +0300 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Petr says:
> 
> The RED qdisc can expose number of packets that it has marked through
> the prob_marked counter (shown in iproute2 as "marked"). This counter
> currently just shows number of packets marked in the SW datapath, which
> in a switch deployment likely means zero.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] mlxsw: reg: Fix a typo in a group heading
    https://git.kernel.org/netdev/net-next/c/b063e0651ced
  - [net-next,2/5] mlxsw: reg: Rename MLXSW_REG_PPCNT_TC_CONG_TC to _CNT
    https://git.kernel.org/netdev/net-next/c/fc372cc07286
  - [net-next,3/5] mlxsw: reg: Add ecn_marked_tc to Per-TC Congestion Counters
    https://git.kernel.org/netdev/net-next/c/6242b0a96302
  - [net-next,4/5] mlxsw: spectrum_qdisc: Introduce per-TC ECN counters
    https://git.kernel.org/netdev/net-next/c/15be36b8126b
  - [net-next,5/5] selftests: mlxsw: RED: Test per-TC ECN counters
    https://git.kernel.org/netdev/net-next/c/bf862732945c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


