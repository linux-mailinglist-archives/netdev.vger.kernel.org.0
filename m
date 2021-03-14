Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 056CB33A89B
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 23:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbhCNWkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 18:40:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:51430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229484AbhCNWkK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Mar 2021 18:40:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B5CA164E98;
        Sun, 14 Mar 2021 22:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615761610;
        bh=N5ox1HY8gaSMPLok66ps2FOQ+7SnMFEKKcniWWBmGAo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KtRI7apyD1xytT/vfckKyTxrsmzoZbqVObt7ECTRNi8YIuqMwNI8/Tjm1xtBk8Ecd
         1HuoutH65Oh8FlIzvXzUlciL3lwEeI5sra32N40MG/WjdiCmrV5ci60OezI6Ouraoo
         iAU4OGHr56ujK73au4JpWmO56naRC1pG79IQBE9cNCtIepn48pZe8QMaLhhDhokBtP
         MR6hi17WqGo3dEvXB4F8/j/bliAlvxE2wi0ZQ8vL55e+DxY3I/Tr7PUQhmuEzK4Wa+
         LZwKugCJeu6tP5Riw/8+08JSmQIjYHQPt7jDKwOagP7Dh387xEgGNcEAZgkYA7OQtj
         PreM5MMHM2QBA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AFD9A609C5;
        Sun, 14 Mar 2021 22:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/11] psample: Add additional metadata attributes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161576161071.5046.18080621784078783490.git-patchwork-notify@kernel.org>
Date:   Sun, 14 Mar 2021 22:40:10 +0000
References: <20210314121940.2807621-1-idosch@idosch.org>
In-Reply-To: <20210314121940.2807621-1-idosch@idosch.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com, yotam.gi@gmail.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, roopa@nvidia.com, peter.phaal@inmon.com,
        neil.mckee@inmon.com, mlxsw@nvidia.com, idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sun, 14 Mar 2021 14:19:29 +0200 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> This series extends the psample module to expose additional metadata to
> user space for packets sampled via act_sample. The new metadata (e.g.,
> transit delay) can then be consumed by applications such as hsflowd [1]
> for better network observability.
> 
> [...]

Here is the summary with links:
  - [net-next,01/11] psample: Encapsulate packet metadata in a struct
    https://git.kernel.org/netdev/net-next/c/a03e99d39f19
  - [net-next,02/11] psample: Add additional metadata attributes
    https://git.kernel.org/netdev/net-next/c/07e1a5809b59
  - [net-next,03/11] netdevsim: Add dummy psample implementation
    https://git.kernel.org/netdev/net-next/c/a8700c3dd0a4
  - [net-next,04/11] selftests: netdevsim: Test psample functionality
    https://git.kernel.org/netdev/net-next/c/f26b30918dac
  - [net-next,05/11] mlxsw: pci: Add more metadata fields to CQEv2
    https://git.kernel.org/netdev/net-next/c/e0eeede3d233
  - [net-next,06/11] mlxsw: Create dedicated field for Rx metadata in skb control block
    https://git.kernel.org/netdev/net-next/c/d4cabaadeaad
  - [net-next,07/11] mlxsw: pci: Set extra metadata in skb control block
    https://git.kernel.org/netdev/net-next/c/5ab6dc9fa272
  - [net-next,08/11] mlxsw: spectrum: Remove unnecessary RCU read-side critical section
    https://git.kernel.org/netdev/net-next/c/e1f78ecdfd59
  - [net-next,09/11] mlxsw: spectrum: Remove mlxsw_sp_sample_receive()
    https://git.kernel.org/netdev/net-next/c/48990bef1e68
  - [net-next,10/11] mlxsw: spectrum: Report extra metadata to psample module
    https://git.kernel.org/netdev/net-next/c/2073c6004443
  - [net-next,11/11] selftests: mlxsw: Add tc sample tests
    https://git.kernel.org/netdev/net-next/c/bb24d592e66e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


