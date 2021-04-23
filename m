Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFFF5369BFA
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 23:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244085AbhDWVU4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 17:20:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:33592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244030AbhDWVUq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 17:20:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C676B61422;
        Fri, 23 Apr 2021 21:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619212809;
        bh=F9g+OBj8JKUTxWmYgI/5MPTs5T5Zky15ro76Gf0kWt4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Hrd8uulrzWSXdwhZvxcu8tziZVLdsRj7MXoMBZb2Pp/G0PGb+yLxbd2Gi7Xg43qQN
         Ia0fi0TUnRlbba/CYt8//ohzsu1Bpe3x4ND0yYz6hm9FAblb0uKYTSEJHgr70h2TC8
         LJR12LYU9o6Mbta+x5Qqgu5koA2wFG6OnHrFoGqSNbSmS+FWB6xJGrfLdC+5A2skGh
         S79G0G1b/PliQiCsXetxv7zA2xxW6oiAwZBjEeOuMHIUBFSQMKMPoImdaOFQ8Z+tlR
         XzJE4aTyh2wr/yGyDcJmfInBvzHlD60lECwZLOTsqmhJMy9uxa/4yEwBWaYTFv69Di
         CgTY42VSx9IrA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BAD4660C08;
        Fri, 23 Apr 2021 21:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 1/1] phy: nxp-c45-tja11xx: add interrupt support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161921280976.29384.4862066009521740132.git-patchwork-notify@kernel.org>
Date:   Fri, 23 Apr 2021 21:20:09 +0000
References: <20210423150050.1037224-1-radu-nicolae.pirea@oss.nxp.com>
In-Reply-To: <20210423150050.1037224-1-radu-nicolae.pirea@oss.nxp.com>
To:     Radu Pirea (NXP OSS) <radu-nicolae.pirea@oss.nxp.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 23 Apr 2021 18:00:50 +0300 you wrote:
> Added .config_intr and .handle_interrupt callbacks.
> 
> Link event interrupt will trigger an interrupt every time when the link
> goes up or down.
> 
> Signed-off-by: Radu Pirea (NXP OSS) <radu-nicolae.pirea@oss.nxp.com>
> 
> [...]

Here is the summary with links:
  - [v2,1/1] phy: nxp-c45-tja11xx: add interrupt support
    https://git.kernel.org/netdev/net-next/c/b2f0ca00e6b3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


