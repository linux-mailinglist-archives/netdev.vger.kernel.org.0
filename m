Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A281442A226
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 12:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235998AbhJLKcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 06:32:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:43630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235987AbhJLKcJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 06:32:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DF68961151;
        Tue, 12 Oct 2021 10:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634034607;
        bh=w/bvvX0HxeIoExpnW96fsxsQLNvYMeAzwvWjQ/toMAk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Qh//fHgmjuFKkagitoHGrEDm7qIq5xTxP9yfUZmla2tXhW1jdsQHYqvqTljEPV9sy
         z0q0WCYTW33KoO8jaSCM+UmMvRpZM/1TFM7/aC3DLJJxfvLoDBzNxiXcc+rhJWnZy6
         +T19D4AU5vi+c4yuY/0o46SRp0xmyagwrBhFNHBfvAQQRcR4AXPCNcqDriuoLpOkp9
         wWdGcMnQtpIpP70GoX5DUzehJ0eREB40IX7AyOsZymAU3npDxheK+eZNl0JgvAXz+y
         KXHka3XC28I1JjSuy7hZ8FKdNUMyr3sOcgrbzqffOJ8TqGJWaomcewLk/1kmwKvYvF
         8F7brlhVYgL1A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D9670609CC;
        Tue, 12 Oct 2021 10:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] mlxsw: Add support for ECN mirroring
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163403460788.20758.9882084918177945455.git-patchwork-notify@kernel.org>
Date:   Tue, 12 Oct 2021 10:30:07 +0000
References: <20211010114018.190266-1-idosch@idosch.org>
In-Reply-To: <20211010114018.190266-1-idosch@idosch.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com, petrm@nvidia.com, mlxsw@nvidia.com,
        idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 10 Oct 2021 14:40:12 +0300 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Petr says:
> 
> Patches in this set have been floating around for some time now together
> with trap_fwd support. That will however need more work, time for which is
> nowhere to be found, apparently. Instead, this patchset enables offload of
> only packet mirroring on RED mark qevent, enabling mirroring of ECN-marked
> packets.
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] mlxsw: spectrum_qdisc: Pass extack to mlxsw_sp_qevent_entry_configure()
    https://git.kernel.org/netdev/net-next/c/a34dda728430
  - [net-next,2/6] mlxsw: spectrum_qdisc: Distinguish between ingress and egress triggers
    https://git.kernel.org/netdev/net-next/c/0908e42ad9a5
  - [net-next,3/6] mlxsw: spectrum_qdisc: Track permissible actions per binding
    https://git.kernel.org/netdev/net-next/c/099bf89d6a35
  - [net-next,4/6] mlxsw: spectrum_qdisc: Offload RED qevent mark
    https://git.kernel.org/netdev/net-next/c/9c18eaf2882d
  - [net-next,5/6] selftests: mlxsw: sch_red_core: Drop two unused variables
    https://git.kernel.org/netdev/net-next/c/a703b5179b5c
  - [net-next,6/6] selftests: mlxsw: RED: Add selftests for the mark qevent
    https://git.kernel.org/netdev/net-next/c/0cd6fa99a076

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


