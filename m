Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23C382EB48D
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 22:02:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727225AbhAEVCD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 16:02:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:55388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726074AbhAEVCC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 16:02:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 47D1422D5B;
        Tue,  5 Jan 2021 21:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609880482;
        bh=aZZOPQn1miFYRx9rxex+tvEUKJksVciMwk3qORIF+OE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BgjNrwHXh6bXqjmxM2gNqg/3hoNo8+UmfT/hmdqjWVzEC8FbbzU3vz/xnLrGi9E24
         3mmsGC//4r9Mmlv8nIxJUzoYoZteZjsDDqWqMxV9Gu3FaNuSSWdPCblKh5a2zo+R5Y
         GbmzA4lfz60W0vE+YxT/3WvEEcT9NQmruESk+2dX58TWKUFFll35jWsfkvgIahlfrH
         vPfIjXqQviat5YgUNBjYUWcLDocBtrqZnDz0oaV5w5xYjqMAm+67RomyRs+CjA31gQ
         6oAzGPrv0DZtYcpnJrxARB0fJ0pFIfOkMeqJIXPa5CxkrPB4NlXteJwi4VrDUPrN0N
         1U4vowMFe+sSg==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 39354604FC;
        Tue,  5 Jan 2021 21:01:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PULL] Networking for 5.11-rc3
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160988048223.32112.8616016144291095240.git-patchwork-notify@kernel.org>
Date:   Tue, 05 Jan 2021 21:01:22 +0000
References: <20210105003232.3172133-1-kuba@kernel.org>
In-Reply-To: <20210105003232.3172133-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (refs/heads/master):

On Mon,  4 Jan 2021 16:32:32 -0800 you wrote:
> The following changes since commit d64c6f96ba86bd8b97ed8d6762a8c8cc1770d214:
> 
>   Merge tag 'net-5.11-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2020-12-17 13:45:24 -0800)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.11-rc3
> 
> [...]

Here is the summary with links:
  - [GIT,PULL] Networking for 5.11-rc3
    https://git.kernel.org/netdev/net/c/aa35e45cd42a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


