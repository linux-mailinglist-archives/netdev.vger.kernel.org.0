Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFC6245D37E
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 04:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345659AbhKYDPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 22:15:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:36316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344104AbhKYDNU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 22:13:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 67A1661108;
        Thu, 25 Nov 2021 03:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637809810;
        bh=8SAhr0b5QZ6E90k/WXqKwJ26QMsGlO/FL+bnn/Z8YNU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VuVyIB+IcOvBSEWd1mv/IsKDWE33Ze5C2poKwqGDRMpb5J9glicpssRiNSO8TiteQ
         xSHpw7LsFaUo14ZMNOfZs9Pt1GkACX5n8QH8ldvot0gvugd7hKViwnOJPVt8wMu76r
         lw6rDaCTp7YV7v7+CTxoB0wibSD+MIH01YZOfabvdYb73ojTSbwkNYuyZXIahnj4FK
         rkFWjlF/cVTDu7UHy875QE+CIDOVkWSE55ZoKo/RHfGyyVtOW2YqeC/N+nl6ctreHe
         wRZNg++BGNnds53Zv5rkks72rAzL7wBGNnfM35Omq+lBB/1Qs2WMzAZrmVP/aQY5yM
         WK0ScDG/ZL3ng==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5C89360A4E;
        Thu, 25 Nov 2021 03:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net-ipv6: changes to ->tclass (via IPV6_TCLASS) should
 sk_dst_reset()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163780981037.14115.5473017497899169157.git-patchwork-notify@kernel.org>
Date:   Thu, 25 Nov 2021 03:10:10 +0000
References: <20211123223208.1117871-1-zenczykowski@gmail.com>
In-Reply-To: <20211123223208.1117871-1-zenczykowski@gmail.com>
To:     =?utf-8?q?Maciej_=C5=BBenczykowski_=3Czenczykowski=40gmail=2Ecom=3E?=@ci.codeaurora.org
Cc:     maze@google.com, netdev@vger.kernel.org, edumazet@google.com,
        ncardwell@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 23 Nov 2021 14:32:08 -0800 you wrote:
> From: Maciej Żenczykowski <maze@google.com>
> 
> This is to match ipv4 behaviour, see __ip_sock_set_tos()
> implementation.
> 
> Technically for ipv6 this might not be required because normally we
> do not allow tclass to influence routing, yet the cli tooling does
> support it:
> 
> [...]

Here is the summary with links:
  - net-ipv6: changes to ->tclass (via IPV6_TCLASS) should sk_dst_reset()
    https://git.kernel.org/netdev/net-next/c/305e95bb893c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


