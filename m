Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 334793195B8
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 23:22:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbhBKWUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 17:20:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:42032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229694AbhBKWUr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 17:20:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 640C164E4D;
        Thu, 11 Feb 2021 22:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613082007;
        bh=O6OEPB3Ctmz3ML4AXIr2Whut4piLv+5zwl5/Ht1hKFE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=piqqZ0rWZ6YBWaGBT5dheCwGy21CzNIpq3UzWEd+OPbTvWcTAGofy0vede1btKG37
         4UUx6B0QrH1M2eZZlatEmimb3EOiy0Kuaf4DEg+bAQWZcpqeD7qp39BgtCs8yveSkg
         zRL43RGmuZQLrKkLjShc+ch+ZX1JuS6pFJPQmTgXmgYhzSjrxBfcXM9LKkarwiiSDr
         3BYtMQPqrfcsSo6XewgRXbmoeNpcKK11iiVNnZozNIvI7piHGXVqrAgaReXi4yMPhC
         wMTciJZc7XkBrc49dT+e7ul5qMMC2CJ77yZx3rBsjwXdBuTgBcwB1VPSdbgrXOR5bQ
         uV/40z2Irt89g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 554F1609D6;
        Thu, 11 Feb 2021 22:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: initialize net->net_cookie at netns setup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161308200734.4488.12326551834384973132.git-patchwork-notify@kernel.org>
Date:   Thu, 11 Feb 2021 22:20:07 +0000
References: <20210210144144.24284-1-eric.dumazet@gmail.com>
In-Reply-To: <20210210144144.24284-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, daniel@iogearbox.net, lmb@cloudflare.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 10 Feb 2021 06:41:44 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> It is simpler to make net->net_cookie a plain u64
> written once in setup_net() instead of looping
> and using atomic64 helpers.
> 
> Lorenz Bauer wants to add SO_NETNS_COOKIE socket option
> and this patch would makes his patch series simpler.
> 
> [...]

Here is the summary with links:
  - [net-next] net: initialize net->net_cookie at netns setup
    https://git.kernel.org/netdev/net-next/c/3d368ab87cf6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


