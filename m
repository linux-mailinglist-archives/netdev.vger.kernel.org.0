Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6274532DE
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 14:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236776AbhKPNdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 08:33:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:51048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236729AbhKPNdL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 08:33:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 2803761B49;
        Tue, 16 Nov 2021 13:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637069414;
        bh=9o8hvU0fK1XFsXz34XreeARe1v8RmQpSo8N9uDuNqE4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZlntJ0MX1R1kww1aulQYKefEUbjvbSw2I5K4mm07o2fbqYPeO/vqu7FODmjhNIbmF
         9Xk8BxJw/rEvSnpxbDzu/OhTVP+pXvOMn5TkklMIbWZjx/ePUA5ZLe2Tzhx3EARogk
         yj8PrJe1H/LVRFZwuAt6AkGzTGztdOFYS471EZXEyGzDLtvWq/33ol8bXelZmUM9Jh
         QCuq24XOQBikNLZkvmwDw8i3ei9BkhJTDu2HnPv1CE3s/ZvDIFRjlAEcOtwvH482OM
         wxV8vRc5/HFWk0bhMwGUU59VFMvoWzuE6hHbS/gaWapSESuGczSYil2WdQvXgr2Wy4
         spM8bZ/Wdiepw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 15DC6609D3;
        Tue, 16 Nov 2021 13:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] gro: get out of core files
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163706941408.24146.13534152124004338198.git-patchwork-notify@kernel.org>
Date:   Tue, 16 Nov 2021 13:30:14 +0000
References: <20211115170554.3645322-1-eric.dumazet@gmail.com>
In-Reply-To: <20211115170554.3645322-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 15 Nov 2021 09:05:50 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Move GRO related content into net/core/gro.c
> and include/net/gro.h.
> 
> This reduces GRO scope to where it is really needed,
> and shrinks too big files (include/linux/netdevice.h
> and net/core/dev.c)
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] net: move gro definitions to include/net/gro.h
    https://git.kernel.org/netdev/net-next/c/4721031c3559
  - [net-next,2/4] net: gro: move skb_gro_receive_list to udp_offload.c
    https://git.kernel.org/netdev/net-next/c/0b935d7f8c07
  - [net-next,3/4] net: gro: move skb_gro_receive into net/core/gro.c
    https://git.kernel.org/netdev/net-next/c/e456a18a390b
  - [net-next,4/4] net: gro: populate net/core/gro.c
    https://git.kernel.org/netdev/net-next/c/587652bbdd06

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


