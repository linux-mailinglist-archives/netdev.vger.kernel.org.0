Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CEB4287CB2
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 22:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729476AbgJHUAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 16:00:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:36940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725852AbgJHUAF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 16:00:05 -0400
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602187204;
        bh=t5szDrvEfB9a/I46WyskO+BH1LUWvHCEvQBrvAyiHs4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=k0hXYxsnM4NEQB3Qf1sA7IdKbTv5suY30u5xDBCZ7dwa2kmQXtcrwIePdlYfbekDm
         DD97mvLsK7odWq4LRPxmfJ+e4iqfMmHpOFF78mgtm7g5F9+TGQgms5QIXI23oqtXPq
         biWtOZ02tyACVs3NwNWgw2a22oYwCInP99hWaQBw=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] macsec: avoid use-after-free in macsec_handle_frame()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160218720487.8125.18325419905258779471.git-patchwork-notify@kernel.org>
Date:   Thu, 08 Oct 2020 20:00:04 +0000
References: <20201007084246.4068317-1-eric.dumazet@gmail.com>
In-Reply-To: <20201007084246.4068317-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed,  7 Oct 2020 01:42:46 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> De-referencing skb after call to gro_cells_receive() is not allowed.
> We need to fetch skb->len earlier.
> 
> Fixes: 5491e7c6b1a9 ("macsec: enable GRO and RPS on macsec devices")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Paolo Abeni <pabeni@redhat.com>
> 
> [...]

Here is the summary with links:
  - [net] macsec: avoid use-after-free in macsec_handle_frame()
    https://git.kernel.org/netdev/net/c/c7cc9200e9b4

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


