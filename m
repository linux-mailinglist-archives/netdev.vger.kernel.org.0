Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFEB03425DB
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 20:10:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231187AbhCSTKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 15:10:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:41864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230379AbhCSTKJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Mar 2021 15:10:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 52A2561948;
        Fri, 19 Mar 2021 19:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616181009;
        bh=hECaZji+YHVFMSqbJyz60H3YD+HxKLOo7jPajo0LUXU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=k2NAzl9mD7ttvBYyyE9zNtQyorIj7rIf5vYsPHu00M/tsUUtrES34wLiX0UBZVREO
         SzQcFr2LI88DSDkSDvl5q3PNaIRPFhrPtjY2pwfvXapkgNf7GqSUmOpamw6Ho7/hDs
         ggIErIHECvSBSJMART7pPfjHgw1pZf+u0IfO9ioE2BuzdiG2uRh/pMndill5Nfq4GL
         MJszV8TeiBIA40xT1aDQlCHO4viKiGMxs+0bMIl8p0mo9FcwgbOqbq7gX107hOPbxQ
         QLaVrtFMBDmKbHPbTHSDAX20Lef9WQi7e+k1I+xXeG8Bw4WXufXpCceGwpO/2jnLwv
         rPdTUiu67Muhw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 434EA626ED;
        Fri, 19 Mar 2021 19:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] atl1c: use napi_alloc_skb
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161618100927.534.8273083622922077302.git-patchwork-notify@kernel.org>
Date:   Fri, 19 Mar 2021 19:10:09 +0000
References: <20210319041322.1001-1-liew.s.piaw@gmail.com>
In-Reply-To: <20210319041322.1001-1-liew.s.piaw@gmail.com>
To:     Sieng Piaw Liew <liew.s.piaw@gmail.com>
Cc:     chris.snook@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 19 Mar 2021 12:13:22 +0800 you wrote:
> Using napi_alloc_skb in NAPI context avoids enable/disable IRQs, which
> increases iperf3 result by a few Mbps. Since napi_alloc_skb() uses
> NET_IP_ALIGN, convert other alloc methods to the same padding. Tested
> on Intel Core2 and AMD K10 platforms.
> 
> Signed-off-by: Sieng Piaw Liew <liew.s.piaw@gmail.com>
> 
> [...]

Here is the summary with links:
  - atl1c: use napi_alloc_skb
    https://git.kernel.org/netdev/net-next/c/a9d6df642dc8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


