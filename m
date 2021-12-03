Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18CE146794F
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 15:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381429AbhLCOXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 09:23:35 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51146 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381425AbhLCOXf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 09:23:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DEF1E62B7D
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 14:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 49D10C53FD4;
        Fri,  3 Dec 2021 14:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638541210;
        bh=wXbCJ3DzSIlbUW6omO6hyGnvjKRtw5pXHMdbUEqiHps=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kZu1yyiGesNlktRJrcSN/Ba2Vpg2+jW2MwiRHYAGSDyueAE/9sRVMKqsgQfmCkkX6
         YO+E0O0UpRVEcTPC0eeDMWQmLkjIoMQYTusJdXW/fAtuIaa3KCtdieB0sbIGnfHDX3
         WWTbdojTsmS9pIM/CkrofVCrl+QvF6UER/PSu0E2kxSMdq4l7PSCq+PJ1OtVTmz2I7
         9iPLhzOlJt13zy6wl8qGrCDtL8ULfUpprZNsAmYsgiEcTZF9iVIrSmxXT9nz9Crhze
         DpH41jEOovTF4bb+P7XdbmbACIFgzwY/13kdjjVu2Ut/OphVL+I/a8SlN8z/Kg/1aZ
         k9ogP9+uN8l9w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 331C660C74;
        Fri,  3 Dec 2021 14:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tcp: fix another uninit-value (sk_rx_queue_mapping)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163854121020.27426.15621040177733150216.git-patchwork-notify@kernel.org>
Date:   Fri, 03 Dec 2021 14:20:10 +0000
References: <20211202233724.325226-1-eric.dumazet@gmail.com>
In-Reply-To: <20211202233724.325226-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, syzkaller@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu,  2 Dec 2021 15:37:24 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> KMSAN is still not happy [1].
> 
> I missed that passive connections do not inherit their
> sk_rx_queue_mapping values from the request socket,
> but instead tcp_child_process() is calling
> sk_mark_napi_id(child, skb)
> 
> [...]

Here is the summary with links:
  - [net] tcp: fix another uninit-value (sk_rx_queue_mapping)
    https://git.kernel.org/netdev/net/c/03cfda4fa6ea

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


