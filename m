Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FEBC3C77AD
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 22:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234394AbhGMUMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 16:12:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:55696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229944AbhGMUMy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Jul 2021 16:12:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DE4EB6128B;
        Tue, 13 Jul 2021 20:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626207003;
        bh=AUD5ErtiWcsLOk1dfjQy1XDX+RbqV19ITaGVu1kQCfY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cE6ozz+jZdvpXho4I6RNCJmA3tpZ1u3hAMpDAqrWqukUxHKTSeewXboaxVnVCB1GL
         xbUvJOEW38PPFxI2cbaRKJqm4rbBUIrePBZhxSr/fgU1H9O1s/ZPerR8vMTgTHcW0u
         zOTr4HNyNZxHj+n+LAm+xOTlLU2NYqCUpSIi/TwMr1NUyaZgAwcSEvaYpaA3Fs4dfE
         wVXnQZmKRSqfrAKfLhULZb5Ur8/bcd8oG7/SfRzLuw7xnhbsv3p4tNOaq6FZ2WvYjy
         QL5y9zYpisdEheSHE9njjIIIbrO+5w712e+vR4u3YVrS1YNnRRMJ1k3qiUQtE6IBAP
         5r/JypyYl+T0w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D003C60A4D;
        Tue, 13 Jul 2021 20:10:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 0/3] Fix lack of XDP TX queues
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162620700384.14017.11834813316426489046.git-patchwork-notify@kernel.org>
Date:   Tue, 13 Jul 2021 20:10:03 +0000
References: <20210713142129.17077-1-ihuguet@redhat.com>
In-Reply-To: <20210713142129.17077-1-ihuguet@redhat.com>
To:     =?utf-8?b?w43DsWlnbyBIdWd1ZXQgPGlodWd1ZXRAcmVkaGF0LmNvbT4=?=@ci.codeaurora.org
Cc:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, kuba@kernel.org, ivan@cloudflare.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Tue, 13 Jul 2021 16:21:26 +0200 you wrote:
> A change introduced in commit e26ca4b53582 ("sfc: reduce the number of
> requested xdp ev queues") created a bug in XDP_TX and XDP_REDIRECT
> because it unintentionally reduced the number of XDP TX queues, letting
> not enough queues to have one per CPU, which leaded to errors if XDP
> TX/REDIRECT was done from a high numbered CPU.
> 
> This patchs make the following changes:
> - Fix the bug mentioned above
> - Revert commit 99ba0ea616aa ("sfc: adjust efx->xdp_tx_queue_count with
>   the real number of initialized queues") which intended to fix a related
>   problem, created by mentioned bug, but it's no longer necessary
> - Add a new error log message if there are not enough resources to make
>   XDP_TX/REDIRECT work
> 
> [...]

Here is the summary with links:
  - [v3,1/3] sfc: fix lack of XDP TX queues - error XDP TX failed (-22)
    https://git.kernel.org/netdev/net/c/f28100cb9c96
  - [v3,2/3] sfc: ensure correct number of XDP queues
    https://git.kernel.org/netdev/net/c/788bc000d4c2
  - [v3,3/3] sfc: add logs explaining XDP_TX/REDIRECT is not available
    https://git.kernel.org/netdev/net/c/d2a16bde7732

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


