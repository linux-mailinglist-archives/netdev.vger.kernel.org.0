Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0166338253
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 01:31:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231336AbhCLAac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 19:30:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:53620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231197AbhCLAaP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 19:30:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id DF9AF64F91;
        Fri, 12 Mar 2021 00:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615509014;
        bh=JFkSdXDJk5Cl3aWg8vyC01K/rfowkxDb8IeNBUu6UpM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=a7AmY3YK0mbVOUVDgrImUxYWYqf2NenZYGRqgJCYlyDrgxasdLfLMwypA1Xl/gAJB
         r7Q/CM1SYIfBTprjhd/e8STKa2COUn3g0fLzqWW649BS51nKzybFAXC9WPYeJkqN1H
         r19usszrfPGIjtnFOMkj17q4E9uV8HATK5ZDW8VE3dzydZBF4HoKPlFQE4X4KcI9lt
         661MLAiigEjQMVrDARlBej++OEmirVB7kuLLmvaQMx4GKIkA1JKkip6VBn7hLYlRkC
         zfPx3xIZGfvt2p/cR8DfzA2hm201Rh7ZuJHjLHRx5AwGOhyNCR9jWqRRU8GeS8XYl3
         OI23E50jKkGnQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DB18A609CD;
        Fri, 12 Mar 2021 00:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] mlxsw: Implement sampling using mirroring
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161550901489.18262.8972537262922383855.git-patchwork-notify@kernel.org>
Date:   Fri, 12 Mar 2021 00:30:14 +0000
References: <20210311122416.2620300-1-idosch@idosch.org>
In-Reply-To: <20210311122416.2620300-1-idosch@idosch.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com, mlxsw@nvidia.com, idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 11 Mar 2021 14:24:10 +0200 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> So far, sampling was implemented using a dedicated sampling mechanism
> that is available on all Spectrum ASICs. Spectrum-2 and later ASICs
> support sampling by mirroring packets to the CPU port with probability.
> This method has a couple of advantages compared to the legacy method:
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] mlxsw: spectrum_span: Add SPAN session identifier support
    https://git.kernel.org/netdev/net-next/c/5c7659eba873
  - [net-next,2/6] mlxsw: reg: Extend mirroring registers with probability rate field
    https://git.kernel.org/netdev/net-next/c/fa3faeb7aedb
  - [net-next,3/6] mlxsw: spectrum_span: Add SPAN probability rate support
    https://git.kernel.org/netdev/net-next/c/2dcbd9207b33
  - [net-next,4/6] mlxsw: spectrum_matchall: Split sampling support between ASICs
    https://git.kernel.org/netdev/net-next/c/20afb9bc480d
  - [net-next,5/6] mlxsw: spectrum_trap: Split sampling traps between ASICs
    https://git.kernel.org/netdev/net-next/c/34a277212c67
  - [net-next,6/6] mlxsw: spectrum_matchall: Implement sampling using mirroring
    https://git.kernel.org/netdev/net-next/c/cf31190ae0b7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


