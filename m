Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E061632248A
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 04:12:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbhBWDKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 22:10:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:48894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230401AbhBWDKs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Feb 2021 22:10:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 4DA7264DEC;
        Tue, 23 Feb 2021 03:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614049808;
        bh=GFDduUrTsx2ACIryUkHXjcHfMdUF1sIEE4mEtuc2PDg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JLc6argJjPKHcZtC/POEOwgWozk3mq5UZZsk7QyvdxTQNvdGBcISLaMRvk71+gt2M
         BLIAQbkWZIfBDYsD/y1lHcmNuGar8oFRQvTXk7qEDhj4ke3oKE9rxkl5u3wqgreIOk
         ucogCMHmoX15rY6os9kN4GydCma43KbxjV0xa7BuXZ7TWN7wYl8/YiLefDJkH9VsHk
         8zoxp3M2sJjJ+PIQJk1qUN1h885Q+oVPB9UgmM4Ert/u6vMUN5iQ1bs92q8P11Vt97
         nk91SojAki4Sk3GoHS3sz1OuXFij+xWErCYenMUVS3TEaX4qX9msbOC2hUy6clRcVP
         aFITffXUBWP5g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3B102609F4;
        Tue, 23 Feb 2021 03:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/4] mptcp: a bunch of fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161404980823.7081.9095170388881116560.git-patchwork-notify@kernel.org>
Date:   Tue, 23 Feb 2021 03:10:08 +0000
References: <cover.1613755058.git.pabeni@redhat.com>
In-Reply-To: <cover.1613755058.git.pabeni@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mptcp@lists.01.org, fw@strlen.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Fri, 19 Feb 2021 18:35:36 +0100 you wrote:
> This series bundle a few MPTCP fixes for the current net tree.
> They have been detected via syzkaller and packetdrill
> 
> Patch 1 fixes a slow close for orphaned sockets
> 
> Patch 2 fixes another hangup at close time, when no
> data was actually transmitted before close
> 
> [...]

Here is the summary with links:
  - [net,1/4] mptcp: fix DATA_FIN processing for orphaned sockets
    https://git.kernel.org/netdev/net/c/341c65242fe1
  - [net,2/4] mptcp: fix DATA_FIN generation on early shutdown
    https://git.kernel.org/netdev/net/c/d87903b63e3c
  - [net,3/4] mptcp: provide subflow aware release function
    https://git.kernel.org/netdev/net/c/ad98dd37051e
  - [net,4/4] mptcp: do not wakeup listener for MPJ subflows
    https://git.kernel.org/netdev/net/c/52557dbc7538

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


