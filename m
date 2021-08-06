Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64E7A3E283C
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 12:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244912AbhHFKKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 06:10:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:56262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244803AbhHFKKV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Aug 2021 06:10:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 856F960F38;
        Fri,  6 Aug 2021 10:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628244605;
        bh=3Pe8hwT2buE5kXzwoDdCANVVnBs/mAUECX7qj/9osBk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=W53LcKvO5efRagllpmALGbmuaKuLNq0Tvd8CmQlNp/12xn3f47r576EWeTpnC7ooe
         bM1L+bNX0wLPZ4k6WShu9D+8f3yg6E4N0hWal+O32/E5uyXJq5XUP8dPOF0S9jvF5R
         jRpPKKDIdo/inUAd1QG7piSB+//WmZMKwcpIsSipRQ9idKZMDhkYu1AWyQsSQA5oj1
         SiVsT8CWZwoVKk/hH/6N7bitM+J3Slz/6ELPqA0Et7Ot1FBS2dUc6wqZzHU2Av+s7S
         ZKXD/33KTpWPkjAMHdNG6wPZsF4+3zmsv75ibVtCQ5qQ8pNygdXgh5iJb0EgFg8OdD
         6z93SZ48Suyig==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 74B9960A7C;
        Fri,  6 Aug 2021 10:10:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net: ethernet: ti: am65-cpsw: use
 napi_complete_done() in TX completion
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162824460547.4294.14719198165397613138.git-patchwork-notify@kernel.org>
Date:   Fri, 06 Aug 2021 10:10:05 +0000
References: <20210805225532.2667-1-grygorii.strashko@ti.com>
In-Reply-To: <20210805225532.2667-1-grygorii.strashko@ti.com>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, vigneshr@ti.com, lokeshvutla@ti.com,
        edumazet@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 6 Aug 2021 01:55:30 +0300 you wrote:
> hi
> 
> The intention of this series is to fully enable hard irqs deferral feature
> (hrtimers based HW IRQ coalescing) from Eric Dumazet [1] for TI K3 CPSW driver
> by using napi_complete_done() in TX completion path, so the combination of
> parameters (/sys/class/net/ethX/):
>  napi_defer_hard_irqs
>  gro_flush_timeout
> can be used for hard irqs deferral.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: ti: am65-cpsw-nuss: fix RX IRQ state after .ndo_stop()
    https://git.kernel.org/netdev/net-next/c/47bfc4d128de
  - [net-next,2/2] net: ethernet: ti: am65-cpsw: use napi_complete_done() in TX completion
    https://git.kernel.org/netdev/net-next/c/3bacbe04251b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


