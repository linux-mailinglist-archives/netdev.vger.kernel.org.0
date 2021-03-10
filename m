Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96599333242
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 01:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbhCJAU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 19:20:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:53470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230489AbhCJAUK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Mar 2021 19:20:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id B2B1065111;
        Wed, 10 Mar 2021 00:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615335609;
        bh=A9xqNkpPU4US1WXfOAO6VZgrS/aoRmo4VDOY0uO/VL8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=anb3FPDDgekaPjN2fPP9lXM3Ev9RXubwB/w+lGkdTQrr/rzn6mw6Y8yGd6srkYqTU
         LWmM4tQOXEsOGGlG8SLwl/CorEKo9W9yWXqhKHAK8OLWWTXjJuVkIBpgGi5t6goeUS
         V+KsWZ7Xg4JWyYMdKlZ2TBjertk8wFxXadL/ujWuoTiMNdxksj0jnDFBPya7ZB9PeR
         l3AcEv4uzsmd5Q7Pm0IgA/kVnmGAjfwAVr4mPnOomSa+WTvMxwfjghlloh+turPKDH
         UiYQmyXudRYkXepy9jR5Xt6bWnTv5+B1SvyfNsW80vYtQy1Ni8GFcBBBfKmb7VFDU8
         xkF56jpmx/qCg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A8C09609EC;
        Wed, 10 Mar 2021 00:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: xrs700x: check if partner is same as port in
 hsr join
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161533560968.32666.6725371503487188210.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Mar 2021 00:20:09 +0000
References: <20210308233822.59729-1-george.mccollister@gmail.com>
In-Reply-To: <20210308233822.59729-1-george.mccollister@gmail.com>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon,  8 Mar 2021 17:38:22 -0600 you wrote:
> Don't assign dp to partner if it's the same port that xrs700x_hsr_join
> was called with. The partner port is supposed to be the other port in
> the HSR/PRP redundant pair not the same port. This fixes an issue
> observed in testing where forwarding between redundant HSR ports on this
> switch didn't work depending on the order the ports were added to the
> hsr device.
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: xrs700x: check if partner is same as port in hsr join
    https://git.kernel.org/netdev/net/c/286a8624d7f9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


