Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBE4E3FD82B
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 12:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243219AbhIAKvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 06:51:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:36656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236965AbhIAKvD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Sep 2021 06:51:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7BEFC6108E;
        Wed,  1 Sep 2021 10:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630493406;
        bh=bcdfFuDHza+I1hCefrESraZr73Ft42CEzx+fB6Vaa2I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HcX1GLSrMeQx9GNyW6/zFAKgx0B5JhPQh+lc+6FYOYEA0CCojHhhtX5UDNQP5oVmq
         zJLgXEwkGs0pT0k0T4vhgoKZWZCJbQ3+QkKse8b2rgtotW23SEvqypOTKCJ9iGSGlv
         Pm+x0mt9gpD6lq/uoNR9aYd9+XhKq1zd66Ijb1IhLsCjyq546X6TgOASXQrCK3xouN
         LtTMersLjGTwYi28OlzsCTrQQH02JgS0Hhb+GLUf98soXROByLVNR1QpPcyVeCmzFd
         NrGt6Hb7ooL5cEQmOHpQJPCwKVy/ucX4WS6pJlyauydxnPX/EQ5CLUvPBV3w04neGh
         3g5VrSkq6nKtQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6FCA9609D9;
        Wed,  1 Sep 2021 10:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH] octeontx2-pf: cn10K: Reserve LMTST lines per core
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163049340645.3899.4487369776492800860.git-patchwork-notify@kernel.org>
Date:   Wed, 01 Sep 2021 10:50:06 +0000
References: <20210901095550.10590-1-gakula@marvell.com>
In-Reply-To: <20210901095550.10590-1-gakula@marvell.com>
To:     Geetha sowjanya <gakula@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, sgoutham@marvell.com,
        sbhatta@marvell.com, hkelam@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 1 Sep 2021 15:25:50 +0530 you wrote:
> This patch reserves the LMTST lines per cpu instead
> of separate LMTST lines for NPA(buffer free) and NIX(sqe flush).
> LMTST line of the core on which SQ or RQ is processed is used
> for LMTST operation.
> 
> This patch also replace STEOR with STEORL release semantics and
> updates driver name in ethtool file.
> 
> [...]

Here is the summary with links:
  - [net-next] octeontx2-pf: cn10K: Reserve LMTST lines per core
    https://git.kernel.org/netdev/net/c/ef6c8da71eaf

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


