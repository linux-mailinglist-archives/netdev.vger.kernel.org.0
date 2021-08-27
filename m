Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7AD3F9889
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 13:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245022AbhH0Lu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 07:50:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:40210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233448AbhH0Luy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Aug 2021 07:50:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 11C7160FDA;
        Fri, 27 Aug 2021 11:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630065006;
        bh=5ToR99mp4Ul+wpN3pmLe4H8JwUiJMJ2WLqc/rQRwXOM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mfts5/M7pifxmwuX2DLWDik1r2LtGf8fu3bam275xvaIBnZLOXOR3iZbxX7ciUaYY
         0sJbPyF1lcQwto6JGEzVnsTHmdboEUYGDOdw68EzFGdtHmW/RNuk6va8q9e0PaC5CJ
         Nz3Q7Kda0Q0SucOOQHpA6Ep1qJZ7pAFPV1y0dR0l+5cTd14RMYclz9cYZ0YlVJBAVj
         EIGEVWcfKjSjQA3txcguthgWVwwejUVh5pPOgTmBoK2daP+CfsSMOyk17/a5bYRf8i
         CSqkKzINn/ZZcSYM6Ljm83Y6rZb6I0x88mpT9RzdKXVU18wvQ5EF3iVex60qt/A7sQ
         NcQqVDkLU5NLg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 039DD60A27;
        Fri, 27 Aug 2021 11:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH] octeontx2-af: cn10K: support for sched lmtst and
 other features
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163006500600.12817.15249913126391353158.git-patchwork-notify@kernel.org>
Date:   Fri, 27 Aug 2021 11:50:06 +0000
References: <20210826123340.14507-1-gakula@marvell.com>
In-Reply-To: <20210826123340.14507-1-gakula@marvell.com>
To:     Geetha sowjanya <gakula@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, sgoutham@marvell.com,
        lcherian@marvell.com, jerinj@marvell.com, sbhatta@marvell.com,
        hkelam@marvell.com, hkalra@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 26 Aug 2021 18:03:40 +0530 you wrote:
> From: Harman Kalra <hkalra@marvell.com>
> 
> Enhancing the mailbox scope to support important configurations
> like enabling scheduled LMTST, disable LMTLINE prefetch, disable
> early completion for ordered LMTST, as per request from the
> application. On FLR these configurations will be reset to default.
> This patch also adds the 95XXO silicon version to octeontx2 silicon
> list.
> 
> [...]

Here is the summary with links:
  - [net-next] octeontx2-af: cn10K: support for sched lmtst and other features
    https://git.kernel.org/netdev/net-next/c/49d6baea7986

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


