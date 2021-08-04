Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFB083DFDAC
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 11:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236969AbhHDJKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 05:10:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:53386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235419AbhHDJKR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 05:10:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 69D8E60FC4;
        Wed,  4 Aug 2021 09:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628068205;
        bh=1SiYUeDN/sbvgMomkZqMTzQSjFhtpqp6enqqHF34eLg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VDmvWFB7VpkMf/BkfojW9nRU6evIkxa8/bvo07muCBihA1vXo/KDQ5AYfEsygTI4k
         KNrZ1ahPAQDTnjRvtB9PBoxkpJlLRWr5FE+z1TIfD3UdoMBaN0hnoa+OFz8a2tQUkF
         gF3yUyQ6KDnl9HmNcmcxn7FH/IyzRrGgkchVrL3HIcAWBNZuJtsbhjf+unU3GBY3tO
         zWp/iLl+GM2sYN81kUhde4AsfuWUB+W7jTHz3uTuzzgTzfdUED5BR38EOPZuKYM78Z
         /iDY833VFel4OZIdWluQxTu1FgRWSaVsX7CP8FQLEZzDukmCegmeqL2hWsJEzi0o0B
         MDF7mxJ+8uZJQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5BE30609E2;
        Wed,  4 Aug 2021 09:10:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/prestera: Fix devlink groups leakage in error flow
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162806820537.32022.1126128946400070575.git-patchwork-notify@kernel.org>
Date:   Wed, 04 Aug 2021 09:10:05 +0000
References: <6223773b71e374192af341361055c0124df7083c.1627991916.git.leonro@nvidia.com>
In-Reply-To: <6223773b71e374192af341361055c0124df7083c.1627991916.git.leonro@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, leonro@nvidia.com,
        netdev@vger.kernel.org, oleksandr.mazur@plvision.eu,
        tchornyi@marvell.com, vkochan@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue,  3 Aug 2021 15:00:43 +0300 you wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Devlink trap group is registered but not released in error flow,
> add the missing devlink_trap_groups_unregister() call.
> 
> Fixes: 0a9003f45e91 ("net: marvell: prestera: devlink: add traps/groups implementation")
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net] net/prestera: Fix devlink groups leakage in error flow
    https://git.kernel.org/netdev/net/c/13a9c4ac319a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


