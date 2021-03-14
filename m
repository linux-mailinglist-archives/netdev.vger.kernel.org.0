Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 823D533A89C
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 23:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbhCNWke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 18:40:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:51380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229473AbhCNWkJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Mar 2021 18:40:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E6C8A64E7C;
        Sun, 14 Mar 2021 22:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615761608;
        bh=SxHilUiu5XzZsadZE58q3R5cLpwAdcFEXM7SkX3tQKM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=K89acURmXUL+JP3S7tdl5XM/WpzmXQvZr0IS6GpiBAj99THhWpSNlaA4PV5FOZDOt
         vOuKdoM82iBE8+LfRJIE81/3PW1btBcRoZpWrz1WNbKol8kbNfGaxBNgnh58Zbu0pl
         25Awc34bktB6WwL50WOuErjuqraA2pt1JtXo9pGUShjkxh7kO0cJfhW86ETGzzNX6O
         ZPH+J4sQE1dFGVFiqx3tt1tm6JVk81+MH8hporPexcgDgKaBaMF9mxnmtuvV2obctV
         GEv6nATOTuREHFQBovy1BJwpRN+WdUPzyaLlG1leuQi50PgxhtMH36MAA3PcMJNX7j
         lZa2yNJzDBvZw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D5DC8609C5;
        Sun, 14 Mar 2021 22:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: qrtr: fix a kernel-infoleak in qrtr_recvmsg()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161576160887.5046.4834330452596879053.git-patchwork-notify@kernel.org>
Date:   Sun, 14 Mar 2021 22:40:08 +0000
References: <20210312165948.909295-1-eric.dumazet@gmail.com>
In-Reply-To: <20210312165948.909295-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, courtney.cavin@sonymobile.com,
        syzkaller@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 12 Mar 2021 08:59:48 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> struct sockaddr_qrtr has a 2-byte hole, and qrtr_recvmsg() currently
> does not clear it before copying kernel data to user space.
> 
> It might be too late to name the hole since sockaddr_qrtr structure is uapi.
> 
> [...]

Here is the summary with links:
  - [net] net: qrtr: fix a kernel-infoleak in qrtr_recvmsg()
    https://git.kernel.org/netdev/net/c/50535249f624

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


