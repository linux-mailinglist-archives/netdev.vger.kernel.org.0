Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA85730C730
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 18:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236997AbhBBRMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 12:12:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:35580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236891AbhBBQvA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 11:51:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 8C0A964F95;
        Tue,  2 Feb 2021 16:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612284607;
        bh=YazcG+BE+q7PioHb/BdTLj8HKtycWtsJz+EN2jWSj8Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lrcNopUwcij1KTBBtaOTQRKS60NKrNuGrxvsNqwxqPgPIyEJpxbwhIUOwaXgQIZkH
         gmHlNw+GXHLp7gE/V+IvUydtgngbMceoY/jPgq0xPR7PGH28e2B6b43/WLTu9i5C//
         S2z9VT8i8Gpk/Ba4YxfN7vLO36gC+DhvRM1hvL3NuenrGgJQmP5ZGwtmif2s0EV6JG
         DhW6jrXBv61XkAvySiP/2nHBlMUDDWZfSFpff1PW83coYiLnjlRfMNch4E5WGzjWcp
         78NbvZHvv2HqpcGIKl/0qnIy6tF2ynE40mETWn8wJxWprppFCe9B2Mbv5t6hvIj+MJ
         5vo2Vj1CzOZAA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 83D1960987;
        Tue,  2 Feb 2021 16:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/rds: restrict iovecs length for RDS_CMSG_RDMA_ARGS
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161228460753.23213.15174614823787574149.git-patchwork-notify@kernel.org>
Date:   Tue, 02 Feb 2021 16:50:07 +0000
References: <20210201203233.1324704-1-snovitoll@gmail.com>
In-Reply-To: <20210201203233.1324704-1-snovitoll@gmail.com>
To:     Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Cc:     santosh.shilimkar@oracle.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
        syzbot+1bd2b07f93745fa38425@syzkaller.appspotmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue,  2 Feb 2021 02:32:33 +0600 you wrote:
> syzbot found WARNING in rds_rdma_extra_size [1] when RDS_CMSG_RDMA_ARGS
> control message is passed with user-controlled
> 0x40001 bytes of args->nr_local, causing order >= MAX_ORDER condition.
> 
> The exact value 0x40001 can be checked with UIO_MAXIOV which is 0x400.
> So for kcalloc() 0x400 iovecs with sizeof(struct rds_iovec) = 0x10
> is the closest limit, with 0x10 leftover.
> 
> [...]

Here is the summary with links:
  - net/rds: restrict iovecs length for RDS_CMSG_RDMA_ARGS
    https://git.kernel.org/netdev/net/c/a11148e6fcce

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


