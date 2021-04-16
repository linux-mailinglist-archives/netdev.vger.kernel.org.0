Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61F20362B16
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 00:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235750AbhDPWao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 18:30:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:49338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234312AbhDPWah (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 18:30:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 748E8613CE;
        Fri, 16 Apr 2021 22:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618612212;
        bh=/ZFluAh4rqszJcZKBHZd3eliwanLc/Z9s4037W/mDlk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EbBhUrVmb6UxJif8EntaZYHXqqgEZ044rLlCN7BhJCCju7MDapn4MEkiSruwh5HSq
         hPu/QhmO4EChlLzmAaaPxafsRy9OqtIs07nxLnc8t6yRMgreNqNNZvvFVhecpwF9kh
         ajL9TLS7uDkVCCygrwqbMNE9Jac3QQO1wOFrilePcYRkTMpwrieJFRhl40ybinYro4
         x8BK8Ra0mQCaVYbHYPomlgv2306UBHPI56oxgoCxNtUd8wndt0uPOAPYDtGKeA7yWw
         kAiE5MZ4FpK8uFnjKuQKdy+fzlsesqz27GE8Iv5p2iUWEV0s9wTttzg7gH7G0NYltE
         GXlAlUn3y8s6g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6C00960CD4;
        Fri, 16 Apr 2021 22:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v6] atl1c: move tx cleanup processing out of
 interrupt
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161861221243.19916.16927884200899111742.git-patchwork-notify@kernel.org>
Date:   Fri, 16 Apr 2021 22:30:12 +0000
References: <20210414190920.2516572-1-gatis@mikrotik.com>
In-Reply-To: <20210414190920.2516572-1-gatis@mikrotik.com>
To:     Gatis Peisenieks <gatis@mikrotik.com>
Cc:     chris.snook@gmail.com, davem@davemloft.net, kuba@kernel.org,
        hkallweit1@gmail.com, jesse.brandeburg@intel.com,
        dchickles@marvell.com, tully@mikrotik.com, eric.dumazet@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 14 Apr 2021 22:09:20 +0300 you wrote:
> Tx queue cleanup happens in interrupt handler on same core as rx queue
> processing. Both can take considerable amount of processing in high
> packet-per-second scenarios.
> 
> Sending big amounts of packets can stall the rx processing which is
> unfair and also can lead to out-of-memory condition since
> __dev_kfree_skb_irq queues the skbs for later kfree in softirq which
> is not allowed to happen with heavy load in interrupt handler.
> 
> [...]

Here is the summary with links:
  - [net-next,v6] atl1c: move tx cleanup processing out of interrupt
    https://git.kernel.org/netdev/net-next/c/a1150a04b7e8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


