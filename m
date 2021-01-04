Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9F52E9F8A
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 22:31:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727155AbhADVau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 16:30:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:40478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726672AbhADVat (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Jan 2021 16:30:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id B71D2224F9;
        Mon,  4 Jan 2021 21:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609795808;
        bh=+VIp1fbOslRnEXjmav/oSNMgrzek7YuC7KXDOGeIgvY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=k+JzBVwdepZQVgi2qtp4pO4mRtkbC85HHzefaSm3bVgVdzoucfBrFhavNCFbsNU4e
         lGhkeEHQVG3r3W5VZm1c2wAUjQQ74VpVQaXkNeHE/Gan60/GykIldLRemE4geTmcF8
         DJLl7sTv8OlEuzc8SY1+sW6QU85J4TzeCuwWdotj7S+MnvK1YiQbjiOV/bWpbxByNc
         Wo7C3QPnS90DiIFzZ2ETgN3A6siZPH8YW/sYxMcZp9bswCV6X7XLv/75xhMYkXFvwQ
         bMUD9VtVDI94q3jZy2KDkfB90MsDVhfTgse5pc/g0j+A440DKCnDMe34+G04meBQJt
         jJycRxRyU18xg==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id A96A460591;
        Mon,  4 Jan 2021 21:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ibmvnic: fix: NULL pointer dereference.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160979580868.407.15154718207027980381.git-patchwork-notify@kernel.org>
Date:   Mon, 04 Jan 2021 21:30:08 +0000
References: <1609312994-121032-1-git-send-email-abaci-bugfix@linux.alibaba.com>
In-Reply-To: <1609312994-121032-1-git-send-email-abaci-bugfix@linux.alibaba.com>
To:     YANG LI <abaci-bugfix@linux.alibaba.com>
Cc:     davem@davemloft.net, kuba@kernel.org, drt@linux.ibm.com,
        ljp@linux.ibm.com, sukadev@linux.ibm.com, mpe@ellerman.id.au,
        benh@kernel.crashing.org, paulus@samba.org, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 30 Dec 2020 15:23:14 +0800 you wrote:
> The error is due to dereference a null pointer in function
> reset_one_sub_crq_queue():
> 
> if (!scrq) {
>     netdev_dbg(adapter->netdev,
>                "Invalid scrq reset. irq (%d) or msgs(%p).\n",
> 		scrq->irq, scrq->msgs);
> 		return -EINVAL;
> }
> 
> [...]

Here is the summary with links:
  - ibmvnic: fix: NULL pointer dereference.
    https://git.kernel.org/netdev/net/c/862aecbd9569

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


