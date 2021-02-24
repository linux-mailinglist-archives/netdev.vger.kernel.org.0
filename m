Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08EE332456B
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 21:41:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235829AbhBXUlB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 15:41:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:41734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235376AbhBXUkr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 15:40:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id BAA2D64E7A;
        Wed, 24 Feb 2021 20:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614199206;
        bh=CWwZ4znOtnV8IBA3BWozcdhwRARVdP24SOm1Zvenq0s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kVfr/sCoOV7IHWoHwfud0ENkACaMridJWcX0E8iFfrYvBXY8IbbLs8rJ/aikeUfAb
         1zdNhCvKi0xQn0EswdxHOTTVb6msCGSv8LyDZzbhVSdDn7xfaTSb+mDtHM5h+9bJVP
         N7p6Xp6W+Vt5cJc5UUtdhwdhcZKvjobrG7atyEQ4o4YqjhmPhtKujwZwY1kXMjlvlJ
         kxrUaaS7DgeU4JbxrvMoco2m0TACVjO5Q6hj7ChM09i5P7nVH6uJCVHl6foeKzMU0l
         0mNrV/k1U51iLknw3L6S1g6kH+qnid/Y0NBchkVRP7Av0fsz7WWWD4t5Q7PXPypDcq
         78OO1Tcy5HZ3Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A8060609F2;
        Wed, 24 Feb 2021 20:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] selftest/bpf: no need to drop the packet when there is no
 geneve opt
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161419920668.16624.1337615822618537205.git-patchwork-notify@kernel.org>
Date:   Wed, 24 Feb 2021 20:40:06 +0000
References: <20210224081403.1425474-1-liuhangbin@gmail.com>
In-Reply-To: <20210224081403.1425474-1-liuhangbin@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, daniel@iogearbox.net,
        yihung.wei@gmail.com, davem@davemloft.net, bpf@vger.kernel.org,
        jiong.wang@netronome.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (refs/heads/master):

On Wed, 24 Feb 2021 16:14:03 +0800 you wrote:
> In bpf geneve tunnel test we set geneve option on tx side. On rx side we
> only call bpf_skb_get_tunnel_opt(). Since commit 9c2e14b48119 ("ip_tunnels:
> Set tunnel option flag when tunnel metadata is present") geneve_rx() will
> not add TUNNEL_GENEVE_OPT flag if there is no geneve option, which cause
> bpf_skb_get_tunnel_opt() return ENOENT and _geneve_get_tunnel() in
> test_tunnel_kern.c drop the packet.
> 
> [...]

Here is the summary with links:
  - [net] selftest/bpf: no need to drop the packet when there is no geneve opt
    https://git.kernel.org/bpf/bpf/c/557c223b643a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


