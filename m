Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0EAD3A2068
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 00:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbhFIWwB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 18:52:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:45714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229578AbhFIWwA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 18:52:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3C6B2613E3;
        Wed,  9 Jun 2021 22:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623279005;
        bh=A6obYrfRdTksecFghr03/zfd9jd1bsPEXJxEGC8fuMY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hMUsYpP9WH3VFPl+EH7Es8X65VmLd3GdoWxU0W9dmBfzWDEvg4gw+PHE3TwXuJGOg
         bZmO/HsHs1GTT+plPpPFRM4tBPp0NNC/R0CLvogfSyJp0RQT6WrMrz95UlNxMz0pi2
         PpPzxyOpXHm0k4wC1tePWef5SPgaRj9mi9Y+iPTw6S6pKeXHSm9DIOwghbBi5OMLlE
         jfVBKRf8g/lcawtFUTtI3qn58NgnK/uwlkTJPrjBEVTt6NoqN7XokwuNBELa0sePAD
         KdGza1GJVj/eOOla+pNfh5ZXT/0wc9VvMghhqkqIWrYXDNwgUF8aRDvZEL6AgQkGWN
         ON5lHSpaM94gg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2AB8D60A16;
        Wed,  9 Jun 2021 22:50:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] stmmac: prefetch right address
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162327900517.30855.3396630004456176161.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Jun 2021 22:50:05 +0000
References: <20210609172303.49529-1-mcroce@linux.microsoft.com>
In-Reply-To: <20210609172303.49529-1-mcroce@linux.microsoft.com>
To:     Matteo Croce <mcroce@linux.microsoft.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        boon.leong.ong@intel.com, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        davem@davemloft.net, kuba@kernel.org, kernel@esmil.dk
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed,  9 Jun 2021 19:23:03 +0200 you wrote:
> From: Matteo Croce <mcroce@microsoft.com>
> 
> To support XDP, a headroom is prepended to the packet data.
> Consider this offset when doing a prefetch.
> 
> Fixes: da5ec7f22a0f ("net: stmmac: refactor stmmac_init_rx_buffers for stmmac_reinit_rx_buffers")
> Signed-off-by: Matteo Croce <mcroce@microsoft.com>
> 
> [...]

Here is the summary with links:
  - [net-next] stmmac: prefetch right address
    https://git.kernel.org/netdev/net-next/c/4744bf072b46

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


