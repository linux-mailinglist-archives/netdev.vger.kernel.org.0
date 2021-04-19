Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76715364DD3
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 00:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbhDSWuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 18:50:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:55258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229941AbhDSWuk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 18:50:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0E6A8613B0;
        Mon, 19 Apr 2021 22:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618872610;
        bh=Jk/LkQJ09g29F/PEPEPO6oOekEBT5G3dcIDdlVgIRYM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GKzM1p0gk38IlZhfzTbxo8EH09Sdvv4mTcp9aoj7OCN++VgSeob51+McOqjJcXs5R
         ER29Q+vQy2g1NfC+XvidlZys4SbPzZ0gVPxwd0UygpWZzqtE82YZwaCicjWwf8MnjF
         jY3A97WwbITy4Ye18td1Tk+NXVtxbbpM7BgjuBJb+ahKvX01HVX96Z8Hzkqj+LmaO3
         umYWEAiGxjwIVzpW0vOlIo42pYZVZT4I0XjByMTlcoSmtrXdrOq09pUADBTtbGzPen
         NFOhdXHS49274NihvGKs4D2QT+fRBIJoyq1OzrvJ21gecGWJEiAGxKjtw41SO91Nv3
         pILtaj4xWUl/w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0360260A2A;
        Mon, 19 Apr 2021 22:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] net: ethernet: mediatek: fix a typo bug in flow
 offloading
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161887261000.25363.1625251709846918967.git-patchwork-notify@kernel.org>
Date:   Mon, 19 Apr 2021 22:50:10 +0000
References: <20210417072905.207032-1-dqfext@gmail.com>
In-Reply-To: <20210417072905.207032-1-dqfext@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, kuba@kernel.org,
        matthias.bgg@gmail.com, pablo@netfilter.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        frank-w@public-files.de, d3adme4t@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 17 Apr 2021 15:29:04 +0800 you wrote:
> Issue was traffic problems after a while with increased ping times if
> flow offload is active. It turns out that key_offset with cookie is
> needed in rhashtable_params but was re-assigned to head_offset.
> Fix the assignment.
> 
> Fixes: 502e84e2382d ("net: ethernet: mtk_eth_soc: add flow offloading support")
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> 
> [...]

Here is the summary with links:
  - [v2,net-next] net: ethernet: mediatek: fix a typo bug in flow offloading
    https://git.kernel.org/netdev/net-next/c/6ecaf81d4ac6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


