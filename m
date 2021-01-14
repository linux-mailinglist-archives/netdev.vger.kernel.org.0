Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E42062F5907
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 04:32:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727903AbhANDLz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 22:11:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:53062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727805AbhANDLe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 22:11:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 650D523619;
        Thu, 14 Jan 2021 03:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610593809;
        bh=UrMb4pOgyUxRbspZeCZOuzk6ZhbroCYRglSDMIUBTVY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Mn5AFNMR/mfz4+VRnoPPBKsJ6S0M+Hj1sx4JqkUgw7NRC/imRz2gQe7eRHcL6RvQf
         3JvJxayjLzsfKF9eXrehg71kmRWkkP1kjIWiIF3hCsaRduf9l5a5f8OhZRXWoJWeyt
         eDQwYYtUnQsUxlnF9MZxtMgfajoRV4JBhyknYk0QuVQrc5GhAyztseV8zCb8OmQVG2
         pmZq9JotkfjBXM3xd1Py3/vDdM0TJ4/Ag1XvqGNH/G7E/ZN8SUrU3GmrlZi7M2TM4s
         P0Nozbu88UKkM3wmXRqgMcMKPuPFb+c9hzEQWhmZKRKfWHEvJIKVP09gCyEJBTTV2J
         Du8OSJrngl1Uw==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 6023960593;
        Thu, 14 Jan 2021 03:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net 1/2] can: isotp: isotp_getname(): fix kernel information leak
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161059380938.28478.8205076574768739115.git-patchwork-notify@kernel.org>
Date:   Thu, 14 Jan 2021 03:10:09 +0000
References: <20210113212158.925513-2-mkl@pengutronix.de>
In-Reply-To: <20210113212158.925513-2-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        socketcan@hartkopp.net, xiyou.wangcong@gmail.com,
        syzbot+057884e2f453e8afebc8@syzkaller.appspotmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Wed, 13 Jan 2021 22:21:57 +0100 you wrote:
> From: Oliver Hartkopp <socketcan@hartkopp.net>
> 
> Initialize the sockaddr_can structure to prevent a data leak to user space.
> 
> Suggested-by: Cong Wang <xiyou.wangcong@gmail.com>
> Reported-by: syzbot+057884e2f453e8afebc8@syzkaller.appspotmail.com
> Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
> Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
> Link: https://lore.kernel.org/r/20210112091643.11789-1-socketcan@hartkopp.net
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> 
> [...]

Here is the summary with links:
  - [net,1/2] can: isotp: isotp_getname(): fix kernel information leak
    https://git.kernel.org/netdev/net/c/b42b3a2744b3
  - [net,2/2] can: mcp251xfd: mcp251xfd_handle_rxif_one(): fix wrong NULL pointer check
    https://git.kernel.org/netdev/net/c/ca4c6ebeeb50

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


