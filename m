Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16549426CC5
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 16:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242103AbhJHOcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 10:32:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:43456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241048AbhJHOcD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 10:32:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3B127610E7;
        Fri,  8 Oct 2021 14:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633703408;
        bh=u0puWoRGbqbsgB/vHxAPHH1AenqCKuxqxlNE+MY+Xvw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mfkav6NtLp8H3Ig/JbxYD6TkkxNzQ0ENi7alIwK9KvAO62zPk6dYc/dQrhiuSl2jw
         dWTbDheGwrNhVs9A8jTrqk6HCpW4ZE1JhfmrtL4HqMWnIEjF3HptVA5BjIv4UOvxS3
         mmiwSC5N0jDvVFUdKyCx/iiZwbB3e/Ag0VQgOnv2fB0K/MPMHIecdE5lenry+yMbFu
         HqYiEIOqfiajQ/4P2T8Wa8IZaF+sGTnPZ2B9as158+3GHbaykAyLJFCT1Pu4P8tkKd
         aIwn70Oi1MjRY3RYqMbC8lfHaF/5w0WKujOjtukji5XXKhAXvCYQP5PXQ9nQStJ1yR
         OX1JB85KUQSuQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 35E1D6094F;
        Fri,  8 Oct 2021 14:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net-sysfs: try not to restart the syscall if it will
 fail eventually
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163370340821.9336.11969277633454623458.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Oct 2021 14:30:08 +0000
References: <20211007140051.297963-1-atenart@kernel.org>
In-Reply-To: <20211007140051.297963-1-atenart@kernel.org>
To:     Antoine Tenart <atenart@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        juri.lelli@redhat.com, mhocko@suse.com, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu,  7 Oct 2021 16:00:51 +0200 you wrote:
> Due to deadlocks in the networking subsystem spotted 12 years ago[1],
> a workaround was put in place[2] to avoid taking the rtnl lock when it
> was not available and restarting the syscall (back to VFS, letting
> userspace spin). The following construction is found a lot in the net
> sysfs and sysctl code:
> 
>   if (!rtnl_trylock())
>           return restart_syscall();
> 
> [...]

Here is the summary with links:
  - [net-next] net-sysfs: try not to restart the syscall if it will fail eventually
    https://git.kernel.org/netdev/net-next/c/146e5e733310

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


