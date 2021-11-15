Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E89345057C
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 14:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231765AbhKONdZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 08:33:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:49168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231761AbhKONdE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 08:33:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 0FEEC63214;
        Mon, 15 Nov 2021 13:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636983009;
        bh=ujuXnMtMxUPFacK0XZ0Aet8M3mGZj0ppLwS46KXNsz4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nc7n1vVnqo/9tjYyVqzeEQrBWptCkBmTeSCLfUeDuxGFBinZPO9rdemgDppeoOQA4
         4XBDtTeKurNJk4lNQ1uVRUxpr6DDIDJn/4snxSGFD+qiGXX+bNYYB59CJS1RZDtpcG
         ckwbXAiCcugXWu/UIlI8UDUnNu3LOlVVtFa2h2i1m1cN8u2c8VQExLSaE7RRNzK/rH
         WfsOgMcrk0BKO3CdTTddQVdm2xsQyWf+1eEO5xI0SgrPnlxvXCZjky7FxLmXvkHfY2
         Bi023tzxQa0hLNk8uGOja4sgayop66lLeJCRfWPBPm/w24WXNgp+6yv/BuQC7dSS/y
         FOl8jFe97IQbQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F37C360A4E;
        Mon, 15 Nov 2021 13:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net/smc: Transfer remaining wait queue entries during
 fallback
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163698300899.26335.13329669260343577654.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Nov 2021 13:30:08 +0000
References: <1636788815-29902-1-git-send-email-guwen@linux.alibaba.com>
In-Reply-To: <1636788815-29902-1-git-send-email-guwen@linux.alibaba.com>
To:     Wen Gu <guwen@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, tonylu@linux.alibaba.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat, 13 Nov 2021 15:33:35 +0800 you wrote:
> The SMC fallback is incomplete currently. There may be some
> wait queue entries remaining in smc socket->wq, which should
> be removed to clcsocket->wq during the fallback.
> 
> For example, in nginx/wrk benchmark, this issue causes an
> all-zeros test result:
> 
> [...]

Here is the summary with links:
  - [net,v2] net/smc: Transfer remaining wait queue entries during fallback
    https://git.kernel.org/netdev/net/c/2153bd1e3d3d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


