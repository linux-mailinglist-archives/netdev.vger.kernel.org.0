Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17201434C16
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 15:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbhJTNc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 09:32:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:41872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229977AbhJTNcY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 09:32:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9CC2261361;
        Wed, 20 Oct 2021 13:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634736610;
        bh=6I3JhA8kct0T7Sf/e1uYQ89v6jVxVnPog828pVq1ED0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=c4avvLs2rSalsFpmSKmdSBaqRxqgBM5BIxrKqqT0kKh1c44t0k1JlJN4MhU8SfXR/
         HPSgPQblA83SnofKc0ibeI1SnNikJKw63GjOtTixPN/ZFmVe9V4D4HpLYr7Jx3l7/S
         AqVXpgrZlIarVq4WgQETbOtxMmvyuepntD/rB7nfmIN2P/LpOp4rcxkQQLhv/jTIXg
         8VEbhFhYjrRG6rcUWhQw1at5ZFiIBPfqkKSLv5HpT2EWuJYSE2Q+O4nAEjpwAZ6dYz
         DmOlNCIH8nG3Yr0tkfe4BaA6NMVQtQkaBVlWeRmfF2xCnr7Acf0o9CtMCKRQKl4Il/
         0+Y2wCpnm1Kyw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8A544609F7;
        Wed, 20 Oct 2021 13:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2][net-next] soc: fsl: dpio: Unsigned compared against 0 in
 qbman_swp_set_irq_coalescing()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163473661056.3411.12683931306376167461.git-patchwork-notify@kernel.org>
Date:   Wed, 20 Oct 2021 13:30:10 +0000
References: <20211019121925.8910-1-tim.gardner@canonical.com>
In-Reply-To: <20211019121925.8910-1-tim.gardner@canonical.com>
To:     Tim Gardner <tim.gardner@canonical.com>
Cc:     netdev@vger.kernel.org, ioana.ciornei@nxp.com, Roy.Pledge@nxp.com,
        leoyang.li@nxp.com, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 19 Oct 2021 06:19:25 -0600 you wrote:
> Coverity complains of unsigned compare against 0. There are 2 cases in
> this function:
> 
> 1821        itp = (irq_holdoff * 1000) / p->desc->qman_256_cycles_per_ns;
> 
> CID 121131 (#1 of 1): Unsigned compared against 0 (NO_EFFECT)
> unsigned_compare: This less-than-zero comparison of an unsigned value is never true. itp < 0U.
> 1822        if (itp < 0 || itp > 4096) {
> 1823                max_holdoff = (p->desc->qman_256_cycles_per_ns * 4096) / 1000;
> 1824                pr_err("irq_holdoff must be between 0..%dus\n", max_holdoff);
> 1825                return -EINVAL;
> 1826        }
> 1827
>     	unsigned_compare: This less-than-zero comparison of an unsigned value is never true. irq_threshold < 0U.
> 1828        if (irq_threshold >= p->dqrr.dqrr_size || irq_threshold < 0) {
> 1829                pr_err("irq_threshold must be between 0..%d\n",
> 1830                       p->dqrr.dqrr_size - 1);
> 1831                return -EINVAL;
> 1832        }
> 
> [...]

Here is the summary with links:
  - [v2,net-next] soc: fsl: dpio: Unsigned compared against 0 in qbman_swp_set_irq_coalescing()
    https://git.kernel.org/netdev/net-next/c/818a76a55d6e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


