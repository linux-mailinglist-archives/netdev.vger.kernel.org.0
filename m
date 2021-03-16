Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 133C733E18E
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 23:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231510AbhCPWkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 18:40:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:59012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231415AbhCPWkL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 18:40:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D201964F40;
        Tue, 16 Mar 2021 22:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615934410;
        bh=65UI8Ckuk0tgsY8o0uT63ZLLbPucG5DTQMJSh9QGnSI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GfqipmvPOmI/ibUNTv6mVo25CGaenBsgxWWGkKVuV1tHcAF9hsdaWmjDhqVa7fwgU
         ayCQi8bd0bepLYTDyZIw8KRSbTsdd9UUqib+Gp1Ovqj74UAUhEha77gAqoYpDhyTq4
         mN8x10bV2Q80iVkx+omMI6AXY52W+tUNnn2Mx41Mt4+VvvArPAO1qnTbQHwJHzHW/w
         ar516rsemETL8mfx7VzN0mrxz7ziLOWYcDt9Vj5pvmFtBwt/v/POtwXpC3L3biOYJr
         ZWIpqcqBowdF8cpfTeK2TwYMs7mp+fV9YSjo+MkHRtynmW7qzcLyLUocFWixHrAIZ2
         J1Y1ATA+sHseQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CD04060A60;
        Tue, 16 Mar 2021 22:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/10] mlxsw: Add support for egress and policy-based
 sampling
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161593441083.11342.440625160850413705.git-patchwork-notify@kernel.org>
Date:   Tue, 16 Mar 2021 22:40:10 +0000
References: <20210316150303.2868588-1-idosch@idosch.org>
In-Reply-To: <20210316150303.2868588-1-idosch@idosch.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com, roopa@nvidia.com, peter.phaal@inmon.com,
        neil.mckee@inmon.com, mlxsw@nvidia.com, idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 16 Mar 2021 17:02:53 +0200 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> So far mlxsw only supported ingress sampling using matchall classifier.
> This series adds support for egress sampling and policy-based sampling
> using flower classifier on Spectrum-2 and newer ASICs. As such, it is
> now possible to issue these commands:
> 
> [...]

Here is the summary with links:
  - [net-next,01/10] mlxsw: spectrum_matchall: Propagate extack further
    https://git.kernel.org/netdev/net-next/c/6561df560833
  - [net-next,02/10] mlxsw: spectrum_matchall: Push sampling checks to per-ASIC operations
    https://git.kernel.org/netdev/net-next/c/559313b2cbb7
  - [net-next,03/10] mlxsw: spectrum_matchall: Pass matchall entry to sampling operations
    https://git.kernel.org/netdev/net-next/c/e09a59555a30
  - [net-next,04/10] mlxsw: spectrum: Track sampling triggers in a hash table
    https://git.kernel.org/netdev/net-next/c/1b9fc42e46df
  - [net-next,05/10] mlxsw: spectrum: Start using sampling triggers hash table
    https://git.kernel.org/netdev/net-next/c/90f53c53ec4a
  - [net-next,06/10] mlxsw: spectrum_matchall: Add support for egress sampling
    https://git.kernel.org/netdev/net-next/c/54d0e963f683
  - [net-next,07/10] mlxsw: core_acl_flex_actions: Add mirror sampler action
    https://git.kernel.org/netdev/net-next/c/ca19ea63f739
  - [net-next,08/10] mlxsw: spectrum_acl: Offload FLOW_ACTION_SAMPLE
    https://git.kernel.org/netdev/net-next/c/45aad0b7043d
  - [net-next,09/10] selftests: mlxsw: Add tc sample tests for new triggers
    https://git.kernel.org/netdev/net-next/c/f0b692c4ee2f
  - [net-next,10/10] selftests: mlxsw: Test egress sampling limitation on Spectrum-1 only
    https://git.kernel.org/netdev/net-next/c/0f967d9e5a20

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


