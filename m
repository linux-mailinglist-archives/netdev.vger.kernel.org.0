Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD7F325519
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 19:04:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233313AbhBYSDn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 13:03:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:51692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233852AbhBYSAr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 13:00:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 07D3064F6D;
        Thu, 25 Feb 2021 18:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614276007;
        bh=39i6v/8yuHdeFZHNDL+h/FNI/ruvtNONzkURfQi4Qd4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kcDPvQcCz5xLaz4Loa/kryghPq7WeTrZe1mBuGIyWowE80dZfzuCvJ7AGOrEb0xxb
         fO6qGir1kWgndtg2BzHAPTImp6YzhnMfPnAo/ZGO4Z25KlOuvaORdlGAzE0IuhVCNp
         wek8HLfqeiM7tegSy3TZQxtdVyAHfGI4UGMUHcRuSw6Cq1HJ71PisU9KI6bBGr2pgm
         2BNsA03hBmbkW7YNb3bNgMhu1c5A5QqZ9svofeG5KYDsWXxWJwSGBU1746Kv28cxlU
         pRjfm+EUli/59dIkhsCrHRGJOWcnzNCC9EwXGtMArelFXPp3xYwQUYUPDaS+0SR2dd
         AYwwahluaBUXw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EC0A760A13;
        Thu, 25 Feb 2021 18:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: psample: Fix netlink skb length with tunnel info
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161427600696.9193.14924016455696170106.git-patchwork-notify@kernel.org>
Date:   Thu, 25 Feb 2021 18:00:06 +0000
References: <20210225075145.184314-1-cmi@nvidia.com>
In-Reply-To: <20210225075145.184314-1-cmi@nvidia.com>
To:     Chris Mi <cmi@nvidia.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, idosch@nvidia.com,
        jiri@nvidia.com, yotam.gi@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 25 Feb 2021 15:51:45 +0800 you wrote:
> Currently, the psample netlink skb is allocated with a size that does
> not account for the nested 'PSAMPLE_ATTR_TUNNEL' attribute and the
> padding required for the 64-bit attribute 'PSAMPLE_TUNNEL_KEY_ATTR_ID'.
> This can result in failure to add attributes to the netlink skb due
> to insufficient tail room. The following error message is printed to
> the kernel log: "Could not create psample log message".
> 
> [...]

Here is the summary with links:
  - [net] net: psample: Fix netlink skb length with tunnel info
    https://git.kernel.org/netdev/net/c/a93dcaada2dd

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


